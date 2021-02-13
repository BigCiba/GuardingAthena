/******/ (() => { // webpackBootstrap
/******/ 	"use strict";
/*!****************************************!*\
  !*** ./tooltips/unit_stats/script.jsx ***!
  \****************************************/
/*! unknown exports (runtime-defined) */
/*! runtime requirements:  */


var tSettings = CustomNetTables.GetTableValue("common", "settings");
CustomNetTables.SubscribeNetTableListener("common", function () {
  tSettings = CustomNetTables.GetTableValue("common", "settings");
});
var pSelf = $.GetContextPanel();
pSelf.SetPanelEvent("ontooltiploaded", function () {
  var iLocalPortraitUnit = Players.GetLocalPlayerPortraitUnit();

  Entities._updateUnitState(iLocalPortraitUnit);

  pSelf.SetHasClass("Hero", Entities.HasHeroAttribute(iLocalPortraitUnit));
  var sUnitName = Entities.GetUnitName(iLocalPortraitUnit);
  var tData = CustomUIConfig.UnitsKv[sUnitName] || CustomUIConfig.HeroesKv[sUnitName];
  var fExtraBaseHealthRegen = 0;
  var fExtraBaseManaRegen = 0;

  if (Entities.HasHeroAttribute(iLocalPortraitUnit)) {
    var iPrimaryAttribute = Entities.GetPrimaryAttribute(iLocalPortraitUnit);
    pSelf.FindChildTraverse("StrengthContainer").SetHasClass("PrimaryAttribute", iPrimaryAttribute == Attributes.DOTA_ATTRIBUTE_STRENGTH);
    pSelf.FindChildTraverse("AgilityContainer").SetHasClass("PrimaryAttribute", iPrimaryAttribute == Attributes.DOTA_ATTRIBUTE_AGILITY);
    pSelf.FindChildTraverse("IntellectContainer").SetHasClass("PrimaryAttribute", iPrimaryAttribute == Attributes.DOTA_ATTRIBUTE_INTELLECT);
    var fStrengthGain = tData && tData.StrengthGain ? Float(tData.StrengthGain) : 0;
    var fAgilityGain = tData && tData.AgilityGain ? Float(tData.AgilityGain) : 0;
    var fIntellectGain = tData && tData.IntellectGain ? Float(tData.IntellectGain) : 0;
    pSelf.SetDialogVariable("strength_per_level", fStrengthGain);
    pSelf.SetDialogVariable("agility_per_level", fAgilityGain);
    pSelf.SetDialogVariable("intelligence_per_level", fIntellectGain); // 力量

    {
      var pStrength = pSelf.FindChildTraverse("StrengthContainer");
      var iStrength = Entities.GetStrength(iLocalPortraitUnit);
      var iBaseStrength = Entities.GetBaseStrength(iLocalPortraitUnit);
      var iBonusStrength = iStrength - iBaseStrength;
      var sSign = iBonusStrength == 0 ? "" : iBonusStrength > 0 ? "+" : "-";
      var sBonusStrength;

      if (sSign == "") {
        sBonusStrength = "";
      } else if (sSign == "+") {
        sBonusStrength = sSign + iBonusStrength.toFixed(0);
      } else {
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
    } // 敏捷

    {
      var pAgility = pSelf.FindChildTraverse("AgilityContainer");
      var iAgility = Entities.GetAgility(iLocalPortraitUnit);
      var iBaseAgility = Entities.GetBaseAgility(iLocalPortraitUnit);
      var iBonusAgility = iAgility - iBaseAgility;

      var _sSign = iBonusAgility == 0 ? "" : iBonusAgility > 0 ? "+" : "-";

      var sBonusAgility;

      if (_sSign == "") {
        sBonusAgility = "";
      } else if (_sSign == "+") {
        sBonusAgility = _sSign + iBonusAgility.toFixed(0);
      } else {
        sBonusAgility = iBonusAgility.toFixed(0);
      } // var fAgiCooldownReductionPercent = (1 - Math.pow(1 - Float(tSettings.attribute_agility_cooldown_reduction_percent) * 0.01, iAgility)) * Float(tSettings.attribute_agility_cooldown_reduction_max);


      pAgility.SetDialogVariableInt("base_agility", iBaseAgility);
      pAgility.SetDialogVariable("bonus_agility", sBonusAgility);
      pAgility.SetDialogVariableInt("agility_attack_speed", Float(iAgility * Float(tSettings.ATTRIBUTE_AGILITY_ATTACK_SPEED)));
      pAgility.SetDialogVariable("agility_armor", Round(Float(iAgility * Float(tSettings.ATTRIBUTE_AGILITY_ARMOR)), 1));
      pAgility.SetDialogVariableInt("primary_attribute_damage", Math.floor(Float(iAgility * tSettings.ATTRIBUTE_PRIMARY_ATTACK_DAMAGE)));
      pAgility.SetHasClass("NegativeValue", _sSign == "-");
      pAgility.SetHasClass("NoBonus", _sSign == "");
    } // 智力

    {
      var pIntellect = pSelf.FindChildTraverse("IntellectContainer");
      var iIntellect = Entities.GetIntellect(iLocalPortraitUnit);
      var iBaseIntellect = Entities.GetBaseIntellect(iLocalPortraitUnit);
      var iBonusIntellect = iIntellect - iBaseIntellect;

      var _sSign2 = iBonusIntellect == 0 ? "" : iBonusIntellect > 0 ? "+" : "-";

      var sBonusIntellect;

      if (_sSign2 == "") {
        sBonusIntellect = "";
      } else if (_sSign2 == "+") {
        sBonusIntellect = _sSign2 + iBonusIntellect.toFixed(0);
      } else {
        sBonusIntellect = iBonusIntellect.toFixed(0);
      }

      pIntellect.SetDialogVariableInt("base_intellect", iBaseIntellect);
      pIntellect.SetDialogVariable("bonus_intellect", sBonusIntellect);
      pIntellect.SetDialogVariableInt("intelligence_mana", Float(iIntellect * Float(tSettings.ATTRIBUTE_INTELLIGENCE_MANA)));
      pIntellect.SetDialogVariable("intelligence_mana_regen", Float(iIntellect * Float(tSettings.ATTRIBUTE_INTELLIGENCE_MANA_REGEN)));
      pIntellect.SetDialogVariableInt("primary_attribute_damage", Math.floor(Float(iIntellect * Float(tSettings.ATTRIBUTE_PRIMARY_ATTACK_DAMAGE))));
      pIntellect.SetHasClass("NegativeValue", _sSign2 == "-");
      pIntellect.SetHasClass("NoBonus", _sSign2 == "");
      fExtraBaseManaRegen += Float(iIntellect * Float(tSettings.ATTRIBUTE_INTELLIGENCE_MANA_REGEN));
    }
  } // 攻击属性


  {
    // 攻击速度
    {
      var pAttackSpeed = pSelf.FindChildTraverse("AttackSpeedRow");
      var fAttackSpeed = Entities.GetAttackSpeedPercent(iLocalPortraitUnit);
      var fSecondsPerAttack = Entities.GetSecondsPerAttack(iLocalPortraitUnit);
      pAttackSpeed.SetDialogVariableInt("attack_speed", fAttackSpeed);
      pAttackSpeed.SetDialogVariable("seconds_per_attack", Round(fSecondsPerAttack, 2));
    } // 攻击力

    {
      var pDamage = pSelf.FindChildTraverse("DamageRow");
      var fBonusDamage = Entities.GetDamageBonus(iLocalPortraitUnit);
      var fMinDamage = Entities.GetDamageMin(iLocalPortraitUnit);
      var fMaxDamage = Entities.GetDamageMax(iLocalPortraitUnit);
      var fBaseDamage = (fMinDamage + fMaxDamage) / 2;

      var _sSign3 = fBonusDamage == 0 ? "" : fBonusDamage > 0 ? "+" : "-";

      var sBonusDamage;

      if (_sSign3 == "") {
        sBonusDamage = "";
      } else if (_sSign3 == "+") {
        sBonusDamage = _sSign3 + fBonusDamage.toFixed(0);
      } else {
        sBonusDamage = fBonusDamage.toFixed(0);
      }

      pDamage.SetDialogVariableInt("base_damage_min", fMinDamage);
      pDamage.SetDialogVariableInt("base_damage_max", fMaxDamage);
      pDamage.SetDialogVariable("bonus_damage", sBonusDamage);
      pDamage.SetHasClass("NegativeValue", _sSign3 == "-");
      pDamage.SetHasClass("NoBonus", _sSign3 == "");
    } // 攻击距离

    {
      var pAttackRange = pSelf.FindChildTraverse("AttackRangeRow");
      var fAttackRange = Entities.GetAttackRange(iLocalPortraitUnit);
      var fBaseAttackRange = tData && tData.AttackRange ? Float(tData.AttackRange) : 0;
      var fBonusAttackRange = fAttackRange - fBaseAttackRange;

      var _sSign4 = fBonusAttackRange == 0 ? "" : fBonusAttackRange > 0 ? "+" : "-";

      var sBonusAttackRange;

      if (_sSign4 == "") {
        sBonusAttackRange = "";
      } else if (_sSign4 == "+") {
        sBonusAttackRange = _sSign4 + fBonusAttackRange.toFixed(0);
      } else {
        sBonusAttackRange = fBonusAttackRange.toFixed(0);
      }

      pAttackRange.SetDialogVariableInt("base_attack_range", fBaseAttackRange);
      pAttackRange.SetDialogVariable("bonus_attack_range", sBonusAttackRange);
      pAttackRange.SetHasClass("NegativeValue", _sSign4 == "-");
      pAttackRange.SetHasClass("NoBonus", _sSign4 == "");
    } // 移动速度

    {
      var pMoveSpeed = pSelf.FindChildTraverse("MoveSpeedRow");
      var fBaseMoveSpeed = Entities.GetBaseMoveSpeed(iLocalPortraitUnit);
      var fBonusMoveSpeed = Entities.GetMoveSpeed(iLocalPortraitUnit) - fBaseMoveSpeed;

      var _sSign5 = fBonusMoveSpeed == 0 ? "" : fBonusMoveSpeed > 0 ? "+" : "-";

      var sBonusMoveSpeed;

      if (_sSign5 == "") {
        sBonusMoveSpeed = "";
      } else if (_sSign5 == "+") {
        sBonusMoveSpeed = _sSign5 + fBonusMoveSpeed.toFixed(0);
      } else {
        sBonusMoveSpeed = fBonusMoveSpeed.toFixed(0);
      }

      pMoveSpeed.SetDialogVariable("base_move_speed", fBaseMoveSpeed.toFixed(0));
      pMoveSpeed.SetDialogVariable("bonus_move_speed", sBonusMoveSpeed);
      pMoveSpeed.SetHasClass("NegativeValue", _sSign5 == "-");
      pMoveSpeed.SetHasClass("NoBonus", _sSign5 == "");
    } // 技能增强

    {
      var pSpellAmplify = pSelf.FindChildTraverse("SpellAmpRow");
      var fSpellAmplify = Entities.GetSpellAmplify(iLocalPortraitUnit); // let fBaseSpellAmplify = Entities.GetBaseSpellAmplify(iLocalPortraitUnit);
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

      pSpellAmplify.SetDialogVariable("base_spell_amplify", Round(fSpellAmplify, 1)); // pSpellAmplify.SetDialogVariable("bonus_spell_amplify", sBonusSpellAmplify);
      // pSpellAmplify.SetHasClass("NegativeValue", sSign == "-");
      // pSpellAmplify.SetHasClass("NoBonus", sSign == "");
    } // // 冷却减少
    // {
    // 	let pCooldownReduction = pSelf.FindChildTraverse("CooldownReductionRow");
    // 	let fCooldownReduction = Entities.GetCooldownReduction(iLocalPortraitUnit);
    // 	pCooldownReduction.SetDialogVariable("cooldown_reduction", Round(fCooldownReduction, 1));
    // }
    // 魔法恢复

    {
      var pManaRegen = pSelf.FindChildTraverse("ManaRegenRow");
      var fBaseManaRegen = tData && tData.StatusManaRegen ? Float(tData.StatusManaRegen) : 0;
      var fManaRegen = Entities.GetManaRegen(iLocalPortraitUnit) + fBaseManaRegen;
      fBaseManaRegen += fExtraBaseManaRegen;
      var fBonusManaRegen = fManaRegen - fBaseManaRegen;

      var _sSign6 = fBonusManaRegen == 0 ? "" : fBonusManaRegen > 0 ? "+" : "-";

      var sBonusManaRegen;

      if (_sSign6 == "") {
        sBonusManaRegen = "";
      } else if (_sSign6 == "+") {
        sBonusManaRegen = _sSign6 + Round(fBonusManaRegen, 1);
      } else {
        sBonusManaRegen = Round(fBonusManaRegen, 1);
      }

      pManaRegen.SetDialogVariable("base_mana_regen", Round(fBaseManaRegen, 1));
      pManaRegen.SetDialogVariable("bonus_mana_regen", sBonusManaRegen);
      pManaRegen.SetHasClass("NegativeValue", _sSign6 == "-");
      pManaRegen.SetHasClass("NoBonus", _sSign6 == "");
    }
  } // 防御属性

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
      var pStatusResistance = pSelf.FindChildTraverse("DefenseContainer").FindChildTraverse("StatusResistRow");
      var fStatusResistance = Entities.GetStatusResistance(iLocalPortraitUnit);
      pStatusResistance.SetDialogVariable("status_resistance", Round(fStatusResistance, 1));
    } // 闪避

    {
      var pEvasion = pSelf.FindChildTraverse("EvasionRow");
      var fEvasion = Entities.GetEvasion(iLocalPortraitUnit);
      pEvasion.SetDialogVariable("evasion", fEvasion.toFixed(0));
    } // 生命恢复

    {
      var pHealthRegen = pSelf.FindChildTraverse("HealthRegenRow");
      var fBaseHealthRegen = tData && tData.StatusHealthRegen ? Float(tData.StatusHealthRegen) : 0;
      var fHealthRegen = Entities.GetHealthRegen(iLocalPortraitUnit) + fBaseHealthRegen;
      fBaseHealthRegen += fExtraBaseHealthRegen;
      var fBonusHealthRegen = fHealthRegen - fBaseHealthRegen;

      var _sSign7 = fBonusHealthRegen == 0 ? "" : fBonusHealthRegen > 0 ? "+" : "-";

      var sBonusHealthRegen;

      if (_sSign7 == "") {
        sBonusHealthRegen = "";
      } else if (_sSign7 == "+") {
        sBonusHealthRegen = _sSign7 + Round(fBonusHealthRegen, 1);
      } else {
        sBonusHealthRegen = Round(fBonusHealthRegen, 1);
      }

      pHealthRegen.SetDialogVariable("base_health_regen", Round(fBaseHealthRegen, 1));
      pHealthRegen.SetDialogVariable("bonus_health_regen", sBonusHealthRegen);
      pHealthRegen.SetHasClass("NegativeValue", _sSign7 == "-");
      pHealthRegen.SetHasClass("NoBonus", _sSign7 == "");
    } // 警戒距离
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
/******/ })()
;