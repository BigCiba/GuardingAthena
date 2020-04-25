"use strict";
function Update() {
    $.Schedule(0, Update);
    if (!Game.IsInToolsMode()) {
        $.GetContextPanel().style.visibility = "collapse";
    }
    // if (CustomNetTables.GetTableValue("common", "settings").is_cheat_mode == 0)
    //     $.GetContextPanel().style.visibility = "collapse";
    // var settings = CustomNetTables.GetTableValue("common", "hero_demo_settings") || {};
    // $("#FreeSpellsButton").SetSelected(settings.free_spells == 1);
    // $("#LaneCreepsButton").SetSelected(settings.creeps == 0);
}
function ToggleHeroPicker() {
    $('#SelectHeroContainer').ToggleClass('HeroPickerVisible');
}
function SwitchToNewHero(nHeroID) {
    $('#SelectHeroContainer').RemoveClass('HeroPickerVisible');
    $.DispatchEvent('FireCustomGameEvent_Str', 'SelectHeroButtonPressed', String(nHeroID));
}
(function () {
    Update();
    $.RegisterEventHandler('DOTAUIHeroPickerHeroSelected', $('#SelectHeroContainer'), SwitchToNewHero);
    $.RegisterEventHandler('DOTAUIHeroPickerHeroSelected', $('#UpdateAbilityHeroContainer'), OnNewHeroAbility);
})();
var iCursorEntIndex = 0;
function ToggleUpdateAbility() {
    if ($('#UpdateAbilityHeroContainer').BHasClass('HeroPickerVisible')) {
        sAbltOld = '';
        $('#UpdateAbilityHeroContainer').RemoveClass('HeroPickerVisible');
        return;
    }
    let pContainer = $('#UpdateAbilityContainer');
    pContainer.ToggleClass('UpdateAbilityVisible');
    if (!pContainer.BHasClass('UpdateAbilityVisible')) {
        sAbltOld = '';
        $('#UpdateAbilityHeroContainer').RemoveClass('HeroPickerVisible');
        return;
    }
    let iLocalPlayerID = Players.GetLocalPlayer();
    let arrEnts = Players.GetSelectedEntities(iLocalPlayerID);
    if (0 >= arrEnts.length)
        return;
    iCursorEntIndex = arrEnts[0];
    let tAblts = [];
    for (let i = 0; i < Entities.GetAbilityCount(iCursorEntIndex); i++) {
        const iAbilityEntIndex = Entities.GetAbility(iCursorEntIndex, i);
        if (iAbilityEntIndex == -1)
            continue;
        if (Abilities.IsHidden(iAbilityEntIndex))
            continue;
        if (Abilities.GetAbilityType(iAbilityEntIndex) == ABILITY_TYPES.ABILITY_TYPE_ATTRIBUTES)
            continue;
        if (Abilities.GetAbilityType(iAbilityEntIndex) == ABILITY_TYPES.ABILITY_TYPE_HIDDEN)
            continue;
        tAblts.push(Abilities.GetAbilityName(iAbilityEntIndex));
    }
    tAblts.push('generic_hidden');
    SetAbltByUpdateAbility(tAblts);
}
var sAbltOld = '';
function OnAbility(pBtn) {
    if ('' != sAbltOld) {
        let json = JSON.stringify({
            'entid': iCursorEntIndex,
            'ablt_name_old': sAbltOld,
            'ablt_name_new': pBtn.FindChildTraverse('AbilityImage').abilityname,
        });
        $.DispatchEvent('FireCustomGameEvent_Str', 'UpdateAbilityButtonPressed', json);
        sAbltOld = '';
    }
    else {
        sAbltOld = pBtn.FindChildTraverse('AbilityImage').abilityname;
        $('#UpdateAbilityHeroContainer').ToggleClass('HeroPickerVisible');
    }
    $('#UpdateAbilityContainer').ToggleClass('UpdateAbilityVisible');
}
function OnNewHeroAbility(nHeroID) {
    let sHeroName = GetHeroNameByID(nHeroID);
    if (undefined == sHeroName)
        return;
    let tAblts = GetHeroAbilities(sHeroName);
    tAblts = tAblts.filter((sAbltName) => {
        return 'generic_hidden' != sAbltName;
    });
    tAblts.push('generic_hidden');
    SetAbltByUpdateAbility(tAblts);
    $('#UpdateAbilityHeroContainer').RemoveClass('HeroPickerVisible');
}
function SetAbltByUpdateAbility(tAbltName) {
    let pContainer = $('#UpdateAbilityContainer');
    let i = 0;
    for (i = 0; i < tAbltName.length; i++) {
        const sAbltName = tAbltName[i];
        let pUpdateAbility = pContainer.GetChild(i);
        if (pUpdateAbility == undefined || pUpdateAbility == null) {
            pUpdateAbility = $.CreatePanel("Panel", pContainer, "");
            if (pUpdateAbility.BLoadLayoutSnippet("UpdateAbility")) {
                let pBtn = pUpdateAbility.GetChild(pUpdateAbility.GetChildCount() - 1);
                pBtn.SetPanelEvent('onactivate', OnAbility.bind(this, pBtn));
                pBtn.SetPanelEvent("onmouseover", function () {
                    $.DispatchEvent("DOTAShowAbilityTooltip", pBtn, pBtn.FindChildTraverse('AbilityImage').abilityname);
                });
                pBtn.SetPanelEvent("onmouseout", function () {
                    $.DispatchEvent("DOTAHideAbilityTooltip", pBtn);
                });
            }
        }
        pUpdateAbility.FindChildTraverse("AbilityImage").abilityname = sAbltName;
        const sBehavior = GetAbilityBehavior(sAbltName);
        if (undefined != sBehavior) {
            pUpdateAbility.SetHasClass("IsPassive", sBehavior.indexOf("DOTA_ABILITY_BEHAVIOR_PASSIVE") != -1);
            pUpdateAbility.SetHasClass("IsAutoCast", sBehavior.indexOf("DOTA_ABILITY_BEHAVIOR_AUTOCAST") != -1);
        }
        pUpdateAbility.style.visibility = 'visible';
    }
    while (true) {
        let pUpdateAbility = pContainer.GetChild(i);
        if (pUpdateAbility == undefined || pUpdateAbility == null) {
            break;
        }
        i += 1;
        pUpdateAbility.style.visibility = 'collapse';
    }
    pContainer.SetHasClass('UpdateAbilityVisible', true);
}
