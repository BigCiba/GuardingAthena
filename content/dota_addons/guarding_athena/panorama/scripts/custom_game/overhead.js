let pOverheadContainer = $("#OverheadContainer");

function UpdateOverhead() {
	let iLocalPlayerID = Players.GetLocalPlayer();
	let tHeroes = Entities.GetAllHeroEntities();


	for (let i = 0; i < tHeroes.length; i++) {
		const iUnitEntIndex = tHeroes[i];

		if (!Entities.IsValidEntity(iUnitEntIndex)) continue;

		let pPanel = pOverheadContainer.GetChild(i);
		if (pPanel == null || pPanel == undefined) {
			pPanel = $.CreatePanel("Panel", pOverheadContainer, "");
			pPanel.BLoadLayoutSnippet("Overhead");
		}
		pPanel.SetHasClass("no_health_bar", true);
		
		let vOrigin = Entities.GetAbsOrigin(iUnitEntIndex);
		let fScreenX = Game.WorldToScreenX(vOrigin[0], vOrigin[1], vOrigin[2]);
		let fScreenY = Game.WorldToScreenY(vOrigin[0], vOrigin[1], vOrigin[2]);
		if (fScreenX < 0 || fScreenX > Game.GetScreenWidth() || fScreenY < 0 || fScreenY > Game.GetScreenHeight()) continue;

		if (Entities.IsAlive(iUnitEntIndex) == false || Entities.IsOutOfGame(iUnitEntIndex) == true || Entities.NotOnMinimapForEnemies(iUnitEntIndex) == true || !Entities.IsRealHero(iUnitEntIndex)) continue;

		pPanel.iUnitEntIndex = iUnitEntIndex;
		pPanel.SetHasClass("no_health_bar", false);

		let fOffset = Entities.GetHealthBarOffset(iUnitEntIndex);
		fOffset = fOffset == -1 ? 100 : fOffset;
		let fX = Game.WorldToScreenX(vOrigin[0], vOrigin[1], vOrigin[2] + fOffset);
		let fY = Game.WorldToScreenY(vOrigin[0], vOrigin[1], vOrigin[2] + fOffset);
		pPanel.SetPositionInPixels(GameUI.CorrectPositionValue(fX - pPanel.actuallayoutwidth / 2), GameUI.CorrectPositionValue(fY - pPanel.actuallayoutheight), 0);

		pPanel.FindChildTraverse("HeroImage").heroname = Entities.GetUnitName(iUnitEntIndex);
		let fManaPercent = Entities.GetMana(iUnitEntIndex) / Entities.GetMaxMana(iUnitEntIndex);
		pPanel.FindChildTraverse("ManaProgress").value = fManaPercent;

		let fHealthPercent = Entities.GetHealth(iUnitEntIndex) / Entities.GetMaxHealth(iUnitEntIndex);
		pPanel.FindChildTraverse("HealthProgress").value = fHealthPercent;

		let iLevel = Entities.GetLevel(iUnitEntIndex);
		pPanel.FindChildTraverse("LevelLabel").text = iLevel;

	}
	for (let i = tHeroes.length; i < pOverheadContainer.GetChildCount(); i++) {
		let pPanel = pOverheadContainer.GetChild(i);
		pPanel.DeleteAsync(0)
		// pPanel.AddClass("Hidden");
	}
}

function Update() {
	$.Schedule(Game.GetGameFrameTime(), Update);

	UpdateOverhead();
}

(function () {
	pOverheadContainer.RemoveAndDeleteChildren();
	Update();
})();