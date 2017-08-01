var questList = []
var countList = []
var finishList = []
//更新任务
function UpdataQuest(data){
    var questPanel = questList[data.quest_name];
    var countLabel = countList[data.quest_name];
    countLabel.text = data.reamain_count;
}
//初始化任务
function CreateQuest(data){
    var questContent = $("#QuestContent");
    var questPanel = $.CreatePanel("Panel", questContent, "");
    questPanel.AddClass("QuestPanel");
    questList[data.quest_name] = questPanel;
    var questNameLabel = $.CreatePanel("Label", questPanel, "");
    questNameLabel.AddClass("QuestName");
    questNameLabel.text = $.Localize("#" + data.quest_name);
    var countLabel = $.CreatePanel("Label", questPanel, "");
    countLabel.AddClass("QuestCount");
    countLabel.text = "0";
    countList[data.quest_name] = countLabel;
    var questCountLabel = $.CreatePanel("Label", questPanel, "");
    questCountLabel.AddClass("QuestCount");
    questCountLabel.text = "/"+ data.demand_count;
    var rewardPanel = $.CreatePanel("Panel", questPanel, "");
    rewardPanel.AddClass("QuestRewardPanel");
    var rewardLabel = $.CreatePanel("Label", rewardPanel, "");
    rewardLabel.AddClass("QuestReward");
    rewardLabel.text = $.Localize("#reward");
    var item = $.CreatePanel('DOTAItemImage', rewardPanel, '');
    var itemName = data.reward_content;
    item.itemname = itemName;
    item.AddClass("ItemLabel");
    SetAbilityButtonTooltipEvents(item,itemName);
    questPanel.SetHasClass( "quest_flyout", true );
    ShowQuest()
}
function DestoryQuest(data) {
    var questPanel = questList[data.quest_name]
    questPanel.SetHasClass( "quest_flyout", false );
    $.Schedule(0.2, function(){questPanel.DeleteAsync(0)});
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
        //CreateQuest();
        SetFlyoutQuestVisible( false );
        TimeRemaining();
        Game.AddCommand( "QUEST", ShowQuest, "", 0 );
        //CustomNetTables.SubscribeNetTableListener( "quest",UpdataQuest );
    });
    //$.RegisterEventHandler( "DOTACustomUI_SetFlyoutScoreboardVisible", $.GetContextPanel(), SetFlyoutScoreboardVisible );
})();
GameEvents.Subscribe( "create_quest", CreateQuest);
GameEvents.Subscribe( "destory_quest", DestoryQuest);
GameEvents.Subscribe( "updata_quest", UpdataQuest);
