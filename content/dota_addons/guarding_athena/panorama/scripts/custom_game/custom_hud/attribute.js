function Updata(){
	var playerId = Players.GetLocalPlayer();
	if (Players.IsValidPlayerID( playerId )) {
		var previewPlayer = CustomNetTables.GetTableValue("scoreboard",playerId.toString());
		var bonusStr = previewPlayer.str - previewPlayer.baseStr;
		var bonusAgi = previewPlayer.agi - previewPlayer.baseAgi;
		var bonusInt = previewPlayer.int - previewPlayer.baseInt;
		$("#StrText").text = previewPlayer.baseStr;
		$("#AgiText").text = previewPlayer.baseAgi;
		$("#IntText").text = previewPlayer.baseInt;
		$("#StrBonusText").text = "+ " + bonusStr;
		$("#AgiBonusText").text = "+ " + bonusAgi;
		$("#IntBonusText").text = "+ " + bonusInt;
	}
}
function Time(){
	Updata();
	$.Schedule(0.1, Time);
}
function SetVisible(){
	$("#AttributeBG").style.visibility = "collapse";
}
(function () {
    $.Schedule(21, function(){
    	$("#AttributeBG").style.visibility = "visible";
    	Time();
    });
})();
