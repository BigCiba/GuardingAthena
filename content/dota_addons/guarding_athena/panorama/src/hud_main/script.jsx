import React, { useEffect, useState, useRef } from 'react';
import { render, useRegisterForUnhandledEvent } from 'react-panorama';
import classNames from 'classnames';
import { AbilityPanel } from '../elements/AbilityPanel';
import { AbilityUpgradeImage } from '../elements/AbilityUpgrade';
import './stats.js';

let CustomUIConfig = GameUI.CustomUIConfig();
let tSettings = CustomNetTables.GetTableValue("common", "settings");
CustomNetTables.SubscribeNetTableListener("common", () => {
	tSettings = CustomNetTables.GetTableValue("common", "settings");
});

// 单位技能栏
function AbilitiesContainer() {
	let refAbilities = useRef(null)

	function updateAbilityList() {
		let aAbilities = [];
		let iLocalPortraitUnit = Players.GetLocalPlayerPortraitUnit();

		$("#HUDContents").SetHasClass("HasAbilityToSpend", Entities.GetAbilityPoints(iLocalPortraitUnit) > 0);

		for (let i = 0; i < Entities.GetAbilityCount(iLocalPortraitUnit); i++) {
			let iAbilityEntIndex = Entities.GetAbility(iLocalPortraitUnit, i);

			if (iAbilityEntIndex == -1) continue;
			if (!Abilities.IsDisplayedAbility(iAbilityEntIndex)) continue;

			aAbilities.push({
				overrideentityindex: iAbilityEntIndex,
			});
		}

		return aAbilities;
	}

	const [abilities, setAbilities] = useState(() => {
		return updateAbilityList();
	});

	let update = () => {
		if (refAbilities.current) {
			for (let index = 0; index < refAbilities.current.GetChildCount(); index++) {
				const element = refAbilities.current.GetChild(index);
				if (element.update) {
					element.update(element);
				}
			}
		}
	}

	useEffect(() => {
		let func = () => {
			setAbilities(updateAbilityList());
		}
		const listeners = [
			GameEvents.Subscribe("dota_portrait_ability_layout_changed", func),
			GameEvents.Subscribe("dota_player_update_selected_unit", func),
			GameEvents.Subscribe("dota_player_update_query_unit", func),
			GameEvents.Subscribe("dota_ability_changed", func),
			GameEvents.Subscribe("dota_hero_ability_points_changed", func),
		]

		let iScheduleHandle;
		let think = () => {
			iScheduleHandle = $.Schedule(Game.GetGameFrameTime(), think)
			update();
		}
		think();

		return () => {
			listeners.forEach((listener) => {
				GameEvents.Unsubscribe(listener);
			});
			$.CancelScheduled(iScheduleHandle);
		}
	}, []);

	useEffect(() => {
		if (refAbilities.current) {
			let iAbilityCount = abilities.length;
			refAbilities.current.SetHasClass("FiveAbilities", iAbilityCount == 5);
			refAbilities.current.SetHasClass("SixAbilities", iAbilityCount == 6);
			refAbilities.current.SetHasClass("SevenAbilities", iAbilityCount == 7);
			refAbilities.current.SetHasClass("EightAbilities", iAbilityCount == 8);
			refAbilities.current.SetHasClass("NineAbilities", iAbilityCount == 9);
		}
	}, [abilities]);

	return (
		<Panel id="abilities" hittest={false} ref={refAbilities}>
			{abilities.map((tAbilityData, key) => {
				return <AbilityPanel key={key.toString()} {...tAbilityData} hittest={false} />;
			})}
		</Panel>
	)
}
render(<AbilitiesContainer />, $("#AbilitiesAndStatBranch"));

// 单位技能升级列表
function AbilityUpgradesContainer() {
	const [localPortraitUnit, setLocalPortraitUnit] = useState(Players.GetLocalPlayerPortraitUnit())

	let updateAbilityUpgradesList = () => {
		let t = CustomNetTables.GetTableValue("ability_upgrades_list", localPortraitUnit.toString());
		let aAbilityUpgradesList = [];
		if (t && typeof (t.json) == "string") {
			t.json = t.json.replace(/null/g, `"null"`);
			try {
				aAbilityUpgradesList = JSON.parse(t.json);
			} catch (error) { }
		}
		if (aAbilityUpgradesList.length > 0) {
			for (let index = 1; index < aAbilityUpgradesList.length; index++) {
				aAbilityUpgradesList[index] = upzip(aAbilityUpgradesList[0], aAbilityUpgradesList[index]);
			}
			aAbilityUpgradesList.splice(0, 1);
		}
		return aAbilityUpgradesList;
	}

	const [abilityUpgradesList, setAbilityUpgradesList] = useState(() => {
		return updateAbilityUpgradesList();
	});

	useEffect(() => {
		let func = () => {
			setLocalPortraitUnit(Players.GetLocalPlayerPortraitUnit());
		}
		const listeners = [
			GameEvents.Subscribe("dota_player_update_selected_unit", func),
			GameEvents.Subscribe("dota_player_update_query_unit", func),
		]

		return () => {
			listeners.forEach((listener) => {
				GameEvents.Unsubscribe(listener);
			});
		}
	}, [])

	useEffect(() => {
		setAbilityUpgradesList(updateAbilityUpgradesList());
		const listener = CustomNetTables.SubscribeNetTableListener("ability_upgrades_list", (_, tableKey, table) => {
			if (tableKey === localPortraitUnit.toString()) {
				setAbilityUpgradesList(updateAbilityUpgradesList());
			}
		});

		return () => {
			CustomNetTables.UnsubscribeNetTableListener(listener)
		};
	}, [localPortraitUnit])

	return (
		<Panel id="AbilityUpgradesContainer" require-composition-layer="true" always-cache-composition-layer="true" >
			{abilityUpgradesList.map((tData, key) => {
				return <Panel key={key.toString()} className={classNames("AbilityUpgrade", "AbilityUpgradesType" + (tData.type - 1))}>
					<AbilityUpgradeImage id="AbilityUpgradeImage" abilityData={tData} />
					<Label id="AbilityUpgradeNumber" text={(key + 1).toString()} />
				</Panel>
			})}
		</Panel>
	)
}
render(<AbilityUpgradesContainer />, $("#left_block"));

