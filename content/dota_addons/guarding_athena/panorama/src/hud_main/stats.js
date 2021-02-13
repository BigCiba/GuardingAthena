"use strict";

let tSettings = CustomNetTables.GetTableValue("common", "settings");
CustomNetTables.SubscribeNetTableListener("common", () => {
	tSettings = CustomNetTables.GetTableValue("common", "settings");
});

var iAttackRangeParticleID = -1;

function ShowStatsTooltip() {
	let pStatsTooltipRegion = $("#StatsContainer");
	$.DispatchEvent("UIShowCustomLayoutTooltip", pStatsTooltipRegion, "stats_tooltip_region_tooltips", "file://{resources}/layout/custom_game/tooltips/unit_stats/unit_stats.xml");

	let iLocalPortraitUnit = Players.GetLocalPlayerPortraitUnit()
	if (iAttackRangeParticleID != -1) {
		Particles.DestroyParticleEffect(iAttackRangeParticleID, false);
		iAttackRangeParticleID = -1;
	}
	let fRange = Entities.GetAttackRange(iLocalPortraitUnit) + Entities.GetHullRadius(iLocalPortraitUnit);
	iAttackRangeParticleID = Particles.CreateParticle("particles/ui_mouseactions/range_display.vpcf", ParticleAttachment_t.PATTACH_ABSORIGIN_FOLLOW, iLocalPortraitUnit);
	Particles.SetParticleControl(iAttackRangeParticleID, 1, [fRange, fRange, fRange]);
}

function HideStatsTooltip() {
	let pStatsTooltipRegion = $("#StatsContainer");
	$.DispatchEvent("UIHideCustomLayoutTooltip", pStatsTooltipRegion, "stats_tooltip_region_tooltips");

	if (iAttackRangeParticleID != -1) {
		Particles.DestroyParticleEffect(iAttackRangeParticleID, false);
		iAttackRangeParticleID = -1;
	}
}


