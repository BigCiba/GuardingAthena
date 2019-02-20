var ShopPanel = []
var itemsPanel = []
var activeShop = "def_point"
//更新任务
function UpdataPoint(type){
    var previewPlayer = CustomNetTables.GetTableValue("shop", Players.GetLocalPlayer());
    $("#Point").text = $.Localize("#" + type) + ":" + previewPlayer[type];
}
//初始化任务
function CreateShop(){
    var ShopsPanel = $("#ShopPanel");
    var DefShopList = CustomNetTables.GetTableValue("shop","DefShop");
    var PraShopList = CustomNetTables.GetTableValue("shop","PracticeShop");
    var BossShopList = CustomNetTables.GetTableValue("shop","BossShop");
    var CostList = CustomNetTables.GetTableValue("shop","cost");
    var RefreshList = CustomNetTables.GetTableValue("shop","refresh");
    var DefShopPanel = $.CreatePanel("Panel", ShopsPanel, "");
    ShopPanel[1] = DefShopPanel;
    ShopPanel[1].SetHasClass("shop_visible", true);
    DefShopPanel.AddClass("ShopContent");
    for (var i in DefShopList) {
        var itemPanel = $.CreatePanel("Button", DefShopPanel, "");
        itemPanel.AddClass("ItemPanel");
        var item = $.CreatePanel('DOTAItemImage', itemPanel, '');
        var itemName = DefShopList[i];
        item.itemname = itemName;
        item.AddClass("ItemLabel");
        var itemNameLabel = $.CreatePanel("Label", itemPanel, "");
        itemNameLabel.AddClass("ItemName");
        itemNameLabel.text = $.Localize("#DOTA_Tooltip_ability_" + itemName);
        var costLabel = $.CreatePanel("Label", itemPanel, "");
        costLabel.AddClass("CostLabel");
        costLabel.text = $.Localize("#cost") + CostList[itemName];
        AddItemEvents(itemPanel,CostList[itemName],itemName,"def_point",RefreshList[itemName]);
    }
    var PraShopPanel = $.CreatePanel("Panel", ShopsPanel, "");
    ShopPanel[2] = PraShopPanel;
    PraShopPanel.AddClass("ShopContent");
    for (var i in PraShopList) {
        var itemPanel = $.CreatePanel("Button", PraShopPanel, "");
        itemPanel.AddClass("ItemPanel");
        var item = $.CreatePanel('DOTAItemImage', itemPanel, '');
        var itemName = PraShopList[i];
        item.itemname = itemName;
        item.AddClass("ItemLabel");
        var itemNameLabel = $.CreatePanel("Label", itemPanel, "");
        itemNameLabel.AddClass("ItemName");
        itemNameLabel.text = $.Localize("#DOTA_Tooltip_ability_" + itemName);
        var costLabel = $.CreatePanel("Label", itemPanel, "");
        costLabel.AddClass("CostLabel");
        costLabel.text = $.Localize("#cost") + CostList[itemName];
        AddItemEvents(itemPanel,CostList[itemName],itemName,"practice_point",RefreshList[itemName]);
    }
    var BossShopPanel = $.CreatePanel("Panel", ShopsPanel, "");
    ShopPanel[3] = BossShopPanel;
    BossShopPanel.AddClass("ShopContent");
    for (var i in BossShopList) {
        var itemPanel = $.CreatePanel("Button", BossShopPanel, "");
        itemPanel.AddClass("ItemPanel");
        var item = $.CreatePanel('DOTAItemImage', itemPanel, '');
        var itemName = BossShopList[i];
        item.itemname = itemName;
        item.AddClass("ItemLabel");
        var itemNameLabel = $.CreatePanel("Label", itemPanel, "");
        itemNameLabel.AddClass("ItemName");
        itemNameLabel.text = $.Localize("#DOTA_Tooltip_ability_" + itemName);
        var costLabel = $.CreatePanel("Label", itemPanel, "");
        costLabel.AddClass("CostLabel");
        costLabel.text = $.Localize("#cost") + CostList[itemName];
        AddBossRewardEvents(itemPanel,CostList[itemName],itemName,"boss_point");
    }
}
function AddItemEvents(panel,cost,name,type,refreshTime){
    panel.SetPanelEvent("oncontextmenu", function() {BuyItem(panel,cost,name,type,refreshTime);});
}
function AddBossRewardEvents(panel,cost,name,type){
    panel.SetPanelEvent("oncontextmenu", function() {ApplyReward(panel,cost,name,type);});
}
function ApplyReward (panel,cost,name,type) {
    var m_IsBuyEnable = false;
    var previewPlayer = CustomNetTables.GetTableValue("shop", Players.GetLocalPlayer());
    var gold = previewPlayer[type];
    if( gold >= cost )
    {
        m_IsBuyEnable = true;
    }
    if(!m_IsBuyEnable)
    {
        Game.EmitSound( "General.Cancel" );
        return;
    }

    var unit = Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer());
    if( unit != -1)
    {
        Game.EmitSound( "General.Buy" );
        GameEvents.SendCustomGameEventToServer( "UI_BuyReward", { 'entindex':unit, 'itemName':name, 'cost':cost, 'type':type} );
    }
    else
    {
        Game.EmitSound( "ui_rollover_micro" );
    }
}
function BuyItem (panel,cost,name,type,refreshTime) {
    var m_IsBuyEnable = false;
    var previewPlayer = CustomNetTables.GetTableValue("shop", Players.GetLocalPlayer());
    var buyEnable = CustomNetTables.GetTableValue("shop", "can_buy");
    var canBuy = buyEnable[name];
    var gold = previewPlayer[type];
    if( gold >= cost  && canBuy == true && Game.IsGamePaused() == false )
    {
        m_IsBuyEnable = true;
    }
    if(!m_IsBuyEnable)
    {
        Game.EmitSound( "General.Cancel" );
        return;
    }

    var unit = Players.GetPlayerHeroEntityIndex(Players.GetLocalPlayer());
    if( unit != -1)
    {
        Game.EmitSound( "General.Buy" );
        GameEvents.SendCustomGameEventToServer( "UI_BuyItem", { 'entindex':unit, 'itemName':name, 'cost':cost, 'type':type, 'cooldown':refreshTime} );
        panel.AddClass("ItemCantBuy");
        $.Schedule(refreshTime, function(){
            panel.RemoveClass("ItemCantBuy");
        });
    }
    else
    {
        Game.EmitSound( "ui_rollover_micro" );
    }
}
function DefShopActive(){
    activeShop = "def_point";
    ShopPanel[1].SetHasClass("shop_visible", true);
    ShopPanel[2].SetHasClass("shop_visible", false);
    ShopPanel[3].SetHasClass("shop_visible", false);
}
function PracticeShopActive(){
    activeShop = "practice_point";
    ShopPanel[1].SetHasClass("shop_visible", false);
    ShopPanel[2].SetHasClass("shop_visible", true);
    ShopPanel[3].SetHasClass("shop_visible", false);
}
function BossShopActive(){
    activeShop = "boss_point";
    ShopPanel[1].SetHasClass("shop_visible", false);
    ShopPanel[2].SetHasClass("shop_visible", false);
    ShopPanel[3].SetHasClass("shop_visible", true);
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
    UpdataPoint(activeShop);
    $.GetContextPanel().SetHasClass( "flyout_shop_visible", GameUI.CustomUIConfig().shop );
    $.Schedule(0.1, TimeRemaining);
}
function SetFlyoutQuestVisible( bVisible )
{
    $.GetContextPanel().SetHasClass( "flyout_shop_visible", bVisible );
}
function ShowShop()
{
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
(function () {
    GameUI.CustomUIConfig().shop = false;
    $.Schedule(21, function(){
        CreateShop();
        SetFlyoutQuestVisible( false );
        TimeRemaining();
        Game.AddCommand( "SHOP", ShowShop, "", 0 );
    });
    //$.RegisterEventHandler( "DOTACustomUI_SetFlyoutScoreboardVisible", $.GetContextPanel(), SetFlyoutScoreboardVisible );
})();
//GameEvents.Subscribe( "create_quest", CreateQuest);
//GameEvents.Subscribe( "updata_quest", UpdataQuest);
