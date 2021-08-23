import classNames from 'classnames';
import React, { useCallback, useEffect, useReducer, useRef, useState } from 'react';
import { render, useGameEvent, useNetTableKey, useRegisterForUnhandledEvent } from '@demon673/react-panorama';
// import { GetAbilityUpgradeData, GetAbilityUpgradeDescription } from '../elements/AbilityUpgrade/utils';
import { CustomItemImage } from '../elements/ItemImage';
import { DOTAShowTextTooltip, DispatchRefreshEvent, ShowCustomTooltip, useRefresh, useRefreshEvent, useRefreshState, useNetTableState, LogHelper, useSchedule, DOTAHideTextTooltip, useToggle } from '../utils/utils';
import { Compile } from './compile';

let pSelf = $.GetContextPanel();
let bManualShowDemo = false;

let update = () => {
	$.Schedule(1 / 30, update);
	if (!bManualShowDemo) {
		pSelf.SetHasClass('Minimized', GameUI.IsAltDown());
	} else {
		if (pSelf.BHasClass("Minimized") && GameUI.IsAltDown()) {
			pSelf.SetHasClass('Minimized', false);
			bManualShowDemo = false;
		}
	}
};
update();

function FireEvent(sEventName: string, str: string = "") {
	GameEvents.SendCustomGameEventToServer("DemoEvent", {
		event_name: sEventName,
		player_id: Players.GetLocalPlayer(),
		unit: Players.GetLocalPlayerPortraitUnit(),
		position: GameUI.GetCameraLookAtPosition(),
		str: str,
	});
}

