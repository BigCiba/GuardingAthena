function PlayersUpdated(){
    var titlePanel = $("#EndScreenLabel");
    if(Game.GetGameWinner()==2){
        titlePanel.text = $.Localize("#win");
        titlePanel.AddClass("WinText");
    }
    else{
        titlePanel.text = $.Localize("#lost");
        titlePanel.AddClass("LostText");
    }
    var playersPanel = $("#EndScreenContent");
    DeleteChildrenWithClass(playersPanel, "PlayerPanel");
    var playerCount = Players.GetMaxPlayers()
    for (var id = 0; id < playerCount; id++) {
        if (Players.IsValidPlayerID( id )) {
            var previewHeroName = CustomNetTables.GetTableValue("player_hero",id.toString());
            var previewPlayer = CustomNetTables.GetTableValue("scoreboard",id.toString());
            var endData = CustomNetTables.GetTableValue("end_screen",id.toString());
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
            //等级
            playerPanelCow.BCreateChildren('<Panel class="LevelIcon" onmouseover="DOTAShowTextTooltip(#level)" onmouseout="DOTAHideTextTooltip()"/> ', false, false );
            var lvLabel = $.CreatePanel("Label", playerPanelCow, "");
            lvLabel.AddClass("Level");
            lvLabel.text = previewPlayer.lv;
            //经验获取率
            playerPanelCow.BCreateChildren('<Panel class="RateIcon" onmouseover="DOTAShowTextTooltip(#exp_rate)" onmouseout="DOTAHideTextTooltip()"/> ', false, false );
            var expLabel = $.CreatePanel("Label", playerPanelCow, "");
            expLabel.AddClass("Level");
            expLabel.text = endData.exp_rate.toFixed(0) + "%";
            //总资产
            playerPanelCow.BCreateChildren('<Panel class="GoldIcon" onmouseover="DOTAShowTextTooltip(#gold)" onmouseout="DOTAHideTextTooltip()"/> ', false, false );
            var goldLabel = $.CreatePanel("Label", playerPanelCow, "");
            goldLabel.AddClass("Gold");
            goldLabel.text = previewPlayer.goldsave;
            //金钱获取率
            playerPanelCow.BCreateChildren('<Panel class="RateIcon" onmouseover="DOTAShowTextTooltip(#gold_rate)" onmouseout="DOTAHideTextTooltip()"/> ', false, false );
            var farmLabel = $.CreatePanel("Label", playerPanelCow, "");
            farmLabel.AddClass("GoldRate");
            farmLabel.text = endData.gold_rate.toFixed(0) + "%";
            for (var i = 1;i<4;i++){
                var itemName = endData["item"+i]
                var itemPanel = $.CreatePanel("Panel", playerPanelCow, "");
                ShowHeroItems(itemName,itemPanel)
            }
            //第二行面板
            var playerPanelCowDetail = $.CreatePanel("Panel", playerPanel, "");
            playerPanelCowDetail.AddClass("PlayerPanelCow");
            //属性

            playerPanelCowDetail.BCreateChildren('<Panel class="StrIcon" onmouseover="DOTAShowTextTooltip(#str)" onmouseout="DOTAHideTextTooltip()"/> ', false, false );
            var strLabel = $.CreatePanel("Label", playerPanelCowDetail, "");
            strLabel.AddClass("NormalText");
            strLabel.text = previewPlayer.str;
            playerPanelCowDetail.BCreateChildren('<Panel class="RateIcon" onmouseover="DOTAShowTextTooltip(#str_gain)" onmouseout="DOTAHideTextTooltip()"/> ', false, false );
            var strGainLabel = $.CreatePanel("Label", playerPanelCowDetail, "");
            strGainLabel.AddClass("RateText");
            strGainLabel.text = endData.strgain.toFixed(1);

            playerPanelCowDetail.BCreateChildren('<Panel class="AgiIcon" onmouseover="DOTAShowTextTooltip(#agi)" onmouseout="DOTAHideTextTooltip()"/> ', false, false );
            var agiLabel = $.CreatePanel("Label", playerPanelCowDetail, "");
            agiLabel.AddClass("NormalText");
            agiLabel.text = previewPlayer.agi;
            playerPanelCowDetail.BCreateChildren('<Panel class="RateIcon" onmouseover="DOTAShowTextTooltip(#agi_gain)" onmouseout="DOTAHideTextTooltip()"/> ', false, false );
            var agiGainLabel = $.CreatePanel("Label", playerPanelCowDetail, "");
            agiGainLabel.AddClass("RateText");
            agiGainLabel.text = endData.agigain.toFixed(1);

            playerPanelCowDetail.BCreateChildren('<Panel class="IntIcon" onmouseover="DOTAShowTextTooltip(#int)" onmouseout="DOTAHideTextTooltip()"/> ', false, false );
            var intLabel = $.CreatePanel("Label", playerPanelCowDetail, "");
            intLabel.AddClass("NormalText");
            intLabel.text = previewPlayer.int;
            playerPanelCowDetail.BCreateChildren('<Panel class="RateIcon" onmouseover="DOTAShowTextTooltip(#int_gain)" onmouseout="DOTAHideTextTooltip()"/> ', false, false );
            var intGainLabel = $.CreatePanel("Label", playerPanelCowDetail, "");
            intGainLabel.AddClass("RateText");
            intGainLabel.text = endData.intgain.toFixed(1);
            //防守积分
            playerPanelCowDetail.BCreateChildren('<Panel class="DefIcon" onmouseover="DOTAShowTextTooltip(#wave_def)" onmouseout="DOTAHideTextTooltip()"/> ', false, false );
            var defLabel = $.CreatePanel("Label", playerPanelCowDetail, "");
            defLabel.AddClass("NormalText");
            defLabel.text = previewPlayer.wavedef;
            //练功积分
            playerPanelCowDetail.BCreateChildren('<Panel class="PracticeIcon" onmouseover="DOTAShowTextTooltip(#practice)" onmouseout="DOTAHideTextTooltip()"/> ', false, false );
            var practiceLabel = $.CreatePanel("Label", playerPanelCowDetail, "");
            practiceLabel.AddClass("NormalText");
            practiceLabel.text = endData.practice;
            //Boss伤害
            playerPanelCowDetail.BCreateChildren('<Panel class="DamageIcon" onmouseover="DOTAShowTextTooltip(#damage)" onmouseout="DOTAHideTextTooltip()"/> ', false, false );
            var damageLabel = $.CreatePanel("Label", playerPanelCowDetail, "");
            damageLabel.AddClass("NormalText");
            damageLabel.text = previewPlayer.damagesave + "%";
            for (var i = 4;i<7;i++){
                var itemName = endData["item"+i]
                var itemPanel = $.CreatePanel("Panel", playerPanelCowDetail, "");
                ShowHeroItems(itemName,itemPanel)
            }
        }
    }
}
function ShowHeroItems(itemName,itemPanel) {
    var item = $.CreatePanel('DOTAItemImage', itemPanel, '');
    item.itemname = itemName;
    item.AddClass("ItemLabel");
    SetAbilityButtonTooltipEvents(itemPanel,itemName)
}
function SetAbilityButtonTooltipEvents(button, name) {
    button.SetPanelEvent("onmouseover", function() {
        $.DispatchEvent("DOTAShowAbilityTooltip", button, name);
    });

    button.SetPanelEvent("onmouseout", function() {
        $.DispatchEvent("DOTAHideAbilityTooltip");
    });
}
function DeleteChildrenWithClass(panel, elClass){
    var elements = panel.FindChildrenWithClassTraverse(elClass);
    for (var i = 0; i < elements.length; i++) {
        elements[i].DeleteAsync(0);
    }
}
function EndGame(){
    Game.FinishGame();
}
function TimeRemaining(){
    PlayersUpdated();
    $.Schedule(1, TimeRemaining);
}
(function () {
    PlayersUpdated();
})();
