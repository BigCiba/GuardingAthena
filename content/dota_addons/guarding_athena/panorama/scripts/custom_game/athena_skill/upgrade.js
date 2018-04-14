var doubleclick = false
function HpButton() {
         GameEvents.SendCustomGameEventToServer( "hp_click", {} );
}
function RegenButton() {
         GameEvents.SendCustomGameEventToServer( "regen_click", {} );
}
function ArmorButton() {
         GameEvents.SendCustomGameEventToServer( "armor_click", {} );
}
function HpButtonDoubleClick() {
    doubleclick = true
    $.Schedule(0.1,function(){
        if (doubleclick) {
            GameEvents.SendCustomGameEventToServer( "hp_click", {} );
            HpButtonDoubleClick();
        }
    });
}
function RegenButtonDoubleClick() {
    doubleclick = true
    $.Schedule(0.1,function(){
        if (doubleclick) {
            GameEvents.SendCustomGameEventToServer( "regen_click", {} );
            RegenButtonDoubleClick();
        }
    });
}
function ArmorButtonDoubleClick() {
    doubleclick = true
    $.Schedule(0.1,function(){
        if (doubleclick) {
            GameEvents.SendCustomGameEventToServer( "armor_click", {} );
            ArmorButtonDoubleClick();
        }
    });
}
function OnHpMouseOut() {
    doubleclick = false;
    $.DispatchEvent( 'DOTAHideTextTooltip', $("#HpButton") );
}
function OnRegenMouseOut() {
    doubleclick = false;
    $.DispatchEvent( 'DOTAHideTextTooltip', $("#RegenButton") );
}
function OnArmorMouseOut() {
    doubleclick = false;
    $.DispatchEvent( 'DOTAHideTextTooltip', $("#ArmorButton") );
}
(function () {
   $.Schedule(21, function(){$("#UpgradeBG").style.visibility = "visible";});
})();