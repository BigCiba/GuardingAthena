"use strict";
function HpButton() {
         GameEvents.SendCustomGameEventToServer( "hp_click", {} );
}
function RegenButton() {
         // 发送数据到Lua请求打开UI
         // 即使没有数据第二个参数也要填
         GameEvents.SendCustomGameEventToServer( "regen_click", {} );
}
function ArmorButton() {
         // 发送数据到Lua请求打开UI
         // 即使没有数据第二个参数也要填
         GameEvents.SendCustomGameEventToServer( "armor_click", {} );
}
function OnTeleportClick(){
	GameEvents.SendCustomGameEventToServer( "hg_click", {} );
}
function Updata(){
	var playerId = Players.GetLocalPlayer();
	if (Players.IsValidPlayerID( playerId )) {
		var gold = Players.GetGold( playerId )
		$("#GoldLabel").text = gold;
	}
}
function Time(){
	Updata();
	$.Schedule(0.1, Time);
}
(function () {
    $.Schedule(21, function(){
	    Game.AddCommand( "HG", OnTeleportClick, "", 0 );
	    Time(); 
	    $("#shop_launcher_bg").style.visibility = "visible";
	    $("#UpgradeBG").style.visibility = "visible";
        $("#OverlayMapContainer").style.visibility = "visible";
        $("#DungeonHUD").style.visibility = "visible";
        GameUI.SetDefaultUIEnabled( DotaDefaultUIElement_t.DOTA_DEFAULT_UI_ACTION_MINIMAP, false );
    });
})();