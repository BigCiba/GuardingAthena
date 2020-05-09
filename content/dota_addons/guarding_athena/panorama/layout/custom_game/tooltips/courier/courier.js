"use strict";

var self = $.GetContextPanel();

function setupTooltip()
{
	var sCourierName = self.GetAttributeString("courier_name", '');
	var iRotationSpeed = self.GetAttributeInt("rotationspeed", 0);
	var iItemDef = GetCourierItemDef(sCourierName);
	var iItemStyle = GetCourierItemStyle(sCourierName);
	self.SetDialogVariable("courier_name", $.Localize(sCourierName));
	if (iItemDef)
	{
		$("#Bubble").BCreateChildren('<DOTAUIEconSetPreview id="SetPreview" itemdef="'+iItemDef+'" itemstyle="'+iItemStyle+'" displaymode="loadout_small" drawbackground="true" antialias="true" />')
		$("#Bubble").MoveChildBefore($("#SetPreview"), $("#Reflection"));
		$.DispatchEvent("DOTAEconSetPreviewSetRotationSpeed", $("#SetPreview"), 0);
		$.DispatchEventAsync(2, "DOTAEconSetPreviewSetRotationSpeed", $("#SetPreview"), iRotationSpeed);
	}
}
(function() {
	var courier_tooltip = self.GetParent().GetParent();

	var TopArrow = courier_tooltip.FindChildTraverse("TopArrow");
	TopArrow.style.opacity = "0";
	var BottomArrow = courier_tooltip.FindChildTraverse("BottomArrow");
	BottomArrow.style.opacity = "0";
	var LeftArrow = courier_tooltip.FindChildTraverse("LeftArrow");
	LeftArrow.style.opacity = "0";
	var RightArrow = courier_tooltip.FindChildTraverse("RightArrow");
	RightArrow.style.opacity = "0";
})();