// 单位物品栏相关
{
	const DOTA_ITEM_SLOT_MIN = 0;
	const DOTA_ITEM_SLOT_MAX = 5;
	const DOTA_ITEM_BACKPACK_MIN = 6;
	const DOTA_ITEM_BACKPACK_MAX = 8;
	const DOTA_ITEM_STASH_MIN = 9;
	const DOTA_ITEM_STASH_MAX = 14;

	function InventorySlot({ overrideentityindex = -1, overridedisplaykeybind = -1, slot = -1, isBackpack = false, pInventoryContainer, ...other }) {
		const refSelf = useRef(null);

		let update = () => {
			let pSelf = refSelf.current;
			if (pSelf) {
				let pAbilityPanel = pSelf.FindChildTraverse("AbilityPanel");
				if (pAbilityPanel) {
					if (pAbilityPanel.update) {
						pAbilityPanel.update();
					}
					pAbilityPanel.RemoveClass("inactive_item")
				}

				pSelf.RemoveClass("IsUpgradable")
				pSelf.RemoveClass("IsAdvanced")
				pSelf.SwitchClass("ItemRarity", "");

				if (overrideentityindex != -1 && Entities.IsValidEntity(overrideentityindex)) {
					let iCasterIndex = Abilities.GetCaster(overrideentityindex)
					let sItemName = Abilities.GetAbilityName(overrideentityindex)
					if (Abilities.GetLevel(overrideentityindex) < Abilities.GetMaxLevel(overrideentityindex) && iCasterIndex && Items.CanBeSoldByLocalPlayer(overrideentityindex)) {
						let iGoldCost = GetItemUpgradedCost(sItemName) || 0
						let iGold = Players.GetGold(Players.GetLocalPlayer())

						pSelf.SetHasClass("IsUpgradable", iGold >= iGoldCost)
					}
					let sItemAdvancedName = GetItemAdvancedName(sItemName)
					if (Abilities.GetLevel(overrideentityindex) == Abilities.GetMaxLevel(overrideentityindex) && sItemAdvancedName && iCasterIndex && Items.CanBeSoldByLocalPlayer(overrideentityindex)) {
						let iGoldCost = GetItemAdvancedCost(sItemName) || 0
						let iGold = Players.GetGold(Players.GetLocalPlayer())

						pSelf.SetHasClass("IsAdvanced", iGold >= iGoldCost)
					}

					let iRarity = GetItemRarity(sItemName);
					if (iRarity != undefined && iRarity != null && iRarity >= 0) {
						pSelf.SwitchClass("ItemRarity", "Rarity" + iRarity);
					}

					if (isBackpack) {
						if (pAbilityPanel) {
							pAbilityPanel.AddClass("inactive_item");
						}
					}
				}
			}
		}

		useEffect(() => {
			let pSelf = refSelf.current;
			if (pSelf) {
				pSelf.update = update;
			}
			update();
		}, [overrideentityindex, overridedisplaykeybind, slot, pInventoryContainer]);

		// 拖拽相关
		useRegisterForUnhandledEvent("DragStart", (pPanel, tDragCallbacks) => {
			let pSelf = refSelf.current;
			if (pSelf && pPanel == pSelf) {
				let pAbilityPanel = pPanel.FindChildTraverse("AbilityPanel");
				if (!pAbilityPanel || pAbilityPanel.BHasClass("no_ability")) {
					return true;
				}

				CustomUIConfig.HideAbilityTooltiop(pPanel);

				let iItemIndex = overrideentityindex
				if (iItemIndex != -1) {
					let pDisplayPanel = $.CreatePanel("DOTAItemImage", $.GetContextPanel(), "dragImage");
					pDisplayPanel.itemindex = iItemIndex;
					pDisplayPanel.itemname = Abilities.GetAbilityName(iItemIndex);
					pDisplayPanel.m_pPanel = pPanel;
					pDisplayPanel.m_DragCompleted = false;
					pDisplayPanel.m_DragType = "InventorySlot";

					tDragCallbacks.displayPanel = pDisplayPanel;
					tDragCallbacks.offsetX = 0;
					tDragCallbacks.offsetY = 0;

					pAbilityPanel.AddClass("dragging_from");
					pPanel.AddClass("dragging_from");

					if (pInventoryContainer) {
						let iRarity = GetItemRarity(pDisplayPanel.itemname);
						if (iRarity != undefined && iRarity != null && iRarity >= 0) {
							pInventoryContainer.SwitchClass("DragRarity", "DragRarity" + iRarity);
						}
					}
				}

				return true;
			}
		}, [overrideentityindex, overridedisplaykeybind, slot, pInventoryContainer])
		useRegisterForUnhandledEvent("DragLeave", (pPanel, pDraggedPanel) => {
			let pSelf = refSelf.current;
			if (pSelf && pPanel == pSelf) {
				if (pDraggedPanel.m_pPanel == undefined || pDraggedPanel.m_pPanel == null) {
					return false;
				}
				if (pDraggedPanel.m_DragType != "InventorySlot") {
					return false;
				}
				if (pDraggedPanel.m_pPanel == pPanel) {
					return false;
				}

				let pAbilityPanel = pPanel.FindChildTraverse("AbilityPanel");
				if (pAbilityPanel) {
					pAbilityPanel.RemoveClass("potential_drop_target");
				}
				return true;
			}
			return false;
		}, [overrideentityindex, overridedisplaykeybind, slot, pInventoryContainer])
		useRegisterForUnhandledEvent("DragEnter", (pPanel, pDraggedPanel) => {
			let pSelf = refSelf.current;
			if (pSelf && pPanel == pSelf) {
				if (pDraggedPanel.m_pPanel == undefined || pDraggedPanel.m_pPanel == null) {
					return true;
				}
				if (pDraggedPanel.m_DragType != "InventorySlot") {
					return true;
				}
				if (pDraggedPanel.m_pPanel == pPanel) {
					return true;
				}

				let pAbilityPanel = pPanel.FindChildTraverse("AbilityPanel");
				if (pAbilityPanel) {
					pAbilityPanel.AddClass("potential_drop_target");
				}

				return true;
			}
			return false;
		}, [overrideentityindex, overridedisplaykeybind, slot, pInventoryContainer])
		useRegisterForUnhandledEvent("DragDrop", (pPanel, pDraggedPanel) => {
			let pSelf = refSelf.current;
			if (pSelf && pPanel == pSelf) {
				if (pDraggedPanel.m_pPanel == undefined || pDraggedPanel.m_pPanel == null) {
					return true;
				}
				if (pDraggedPanel.m_DragType != "InventorySlot") {
					return true;
				}
				if (pDraggedPanel.m_pPanel == pSelf) {
					pDraggedPanel.m_DragCompleted = true;
					return true;
				}
				let iItemIndex = pDraggedPanel.itemindex;
				if (iItemIndex != -1) {
					let iCasterIndex = Abilities.GetCaster(iItemIndex)
					Game.PrepareUnitOrders({
						UnitIndex: iCasterIndex,
						OrderType: dotaunitorder_t.DOTA_UNIT_ORDER_MOVE_ITEM,
						TargetIndex: slot,
						AbilityIndex: iItemIndex
					});
					pDraggedPanel.m_DragCompleted = true;
				}

				return true;
			}
			return false;
		}, [overrideentityindex, overridedisplaykeybind, slot, pInventoryContainer])
		useRegisterForUnhandledEvent("DragEnd", (pPanel, pDraggedPanel) => {
			let pSelf = refSelf.current;
			if (pSelf && pPanel == pSelf) {
				let pAbilityPanel = pPanel.FindChildTraverse("AbilityPanel");
				if (pDraggedPanel.m_DragCompleted == false) {
					let iItemIndex = pDraggedPanel.itemindex;
					if (iItemIndex != -1) {
						let iCasterIndex = Abilities.GetCaster(iItemIndex)
						Game.DropItemAtCursor(iCasterIndex, iItemIndex);
					}
				}
				pDraggedPanel.DeleteAsync(-1);

				pPanel.RemoveClass("dragging_from");
				if (pAbilityPanel) {
					pAbilityPanel.RemoveClass("dragging_from");
				}
				if (pInventoryContainer) {
					pInventoryContainer.SwitchClass("DragRarity", "");
				}
			}
		}, [overrideentityindex, overridedisplaykeybind, slot, pInventoryContainer]);

		return (
			<Panel className="inventory_slot" {...other} ref={refSelf} draggable={true} hittest={true} onactivate={(self) => {
				if (overrideentityindex != -1 && Entities.IsValidEntity(overrideentityindex)) {
					if (GameUI.IsAltDown()) {
						Abilities.PingAbility(overrideentityindex);
						return;
					}
					if (GameUI.IsControlDown()) {
						Abilities.AttemptToUpgrade(overrideentityindex);
						return;
					}
					let iCasterIndex = Abilities.GetCaster(overrideentityindex);
					Abilities.ExecuteAbility(overrideentityindex, iCasterIndex, false);
				}
			}} oncontextmenu={(self) => {
				if (overrideentityindex != -1 && Entities.IsValidEntity(overrideentityindex)) {
					let iCasterIndex = Abilities.GetCaster(overrideentityindex)
					let sItemName = Abilities.GetAbilityName(overrideentityindex)
					let bSlotInStash = slot >= DOTA_ITEM_STASH_MIN;
					let bControllable = Entities.IsControllableByPlayer(iCasterIndex, Game.GetLocalPlayerID());
					let bSellable = Items.IsSellable(overrideentityindex) && Items.CanBeSoldByLocalPlayer(overrideentityindex);
					let bDisassemble = Items.IsDisassemblable(overrideentityindex) && bControllable && !bSlotInStash;
					let bAlertable = Items.IsAlertableItem(overrideentityindex);
					let bUpgradable = Abilities.GetLevel(overrideentityindex) < Abilities.GetMaxLevel(overrideentityindex) && Items.CanBeSoldByLocalPlayer(overrideentityindex);
					let bAdvanced = Abilities.GetLevel(overrideentityindex) == Abilities.GetMaxLevel(overrideentityindex) && GetItemAdvancedName(sItemName) != undefined && GetItemAdvancedName(sItemName) != null && Items.CanBeSoldByLocalPlayer(overrideentityindex);
					// let bShowInShop = Items.IsPurchasable(overrideentityindex);
					let bShowInShop = false;
					// let bMoveToStash = !bSlotInStash && bControllable;
					// let bDropFromStash = bSlotInStash && bControllable;
					let bMoveToStash = false;
					let bDropFromStash = false;

					if (!bSellable && !bDisassemble && !bShowInShop && !bDropFromStash && !bAlertable && !bMoveToStash && !bUpgradable && !bAdvanced) {
						return;
					}
					let pContextMenu = $.CreatePanel("ContextMenuScript", self, "");
					pContextMenu.AddClass("ContextMenu_NoArrow");
					pContextMenu.AddClass("ContextMenu_NoBorder");

					let pContentsPanel = pContextMenu.GetContentsPanel()
					pContentsPanel.BLoadLayout("file://{resources}/layout/custom_game/context_menu/context_menu_inventory_item/context_menu_inventory_item.xml", false, false);
					pContentsPanel.SetItem(overrideentityindex);
					pContentsPanel.SetHasClass("bSellable", bSellable);
					pContentsPanel.SetHasClass("bDisassemble", bDisassemble);
					pContentsPanel.SetHasClass("bShowInShop", bShowInShop);
					pContentsPanel.SetHasClass("bDropFromStash", bDropFromStash);
					pContentsPanel.SetHasClass("bAlertable", bAlertable);
					pContentsPanel.SetHasClass("bMoveToStash", bMoveToStash);
					pContentsPanel.SetHasClass("bUpgradable", bUpgradable);
					pContentsPanel.SetHasClass("bAdvanced", bAdvanced);
					pContentsPanel.pTargetPanel = self
				}
			}} onmouseover={(self) => {
				if (overrideentityindex != -1 && Entities.IsValidEntity(overrideentityindex)) {
					CustomUIConfig.ShowAbilityTooltiop(self, Abilities.GetAbilityName(overrideentityindex), Abilities.GetCaster(overrideentityindex), slot);
				}
			}} onmouseout={(self) => {
				CustomUIConfig.HideAbilityTooltiop(self);
			}} >
				<AbilityPanel id="AbilityPanel" hittestchildren={false} hittest={false} className={classNames("InventoryItem", { "BackpackSlot": isBackpack })} overrideentityindex={overrideentityindex} overridedisplaykeybind={overridedisplaykeybind} slot={slot} />
				<Panel id="ItemUpgradeIcon" hittest={false} />
				<Panel id="ItemAdvanceIcon" hittest={false} />
			</Panel>
		)
	}
	function InventoryItems() {
		const refInventoryList = useRef(null);
		const refInventoryList2 = useRef(null);
		const refBackpackList = useRef(null);
		const refInventoryBG = useRef(null);

		const [pInventoryContainer, setInventoryContainer] = useState(null);

		function updateSlots() {
			let aSlots = [];
			let iLocalPortraitUnit = Players.GetLocalPlayerPortraitUnit();

			for (let index = DOTA_ITEM_SLOT_MIN; index <= DOTA_ITEM_SLOT_MAX; index++) {
				let iItemIndex = Entities.GetItemInSlot(iLocalPortraitUnit, index);

				aSlots.push({
					overrideentityindex: iItemIndex,
					slot: index,
				});
			}

			return aSlots;
		}

		function updateBackpacks() {
			let aBackpacks = [];
			let iLocalPortraitUnit = Players.GetLocalPlayerPortraitUnit();

			for (let index = DOTA_ITEM_BACKPACK_MIN; index <= DOTA_ITEM_BACKPACK_MAX; index++) {
				let iItemIndex = Entities.GetItemInSlot(iLocalPortraitUnit, index);

				aBackpacks.push({
					overrideentityindex: iItemIndex,
					slot: index,
				});
			}

			return aBackpacks;
		}

		const [slots, setSlots] = useState(() => {
			return updateSlots();
		});

		const [backpacks, setBackpacks] = useState(() => {
			return updateBackpacks();
		});

		let updateChildren = ref => {
			if (ref.current) {
				for (let index = 0; index < ref.current.GetChildCount(); index++) {
					const element = ref.current.GetChild(index);
					if (element.update) {
						element.update(element);
					}
				}
			}
		}

		let update = () => {
			updateChildren(refInventoryList);
			updateChildren(refInventoryList2);
		}

		useEffect(() => {
			let func = () => {
				setSlots(updateSlots());
				setBackpacks(updateBackpacks());
			}
			const listeners = [
				GameEvents.Subscribe("dota_inventory_changed", func),
				GameEvents.Subscribe("dota_inventory_item_changed", func),
				GameEvents.Subscribe("m_event_dota_inventory_changed_query_unit", func),
				GameEvents.Subscribe("m_event_keybind_changed", func),
				GameEvents.Subscribe("dota_player_update_selected_unit", func),
				GameEvents.Subscribe("dota_player_update_query_unit", func),
			]

			let iScheduleHandle;
			let think = () => {
				iScheduleHandle = $.Schedule(Game.GetGameFrameTime(), think)
				update();
			}
			think();

			return () => {
				listeners.forEach((listener) => {
					GameEvents.Unsubscribe(listener);
				});
				$.CancelScheduled(iScheduleHandle);
			}
		}, []);

		useRegisterForUnhandledEvent("DragDrop", (pPanel, pDraggedPanel) => {
			if (pInventoryContainer && pPanel == pInventoryContainer) {
				if (pDraggedPanel.m_pPanel == undefined || pDraggedPanel.m_pPanel == null) {
					return true;
				}
				if (pDraggedPanel.m_DragType != "InventorySlot") {
					return true;
				}
				pDraggedPanel.m_DragCompleted = true;
				return true;
			}
			return false;
		}, [pInventoryContainer])

		return (
			<Panel id="inventory_items" hittest={false} require-composition-layer="true" always-cache-composition-layer="true" >
				<Panel id="InventoryContainer" ref={setInventoryContainer} draggable={true} >
					<Panel id="InventoryBG" className="InventoryBackground" hittest={false} />
					<Panel id="HUDSkinInventoryBG" className="InventoryBackground" hittest={false} />
					<Panel id="inventory_list_container" hittest={false} >
						<Panel id="inventory_list" className="inventory_list" hittest={false} ref={refInventoryList} >
							{[...Array(3).keys()].map((key) => {
								return <InventorySlot key={key.toString()} id={"inventory_slot_" + key} {...slots[key]} pInventoryContainer={pInventoryContainer} />
							})}
						</Panel>
						<Panel id="inventory_list2" className="inventory_list" hittest={false} ref={refInventoryList2} >
							{[...Array(3).keys()].map((key) => {
								return <InventorySlot key={key.toString()} id={"inventory_slot_" + key + 3} {...slots[key + 3]} pInventoryContainer={pInventoryContainer} />
							})}
						</Panel>
					</Panel>
					<Panel id="inventory_backpack_list" hittest={false} ref={refBackpackList} >
						{backpacks.map((t, key) => {
							return <InventorySlot key={key.toString()} id={"inventory_slot_" + (key + DOTA_ITEM_BACKPACK_MIN)} {...t} isBackpack={true} pInventoryContainer={pInventoryContainer} />
						})}
					</Panel>
				</Panel>
			</Panel>
		)
	}
	render(<InventoryItems />, $("#inventory"));
}

