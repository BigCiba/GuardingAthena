"use strict";

var CustomUIConfig = GameUI.CustomUIConfig();

var STEAM_WEB_KEY = "D34B40626FBA6E482A7653E4FB8A80CB";
CustomUIConfig.tSteamID2Name = [];

var REQUEST_TIME_OUT = 30;

String.prototype.replaceAll = function (s1, s2) {
	return this.replace(new RegExp(s1, "gm"), s2);
};

$.RandomInt = function (n, m) {
	var random = RemapValClamped(Math.random(), 0, 1, n, m);
	return Math.floor(random);
};

$.RandomFloat = function (n, m) {
	var random = RemapValClamped(Math.random(), 0, 1, n, m);
	return random;
};

function Round(fNumber, prec = 0) {
	let i = Math.pow(10, prec);
	return Math.round(fNumber * i) / i;
}

function Clamp(num, min, max) {
	return num <= min ? min : (num >= max ? max : num);
}

function Lerp(percent, a, b) {
	return a + percent * (b - a);
}

function RemapVal(num, a, b, c, d) {
	if (a == b)
		return c;

	var percent = (num - a) / (b - a);
	return Lerp(percent, c, d);
}

function RemapValClamped(num, a, b, c, d) {
	if (a == b)
		return c;

	var percent = (num - a) / (b - a);
	percent = Clamp(percent, 0.0, 1.0);

	return Lerp(percent, c, d);
}

function FindKey(o, v) {
	for (var k in o) {
		if (o[k] == v)
			return k;
	}
}

function Float(f) {
	return Math.round(f * 10000) / 10000;
}

function VectorToString(vec) {
	return vec.join(" ");
}

function StringToVector(str) {
	let a = str.split(" ");
	return [Number(a[0]), Number(a[1]), Number(a[2])];
}

function alertObj(obj, name, str) {
	let output = "";
	if (name == null) {
		name = toString(obj);
	}
	if (str == null) {
		str = "";
	}
	$.Msg(str + name + "\n" + str + "{");
	for (let i in obj) {
		let property = obj[i];
		if (typeof (property) == "object") {
			alertObj(property, i, str + "\t");
		} else {
			output = i + " = " + property + "\t(" + typeof (property) + ")";
			$.Msg(str + "\t" + output);
		}
	}
	$.Msg(str + "}");
}

function DeepPrint(obj) {
	return alertObj(obj);
}

function polygonArray(polygon) {
	let p = [];
	for (let k in polygon) {
		p.push(polygon[k]);
	}
	return p;
}

function IsPointInPolygon(point, polygon) {
	let j = polygon.length - 1;
	let bool = 0;
	for (let i = 0; i < polygon.length; i++) {
		let polygonPoint1 = polygon[i];
		let polygonPoint2 = polygon[j];
		if (((polygonPoint2.y < point[1] && polygonPoint1.y >= point[1]) || (polygonPoint1.y < point[1] && polygonPoint2.y >= point[1])) && (polygonPoint2.x <= point[0] || polygonPoint1.x <= point[0])) {
			bool = bool ^ (((polygonPoint2.x + (point[1] - polygonPoint2.y) / (polygonPoint1.y - polygonPoint2.y) * (polygonPoint1.x - polygonPoint2.x)) < point[0]) ? 1 : 0);
		}
		j = i;
	}
	return bool == 1;
}

function ErrorMessage(msg, sound) {
	sound = sound || "General.CastFail_Custom";
	GameUI.SendCustomHUDError(msg, sound);
}

function OnErrorMessage(data) {
	ErrorMessage(data.message, data.sound);
}

function intToARGB(i) {
	return ('00' + (i & 0xFF).toString(16)).substr(-2) +
		('00' + ((i >> 8) & 0xFF).toString(16)).substr(-2) +
		('00' + ((i >> 16) & 0xFF).toString(16)).substr(-2) +
		('00' + ((i >> 24) & 0xFF).toString(16)).substr(-2);
}

function SBehavior2IBehavior(sBehaviors) {
	sBehaviors = sBehaviors.replace(/ /g, "");
	let aBehaviors = sBehaviors.split(/\|/g);
	let iBehaviors = 0;
	for (const sBehavior of aBehaviors) {
		let iBehavior = parseInt(DOTA_ABILITY_BEHAVIOR[sBehavior]);
		if (iBehavior) {
			iBehaviors = iBehaviors + iBehavior;
		}
	}
	return iBehaviors;
}

function STeam2ITeam(sTeam) {
	return DOTA_UNIT_TARGET_TEAM[sTeam] || 0;
}

function SDamageType2IDamageType(sDamageType) {
	return DAMAGE_TYPES[sDamageType] || 0;
}

function SSpellImmunityType2ISpellImmunityType(sSpellImmunityType) {
	return SPELL_IMMUNITY_TYPES[sSpellImmunityType] || 0;
}

function SType2IType(sTypes) {
	sTypes = sTypes.replace(/ /g, "");
	let aTypes = sTypes.split(/\|/g);
	let iTypes = 0;
	for (const sType of aTypes) {
		let iType = parseInt(DOTA_UNIT_TARGET_TYPE[sType]);
		if (iType) {
			iTypes = iTypes + iType;
		}
	}
	return iTypes;
}

function GetHeroNameByHeroID(iHeroID) {
	for (let sHeroName in CustomUIConfig.HeroesKv) {
		if (sHeroName != "Version") {
			let tHeroData = CustomUIConfig.HeroesKv[sHeroName];
			if (tHeroData && Number(tHeroData.HeroID) == iHeroID) {
				return sHeroName;
			}
		}
	}
}

function SimplifyValuesArray(aValues) {
	if (aValues && aValues.length > 1) {
		let a = aValues[0];
		for (let i = 1; i < aValues.length; i++) {
			const value = aValues[i];
			if (a != value) {
				return aValues;
			}
		}
		return [a];
	}
	return aValues;
}

function GetAbilityType(sAbilityName) {
	var tAbilityKeyValues = CustomUIConfig.AbilitiesKv[sAbilityName];
	var tItemKeyValues = CustomUIConfig.AbilitiesKv[sAbilityName];
	var tKeyValues = tAbilityKeyValues || tItemKeyValues;
	if (tKeyValues) {
		return tAbilityKeyValues.AbilityType || "ABILITY_TYPE_BASIC";
	}

	return "";
}

function IsGrantedByScepter(sAbilityName) {
	var tAbilityKeyValues = CustomUIConfig.AbilitiesKv[sAbilityName];
	var tItemKeyValues = CustomUIConfig.AbilitiesKv[sAbilityName];
	var tKeyValues = tAbilityKeyValues || tItemKeyValues;
	if (tKeyValues) {
		return tAbilityKeyValues.IsGrantedByScepter == 1 || tAbilityKeyValues.IsGrantedByScepter == "1";
	}

	return false;
}