function ToggleSelection(sPickerName: string) {
	let aPickerList = $.GetContextPanel().FindChildrenWithClassTraverse("SelectionContainer");
	if (aPickerList !== null) {
		for (const iterator of aPickerList) {
			if (iterator.id == sPickerName) {
				iterator.ToggleClass("Show");
			}
			else if (iterator.BHasClass("LockWindow") == false) {
				iterator.SetHasClass("Show", false);
			}
		}
	}
}
// ------------------------------------------------------------------------------------
function Root({ ...other }) {
	const [itemsNames, setItemNames] = useState<string[]>(() => {
		let items = [];
		for (const sItemName in GameUI.CustomUIConfig().ItemsKv) {

			if (sItemName != "Version") {
				const tItemData = GameUI.CustomUIConfig().ItemsKv[sItemName];

				if (typeof (tItemData) != "object") continue;

				if (tItemData.ItemRecipe && Number(tItemData.ItemRecipe) == 1) continue;
				if (sItemName.indexOf("item_wearable") != -1) continue;

				items.push(sItemName);
			}
		}

		items.sort((a, b) => {
			// 名字
			if ($.Localize("DOTA_Tooltip_ability_" + a) > $.Localize("DOTA_Tooltip_ability_" + b)) {
				return 1;
			} else if ($.Localize("DOTA_Tooltip_ability_" + a) < $.Localize("DOTA_Tooltip_ability_" + b)) {
				return -1;
			}
			return 0;
		});
		return items;
	});
	// // 当前英雄的饰品
	// const [wearables, setWearables] = useRefreshState<string[]>("AddWearable", () => {
	// 	let items: string[] = [];
	// 	const tWearableList = GameUI.CustomUIConfig().WearablesKv[Players.GetPlayerSelectedHero(Players.GetLocalPlayer())];
	// 	const heroWearableList = Object.keys(tWearableList);

	// 	items = items.concat(heroWearableList);
	// 	return items;
	// });
	// // 当前英雄的词条
	// const [abilityUpgrades, setAbilityUpgrades] = useRefreshState<string[]>("AddAbilityUpgrade", () => {
	// 	let items: string[] = [];

	// 	let iEntIndex = Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer());
	// 	for (const sID in GameUI.CustomUIConfig().AbilityUpgradesKv) {
	// 		const element = GameUI.CustomUIConfig().AbilityUpgradesKv[sID];

	// 		if (Entities.GetAbilityByName(iEntIndex, element.ability_name) != -1) {
	// 			items.push(sID);
	// 		}
	// 	}
	// 	return items;
	// });


	const [heroNames, setHeroNames] = useState<string[]>(() => {
		let items: string[] = [];
		for (const heroName in GameUI.CustomUIConfig().HeroesKv) {
			const heroData = GameUI.CustomUIConfig().HeroesKv[heroName];
			if (typeof (heroData) != "object") continue;
			if (heroData.override_hero == undefined) continue;
			if (heroName == "Version") continue;

			items.push(heroName);
		}
		return items;
	});
	// // 创建地方单位的分类按钮
	// const enemyToggleList = () => {
	// 	let items: any = {};
	// 	for (const unitName in GameUI.CustomUIConfig().EnemiesKV) {
	// 		const unitData = GameUI.CustomUIConfig().EnemiesKV[unitName];

	// 		if (typeof (unitData) != "object") continue;
	// 		if (unitData.Filter == undefined) continue;
	// 		if (unitName == "Version") continue;

	// 		items[$.Localize("filter_" + unitData.Filter)] = unitData.Filter;
	// 	}
	// 	return items;
	// };

	// // 是否作弊模式
	// const [isCheatMode, setIsCheatMode] = useNetTableState("common", "settings", false, (nettable) => {
	// 	if (nettable && nettable.is_cheat_mode) {
	// 		setIsCheatMode(nettable.is_cheat_mode == 1);
	// 	}
	// });
	// // 是否冻结游戏
	// const [isGameFrozen, setIsGameFrozen] = useNetTableState("common", "demo_settings", false, (nettable) => {
	// 	if (nettable && nettable.game_time_frozen) {
	// 		setIsCheatMode(nettable.game_time_frozen == 1);
	// 	}
	// });

	// const itemFilter = (_itemName: string, selected: Table) => {
	// 	if (Object.keys(selected).length == 0) {
	// 		return true;
	// 	}
	// 	const itemData = GameUI.CustomUIConfig().ItemsKv[_itemName];

	// 	if (itemData && itemData.Rarity != undefined) {
	// 		for (const key in selected) {
	// 			if (itemData.Rarity == selected[key]) {

	// 				return true;
	// 			}
	// 		}
	// 	} else {
	// 		return false;
	// 	}
	// 	return false;
	// };
	// const enemyFilter = (_itemName: string, selected: Table) => {
	// 	if (Object.keys(selected).length == 0) {
	// 		return true;
	// 	}
	// 	const itemData = GameUI.CustomUIConfig().EnemiesKV[_itemName] || GameUI.CustomUIConfig().BossKV[_itemName];

	// 	if (itemData && itemData.Filter) {
	// 		for (const key in selected) {
	// 			if (itemData.Filter == selected[key]) {
	// 				return true;
	// 			}
	// 		}
	// 	} else {
	// 		return false;
	// 	}
	// 	return false;
	// };

	const [compile, setCompile] = useState(false);

	useRefreshEvent("RefreshContainer");

	return (
		<Panel className="CustomHudRoot" {...other} style={{ visibility: true ? "visible" : "collapse" }}>
			<SelectContainer eventName="AddPassiveAbility" text="添加技能" list={Object.keys(GameUI.CustomUIConfig().AbilitiesKv)} type={SelectionItemType.SELECTION_ITEM_TYPE_ABILITY} />
			{/* <SelectContainer eventName="AddFaithAbility" text="添加信仰技能" list={Object.keys(GameUI.CustomUIConfig().FaithAbilitiesKv)} type={SelectionItemType.SELECTION_ITEM_TYPE_ABILITY} /> */}
			{/* <SelectContainer eventName="AddAbilityUpgrade" text="添加技能词条" list={abilityUpgrades} type={SelectionItemType.SELECTION_ITEM_TYPE_ABILITY_UPGRADE} /> */}
			<SelectContainer eventName="AddItem" text="添加物品" list={itemsNames} type={SelectionItemType.SELECTION_ITEM_TYPE_ITEM} />
			{/* <SelectContainer eventName="AddWearable" text="添加饰品" list={wearables} type={SelectionItemType.SELECTION_ITEM_TYPE_WEARABLE} /> */}
			<SelectContainer eventName="SwitchHero" text="更换英雄" list={heroNames} type={SelectionItemType.SELECTION_ITEM_TYPE_HERO} />
			<SelectContainer eventName="AllyHero" text="友方英雄" list={heroNames} type={SelectionItemType.SELECTION_ITEM_TYPE_HERO} />
			<SelectContainer eventName="CreateEnemy" text="创建敌方单位" list={Object.keys(GameUI.CustomUIConfig().EnemiesKv).concat(Object.keys(GameUI.CustomUIConfig().SpecialEnemiesKv)).concat(Object.keys(GameUI.CustomUIConfig().NaturesKv))} type={SelectionItemType.SELECTION_ITEM_TYPE_COMMON} />
			<Panel id="DemoPanel" className="ControlPanel TopBottomFlow" >
				<Panel className="ControlPanelContainer">
					<Panel id="Maximized">
						<Panel id="MinimizeButton">
							<Label localizedText="#DemoOptions_MinimizeButton" />
						</Panel>
						{/* 关卡 */}
						<Panel className="CategoryContainer">
							<Label localizedText="关卡" />
							<Panel className="Category" >
								{/* <CommonButton eventName="ResetGameLevelPressed" text="#Button_ResetGameLevel" /> */}
								<CommonToggleButton eventName="ToggleSpawnerButtonPressed" setting="has_fog" text="暂停刷怪" />
								{/* <CommonToggleButton eventName="ToggleCameraButtonPressed" setting="lock_camera" text="锁定视角" /> */}
								{/* <CommonToggleButton eventName="ToggleMouseButtonPressed" setting="unlock_mouse" text="解锁鼠标" /> */}
								<TextEntryButton eventName="ChangeRound" text="进攻波数" />
								<TextEntryButton eventName="ChangeHostTimescale" text="主机速度" />
								{/* <CommonButton eventName="UnlockMap" text="显示所有地图" /> */}
							</Panel>
						</Panel>
						{/* 技能 */}
						<Panel className="CategoryContainer">
							<Label localizedText="技能" />
							<Panel className="Category" >
								<SelectionButton eventName="AddPassiveAbility" text="添加额外技能" />
								<CommonButton eventName="RemoveAllPassiveAbility" text="移除所有额外技能" />
								<SelectionButton eventName="AddItem" text="添加物品" />
								<CommonButton eventName="RemoveInventoryItemsButtonPressed" text="移除所有物品" />
							</Panel>
						</Panel>
						{/* 英雄 */}
						<Panel className="CategoryContainer">
							<Label localizedText="#Hero_ButtonCategory" />
							<Panel className="Category" >
								<CommonButton eventName="RefreshButtonPressed" text="刷新状态" />
								<CommonToggleButton eventName="FreeSpellsButtonPressed" setting="free_spells" text="#FreeSpells_Button" />
								<CommonToggleButton eventName="InvulnerabilityButtonPressed" text="无敌状态" />
								<TextEntryButton eventName="LevelUpButtonPressed" text="升级" defaultValue="1" />
								<DropDownButton eventName="RebornButtonPressed" text="转生次数" list={["0", "1", "2", "3", "4"]} />
								<CommonButton eventName="PrintModifiers" text="打印英雄的Modifier" />
							</Panel>
						</Panel>
						{/* 创建英雄 */}
						<Panel className="CategoryContainer">
							<Label localizedText="创建英雄" />
							<Panel className="Category">
								<SelectionButton eventName="SwitchHero" text="切换英雄" />
								{/* <SelectionButton eventName="SpawnEnemyButtonPressed" text="创建敌方英雄" />
								<CommonButton eventName="LevelUpEnemyButtonPressed" text="#LevelUpEnemy_Button" />
							<CommonButton eventName="EnemyMaxLevelButtonPressed" text="#EnemyMaxLevel_Button" /> */}
								<CommonButton eventName="DummyTargetButtonPressed" text="傀儡目标" />
								<CommonButton eventName="RemoveSpawnedUnitsButtonPressed" text="#RemoveSpawns_Button" />
								<SelectionButton eventName="CreateEnemy" text="创建敌方单位" />
								<CommonToggleButton eventName="ToggleEnemyControlable" setting="enemy_controlable" text="开启敌人控制" />
								<CommonButton eventName="RespawnHero" text="复活英雄" />
								<SelectionButton eventName="AllyHero" text="友方英雄" />
								<CommonButton eventName="LevelUpAllyButtonPressed" text="升级友方英雄" />
								<CommonButton eventName="AllyMaxLevelButtonPressed" text="友方英雄满级" />
							</Panel>
						</Panel>
						{/* 其他 */}
						<Panel className="CategoryContainer">
							<Label localizedText="#Other_ButtonCategory" />
							<Panel className="Category">
								<CommonButton eventName="" text="#Compile_Button" onactivate={() => { setCompile(true); }} />
								<CommonButton eventName="SetWinnerPressed" text="#SetWinner_Button" />
								<CommonButton eventName="RestartButtonPressed" text="重开游戏" />
								<CommonButton eventName="ReloadScriptButtonPressed" text="#ReloadScript_Button" />
								{/* <Panel className="Row">
									<ToggleButton id="GameTimeFrozenButton" className="DemoButton" selected={isGameFrozen} onactivate={() => { FireEvent("GameTimeFrozenButtonPressed"); }}>
										<Label localizedText="#GameTimeFrozen_Button" />
									</ToggleButton>
								</Panel> */}
								<TextEntryButton eventName="DrawCircle" text="画圈" />
							</Panel>
						</Panel>
					</Panel>
				</Panel>
				<Button id="ControlPanelSlideThumb" onactivate={() => {
					pSelf.ToggleClass('Minimized');
					bManualShowDemo = pSelf.BHasClass("Minimized");
				}}>
					<Label className="BottomArrowButtonIcon" text="ALT" />
				</Button>
			</Panel>
			<Panel id="Compile" >
				{compile && <Compile onload={() => { setCompile(false); }} />}
			</Panel>
		</Panel >
	);
}
// 普通按钮
function CommonButton({ eventName, str = "", text, onactivate = () => FireEvent(eventName, str) }: { eventName: string, str?: string, text: string, onactivate?: () => void; }) {
	return (
		<Panel className="Row">
			<Button className="DemoButton" onactivate={onactivate}>
				<Label localizedText={text} />
			</Button>
		</Panel>
	);
}
// 切换按钮
function CommonToggleButton({ eventName, str = "", setting, text }: { eventName: string, str?: string, setting?: keyof CustomNetTableDeclarations["common"]["demo_settings"], text: string; }) {
	const [selected, setSelected] = useState(() => {
		let bSelected = false;
		if (setting) {
			const tSettings = CustomNetTables.GetTableValue("common", "demo_settings");
			if (tSettings) {
				bSelected = Number(tSettings[setting]) == 1;
			}
		}
		return bSelected;
	});
	return (
		<Panel className="Row">
			<ToggleButton id="ToggleFogButton" className="DemoButton" selected={selected} onactivate={() => { FireEvent(eventName, str); setSelected(!selected); }}>
				<Label localizedText={text} />
			</ToggleButton>
		</Panel>
	);
}
// 下拉按钮
function DropDownButton({ eventName, list, width = "140px", text }: { eventName: string, list: string[], width?: string, text: string; }) {
	return (
		<Panel className="Row">
			<Button className="DemoButton" onactivate={(self) => {
				let drop = self.FindChildTraverse("DemoDropDown") as DropDown;
				let select = drop.GetSelected() as LabelPanel;
				FireEvent(eventName, select.text);
			}}>
				<DropDown id="DemoDropDown" selected={list[0]} oninputsubmit={(self) => {
					let pSelected = self.GetSelected() as LabelPanel;
					if (pSelected) {
						FireEvent(eventName, pSelected.text);
					}
				}}>
					{list.map((tData: any, key: any) => {
						return <Label style={{ width: width }} key={String(tData)} id={String(tData)} text={String(tData)} />;
					})}
				</DropDown>
				<Label localizedText={text} />
			</Button>
		</Panel>
	);
}

