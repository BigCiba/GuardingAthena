// GameUI.HeroesKv = HeroesKv;
// GameUI.PlayerItemsKV = PlayerItemsKV;
// GameUI.AbilitiesKv = AbilitiesKv;
// GameUI.PetsKv = PetsKv;
var offsetX = null;
var offsetY = null;
var Draggable = false;
var DragPanel = null;
function DragCallback() {
	var isLeftPressed = GameUI.IsMouseDown(0);
	if (isLeftPressed && DragPanel != null) {
		let position = GameUI.GetCursorPosition();
		// $.Msg(position);
		// $.Msg(DragPanel.GetPositionWithinWindow());
		if (offsetX == null || offsetY == null) {
			offsetX = DragPanel.GetPositionWithinWindow().x - position[0];
			offsetY = DragPanel.GetPositionWithinWindow().y - position[1];
			// $.Msg(offsetX);
			// $.Msg(offsetY);
			DragPanel.style.align = "left top";
			DragPanel.style.margin = "0px 0px 0px 0px";
		}
		if (offsetX != null && offsetY != null) {
			// $.Msg("fix:", (position[0] + offsetX), ",", (position[1] + offsetY), ",", 0);
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
// function EmitSoundForPlayer(tData) {
// 	Game.EmitSound(tData.soundname);
// }

// (function () {
// 	GameEvents.Subscribe("emit_sound_for_player", EmitSoundForPlayer);
// })();