let aPropertyNames = [
	"LinkedSpecialBonus",
	"LinkedSpecialBonusField",
	"LinkedSpecialBonusOperation",
	"CalculateSpellDamageTooltip",
	"RequiresScepter",
	"levelkey",
	"_str",
	"_int",
	"_agi",
	"_all",
	"_attack_damage",
	"_attack_speed",
	"_health",
	"_physical_armor",
	"_magical_armor",
	"_mana",
	"_max",
	"_min",
	"_move_speed",
];

function GetSpecialNames(sAbilityName, iEntityIndex = -1) {
	var tAbilityKeyValues = CustomUIConfig.AbilitiesKv[sAbilityName];
	var tItemKeyValues = CustomUIConfig.ItemsKv[sAbilityName];
	var aSpecials = [];
	var tKeyValues = tAbilityKeyValues || tItemKeyValues;

	if (tKeyValues) {
		var tSpecials = tKeyValues.AbilitySpecial;
		if (tSpecials) {
			var sKey = Object.keys(tSpecials);
			sKey.sort(function (a, b) {
				return a - b;
			});
			for (let index = 0; index < sKey.length; index++) {
				const sIndex = sKey[index];
				var tData = tSpecials[sIndex];
				for (var sName in tData) {
					if (FindKey(aPropertyNames, sName) == undefined &&
						sName != "var_type" &&
						sName != "abilitycastrange" &&
						sName != "abilitycastpoint" &&
						sName != "abilityduration" &&
						sName != "abilitychanneltime") {
						aSpecials.push(sName);
						break;
					}
				}
			}
		}
		aSpecials = aSpecials.concat("abilitycastrange", "abilitycastpoint", "abilityduration", "abilitychanneltime", "abilitydamage");
	}

	if (iEntityIndex != -1) {
		let a = GetAbilityMechanicsUpgradeSpecialNames(iEntityIndex, sAbilityName);
		for (let index = 0; index < a.length; index++) {
			const v = a[index];
			if (!FindKey(aSpecials, v)) {
				aSpecials.push(v);
			}
		}
	}

	return aSpecials;
}

function GetSpecialValueForLevel(sAbilityName, sName, iLevel, iEntityIndex = -1) {
	var tAbilityKeyValues = CustomUIConfig.AbilitiesKv[sAbilityName];
	var tItemKeyValues = CustomUIConfig.ItemsKv[sAbilityName];
	var tKeyValues = tAbilityKeyValues || tItemKeyValues;

	if (iEntityIndex != -1) {
		let fValue = GetAbilityMechanicsUpgradeLevelSpecialValue(iEntityIndex, sAbilityName, sName, iLevel);
		if (fValue != undefined) {
			return fValue;
		}
	}

	if (tKeyValues) {
		var tSpecials = tKeyValues.AbilitySpecial;
		if (tSpecials) {
			for (var sIndex in tSpecials) {
				var tData = tSpecials[sIndex];
				if (tData[sName] != undefined && tData[sName] != null) {
					var sType = tData.var_type;
					var sValues = tData[sName].toString();
					var aValues = sValues.split(" ");
					if (aValues[iLevel - 1]) {
						var value = Number(aValues[iLevel - 1]);
						if (sType == "FIELD_INTEGER") {
							return parseInt(value);
						} else if (sType == "FIELD_FLOAT") {
							return Float(Number(value));
						}
					}
				}
			}
		}
	}

	return 0;
}

function StringToValues(sValues) {
	var aValues = sValues.toString().split(" ");
	for (var i = 0; i < aValues.length; i++) {
		aValues[i] = Float(Number(aValues[i]));
	}
	return FixDuplicateData(aValues);
}

function FixDuplicateData(aValues) {
	var value = aValues[0];
	for (const v of aValues) {
		if (value != v) {
			return aValues;
		}
	}
	return [value];
}

function GetSpecialValues(sAbilityName, sName, iEntityIndex = -1) {
	var tAbilityKeyValues = CustomUIConfig.AbilitiesKv[sAbilityName];
	var tItemKeyValues = CustomUIConfig.ItemsKv[sAbilityName];
	var tKeyValues = tAbilityKeyValues || tItemKeyValues;

	if (iEntityIndex != -1) {
		let aValues = GetAbilityMechanicsUpgradeSpecialValues(iEntityIndex, sAbilityName, sName);
		if (aValues != undefined) {
			return aValues;
		}
	}

	if (tKeyValues) {
		var tSpecials = tKeyValues.AbilitySpecial;
		if (tSpecials) {
			for (var sIndex in tSpecials) {
				var tData = tSpecials[sIndex];
				if (tData[sName] != undefined && tData[sName] != null) {
					var sType = tData.var_type;
					var sValues = tData[sName].toString();
					var aValues = sValues.split(" ");
					for (var i = 0; i < aValues.length; i++) {
						var value = Number(aValues[i]);
						if (sType == "FIELD_INTEGER") {
							aValues[i] = parseInt(value);
						} else if (sType == "FIELD_FLOAT") {
							aValues[i] = parseFloat(value.toFixed(6));
						}
					}
					return FixDuplicateData(aValues);
				}
			}
		}
	}

	return [];
}

function GetSpecialVarType(sAbilityName, sName) {
	var tAbilityKeyValues = CustomUIConfig.AbilitiesKv[sAbilityName];
	var tItemKeyValues = CustomUIConfig.ItemsKv[sAbilityName];
	var tKeyValues = tAbilityKeyValues || tItemKeyValues;

	if (tKeyValues) {
		var tSpecials = tKeyValues.AbilitySpecial;
		if (tSpecials) {
			for (var sIndex in tSpecials) {
				var tData = tSpecials[sIndex];
				if (tData[sName] != undefined && tData[sName] != null) {
					return tData.var_type;
				}
			}
		}
	}

	return [];
}

function GetSpecialValueProperty(sAbilityName, sName, sPropertyName, iEntityIndex = -1) {
	var tAbilityKeyValues = CustomUIConfig.AbilitiesKv[sAbilityName];
	var tItemKeyValues = CustomUIConfig.ItemsKv[sAbilityName];
	var tKeyValues = tAbilityKeyValues || tItemKeyValues;

	if (iEntityIndex != -1) {
		let sPropertyValue = GetAbilityMechanicsUpgradeLevelSpecialValueProperty(iEntityIndex, sAbilityName, sName, sPropertyName);
		if (sPropertyValue != undefined) {
			return sPropertyValue.toString();
		}
	}

	if (tKeyValues) {
		var tSpecials = tKeyValues.AbilitySpecial;
		if (tSpecials) {
			for (var sIndex in tSpecials) {
				var tData = tSpecials[sIndex];
				if (tData[sName] != undefined && tData[sName] != null) {
					if (tData[sPropertyName] != undefined && tData[sPropertyName] != null) {
						return tData[sPropertyName].toString();
					}
				}
			}
		}
	}
}