// 文本输入按钮
function TextEntryButton({ eventName, text, defaultValue = "" }: { eventName: string, text: string, defaultValue?: string; }) {
	return (
		<Panel className="Row">
			<Button className="DemoButton" onactivate={(self) => {
				let TextEntry = self.FindChildTraverse("CommonTextEntry") as TextEntry;
				FireEvent(eventName, TextEntry.text);
			}}>
				<TextEntry id="CommonTextEntry" className="DemoTextEntry" text={defaultValue} oninputsubmit={(self) => {
					FireEvent(eventName, self.text);
				}}>
				</TextEntry>
				<Label localizedText={text} />
			</Button>
		</Panel>
	);
}
// 选择按钮
function SelectionButton({ eventName, text }: { eventName: string, text: string; }) {
	return (
		<Panel className="Row">
			<Button className="DemoButton" onactivate={() => {
				ToggleSelection(eventName);
				DispatchRefreshEvent(eventName);
				DispatchRefreshEvent("RefreshContainer");
			}}>
				<Image className="SelectionButtonIcon" />
				<Label localizedText={text} />
			</Button>
		</Panel>
	);
}
enum SelectionItemType {
	SELECTION_ITEM_TYPE_COMMON = 0,
	SELECTION_ITEM_TYPE_ABILITY,
	SELECTION_ITEM_TYPE_ABILITY_UPGRADE,
	SELECTION_ITEM_TYPE_ITEM,
	SELECTION_ITEM_TYPE_HERO,
	SELECTION_ITEM_TYPE_WEARABLE,
}
/**
 * 选择容器
 * @param {{ eventName: string, text: string, list: string[], toggleList?: Table, filter?: (_itemName: string, _toggleList: Table) => boolean, type?: SelectionItemType; }} { eventName, text, list, toggleList = {}, filter, type = SelectionItemType.SELECTION_ITEM_TYPE_COMMON }
 */