// 经验
{
	function XPCustom() {
		let pXP = $("#xp");
		pXP.FindChildTraverse("LevelBackground").style.opacity = "0";
		pXP.FindChildTraverse("LevelLabel").style.opacity = "0";
		pXP.FindChildTraverse("XPProgress").style.opacity = "0";

		const refXPCustom = useRef(null);

		let update = () => {
			if (refXPCustom.current != null) {
				let iLocalPortraitUnit = Players.GetLocalPlayerPortraitUnit();
				let pXPCustom = refXPCustom.current
				pXPCustom.SetHasClass("ShowLifetimeBar", pXP.BHasClass("ShowLifetimeBar"));
				pXPCustom.SetHasClass("ShowLevel", pXP.BHasClass("ShowLevel"));

				pXPCustom.SetHasClass("AltPressed", GameUI.IsAltDown());

				let tBuildingData = CustomNetTables.GetTableValue("buildings", iLocalPortraitUnit.toString());
				let iLevel = 0;
				let fXPPercent = 0;
				let iNeedXP = 0;
				let iLevelXP = 0;
				let iLevelNeedXP = 0;
				if (tBuildingData != undefined && tBuildingData != null) {
					pXPCustom.AddClass("ShowXPBar")

					iLevel = tBuildingData.iLevel;

					let iXP = tBuildingData.iCurrentXP || 0;
					iNeedXP = tBuildingData.iNeededXPToLevel || 0;
					let BUILDING_XP_PER_LEVEL_TABLE = tSettings.BUILDING_XP_PER_LEVEL_TABLE || {};
					iLevelXP = (iXP - (BUILDING_XP_PER_LEVEL_TABLE[String(iLevel)] || 0));
					iLevelNeedXP = (iNeedXP - (BUILDING_XP_PER_LEVEL_TABLE[String(iLevel)] || 0));
				} else {
					pXPCustom.AddClass("ShowXPBar");

					iLevel = Entities.GetLevel(iLocalPortraitUnit);

					if (Entities.IsHero(iLocalPortraitUnit)) {
						let iXP = Entities.GetCurrentXP(iLocalPortraitUnit);
						iNeedXP = Entities.GetNeededXPToLevel(iLocalPortraitUnit);
						let HERO_XP_PER_LEVEL_TABLE = tSettings.HERO_XP_PER_LEVEL_TABLE || {};
						iLevelXP = (iXP - (HERO_XP_PER_LEVEL_TABLE[String(iLevel)] || 0));
						iLevelNeedXP = (iNeedXP - (HERO_XP_PER_LEVEL_TABLE[String(iLevel)] || 0));
					}
				}
				if (iNeedXP == 0) {
					fXPPercent = 1;
				} else {
					fXPPercent = iLevelXP / iLevelNeedXP;
				}
				pXPCustom.SetHasClass("ShowXPLabel", Float(fXPPercent) != 1);
				pXPCustom.SetDialogVariableInt("level", iLevel)
				pXPCustom.SetDialogVariableInt("current_xp", iLevelXP);
				pXPCustom.SetDialogVariableInt("xp_to_level", iLevelNeedXP);
				let pCircularXPProgress = pXPCustom.FindChildTraverse("CircularXPProgress")
				if (pCircularXPProgress && pCircularXPProgress.value != fXPPercent) {
					pCircularXPProgress.value = fXPPercent;
				}
				let pCircularXPProgressBlur = pXPCustom.FindChildTraverse("CircularXPProgressBlur")
				if (pCircularXPProgressBlur && pCircularXPProgressBlur.value != fXPPercent) {
					pCircularXPProgressBlur.value = fXPPercent;
				}
			}
		}

		useEffect(() => {
			let iScheduleHandle;
			let think = () => {
				iScheduleHandle = $.Schedule(Game.GetGameFrameTime(), think)
				update();
			}
			think();

			return () => {
				$.CancelScheduled(iScheduleHandle);
			}
		}, [])

		return (
			<Panel id="xp_custom" hittest={false} ref={refXPCustom} >
				<Panel id="LevelBackground" /*onactivate="DOTAHUDXPBarClicked();"*/ />
				<Label id="LevelLabel" className="MonoNumbersFont" localizedText="{d:level}" hittest={false} />
				<CircularProgressBar id="CircularXPProgress" /*onactivate="DOTAHUDXPBarClicked();"*/ />
				<CircularProgressBar id="CircularXPProgressBlur" hittest={false} />
				<ProgressBar id="XPProgress" /*onactivate="DOTAHUDXPBarClicked();"*/>
					<Label id="XPLabel" localizedText="#DOTA_Hud_XP" hittest={false} />
				</ProgressBar>
			</Panel>
		)
	}
	render(<XPCustom />, $("#center_block"));
}