// 判断单位是否被玩家选择
Players.IsEntitySelected = function (iEntIndex) {
	let aSelectedEntities = Players.GetSelectedEntities(Players.GetLocalPlayer());
	for (let index = aSelectedEntities.length - 1; index >= 0; index--) {
		let _iEntIndex = aSelectedEntities[index];
		if (iEntIndex == _iEntIndex) {
			return true;
		}
	}
	return false;
};

// 清除本地玩家选择单位
Players.RemoveSelection = function (iRemoveEntIndex) {
	let aSelectedEntities = Players.GetSelectedEntities(Players.GetLocalPlayer());
	for (let index = aSelectedEntities.length - 1; index >= 0; index--) {
		let iEntIndex = aSelectedEntities[index];
		if (iRemoveEntIndex == iEntIndex) {
			aSelectedEntities.splice(index, 1);
		}
	}

	GameUI.SelectUnit(-1, false);
	for (let index = 0; index < aSelectedEntities.length; index++) {
		let iEntIndex = aSelectedEntities[index];
		GameUI.SelectUnit(iEntIndex, true);
	}

};

Abilities.GetLevelCooldown = (iEntityIndex, iLevel = -1) => {
	GameEvents.SendEventClientSide("custom_get_ability_cooldown", {
		ability_ent_index: iEntityIndex,
		level: iLevel,
	});
	let iCasterIndex = Abilities.GetCaster(iEntityIndex);
	let iAbilityEntIndex = Entities.GetAbilityByName(iCasterIndex, "unit_state");
	if (iAbilityEntIndex != -1) {
		let sCooldown = Abilities.GetAbilityTextureName(iAbilityEntIndex);
		if (sCooldown == "") {
			let sAbilityName = Abilities.GetAbilityName(iEntityIndex);
			let tAbility = CustomUIConfig.AbilitiesKv[sAbilityName];
			let tItem = CustomUIConfig.ItemsKv[sAbilityName];
			let tData = tAbility || tItem;
			if (tData) {
				if (iLevel == -1) iLevel = Abilities.GetLevel(iEntityIndex);
				let aCooldowns = StringToValues(tData.AbilityCooldown || "");
				if (aCooldowns.length > 0) {
					return aCooldowns[Math.min(iLevel, aCooldowns.length - 1)];
				}
			}
			return 0;
		}
		return Number(sCooldown);
	}
	return 0;
};

Abilities.GetLevelManaCost = (iEntityIndex, iLevel = -1) => {
	GameEvents.SendEventClientSide("custom_get_ability_mana_cost", {
		ability_ent_index: iEntityIndex,
		level: iLevel,
	});
	let iCasterIndex = Abilities.GetCaster(iEntityIndex);
	let iAbilityEntIndex = Entities.GetAbilityByName(iCasterIndex, "unit_state");
	if (iAbilityEntIndex != -1) {
		let sManaCost = Abilities.GetAbilityTextureName(iAbilityEntIndex);
		if (sManaCost == "") {
			let sAbilityName = Abilities.GetAbilityName(iEntityIndex);
			let tAbility = CustomUIConfig.AbilitiesKv[sAbilityName];
			let tItem = CustomUIConfig.ItemsKv[sAbilityName];
			let tData = tAbility || tItem;
			if (tData) {
				if (iLevel == -1) iLevel = Abilities.GetLevel(iEntityIndex);
				let aManaCosts = StringToValues(tData.AbilityManaCost || "");
				if (aManaCosts.length > 0) {
					return aManaCosts[Math.min(iLevel, aManaCosts.length - 1)];
				}
			}
			return 0;
		}
		return Number(sManaCost);
	}
	return 0;
};

Abilities.GetLevelGoldCost = (iEntityIndex, iLevel = -1) => {
	GameEvents.SendEventClientSide("custom_get_ability_gold_cost", {
		ability_ent_index: iEntityIndex,
		level: iLevel,
	});
	let iCasterIndex = Abilities.GetCaster(iEntityIndex);
	let iAbilityEntIndex = Entities.GetAbilityByName(iCasterIndex, "unit_state");
	if (iAbilityEntIndex != -1) {
		let sGoldCost = Abilities.GetAbilityTextureName(iAbilityEntIndex);
		if (sGoldCost == "") {
			let sAbilityName = Abilities.GetAbilityName(iEntityIndex);
			let tAbility = CustomUIConfig.AbilitiesKv[sAbilityName];
			let tItem = CustomUIConfig.ItemsKv[sAbilityName];
			let tData = tAbility || tItem;
			if (tData) {
				if (iLevel == -1) iLevel = Abilities.GetLevel(iEntityIndex);
				let aGoldCosts = StringToValues(tData.AbilityGoldCost || "");
				if (aGoldCosts.length > 0) {
					return aGoldCosts[Math.min(iLevel, aGoldCosts.length - 1)];
				}
			}
			return 0;
		}
		return Number(sGoldCost);
	}
	return 0;
};

Entities.GetAbilityIndex = function (iEntityIndex, iAbilityEntIndex) {
	for (let i = 0; i < Entities.GetAbilityCount(iEntityIndex); i++) {
		const _iAbilityEntIndex = Entities.GetAbility(iEntityIndex, i);
		if (_iAbilityEntIndex == iAbilityEntIndex) {
			return i;
		}
	}
	return -1;
};

Entities.HasBuff = function (unitEntIndex, buffName) {
	for (let index = 0; index < Entities.GetNumBuffs(unitEntIndex); index++) {
		let buff = Entities.GetBuff(unitEntIndex, index);
		if (Buffs.GetName(unitEntIndex, buff) == buffName)
			return true;
	}
	return false;
};

Entities.FindBuffByName = function (unitEntIndex, buffName) {
	for (let index = 0; index < Entities.GetNumBuffs(unitEntIndex); index++) {
		let buff = Entities.GetBuff(unitEntIndex, index);
		if (Buffs.GetName(unitEntIndex, buff) == buffName)
			return buff;
	}
	return -1;
};

Entities.GetEvasion = function (iEntityIndex) {
	let value = 1;
	if (Entities.HasBuff(iEntityIndex, "modifier_stinky"))
		value = value * 0.9;
	if (Entities.HasBuff(iEntityIndex, "modifier_dexterous"))
		value = value * 0.65;
	if (Entities.HasBuff(iEntityIndex, "modifier_unreal"))
		value = value * 0.5;
	if (Entities.HasBuff(iEntityIndex, "modifier_sky_light_buff"))
		value = value * 0;

	return 1 - value;
};

