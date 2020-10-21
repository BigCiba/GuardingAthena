import { compose } from "../AbilityDetails/utils"

export function GetAbilityUpgradeDescription(tData) {
	function _replaceValues(sStr, tValues) {
		for (const sValueName in tValues) {
			const value = tValues[sValueName];

			let block = new RegExp("%" + sValueName + "%", "g");
			let blockPS = new RegExp("%" + sValueName + "%%", "g");
			let iResult = sStr.search(block);
			let iResultPS = sStr.search(blockPS);
			if (iResult == -1 && iResultPS == -1) continue;

			let aValues
			if (typeof (value) == "number") {
				aValues = [Float(value)];
			} else if (typeof (value) == "string") {
				aValues = StringToValues(value);
			} else if (typeof (value) == "object" && value.value) {
				if (typeof (value.value) == "number") {
					aValues = [Float(value.value)];
				} else if (typeof (value.value) == "string") {
					aValues = StringToValues(value.value);
				} else {
					continue;
				}
			} else {
				continue;
			}

			let [sValues, sValuesPS] = compose(aValues);

			let tAddedFactors = {};
			for (const key in tAddedProperties) {
				const sFuncName = tAddedProperties[key];
				let func = Entities[sFuncName];
				if (typeof (func) != "function") continue;
				let factor = value[key];
				let aAddedFactor
				if (typeof (factor) == "number") {
					aAddedFactor = [Float(factor)];
				} else if (typeof (factor) == "string") {
					aAddedFactor = StringToValues(factor);
				}

				if (aAddedFactor) {
					tAddedFactors[key] = aAddedFactor;
				}
			}

			for (const key in tAddedFactors) {
				const aAddedFactors = tAddedFactors[key];
				let [sTemp, sTempPS] = compose(aAddedFactors);
				sValues = sValues + "[+" + $.Localize("dota_tooltip_ability_variable" + key) + "x" + sTemp + "]";
				sValuesPS = sValuesPS + "[+" + $.Localize("dota_tooltip_ability_variable" + key) + "x" + sTempPS + "]";
			}

			sStr = sStr.replace(blockPS, sValuesPS);
			sStr = sStr.replace(block, sValues);
		}
		return sStr;
	}

	let iType = tData.type - 1;
	let iOperator = tData.operator - 1;
	let fValue = tData.value;
	let sSpecialValueName = tData.special_value_name;
	let sSpecialValueProperty = tData.special_value_property;
	let sAbilityName = tData.ability_name;
	let sDescription = tData.description;
	let tValues = tData.values;
	switch (iType) {
		case CustomUIConfig.ABILITY_UPGRADES_TYPE_SPECIAL_VALUE: {
			let sLocAbilityName = $.Localize("DOTA_Tooltip_ability_" + sAbilityName);
			let bHasPercentSign = iOperator == CustomUIConfig.ABILITY_UPGRADES_OP_MUL;
			let sLocSpecialValueName
			switch (sSpecialValueName) {
				case "mana_cost":
					sLocSpecialValueName = $.Localize("dota_tooltip_ability_upgrades_mana_cost")
					break;
				case "cooldown":
					sLocSpecialValueName = $.Localize("dota_tooltip_ability_upgrades_cooldown")
					break;
				default:
					sLocSpecialValueName = $.Localize("dota_tooltip_ability_" + sAbilityName + "_" + sSpecialValueName)
					if (sLocSpecialValueName.search(/%/g) == 0) {
						bHasPercentSign = true;
						sLocSpecialValueName = sLocSpecialValueName.substr(1);
					}
					break;
			}
			let sValue = fValue > 0 ? "+" + Float(fValue) : fValue.toString();
			if (bHasPercentSign) {
				sValue = sValue + "%";
			}

			sLocSpecialValueName = sLocSpecialValueName.replace(/:/g, "");
			sLocSpecialValueName = sLocSpecialValueName.replace(/：/g, "");
			return sValue + " " + sLocAbilityName + sLocSpecialValueName;
		}
		case CustomUIConfig.ABILITY_UPGRADES_TYPE_SPECIAL_VALUE_PROPERTY: {
			let sLocAbilityName = $.Localize("DOTA_Tooltip_ability_" + sAbilityName);
			let sLocSpecialValueName
			switch (sSpecialValueName) {
				case "mana_cost":
					sLocSpecialValueName = $.Localize("dota_tooltip_ability_upgrades_mana_cost")
					break;
				case "cooldown":
					sLocSpecialValueName = $.Localize("dota_tooltip_ability_upgrades_cooldown")
					break;
				default:
					sLocSpecialValueName = $.Localize("dota_tooltip_ability_" + sAbilityName + "_" + sSpecialValueName)
					break;
			}
			let sValue = fValue > 0 ? "+" + Float(fValue) : fValue.toString();

			sLocSpecialValueName = sLocSpecialValueName.replace(/:/g, "");
			sLocSpecialValueName = sLocSpecialValueName.replace(/：/g, "");

			let sLocSpecialValueProperty = $.Localize("dota_tooltip_ability_variable" + sSpecialValueProperty);

			return sValue + " " + sLocAbilityName + sLocSpecialValueName + sLocSpecialValueProperty + $.Localize("dota_tooltip_ability_upgrades_factor");
		}
		case CustomUIConfig.ABILITY_UPGRADES_TYPE_STATS: {
			let sLocSpecialValueName = $.Localize("dota_tooltip_ability_upgrades_stats_" + sSpecialValueName)
			let bHasPercentSign = false;
			if (sLocSpecialValueName.search(/%/g) == 0) {
				bHasPercentSign = true;
				sLocSpecialValueName = sLocSpecialValueName.substr(1);
			}

			let sValue = fValue > 0 ? "+" + Float(fValue) : fValue.toString();
			if (bHasPercentSign) {
				sValue = sValue + "%";
			}

			return sValue + " " + sLocSpecialValueName;
		}
		case CustomUIConfig.ABILITY_UPGRADES_TYPE_ABILITY_MECHANICS: {
			let s = $.Localize("dota_tooltip_ability_mechanics_" + sAbilityName + "_" + sDescription);
			s = s.replace(/%%/g, "%");
			return _replaceValues(s, tValues);
		}
		case CustomUIConfig.ABILITY_UPGRADES_TYPE_ADD_ABILITY: {
			return $.Localize(sDescription);
		}
		default: {
			return $.Localize(sDescription);
		}
	}
}