function SelectContainer({ eventName, text, list, toggleList = {}, filter, type = SelectionItemType.SELECTION_ITEM_TYPE_COMMON }: { eventName: string, text: string, list: string[], toggleList?: Table, filter?: (_itemName: string, _toggleList: Table) => boolean, type?: SelectionItemType; }) {
	const [filterWord, setFilterWord] = useState("");
	const [selectedFilter, setSelectedFilter] = useState({});
	const onactivate = (self: ToggleButton, key: string) => {
		if (self.IsSelected() == true) {
			setSelectedFilter({ ...selectedFilter, [key]: toggleList[key] });
		} else {
			let temp: any = { ...selectedFilter };
			delete temp[key];
			setSelectedFilter(temp);
		}
	};
	const [size, setSize] = useState("NormalSize");
	const [lock, toggleLock] = useToggle(false);
	const [textMode, toggleTextMode] = useToggle(true);
	const ToggleSize = (self: Panel) => {
		if (size == "NormalSize") {
			setSize("ThinSize");
		}
		if (size == "ThinSize") {
			setSize("WidthSize");
		}
		if (size == "WidthSize") {
			setSize("NormalSize");
		}
	};
	const ToggleLock = (self: Panel) => {
		toggleLock();
	};
	const DragStart = (panel: Panel) => {
		let parent = panel.FindAncestor(eventName);
		if (parent) {
			GameUI.CustomUIConfig().StartDrag(parent);
		}
	};


	return (
		<Panel id={eventName} className={classNames("SelectionContainer", { LockWindow: lock })} hittest={true} >
			<Panel id="SelectionPicker" className={size} >
				<Panel id="SelectionPickerHeader" onmouseover={DragStart} onmouseout={() => GameUI.CustomUIConfig().EndDrag()}>
					<Button className="CloseButton" onactivate={() => ToggleSelection(eventName)} />
					<Label id="SelectionChoice" localizedText={text} />
					<Panel className="FillWidth" />
					{Object.keys(toggleList).map((key) => {
						return <ToggleButton key={key} text={key} onactivate={(self) => onactivate(self, key)} />;
					})}
					<Panel id="SelectionSearch" className="SearchBox" >
						<TextEntry id="SelectionSearchTextEntry" placeholder="#DOTA_Search" oninputsubmit={(self) => setFilterWord(self.text)} ontextentrychange={(self) => {
							if (self.text == "" && filterWord != "") {
								setFilterWord("");
							}
						}} />
						<Button id="SelectionSearchButton" />
					</Panel>
					<Button className="RowMode" onactivate={toggleTextMode} onmouseover={(self) => DOTAShowTextTooltip(self, "源码模式")} onmouseout={(self) => DOTAHideTextTooltip(self)} />
					<Button className="Resize" onactivate={ToggleSize} onmouseover={(self) => DOTAShowTextTooltip(self, "切换样式")} onmouseout={(self) => DOTAHideTextTooltip(self)} />
					<Button className="Lock" onactivate={ToggleLock} onmouseover={(self) => DOTAShowTextTooltip(self, "锁定窗口")} onmouseout={(self) => DOTAHideTextTooltip(self)} />
				</Panel>
				<Panel id="SelectionList" >
					{list.map((itemName) => {
						let localize = $.Localize(itemName);
						if (type == SelectionItemType.SELECTION_ITEM_TYPE_ABILITY || type == SelectionItemType.SELECTION_ITEM_TYPE_ITEM) {
							localize = $.Localize("DOTA_Tooltip_ability_" + itemName);
						}
						if (type == SelectionItemType.SELECTION_ITEM_TYPE_WEARABLE) {
							localize = $.Localize("DOTA_Tooltip_ability_item_wearable_" + itemName);
						}
						if ((filterWord == "" || localize.search(filterWord) != -1) && (filter ? filter(itemName, selectedFilter) : true)) {
							return <SelectContainerItem key={itemName} eventName={eventName} itemName={itemName} type={type} textMode={textMode} />;
						}
					})}
				</Panel>
			</Panel>
		</Panel>
	);
}
function SelectContainerItem({ eventName, itemName, type, textMode }: { eventName: string, itemName: string, type: SelectionItemType, textMode: boolean; }) {
	return (
		<>
			{type == SelectionItemType.SELECTION_ITEM_TYPE_COMMON &&
				<Panel key={itemName} className={classNames("CommonSelectionItem", "DemoButton")} onactivate={() => FireEvent(eventName, itemName)}>
					<Label id="CommonSelectionItemName" text={textMode ? $.Localize(itemName) : itemName} />
				</Panel>
			}
			{type == SelectionItemType.SELECTION_ITEM_TYPE_ABILITY &&
				<Panel className="AbilityPickerCard" onactivate={() => FireEvent(eventName, itemName)} >
					<DOTAAbilityImage id="AbilityPickerCardImage" abilityname={itemName} showtooltip={true} />
					<Label id="AbilityPickerCardName" text={textMode ? $.Localize("DOTA_Tooltip_ability_" + itemName) : itemName} />
				</Panel>
			}
			{type == SelectionItemType.SELECTION_ITEM_TYPE_ITEM &&
				<Panel className="ItemPickerCard" onactivate={() => FireEvent(eventName, itemName)} >
					<DOTAItemImage id="ItemPickerCardImage" itemname={itemName} showtooltip={true} />
					<Label id="ItemPickerCardName" text={textMode ? $.Localize("DOTA_Tooltip_ability_" + itemName) : itemName} />
				</Panel>
			}
			{type == SelectionItemType.SELECTION_ITEM_TYPE_WEARABLE &&
				<Panel className="WearablePickerCard" onmouseover={(self) => $.DispatchEvent("DOTAShowEconItemTooltip", self, itemName, -1, -1)} onmouseout={(self) => $.DispatchEvent("DOTAHideEconItemTooltip", self)} onactivate={() => FireEvent(eventName, itemName)} >
					<GenericPanel type="EconItemImage" itemdef={itemName} key={itemName} id="EconItemIcon" scaling="stretch-to-cover-preserve-aspect" />
					<Label id="ItemPickerCardName" text={textMode ? $.Localize("DOTA_Tooltip_ability_item_wearable_" + itemName) : itemName} />
				</Panel>
			}
			{type == SelectionItemType.SELECTION_ITEM_TYPE_HERO &&
				<Panel className="HeroPickerCard" onactivate={() => FireEvent(eventName, itemName)} >
					<DOTAHeroImage heroimagestyle={"portrait"} heroname={itemName} id="HeroPickerCardImage" scaling="stretch-to-fit-x-preserve-aspect" />
					<Label id="ItemPickerCardName" text={textMode ? $.Localize(itemName) : itemName} />
				</Panel>
			}
		</>
	);
}

render(<Root hittest={false} />, pSelf);