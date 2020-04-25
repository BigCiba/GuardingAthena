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
	let HeroList = $("#HeroListPanel").FindChildrenWithClassTraverse("HeroCard");
	for (var i = 0; i < HeroList.length; i++) {
		HeroList[i].DeleteAsync(0);
	}
	for (const key in GameUI.HeroesKv) {
		const HeroKV = GameUI.HeroesKv[key];
		let HeroName = HeroKV.override_hero;
		let Panel = $("#HeroListPanel").FindChildTraverse(HeroName);
		if (Panel == undefined || Panel == null) {
			let Panel = $.CreatePanelWithProperties("DOTAHeroMovie", $("#HeroListPanel"), HeroName, {heroname: HeroName});
			Panel.BLoadLayoutSnippet("HeroCard");
			if (HeroKV.UnitLabel == "lock" ) {
				Panel.RemoveClass("Unlock");
			}
		}
	}
	// 加载玩家卡片
	let PlayerList = $("#PlayerContent").FindChildrenWithClassTraverse("PlayerContentBody");
	for (var i = 0; i < PlayerList.length; i++) {
		PlayerList[i].DeleteAsync(0);
	}
	let AllPlayerID = Game.GetAllPlayerIDs()
	for (let index = 0; index < AllPlayerID.length; index++) {
		const PlayerID = AllPlayerID[index];
		const tPlayerInfo = Game.GetPlayerInfo(PlayerID);
		$.Msg(tPlayerInfo);
		let Panel = $("#PlayerContent").FindChildTraverse("Player" + PlayerID);
		if (Panel == undefined || Panel == null) {
			let Panel = $.CreatePanel("Panel", $("#PlayerContent"), "Player" + PlayerID);
			Panel.BLoadLayoutSnippet("PlayerCard");
			Panel.FindChildrenWithClassTraverse("AvatarImage").steamid = tPlayerInfo.player_steamid;
			Panel.FindChildrenWithClassTraverse("UserName").steamid = tPlayerInfo.player_steamid;
		}
	}
})();