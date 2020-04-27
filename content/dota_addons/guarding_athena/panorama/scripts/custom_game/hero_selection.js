let GameModeSelectionEndTime = -1;
let TestPetList = [
	{name: "pet_01", quality: "Common", src: "file://{images}/econ/items/courier/pangolier_squire/pangolier_squire.png"},
	{name: "pet_02", quality: "Rare", src: "file://{images}/econ/loading_screens/basim.png"},
	{name: "pet_03", quality: "Epic", src: "file://{images}/econ/items/courier/nilbog/nilbog.png"},
	{name: "pet_04", quality: "Artifact", src: "file://{images}/econ/loading_screens/duskie.png"},
];
let EquipItem = "pet_01";

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
function LoadPet(self) {
	self.BLoadLayoutSnippet("EconItem");
	self.SetPet = function(PetData) {
		self.FindChildTraverse("EconItemImage").SetImage(PetData.src);
		self.FindChildTraverse("Equipped").SetHasClass("hide", PetData.name != EquipItem);
		self.FindChildTraverse("BottomLayer").AddClass(PetData.quality);
		self.SetPanelEvent("onactivate", function() {
			EquipItem = this.id;
			let Contents = $("#Contents").FindChildrenWithClassTraverse("EconItem");
			for (let index = 0; index < Contents.length; index++) {
				const EchoItem = Contents[index];
				EchoItem.FindChildTraverse("Equipped").SetHasClass("hide", EchoItem.id != EquipItem);
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
function ShowContextMenu(Type) {
	let SettingPanel = $("#" + Type);
	let ContextMenuBody = $("#ContextMenuBody");
	let Posistion = GetPanelCenter(SettingPanel);
	let Width = ContextMenuBody.actuallayoutwidth / 2;
	let Height = ContextMenuBody.actuallayoutheight + SettingPanel.actuallayoutheight / 2;
	for (let index = 0; index < TestPetList.length; index++) {
		const PetData = TestPetList[index];
		let Panel = $("#Contents").FindChildTraverse(PetData.name);
		Panel = ReloadPanel(Panel, "Panel", $("#Contents"), PetData.name);
		LoadPet(Panel);
		Panel.SetPet(PetData);
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