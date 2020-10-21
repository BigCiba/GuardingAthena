import { AbilityDetails } from '../../elements/AbilityDetails/AbilityDetails';
import React from 'react';
import { render } from 'react-panorama';

let pSelf = $.GetContextPanel();
let m_iAbilityIndex = -1;
let m_sAbilityName = "";
let m_iEntityIndex = -1;
let m_iInventorySlot = -1;
let m_iLevel = -1;
let m_iCastRangeParticleID = -1;
let m_bToggleState = false;

function Update() {
	let bAltDown = GameUI.IsAltDown();
	if (pSelf.BHasClass("ShowExtraDescription")) {
		if (!bAltDown) {
			pSelf.RemoveClass("ShowExtraDescription");
			if (pSelf.BAscendantHasClass("TooltipVisible")) {
				CustomUIConfig.ShowAbilityTooltiop(pSelf.GetTooltipTarget(), m_sAbilityName, m_iEntityIndex, m_iInventorySlot, m_iLevel)
			}
		}
	} else {
		if (bAltDown) {
			pSelf.AddClass("ShowExtraDescription");
			if (pSelf.BAscendantHasClass("TooltipVisible")) {
				CustomUIConfig.ShowAbilityTooltiop(pSelf.GetTooltipTarget(), m_sAbilityName, m_iEntityIndex, m_iInventorySlot, m_iLevel)
			}
		}
	}

	if (m_iAbilityIndex != -1) {
		if (m_bToggleState != Abilities.GetToggleState(m_iAbilityIndex)) {
			CustomUIConfig.ShowAbilityTooltiop(pSelf.GetTooltipTarget(), m_sAbilityName, m_iEntityIndex, m_iInventorySlot, m_iLevel)
		}
	}
	if (!pSelf.BAscendantHasClass("TooltipVisible")) {
		m_iAbilityIndex = -1;
		if (m_iCastRangeParticleID != -1) {
			Particles.DestroyParticleEffect(m_iCastRangeParticleID, false);
			m_iCastRangeParticleID = -1;
		}
		m_bToggleState = false;
	}
	$.Schedule(Game.GetGameFrameTime(), Update);
}

function SetupTooltip() {
	m_iAbilityIndex = -1;
	m_sAbilityName = pSelf.GetAttributeString("abilityname", "");
	m_iEntityIndex = pSelf.GetAttributeInt("entityindex", -1);
	m_iInventorySlot = pSelf.GetAttributeInt("inventoryslot", -1);
	m_iLevel = pSelf.GetAttributeInt("level", -1);
	if (m_iEntityIndex != -1 && m_iInventorySlot != -1) {
		m_iAbilityIndex = Entities.GetItemInSlot(m_iEntityIndex, m_iInventorySlot);
		if (m_iAbilityIndex && m_iAbilityIndex != -1)
			m_sAbilityName = Abilities.GetAbilityName(m_iAbilityIndex);
	} else if (m_iEntityIndex != -1) {
		m_iAbilityIndex = Entities.GetAbilityByName(m_iEntityIndex, m_sAbilityName);
	}

	let tAbility = CustomUIConfig.AbilitiesKv[m_sAbilityName];
	let tItem = CustomUIConfig.ItemsKv[m_sAbilityName];
	let tData = tAbility || tItem;
	let bIsItem = (tData == tItem);
	pSelf.SetHasClass("IsItem", bIsItem);
	render(<AbilityDetails id="AbilityDetails" abilityname={m_sAbilityName} entityindex={m_iEntityIndex} inventoryslot={m_iInventorySlot} level={m_iLevel} showextradescription={pSelf.BHasClass("ShowExtraDescription")} />, pSelf);

	if (m_iAbilityIndex != -1) {
		m_bToggleState = Abilities.GetToggleState(m_iAbilityIndex);

		let fCastRange = Abilities.GetCastRange(m_iAbilityIndex);
		if (m_iCastRangeParticleID == -1) {
			m_iCastRangeParticleID = Particles.CreateParticle("particles/ui_mouseactions/range_display.vpcf", ParticleAttachment_t.PATTACH_CUSTOMORIGIN, -1);
		}
		Particles.SetParticleControlEnt(m_iCastRangeParticleID, 0, m_iEntityIndex, ParticleAttachment_t.PATTACH_ABSORIGIN_FOLLOW, "", Entities.GetAbsOrigin(m_iEntityIndex), true);
		Particles.SetParticleControl(m_iCastRangeParticleID, 1, [fCastRange, 1, 1]);
	}
}


(function () {
	pSelf.SetPanelEvent("ontooltiploaded", SetupTooltip);
	render(<AbilityDetails id="AbilityDetails" />, pSelf);
	Update();
})();