CustomUIConfig.UnitState = [];
Entities._updateUnitState = (iUnitEntIndex) => {
	let iAbilityEntIndex = Entities.GetAbilityByName(iUnitEntIndex, "unit_state");
	if (iAbilityEntIndex != -1) {
		let json = Abilities.GetAbilityTextureName(iAbilityEntIndex);
		if (json != "") {
			let aData = JSON.parse(json);
			CustomUIConfig.UnitState[iUnitEntIndex] = aData;
		}
	}
};

Entities.GetAverageAttackDamage = (iUnitEntIndex) => {
	return (Entities.GetDamageMin(iUnitEntIndex) + Entities.GetDamageMax(iUnitEntIndex)) / 2 + Entities.GetDamageBonus(iUnitEntIndex);
};

Entities.GetAttackSpeedPercent = (iUnitEntIndex) => {
	return Entities.GetAttackSpeed(iUnitEntIndex) * 100;
};

Entities.GetMoveSpeed = (iUnitEntIndex) => {
	return Entities.GetMoveSpeedModifier(iUnitEntIndex, Entities.GetBaseMoveSpeed(iUnitEntIndex));
};

Entities.GetBasePhysicalArmor = (iUnitEntIndex) => {
	if (CustomUIConfig.UnitState[iUnitEntIndex]) {
		return CustomUIConfig.UnitState[iUnitEntIndex][0];
	}
	return 0;
};
Entities.GetPhysicalArmor = (iUnitEntIndex) => {
	if (CustomUIConfig.UnitState[iUnitEntIndex]) {
		return CustomUIConfig.UnitState[iUnitEntIndex][1];
	}
	return 0;
};
Entities.GetBaseMagicalArmor = (iUnitEntIndex) => {
	if (CustomUIConfig.UnitState[iUnitEntIndex]) {
		return CustomUIConfig.UnitState[iUnitEntIndex][2];
	}
	return 0;
};
Entities.GetMagicalArmor = (iUnitEntIndex) => {
	if (CustomUIConfig.UnitState[iUnitEntIndex]) {
		return CustomUIConfig.UnitState[iUnitEntIndex][3];
	}
	return 0;
};
Entities.GetBaseSpellAmplify = (iUnitEntIndex) => {
	if (CustomUIConfig.UnitState[iUnitEntIndex]) {
		return CustomUIConfig.UnitState[iUnitEntIndex][4];
	}
	return 0;
};
Entities.GetSpellAmplify = (iUnitEntIndex) => {
	if (CustomUIConfig.UnitState[iUnitEntIndex]) {
		return CustomUIConfig.UnitState[iUnitEntIndex][5];
	}
	return 0;
};
Entities.GetHealthRegen = (iUnitEntIndex) => {
	if (CustomUIConfig.UnitState[iUnitEntIndex]) {
		return CustomUIConfig.UnitState[iUnitEntIndex][6];
	}
	return 0;
};
Entities.GetManaRegen = (iUnitEntIndex) => {
	if (CustomUIConfig.UnitState[iUnitEntIndex]) {
		return CustomUIConfig.UnitState[iUnitEntIndex][7];
	}
	return 0;
};
Entities.GetStatusResistance = (iUnitEntIndex) => {
	if (CustomUIConfig.UnitState[iUnitEntIndex]) {
		return CustomUIConfig.UnitState[iUnitEntIndex][8];
	}
	return 0;
};
Entities.GetEvasion = (iUnitEntIndex) => {
	if (CustomUIConfig.UnitState[iUnitEntIndex]) {
		return CustomUIConfig.UnitState[iUnitEntIndex][9];
	}
	return 0;
};
Entities.GetCooldownReduction = (iUnitEntIndex) => {
	if (CustomUIConfig.UnitState[iUnitEntIndex]) {
		return CustomUIConfig.UnitState[iUnitEntIndex][10];
	}
	return 0;
};
Entities.GetBaseAcquisitionRange = (iUnitEntIndex) => {
	if (CustomUIConfig.UnitState[iUnitEntIndex]) {
		return CustomUIConfig.UnitState[iUnitEntIndex][11];
	}
	return 0;
};
Entities.GetAcquisitionRange = (iUnitEntIndex) => {
	if (CustomUIConfig.UnitState[iUnitEntIndex]) {
		return CustomUIConfig.UnitState[iUnitEntIndex][12];
	}
	return 0;
};
Entities.HasHeroAttribute = (iUnitEntIndex) => {
	if (CustomUIConfig.UnitState[iUnitEntIndex]) {
		return CustomUIConfig.UnitState[iUnitEntIndex][13] == 1;
	}
	return false;
};
Entities.GetBaseStrength = (iUnitEntIndex) => {
	if (Entities.HasHeroAttribute(iUnitEntIndex)) {
		return CustomUIConfig.UnitState[iUnitEntIndex][14];
	}
	return 0;
};
Entities.GetStrength = (iUnitEntIndex) => {
	if (Entities.HasHeroAttribute(iUnitEntIndex)) {
		return CustomUIConfig.UnitState[iUnitEntIndex][15];
	}
	return 0;
};
Entities.GetBaseAgility = (iUnitEntIndex) => {
	if (Entities.HasHeroAttribute(iUnitEntIndex)) {
		return CustomUIConfig.UnitState[iUnitEntIndex][16];
	}
	return 0;
};
Entities.GetAgility = (iUnitEntIndex) => {
	if (Entities.HasHeroAttribute(iUnitEntIndex)) {
		return CustomUIConfig.UnitState[iUnitEntIndex][17];
	}
	return 0;
};
Entities.GetBaseIntellect = (iUnitEntIndex) => {
	if (Entities.HasHeroAttribute(iUnitEntIndex)) {
		return CustomUIConfig.UnitState[iUnitEntIndex][18];
	}
	return 0;
};
Entities.GetIntellect = (iUnitEntIndex) => {
	if (Entities.HasHeroAttribute(iUnitEntIndex)) {
		return CustomUIConfig.UnitState[iUnitEntIndex][19];
	}
	return 0;
};
Entities.GetAllStats = (iUnitEntIndex) => {
	return Entities.GetStrength(iUnitEntIndex) + Entities.GetAgility(iUnitEntIndex) + Entities.GetIntellect(iUnitEntIndex);
};
Entities.GetBaseAllStats = (iUnitEntIndex) => {
	return Entities.GetBaseStrength(iUnitEntIndex) + Entities.GetBaseAgility(iUnitEntIndex) + Entities.GetBaseIntellect(iUnitEntIndex);
};
Entities.GetPrimaryAttribute = (iUnitEntIndex) => {
	if (Entities.HasHeroAttribute(iUnitEntIndex)) {
		let iBuffIndex = Entities.FindBuffByName(iUnitEntIndex, "modifier_hero_attribute");
		if (iBuffIndex == -1) return -1;
		return Buffs.GetStackCount(iUnitEntIndex, iBuffIndex);
	}
};

