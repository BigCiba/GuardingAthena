let pOverheadContainer = $("#OverheadContainer");

function UpdateOverhead() {
	let iLocalPlayerID = Players.GetLocalPlayer();
	let iCursorEntIndex = GameUI.GetCursorEntity();
	let tHeroes = Entities.GetAllHeroEntities();


	for (let i = 0; i < tHeroes.length; i++) {
		const iHeroIndex = tHeroes[i];

		if (!Entities.IsValidEntity(iHeroIndex)) continue;

		let vOrigin = Entities.GetAbsOrigin(iHeroIndex);
		let fScreenX = Game.WorldToScreenX(vOrigin[0], vOrigin[1], vOrigin[2]);
		let fScreenY = Game.WorldToScreenY(vOrigin[0], vOrigin[1], vOrigin[2]);
		if (fScreenX < 0 || fScreenX > Game.GetScreenWidth() || fScreenY < 0 || fScreenY > Game.GetScreenHeight()) continue;

		let bControllable = Entities.IsControllableByPlayer(iUnitEntIndex, iLocalPlayerID);

		let pPanel = pBuildingOverheadContainer.GetChild(index);
		if (pPanel == null || pPanel == undefined) {
			pPanel = $.CreatePanel("Panel", pBuildingOverheadContainer, "");
			pPanel.BLoadLayoutSnippet("BuildingOverhead");
		}
	}
	let index = 0;
	for (const sKey in tBuildings) {
		const iUnitEntIndex = parseInt(sKey);
		const tInfo = tBuildings[sKey];

		if (!Entities.IsValidEntity(iUnitEntIndex)) continue;

		let vOrigin = Entities.GetAbsOrigin(iUnitEntIndex);
		let fScreenX = Game.WorldToScreenX(vOrigin[0], vOrigin[1], vOrigin[2]);
		let fScreenY = Game.WorldToScreenY(vOrigin[0], vOrigin[1], vOrigin[2]);
		if (fScreenX < 0 || fScreenX > Game.GetScreenWidth() || fScreenY < 0 || fScreenY > Game.GetScreenHeight()) continue;

		let bControllable = Entities.IsControllableByPlayer(iUnitEntIndex, iLocalPlayerID);

		let pPanel = pBuildingOverheadContainer.GetChild(index);
		if (pPanel == null || pPanel == undefined) {
			pPanel = $.CreatePanel("Panel", pBuildingOverheadContainer, "");
			pPanel.BLoadLayoutSnippet("BuildingOverhead");
		}

		pPanel.RemoveClass("Hidden");

		pPanel.iUnitEntIndex = iUnitEntIndex;
		pPanel.tInfo = tInfo;

		let sUnitName = tInfo.sName;
		let iPlayerOwnerID = Entities.GetPlayerOwnerID(iUnitEntIndex);

		pPanel.SetHasClass("is_owner", iPlayerOwnerID == iLocalPlayerID);

		let fOffset = Entities.GetHealthBarOffset(iUnitEntIndex);
		fOffset = fOffset == -1 ? 100 : fOffset;
		let fX = Game.WorldToScreenX(vOrigin[0], vOrigin[1], vOrigin[2] + fOffset);
		let fY = Game.WorldToScreenY(vOrigin[0], vOrigin[1], vOrigin[2] + fOffset);
		pPanel.SetPositionInPixels(GameUI.CorrectPositionValue(fX - pPanel.actuallayoutwidth / 2), GameUI.CorrectPositionValue(fY - pPanel.actuallayoutheight), 0);

		if (iCursorEntIndex != -1) pPanel.SetHasClass("UpperLevel", iUnitEntIndex == iCursorEntIndex);
		pPanel.SetHasClass("IsCursor", iUnitEntIndex == iCursorEntIndex);

		let iQualificationLevel = Math.min(tInfo.iQualificationLevel, 7);
		pPanel.SetHasClass("Star1", iQualificationLevel == 3);
		pPanel.SetHasClass("Star2", iQualificationLevel == 4);
		pPanel.SetHasClass("Star3", iQualificationLevel == 5);
		pPanel.SetHasClass("Star4", iQualificationLevel == 6);
		pPanel.SetHasClass("Star5", iQualificationLevel == 7);

		let sRarity = GetCardRarity(sUnitName);
		pPanel.SetHasClass("rarity_n", sRarity == "n");
		pPanel.SetHasClass("rarity_r", sRarity == "r");
		pPanel.SetHasClass("rarity_sr", sRarity == "sr");
		pPanel.SetHasClass("rarity_ssr", sRarity == "ssr");

		pPanel.SetDialogVariable("unit_name", $.Localize(sUnitName));

		let fManaPercent = Entities.GetMana(iUnitEntIndex) / Entities.GetMaxMana(iUnitEntIndex);
		pPanel.FindChildTraverse("ManaProgress").value = fManaPercent;

		let fHealthPercent = Entities.GetHealth(iUnitEntIndex) / Entities.GetMaxHealth(iUnitEntIndex);
		pPanel.FindChildTraverse("HealthProgress").value = fHealthPercent;

		let iLevel = Entities.GetLevel(iUnitEntIndex);
		pPanel.FindChildTraverse("LevelLabel").text = iLevel;

		let fXPPercent = 0;
		let iLevelXP = 0;
		let iLevelNeedXP = 0;
		let iXP = tInfo.iCurrentXP || 0;
		let iNeedXP = tInfo.iNeededXPToLevel || 0;
		if (Entities.GetUnitLabel(iUnitEntIndex) != "HERO") {
			if (sUnitName == "t35") {
				iLevelXP = (iXP - T35XpPerLevelTable[String(iLevel)]);
				iLevelNeedXP = (iNeedXP - T35XpPerLevelTable[String(iLevel)]);
			} else {
				iLevelXP = (iXP - NonheroXpPerLevelTable[String(iLevel)]);
				iLevelNeedXP = (iNeedXP - NonheroXpPerLevelTable[String(iLevel)]);
			}
		} else {
			iLevelXP = (iXP - HeroXpPerLevelTable[String(iLevel)]);
			iLevelNeedXP = (iNeedXP - HeroXpPerLevelTable[String(iLevel)]);
		}
		if (iNeedXP == 0) {
			fXPPercent = 1;
		} else {
			fXPPercent = iLevelXP / iLevelNeedXP;
		}
		if (fXPPercent == 1) {
			pPanel.FindChildTraverse("LevelLabel").text = $.Localize("Level_Max");
		}
		pPanel.FindChildTraverse("CircularXPProgress").value = fXPPercent;
		pPanel.FindChildTraverse("CircularXPProgressBlur").value = fXPPercent;

		pPanel.SetHasClass("HasAbilityToSpend", false);
		if (bControllable) {
			let iStar = iQualificationLevel - 2;
			let n = 0;
			let bCanSelected = true;
			let bHasAbilityToSpend = false;
			for (let index = 0; index < Entities.GetAbilityCount(iUnitEntIndex); index++) {
				let iAbility = Entities.GetAbility(iUnitEntIndex, index);
				if (iAbility != -1 && !Abilities.IsHidden(iAbility)) {
					let canLevelUp = tInfo.iAbilityPoints > 0 && Abilities.GetAbilityType(iAbility) != ABILITY_TYPES.ABILITY_TYPE_ATTRIBUTES && Entities.GetLevel(iUnitEntIndex) >= Abilities.GetHeroLevelRequiredToUpgrade(iAbility) && Abilities.CanAbilityBeUpgraded(iAbility) != AbilityLearnResult_t.ABILITY_NOT_LEARNABLE;
					if (canLevelUp) {
						bHasAbilityToSpend = true;
						break;
					}
				}
				if (iAbility != -1 && Abilities.GetAbilityName(iAbility).indexOf("special_bonus_") != -1) {
					let iLevel = Abilities.GetLevel(iAbility);

					let bDisabled = (iStar <= (Math.floor(n / 2) + 1)) || !bControllable;
					let BranchChosen = iLevel > 0;
					bCanSelected = bCanSelected && (!bDisabled && !BranchChosen);

					++n;
					if (n % 2 == 0) {
						bHasAbilityToSpend = bHasAbilityToSpend || bCanSelected;
						bCanSelected = true;
						if (bHasAbilityToSpend) {
							break;
						}
					}
				}
			}
			pPanel.SetHasClass("HasAbilityToSpend", bHasAbilityToSpend);
		}

		pPanel.SetHasClass("no_health_bar", Entities.HasBuff(iUnitEntIndex, "modifier_no_health_bar"));

		let n = 0;
		let tQualificationAbilities = tInfo.tQualificationAbilities;
		if (tQualificationAbilities) {
			for (const key in tQualificationAbilities) {
				let sQualificationAbility = tQualificationAbilities[key];
				let sCardName = GetCardNameByQualificationAbility(sQualificationAbility);
				let sUnitRarity = GetCardRarity(sCardName);

				let pImage = pPanel.FindChildTraverse("BuildingQualificationAbilities").GetChild(n);
				if (pImage == undefined || pImage == null) {
					pImage = $.CreatePanel("Image", pPanel.FindChildTraverse("BuildingQualificationAbilities"), "");
				}

				pImage.AddClass("UnitIcon");

				pImage.SetHasClass("rarity_n", sUnitRarity == "n");
				pImage.SetHasClass("rarity_r", sUnitRarity == "r");
				pImage.SetHasClass("rarity_sr", sUnitRarity == "sr");
				pImage.SetHasClass("rarity_ssr", sUnitRarity == "ssr");

				pImage.SetImage(GetCardIcon(sCardName));

				pImage.RemoveClass("Hidden");

				++n;
			}
		}
		for (let i = n; i < pPanel.FindChildTraverse("BuildingQualificationAbilities").GetChildCount(); i++) {
			let pImage = pPanel.FindChildTraverse("BuildingQualificationAbilities").GetChild(i);
			pImage.AddClass("Hidden");
		}

		++index;
	}
	for (let i = index; i < pBuildingOverheadContainer.GetChildCount(); i++) {
		let pPanel = pBuildingOverheadContainer.GetChild(i);
		pPanel.AddClass("Hidden");
	}
}

function Update() {
	$.Schedule(Game.GetGameFrameTime(), Update);

	UpdateOverhead();
}

(function () {
	pOverheadContainer.RemoveAndDeleteChildren();
	Update();
})();