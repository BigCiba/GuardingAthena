var questList = []
var countList = []
var finishList = []
//更新任务
function UpdataQuest(){
    var table = CustomNetTables.GetTableValue("quest",Game.GetLocalPlayerID());
    var panel = questList[table.name];
    var label = countList[table.name];
    if(table.create == true){
        GameUI.CustomUIConfig().quest = true;
        GameUI.CustomUIConfig().scoreboard = false;
    }
    if(table.finish == true){
        panel.SetHasClass( "quest_flyout", false );
        $.Schedule(0.2,function(){panel.SetHasClass( "quest_visible", false )});
    }
    else{
        label.text = table.count;
        panel.SetHasClass( "quest_flyout", true );
        panel.SetHasClass( "quest_visible", true );
    }
}
//初始化任务
function CreateQuest(){
    var name = CustomNetTables.GetTableValue("quest","name");
    var require = CustomNetTables.GetTableValue("quest","require");
    var reward = CustomNetTables.GetTableValue("quest","reward");
    var questContent = $("#QuestContent");
    for (var i = 1; i <= 5; i++) {
        var questPanel = $.CreatePanel("Panel", questContent, "");
        questPanel.AddClass("QuestPanel");
        var questNameLabel = $.CreatePanel("Label", questPanel, "");
        questNameLabel.AddClass("QuestName");
        questNameLabel.text = $.Localize("#" + name[i]);
        var countLabel = $.CreatePanel("Label", questPanel, "");
        countLabel.AddClass("QuestCount");
        countLabel.text = "0";
        var questCountLabel = $.CreatePanel("Label", questPanel, "");
        questCountLabel.AddClass("QuestCount");
        questCountLabel.text = "/"+ require[i];
        var rewardPanel = $.CreatePanel("Panel", questPanel, "");
        rewardPanel.AddClass("QuestRewardPanel");
        var rewardLabel = $.CreatePanel("Label", rewardPanel, "");
        rewardLabel.AddClass("QuestReward");
        rewardLabel.text = $.Localize("#reward");
        var item = $.CreatePanel('DOTAItemImage', rewardPanel, '');
        var itemName = reward[i];
        item.itemname = itemName;
        item.AddClass("ItemLabel");
        SetAbilityButtonTooltipEvents(item,itemName);
        questList[name[i]] = questPanel;
        countList[name[i]] = countLabel;
    }
}
function SetAbilityButtonTooltipEvents(button, name) {
    button.SetPanelEvent("onmouseover", function() {
        $.DispatchEvent("DOTAShowAbilityTooltip", button, name);
    });

    button.SetPanelEvent("onmouseout", function() {
        $.DispatchEvent("DOTAHideAbilityTooltip");
    });
}
function TimeRemaining(){
    $.GetContextPanel().SetHasClass( "flyout_quest_visible", GameUI.CustomUIConfig().quest );
    $.Schedule(0.1, TimeRemaining);
}
function SetFlyoutQuestVisible( bVisible )
{
    $.GetContextPanel().SetHasClass( "flyout_quest_visible", bVisible );
}
function ShowQuest()
{
    if(GameUI.CustomUIConfig().quest == false)
    {
        GameUI.CustomUIConfig().quest = true;
        GameUI.CustomUIConfig().scoreboard = false;
        GameUI.CustomUIConfig().shop = false;
    }
    else
    {
        GameUI.CustomUIConfig().quest = false;
    }
}
(function () {
    GameUI.CustomUIConfig().quest = false;
    $.Schedule(21, function(){
        CreateQuest();
        SetFlyoutQuestVisible( false );
        TimeRemaining();
        Game.AddCommand( "QUEST", ShowQuest, "", 0 );
        CustomNetTables.SubscribeNetTableListener( "quest",UpdataQuest );
    });
    //$.RegisterEventHandler( "DOTACustomUI_SetFlyoutScoreboardVisible", $.GetContextPanel(), SetFlyoutScoreboardVisible );
})();
//GameEvents.Subscribe( "create_quest", CreateQuest);
//GameEvents.Subscribe( "updata_quest", UpdataQuest);
