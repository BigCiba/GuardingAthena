let GameModeSelectionEndTime = -1;
let TestList = {
	"pet":{
		"pet_01": {quality: "Common"},
		"pet_02": {quality: "Common"},
		"pet_03": {quality: "Epic"},
		"pet_04": {quality: "Rare"},
		"pet_05": {quality: "Rare"},
	},
	"skin": {
		"rubick_01": {quality: "Artifact"},
		"windrunner_01": {quality: "Artifact"},
		"phantom_assassin_01": {quality: "Artifact"},
	},
	"particle": {
		"wing_01": {quality: "Artifact"},
	}
};
let EquipItem = {
	"pet": "default",
	"skin": "default",
	"particle": "default",
};

function Update() {
	if (Game.GameStateIsAfter(DOTA_GameState.DOTA_GAMERULES_STATE_PRE_GAME)) {
		$.GetContextPanel().DeleteAsync(-1);
		return;
	}
	$.Schedule(0, Update);
	
	if (GameModeSelectionEndTime != -1) {
		let time = GameModeSelectionEndTime - Game.GetGameTime();
		$("#TimerContent").SetDialogVariableInt("time", Math.ceil(time));
	}
}
function LoadPlayer(self) {
	self.BLoadLayoutSnippet("PlayerCard");
	self.SetPlayer = function(PlayerID) {
		const tPlayerInfo = Game.GetPlayerInfo(PlayerID);
		const iLevel = 169;
		self.FindChildTraverse("AvatarImage").steamid = tPlayerInfo.player_steamid;
		self.FindChildTraverse("UserName").steamid = tPlayerInfo.player_steamid;
		self.FindChildTraverse("BackGroundImage").SetImage(GetBadgesBackground(iLevel));
		self.FindChildTraverse("ItemImage").SetImage(GetBadgesLevel(iLevel));
		self.FindChildTraverse("ProfileLevel").SetImage(GetBadgesBackgroundNumber(iLevel));
		self.SetDialogVariableInt("level", iLevel);
	};

}
function LoadItem(self) {
	self.BLoadLayoutSnippet("EconItem");
	self.SetItem = function(ItemData) {
		let LocalData = TestList[ItemData.Type][ItemData.ItemName];
		self.FindChildTraverse("EconItemImage").SetImage("file://{images}/custom_game/"+ItemData.Type+"/"+ItemData.ItemName+".png");
		self.FindChildTraverse("Equipped").SetHasClass("hide", ItemData.Equip == "0");
		self.FindChildTraverse("BottomLayer").AddClass(LocalData.quality);
		self.Type = ItemData.Type;
		self.SetPanelEvent("onactivate", function() {
			EquipItem[this.Type] = this.id;
			let Contents = $("#Contents").FindChildrenWithClassTraverse("EconItem");
			for (let index = 0; index < Contents.length; index++) {
				const EchoItem = Contents[index];
				EchoItem.FindChildTraverse("Equipped").SetHasClass("hide", EchoItem.id != EquipItem[this.Type]);
			}
		}.bind(self));
	}
}
function PreviewHero(HeroName) {
	const HeroKV = GameUI.HeroesKv[HeroName];
	// 预览英雄属性与名字
	$("#HeroNamePanel").FindChildTraverse("PrimaryAttributeImage").SetImage(GetAttributeIcon(HeroKV.AttributePrimary));
	$("#HeroNamePanel").SetDialogVariable("heroname", $.Localize(HeroName));
	// 预览技能
	$("#HeroAbilityPanel").RemoveAndDeleteChildren();
	for (let index = 1; index <= 5; index++) {
		const AbilityName = HeroKV["Ability" + index];
		let AbilityPanel = $.CreatePanelWithProperties("DOTAAbilityImage", $("#HeroAbilityPanel"), AbilityName, {abilityname: AbilityName});
		AbilityPanel.AddClass("HeroAbility");
		AbilityPanel.SetPanelEvent("onmouseover", function() {
			$.DispatchEvent("DOTAShowAbilityTooltip", AbilityPanel, AbilityName);
		});
		AbilityPanel.SetPanelEvent("onmouseout", function() {
			$.DispatchEvent("DOTAHideAbilityTooltip");
		});
	}
	
	// 预览模型
	$("#HeroScenePanel").RemoveAndDeleteChildren();
	let HeroScenePanel = $.CreatePanelWithProperties("DOTAScenePanel", $("#HeroScenePanel"), HeroName, {unit: HeroName, light: "global_light", antialias: "true", drawbackground: "false", particleonly: "false", hittest: "false"});
	HeroScenePanel.AddClass("HeroScene");
}
function ShowContextMenu(ID, Type) {
	let LocalPlayerID = Players.GetLocalPlayer();
	let SettingPanel = $("#" + ID);
	let ContextMenuBody = $("#ContextMenuBody");
	let Posistion = GetPanelCenter(SettingPanel);
	let Width = ContextMenuBody.actuallayoutwidth / 2;
	let Height = ContextMenuBody.actuallayoutheight + SettingPanel.actuallayoutheight / 2;
	let Data = CustomNetTables.GetTableValue("service", "player_data")[LocalPlayerID];
	const ItemList = Data[Type];
	for (const key in ItemList) {
		const ItemData = ItemList[key];
		let Panel = $("#Contents").FindChildTraverse(ItemData.ItemName);
		Panel = ReloadPanel(Panel, "Panel", $("#Contents"), ItemData.ItemName);
		LoadItem(Panel);
		Panel.SetItem(ItemData);
	}
	ContextMenuBody.SetPositionInPixels(Posistion.x - Width, Posistion.y - Height, 0);
	ContextMenuBody.ToggleClass("ContextMenuBodyShow");
}
(function () {
	let HUD = $.GetContextPanel().GetParent().GetParent().GetParent();
	let PreGame = HUD.FindChildTraverse("PreGame");
	if (PreGame)
		PreGame.enabled = true;
	PreGame.style.opacity = "1";
	let HeroPickScreen = PreGame.FindChildTraverse("HeroPickScreen");
	if (HeroPickScreen)
		HeroPickScreen.enabled = false;
	HeroPickScreen.style.opacity = "0";
	let PreMinimapContainer = PreGame.FindChildTraverse("PreMinimapContainer");
	if (PreMinimapContainer)
		PreMinimapContainer.enabled = false;
	PreMinimapContainer.style.opacity = "0";
	let Header = PreGame.FindChildTraverse("Header");
	if (Header)
		Header.enabled = false;
	Header.style.opacity = "0";
	let Chat = PreGame.FindChildTraverse("Chat");
	if (Chat)
		Chat.style.opacity = "0";

	GameModeSelectionEndTime = Game.GetGameTime() + Game.GetStateTransitionTime();
	Update();
	// 加载英雄卡片
	for (const key in GameUI.HeroesKv) {
		const HeroKV = GameUI.HeroesKv[key];
		let HeroName = HeroKV.override_hero;
		let Panel = $("#HeroListPanel").FindChildTraverse(HeroName);
		Panel = ReloadPanelWithProperties(Panel, "DOTAHeroMovie", $("#HeroListPanel"), HeroName, {heroname: HeroName});
		Panel.BLoadLayoutSnippet("HeroCard");
		Panel.SetPanelEvent("onactivate", function() {
			PreviewHero(HeroName);
		});
		if (HeroKV.UnitLabel == "lock" ) {
			Panel.RemoveClass("Unlock")
		}
	}
	// 加载玩家卡片
	let AllPlayerID = Game.GetAllPlayerIDs()
	for (let index = 0; index < AllPlayerID.length; index++) {
		const PlayerID = AllPlayerID[index];
		let Panel = $("#PlayerContent").FindChildTraverse("Player" + PlayerID);
		Panel = ReloadPanel(Panel, "Panel", $("#PlayerContent"), "Player" + PlayerID);
		LoadPlayer(Panel);
		Panel.SetPlayer(PlayerID);
	}
	// 默认预览
	PreviewHero(Object.keys(GameUI.HeroesKv)[0]);
})();