(function () {
	let pStatsContainer = $("#StatsContainer")

	pStatsContainer.SetPanelEvent("onmouseover", ShowStatsTooltip);
	pStatsContainer.SetPanelEvent("onmouseout", HideStatsTooltip);

	function updateBonus(p, sVariableName, fValue, iRetained = 0) {
		let iLocalPortraitUnit = Players.GetLocalPlayerPortraitUnit()

		if (IsNull(p.iUnit)) p.iUnit = -1;

		if (!IsNull(p.fValue) && p.fValue == fValue) return;

		if (IsNull(p.fSmoothValue)) p.fSmoothValue = 0;

		if (fValue <= p.fSmoothValue || IsNull(p.fValue) || iLocalPortraitUnit != p.iUnit) {
			if (!IsNull(p.iAnimatingUpSchedule)) {
				$.CancelScheduled(p.iAnimatingUpSchedule);
				p.iAnimatingUpSchedule = undefined;
			}

			let sSign = fValue == 0 ? "" : (fValue > 0 ? "+" : "-");
			let sValue;

			if (sSign == "") {
				sValue = "";
			}
			else if (sSign == "+") {
				sValue = sSign + fValue.toFixed(iRetained);
			}
			else {
				sValue = fValue.toFixed(iRetained);
			}
			p.SetHasClass("StatPositive", sSign == "+")
			p.SetHasClass("StatNegative", sSign == "-")

			p.SetDialogVariable(sVariableName, sValue);

			p.fSmoothValue = fValue;
			p.RemoveClass("AnimatingUp");
		} else {
			if (!IsNull(p.iAnimatingUpSchedule)) {
				$.CancelScheduled(p.iAnimatingUpSchedule);
				p.iAnimatingUpSchedule = undefined;
			}

			p.AddClass("AnimatingUp");

			let fSpeed = 50;
			let fStartValue = p.fValue;
			let fEndValue = fValue;
			let fStartTime = Game.Time();
			let fEndTime = Game.Time() + Clamp(Math.abs(fEndValue-fStartValue)/fSpeed, 0, 0.5);
			let func = () => {
				let fTime = Game.Time();
				p.fSmoothValue = RemapValClamped(fTime, fStartTime, fEndTime, fStartValue, fEndValue);

				let sSign = p.fSmoothValue == 0 ? "" : (p.fSmoothValue > 0 ? "+" : "-");
				let sValue;

				if (sSign == "") {
					sValue = "";
				}
				else if (sSign == "+") {
					sValue = sSign + p.fSmoothValue.toFixed(iRetained);
				}
				else {
					sValue = p.fSmoothValue.toFixed(iRetained);
				}
				p.SetHasClass("StatPositive", sSign == "+")
				p.SetHasClass("StatNegative", sSign == "-")

				p.SetDialogVariable(sVariableName, sValue);

				if (fTime < fEndTime) {
					p.iAnimatingUpSchedule = $.Schedule(Game.GetGameFrameTime(), func);
				} else {
					p.RemoveClass("AnimatingUp")
					p.iAnimatingUpSchedule = undefined;
					p.fSmoothValue = p.fValue;
				}
			}
			p.iAnimatingUpSchedule = $.Schedule(Game.GetGameFrameTime(), func);
		}
		p.fValue = fValue;
		p.iUnit = iLocalPortraitUnit;
	}

	Timer("stats", 1/30, () => {
		let iLocalPortraitUnit = Players.GetLocalPlayerPortraitUnit()

		if (iLocalPortraitUnit == -1) return 1/30;

		Entities._updateUnitState(iLocalPortraitUnit);

		pStatsContainer.SetHasClass("ShowDamageArmorMovement", true)

		// 攻击力
		{
			let pDamage = pStatsContainer.FindChildTraverse("Damage");

			pDamage.SetHasClass("ShowSplitLabels", true)

			let fBonusDamage = Entities.GetDamageBonus(iLocalPortraitUnit);
			let fMinDamage = Entities.GetDamageMax(iLocalPortraitUnit);
			let fMaxDamage = Entities.GetDamageMin(iLocalPortraitUnit);
			let fBaseDamage = (fMinDamage + fMaxDamage) / 2;

			pDamage.SetDialogVariable("combined_damage", (fBaseDamage + fBonusDamage).toFixed(0));
			pDamage.SetDialogVariableInt("damage", fBaseDamage);
			updateBonus(pDamage.FindChildTraverse("DamageModifierLabel"), "bonus_damage", fBonusDamage);
		}
		// 物理防御
		{
			let pPhysicalArmor = pStatsContainer.FindChildTraverse("PhysicalArmor");

			pPhysicalArmor.SetHasClass("ShowSplitLabels", true)

			let fPhysicalArmor = Entities.GetPhysicalArmor(iLocalPortraitUnit);
			let fBasePhysicalArmor = Entities.GetBasePhysicalArmor(iLocalPortraitUnit);
			let fBonusPhysicalArmor = fPhysicalArmor - fBasePhysicalArmor;
			let fPhysicalArmorReduction = (() => {
				let iSign = fPhysicalArmor >= 0 ? 1 : -1
				return iSign * tSettings.PHYSICAL_ARMOR_FACTOR * Math.abs(fPhysicalArmor) / (1 + tSettings.PHYSICAL_ARMOR_FACTOR * Math.abs(fPhysicalArmor))
			})();

			pPhysicalArmor.SetDialogVariable("combined_physical_armor", fPhysicalArmor.toFixed(0));
			pPhysicalArmor.SetDialogVariable("physical_armor", fBasePhysicalArmor.toFixed(0));
			pPhysicalArmor.SetDialogVariableInt("physical_resistance", parseInt((fPhysicalArmorReduction * 100).toFixed(0)));

			updateBonus(pPhysicalArmor.FindChildTraverse("PhysicalArmorModifierLabel"), "bonus_physical_armor", fBonusPhysicalArmor)
		}
		// 魔法防御
		{
			let pMagicalArmor = pStatsContainer.FindChildTraverse("MagicalArmor");

			pMagicalArmor.SetHasClass("ShowSplitLabels", true)

			let fMagicalArmor = Entities.GetMagicalArmor(iLocalPortraitUnit);
			let fBaseMagicalArmor = Entities.GetBaseMagicalArmor(iLocalPortraitUnit);
			let fBonusMagicalArmor = fMagicalArmor - fBaseMagicalArmor;
			let fMagicalArmorReduction = (() => {
				let iSign = fMagicalArmor >= 0 ? 1 : -1
				return iSign * tSettings.MAGICAL_ARMOR_FACTOR * Math.abs(fMagicalArmor) / (1 + tSettings.MAGICAL_ARMOR_FACTOR * Math.abs(fMagicalArmor))
			})();

			pMagicalArmor.SetDialogVariable("combined_magical_armor", fMagicalArmor.toFixed(0));
			pMagicalArmor.SetDialogVariable("magical_armor", fBaseMagicalArmor.toFixed(0));
			pMagicalArmor.SetDialogVariableInt("magical_resistance", parseInt((fMagicalArmorReduction * 100).toFixed(0)));

			updateBonus(pMagicalArmor.FindChildTraverse("MagicalArmorModifierLabel"), "bonus_magical_armor", fBonusMagicalArmor)
		}
		// 移动速度
		{
			let pMoveSpeed = pStatsContainer.FindChildTraverse("MoveSpeed");

			pMoveSpeed.SetHasClass("ShowSplitLabels", pMoveSpeed.BAscendantHasClass("AltPressed"))

			let fBaseMoveSpeed = Entities.GetBaseMoveSpeed(iLocalPortraitUnit);
			let fBonusMoveSpeed = Entities.GetMoveSpeedModifier(iLocalPortraitUnit, fBaseMoveSpeed) - fBaseMoveSpeed;

			pMoveSpeed.SetDialogVariable("combined_move_speed", (fBaseMoveSpeed + fBonusMoveSpeed).toFixed(0));
			pMoveSpeed.SetDialogVariableInt("base_move_speed", fBaseMoveSpeed);

			updateBonus(pMoveSpeed.FindChildTraverse("MoveSpeedModifierLabel"), "bonus_move_speed", fBonusMoveSpeed)
		}

		pStatsContainer.SetHasClass("ShowStrAgiInt", Entities.HasHeroAttribute(iLocalPortraitUnit))

		if (Entities.HasHeroAttribute(iLocalPortraitUnit)) {
			// 力量
			{
				let pStrength = pStatsContainer.FindChildTraverse("Strength");

				pStrength.SetHasClass("ShowSplitLabels", true)

				let iStrength = Entities.GetStrength(iLocalPortraitUnit);
				let iBaseStrength = Entities.GetBaseStrength(iLocalPortraitUnit);
				let iBonusStrength = iStrength - iBaseStrength;

				pStrength.SetDialogVariable("strength", iBaseStrength.toFixed(0));
				updateBonus(pStrength.FindChildTraverse("StrengthModifierLabel"), "strength_bonus", iBonusStrength);
			}
			// 敏捷
			{
				let pAgility = pStatsContainer.FindChildTraverse("Agility");

				pAgility.SetHasClass("ShowSplitLabels", true)

				let iAgility = Entities.GetAgility(iLocalPortraitUnit);
				let iBaseAgility = Entities.GetBaseAgility(iLocalPortraitUnit);
				let iBonusAgility = iAgility - iBaseAgility;

				pAgility.SetDialogVariable("agility", iBaseAgility.toFixed(0));
				updateBonus(pAgility.FindChildTraverse("AgilityModifierLabel"), "agility_bonus", iBonusAgility);
			}
			// 智力
			{
				let pIntellect = pStatsContainer.FindChildTraverse("Intellect");

				pIntellect.SetHasClass("ShowSplitLabels", true)

				let iIntellect = Entities.GetIntellect(iLocalPortraitUnit);
				let iBaseIntellect = Entities.GetBaseIntellect(iLocalPortraitUnit);
				let iBonusIntellect = iIntellect - iBaseIntellect;

				pIntellect.SetDialogVariable("intellect", iBaseIntellect.toFixed(0));
				updateBonus(pIntellect.FindChildTraverse("IntellectModifierLabel"), "intellect_bonus", iBonusIntellect);
			}
		}

		return 1/30;
	});
})();