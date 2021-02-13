"use strict";

let tSettings = CustomNetTables.GetTableValue("common", "settings");
CustomNetTables.SubscribeNetTableListener("common", () => {
	tSettings = CustomNetTables.GetTableValue("common", "settings");
});

let pSelf = $.GetContextPanel()

pSelf.SetPanelEvent("ontooltiploaded", () => {
	let iLocalPortraitUnit = Players.GetLocalPlayerPortraitUnit();

	Entities._updateUnitState(iLocalPortraitUnit);

	pSelf.SetHasClass("Hero", Entities.HasHeroAttribute(iLocalPortraitUnit));

	let sUnitName = Entities.GetUnitName(iLocalPortraitUnit);
	let tData = CustomUIConfig.UnitsKv[sUnitName] || CustomUIConfig.HeroesKv[sUnitName];
	let fExtraBaseHealthRegen = 0;
	let fExtraBaseManaRegen = 0;

	if (Entities.HasHeroAttribute(iLocalPortraitUnit)) {
		var iPrimaryAttribute = Entities.GetPrimaryAttribute(iLocalPortraitUnit);

		pSelf.FindChildTraverse("StrengthContainer").SetHasClass("PrimaryAttribute", iPrimaryAttribute == Attributes.DOTA_ATTRIBUTE_STRENGTH);
		pSelf.FindChildTraverse("AgilityContainer").SetHasClass("PrimaryAttribute", iPrimaryAttribute == Attributes.DOTA_ATTRIBUTE_AGILITY);
		pSelf.FindChildTraverse("IntellectContainer").SetHasClass("PrimaryAttribute", iPrimaryAttribute == Attributes.DOTA_ATTRIBUTE_INTELLECT);

		let fStrengthGain = (tData && tData.StrengthGain) ? Float(tData.StrengthGain) : 0;
		let fAgilityGain = (tData && tData.AgilityGain) ? Float(tData.AgilityGain) : 0;
		let fIntellectGain = (tData && tData.IntellectGain) ? Float(tData.IntellectGain) : 0;
		pSelf.SetDialogVariable("strength_per_level", fStrengthGain)
		pSelf.SetDialogVariable("agility_per_level", fAgilityGain)
		pSelf.SetDialogVariable("intelligence_per_level", fIntellectGain)

		// 力量
		{
			let pStrength = pSelf.FindChildTraverse("StrengthContainer");

			let iStrength = Entities.GetStrength(iLocalPortraitUnit);
			let iBaseStrength = Entities.GetBaseStrength(iLocalPortraitUnit);
			let iBonusStrength = iStrength - iBaseStrength;
			let sSign = iBonusStrength == 0 ? "" : (iBonusStrength > 0 ? "+" : "-");
			let sBonusStrength;

			if (sSign == "") {
				sBonusStrength = "";
			}
			else if (sSign == "+") {
				sBonusStrength = sSign + iBonusStrength.toFixed(0);
			}
			else {
				sBonusStrength = iBonusStrength.toFixed(0);
			}

			pStrength.SetDialogVariableInt("base_strength", iBaseStrength);
			pStrength.SetDialogVariable("bonus_strength", sBonusStrength);
			pStrength.SetDialogVariableInt("strength_hp", iStrength * tSettings.ATTRIBUTE_STRENGTH_HP);
			pStrength.SetDialogVariable("strength_hp_regen", Float(iStrength * Float(tSettings.ATTRIBUTE_STRENGTH_HP_REGEN)));
			pStrength.SetDialogVariableInt("primary_attribute_damage", Math.floor(Float(iStrength * Float(tSettings.ATTRIBUTE_PRIMARY_ATTACK_DAMAGE))));
			pStrength.SetHasClass("NegativeValue", sSign == "-");
			pStrength.SetHasClass("NoBonus", sSign == "");
			fExtraBaseHealthRegen += Float(iStrength * Float(tSettings.ATTRIBUTE_STRENGTH_HP_REGEN));
		}

		// 敏捷
		{
			let pAgility = pSelf.FindChildTraverse("AgilityContainer");

			let iAgility = Entities.GetAgility(iLocalPortraitUnit);
			let iBaseAgility = Entities.GetBaseAgility(iLocalPortraitUnit);
			let iBonusAgility = iAgility - iBaseAgility;
			let sSign = iBonusAgility == 0 ? "" : (iBonusAgility > 0 ? "+" : "-");
			let sBonusAgility;

			if (sSign == "") {
				sBonusAgility = "";
			}
			else if (sSign == "+") {
				sBonusAgility = sSign + iBonusAgility.toFixed(0);
			}
			else {
				sBonusAgility = iBonusAgility.toFixed(0);
			}

			// var fAgiCooldownReductionPercent = (1 - Math.pow(1 - Float(tSettings.attribute_agility_cooldown_reduction_percent) * 0.01, iAgility)) * Float(tSettings.attribute_agility_cooldown_reduction_max);

			pAgility.SetDialogVariableInt("base_agility", iBaseAgility);
			pAgility.SetDialogVariable("bonus_agility", sBonusAgility);
			pAgility.SetDialogVariableInt("agility_attack_speed", Float(iAgility * Float(tSettings.ATTRIBUTE_AGILITY_ATTACK_SPEED)));
			pAgility.SetDialogVariable("agility_armor", Round(Float(iAgility * Float(tSettings.ATTRIBUTE_AGILITY_ARMOR)), 1));
			pAgility.SetDialogVariableInt("primary_attribute_damage", Math.floor(Float(iAgility * tSettings.ATTRIBUTE_PRIMARY_ATTACK_DAMAGE)));
			pAgility.SetHasClass("NegativeValue", sSign == "-");
			pAgility.SetHasClass("NoBonus", sSign == "");
		}

		// 智力
		{
			let pIntellect = pSelf.FindChildTraverse("IntellectContainer");

			let iIntellect = Entities.GetIntellect(iLocalPortraitUnit);
			let iBaseIntellect = Entities.GetBaseIntellect(iLocalPortraitUnit);
			let iBonusIntellect = iIntellect - iBaseIntellect;
			let sSign = iBonusIntellect == 0 ? "" : (iBonusIntellect > 0 ? "+" : "-");
			let sBonusIntellect;

			if (sSign == "") {
				sBonusIntellect = "";
			}
			else if (sSign == "+") {
				sBonusIntellect = sSign + iBonusIntellect.toFixed(0);
			}
			else {
				sBonusIntellect = iBonusIntellect.toFixed(0);
			}

			pIntellect.SetDialogVariableInt("base_intellect", iBaseIntellect);
			pIntellect.SetDialogVariable("bonus_intellect", sBonusIntellect);
			pIntellect.SetDialogVariableInt("intelligence_mana", Float(iIntellect * Float(tSettings.ATTRIBUTE_INTELLIGENCE_MANA)));
			pIntellect.SetDialogVariable("intelligence_mana_regen", Float(iIntellect * Float(tSettings.ATTRIBUTE_INTELLIGENCE_MANA_REGEN)));
			pIntellect.SetDialogVariableInt("primary_attribute_damage", Math.floor(Float(iIntellect * Float(tSettings.ATTRIBUTE_PRIMARY_ATTACK_DAMAGE))));
			pIntellect.SetHasClass("NegativeValue", sSign == "-");
			pIntellect.SetHasClass("NoBonus", sSign == "");
			fExtraBaseManaRegen += Float(iIntellect * Float(tSettings.ATTRIBUTE_INTELLIGENCE_MANA_REGEN));
		}
	}

	// 攻击属性
	{
		// 攻击速度
		{
			let pAttackSpeed = pSelf.FindChildTraverse("AttackSpeedRow");

			let fAttackSpeed = Entities.GetAttackSpeedPercent(iLocalPortraitUnit);
			let fSecondsPerAttack = Entities.GetSecondsPerAttack(iLocalPortraitUnit);

			pAttackSpeed.SetDialogVariableInt("attack_speed", fAttackSpeed);
			pAttackSpeed.SetDialogVariable("seconds_per_attack", Round(fSecondsPerAttack, 2));
		}
		// 攻击力
		{
			let pDamage = pSelf.FindChildTraverse("DamageRow");

			let fBonusDamage = Entities.GetDamageBonus(iLocalPortraitUnit);
			let fMinDamage = Entities.GetDamageMin(iLocalPortraitUnit);
			let fMaxDamage = Entities.GetDamageMax(iLocalPortraitUnit);
			let fBaseDamage = (fMinDamage + fMaxDamage) / 2;
			let sSign = fBonusDamage == 0 ? "" : (fBonusDamage > 0 ? "+" : "-");
			let sBonusDamage;

			if (sSign == "") {
				sBonusDamage = "";
			}
			else if (sSign == "+") {
				sBonusDamage = sSign + fBonusDamage.toFixed(0);
			}
			else {
				sBonusDamage = fBonusDamage.toFixed(0);
			}

			pDamage.SetDialogVariableInt("base_damage_min", fMinDamage);
			pDamage.SetDialogVariableInt("base_damage_max", fMaxDamage);
			pDamage.SetDialogVariable("bonus_damage", sBonusDamage);
			pDamage.SetHasClass("NegativeValue", sSign == "-");
			pDamage.SetHasClass("NoBonus", sSign == "");
		}
		// 攻击距离
		{
			let pAttackRange = pSelf.FindChildTraverse("AttackRangeRow");

			let fAttackRange = Entities.GetAttackRange(iLocalPortraitUnit);
			let fBaseAttackRange = (tData && tData.AttackRange) ? Float(tData.AttackRange) : 0;
			let fBonusAttackRange = fAttackRange - fBaseAttackRange;
			let sSign = fBonusAttackRange == 0 ? "" : (fBonusAttackRange > 0 ? "+" : "-");
			let sBonusAttackRange;

			if (sSign == "") {
				sBonusAttackRange = "";
			}
			else if (sSign == "+") {
				sBonusAttackRange = sSign + fBonusAttackRange.toFixed(0);
			}
			else {
				sBonusAttackRange = fBonusAttackRange.toFixed(0);
			}

			pAttackRange.SetDialogVariableInt("base_attack_range", fBaseAttackRange);
			pAttackRange.SetDialogVariable("bonus_attack_range", sBonusAttackRange);
			pAttackRange.SetHasClass("NegativeValue", sSign == "-");
			pAttackRange.SetHasClass("NoBonus", sSign == "");
		}
		// 移动速度
		{
			let pMoveSpeed = pSelf.FindChildTraverse("MoveSpeedRow");

			let fBaseMoveSpeed = Entities.GetBaseMoveSpeed(iLocalPortraitUnit);
			let fBonusMoveSpeed = Entities.GetMoveSpeed(iLocalPortraitUnit) - fBaseMoveSpeed;
			let sSign = fBonusMoveSpeed == 0 ? "" : (fBonusMoveSpeed > 0 ? "+" : "-");
			let sBonusMoveSpeed;

			if (sSign == "") {
				sBonusMoveSpeed = "";
			}
			else if (sSign == "+") {
				sBonusMoveSpeed = sSign + fBonusMoveSpeed.toFixed(0);
			}
			else {
				sBonusMoveSpeed = fBonusMoveSpeed.toFixed(0);
			}

			pMoveSpeed.SetDialogVariable("base_move_speed", fBaseMoveSpeed.toFixed(0));
			pMoveSpeed.SetDialogVariable("bonus_move_speed", sBonusMoveSpeed);
			pMoveSpeed.SetHasClass("NegativeValue", sSign == "-");
			pMoveSpeed.SetHasClass("NoBonus", sSign == "");
		}
		// 技能增强
		{
			let pSpellAmplify = pSelf.FindChildTraverse("SpellAmpRow");

			let fSpellAmplify = Entities.GetSpellAmplify(iLocalPortraitUnit);
			// let fBaseSpellAmplify = Entities.GetBaseSpellAmplify(iLocalPortraitUnit);
			// let fBonusSpellAmplify = fSpellAmplify - fBaseSpellAmplify;
			// let sSign = fBonusSpellAmplify == 0 ? "" : (fBonusSpellAmplify > 0 ? "+" : "-");
			// let sBonusSpellAmplify;

			// if (sSign == "") {
			// 	sBonusSpellAmplify = "";
			// }
			// else if (sSign == "+") {
			// 	sBonusSpellAmplify = sSign + Round(fBonusSpellAmplify, 1);
			// }
			// else {
			// 	sBonusSpellAmplify = Round(fBonusSpellAmplify, 1);
			// }

			pSpellAmplify.SetDialogVariable("base_spell_amplify", Round(fSpellAmplify, 1));
			// pSpellAmplify.SetDialogVariable("bonus_spell_amplify", sBonusSpellAmplify);
			// pSpellAmplify.SetHasClass("NegativeValue", sSign == "-");
			// pSpellAmplify.SetHasClass("NoBonus", sSign == "");
		}
		// // 冷却减少
		// {
		// 	let pCooldownReduction = pSelf.FindChildTraverse("CooldownReductionRow");

		// 	let fCooldownReduction = Entities.GetCooldownReduction(iLocalPortraitUnit);

		// 	pCooldownReduction.SetDialogVariable("cooldown_reduction", Round(fCooldownReduction, 1));
		// }
		// 魔法恢复
		{
			let pManaRegen = pSelf.FindChildTraverse("ManaRegenRow");

			let fBaseManaRegen = (tData && tData.StatusManaRegen) ? Float(tData.StatusManaRegen) : 0;
			let fManaRegen = Entities.GetManaRegen(iLocalPortraitUnit) + fBaseManaRegen;
			fBaseManaRegen += fExtraBaseManaRegen;
			let fBonusManaRegen = fManaRegen - fBaseManaRegen;
			let sSign = fBonusManaRegen == 0 ? "" : (fBonusManaRegen > 0 ? "+" : "-");
			let sBonusManaRegen;

			if (sSign == "") {
				sBonusManaRegen = "";
			}
			else if (sSign == "+") {
				sBonusManaRegen = sSign + Round(fBonusManaRegen, 1);
			}
			else {
				sBonusManaRegen = Round(fBonusManaRegen, 1);
			}

			pManaRegen.SetDialogVariable("base_mana_regen", Round(fBaseManaRegen, 1));
			pManaRegen.SetDialogVariable("bonus_mana_regen", sBonusManaRegen);
			pManaRegen.SetHasClass("NegativeValue", sSign == "-");
			pManaRegen.SetHasClass("NoBonus", sSign == "");
		}
	}
	// 防御属性
	{
		// 物理防御
		// {
		// 	let pPhysicalArmor = pSelf.FindChildTraverse("PhysicalArmorRow");

		// 	let fPhysicalArmor = Entities.GetPhysicalArmor(iLocalPortraitUnit);
		// 	let fBasePhysicalArmor = Entities.GetBasePhysicalArmor(iLocalPortraitUnit);
		// 	let fBonusPhysicalArmor = fPhysicalArmor - fBasePhysicalArmor;
		// 	let fPhysicalArmorReduction = (() => {
		// 		let iSign = fPhysicalArmor >= 0 ? 1 : -1
		// 		return iSign * tSettings.PHYSICAL_ARMOR_FACTOR * Math.abs(fPhysicalArmor) / (1 + tSettings.PHYSICAL_ARMOR_FACTOR * Math.abs(fPhysicalArmor))
		// 	})();
		// 	let sSign = fBonusPhysicalArmor == 0 ? "" : (fBonusPhysicalArmor > 0 ? "+" : "-");
		// 	let sBonusPhysicalArmor;

		// 	if (sSign == "") {
		// 		sBonusPhysicalArmor = "";
		// 	}
		// 	else if (sSign == "+") {
		// 		sBonusPhysicalArmor = sSign + Round(fBonusPhysicalArmor, 1);
		// 	}
		// 	else {
		// 		sBonusPhysicalArmor = Round(fBonusPhysicalArmor, 1);
		// 	}

		// 	pPhysicalArmor.SetDialogVariable("base_physical_armor", Round(fBasePhysicalArmor, 1));
		// 	pPhysicalArmor.SetDialogVariable("bonus_physical_armor", sBonusPhysicalArmor);
		// 	pPhysicalArmor.SetDialogVariable("physical_resistance", Round(fPhysicalArmorReduction * 100, 1));
		// 	pPhysicalArmor.SetHasClass("NegativeValue", sSign == "-");
		// 	pPhysicalArmor.SetHasClass("NoBonus", sSign == "");
		// }
		// 魔法防御
		// {
		// 	let pMagicalArmor = pSelf.FindChildTraverse("MagicalArmorRow");

		// 	let fMagicalArmor = Entities.GetMagicalArmor(iLocalPortraitUnit);
		// 	let fBaseMagicalArmor = Entities.GetBaseMagicalArmor(iLocalPortraitUnit);
		// 	let fBonusMagicalArmor = fMagicalArmor - fBaseMagicalArmor;
		// 	let fMagicalArmorReduction = (() => {
		// 		let iSign = fMagicalArmor >= 0 ? 1 : -1
		// 		return iSign * tSettings.MAGICAL_ARMOR_FACTOR * Math.abs(fMagicalArmor) / (1 + tSettings.MAGICAL_ARMOR_FACTOR * Math.abs(fMagicalArmor))
		// 	})();
		// 	let sSign = fBonusMagicalArmor == 0 ? "" : (fBonusMagicalArmor > 0 ? "+" : "-");
		// 	let sBonusMagicalArmor;

		// 	if (sSign == "") {
		// 		sBonusMagicalArmor = "";
		// 	}
		// 	else if (sSign == "+") {
		// 		sBonusMagicalArmor = sSign + Round(fBonusMagicalArmor, 1);
		// 	}
		// 	else {
		// 		sBonusMagicalArmor = Round(fBonusMagicalArmor, 1);
		// 	}

		// 	pMagicalArmor.SetDialogVariable("base_magical_armor", Round(fBaseMagicalArmor, 1));
		// 	pMagicalArmor.SetDialogVariable("bonus_magical_armor", sBonusMagicalArmor);
		// 	pMagicalArmor.SetDialogVariable("magical_resistance", Round(fMagicalArmorReduction * 100, 1));
		// 	pMagicalArmor.SetHasClass("NegativeValue", sSign == "-");
		// 	pMagicalArmor.SetHasClass("NoBonus", sSign == "");
		// }
		// 状态抗性
		{
			let pStatusResistance = pSelf.FindChildTraverse("DefenseContainer").FindChildTraverse("StatusResistRow");

			let fStatusResistance = Entities.GetStatusResistance(iLocalPortraitUnit);

			pStatusResistance.SetDialogVariable("status_resistance", Round(fStatusResistance, 1));
		}
		// 闪避
		{
			let pEvasion = pSelf.FindChildTraverse("EvasionRow");

			let fEvasion = Entities.GetEvasion(iLocalPortraitUnit);

			pEvasion.SetDialogVariable("evasion", fEvasion.toFixed(0));
		}
		// 生命恢复
		{
			let pHealthRegen = pSelf.FindChildTraverse("HealthRegenRow");

			let fBaseHealthRegen = (tData && tData.StatusHealthRegen) ? Float(tData.StatusHealthRegen) : 0;
			let fHealthRegen = Entities.GetHealthRegen(iLocalPortraitUnit) + fBaseHealthRegen;
			fBaseHealthRegen += fExtraBaseHealthRegen;
			let fBonusHealthRegen = fHealthRegen - fBaseHealthRegen;
			let sSign = fBonusHealthRegen == 0 ? "" : (fBonusHealthRegen > 0 ? "+" : "-");
			let sBonusHealthRegen;

			if (sSign == "") {
				sBonusHealthRegen = "";
			}
			else if (sSign == "+") {
				sBonusHealthRegen = sSign + Round(fBonusHealthRegen, 1);
			}
			else {
				sBonusHealthRegen = Round(fBonusHealthRegen, 1);
			}

			pHealthRegen.SetDialogVariable("base_health_regen", Round(fBaseHealthRegen, 1));
			pHealthRegen.SetDialogVariable("bonus_health_regen", sBonusHealthRegen);
			pHealthRegen.SetHasClass("NegativeValue", sSign == "-");
			pHealthRegen.SetHasClass("NoBonus", sSign == "");
		}
		// 警戒距离
		// {
		// 	let pAcquisitionRange = pSelf.FindChildTraverse("AcquisitionRangeRow");

		// 	let fAcquisitionRange = Entities.GetAcquisitionRange(iLocalPortraitUnit);
		// 	let fBaseAcquisitionRange = Entities.GetBaseAcquisitionRange(iLocalPortraitUnit);
		// 	let fBonusAcquisitionRange = fAcquisitionRange - fBaseAcquisitionRange;
		// 	let sSign = fBonusAcquisitionRange == 0 ? "" : (fBonusAcquisitionRange > 0 ? "+" : "-");
		// 	let sBonusAcquisitionRange;

		// 	if (sSign == "") {
		// 		sBonusAcquisitionRange = "";
		// 	}
		// 	else if (sSign == "+") {
		// 		sBonusAcquisitionRange = sSign + fBonusAcquisitionRange.toFixed(0);
		// 	}
		// 	else {
		// 		sBonusAcquisitionRange = fBonusAcquisitionRange.toFixed(0);
		// 	}

		// 	pAcquisitionRange.SetDialogVariableInt("base_acquisition_range", fBaseAcquisitionRange);
		// 	pAcquisitionRange.SetDialogVariable("bonus_acquisition_range", sBonusAcquisitionRange);
		// 	pAcquisitionRange.SetHasClass("NegativeValue", sSign == "-");
		// 	pAcquisitionRange.SetHasClass("NoBonus", sSign == "");
		// }
	}
});