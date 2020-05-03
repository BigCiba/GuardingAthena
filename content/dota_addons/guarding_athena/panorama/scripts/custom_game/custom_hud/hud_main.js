// 显示错误提示
function ShowError(data) {
	$( "#ErrorMsg" ).text = $.Localize(data.text);
	//$( "#DOTAErrorMsg" ).SetHasClass( "ShowErrorMsg", false );
	$( "#DotaErrorMsg" ).RemoveClass("PopOutEffect");
	$( "#DotaErrorMsg" ).RemoveClass("ShowErrorMsg");
	$( "#DotaErrorMsg" ).AddClass("PopOutEffect");
	$( "#DotaErrorMsg" ).AddClass("ShowErrorMsg");
	$.Schedule(1,HideError);
}
function HideError() {
	$( "#DotaErrorMsg" ).RemoveClass("PopOutEffect");
	$( "#DotaErrorMsg" ).RemoveClass("ShowErrorMsg");
}
GameEvents.Subscribe( "show_error", ShowError );

function UpdateAbilityDetail() {
	let HUD = $.GetContextPanel().GetParent().GetParent().GetParent();
	let Tooltips = HUD.FindChildTraverse("Tooltips");
	let AbilityList = HUD.FindChildTraverse("abilities");
	for (let index = 0; index < AbilityList.GetChildCount(); index++) {
		let Ability = AbilityList.FindChildTraverse("Ability" + index);
		if (Ability.BHasHoverStyle()) {
			let AbilityName = Ability.FindChildTraverse("AbilityImage").abilityname;
			let AbilityIndex = Entities.GetAbilityByName( Players.GetLocalPlayerPortraitUnit(), AbilityName );
			let AbilityLevel = Abilities.GetLevel(AbilityIndex);
			let Attribute = Tooltips.FindChildTraverse("AbilityExtraAttributes");
			let text = "";
			Attribute.text = "";
			let AbilitySpecial = GameUI.AbilitiesKv[AbilityName].AbilitySpecial;
			for (const key in AbilitySpecial) {
				const SpecialName = Object.keys(AbilitySpecial[key])[1];
				let localization = "DOTA_Tooltip_ability_" + AbilityName + "_" + SpecialName;
				if ($.Localize(localization) != localization) {
					let Name = $.Localize(localization);
					let HasPct = Name.search("%") != -1
					let LevelValue = Abilities.GetLevelSpecialValueFor(AbilityIndex, SpecialName, AbilityLevel - 1);
					let NextLevelValue = Abilities.GetLevelSpecialValueFor(AbilityIndex, SpecialName, AbilityLevel);
					text += Name.replace("%","") + "<font color='white'>" + String(LevelValue.toFixed(2)).replace(".00","").replace(/(\.[1-9])0/,"$1") + (HasPct ? "%":"") + "</font>";
					if (Ability.BHasClass("show_level_up_tab") && NextLevelValue - LevelValue != 0) {
						text += "<font color='#45DD3B'> +" +  String((NextLevelValue - LevelValue).toFixed(2)).replace(".00","").replace(/(\.[1-9])0/,"$1") + (HasPct ? "%":"") + "</font>";
					}
					text += "<br></br>";
				}
			}
			Attribute.text = text;

			// 魔法消耗
			Tooltips.FindChildTraverse("AbilityManaCost").text = Tooltips.FindChildTraverse("CurrentAbilityManaCost").text;
			Tooltips.FindChildTraverse("AbilityCooldown").text = Tooltips.FindChildTraverse("CurrentAbilityCooldown").text;
			// let Position = Tooltips.FindChildTraverse("DOTAAbilityTooltip").GetPositionWithinWindow();
			// let Height = Tooltips.FindChildTraverse("DOTAAbilityTooltip").actuallayoutheight;
			// if (Position.y + Height != 900) {
			// 	$.Msg(Position.y + Height);
			// 	Tooltips.FindChildTraverse("DOTAAbilityTooltip").SetPositionInPixels(0, 0, 0);
			// }
		}
	}
	$.Schedule(0, UpdateAbilityDetail);
	
}
function LoadStoreItem(self) {
	self.BLoadLayoutSnippet("StoreItem");
	self.SetStoreItem = function(ItemData) {
		let ItemName = ItemData.ItemName;
		if (ItemData.Type == "hero") {
			ItemName = "npc_dota_hero_" + ItemData.ItemName;
			self.FindChildTraverse("HeroIcon").heroname = ItemName;
			self.AddClass("HeroItem");
		}
		if (ItemData.Type == "pet") {
			self.AddClass("Prefab_courier");
		}
		if (ItemData.Type == "particle") {
			self.AddClass("Prefab_league");
		}
		self.FindChildTraverse("ItemImage").SetImage("file://{images}/custom_game/"+ItemData.Type+"/"+ItemData.ItemName+".png");
		self.FindChildTraverse("ItemName").SetDialogVariable("item_name", $.Localize(ItemName));
		self.FindChildTraverse("ItemTypeLabel").SetDialogVariable("item_type", $.Localize("StoreItemType_" + ItemData.Type));
		self.FindChildTraverse("ShardCost").SetDialogVariable("shard_cost", ItemData.Shard);
		self.FindChildTraverse("PriceCost").SetDialogVariable("price_cost", ItemData.Price);
	};

}
function UpdateServiceNetTable(tableName, tableKeyName, table) {
	let localPlayerID = Players.GetLocalPlayer();

	if (tableKeyName == "player_data") {
		for (let sPlayerID in table) {
			let tData = table[sPlayerID];
			$("#CurrentCurrencyAmount").SetDialogVariable("shard", tData.Shard);
			$("#CurrentPriceAmount").SetDialogVariable("price", tData.Price);
		}
	}
	if (tableKeyName == "store_item") {
		for (let Index in table) {
			let ItemData = table[Index];
			let Panel = $("#ChatWheelMessages").FindChildTraverse(ItemData.ItemName);
			Panel = ReloadPanel(Panel, "Panel", $("#ChatWheelMessages"), ItemData.ItemName);
			LoadStoreItem(Panel);
			Panel.SetStoreItem(ItemData);
		}
	}
}
(function () {
	let HUD = $.GetContextPanel().GetParent().GetParent().GetParent();
	UpdateAbilityDetail();

	CustomNetTables.SubscribeNetTableListener("service", UpdateServiceNetTable);

	UpdateServiceNetTable("service", "store_item", CustomNetTables.GetTableValue("service", "store_item"));

	CustomNetTables.SubscribeNetTableListener("service", UpdateServiceNetTable);

	UpdateServiceNetTable("service", "player_data", CustomNetTables.GetTableValue("service", "player_data"));
})();