var gold = []
gold[0] = "fd29154c18f6e3dc094a21b56d8bc075"
gold[1] = "99a72195d9106f09c2d7701fad8136b8"
gold[2] = "a55cef978fe4168f7dd354477cb7206d"
gold[3] = "31502c089790c3bfa475044e18cf5a22"
gold[4] = "544c6f33b516edf9b9227fff2e26da11"
gold[5] = "c278690288c38a1ceed42542bf3f42eb"
gold[6] = "9ac4233ca17c5d4ee3bf1aff98f4b215"
gold[7] = "7479d7d32ead62cf48ca429f1b04e1ab"
gold[8] = "23388fc2c35179c18560ddacbc980070"
var potion = []
potion[0] = "599473233c4f4721ccecffe1465978d5"
potion[1] = "1abe84b8218b34a256e996a2bbb42b74"
potion[2] = "20277f0361e2de46695b179ed6e9c1f5"
potion[3] = "3c99cea113475ad46c3c670c40f6ea5a"
potion[4] = "e7591771f1a97baf9febb0d8130bce39"
potion[5] = "e6d29d6863a7820ae06871d24dd09913"
potion[6] = "d57f089be99286616821f6de188a5eb4"
potion[7] = "ab613b54afc7c9f3001de4e47329c23a"
potion[8] = "ece6d041cce169ae98ccd2a0eb819035"
var password = []
password[0] = "dc1dd5a214cf8c8b7a4bce4f7463819f"
password[1] = "2680114880839055905cc614d1f1a2d5"
password[2] = "b0a47480df945c8d7a78ae3af7d2fc1a"
password[3] = "cd1a126d09226ba9faa003d3f8c2128a"
password[4] = "7adcd18347f2f6a42e05ad08018a9ef7"
password[5] = "601f4a90e90e2b1ad8c2e90c065ee2ed"
password[6] = "ab320563f7b5912eb0c2b34df20e3a67"
password[7] = "e1f19f24ecfc205763f4f36b051a3e9a"
password[8] = "2aaafbb6d52f69ebfed8632f6b1ff1b8"
var revelater_pre = []
revelater_pre[0] = "00557c4013a7c2d5e10a28f7f3740f2e"
revelater_pre[1] = "0a690e54758de6a5e17a29259a5e5f52"
revelater_pre[2] = "31281e284bdd72aafe63cc738f7ea7f6"
revelater_pre[3] = "cf275b7933c25ecb37a81663064e4dc8"
revelater_pre[4] = "af18f27e879b06ebc34dd3f08f3f908c"
revelater_pre[5] = "3ce497db001811ca4dbe9808c9f285dc"
revelater_pre[6] = "bd898faf6d7607fae0e40bf42fa901ab"
revelater_pre[7] = "307ce63229dde6801bb98632c5dc320d"
revelater_pre[8] = "e679c921d737b049c04715c0a8c27a78"
var revelater = []
revelater[0] = "500f29c43d9963de2a46aaf401f77d31"
revelater[1] = "51cbf7549ff57c6025b7cee62b6b9cf4"
revelater[2] = "615b325e3e0fefd027d0e82bbcff15dc"
revelater[3] = "bd16d1d43708bdca3842c5c7855a41de"
revelater[4] = "9b538a4299b9c6b50dda664ff289259b"
revelater[5] = "de7e4b62a7f972ee58d22696e9918efe"
revelater[6] = "a0cd4d17763c9909fba2c6dc683e7d80"
revelater[7] = "06e809538af3c237a2ae4ed55f37bd3f"
revelater[8] = "fe69c4c928fbed16f78bfbe406728208"
var allHeroes = []
allHeroes[0] = "npc_dota_hero_omniknight"
allHeroes[1] = "npc_dota_hero_windrunner"
allHeroes[2] = "npc_dota_hero_phantom_assassin"
allHeroes[3] = "npc_dota_hero_rubick"
allHeroes[4] = "npc_dota_hero_juggernaut"
allHeroes[5] = "npc_dota_hero_antimage"
allHeroes[6] = "npc_dota_hero_lina"
allHeroes[7] = "npc_dota_hero_legion_commander"
allHeroes[8] = "npc_dota_hero_ember_spirit"
allHeroes[9] = "npc_dota_hero_crystal_maiden"
allHeroes[10] = "npc_dota_hero_templar_assassin"
allHeroes[11] = "npc_dota_hero_nevermore"
allHeroes[12] = "npc_dota_hero_monkey_king"
var lockHeroes = []
var unlockHeroes = []
var lockImages = []
lockHeroes[0] = "npc_dota_hero_nevermore"
lockHeroes[1] = "npc_dota_hero_templar_assassin"
var allDifficulty = []
allDifficulty[0] = "EasyButton"
allDifficulty[1] = "NormalButton"
allDifficulty[2] = "HardButton"
allDifficulty[3] = "DemonButton"
allDifficulty[4] = "TeamButton"
var activeDifficulty = null
var heroPreviews = []
var abilityTable = []
var activePreview = null
var activeHeroCard = null
var HeroSelectionTime = CustomNetTables.GetTableValue("difficulty","setting").hero_selection_time
var StartGameTime = null
var HeroComfirm = false
var currentHero = null
var SelectedHeroName = "npc_dota_hero_wisp"
function OnHeroCardMouseOver(heroname) {
    var heroCardPlane = $("#"+heroname);
    heroCardPlane.AddClass("FullColor");
    var panel = $.CreatePanel("Label", heroCardPlane, "");
    panel.AddClass("HeroCardTip");
    panel.text = $.Localize("#"+heroname);
}
function OnHeroCardMouseOut(heroname) {
    var heroCardPlane = $("#"+heroname);
    heroCardPlane.RemoveClass("FullColor");
    DeleteChildrenWithClass(heroCardPlane, "HeroCardTip");
}
function OnHeroCardActive(heroname) {
    if (HeroComfirm==false) {
        GameEvents.SendCustomGameEventToServer("selection_hero_click", { "hero": heroname });
        activeHeroCard.RemoveClass("SelectColor");
        activePreview.style.visibility = "collapse";
        heroPreviews[heroname].style.visibility = "visible";
        activePreview = heroPreviews[heroname];
        $("#HeroName").text = $.Localize("#"+heroname);
        $("#"+heroname).AddClass("SelectColor");
        activeHeroCard = $("#"+heroname);
        ShowHeroAbilities(heroname);
        currentHero = heroname;
    }
}

