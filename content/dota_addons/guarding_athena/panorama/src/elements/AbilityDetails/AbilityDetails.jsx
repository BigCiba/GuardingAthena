import React, { useEffect, useRef, useState } from 'react';
import { getCastType, isActive, getTargetType, getDamageType, getSpellImmunity, getDispelType, getItemDispelType, compose, replaceValues } from './utils';
import classNames from 'classnames';

export function AbilityDetails({ abilityname = "", entityindex = -1, inventoryslot = -1, level = -1, mode = "normal", showextradescription = false, ...other }) {
	const [_, forceRefresh] = useState([]);

	let toggleClass = {};
	let dialogVariables = {};

	toggleClass['DescriptionOnly'] = mode == "description_only";
	toggleClass['ShowScepterOnly'] = mode == "show_scepter_only";

	let bShowExtra = showextradescription;

	let tAbility = CustomUIConfig.AbilitiesKv[abilityname];
	let tItem = CustomUIConfig.ItemsKv[abilityname];
	let tData = tAbility || tItem;
	let bIsItem = (tData != tAbility && tData == tItem);

	toggleClass['NoAbilityData'] = abilityname == "" || tData == undefined || tData == null;

	tData = tData || {};

	let iAbilityIndex = -1;
	if (entityindex != -1 && inventoryslot != -1) {
		iAbilityIndex = Entities.GetItemInSlot(entityindex, inventoryslot);
	} else if (entityindex != -1) {
		iAbilityIndex = Entities.GetAbilityByName(entityindex, abilityname);
	}

	let iLevel = iAbilityIndex != -1 ? Abilities.GetLevel(iAbilityIndex) : level;
	let iMaxLevel = iAbilityIndex != -1 ? Abilities.GetMaxLevel(iAbilityIndex) : -1;
	let iUpgradeLevel = iAbilityIndex != -1 ? Abilities.GetHeroLevelRequiredToUpgrade(iAbilityIndex) : -1;
	let iAbilityLearnResult = iAbilityIndex != -1 ? Abilities.CanAbilityBeUpgraded(iAbilityIndex) : -1;

	if (bIsItem) {
		iLevel = iAbilityIndex == -1 ? tData.ItemBaseLevel || 1 : iLevel;
		iMaxLevel = iAbilityIndex == -1 ? tData.MaxUpgradeLevel || 0 : iMaxLevel;
		let bIsConsumable = tData.ItemQuality == "consumable";
		toggleClass['Consumable'] = bIsConsumable;

		let iItemCost = iAbilityIndex != -1 ? Items.GetCost(iAbilityIndex) : GetItemCost(abilityname);
		let bIsSellable = iAbilityIndex != -1 ? Items.IsSellable(iAbilityIndex) : false;
		toggleClass['ShowItemCost'] = iAbilityIndex == -1 && iItemCost != 0;
		toggleClass['ShowSellPrice'] = iAbilityIndex != -1 && iItemCost != 0 && bIsSellable;
		if (toggleClass['ShowItemCost']) {
			dialogVariables['buy_cost'] = iItemCost;
			let iGold = Players.GetGold(Players.GetLocalPlayer());
			toggleClass['NotEnoughGold'] = iGold < iItemCost;
			dialogVariables['buy_cost_deficit'] = iItemCost - iGold;
		}
		if (toggleClass['ShowSellPrice']) {
			let fPurchaseTime = Items.GetPurchaseTime(iAbilityIndex);
			let bOriginalPrice = Game.GetGameTime() <= fPurchaseTime + 10
			dialogVariables['sell_price'] = bOriginalPrice ? iItemCost : iItemCost / 2;
			toggleClass['ShowSellPriceTime'] = bOriginalPrice;
			toggleClass['ShowSellPrice'] = !bOriginalPrice;
			let fTime = (Game.GetGameTime() - fPurchaseTime);
			let sStr = "";
			if (fTime <= 10) {
				fTime = parseInt((10 - fTime).toFixed(0));
				let sMinute = (Math.floor(fTime / 60)).toString();
				let sSecond = (fTime % 60).toString();
				if (sSecond.length == 1) sSecond = "0" + sSecond;
				sStr = sMinute + ":" + sSecond;
			}
			dialogVariables['sell_time'] = sStr;
		}
	}

	dialogVariables['level'] = iLevel.toString();

	let iBehavior = iAbilityIndex != -1 ? Abilities.GetBehavior(iAbilityIndex) : SBehavior2IBehavior(tData.AbilityBehavior || "");
	let sCastType = getCastType(iBehavior);
	dialogVariables['casttype'] = $.Localize(sCastType);

	let iTeam = iAbilityIndex != -1 ? Abilities.GetAbilityTargetTeam(iAbilityIndex) : STeam2ITeam(tData.AbilityUnitTargetTeam || "");
	let iType = iAbilityIndex != -1 ? Abilities.GetAbilityTargetType(iAbilityIndex) : SType2IType(tData.AbilityUnitTargetType || "");
	let sTargetType = getTargetType(iTeam, iType);
	dialogVariables['targettype'] = $.Localize(sTargetType);

	let iDamageType = iAbilityIndex != -1 ? Abilities.GetAbilityDamageType(iAbilityIndex) : SDamageType2IDamageType(tData.AbilityUnitDamageType || "");
	let sDamageType = getDamageType(iDamageType);
	dialogVariables['damagetype'] = $.Localize(sDamageType);

	let iSpellImmunityType = SSpellImmunityType2ISpellImmunityType(tData.SpellImmunityType || "");
	let sSpellImmunity = getSpellImmunity(iSpellImmunityType);
	dialogVariables['spellimmunity'] = $.Localize(sSpellImmunity);

	let sSpellDispellableType = tData.SpellDispellableType || "";
	let sDispelType = getDispelType(sSpellDispellableType);
	dialogVariables['dispeltype'] = $.Localize(sDispelType);

	let bIsActive = isActive(iBehavior);
	let iActiveDescriptionLine = tData.ActiveDescriptionLine || 1;

	let sLore = "DOTA_Tooltip_ability_" + abilityname + "_Lore";
	dialogVariables['lore'] = $.Localize(sLore);

	toggleClass['ScepterUpgradable'] = !bIsItem && (tData.HasScepterUpgrade ? tData.HasScepterUpgrade == 1 : false);
	if (toggleClass['ScepterUpgradable']) {
		let sScepterUpgradeDescription = $.Localize("DOTA_Tooltip_ability_" + abilityname + "_aghanim_description");
		if (sScepterUpgradeDescription != "DOTA_Tooltip_ability_" + abilityname + "_aghanim_description") {
			sScepterUpgradeDescription = replaceValues(sScepterUpgradeDescription, showextradescription, abilityname, iLevel, entityindex);
			dialogVariables['scepter_upgrade_description'] = sScepterUpgradeDescription;
		}
	}

	let sExtraDescription = "";
	let iMaxNote = 13;
	for (let i = 0; i < iMaxNote; i++) {
		let sNote = "DOTA_Tooltip_ability_" + abilityname + "_note" + i;
		if ($.Localize(sNote) != sNote) {
			if (sExtraDescription != "") sExtraDescription = sExtraDescription + "<br>";
			sExtraDescription = sExtraDescription + $.Localize(sNote);
		}
	}
	if (bIsItem) {
		let sItemDispelType = getItemDispelType(sSpellDispellableType);
		if (sItemDispelType != "") {
			if (sExtraDescription != "") sExtraDescription = sExtraDescription + "<br>";
			sExtraDescription = sExtraDescription + $.Localize(sItemDispelType);
		}
	}
	sExtraDescription = replaceValues(sExtraDescription, showextradescription, abilityname, iLevel, entityindex);
	dialogVariables['extradescription'] = sExtraDescription;

	// 属性
	let aValueNames = GetSpecialNames(abilityname, entityindex);
	let sAttributes = "";
	let sExtraAttributes = "";
	for (let i = 0; i < aValueNames.length; i++) {
		const sValueName = aValueNames[i];
		let bRequiresScepter = (GetSpecialValueProperty(abilityname, sValueName, "RequiresScepter", entityindex) || 0) == 1;
		if (bRequiresScepter && entityindex != -1 && !Entities.HasScepter(entityindex)) {
			continue;
		}
		let sValueDescription = "DOTA_Tooltip_ability_" + abilityname + "_" + sValueName;
		switch (sValueName) {
			case "abilitydamage":
				var aValues = StringToValues(tData.AbilityDamage || "");
				sValueDescription = "AbilityDamage";
				if (aValues.length == 0 || (aValues.length == 1 && aValues[0] == 0)) sValueDescription = "";
				break;
		}

		let sValueLocalize = $.Localize(sValueDescription);
		if (sValueLocalize != sValueDescription) {
			let bHasPercentSign = sValueLocalize.search(/%/g) == 0;
			if (bHasPercentSign) {
				sValueLocalize = sValueLocalize.substr(1);
			}

			let bHasPlusSign = sValueLocalize.search(/\+/g) == 0;
			if (bHasPlusSign) {
				sValueLocalize = sValueLocalize.substr(1);

				if (sAttributes != "") sAttributes = sAttributes + "<br>";
				if (bRequiresScepter) sAttributes = sAttributes + "<span class='ScepterUpgrade'>";

				sAttributes = sAttributes + "+";
				sAttributes = sAttributes + " %" + sValueName + "%";
				if (bHasPercentSign) {
					sAttributes = sAttributes + "%";
				}
				sAttributes = sAttributes + " ";
				let aVariables = sValueLocalize.match(/\$(.+?)\b/g);
				if (aVariables) {
					for (const block of aVariables) {
						let sVariable = block.substr(1);
						let sVariableLocalize = $.Localize("dota_ability_variable_" + sVariable);
						if (sVariableLocalize != "dota_ability_variable_" + sVariable) {
							sAttributes = sAttributes + sVariableLocalize;
						}
					}
				} else {
					sAttributes = sAttributes + sValueLocalize;
				}

				if (bRequiresScepter) sAttributes = sAttributes + "</span>";
			} else {
				if (sExtraAttributes != "") sExtraAttributes = sExtraAttributes + "<br>";
				if (bRequiresScepter) sExtraAttributes = sExtraAttributes + "<span class='ScepterUpgrade'>";

				sExtraAttributes = sExtraAttributes + sValueLocalize;
				sExtraAttributes = sExtraAttributes + " %" + sValueName + "%";
				if (bHasPercentSign) {
					sExtraAttributes = sExtraAttributes + "%";
				}

				if (bRequiresScepter) sExtraAttributes = sExtraAttributes + "</span>";
			}
		}
	}
	sAttributes = replaceValues(sAttributes, showextradescription, abilityname, bIsItem ? iLevel : (iLevel != -1 ? iLevel : 0), entityindex);
	dialogVariables['attributes'] = sAttributes;

	sExtraAttributes = replaceValues(sExtraAttributes, showextradescription, abilityname, bIsItem ? iLevel : (iLevel != -1 ? iLevel : 0), entityindex);
	dialogVariables['extra_attributes'] = sExtraAttributes;

	// TODO: 冷却和魔耗的无效数据待处理
	let fCurrentCooldown = iAbilityIndex != -1 ? Abilities.GetLevelCooldown(iAbilityIndex) : 0;
	fCurrentCooldown = CalcSpecialValueUpgrade(entityindex, abilityname, "cooldown", fCurrentCooldown)
	let fCurrentManaCost = iAbilityIndex != -1 ? Abilities.GetLevelManaCost(iAbilityIndex) : 0;
	fCurrentManaCost = CalcSpecialValueUpgrade(entityindex, abilityname, "mana_cost", fCurrentManaCost)
	let aCooldowns = StringToValues(tData.AbilityCooldown || "");
	for (let i = 0; i < Math.max(aCooldowns.length, iMaxLevel); i++) {
		let v = iAbilityIndex != -1 ? Abilities.GetLevelCooldown(iAbilityIndex, i) : (aCooldowns[i] || 0);
		aCooldowns[i] = CalcSpecialValueUpgrade(entityindex, abilityname, "cooldown", v);
	}
	aCooldowns = SimplifyValuesArray(aCooldowns);
	let aManaCosts = StringToValues(tData.AbilityManaCost || "");
	for (let i = 0; i < Math.max(aManaCosts.length, iMaxLevel); i++) {
		let v = iAbilityIndex != -1 ? Abilities.GetLevelManaCost(iAbilityIndex, i) : (aManaCosts[i] || 0);
		aManaCosts[i] = CalcSpecialValueUpgrade(entityindex, abilityname, "mana_cost", v);
	}
	aManaCosts = SimplifyValuesArray(aManaCosts);

	if (iAbilityIndex == -1 && bIsItem) {
		fCurrentCooldown = aCooldowns[iLevel - 1] || 0;
		fCurrentManaCost = aManaCosts[iLevel - 1] || 0;
	}

	let fCooldownReduction = entityindex != -1 ? Entities.GetCooldownReduction(entityindex) * 0.01 : 0;
	fCurrentCooldown = Float(fCurrentCooldown * (1 - fCooldownReduction * 0.01));

	// 冷却时间
	let sCooldownDescription = "";
	if (!(aCooldowns.length == 0 || (aCooldowns.length == 1 && aCooldowns[0] == 0))) {
		for (let level = 0; level < aCooldowns.length; level++) {
			const value = Float(aCooldowns[level] * (1 - fCooldownReduction * 0.01));
			if (sCooldownDescription != "") {
				sCooldownDescription = sCooldownDescription + " / ";
			}
			let sValue = Round(Math.abs(value), 2) + "";
			if (iLevel != -1 && (level + 1 == Math.min(iLevel, aCooldowns.length))) {
				sValue = "<span class='GameplayVariable'>" + sValue + "</span>";
			}
			sCooldownDescription = sCooldownDescription + sValue;
		}
	}
	if (sCooldownDescription != "") {
		sCooldownDescription = "<span class='GameplayValues'>" + sCooldownDescription + "</span>";
		dialogVariables['cooldown'] = sCooldownDescription;
	}

	// 魔法消耗
	let sManaCostDescription = "";
	if (!(aManaCosts.length == 0 || (aManaCosts.length == 1 && aManaCosts[0] == 0))) {
		for (let level = 0; level < aManaCosts.length; level++) {
			const value = aManaCosts[level];
			if (sManaCostDescription != "") {
				sManaCostDescription = sManaCostDescription + " / ";
			}
			let sValue = Round(Math.abs(value)) + "";
			if (iLevel != -1 && (level + 1 == Math.min(iLevel, aManaCosts.length))) {
				sValue = "<span class='GameplayVariable'>" + sValue + "</span>";
				fCurrentManaCost = value;
			}
			sManaCostDescription = sManaCostDescription + sValue;
		}
	}
	if (sManaCostDescription != "") {
		sManaCostDescription = "<span class='GameplayValues'>" + sManaCostDescription + "</span>";
		dialogVariables['manacost'] = sManaCostDescription;
	}

	toggleClass['UsesAbilityCharges'] = false;

	// 物品等级，用中立物品的样式来显示
	let iNeutralTier = GetItemRarity(abilityname);
	if (bIsItem && iNeutralTier != -1) {
		toggleClass['IsNeutralItem'] = iNeutralTier >= 0;
		toggleClass['NeutralTier' + (iNeutralTier + 1)] = true;
		dialogVariables['neutral_item_tier_number'] = iNeutralTier + 1
	}

	if (bIsItem && iAbilityIndex != -1) {
		if (sCastType == "DOTA_ToolTip_Ability_Toggle") {
			toggleClass['ShowItemSubtitle'] = true;
			if (Abilities.GetToggleState(iAbilityIndex)) {
				dialogVariables['item_subtitle'] = $.Localize("DOTA_Aura_Inactive");
			} else {
				dialogVariables['item_subtitle'] = $.Localize("DOTA_Aura_Active");
			}
		} else {
			let iCurrentCharges = Items.GetCurrentCharges(iAbilityIndex);
			if (Items.IsPermanent(iAbilityIndex)) {
				if (Items.AlwaysDisplayCharges(iAbilityIndex)) {
					toggleClass['ShowItemSubtitle'] = true;
					dialogVariables['item_subtitle'] = ($.Localize("DOTA_Charges")).replace(/%s1/g, iCurrentCharges);
				}
			} else if (iCurrentCharges > 0) {
				if (!Items.ForceHideCharges(iAbilityIndex)) {
					toggleClass['ShowItemSubtitle'] = true;
					dialogVariables['item_subtitle'] = ($.Localize("DOTA_StackCount")).replace(/%s1/g, iCurrentCharges);
				}
			}
		}
	}

	toggleClass['IsAbility'] = !bIsItem;
	toggleClass['Item'] = bIsItem;
	toggleClass['IsItem'] = bIsItem;

	dialogVariables['itemscepterdescription'] = "";

	toggleClass['HasCooldown'] = bIsItem && fCurrentCooldown != 0;
	toggleClass['HasManaCost'] = bIsItem && fCurrentManaCost != 0;
	dialogVariables['current_manacost'] = fCurrentManaCost.toFixed(0);
	dialogVariables['current_cooldown'] = Number(fCurrentCooldown.toFixed(2)).toString();

	dialogVariables['upgradelevel'] = iUpgradeLevel;

	let refSelf = useRef(null)

	let update = () => {
		let pSelf = refSelf.current
		if (pSelf) {
			let iAbilityIndex = -1;
			if (entityindex != -1 && inventoryslot != -1) {
				iAbilityIndex = Entities.GetItemInSlot(entityindex, inventoryslot);
			} else if (entityindex != -1) {
				iAbilityIndex = Entities.GetAbilityByName(entityindex, abilityname);
			}
			if (pSelf.BHasClass("ShowSellPriceTime")) {
				let iItemCost = iAbilityIndex != -1 ? Items.GetCost(iAbilityIndex) : GetItemCost(abilityname);

				let fPurchaseTime = Items.GetPurchaseTime(iAbilityIndex);
				let bOriginalPrice = Game.GetGameTime() <= fPurchaseTime + 10
				pSelf.SetDialogVariableInt("sell_price", bOriginalPrice ? iItemCost : iItemCost / 2);
				pSelf.SetHasClass("ShowSellPriceTime", bOriginalPrice);
				pSelf.SetHasClass("ShowSellPrice", !bOriginalPrice);
				let fTime = (Game.GetGameTime() - fPurchaseTime);
				let sStr = "";
				if (fTime <= 10) {
					fTime = parseInt((10 - fTime).toFixed(0));
					let sMinute = (Math.floor(fTime / 60)).toString();
					let sSecond = (fTime % 60).toString();
					if (sSecond.length == 1) sSecond = "0" + sSecond;
					sStr = sMinute + ":" + sSecond;
				}
				pSelf.SetDialogVariable("sell_time", sStr);
			}
			if (pSelf.BHasClass("ShowItemCost")) {
				let iItemCost = iAbilityIndex != -1 ? Items.GetCost(iAbilityIndex) : GetItemCost(abilityname);
				pSelf.SetDialogVariableInt('buy_cost', iItemCost);
				let iGold = Players.GetGold(Players.GetLocalPlayer());
				pSelf.SetHasClass("NotEnoughGold", iGold < iItemCost);
				pSelf.SetDialogVariableInt('buy_cost_deficit', iItemCost - iGold);
			}
		}
	}

	useEffect(() => {
		let pSelf = refSelf.current;
		if (pSelf && pSelf.IsValid()) {
			pSelf.SetHasClass("ShowSellPriceTime", toggleClass["ShowSellPriceTime"] || false);
		}

		let iScheduleHandle;
		let think = () => {
			iScheduleHandle = $.Schedule(Game.GetGameFrameTime(), think)
			update();
		}
		think();

		let listener;
		if (iAbilityIndex != -1) {
			listener = GameEvents.Subscribe("dota_ability_changed", (tEvents) => {
				if (tEvents.entityIndex == iAbilityIndex) {
					forceRefresh([]);
				}
			})
		}

		return () => {
			if (listener) {
				GameEvents.Unsubscribe(listener);
			}
			$.CancelScheduled(iScheduleHandle);
		}
	});

	return (
		<Panel className={classNames("AbilityDetails", toggleClass)} {...other} ref={refSelf} dialogVariables={dialogVariables}>
			<Panel id="Header">
				<DOTAItemImage id="ItemImage" itemname={abilityname} />

				<Panel id="HeaderLabels">
					<Panel id="AbilityHeader">
						<Label id="AbilityName" className="TitleFont" text={$.Localize("DOTA_Tooltip_ability_" + abilityname)} html={true} />
						<Label id="AbilityLevel" className={classNames({ 'Hidden': iMaxLevel <= 0 })} localizedText="#DOTA_AbilityTooltip_Level" html={true} />
					</Panel>
					<Panel id="AbilitySubHeader">
						<Label id="ItemSubtitle" localizedText="{s:item_subtitle}" />

						<Panel id="ItemAvailibilityMainShop" className="ItemAvailabilityRow">
							<Panel className="ItemAvailabilityIcon MainShopIcon" />
						</Panel>
						<Panel id="ItemAvailibilitySideShop" className="ItemAvailabilityRow">
							<Panel className="ItemAvailabilityIcon SideShopIcon" />
						</Panel>
						<Panel id="ItemAvailibilitySecretShop" className="ItemAvailabilityRow">
							<Panel className="ItemAvailabilityIcon SecretShopIcon" />
						</Panel>
						<Panel className="TopBottomFlow">
							<Label id="NeutralItemTier" html={true} localizedText="#DOTA_NeutralItemTier" />
							<Panel className="LeftRightFlow">
								<Panel id="ItemCost">
									<Panel id="ItemCostIcon" />
									<Label id="BuyCostLabel" localizedText="{d:r:buy_cost}" />
									<Label id="BuyCostDeficit" localizedText="(-{d:r:buy_cost_deficit})" />
								</Panel>
								<Panel id="StockContainer">
									<Label id="RestockTime" localizedText="#DOTA_HUD_Shop_Restock" />
									<Label id="StockAmount" localizedText="#DOTA_HUD_Shop_StockAmount" />
								</Panel>
							</Panel>
						</Panel>
					</Panel>
					<Label id="CostToComplete" localizedText="#DOTA_HUD_Shop_Item_Complete" />
				</Panel>
			</Panel>

			<Panel id="AbilityTarget">
				<Panel id="AbilityTopRowContainer">
					<Label id="AbilityCastType" className={classNames({ 'Hidden': sCastType == "" })} localizedText="#DOTA_AbilityTooltip_CastType" html={true} />
					<Panel id="CurrentAbilityCosts" className={classNames({ 'Hidden': bIsItem || (fCurrentCooldown == 0 && fCurrentManaCost == 0) })}>
						<Label id="CurrentAbilityManaCost" className={classNames("ManaCost", { 'Hidden': bIsItem || fCurrentManaCost == 0 })} localizedText="{s:current_manacost}" html={true} />
						<Label id="CurrentAbilityCooldown" className={classNames("Cooldown", { 'Hidden': bIsItem || fCurrentCooldown == 0 })} localizedText="{s:current_cooldown}" html={true} />
					</Panel>
				</Panel>
				<Label id="AbilityTargetType" className={classNames({ 'Hidden': sTargetType == "" })} localizedText="#DOTA_AbilityTooltip_TargetType" html={true} />
				<Label id="AbilityDamageType" className={classNames({ 'Hidden': sDamageType == "" })} localizedText="#DOTA_AbilityTooltip_DamageType" html={true} />
				<Label id="AbilitySpellImmunityType" className={classNames({ 'Hidden': sSpellImmunity == "" })} localizedText="#DOTA_AbilityTooltip_SpellImmunityType" html={true} />
				<Label id="AbilityDispelType" className={classNames({ 'Hidden': sDispelType == "" })} localizedText="#DOTA_AbilityTooltip_DispelType" html={true} />
			</Panel>

			<Panel id="AbilityCoreDetails">
				<Label id="AbilityAttributes" className={classNames({ 'Hidden': sAttributes == "" })} localizedText="#DOTA_AbilityTooltip_Attributes" html={true} />
				<Panel id="AbilityDescriptionOuterContainer">
					<Panel id="CurrentItemCosts" className={classNames({ 'Hidden': !bIsItem })}>
						<Label className="Cooldown" localizedText="{s:current_cooldown}" html={true} />
						<Label className="ManaCost" localizedText="{s:current_manacost}" html={true} />
					</Panel>
					<Panel id="AbilityDescriptionContainer" >
						{(() => {
							let sAllDescription = "DOTA_Tooltip_ability_" + abilityname + "_Description";
							let list = [];
							if ($.Localize(sAllDescription) != sAllDescription) {
								let aDescriptions = $.Localize(sAllDescription).split("\n");
								let iOriginalDescriptions = aDescriptions.length;

								if (entityindex != -1) {
									let t = CustomNetTables.GetTableValue("ability_upgrades_list", entityindex.toString());
									if (t && typeof (t.json) == "string") {
										t.json = t.json.replace(/null/g, `"null"`);
										let aAbilityUpgradesList
										try {
											aAbilityUpgradesList = JSON.parse(t.json);
										} catch (error) { }
										if (aAbilityUpgradesList) {
											for (let index = 1; index < aAbilityUpgradesList.length; index++) {
												let aData = aAbilityUpgradesList[index];
												let tData = upzip(aAbilityUpgradesList[0], aData);
												if (tData.type - 1 == CustomUIConfig.ABILITY_UPGRADES_TYPE_ABILITY_MECHANICS && tData.ability_name == abilityname) {
													aDescriptions.push($.Localize("dota_tooltip_ability_mechanics_" + tData.ability_name + "_" + tData.description));
												}
											}
										}
									}
								}

								let iLine = 0;
								for (let i = 0; i < aDescriptions.length; i++) {
									const sUnprocessedDescription = aDescriptions[i];
									let sDescription = sUnprocessedDescription;

									if (sDescription == "") continue;

									let regexp = new RegExp("<h1>.+?</h1>", "")
									let aHeaders = sDescription.match(regexp);
									if (aHeaders) {
										for (const sHeader of aHeaders) {
											++iLine;
											list.push(
												<Label key={list.length.toString()} className={classNames('Header', { 'Active': bIsActive && iLine == iActiveDescriptionLine })} text={sHeader} html={true} />
											)
										}
									}
									sDescription = sDescription.replace(regexp, "");
									sDescription = sDescription.replace(/%%/g, "%");

									sDescription = replaceValues(sDescription, showextradescription, abilityname, iLevel, entityindex, true);

									list.push(
										<Label key={list.length.toString()} className={classNames({ 'Active': bIsActive && iLine == iActiveDescriptionLine, 'AbilityMechanics': i >= iOriginalDescriptions })} text={sDescription} html={true} />
									)
								}
							}
							return list;
						})()}
					</Panel>
				</Panel>
				<Panel id="AbilityScepterDescriptionContainer">
					<Panel id="ScepterUpgradeHeader">
						<Panel className="ScepterSpecialAbilityDataIcon" />
						<Label className="ScepterUpgradeHeaderLabel" localizedText="#DOTA_AbilityTooltip_ScepterUpgrade_Header" />
					</Panel>
					<Label className="ScepterUpgradeBodyLabel" localizedText="{s:scepter_upgrade_description}" html={true} />
				</Panel>

				<Panel id="AbilityDraftDescriptionContainer">
					<Panel className="AbilityDraftUpgradeHeader">
						<Panel className="AbilityDraftIcon" />
						<Label className="AbilityDraftHeaderLabel" localizedText="#DOTA_AbilityTooltip_AbilityDraftNote_Header" />
					</Panel>
					<Label className="ScepterUpgradeBodyLabel" localizedText="{s:ability_draft_note}" html={true} />
				</Panel>

				<Label id="AbilityExtraDescription" className={classNames({ 'Hidden': sExtraDescription == "" })} localizedText="#DOTA_AbilityTooltip_ExtraDescription" html={true} />
				<Label id="ItemScepterDescription" className={classNames({ 'Hidden': true })} localizedText="{s:itemscepterdescription}" html={true} />
				<Label id="AbilityCharges" localizedText="#DOTA_AbilityTooltip_AbilityCharges" html={true} />
				<Label id="AbilityExtraAttributes" className={classNames({ 'Hidden': sExtraAttributes == "" })} localizedText="{s:extra_attributes}" html={true} />
				<Panel id="AbilityCosts">
					<Label id="AbilityCooldown" className={classNames("Cooldown", { 'Hidden': sCooldownDescription == "" })} localizedText="#DOTA_AbilityTooltip_Cooldown" html={true} />
					<Label id="AbilityManaCost" className={classNames("ManaCost", { 'Hidden': sManaCostDescription == "" })} localizedText="#DOTA_AbilityTooltip_ManaCost" html={true} />
				</Panel>
				<Panel id="AbilityGameplayChanges">
				</Panel>
				<Label id="AbilityLore" className={classNames({ 'Hidden': $.Localize(sLore) == sLore })} localizedText="#DOTA_AbilityTooltip_Lore" html={true} />

				<Label id="AbilityUpgradeLevel" className={classNames({ 'Hidden': iAbilityLearnResult != AbilityLearnResult_t.ABILITY_CANNOT_BE_UPGRADED_REQUIRES_LEVEL })} localizedText="#DOTA_AbilityTooltip_UpgradeLevel" html={true} />

				<Label id="OwnedBy" localizedText="#DOTA_HUD_Item_Owned_By" html={true} />

				<Label id="SellPriceLabel" localizedText="#DOTA_HUD_Item_Tooltip_Sell_Price" />
				<Label id="SellPriceTimeLabel" localizedText="#DOTA_HUD_Item_Tooltip_Sell_Price_Time" />
				<Label id="DisassembleLabel" localizedText="#DOTA_HUD_Item_Tooltip_Disassemble" />
				<Label id="DisassembleTimeLabel" localizedText="#DOTA_HUD_Item_Tooltip_Disassemble_Time" />
				<Label id="NotEnoughGoldLabel" localizedText="#DOTA_Shop_Item_Error_Cant_Afford" />
			</Panel>

			<Label id="ConsumableAbilityInfo" localizedText="#DOTA_HUD_Item_Tooltip_Consumable_Info" />
		</Panel>
	)
}