let tAddedProperties = {
	_str: "GetStrength",
	_agi: "GetAgility",
	_int: "GetIntellect",
	_all: "GetAllStats",
	_attack_damage: "GetAverageAttackDamage",
	_attack_speed: "GetAttackSpeedPercent",
	_health: "GetMaxHealth",
	_mana: "GetMaxMana",
	_physical_armor: "GetPhysicalArmor",
	_magical_armor: "GetMagicalArmor",
	_move_speed: "GetMoveSpeed",
};

function GetSpecialValuesWithCalculated(sAbilityName, sName, iEntityIndex) {
	let aOriginalValues = GetSpecialValues(sAbilityName, sName, iEntityIndex);
	for (let i = 0; i < aOriginalValues.length; i++) {
		let v = aOriginalValues[i];
		aOriginalValues[i] = CalcSpecialValueUpgrade(iEntityIndex, sAbilityName, sName, v);
	}
	let aValues = JSON.parse(JSON.stringify(aOriginalValues));
	let tAddedValues = {};
	let tAddedFactors = {};
	let aMinValues = GetSpecialValueProperty(sAbilityName, sName, "_min", iEntityIndex);
	if (aMinValues) {
		aMinValues = StringToValues(aMinValues);
		for (let i = 0; i < aMinValues.length; i++) {
			let v = aMinValues[i];
			aMinValues[i] = CalcSpecialValuePropertyUpgrade(iEntityIndex, sAbilityName, sName, "_min", v);
		}
	}
	let aMaxValues = GetSpecialValueProperty(sAbilityName, sName, "_max", iEntityIndex);
	if (aMaxValues) {
		aMaxValues = StringToValues(aMaxValues);
		for (let i = 0; i < aMaxValues.length; i++) {
			let v = aMaxValues[i];
			aMaxValues[i] = CalcSpecialValuePropertyUpgrade(iEntityIndex, sAbilityName, sName, "_max", v);
		}
	}

	let sType = GetSpecialVarType(sAbilityName, sName);
	for (const key in tAddedProperties) {
		const sFuncName = tAddedProperties[key];
		let func = Entities[sFuncName];
		if (typeof (func) != "function") continue;
		let sFactors = GetSpecialValueProperty(sAbilityName, sName, key, iEntityIndex);
		if (sFactors) {
			tAddedValues[key] = [];
			tAddedFactors[key] = [];
			let aFactors = StringToValues(sFactors);
			for (let i = 0; i < aValues.length; i++) {
				let value = aValues[i];
				let factor = aFactors[Clamp(i, 0, aFactors.length)];
				factor = CalcSpecialValuePropertyUpgrade(iEntityIndex, sAbilityName, sName, key, factor);
				tAddedFactors[key][i] = factor;
				let addedValue = factor * func(iEntityIndex);
				value = value + addedValue;
				if (sType == "FIELD_INTEGER") {
					value = parseInt(value);
					addedValue = parseInt(addedValue);
				} else if (sType == "FIELD_FLOAT") {
					value = Float(value);
					addedValue = Float(addedValue);
				}
				tAddedValues[key][i] = addedValue;
				aValues[i] = value;
			}
		}
	}

	if (aMinValues) {
		for (let i = 0; i < aValues.length; i++) {
			aValues[i] = Math.max(aValues[i], aMinValues[Clamp(i, 0, aMinValues.length)]);
		}
	}

	if (aMaxValues) {
		for (let i = 0; i < aValues.length; i++) {
			aValues[i] = Math.min(aValues[i], aMaxValues[Clamp(i, 0, aMaxValues.length)]);
		}
	}

	return {
		aValues: aValues,
		aOriginalValues: aOriginalValues,
		aMinValues: aMinValues,
		aMaxValues: aMaxValues,
		tAddedFactors: tAddedFactors,
		tAddedValues: tAddedValues,
	};
}

CustomUIConfig.ABILITY_UPGRADES_OP_ADD = 0;
CustomUIConfig.ABILITY_UPGRADES_OP_MUL = 1;

CustomUIConfig.ABILITY_UPGRADES_TYPE_SPECIAL_VALUE = 0;
CustomUIConfig.ABILITY_UPGRADES_TYPE_SPECIAL_VALUE_PROPERTY = 1;
CustomUIConfig.ABILITY_UPGRADES_TYPE_STATS = 2;
CustomUIConfig.ABILITY_UPGRADES_TYPE_ABILITY_MECHANICS = 3;
CustomUIConfig.ABILITY_UPGRADES_TYPE_ADD_ABILITY = 4;

CustomUIConfig.UPGRADES_KEY_DATA = 0;
CustomUIConfig.UPGRADES_KEY_CACHED_RESULT = 1;

function upzip(t1, t2) {
	let object = {};
	for (let index = 0; index < t2.length; index++) {
		const k = t1[index];
		const v = t2[index];
		if (v != "null") {
			object[k] = v;
		}
	}
	return object;
}

function GetSpecialValueUpgrade(iEntityIndex, sAbilityName, sSpecialValueName, iOperator) {
	if (!Entities.IsValidEntity(iEntityIndex)) return 0;

	let t = CustomNetTables.GetTableValue("ability_upgrades_result", iEntityIndex.toString());
	if (!t || typeof (t.json) != "string") return 0;

	let tCachedResult = JSON.parse(t.json);
	if (!tCachedResult) return 0;

	let tAllSpecialValueCachedResult = tCachedResult[CustomUIConfig.ABILITY_UPGRADES_TYPE_SPECIAL_VALUE];
	if (typeof (tAllSpecialValueCachedResult) != "object" || typeof (tAllSpecialValueCachedResult[sAbilityName]) != "object" || typeof (tAllSpecialValueCachedResult[sAbilityName][sSpecialValueName]) != "object") return 0;

	return tAllSpecialValueCachedResult[sAbilityName][sSpecialValueName][iOperator] || 0;
}

function CalcSpecialValueUpgrade(iEntityIndex, sAbilityName, sSpecialValueName, fValue) {
	return Float((fValue + GetSpecialValueUpgrade(iEntityIndex, sAbilityName, sSpecialValueName, CustomUIConfig.ABILITY_UPGRADES_OP_ADD)) * (1 + GetSpecialValueUpgrade(iEntityIndex, sAbilityName, sSpecialValueName, CustomUIConfig.ABILITY_UPGRADES_OP_MUL) * 0.01));
}