function OnButtonMouseOver(buttonname) {
    var button = $("#"+buttonname);
    button.AddClass("FullColor");
}
function OnButtonMouseOut(buttonname) {
    var button = $("#"+buttonname);
    button.RemoveClass("FullColor");
}
function OnButtonActive(buttonname) {
    activeDifficulty.RemoveClass("SelectColor")
    var button = $("#"+buttonname);
    button.AddClass("SelectColor");
    activeDifficulty = button;
}
function ShowHeroAbilities(heroName) {
    DeleteChildrenWithClass($("#HeroAbilities"), "AbilityLabel");
    for (var i = 0;i<5;i++){
        var ability = $.CreatePanel('DOTAAbilityImage', $("#HeroAbilities"), '');
        ability.AddClass("AbilityLabel");
        var abilityTable = CustomNetTables.GetTableValue("ability_table",heroName);
        var abilityName = abilityTable[i+1];
        ability.abilityname = abilityName;
        SetAbilityButtonTooltipEvents(ability,abilityName);
    }
}
function SetAbilityButtonTooltipEvents(button, name) {
    button.SetPanelEvent("onmouseover", function() {
        $.DispatchEvent("DOTAShowAbilityTooltip", button, name);
        Game.EmitSound("ui_chat_slide_in");
    });

    button.SetPanelEvent("onmouseout", function() {
        $.DispatchEvent("DOTAHideAbilityTooltip");
        Game.EmitSound("ui_chat_slide_out");
    });
}
function AddHeroCardEvents(heroname){
    var panel = $("#"+heroname);
    panel.SetPanelEvent("onactivate", function() {
        OnHeroCardActive(heroname);
    });
    panel.SetPanelEvent("onmouseover", function() {
        OnHeroCardMouseOver(heroname);
        GameEvents.SendCustomGameEventToServer("selection_hero_hover", { "hero": heroname });
    });
    panel.SetPanelEvent("onmouseout", function(){
        OnHeroCardMouseOut(heroname);
        GameEvents.SendCustomGameEventToServer("selection_hero_hover", { "hero": "null" });
    });
}
function AddButtonEvents(buttonname){
    var panel = $("#"+buttonname);
    panel.SetPanelEvent("onactivate", function() {
        OnButtonActive(buttonname);
        GameEvents.SendCustomGameEventToServer("selection_difficulty_click", { "difficulty": buttonname });
    });
    panel.SetPanelEvent("onmouseover", function() {
        OnButtonMouseOver(buttonname);
    });
    panel.SetPanelEvent("onmouseout", function(){
        OnButtonMouseOut(buttonname);
    });
}
function PlayersUpdated(){
    var playersPanel = $("#PlayersContent");
    DeleteChildrenWithClass(playersPanel, "PlayerPanel");
    DeleteChildrenWithClass(playersPanel, "PlayerPanelComfirm");
    var playerCount = Players.GetMaxPlayers()
    for (var id = 0; id < playerCount; id++) {
        if (Players.IsValidPlayerID( id )) {
            var previewHeroName = CustomNetTables.GetTableValue("player_hero",id.toString());
            var hard = CustomNetTables.GetTableValue("difficulty",id.toString());
            var playerPanel = $.CreatePanel("Panel", playersPanel, "");
            if (HeroComfirm) {
                playerPanel.AddClass("PlayerPanelComfirm");
            }
            else {
                playerPanel.AddClass("PlayerPanel");
            }
            var playerHero = $.CreatePanel("DOTAHeroImage", playerPanel, "");
            playerHero.AddClass("SelectionImage");
            playerHero.heroimagestyle = "landscape";
            playerHero.heroname = previewHeroName.heroname;
            if (HeroComfirm) {
                playerHero.RemoveClass("SelectionImage");
                playerHero.AddClass("SelectedImage");
            }
            var playerNameLabel = $.CreatePanel("Label", playerPanel, "");
            playerNameLabel.AddClass("PlayerName");
            var playerName = Players.GetPlayerName(id);
            playerNameLabel.text = playerName;
            var hardSelectLabel = $.CreatePanel("Label", playerPanel, "");
            hardSelectLabel.AddClass("PlayerDifficulty"+hard.difficulty);
            var hardSelectText = $.CreatePanel("Label", hardSelectLabel, "");
            hardSelectText.AddClass("PlayerDifficultyText");
            hardSelectText.text = $.Localize("#"+hard.difficulty);
        }
    }
}
function PickHeroInit(){
    //预载入所有英雄卡牌与预览
    for (var hero of allHeroes) {
        AddHeroCardEvents(hero);
        var previewStyle = "width:600px;height:600px;";
        var preview = $.CreatePanel("Panel", $("#HeroesScene"), "");
        preview.BCreateChildren('<DOTAScenePanel style="width: 1060px; height: 1060px;" unit="' + hero + '"/>', false, false );
        preview.AddClass("HeroScene");
        preview.style.visibility = "collapse";
        heroPreviews[hero] = preview;
    }
    //添加难度按钮事件
    for (var button of allDifficulty) {
        AddButtonEvents(button);
    }
    //锁定隐藏英雄
    for (var lockHero of lockHeroes) {
        var lock = $("#"+lockHero);
        var preview = $.CreatePanel("Image", lock, "");
        preview.SetImage("file://{images}/custom_game/lock.png");
        lockImages[lockHero] = preview;
    }
    //初始英雄
    heroPreviews["npc_dota_hero_omniknight"].style.visibility = "visible";
    activePreview = heroPreviews["npc_dota_hero_omniknight"];
    currentHero = "npc_dota_hero_omniknight";
    activeDifficulty = $("#NormalButton");
    activeHeroCard = $("#npc_dota_hero_omniknight");
    activeHeroCard.AddClass("SelectColor");
    activeDifficulty.AddClass("SelectColor");
    $("#HeroName").text = $.Localize("#npc_dota_hero_omniknight");
    ShowHeroAbilities("npc_dota_hero_omniknight");
    PlayersUpdated();
}
function DeleteChildrenWithClass(panel, elClass){
    var elements = panel.FindChildrenWithClassTraverse(elClass);
    for (var i = 0; i < elements.length; i++) {
        elements[i].DeleteAsync(0);
    }
}
function OnHeroConfirmClick(){
    var check = true;
    for (var lockHero of lockHeroes) {
        if (lockHero == currentHero) {
            check = false;
        }
    }
    if (check) {
        HeroComfirm = true;
        SelectedHeroName = currentHero;
        PlayersUpdated();
    }
    else {
        for (var unlockHero of unlockHeroes) {
            if (unlockHero == currentHero) {
                HeroComfirm = true;
                SelectedHeroName = currentHero;
                PlayersUpdated();
            }
        }
    }
}
function OnHeroConfirmOver(){
    Game.EmitSound("ui_friends_slide_in");
}
function OnHeroConfirmOut(){
    Game.EmitSound("ui_friends_slide_in");
}
function TimeRemaining(){
    if (HeroSelectionTime>=0) {
        $("#TimerText").text = HeroSelectionTime;
        var game_time = Math.floor(Game.GetGameTime());
        var time = game_time - StartGameTime;
        HeroSelectionTime = CustomNetTables.GetTableValue("difficulty","setting").hero_selection_time - time;
        //$.Msg("time:" + game_time);
        $.Schedule(0.1, TimeRemaining);
    }
    else {
        if (SelectedHeroName=="npc_dota_hero_wisp") {
            //SelectedHeroName = allHeroes[Math.floor(Math.random()*9)];
            //var game_time = Math.floor(Game.GetGameTime());
            //$.Msg("timeout:" + game_time);
            $.Schedule(0.1, TimeRemaining);
        }
        else {
            GameEvents.SendCustomGameEventToServer("hero_selected", { "hero": SelectedHeroName });
            $("#HeroSelectionBackground").style.visibility = "collapse";
        }
    }
}
function OnSubmitted() {
    var inputword = $('#password').text;
    var inputwordmd5 = hex_md5(hex_md5(inputword));
    for(var i = 0; i < 9; i++)
    {
        if (password[i] == inputwordmd5)
        {
            $('#password').text = ""
            Game.EmitSound("ui_chat_msg_send");
            lockImages["npc_dota_hero_nevermore"].style.visibility = "collapse";
            unlockHeroes[0] = "npc_dota_hero_nevermore";
            Game.EmitSound("ui_rollover_today");
            break;
        }
    }
    for(var i = 0; i < 9; i++)
    {
        if (revelater_pre[i] == inputwordmd5)
        {
            $('#password').text = ""
            Game.EmitSound("ui_chat_msg_send");
            lockImages["npc_dota_hero_templar_assassin"].style.visibility = "collapse";
            unlockHeroes[1] = "npc_dota_hero_templar_assassin";
            Game.EmitSound("ui_rollover_today");
            break;
        }
    }
    for(var i = 0; i < 9; i++)
    {
        //$.Msg(inputword);
        if (revelater[i] == inputwordmd5)
        {
            $('#password').text = ""
            Game.EmitSound("ui_chat_msg_send");
            lockImages["npc_dota_hero_templar_assassin"].style.visibility = "collapse";
            unlockHeroes[1] = "npc_dota_hero_templar_assassin";
            Game.EmitSound("ui_rollover_today");
            break;
        }
    }
    for(var i = 0; i < 9; i++)
    {
        if (gold[i] == inputwordmd5)
        {
            GameEvents.SendCustomGameEventToServer( "gold_gift", {index: i} );
            $('#password').text = ""
            Game.EmitSound("ui_chat_msg_send");
            break;
        }
    }
    for(var i = 0; i < 9; i++)
    {
        if (potion[i] == inputwordmd5)
        {
            GameEvents.SendCustomGameEventToServer( "gift_potion", {index: i} );
            $('#password').text = ""
            Game.EmitSound("ui_chat_msg_send");
            break;
        }
    }
    //$.Msg(password);
}
function VIPUnlock(data){
    lockImages["npc_dota_hero_nevermore"].style.visibility = "collapse";
    unlockHeroes[0] = "npc_dota_hero_nevermore";
    lockImages["npc_dota_hero_templar_assassin"].style.visibility = "collapse";
    unlockHeroes[1] = "npc_dota_hero_templar_assassin";
}
function Unlock(data){
    lockImages[data.heroName].style.visibility = "collapse";
    unlockHeroes.push(data.heroName);
}
(function () {
    GameEvents.Subscribe( "vip", VIPUnlock);
    GameEvents.Subscribe( "unlock", Unlock);
    if (Game.GameStateIsAfter( DOTA_GameState.DOTA_GAMERULES_STATE_PRE_GAME ))
    {
        $("#HeroSelectionBackground").style.visibility = "collapse";
    }
    else {
        StartGameTime =  Math.floor(Game.GetGameTime());
        TimeRemaining();
        CustomNetTables.SubscribeNetTableListener("player_hero", PlayersUpdated);
        CustomNetTables.SubscribeNetTableListener("difficulty", PlayersUpdated);
        PickHeroInit();
    }
})();