(() => {
	let Hud = $.GetContextPanel();
	while (Hud.id != "Hud") {
		Hud = Hud.GetParent();
	}
	let minimap_container = Hud.FindChildTraverse("minimap_container");
	if (minimap_container) {
		minimap_container.style.opacity = "0";
	}

	let iLocalPortraitUnit = Players.GetLocalPlayerPortraitUnit()
	let iLastGold = Players.GetGold(Entities.GetPlayerOwnerID(iLocalPortraitUnit));
	let iLastLocalPortraitUnit = iLocalPortraitUnit
	let fPrepTimeEnd = -1;
	let fTimedRoundDurationEnd = -1;
	let fTimedRoundPostGameEnd = -1;

	let pRounds = $("#Rounds");

	let tHitBoundsParticles = {};
	let tHitBounds = {};

	function Think() {
		$.Schedule(Game.GetGameFrameTime(), Think)

		let tLocalPlayerInfo = Game.GetLocalPlayerInfo()
		let iLocalPortraitUnit = Players.GetLocalPlayerPortraitUnit()
		let bAltPressed = GameUI.IsAltDown()

		$.GetContextPanel().SetHasClass("AltPressed", bAltPressed);

		// 怪物伤害基地区域显示
		{
			if (bAltPressed) {
				for (const sTeamNumber in tHitBounds) {
					if (tHitBoundsParticles[sTeamNumber]) continue;

					let tBounds = tHitBounds[sTeamNumber]

					let iParticleID = Particles.CreateParticle("particles/ui_mouseactions/bounding_area_view.vpcf", ParticleAttachment_t.PATTACH_WORLDORIGIN, -1);
					Particles.SetParticleControl(iParticleID, 0, [tBounds.MinX, tBounds.MinY, 128])
					Particles.SetParticleControl(iParticleID, 1, [tBounds.MinX, tBounds.MaxY, 128])
					Particles.SetParticleControl(iParticleID, 2, [tBounds.MaxX, tBounds.MaxY, 128])
					Particles.SetParticleControl(iParticleID, 3, [tBounds.MaxX, tBounds.MinY, 128])
					Particles.SetParticleControl(iParticleID, 15, [0, 255, 255])
					Particles.SetParticleControl(iParticleID, 16, [1, 0, 0])

					tHitBoundsParticles[sTeamNumber] = iParticleID;
				}
			} else {
				for (const sTeamNumber in tHitBoundsParticles) {
					let iParticleID = tHitBoundsParticles[sTeamNumber]
					Particles.DestroyParticleEffect(iParticleID, false)
				}
				tHitBoundsParticles = {}
			}
		}

		// 金钱跳动特效
		{
			let iGold = Players.GetGold(Entities.GetPlayerOwnerID(iLocalPortraitUnit))
			$("#GoldButton").SetDialogVariableInt("gold", iGold == -1 ? 0 : iGold)
			if (iLastGold != iGold && iLocalPortraitUnit == iLastLocalPortraitUnit && typeof (CustomUIConfig.FireChangeGold) == "function") CustomUIConfig.FireChangeGold($("#GoldLabel"), iGold - iLastGold);
			iLastGold = iGold;
			iLastLocalPortraitUnit = iLocalPortraitUnit;
		}

		// 回合
		// {
		// 	if (fPrepTimeEnd != -1) {
		// 		let fTime = Math.max(fPrepTimeEnd - Game.GetGameTime(), 0);
		// 		pRounds.SetDialogVariableInt("round_time", fTime);
		// 	} else if (fTimedRoundDurationEnd != -1) {
		// 		let fTime = fTimedRoundDurationEnd - Game.GetGameTime();
		// 		if (fTime < 1) {
		// 			fTime = Math.max(fTimedRoundPostGameEnd - Game.GetGameTime(), 0);
		// 		}
		// 		pRounds.SetDialogVariableInt("round_time", fTime);
		// 	} else {
		// 		pRounds.SetDialogVariableInt("round_time", 0);
		// 	}
		// }
	}

	Think()

	function UpdateCommonNetTable(tableName, tableKeyName, table) {
		let iLocalPlayerID = Players.GetLocalPlayer();
		if (tableKeyName == "round_data") {
			pRounds.SetDialogVariableInt("round_number", table.round_number || 0);
			fPrepTimeEnd = table.prep_time_end || -1;
			fTimedRoundDurationEnd = table.timed_round_duration_end || -1;
			fTimedRoundPostGameEnd = table.timed_round_post_game_end || -1;

			let iEnemiesTotal = table.enemies_total || 0;
			let tEnemiesKilled = table.enemies_killed || {};
			let iEnemiesKilled = tEnemiesKilled[Players.GetTeam(iLocalPlayerID)] || 0;
			pRounds.SetDialogVariableInt("round_killed", iEnemiesKilled);
			pRounds.SetDialogVariableInt("round_total", iEnemiesTotal);

			let pRoundProgressBar = pRounds.FindChildTraverse("RoundProgressBar")
			if (pRoundProgressBar) {
				pRoundProgressBar.value = (iEnemiesKilled / iEnemiesTotal) || 0;
			}
		}
		if (tableKeyName == "enemy_hit_trigger_bounds") {
			tHitBounds = table || {};
		}
	}

	// CustomNetTables.SubscribeNetTableListener("common", UpdateCommonNetTable);
	// UpdateCommonNetTable("common", "round_data", CustomNetTables.GetTableValue("common", "round_data"));
	// UpdateCommonNetTable("common", "enemy_hit_trigger_bounds", CustomNetTables.GetTableValue("common", "enemy_hit_trigger_bounds"));

	// 掉落物品显示等级
	let pDroppedItemPanel = $("#DroppedItemPanel")
	let bCheck = true
	$.RegisterForUnhandledEvent("DOTAShowDroppedItemTooltip", (a, x, y, sAbilityName, e, f) => {
		if (bCheck) {
			pDroppedItemPanel.SetPositionInPixels(x, y, 0)
			let iPhysicalItemIndex = CustomUIConfig.GetCursorPhysicalItem()
			if (Entities.IsItemPhysical(iPhysicalItemIndex)) {
				let iItemIndex = Entities.GetContainedItem(iPhysicalItemIndex)
				// WHY???
				iItemIndex &= ~0xFFFFC000
				$.Schedule(0, () => {
					bCheck = false
					CustomUIConfig.ShowAbilityTooltiop(pDroppedItemPanel, sAbilityName, -1, -1, Abilities.GetLevel(iItemIndex));
					$.Msg(Abilities.GetLevel(iItemIndex));
					bCheck = true
				})
			}
		}
	})
	$.RegisterForUnhandledEvent("DOTAHideDroppedItemTooltip", () => {
		CustomUIConfig.HideAbilityTooltiop(pDroppedItemPanel);
	})
})();