function GetSpecialValuePropertyUpgrade(iEntityIndex, sAbilityName, sSpecialValueName, sSpecialValueProperty, iOperator) {
	if (!Entities.IsValidEntity(iEntityIndex)) return 0;

	let t = CustomNetTables.GetTableValue("ability_upgrades_result", iEntityIndex.toString());
	if (!t || typeof (t.json) != "string") return 0;

	let tCachedResult = JSON.parse(t.json);
	if (!tCachedResult) return 0;

	let tAllSpecialValuePropertyCachedResult = tCachedResult[CustomUIConfig.ABILITY_UPGRADES_TYPE_SPECIAL_VALUE_PROPERTY];
	if (typeof (tAllSpecialValuePropertyCachedResult) != "object" || typeof (tAllSpecialValuePropertyCachedResult[sAbilityName]) != "object" || typeof (tAllSpecialValuePropertyCachedResult[sAbilityName][sSpecialValueName]) != "object" || typeof (tAllSpecialValuePropertyCachedResult[sAbilityName][sSpecialValueName][sSpecialValueProperty]) != "object") return 0;

	return tAllSpecialValuePropertyCachedResult[sAbilityName][sSpecialValueName][sSpecialValueProperty][iOperator] || 0;
}

function CalcSpecialValuePropertyUpgrade(iEntityIndex, sAbilityName, sSpecialValueName, sSpecialValueProperty, fValue) {
	return Float((fValue + GetSpecialValuePropertyUpgrade(iEntityIndex, sAbilityName, sSpecialValueName, sSpecialValueProperty, CustomUIConfig.ABILITY_UPGRADES_OP_ADD)) * (1 + GetSpecialValuePropertyUpgrade(iEntityIndex, sAbilityName, sSpecialValueName, sSpecialValueProperty, CustomUIConfig.ABILITY_UPGRADES_OP_MUL) * 0.01));
}

function GetAbilityMechanicsUpgradeLevelSpecialValue(iEntityIndex, sAbilityName, sKey, iLevel) {
	if (!Entities.IsValidEntity(iEntityIndex)) return;

	let t = CustomNetTables.GetTableValue("ability_upgrades_result", iEntityIndex.toString());
	if (!t || typeof (t.json) != "string") return;

	let tCachedResult = JSON.parse(t.json);
	if (!tCachedResult) return;

	let tAllAbilityMechanicsCachedResult = tCachedResult[CustomUIConfig.ABILITY_UPGRADES_TYPE_ABILITY_MECHANICS];
	if (typeof (tAllAbilityMechanicsCachedResult) != "object" || typeof (tAllAbilityMechanicsCachedResult[sAbilityName]) != "object") return;

	let tAbilityMechanicsCachedResult = tAllAbilityMechanicsCachedResult[sAbilityName];
	for (const sDescription in tAbilityMechanicsCachedResult) {
		const tValues = tAbilityMechanicsCachedResult[sDescription];
		let aValues = tValues[sKey];
		if (aValues && aValues.value) {
			return aValues.value[Clamp(iLevel, 0, aValues.value.length - 1)];
		}
	}

	return;
}

function GetAbilityMechanicsUpgradeLevelSpecialValueProperty(iEntityIndex, sAbilityName, sKey, sPropertyName) {
	if (!Entities.IsValidEntity(iEntityIndex)) return;

	let t = CustomNetTables.GetTableValue("ability_upgrades_result", iEntityIndex.toString());
	if (!t || typeof (t.json) != "string") return;

	let tCachedResult = JSON.parse(t.json);
	if (!tCachedResult) return;

	let tAllAbilityMechanicsCachedResult = tCachedResult[CustomUIConfig.ABILITY_UPGRADES_TYPE_ABILITY_MECHANICS];
	if (typeof (tAllAbilityMechanicsCachedResult) != "object" || typeof (tAllAbilityMechanicsCachedResult[sAbilityName]) != "object") return;

	let tAbilityMechanicsCachedResult = tAllAbilityMechanicsCachedResult[sAbilityName];
	for (const sDescription in tAbilityMechanicsCachedResult) {
		const tValues = tAbilityMechanicsCachedResult[sDescription];
		let aValues = tValues[sKey];
		if (aValues) {
			return aValues[sPropertyName];
		}
	}

	return;
}

function GetAbilityMechanicsUpgradeSpecialValues(iEntityIndex, sAbilityName, sKey) {
	if (!Entities.IsValidEntity(iEntityIndex)) return;

	let t = CustomNetTables.GetTableValue("ability_upgrades_result", iEntityIndex.toString());
	if (!t || typeof (t.json) != "string") return;

	let tCachedResult = JSON.parse(t.json);
	if (!tCachedResult) return;

	let tAllAbilityMechanicsCachedResult = tCachedResult[CustomUIConfig.ABILITY_UPGRADES_TYPE_ABILITY_MECHANICS];
	if (typeof (tAllAbilityMechanicsCachedResult) != "object" || typeof (tAllAbilityMechanicsCachedResult[sAbilityName]) != "object") return;

	let tAbilityMechanicsCachedResult = tAllAbilityMechanicsCachedResult[sAbilityName];
	for (const sDescription in tAbilityMechanicsCachedResult) {
		const tValues = tAbilityMechanicsCachedResult[sDescription];
		let aValues = tValues[sKey];
		if (aValues && aValues.value) {
			return aValues.value;
		}
	}

	return;
}

function GetAbilityMechanicsUpgradeSpecialNames(iEntityIndex, sAbilityName) {
	if (!Entities.IsValidEntity(iEntityIndex)) return [];

	let t = CustomNetTables.GetTableValue("ability_upgrades_result", iEntityIndex.toString());
	if (!t || typeof (t.json) != "string") return [];

	let tCachedResult = JSON.parse(t.json);
	if (!tCachedResult) return [];

	let tAllAbilityMechanicsCachedResult = tCachedResult[CustomUIConfig.ABILITY_UPGRADES_TYPE_ABILITY_MECHANICS];
	if (typeof (tAllAbilityMechanicsCachedResult) != "object" || typeof (tAllAbilityMechanicsCachedResult[sAbilityName]) != "object") return [];

	let aNames = [];
	let tAbilityMechanicsCachedResult = tAllAbilityMechanicsCachedResult[sAbilityName];
	for (const sDescription in tAbilityMechanicsCachedResult) {
		const tValues = tAbilityMechanicsCachedResult[sDescription];
		for (const sName in tValues) {
			aNames.push(sName);
		}
	}

	return aNames;
}

function GetUnitAbilities(sUnitName) {
	var tUnitKeyValues = CustomUIConfig.UnitsKv[sUnitName];

	var aAbilities = [];

	if (tUnitKeyValues) {
		for (var i = 0; i < 32; i++) {
			var sKey = "Ability" + (i + 1).toString();
			if (tUnitKeyValues[sKey] && tUnitKeyValues[sKey] != "") {
				aAbilities.push(tUnitKeyValues[sKey]);
			}
		}
	}

	return aAbilities;
}

function GetItemValue(sItemName, sKeyName) {
	var tItemKeyValues = CustomUIConfig.ItemsKv[sItemName];

	if (tItemKeyValues) {
		return tItemKeyValues[sKeyName];
	}
	return;
}

function GetItemAdvancedName(sItemName) {
	return GetItemValue(sItemName, "ItemAdvancedName");
}

