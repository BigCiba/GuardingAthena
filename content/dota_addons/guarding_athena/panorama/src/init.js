"use strict";
var offsetX = null;
var offsetY = null;
var Draggable = false;
var DragPanel = null;
function DragCallback() {
	var isLeftPressed = GameUI.IsMouseDown(0);
	if (isLeftPressed && DragPanel != null) {
		let position = GameUI.GetCursorPosition();
		if (offsetX == null || offsetY == null) {
			offsetX = DragPanel.GetPositionWithinWindow().x - position[0];
			offsetY = DragPanel.GetPositionWithinWindow().y - position[1];
			DragPanel.style.align = "left top";
			DragPanel.style.margin = "0px 0px 0px 0px";
		}
		if (offsetX != null && offsetY != null) {
			DragPanel.SetPositionInPixels((position[0] + offsetX) * DragPanel.actualuiscale_x, (position[1] + offsetY) * DragPanel.actualuiscale_y, 0);
		}
	}
	else {
		offsetX = null;
		offsetY = null;
	}
	if (Draggable || isLeftPressed) {
		$.Schedule(Game.GetGameFrameTime(), DragCallback);
	}
	else {
		DragPanel = null;
	}
}
GameUI.CustomUIConfig().StartDrag = function (panel) {
	Draggable = true;
	DragPanel = panel;
	DragCallback();
};
GameUI.CustomUIConfig().EndDrag = function () {
	Draggable = false;
};

function EmitSoundForPlayer(tData) {
	Game.EmitSound(tData.soundname);
}

(function () {
	GameEvents.Subscribe("emit_sound_for_player", EmitSoundForPlayer);

	// $.Msg(DotaDefaultUIElement_t);
	GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_KILLCAM, false);
	GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_QUICK_STATS, false);
	GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_INVENTORY_SHOP, false);
	GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_TOP_BAR, false);
	GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_PREGAME_STRATEGYUI, false);

	GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_CUSTOMUI_BEHIND_HUD_ELEMENTS, true);
	GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_FLYOUT_SCOREBOARD, false);
	GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_HERO_SELECTION_GAME_NAME, false);
	GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_HERO_SELECTION_TEAMS, true);
	GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_HERO_SELECTION_CLOCK, true);
	GameUI.SetDefaultUIEnabled(DotaDefaultUIElement_t.DOTA_DEFAULT_UI_ACTION_PANEL, false);

	// {"DOTA_DEFAULT_UI_INVALID":-1,"DOTA_DEFAULT_UI_TOP_TIMEOFDAY":0,"DOTA_DEFAULT_UI_TOP_HEROES":1,"DOTA_DEFAULT_UI_FLYOUT_SCOREBOARD":2,"DOTA_DEFAULT_UI_ACTION_PANEL":3,"DOTA_DEFAULT_UI_ACTION_MINIMAP":4,"DOTA_DEFAULT_UI_INVENTORY_PANEL":5,"DOTA_DEFAULT_UI_INVENTORY_SHOP":6,"DOTA_DEFAULT_UI_INVENTORY_ITEMS":7,"DOTA_DEFAULT_UI_INVENTORY_QUICKBUY":8,"DOTA_DEFAULT_UI_INVENTORY_COURIER":9,"DOTA_DEFAULT_UI_INVENTORY_PROTECT":10,"DOTA_DEFAULT_UI_INVENTORY_GOLD":11,"DOTA_DEFAULT_UI_SHOP_SUGGESTEDITEMS":12,"DOTA_DEFAULT_UI_SHOP_COMMONITEMS":13,"DOTA_DEFAULT_UI_HERO_SELECTION_TEAMS":14,"DOTA_DEFAULT_UI_HERO_SELECTION_GAME_NAME":15,"DOTA_DEFAULT_UI_HERO_SELECTION_CLOCK":16,"DOTA_DEFAULT_UI_TOP_MENU_BUTTONS":17,"DOTA_DEFAULT_UI_TOP_BAR_BACKGROUND":18,"DOTA_DEFAULT_UI_TOP_BAR_RADIANT_TEAM":19,"DOTA_DEFAULT_UI_TOP_BAR_DIRE_TEAM":20,"DOTA_DEFAULT_UI_TOP_BAR_SCORE":21,"DOTA_DEFAULT_UI_ENDGAME":22,"DOTA_DEFAULT_UI_ENDGAME_CHAT":23,"DOTA_DEFAULT_UI_QUICK_STATS":24,"DOTA_DEFAULT_UI_PREGAME_STRATEGYUI":25,"DOTA_DEFAULT_UI_KILLCAM":26,"DOTA_DEFAULT_UI_TOP_BAR":27,"DOTA_DEFAULT_UI_CUSTOMUI_BEHIND_HUD_ELEMENTS":28,"DOTA_DEFAULT_UI_ELEMENT_COUNT":29}
})();
