import React from 'react';
import { GetAbilityUpgradeDescription } from './utils';

export function AbilityUpgradeImage({ abilityData, showtooltip = true, ...other }) {
	let laterPanelEvent = element => {
		if (element != null) {
			element.SetPanelEvent("onmouseover", () => {
				if (showtooltip) {
					$.DispatchEvent("DOTAShowTextTooltip", element, GetAbilityUpgradeDescription(abilityData));
				}
			})
			element.SetPanelEvent("onmouseout", () => {
				$.DispatchEvent("DOTAHideTextTooltip", element);
			})
		}
	}
	return (
		<DOTAAbilityImage showtooltip={false} {...other} abilityname={abilityData.type - 1 == CustomUIConfig.ABILITY_UPGRADES_TYPE_STATS ? "attribute_bonus" : abilityData.ability_name} ref={laterPanelEvent} />
	)
}