function GetItemAdvancedCost(sItemName) {
	return GetItemValue(sItemName, "ItemAdvancedCost");
}

function GetItemUpgradedCost(sItemName) {
	return GetItemValue(sItemName, "ItemUpgradedCost");
}

function GetItemCost(sItemName) {
	return Number(GetItemValue(sItemName, "ItemCost")) || 0;
}

function GetItemRarity(sItemName) {
	let iRarity = GetItemValue(sItemName, "Rarity");
	if (iRarity == undefined || iRarity == null) {
		return -1;
	}
	return iRarity;
}


CustomUIConfig.GetCursorEntity = function (aPosition = GameUI.GetCursorPosition()) {
	var targets = GameUI.FindScreenEntities(aPosition);
	var world_position = GameUI.GetScreenWorldPosition(aPosition);
	var targets1 = targets.filter((e) => {
		return e.accurateCollision;
	});
	var targets2 = targets.filter((e) => {
		return !e.accurateCollision;
	});
	targets = targets1;
	if (targets1.length == 0) {
		targets = targets2;
	}
	if (targets.length == 0) {
		return -1;
	}
	targets.sort((a, b) => {
		let a_loc = Entities.GetAbsOrigin(a.entityIndex);
		let b_loc = Entities.GetAbsOrigin(b.entityIndex);
		return Game.Length2D(a_loc, world_position) - Game.Length2D(b_loc, world_position);
	});
	return targets[0].entityIndex;
};

CustomUIConfig.GetCursorPhysicalItem = function (aPosition = GameUI.GetCursorPosition()) {
	var targets = GameUI.FindScreenEntities(aPosition);
	var world_position = GameUI.GetScreenWorldPosition(aPosition);
	targets = targets.filter((e) => {
		return Entities.IsItemPhysical(e.entityIndex);
	});
	var targets1 = targets.filter((e) => {
		return e.accurateCollision;
	});
	var targets2 = targets.filter((e) => {
		return !e.accurateCollision;
	});
	targets = targets1;
	if (targets1.length == 0) {
		targets = targets2;
	}
	if (targets.length == 0) {
		return -1;
	}
	targets.sort((a, b) => {
		let a_loc = Entities.GetAbsOrigin(a.entityIndex);
		let b_loc = Entities.GetAbsOrigin(b.entityIndex);
		return Game.Length2D(a_loc, world_position) - Game.Length2D(b_loc, world_position);
	});
	return targets[0].entityIndex;
};


var _Request_QueueIndex = 0;
var _Request_Table = {};

function Request(event, data, func, timeout) {
	var index = "-1";
	if (typeof func === "function") {
		index = (_Request_QueueIndex++).toString();
		_Request_Table[index] = func;
	}
	GameEvents.SendCustomGameEventToServer("service_events_req", {
		eventName: event,
		data: JSON.stringify(data),
		queueIndex: index
	});
	timeout = timeout || REQUEST_TIME_OUT;
	$.Schedule(timeout, function () {
		delete _Request_Table[index];
	});
}
GameEvents.Subscribe("service_events_res", function (data) {
	var index = data.queueIndex || "";
	var func = _Request_Table[index];
	if (!func) return;
	delete _Request_Table[index];
	if (func) {
		func(JSON.parse(data.result));
	};
});

/**
 * 获取游戏是团队还是个人模式
 * @return: 0:团队，1:个人
 */
CustomUIConfig.GetCountingMode = function () {
	var table = CustomNetTables.GetTableValue("common", "game_mode_info");
	return table.counting_mode;
};
CustomUIConfig.GetDifficulty = function () {
	var slocalPlayerID = Players.GetLocalPlayer().toString();
	var table = CustomNetTables.GetTableValue("common", "game_mode_info");
	return table.difficulty[slocalPlayerID];
};

function IsNull(variable) {
	return variable == null || variable == undefined;
}

function GetNameBySteamID(sSteamID) {
	return CustomUIConfig.tSteamID2Name[sSteamID];
}

function RequestSteamID2Name(tSteamIDs, fCallBack) {
	var tRequestSteamIDs = [];
	// 仅请求还未获取的steamid
	for (var i in tSteamIDs) {
		if (IsNull(CustomUIConfig.tSteamID2Name[tSteamIDs[i]])) {
			tRequestSteamIDs.push(tSteamIDs[i]);
		}
	}
	if (tRequestSteamIDs.length < 1) {
		if (typeof (fCallBack) == "function") {
			fCallBack();
		}
		return;
	}

	let url = "http://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=" + STEAM_WEB_KEY + "&steamids=" + tRequestSteamIDs.join(',');
	$.AsyncWebRequest(url, {
		type: 'GET',
		timeout: 6000,
		success: function (tData, b, c) {
			for (var i in tData.response.players) {
				CustomUIConfig.tSteamID2Name[tData.response.players[i].steamid] = tData.response.players[i].personaname;
			}
			if (typeof (fCallBack) == "function") {
				fCallBack();
			}
		},
		error: function (a) {
			$.Msg("RequestSteamID2Name fail");
		},
	});
}

var print = $.Msg;

function _TimerFunction() {
	if (typeof (CustomUIConfig.Timers) == "object") {
		let fTime = Game.Time();
		let bNoSchedule = false;

		let aKeys = Object.keys(CustomUIConfig.Timers);
		for (let index = aKeys.length - 1; index >= 0; index--) {
			let sKey = aKeys[index];

			let tData = CustomUIConfig.Timers[sKey];
			if (tData) {
				let time = tData.time;
				if (typeof (time) == "number") {
					if (fTime < time) continue;

					if (tData.running == true) {
						bNoSchedule = true;
						continue;
					}

					let callback = tData.callback;
					if (typeof (callback) == "function") {
						tData.running = true;
						let result = callback();
						tData.running = false;
						if (typeof (result) == "number") {
							tData.time = fTime + result;
							continue;
						}
					}
				}
			}

			CustomUIConfig.Timers[sKey] = undefined;
			delete CustomUIConfig.Timers[sKey];
			aKeys.splice(index, 1);
		}

		if (!bNoSchedule) {
			CustomUIConfig.iScheduleHandle = $.Schedule(Game.GetGameFrameTime(), _TimerFunction);
		}
	}
}

function Timer(sKey, fTime, funcCallback) {
	if (typeof (CustomUIConfig.Timers) != "object") {
		CustomUIConfig.Timers = {};
	}

	if (typeof (fTime) == "number" && typeof (funcCallback) == "function") {
		if (fTime == 0) fTime = 0.0001;
		CustomUIConfig.Timers[sKey] = {
			time: Game.Time() + fTime,
			callback: funcCallback,
			running: false,
		};
	} else {
		CustomUIConfig.Timers[sKey] = undefined;
	}

	if (CustomUIConfig.iScheduleHandle) {
		try {
			$.CancelScheduled(CustomUIConfig.iScheduleHandle);
		} catch (error) { }
		CustomUIConfig.iScheduleHandle = undefined;
	}
	_TimerFunction();

	// print(sKey, "\t", fTime, "\t", funcCallback)
}

