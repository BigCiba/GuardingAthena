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
function CategoryFilter(sType) {
	let Contents = $("#ChatWheelMessages").FindChildrenWithClassTraverse("AthenaStoreItem");
	$("#ChatWheelText").text = $.Localize("Category_" + sType);
	switch (sType) {
		case "inventory":
			for (let index = 0; index < Contents.length; index++) {
				const EchoItem = Contents[index];
				if (EchoItem.BHasClass("InventoryItem")) {
					EchoItem.style.visibility = "visible";
					continue;
				}
				EchoItem.style.visibility = "collapse";
			}
			break;
		case "all":
			for (let index = 0; index < Contents.length; index++) {
				const EchoItem = Contents[index];
				if (EchoItem.BHasClass("StoreItem")) {
					EchoItem.style.visibility = "visible";
					continue;
				}
				EchoItem.style.visibility = "collapse";
			}
			break;
	
		default:
			for (let index = 0; index < Contents.length; index++) {
				const EchoItem = Contents[index];
				if (EchoItem.BHasClass("StoreItem") && EchoItem.Type == sType) {
					EchoItem.style.visibility = "visible";
					continue;
				}
				EchoItem.style.visibility = "collapse";
			}
			break;
	}
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
		self.Type = ItemData.Type;
		self.Shard = ItemData.Shard;
		self.Price = ItemData.Price;
		self.IteaName = ItemName;
		self.FindChildTraverse("ItemImage").SetImage("file://{images}/custom_game/"+ItemData.Type+"/"+ItemData.ItemName+".png");
		self.FindChildTraverse("ItemName").SetDialogVariable("item_name", $.Localize(ItemName));
		self.FindChildTraverse("ItemTypeLabel").SetDialogVariable("item_type", $.Localize("StoreItemType_" + ItemData.Type));
		self.FindChildTraverse("ShardCost").SetDialogVariable("shard_cost", ItemData.Shard);
		self.FindChildTraverse("PriceCost").SetDialogVariable("price_cost", ItemData.Price);
		self.SetHasClass("StoreItem", true);
		self.FindChildTraverse("ShardPurchaseButton").SetPanelEvent("onactivate", function() {
			let Shard = GetPlayerShard(Players.GetLocalPlayer());
			if (Shard > this.Shard) {
				GameEvents.SendCustomGameEventToServer("PurchaseItem", {
					ItemName: this.id,
					Currency: "Shard"
				});
			}
		}.bind(self));
		self.FindChildTraverse("PricePurchaseButton").SetPanelEvent("onactivate", function() {
			let Shard = GetPlayerShard(Players.GetLocalPlayer());
			if (Shard > this.Shard) {
				GameEvents.SendCustomGameEventToServer("PurchaseItem", {
					ItemName: this.id,
					Currency: "Price"
				});
			}
		}.bind(self));
		
	};
	self.GetShardCost = function () {
		return self.Shard
	}
	self.GetPriceCost = function () {
		return self.Price
	}
	self.SetInventoryItem = function(ItemData) {
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
		self.Type = ItemData.Type;
		self.ItemName = ItemData.ItemName;
		self.FindChildTraverse("ItemImage").SetImage("file://{images}/custom_game/"+ItemData.Type+"/"+ItemData.ItemName+".png");
		self.FindChildTraverse("ItemName").SetDialogVariable("item_name", $.Localize(ItemName));
		self.FindChildTraverse("ItemTypeLabel").SetDialogVariable("item_type", $.Localize("StoreItemType_" + ItemData.Type));
		// self.FindChildTraverse("ShardCost").SetDialogVariable("shard_cost", ItemData.Shard);
		// self.FindChildTraverse("PriceCost").SetDialogVariable("price_cost", ItemData.Price);
		self.SetHasClass("InventoryItem", true);
		self.SetHasClass("Equipped", ItemData.Equip == "1");
		self.SetHasClass("UnEquipped", ItemData.Equip == "0");
		self.FindChildTraverse("EquipButton").SetPanelEvent("onactivate", function() {
			GameEvents.SendCustomGameEventToServer("ToggleItemEquipState", {
				ItemName: this.ItemName,
				Type: this.Type,
			});
		}.bind(self));
		self.FindChildTraverse("UnEquipButton").SetPanelEvent("onactivate", function() {
			GameEvents.SendCustomGameEventToServer("ToggleItemEquipState", {
				ItemName: this.ItemName,
				Type: this.Type,
			});
		}.bind(self));
		
	};

}
function MoneyComeButton() {
	$.DispatchEvent(
		"UIShowCustomLayoutPopupParameters",
		"qrcode",
		"file://{resources}/layout/custom_game/popups/qrcode/qrcode.xml",
		{});
}
function UpdateServiceNetTable(tableName, tableKeyName, table) {
	let localPlayerID = Players.GetLocalPlayer();

	if (tableKeyName == "player_data") {
		for (let sPlayerID in table) {
			let tData = table[sPlayerID];
			for (const sType in tData) {
				if (sType == "skin") {
					for (const HeroName in tData[sType]) {
						const ItemList = tData[sType][HeroName];
						for (const Index in ItemList) {
							const ItemData = ItemList[Index];
							if (ItemData.ItemName != "default_no_item") {
								let Panel = $("#ChatWheelMessages").FindChildTraverse(ItemData.ItemName + localPlayerID);
								Panel = ReloadPanel(Panel, "Panel", $("#ChatWheelMessages"), ItemData.ItemName + localPlayerID);
								LoadStoreItem(Panel);
								Panel.SetInventoryItem(ItemData);
							}
						}
					}
				} else if(typeof(tData[sType]) == "object") {
					const ItemList = tData[sType];
					for (const Index in ItemList) {
						const ItemData = ItemList[Index];
						if (ItemData.ItemName != "default_no_item") {
							let Panel = $("#ChatWheelMessages").FindChildTraverse(ItemData.ItemName + localPlayerID);
							Panel = ReloadPanel(Panel, "Panel", $("#ChatWheelMessages"), ItemData.ItemName + localPlayerID);
							LoadStoreItem(Panel);
							Panel.SetInventoryItem(ItemData);
						}
					}
				}
			}
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
	CategoryFilter('all');
})();