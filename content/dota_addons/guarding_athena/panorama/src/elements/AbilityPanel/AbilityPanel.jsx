import React, { useState, useRef, useEffect } from 'react';
import classNames from 'classnames';

export function AbilityPanel({ overrideentityindex = -1, overridedisplaykeybind = -1, slot = -1, className, ...other }) {
	const refSelf = useRef(null);

	const [m_is_item, set_is_item] = useState(false);
	const [m_max_level, set_max_level] = useState(0);
	const [m_level, set_level] = useState(0);
	const [m_charges_percent, set_charges_percent] = useState(1);
	const [m_cooldown_percent, set_cooldown_percent] = useState(1);

	function update() {
		let pSelf = refSelf.current
		if (!pSelf) return;

		let iActiveAbility = Abilities.GetLocalPlayerActiveAbility();
		let iCasterIndex = Abilities.GetCaster(overrideentityindex);
		let bControllable = Entities.IsControllableByPlayer(iCasterIndex, Players.GetLocalPlayer());
		let bIsValid = overrideentityindex != -1 && Entities.IsValidEntity(overrideentityindex);

		pSelf.SetHasClass("no_ability", !bIsValid);
		let bIsItem = Abilities.IsItem(overrideentityindex) || slot != -1;
		if (bIsItem != pSelf.m_is_item) {
			pSelf.m_is_item = bIsItem
			set_is_item(bIsItem);
		}

		pSelf.SetHasClass("no_item", bIsItem && !bIsValid);

		let iMaxLevel = (!bIsValid || Entities.IsEnemy(iCasterIndex)) ? 0 : Abilities.GetMaxLevel(overrideentityindex)
		if (iMaxLevel != pSelf.m_max_level) {
			pSelf.m_max_level = iMaxLevel
			set_max_level(iMaxLevel);
		}
		let iLevel = (!bIsValid || Entities.IsEnemy(iCasterIndex)) ? 0 : Abilities.GetLevel(overrideentityindex)
		if (iLevel != pSelf.m_level) {
			pSelf.m_level = iLevel
			set_level(iLevel);
			pSelf.SetDialogVariableInt("level", pSelf.m_level);
		}
		let iCasterMana = iCasterIndex == -1 ? 0 : Entities.GetMana(iCasterIndex);
		let iAbilityPoints = Entities.GetAbilityPoints(iCasterIndex);
		let iKeybindCommand = Entities.GetAbilityIndex(iCasterIndex, overrideentityindex) + DOTAKeybindCommand_t.DOTA_KEYBIND_ABILITY_PRIMARY1;
		if (bIsItem) {
			iKeybindCommand = slot + DOTAKeybindCommand_t.DOTA_KEYBIND_INVENTORY1
		}
		let sHotkey = (iKeybindCommand >= DOTAKeybindCommand_t.DOTA_KEYBIND_ABILITY_PRIMARY1 && iKeybindCommand <= DOTAKeybindCommand_t.DOTA_KEYBIND_ABILITY_ULTIMATE) ? Game.GetKeybindForCommand(iKeybindCommand) : "";
		if (bIsItem) {
			sHotkey = (iKeybindCommand >= DOTAKeybindCommand_t.DOTA_KEYBIND_INVENTORY1 && iKeybindCommand <= DOTAKeybindCommand_t.DOTA_KEYBIND_INVENTORY6) ? Game.GetKeybindForCommand(iKeybindCommand) : "";
		}
		if (overridedisplaykeybind != -1) {
			sHotkey = Game.GetKeybindForCommand(overridedisplaykeybind);
		}

		let pAbilityImage = pSelf.FindChildTraverse("AbilityImage");
		if (pAbilityImage) {
			pAbilityImage.contextEntityIndex = bIsItem ? -1 : overrideentityindex;
		}
		let pItemImage = pSelf.FindChildTraverse("ItemImage");
		if (pItemImage) {
			pItemImage.contextEntityIndex = bIsItem ? overrideentityindex : -1;
		}

		let bInAbilityPhase = (!bIsValid || Entities.IsEnemy(iCasterIndex)) ? false : Abilities.IsInAbilityPhase(overrideentityindex);
		let bCooldownReady = (!bIsValid || Entities.IsEnemy(iCasterIndex)) ? true : Abilities.IsCooldownReady(overrideentityindex);

		let iManaCost = (!bIsValid || Entities.IsEnemy(iCasterIndex)) ? 0 : Abilities.GetManaCost(overrideentityindex);
		iManaCost = CalcSpecialValueUpgrade(iCasterIndex, Abilities.GetAbilityName(overrideentityindex), "mana_cost", iManaCost)
		let iGoldCost = (!bIsValid || Entities.IsEnemy(iCasterIndex)) ? 0 : Abilities.GetLevelGoldCost(overrideentityindex, iLevel);

		pSelf.SetHasClass("unitmuted", Entities.IsMuted(iCasterIndex));
		pSelf.SetHasClass("silenced", Entities.IsSilenced(iCasterIndex));

		pSelf.SetHasClass("auto_castable", bIsValid && Abilities.IsAutocast(overrideentityindex));
		pSelf.SetHasClass("is_passive", bIsValid && Abilities.IsPassive(overrideentityindex));
		pSelf.SetHasClass("is_toggle", bIsValid && Abilities.IsToggle(overrideentityindex));

		pSelf.SetHasClass("insufficient_mana", iManaCost > iCasterMana);
		pSelf.SetHasClass("auto_cast_enabled", bIsValid && Abilities.GetAutoCastState(overrideentityindex));
		pSelf.SetHasClass("toggle_enabled", bIsValid && Abilities.GetToggleState(overrideentityindex));

		pSelf.SetHasClass("can_cast_again", iManaCost > iCasterMana || !bCooldownReady);

		pSelf.SetHasClass("no_level", iLevel == 0 || !Abilities.IsActivated(overrideentityindex));
		pSelf.SetHasClass("could_level_up", bControllable && iAbilityPoints > 0 && Abilities.CanAbilityBeUpgraded(overrideentityindex) == AbilityLearnResult_t.ABILITY_CAN_BE_UPGRADED);
		pSelf.SetHasClass("show_level_up_tab", pSelf.BHasClass("could_level_up"));
		pSelf.SetHasClass("show_level_up_frame", Game.IsInAbilityLearnMode() && pSelf.BHasClass("could_level_up"));
		pSelf.SetHasClass("is_active", iActiveAbility == overrideentityindex);
		pSelf.SetHasClass("ability_phase", bInAbilityPhase);
		pSelf.SetHasClass("in_cooldown", !bCooldownReady);
		pSelf.SetHasClass("no_mana_cost", iManaCost == 0);
		pSelf.SetDialogVariableInt("mana_cost", iManaCost);
		pSelf.SetHasClass("no_gold_cost", iGoldCost == 0);
		pSelf.SetDialogVariableInt("gold_cost", iGoldCost);

		pSelf.SetHasClass("no_hotkey", sHotkey == "" || !bControllable || !((!pSelf.BHasClass("no_level") && !pSelf.BHasClass("is_passive")) || pSelf.BHasClass("show_level_up_frame") || (GameUI.IsControlDown() && pSelf.BHasClass("could_level_up"))));
		pSelf.RemoveClass("hotkey_alt");
		pSelf.RemoveClass("hotkey_ctrl");
		let aHotkeys = sHotkey.split("-");
		if (aHotkeys) {
			for (const sKey of aHotkeys) {
				if (sKey.toUpperCase().indexOf("ALT") != -1) {
					pSelf.AddClass("hotkey_alt");
				} else if (sKey.toUpperCase().indexOf("CTRL") != -1) {
					pSelf.AddClass("hotkey_ctrl");
				} else {
					pSelf.SetDialogVariable("hotkey", Abilities.GetKeybind(overrideentityindex));
				}
			}
		}

		let fCooldownLength = Abilities.GetCooldownLength(overrideentityindex);

		pSelf.RemoveClass("show_ability_charges");
		if (!Entities.IsEnemy(iCasterIndex)) {
			for (let i = 0; i < Entities.GetNumBuffs(iCasterIndex); i++) {
				let iModifier = Entities.GetBuff(iCasterIndex, i);
				let sModifierName = Buffs.GetName(iCasterIndex, iModifier);
				if (iModifier != -1 && Buffs.GetAbility(iCasterIndex, iModifier) == overrideentityindex && FindKey(CustomUIConfig.ChargeCounterKv, sModifierName) && !Buffs.IsDebuff(iCasterIndex, iModifier)) {
					pSelf.AddClass("show_ability_charges");
					pSelf.SetDialogVariableInt("ability_charge_count", Buffs.GetStackCount(iCasterIndex, iModifier));
					values.charge_count = Buffs.GetStackCount(iCasterIndex, iModifier);
					fCooldownLength = Buffs.GetDuration(iCasterIndex, iModifier) == -1 ? 0 : Buffs.GetDuration(iCasterIndex, iModifier);
					let fPercent = Clamp(Buffs.GetRemainingTime(iCasterIndex, iModifier) / fCooldownLength, 0, 1);
					let fChargesPercent = 1 - fPercent
					if (fChargesPercent != pSelf.m_charges_percent) {
						pSelf.m_charges_percent = fChargesPercent
						set_charges_percent(fChargesPercent);
					}
					break;
				}
			}
		}

		let fCastStartTime = pSelf.m_cast_start_time
		if (bInAbilityPhase) {
			if (fCastStartTime == -1) fCastStartTime = Game.GetGameTime() - Game.GetGameFrameTime();

			let fCastTime = Clamp(Game.GetGameTime() - fCastStartTime, 0, Abilities.GetCastPoint(overrideentityindex));
			let fPercent = fCastTime / Abilities.GetCastPoint(overrideentityindex);
			if (fPercent != pSelf.m_cooldown_percent) {
				pSelf.m_cooldown_percent = fPercent
				set_cooldown_percent(fPercent)
			}
		} else {
			fCastStartTime = -1
		}
		if (fCastStartTime != pSelf.m_cast_start_time) {
			pSelf.m_cast_start_time = fCastStartTime
		}
		if (!bCooldownReady) {
			let fCooldownTimeRemaining = Abilities.GetCooldownTimeRemaining(overrideentityindex);
			let fPercent = (fCooldownTimeRemaining / fCooldownLength);
			if (fCooldownLength == 0) fPercent = 1;
			if (fPercent != pSelf.m_cooldown_percent) {
				pSelf.m_cooldown_percent = fPercent
				set_cooldown_percent(fPercent)
			}

			pSelf.SetDialogVariableInt("cooldown_timer", Math.ceil(fCooldownTimeRemaining));
		}

		let pShine = pSelf.FindChildTraverse("Shine")
		if (pShine) {
			if ((bCooldownReady == true && bInAbilityPhase == false && bInAbilityPhase != pSelf.m_in_ability_phase) || (bCooldownReady == true && bCooldownReady != pSelf.m_cooldown_ready)) {
				pShine.TriggerClass("do_shine");
			}
		}

		pSelf.RemoveClass("show_item_charges");
		pSelf.RemoveClass("show_item_alt_charges");
		pSelf.RemoveClass("muted");
		if (Abilities.IsItem(overrideentityindex)) {
			pSelf.SetHasClass("muted", Items.IsMuted(overrideentityindex));

			let iChargeCount = 0;
			let bHasCharges = false;
			let iAltChargeCount = 0;
			let bHasAltCharges = false;

			if (Items.ShowSecondaryCharges(overrideentityindex)) {
				bHasCharges = true;
				bHasAltCharges = true;
				if (Abilities.GetToggleState(overrideentityindex)) {
					iChargeCount = Items.GetCurrentCharges(overrideentityindex);
					iAltChargeCount = Items.GetSecondaryCharges(overrideentityindex);
				}
				else {
					iAltChargeCount = Items.GetCurrentCharges(overrideentityindex);
					iChargeCount = Items.GetSecondaryCharges(overrideentityindex);
				}
			}
			else if (Items.ShouldDisplayCharges(overrideentityindex)) {
				bHasCharges = true;
				iChargeCount = Items.GetCurrentCharges(overrideentityindex);
			}

			pSelf.SetHasClass("show_item_charges", bHasCharges);
			pSelf.SetHasClass("show_item_alt_charges", bHasAltCharges);

			pSelf.SetDialogVariableInt("item_charge_count", iChargeCount);
			pSelf.SetDialogVariableInt("item_alt_charge_count", iAltChargeCount);
		}
		if (bInAbilityPhase != pSelf.m_in_ability_phase) {
			pSelf.m_in_ability_phase = bInAbilityPhase
		}
		if (bCooldownReady != pSelf.m_cooldown_ready) {
			pSelf.m_cooldown_ready = bCooldownReady
		}
	}

	useEffect(() => {
		let pSelf = refSelf.current;
		if (pSelf) {
			pSelf.m_is_item = false;
			pSelf.m_max_level = 0;
			pSelf.m_level = 0;
			pSelf.m_cooldown_ready = true;
			pSelf.m_in_ability_phase = false;
			pSelf.m_charges_percent = 1;
			pSelf.m_cooldown_percent = 1;
			pSelf.m_cast_start_time = -1;
			pSelf.update = update;
		}
		update();
	}, []);

	useEffect(() => {
		let pSelf = refSelf.current;
		if (pSelf) {
			pSelf.update = update;
		}
		update();
	}, [overrideentityindex, overridedisplaykeybind, slot]);

	return (
		<Panel className={classNames("AbilityPanel", className, "AbilityMaxLevel" + m_max_level)} {...other} ref={refSelf}>
			<Panel id="ButtonAndLevel" require-composition-layer="true" always-cache-composition-layer="true" hittest={false}>
				<Panel id="LevelUpBurstFXContainer" hittest={false}>
					{!m_is_item &&
						<DOTAScenePanel id="LevelUpBurstFX" map="scenes/hud/levelupburst" renderdeferred={false} rendershadows={false} camera="camera_1" hittest={false} particleonly={true} />
					}
				</Panel>
				<Panel id="ButtonWithLevelUpTab" hittest={false}>
					<Button id="LevelUpTab" hittest={true} onactivate={() => {
						if (overrideentityindex != -1 && Entities.IsValidEntity(overrideentityindex)) {
							Abilities.AttemptToUpgrade(overrideentityindex);
						}
					}} onmouseover={(self) => {
						let pAbilityButton = self.GetParent().FindChildTraverse("AbilityButton");
						if (pAbilityButton) {
							if (overrideentityindex != -1 && Entities.IsValidEntity(overrideentityindex)) {
								CustomUIConfig.ShowAbilityTooltiop(pAbilityButton, Abilities.GetAbilityName(overrideentityindex), Abilities.GetCaster(overrideentityindex), slot)
							}
						}
					}} onmouseout={(self) => {
						let pAbilityButton = self.GetParent().FindChildTraverse("AbilityButton");
						if (pAbilityButton) {
							CustomUIConfig.HideAbilityTooltiop(pAbilityButton)
						}
					}} >
						<Panel id="LevelUpButton">
							<Panel id="LevelUpIcon" />
						</Panel>
						<Panel id="LearnModeButton" hittest={false} />
					</Button>
					<Panel id="LevelUpLight" hittest={false} />
					<Panel hittest={false} id="ButtonWell">
						<Panel hittest={false} id="AutocastableBorder" />
						<Panel id="AutoCastingContainer" hittest={false}>
							{!false &&
								<DOTAScenePanel id="AutoCasting" map="scenes/hud/autocasting" renderdeferred={false} rendershadows={false} camera="camera_1" hittest={false} particleonly={true} />
							}
						</Panel>
						<Panel id="ButtonSize">
							<Panel id="AbilityButton" onactivate={(self) => {
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
									if (Abilities.IsAutocast(overrideentityindex)) {
										Game.PrepareUnitOrders({
											OrderType: dotaunitorder_t.DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO,
											AbilityIndex: overrideentityindex,
											UnitIndex: Abilities.GetCaster(overrideentityindex),
										})
									}
								}
							}} onmouseover={(self) => {
								if (overrideentityindex != -1 && Entities.IsValidEntity(overrideentityindex)) {
									CustomUIConfig.ShowAbilityTooltiop(self, Abilities.GetAbilityName(overrideentityindex), Abilities.GetCaster(overrideentityindex), slot)
								}
							}} onmouseout={(self) => {
								CustomUIConfig.HideAbilityTooltiop(self)
							}} >
								<DOTAAbilityImage id="AbilityImage" showtooltip={false} />
								<DOTAItemImage id="ItemImage" scaling="stretch-to-fit-x-preserve-aspect" showtooltip={false} />
								<Panel hittest={false} id="AbilityBevel" />
								<Panel hittest={false} id="ShineContainer">
									<Panel hittest={false} id="Shine" />
								</Panel>
								<Panel id="TopBarUltimateCooldown" hittest={false} />
								<Panel id="Cooldown" hittest={false}>
									<Panel id="CooldownOverlay" hittest={false} style={{ clip: "radial(50.0% 50.0%, 0.0deg, " + -m_cooldown_percent * 360 + "deg)" }} />
									<Label id="CooldownTimer" className="MonoNumbersFont" localizedText="{d:cooldown_timer}" hittest={false} />
								</Panel>
								<Panel id="ActiveAbility" hittest={false} />
								<Panel id="InactiveOverlay" hittest={false} />
								<Label id="ItemCharges" localizedText="{d:item_charge_count}" hittest={false} />
								<Label id="ItemAltCharges" localizedText="{d:item_alt_charge_count}" hittest={false} />
							</Panel>
							<Panel hittest={false} id="ActiveAbilityBorder" />
							<Panel hittest={false} id="PassiveAbilityBorder" />
							<Panel hittest={false} id="AutocastableAbilityBorder" />
							<Panel hittest={false} id="GoldCostBG" />
							<Label hittest={false} id="GoldCost" localizedText="{d:gold_cost}" />
							<Panel hittest={false} id="ManaCostBG" />
							<Label hittest={false} id="ManaCost" localizedText="{d:mana_cost}" />
							<Panel hittest={false} id="CombineLockedOverlay" />
							<Panel hittest={false} id="SilencedOverlay" />
							<Panel hittest={false} id="AbilityStatusOverlay" />
							<Panel hittest={false} id="UpgradeOverlay" />
							<Panel hittest={false} id="DropTargetHighlight" />
						</Panel>
					</Panel>
					<Panel id="HotkeyContainer" hittest={false} hittestchildren={false}>
						<Panel id="Hotkey">
							<Label id="HotkeyText" localizedText="{s:hotkey}" />
						</Panel>
						<Panel id="HotkeyModifier">
							<Label id="AltText" localizedText="#DOTA_Keybind_ALT" />
						</Panel>
						<Panel id="HotkeyCtrlModifier">
							<Label id="CtrlText" localizedText="#DOTA_Keybind_CTRL" />
						</Panel>
					</Panel>
					<Panel id="LevelContainer" hittest={false} hittestchildren={false}>
						<Panel id="AbilityLevel">
							<Label id="AbilityLevelText" localizedText="{d:level}" />
						</Panel>
					</Panel>
					<CircularProgressBar id="AbilityCharges" hittest={false} hittestchildren={false} value={m_charges_percent}>
						<Label localizedText="{d:ability_charge_count}" />
					</CircularProgressBar>
				</Panel>
				<Panel hittest={false} id="AbilityLevelContainer" >
					{/* {m_max_level > 0 && [...Array(m_max_level).keys()].map((key) => {
						return <Panel key={key.toString()} className={classNames("LevelPanel", { "next_level": key == m_level, "active_level": key < m_level })} />
					})} */}
				</Panel>
			</Panel>
		</Panel>
	)
}