CustomUIConfig.ShowAbilityTooltiop = (panel, abilityname, entityindex = -1, inventoryslot = -1, level = -1) => {
	if (typeof (panel) != "object" || typeof (panel.IsValid) != "function" || !panel.IsValid()) {
		throw "ShowAbilityTooltiop must have a panel parameter!";
	}
	if (typeof (abilityname) != "string") {
		throw "abilityname is not a string type!";
	}
	$.DispatchEvent("UIShowCustomLayoutParametersTooltip", panel, "AbilityTooltiop", "file://{resources}/layout/custom_game/tooltips/tooltip_ability/tooltip_ability.xml", "abilityname=" + abilityname + "&entityindex=" + entityindex + "&inventoryslot=" + inventoryslot + "&level=" + level);
};

CustomUIConfig.HideAbilityTooltiop = (panel) => {
	if (typeof (panel) != "object" || typeof (panel.IsValid) != "function" || !panel.IsValid()) {
		throw "ShowAbilityTooltiop must have a panel parameter!";
	}
	$.DispatchEvent("UIHideCustomLayoutTooltip", panel, "AbilityTooltiop");
};

(function () {
	GameEvents.Subscribe("error_message", OnErrorMessage);
})();

function ReloadPanel(Panel, PanelType, ParentPanel, PanelID) {
	if (Panel == undefined || Panel == null) {
		Panel = $.CreatePanel(PanelType, ParentPanel, PanelID);
	} else {
		Panel.RemoveAndDeleteChildren();
	}
	return Panel;
}
function ReloadPanelWithProperties(Panel, PanelType, ParentPanel, PanelID, Properties) {
	if (Panel == undefined || Panel == null) {
		Panel = $.CreatePanelWithProperties(PanelType, ParentPanel, PanelID, Properties);
	} else {
		Panel.RemoveAndDeleteChildren();
	}
	return Panel;
}
function GetBadgesBackground(iLevel) {
	return "file://{images}/profile_badges/bg_0" + Math.ceil(iLevel / 100) + ".psd";
}
function GetBadgesLevel(iLevel) {
	return "file://{images}/profile_badges/level_" + (Array(2).join(0) + iLevel).slice(-2) + ".png";
}
function GetBadgesBackgroundNumber(iLevel) {
	return "file://{images}/profile_badges/bg_number_0" + Math.ceil(iLevel / 100) + ".psd";
}
function GetAttributeIcon(Attribute) {
	switch (Attributes[Attribute]) {
		case Attributes.DOTA_ATTRIBUTE_STRENGTH:
			return "s2r://panorama/images/primary_attribute_icons/primary_attribute_icon_strength_psd.vtex";
		case Attributes.DOTA_ATTRIBUTE_AGILITY:
			return "s2r://panorama/images/primary_attribute_icons/primary_attribute_icon_agility_psd.vtex";
		case Attributes.DOTA_ATTRIBUTE_INTELLECT:
			return "s2r://panorama/images/primary_attribute_icons/primary_attribute_icon_intelligence_psd.vtex";
		default:
			break;
	}
}
function GetPlayerShard(sPlayerID) {
	let tData = CustomNetTables.GetTableValue("service", "player_data");
	return tData[sPlayerID].Shard;
}
function GetPlayerPrice(sPlayerID) {
	let tData = CustomNetTables.GetTableValue("service", "player_data");
	return tData[sPlayerID].Price;
}
function GetCourierItemDef(sCourierName) {
	return GameUI.CustomUIConfig().PetsKv[sCourierName].ItemDef;
}

function ReadAttributeData(data) {
	var retStr = "";
	for (var key in data) {
		retStr += key + "=" + data[key] + "&";
	}
	return retStr;
}

function GetCourierItemStyle(sCourierName) {
	return GameUI.CustomUIConfig().PetsKv[sCourierName].ItemStyle || 0;
}
function GetHeroesRebornCount(iEntity) {
	for (let index = 0; index < Entities.GetNumBuffs(iEntity); index++) {
		const buff = Entities.GetBuff(iEntity, index);
		if (Buffs.GetName(iEntity, buff) == "modifier_reborn") {
			return Buffs.GetStackCount(iEntity, buff);
		}
	}
	return 0;
}
// 获取英雄穿戴的皮肤
function GetSkinName(iEntity) {
	for (const sItemName in GameUI.CustomUIConfig().PlayerItemsKV) {
		let tItemData = GameUI.CustomUIConfig().PlayerItemsKV[sItemName];
		if (tItemData.Hero && tItemData.Hero == Entities.GetUnitName(iEntity)) {
			if (Entities.HasModifier(iEntity, "modifier_" + sItemName)) {
				return sItemName;
			}
		}
	}
	return false;
}
Entities.HasModifier = function (iEntIndex, sModifierName) {
	for (let index = 0; index < Entities.GetNumBuffs(iEntIndex); index++) {
		const buff = Entities.GetBuff(iEntIndex, index);
		if (Buffs.GetName(iEntIndex, buff) == sModifierName) {
			return true;
		}
	}
	return false;
};
GameUI.GetPanelCenter = function (Panel) {
	let Position = GameUI.GetPanelPosition(Panel);
	return { x: Position.x + Panel.actuallayoutwidth / 2, y: Position.y + Panel.actuallayoutheight / 2 };
};
GameUI.GetPanelPosition = function (Panel) {
	let Position = Panel.GetPositionWithinWindow();
	return { x: Position.x, y: Position.y };
};
GameUI.GetHUDSeed = function () {
	return 1080 / Game.GetScreenHeight();
};
GameUI.CorrectPositionValue = function (value) {
	return GameUI.GetHUDSeed() * value;
};
function print(...args) {
	let params = [];
	for (let i = 0; i < arguments.length; i++) {
		params.push(arguments[i], ' ');
	}
	return $.Msg(...params);
}

function ToggleWindows(sName) {
	GameEvents.SendEventClientSide("custom_ui_toggle_windows", { window_name: sName });
}
function Transform(obj, sTagName) {
	let tHeader = CustomNetTables.GetTableValue("header", sTagName);
	let _obj = Array.isArray(obj) ? [] : {};
	for (let i in obj) {
		if (typeof obj[i] === 'object') {
			_obj[tHeader[i] || i] = Transform(obj[i], sTagName);
		}
		else {
			if (typeof obj[i] === 'string') {
				_obj[tHeader[i] || i] = tHeader[obj[i]] || obj[i];
			} else {
				_obj[tHeader[i] || i] = obj[i];
			}
		}
	}
	return _obj;
}
