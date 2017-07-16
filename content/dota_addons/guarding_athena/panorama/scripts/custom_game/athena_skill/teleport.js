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
   $.Schedule(21, function(){$("#TeleportBG").style.visibility = "visible";});
   Game.AddCommand( "HG", OnTeleportClick, "", 0 );
   Time();
})();