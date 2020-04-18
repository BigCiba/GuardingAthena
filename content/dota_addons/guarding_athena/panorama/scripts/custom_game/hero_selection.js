

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
})();