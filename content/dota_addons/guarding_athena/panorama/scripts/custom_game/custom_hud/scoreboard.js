var lvLabel = [];
var scoreLabel = [];
var goldLabel = [];
var strLabel = [];
var agiLabel = [];
var intLabel = [];
var defLabel = [];
var damageLabel = [];
function PlayersUpdated() {
    var playerCount = Players.GetMaxPlayers();
    for (var id = 0; id < playerCount; id++) {
        if (Players.IsValidPlayerID(id)) {
            var previewPlayer = CustomNetTables.GetTableValue("scoreboard", id.toString());
            let playerData = CustomNetTables.GetTableValue("service", "player_" + Game.GetLocalPlayerID());
            lvLabel[id].text = previewPlayer.lv;
            scoreLabel[id].text = playerData.Score;
            goldLabel[id].text = previewPlayer.goldsave;
            strLabel[id].text = previewPlayer.str;
            agiLabel[id].text = previewPlayer.agi;
            intLabel[id].text = previewPlayer.int;
            defLabel[id].text = previewPlayer.wavedef;
            damageLabel[id].text = previewPlayer.damagesave + "%";
        }
    }
}
function CreateScoreboard() {
    var playersPanel = $("#ScoreboardContent");
    //DeleteChildrenWithClass(playersPanel, "PlayerPanel");
    var playerCount = Players.GetMaxPlayers();
    for (var id = 0; id < playerCount; id++) {
        if (Players.IsValidPlayerID(id)) {
            var previewHeroName = CustomNetTables.GetTableValue("player_hero", id.toString());
            var previewPlayer = CustomNetTables.GetTableValue("scoreboard", id.toString());
            let playerData = CustomNetTables.GetTableValue("service", "player_" + Game.GetLocalPlayerID());
            //玩家面板背景
            var playerPanel = $.CreatePanel("Panel", playersPanel, "");
            playerPanel.AddClass("PlayerPanel");
            //第一行面板
            var playerPanelCow = $.CreatePanel("Panel", playerPanel, "");
            playerPanelCow.AddClass("PlayerPanelCow");
            //玩家英雄头像
            var playerHero = $.CreatePanel("DOTAHeroImage", playerPanelCow, "");
            playerHero.heroimagestyle = "landscape";
            playerHero.heroname = previewHeroName.heroname;
            playerHero.AddClass("SelectedImage");
            //玩家名字
            var playerNameLabel = $.CreatePanel("Label", playerPanelCow, "");
            playerNameLabel.AddClass("PlayerName");
            var playerName = Players.GetPlayerName(id);
            playerNameLabel.text = playerName;
            //积分
            playerPanelCow.BCreateChildren('<Panel class="ScoreIcon" onmouseover="DOTAShowTextTooltip(#score)" onmouseout="DOTAHideTextTooltip()"/> ', false, false);
            scoreLabel[id] = $.CreatePanel("Label", playerPanelCow, "");
            scoreLabel[id].AddClass("Score");
            scoreLabel[id].text = playerData.Score;
            //等级
            playerPanelCow.BCreateChildren('<Panel class="LevelIcon" onmouseover="DOTAShowTextTooltip(#level)" onmouseout="DOTAHideTextTooltip()"/> ', false, false);
            lvLabel[id] = $.CreatePanel("Label", playerPanelCow, "");
            lvLabel[id].AddClass("Level");
            lvLabel[id].text = previewPlayer.lv;
            //总资产
            playerPanelCow.BCreateChildren('<Panel class="GoldIcon" onmouseover="DOTAShowTextTooltip(#gold)" onmouseout="DOTAHideTextTooltip()"/> ', false, false);
            goldLabel[id] = $.CreatePanel("Label", playerPanelCow, "");
            goldLabel[id].AddClass("Gold");
            goldLabel[id].text = previewPlayer.goldsave;
            //第二行面板
            var playerPanelCowDetail = $.CreatePanel("Panel", playerPanel, "");
            playerPanelCowDetail.AddClass("PlayerPanelCow");
            //属性

            playerPanelCowDetail.BCreateChildren('<Panel class="StrIcon" onmouseover="DOTAShowTextTooltip(#str)" onmouseout="DOTAHideTextTooltip()"/> ', false, false);
            strLabel[id] = $.CreatePanel("Label", playerPanelCowDetail, "");
            strLabel[id].AddClass("NormalText");
            strLabel[id].text = previewPlayer.str;

            playerPanelCowDetail.BCreateChildren('<Panel class="AgiIcon" onmouseover="DOTAShowTextTooltip(#agi)" onmouseout="DOTAHideTextTooltip()"/> ', false, false);
            agiLabel[id] = $.CreatePanel("Label", playerPanelCowDetail, "");
            agiLabel[id].AddClass("NormalText");
            agiLabel[id].text = previewPlayer.agi;

            playerPanelCowDetail.BCreateChildren('<Panel class="IntIcon" onmouseover="DOTAShowTextTooltip(#int)" onmouseout="DOTAHideTextTooltip()"/> ', false, false);
            intLabel[id] = $.CreatePanel("Label", playerPanelCowDetail, "");
            intLabel[id].AddClass("NormalText");
            intLabel[id].text = previewPlayer.int;
            //防守积分
            playerPanelCowDetail.BCreateChildren('<Panel class="DefIcon" onmouseover="DOTAShowTextTooltip(#wave_def)" onmouseout="DOTAHideTextTooltip()"/> ', false, false);
            defLabel[id] = $.CreatePanel("Label", playerPanelCowDetail, "");
            defLabel[id].AddClass("NormalText");
            defLabel[id].text = previewPlayer.wavedef;
            //Boss伤害
            playerPanelCowDetail.BCreateChildren('<Panel class="DamageIcon" onmouseover="DOTAShowTextTooltip(#damage)" onmouseout="DOTAHideTextTooltip()"/> ', false, false);
            damageLabel[id] = $.CreatePanel("Label", playerPanelCowDetail, "");
            damageLabel[id].AddClass("NormalText");
            damageLabel[id].text = previewPlayer.damagesave + "%";
        }
    }
    TimeRemaining();
}
function DeleteChildrenWithClass(panel, elClass) {
    var elements = panel.FindChildrenWithClassTraverse(elClass);
    for (var i = 0; i < elements.length; i++) {
        elements[i].DeleteAsync(0);
    }
}
function TimeRemaining() {
    PlayersUpdated();
    $.GetContextPanel().SetHasClass("flyout_scoreboard_visible", GameUI.CustomUIConfig().scoreboard);
    $.Schedule(0.1, TimeRemaining);
}
function SetFlyoutScoreboardVisible(bVisible) {
    PlayersUpdated();
    $.GetContextPanel().SetHasClass("flyout_scoreboard_visible", bVisible);
}
function ShowScoreboard() {
    if (GameUI.CustomUIConfig().scoreboard == false) {
        GameUI.CustomUIConfig().scoreboard = true;
        GameUI.CustomUIConfig().quest = false;
        GameUI.CustomUIConfig().shop = false;
    }
    else {
        GameUI.CustomUIConfig().scoreboard = false;
    }
}
(function () {
    GameUI.CustomUIConfig().scoreboard = false;
    CreateScoreboard();
    SetFlyoutScoreboardVisible(false);
    Game.AddCommand("SCORE", ShowScoreboard, "", 0);
    //$.RegisterEventHandler( "DOTACustomUI_SetFlyoutScoreboardVisible", $.GetContextPanel(), SetFlyoutScoreboardVisible );
})();
