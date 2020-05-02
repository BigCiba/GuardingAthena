function ScoreboardActive(){
	if(GameUI.CustomUIConfig().scoreboard == false)
    {
        GameUI.CustomUIConfig().scoreboard = true;
        GameUI.CustomUIConfig().quest = false;
        GameUI.CustomUIConfig().shop = false;
    }
    else
    {
        GameUI.CustomUIConfig().scoreboard = false;
    }
}
function QuestActive(){
	if(GameUI.CustomUIConfig().quest == false)
    {
        GameUI.CustomUIConfig().quest = true;
        GameUI.CustomUIConfig().shop = false;
        GameUI.CustomUIConfig().scoreboard = false;
    }
    else
    {
        GameUI.CustomUIConfig().quest = false;
    }
}
function ShopActive(){
    if(GameUI.CustomUIConfig().shop == false)
    {
        GameUI.CustomUIConfig().shop = true;
        GameUI.CustomUIConfig().quest = false;
        GameUI.CustomUIConfig().scoreboard = false;
    }
    else
    {
        GameUI.CustomUIConfig().shop = false;
    }
}
function TimeRemaining(){
    $("#ScoreboardButton").SetHasClass( "active", GameUI.CustomUIConfig().scoreboard || false );
    $("#QuestButton").SetHasClass( "active", GameUI.CustomUIConfig().quest || false );
    $("#ShopButton").SetHasClass( "active", GameUI.CustomUIConfig().shop || false );
    $.Schedule(0.1, TimeRemaining);
}
(function () {
    $("#LeftListBG").style.visibility = "visible";
    TimeRemaining();
})();