// 镜头
(() => {
	let pOverlayMap = $("#OverlayMap")
	const MIN_CAMERA_DISTANCE = 1300
	const MAX_CAMERA_DISTANCE = 3500

	/* env_fog_controller实体里的Far Z Clip Plane需要适应调整
		其值设置为[距离/cos(角度)]会出现的最大值
	*/
	const CAMERA_START_PITCH_DISTANCE = 3000
	const CAMERA_END_PITCH_DISTANCE = 3500
	const CAMERA_MIN_PITCH = 60
	const CAMERA_MAX_PITCH = 90
	const OVERLAY_MAP_SCALE = 6

	const MAX_LOOK_SCREEN = 1 / 5
	const START_OFFSET_SCREEN = 1 / 4
	const END_OFFSET_SCREEN = 1 / 3

	let fCameraDistance = 1300
	let fSmoothCameraDistance = 1300
	let vCameraTargetPosition = [0, 0, 0]
	let vSmoothCameraTargetPosition = [0, 0, 0]
	let vLastCameraTargetPosition = [0, 0, 0]

	function SetDistance(fPercent = 0) {
		fCameraDistance = RemapValClamped(fPercent, 0, 1, MIN_CAMERA_DISTANCE, MAX_CAMERA_DISTANCE)
	}
	function Think() {
		$.Schedule(Game.GetGameFrameTime(), Think)

		let fScreenWidth = Game.GetScreenWidth()
		let fScreenHeight = Game.GetScreenHeight()
		let fStartScreenDistance = fScreenHeight * START_OFFSET_SCREEN
		let fEndScreenDistance = fScreenHeight * END_OFFSET_SCREEN
		let fMaxLookDistance = fScreenHeight * MAX_LOOK_SCREEN
		let fFrameTime = Game.GetGameFrameTime();

		let localCamFollowIndex = (Players.GetSelectedEntities(Players.GetLocalPlayer()) || [])[0] || -1;

		if (Players.IsLocalPlayerInPerspectiveCamera()) {
			localCamFollowIndex = Players.GetPerspectivePlayerEntityIndex()
		}

		if (false && localCamFollowIndex !== -1) {
			if (Entities.IsAlive(localCamFollowIndex) === false)
				return

			let fOffset = 0;
			vCameraTargetPosition = Entities.GetAbsOrigin(localCamFollowIndex)
			if (true) {
				if (vSmoothCameraTargetPosition[0] == 0 && vSmoothCameraTargetPosition[1] == 0 && vSmoothCameraTargetPosition[2] == 0) {
					vSmoothCameraTargetPosition = vCameraTargetPosition
				} else {
					fOffset = Game.Length2D(vCameraTargetPosition, vLastCameraTargetPosition)
				}

				let vCursorPos = GameUI.GetCursorPosition()

				let fCursorX = vCursorPos[0] - fScreenWidth / 2
				let fCursorY = vCursorPos[1] - fScreenHeight / 2
				let fCursorToCenterDistance = Math.sqrt(Math.pow(fCursorX, 2) + Math.pow(fCursorY, 2))

				let fPercent = RemapValClamped(fCursorToCenterDistance, fStartScreenDistance, fEndScreenDistance, 0, 1)

				let vScreenWorldPos = GameUI.GetScreenWorldPosition(vCursorPos)
				if (vScreenWorldPos !== null) {
					let vToCursor = []
					vToCursor[0] = vScreenWorldPos[0] - vCameraTargetPosition[0]
					vToCursor[1] = vScreenWorldPos[1] - vCameraTargetPosition[1]
					vToCursor[2] = vScreenWorldPos[2] - vCameraTargetPosition[2]
					vToCursor = Game.Normalized(vToCursor)
					let flDistance = fMaxLookDistance * fPercent
					vCameraTargetPosition[0] = vCameraTargetPosition[0] + vToCursor[0] * flDistance
					vCameraTargetPosition[1] = vCameraTargetPosition[1] + vToCursor[1] * flDistance
					vCameraTargetPosition[2] = vCameraTargetPosition[2] + vToCursor[2] * flDistance
				}

				let minStep = RemapValClamped(fOffset, fStartScreenDistance * fFrameTime, fEndScreenDistance * fFrameTime, 0.125, 0.3125)
				let delta = Game.Length2D(vCameraTargetPosition, vSmoothCameraTargetPosition)
				if (Math.abs(delta) < minStep) {
					vSmoothCameraTargetPosition = vCameraTargetPosition
				}
				else {
					let step = delta * (RemapValClamped(fOffset / fFrameTime, 0, fScreenHeight, 1, 3) * fFrameTime)
					if (fFrameTime == 0) step = 0;
					if (Math.abs(step) < minStep) {
						if (delta > 0)
							step = minStep
						else
							step = -minStep
					}
					let vToCursor = []
					vToCursor[0] = vCameraTargetPosition[0] - vSmoothCameraTargetPosition[0]
					vToCursor[1] = vCameraTargetPosition[1] - vSmoothCameraTargetPosition[1]
					vToCursor[2] = vCameraTargetPosition[2] - vSmoothCameraTargetPosition[2]
					vToCursor = Game.Normalized(vToCursor)
					vSmoothCameraTargetPosition[0] += vToCursor[0] * step
					vSmoothCameraTargetPosition[1] += vToCursor[1] * step
					vSmoothCameraTargetPosition[2] += vToCursor[2] * step
				}
			}
			else {
				vSmoothCameraTargetPosition = vCameraTargetPosition
			}

			GameUI.SetCameraTargetPosition(vSmoothCameraTargetPosition, -1)

			// GameUI.SetCameraTargetPosition(vCameraTargetPosition, RemapValClamped(fOffset, 0, fMaxLookDistance*fFrameTime, 0.125, 0.0625))

			vLastCameraTargetPosition = Entities.GetAbsOrigin(localCamFollowIndex)
		}

		let minStep = 1
		let delta = (fCameraDistance - fSmoothCameraDistance)
		if (Math.abs(delta) < minStep) {
			fSmoothCameraDistance = fCameraDistance
		}
		else {
			let step = delta * (5 * fFrameTime)
			if (Math.abs(step) < minStep) {
				if (delta > 0)
					step = minStep
				else
					step = -minStep
			}
			fSmoothCameraDistance += step
		}

		let fCameraPitch = RemapValClamped(fSmoothCameraDistance, CAMERA_START_PITCH_DISTANCE, CAMERA_END_PITCH_DISTANCE, CAMERA_MIN_PITCH, CAMERA_MAX_PITCH)
		GameUI.SetCameraPitchMin(fCameraPitch + 360)
		GameUI.SetCameraPitchMax(fCameraPitch + 360)
		GameUI.SetCameraDistance(fSmoothCameraDistance)

		pOverlayMap.mapscale = RemapValClamped(fSmoothCameraDistance, MIN_CAMERA_DISTANCE, MAX_CAMERA_DISTANCE, OVERLAY_MAP_SCALE, MIN_CAMERA_DISTANCE / MAX_CAMERA_DISTANCE * OVERLAY_MAP_SCALE)
	}
	Think()

	let CameraArg = { min: 0, value: 0, max: 10 }
	CustomUIConfig.SubscribeMouseEvent("camera", (tData) => {
		let sEventName = tData.event_name
		let iValue = tData.value

		if (GameUI.GetClickBehaviors() != CLICK_BEHAVIORS.DOTA_CLICK_BEHAVIOR_NONE) return

		if (sEventName === "wheeled") {
			CameraArg.value = Clamp(CameraArg.value - iValue, CameraArg.min, CameraArg.max)
			SetDistance(CameraArg.value / (CameraArg.max - CameraArg.min))
		}
	})
})();