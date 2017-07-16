var TimeCount = 30
var wave = 0
var startTime = 0
function StartTimeRemaining(data){
	wave = data.wave;
	TimeCount = 30;
	startTime = Math.floor(Game.GetGameTime());
	TimeRemaining();
}
function UpTimeRemaining(){
	var TimeRemainingPanel = $("#EventLabel");
	var str = $.Localize("#RushTimeRemaining");
	str = str.replace("%wave",wave);
	str = str.replace("%time",TimeCount);
	TimeRemainingPanel.AddClass("EventListLabelOut");
	TimeRemainingPanel.text = str;
	var gameTime = Math.floor(Game.GetGameTime());
    var time = gameTime - startTime;
	TimeCount = 30 - time;
}
function TimeRemaining(){
	UpTimeRemaining();
	if(TimeCount < 0){
		$("#EventLabel").RemoveClass("EventListLabelOut");
	}
	else{
		$.Schedule(0.1, TimeRemaining);
	}
}
GameEvents.Subscribe( "time_remaining", StartTimeRemaining);