function ReloadPanel(Panel, PanelType, ParentPanel, PanelID) {
	if (Panel == undefined || Panel == null) {
		Panel = $.CreatePanel(PanelType, ParentPanel, PanelID);
	} else {
		Panel.RemoveAndDeleteChildren();
	}
	return Panel;
}
function ReloadPanelWithProperties(Panel, PanelType, ParentPanel, PanelID, Properties) {
	if (Panel == undefined || Panel == null) {
		Panel = $.CreatePanelWithProperties(PanelType, ParentPanel, PanelID, Properties);
	} else {
		Panel.RemoveAndDeleteChildren();
	}
	return Panel;
}
function GetBadgesBackground(iLevel) {
	return "file://{images}/profile_badges/bg_0" + Math.ceil(iLevel / 100) + ".psd"
}
function GetBadgesLevel(iLevel) {
	return "file://{images}/profile_badges/level_" + (Array(2).join(0) + iLevel).slice(-2) + ".png";
}
function GetBadgesBackgroundNumber(iLevel) {
	return "file://{images}/profile_badges/bg_number_0" + Math.ceil(iLevel / 100) + ".psd";
}
function GetAttributeIcon(Attribute) {
	switch (Attributes[Attribute]) {
		case Attributes.DOTA_ATTRIBUTE_STRENGTH:
			return "s2r://panorama/images/primary_attribute_icons/primary_attribute_icon_strength_psd.vtex";
		case Attributes.DOTA_ATTRIBUTE_AGILITY:
			return "s2r://panorama/images/primary_attribute_icons/primary_attribute_icon_agility_psd.vtex";
		case Attributes.DOTA_ATTRIBUTE_INTELLECT:
			return "s2r://panorama/images/primary_attribute_icons/primary_attribute_icon_intelligence_psd.vtex";
		default:
			break;
	}
}
function GetPlayerShard(sPlayerID) {
	let tData = CustomNetTables.GetTableValue("service", "player_data");
	return tData[sPlayerID].Shard;
}
function GetPlayerPrice(sPlayerID) {
	let tData = CustomNetTables.GetTableValue("service", "player_data");
	return tData[sPlayerID].Price;
}
function GetCourierItemDef(sCourierName) {
	return GameUI.PetsKv[sCourierName].ItemDef;
}

function ReadAttributeData(data) {
	var retStr = "";
	for (var key in data) {
		retStr += key + "=" + data[key] + "&";
	}
	return retStr;
}

function GetCourierItemStyle(sCourierName) {
	return GameUI.PetsKv[sCourierName].ItemStyle || 0;
}
function GetHeroesRebornCount(iEntity) {
	for (let index = 0; index < Entities.GetNumBuffs(iEntity); index++) {
		const buff = Entities.GetBuff( iEntity, index );
		if (Buffs.GetName( iEntity, buff ) == "modifier_reborn") {
			return Buffs.GetStackCount(iEntity, buff)
		}
	}
	return 0
}
// 获取英雄穿戴的皮肤
function GetSkinName(iEntity) {
	for (const sItemName in GameUI.PlayerItemsKV) {
		let tItemData = GameUI.PlayerItemsKV[sItemName];
		if (tItemData.Hero && tItemData.Hero == Entities.GetUnitName(iEntity)) {
			if (Entities.HasModifier(iEntity, "modifier_" + sItemName)) {
				return sItemName;
			}
		}
	}
	return false;
}
Entities.HasModifier = function (iEntIndex, sModifierName) {
	for (let index = 0; index < Entities.GetNumBuffs(iEntIndex); index++) {
		const buff = Entities.GetBuff( iEntIndex, index );
		if (Buffs.GetName( iEntIndex, buff ) == sModifierName) {
			return true;
		}
	}
	return false;
}
GameUI.GetPanelCenter = function (Panel) {
	let Position = GameUI.GetPanelPosition(Panel);
	return {x: Position.x + Panel.actuallayoutwidth / 2, y: Position.y + Panel.actuallayoutheight / 2};
}
GameUI.GetPanelPosition = function (Panel) {
	let Position = Panel.GetPositionWithinWindow();
	return {x: Position.x, y: Position.y};
}
GameUI.GetHUDSeed = function () {
	return 1080 / Game.GetScreenHeight();
}
GameUI.CorrectPositionValue = function (value) {
	return GameUI.GetHUDSeed() * value;
}