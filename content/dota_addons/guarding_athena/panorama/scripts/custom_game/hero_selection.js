let GameModeSelectionEndTime = -1;

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
	let HeroSceneList = $("#RightContent").FindChildrenWithClassTraverse("HeroScene");
	for (let index = 0; index < HeroSceneList.length; index++) {
		const HeroScene = HeroSceneList[index];
		HeroScene.DeleteAsync(0);
	}
	let HeroScenePanel = $.CreatePanelWithProperties("DOTAScenePanel", $("#HeroScenePanel"), HeroName, {unit: HeroName, light: "global_light", antialias: "true", drawbackground: "false", particleonly: "false", hittest: "false"});
	HeroScenePanel.AddClass("HeroScene");
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
})();