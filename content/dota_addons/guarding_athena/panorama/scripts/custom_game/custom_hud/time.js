"use strict";
var hour = 0
var minute = 0
var second = 30
var gameStart = false
var showGameTime = "collapse"
var showDotaTime = "visible"
function OnClick(){
	if(showDotaTime=="collapse")
	{
		showGameTime = "collapse";
		showDotaTime = "visible";
	}
	else
	{
		showGameTime = "visible";
		showDotaTime = "collapse";
	}
	$("#DotaTime").style.visibility = showDotaTime;
	$("#GameTime").style.visibility = showGameTime;
}
function UpdataTime(){
	var timeLabel = $("#GameTime");
	var dotaLabel = $("#DotaTime");
	var dotaTime = Math.round(Game.GetDOTATime(false,false));
	var secondShow = dotaTime % 60;
	var minuteShow = Math.floor(dotaTime / 60);
	hour = (Math.floor(dotaTime / 25)+6)%24;
	var day = true;
	var night = false;
	var a = Math.floor((minuteShow) / 4)%2;
	if(a == 0)
	{
		day = false;
		night = true;
	}
	$("#DayTime").SetHasClass( "HideElement", day );
	$("#NightTime").SetHasClass( "HideElement", night );
	$("#DayGlow").SetHasClass( "HideElement", night );
	$("#NightGlow").SetHasClass( "HideElement", day );
	if(secondShow < 10)
	{
		secondShow = "0" + secondShow;
	}
	timeLabel.text = minuteShow+":"+secondShow;
	dotaLabel.text = hour+":00";
}
function TimeRemaining(){
    UpdataTime();
    $.Schedule(1, TimeRemaining);
}
function Countdown(){
	var timeLabel = $("#GameTime");
	var secondShow = second;
	if(second < 10)
	{
		secondShow = "0" + second;
	}
	timeLabel.text = minute+":"+secondShow;
	second = second - 1;
	if(second <= 0)
	{
		gameStart = true;
    	TimeRemaining();
	}
}
function AutoCountdown(){
	if(gameStart == false)
	{
	    Countdown();
	    $.Schedule(1, AutoCountdown);
	}
}
(function(){
	$.Schedule(20, function(){
        //SetVisible( false );
        $("#TimePanel").style.visibility = "visible";
        AutoCountdown();
        //TimeRemaining();
    });
})()
