let SearchWord = "";
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

function Update() {
	let HUD = $.GetContextPanel().GetParent().GetParent().GetParent();
	let Tooltips = HUD.FindChildTraverse("Tooltips");
	let AbilityList = HUD.FindChildTraverse("abilities");
	let DOTAAbilityTooltip = Tooltips.FindChildTraverse("DOTAAbilityTooltip");
	let AbilityScepterDescriptionContainer = Tooltips.FindChildTraverse("AbilityScepterDescriptionContainer");
	if (DOTAAbilityTooltip != null && DOTAAbilityTooltip.BHasClass("TooltipVisible") == true) {
		DOTAAbilityTooltip.SetPositionInPixels(0, 0, 0);
		AbilityScepterDescriptionContainer.style.visibility = "collapse"
		if (DOTAAbilityTooltip.BHasClass("IsItem") == true) {
			let ItemName = DOTAAbilityTooltip.FindChildTraverse("ItemImage").itemname;
			let Unit = Players.GetLocalPlayerPortraitUnit();
			// 专属装备
			if (ItemName == "item_" + Entities.GetUnitName( Unit )) {
				for (let i = 2; i <= 9; i++) {
					let Child = DOTAAbilityTooltip.FindChildTraverse("AbilityDescriptionContainer").GetChild(i);
					if (GetHeroesRebornCount(Unit) * 2 + 1 >= i) {
						if (Child.BHasClass("Header") == true && Child.text.search($.Localize("Custom_Tooltip_ability_Active")) == -1) {
							Child.text = Child.text + $.Localize("Custom_Tooltip_ability_Active");
						}
						Child.SetHasClass("Active", true);
					} else {
						if (Child.BHasClass("Header") == true && Child.text.search($.Localize("Custom_Tooltip_ability_NotActive")) == -1) {
							Child.text = Child.text + $.Localize("Custom_Tooltip_ability_NotActive");
						}
					}
				}
			}
			// 创世之戒
			if (ItemName == "item_ring_secret" || ItemName == "item_ring_world" || ItemName == "item_ring_broken" || ItemName == "item_ring_world_broken") {
				let PlayerData = CustomNetTables.GetTableValue("player_data", "player_datas")[Players.GetLocalPlayer()];
				let RingsData = PlayerData.rings;
				// 融合buff
				let iFirstIndex = Math.min(PlayerData.rings["1"].iRingIndex, PlayerData.rings["2"].iRingIndex);
				let iSecondIndex = Math.max(PlayerData.rings["1"].iRingIndex, PlayerData.rings["2"].iRingIndex);
				let Header = DOTAAbilityTooltip.FindChildTraverse("AbilityDescriptionContainer").GetChild(2);
				Header.text = $.Localize("DOTA_Tooltip_ring_" + iFirstIndex + "_" + iSecondIndex);
				let Description = DOTAAbilityTooltip.FindChildTraverse("AbilityDescriptionContainer").GetChild(3);
				Description.text = $.Localize("DOTA_Tooltip_ring_" + iFirstIndex + "_" + iSecondIndex + "_Description");
				let HasModifier = Entities.HasModifier(Unit, "ring_" + iFirstIndex + "_" + iSecondIndex);
				Header.SetHasClass("Active", HasModifier);
				Description.SetHasClass("Active", HasModifier);
				Header.text += HasModifier ? $.Localize("Custom_Tooltip_ability_Active"):$.Localize("Custom_Tooltip_ability_NotActive");
				for (const index in RingsData) {
					const RingData = RingsData[index];
					let Header = DOTAAbilityTooltip.FindChildTraverse("AbilityDescriptionContainer").GetChild(Number(index) * 2 + 2);
					Header.text = $.Localize("DOTA_Tooltip_ring_0_" + RingData.iRingIndex);
					let Description = DOTAAbilityTooltip.FindChildTraverse("AbilityDescriptionContainer").GetChild(Number(index) * 2 + 3);
					Description.text = $.Localize("DOTA_Tooltip_ring_0_" + RingData.iRingIndex + "_Description");
					let HasModifier = Entities.HasModifier(Unit, RingData.sModifierName);
					Header.SetHasClass("Active", HasModifier);
					Description.SetHasClass("Active", HasModifier);
					Header.text += HasModifier ? $.Localize("Custom_Tooltip_ability_Active"):$.Localize("Custom_Tooltip_ability_NotActive");
					// 破碎创世之戒
					if (ItemName == "item_ring_broken" || ItemName == "item_ring_world_broken") {
						break;
					}
				}
			}
		} else {
			for (let index = 0; index < AbilityList.GetChildCount(); index++) {
				let Ability = AbilityList.FindChildTraverse("Ability" + index);
				if (Ability.BHasHoverStyle()) {
					let Unit = Players.GetLocalPlayerPortraitUnit();
					let AbilityName = Ability.FindChildTraverse("AbilityImage").abilityname;
					let AbilityIndex = Entities.GetAbilityByName( Unit, AbilityName );
					let AbilityLevel = Abilities.GetLevel(AbilityIndex);
					let Attribute = Tooltips.FindChildTraverse("AbilityExtraAttributes");
					let text = "";
					Attribute.text = "";
					
					// 技能伤害
					let AbilityDamage = Abilities.GetAbilityDamage( AbilityIndex );
					if (AbilityDamage != null && AbilityDamage != "") {
						let localization = "DOTA_Tooltip_ability_" + AbilityName + "_abilitydamage";
						let Name = $.Localize(localization);
						if (Name.search("DOTA_Tooltip_ability_") != -1) {
							Name = $.Localize("DOTA_Tooltip_ability_common_abilitydamage");
						}
						let HasPct = Name.search("%") != -1
						text += Name.replace("%","") + "<font color='white'>" + String(AbilityDamage.toFixed(2)).replace(".00","").replace(/(\.[1-9])0/,"$1") + (HasPct ? "%":"") + "</font>";
						text += "<br></br>";
					}
	
					// 技能伤害
					let AbilityDuration = Abilities.GetDuration( AbilityIndex );
					if (AbilityDuration != null && AbilityDuration != "") {
						let localization = "DOTA_Tooltip_ability_" + AbilityName + "_abilityduration";
						let Name = $.Localize(localization);
						if (Name.search("DOTA_Tooltip_ability_") != -1) {
							Name = $.Localize("DOTA_Tooltip_ability_common_abilityduration");
						}
						let HasPct = Name.search("%") != -1
						text += Name.replace("%","") + "<font color='white'>" + String(AbilityDuration.toFixed(2)).replace(".00","").replace(/(\.[1-9])0/,"$1") + (HasPct ? "%":"") + "</font>";
						text += "<br></br>";
					}
	
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
	
					Tooltips.FindChildTraverse("CurrentAbilityManaCost").SetHasClass("Hidden", true);
					Tooltips.FindChildTraverse("CurrentAbilityCooldown").SetHasClass("Hidden", true);
	
					// Tooltips.FindChildTraverse("ScepterUpgradeHeader").GetChild(0).style.backgroundImage = 'url("s2r://panorama/images/heroes/icons/'+Entities.GetUnitName(Players.GetLocalPlayerPortraitUnit())+'_png.vtex")';
					// 神杖提示
					if (GameUI.AbilitiesKv[AbilityName].HasScepterUpgrade == "1") {
						let localization = "";
						let ShowTooltip = false;
						let ScepterLevel = String(GameUI.AbilitiesKv[AbilityName].ScepterLevel).split("|");
						for (let i = 0; i < ScepterLevel.length; i++) {
							const Level = ScepterLevel[i];
							if (GetHeroesRebornCount(Unit) >= Level) {
								let Description = (i == 0 ? "":"<br></br>") + $.Localize("DOTA_Tooltip_ability_" + AbilityName + "_scepter_description_" + Level);
								for (const key in AbilitySpecial) {
									const SpecialName = Object.keys(AbilitySpecial[key])[1];
									Description = Description.replace(new RegExp("%"+SpecialName+"%(%+)"), "<font color='white'>" + Abilities.GetLevelSpecialValueFor(AbilityIndex, SpecialName, AbilityLevel - 1) + "%</font>");
									Description = Description.replace(new RegExp("%"+SpecialName+"%"), "<font color='white'>" + Abilities.GetLevelSpecialValueFor(AbilityIndex, SpecialName, AbilityLevel - 1) + "</font>");
								}
								localization += Description;
								ShowTooltip = true;
								AbilityScepterDescriptionContainer.style.visibility = "visible"
							}
						}
						if (ShowTooltip == true) {
							AbilityScepterDescriptionContainer.style.visibility = "visible"
							AbilityScepterDescriptionContainer.GetChild(1).text = localization;
						} else {
							AbilityScepterDescriptionContainer.style.visibility = "collapse"
						}
					} else {
						AbilityScepterDescriptionContainer.style.visibility = "collapse";
					}
	
					// 添加不减少冷却提示
					let IgnoreCooldownReduction = GameUI.AbilitiesKv[AbilityName].IgnoreCooldownReduction || "0";
					// 添加驱散类型
					let PurgeType = GameUI.AbilitiesKv[AbilityName].PurgeType || "0";
					if (IgnoreCooldownReduction == "1" || PurgeType != "0") {
						let Description = Tooltips.FindChildTraverse("AbilityDescriptionContainer").GetChild(0);
						let localization = $.Localize("DOTA_Tooltip_ability_" + AbilityName + "_Description");
						for (const key in AbilitySpecial) {
							const SpecialName = Object.keys(AbilitySpecial[key])[1];
							localization = localization.replace(new RegExp("%"+SpecialName+"%(%+)"), "<font color='white'>" + Abilities.GetLevelSpecialValueFor(AbilityIndex, SpecialName, AbilityLevel - 1) + "%</font>");
							localization = localization.replace(new RegExp("%"+SpecialName+"%"), "<font color='white'>" + Abilities.GetLevelSpecialValueFor(AbilityIndex, SpecialName, AbilityLevel - 1) + "</font>");
						}
						Description.text = localization;
						if (PurgeType != "0") {
							Description.text += "<br></br><br></br>" + $.Localize("Custom_Tooltip_ability_PurgeType") + $.Localize("Custom_Tooltip_ability_" + PurgeType);
						}
						if (IgnoreCooldownReduction == "1") {
							Description.text += "<br></br><br></br><font color='#d63c2d'>" + $.Localize("Custom_Tooltip_ability_IgnoreCooldownReduction") + "</font>";
							Tooltips.FindChildTraverse("AbilityCooldown").text = Abilities.GetCooldown(AbilityIndex);
						}
					}
					// 修正位置
					let PositionY = GameUI.CorrectPositionValue(DOTAAbilityTooltip.GetPositionWithinWindow().y);
					let Height = GameUI.CorrectPositionValue(DOTAAbilityTooltip.actuallayoutheight);
					if (Math.floor(PositionY + Height) != 1080) {
						DOTAAbilityTooltip.SetPositionInPixels(0, 1080 - PositionY - Height, 0);
					}
				}
			}
	
			let SearchText = $("#SearchTextEntry").text;
			if (SearchText != SearchWord) {
				SearchWord = SearchText;
				if (SearchText == "") {
					let Contents = $("#ChatWheelMessages").FindChildrenWithClassTraverse("AthenaStoreItem");
					for (let index = 0; index < Contents.length; index++) {
						const EchoItem = Contents[index];
						EchoItem.style.visibility = "visible";
					}
				} else {
					let Contents = $("#ChatWheelMessages").FindChildrenWithClassTraverse("AthenaStoreItem");
					for (let index = 0; index < Contents.length; index++) {
						const EchoItem = Contents[index];
						if (EchoItem.FindChildTraverse("ItemName").text.search(SearchWord) == -1) {
							EchoItem.style.visibility = "collapse";
						} else {
							EchoItem.style.visibility = "visible";
						}
					}
				}
				CategoryFilter($("#ChatWheelText").Type);
			}
		}
	}
	$.Schedule(0, Update);
}
function CategoryFilter(sType) {
	let Contents = $("#ChatWheelMessages").FindChildrenWithClassTraverse("AthenaStoreItem");
	$("#ChatWheelText").text = $.Localize("Category_" + sType);
	$("#ChatWheelText").Type = sType;
	switch (sType) {
		case "inventory":
			for (let index = 0; index < Contents.length; index++) {
				const EchoItem = Contents[index];
				if (EchoItem.BHasClass("InventoryItem") && (EchoItem.FindChildTraverse("ItemName").text.search(SearchWord) != -1 || SearchWord == "")) {
					EchoItem.style.visibility = "visible";
					continue;
				}
				EchoItem.style.visibility = "collapse";
			}
			break;
		case "all":
			for (let index = 0; index < Contents.length; index++) {
				const EchoItem = Contents[index];
				if (EchoItem.BHasClass("StoreItem") && (EchoItem.FindChildTraverse("ItemName").text.search(SearchWord) != -1 || SearchWord == "")) {
					EchoItem.style.visibility = "visible";
					continue;
				}
				EchoItem.style.visibility = "collapse";
			}
			break;
	
		default:
			for (let index = 0; index < Contents.length; index++) {
				const EchoItem = Contents[index];
				if (EchoItem.BHasClass("StoreItem") && EchoItem.Type == sType && (EchoItem.FindChildTraverse("ItemName").text.search(SearchWord) != -1 || SearchWord == "")) {
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
			// 预览技能
			const PetKV = GameUI.PetsKv[ItemName];
			for (let index = 1; index <= 5; index++) {
				const AbilityName = PetKV["Ability" + index];
				if (AbilityName != undefined || AbilityName != null) {
					let AbilityPanel = $.CreatePanelWithProperties("DOTAAbilityImage", self.FindChildTraverse("SkillPreview"), AbilityName, {abilityname: AbilityName});
					AbilityPanel.SetPanelEvent("onmouseover", function() {
						$.DispatchEvent("DOTAShowAbilityTooltip", AbilityPanel, AbilityName);
					});
					AbilityPanel.SetPanelEvent("onmouseout", function() {
						$.DispatchEvent("DOTAHideAbilityTooltip");
					});
				}
			}
			self.SetPanelEvent("onmouseover", function () {
				$.DispatchEvent(
					"UIShowCustomLayoutParametersTooltip",
					self,
					"courier_tooltip",
					"file://{resources}/layout/custom_game/tooltips/courier/courier.xml",
					"courier_name=" + ItemName + "&rotationspeed=2");
			}.bind(self));
		
			self.SetPanelEvent("onmouseout", function () {
				$.DispatchEvent("UIHideCustomLayoutTooltip", self, "courier_tooltip");
			}.bind(self));
		}
		if (ItemData.Type == "particle") {
			self.AddClass("Prefab_league");
		}
		self.Type = ItemData.Type;
		self.Shard = ItemData.Shard;
		self.Price = ItemData.Price;
		self.ItemName = ItemData.ItemName;
		self.FindChildTraverse("ItemImage").SetImage("file://{images}/custom_game/"+ItemData.Type+"/"+ItemData.ItemName+".png");
		self.FindChildTraverse("ItemName").SetDialogVariable("item_name", $.Localize(ItemName));
		self.FindChildTraverse("ItemTypeLabel").SetDialogVariable("item_type", $.Localize("StoreItemType_" + ItemData.Type));
		self.FindChildTraverse("ShardCost").SetDialogVariable("shard_cost", ItemData.Shard);
		self.FindChildTraverse("PriceCost").SetDialogVariable("price_cost", ItemData.Price);
		if (ItemData.Shard == "-1") {
			self.AddClass("NoShard");
		}
		if (ItemData.Price == "-1") {
			self.AddClass("NoPrice");
		}
		self.SetHasClass("StoreItem", true);
		self.FindChildTraverse("ShardPurchaseButton").SetPanelEvent("onactivate", function() {
			let Shard = GetPlayerShard(Players.GetLocalPlayer());
			// if (Shard > this.Shard) {
			// 	GameEvents.SendCustomGameEventToServer("PurchaseItem", {
			// 		ItemName: this.id,
			// 		Currency: "Shard"
			// 	});
			// }
			$.DispatchEvent(
				"UIShowCustomLayoutPopupParameters",
				"qrcode",
				"file://{resources}/layout/custom_game/popups/payment/payment.xml",
				ReadAttributeData({
					Shard: this.Shard,
					CostType: "Shard",
					ItemName: self.ItemName,
					Image: "file://{images}/custom_game/"+self.Type+"/"+self.ItemName+".png"
				}));
		}.bind(self));
		self.FindChildTraverse("PricePurchaseButton").SetPanelEvent("onactivate", function() {
			let Price = GetPlayerPrice(Players.GetLocalPlayer());
			// if (Shard > this.Shard) {
			// 	GameEvents.SendCustomGameEventToServer("PurchaseItem", {
			// 		ItemName: this.id,
			// 		Currency: "Price"
			// 	});
			// }
			$.DispatchEvent(
				"UIShowCustomLayoutPopupParameters",
				"qrcode",
				"file://{resources}/layout/custom_game/popups/payment/payment.xml",
				ReadAttributeData({
					Price: this.Price,
					CostType: "Price",
					ItemName: self.ItemName,
					Image: "file://{images}/custom_game/"+self.Type+"/"+self.ItemName+".png"
				}));
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
			self.SetPanelEvent("onmouseover", function () {
				$.DispatchEvent(
					"UIShowCustomLayoutParametersTooltip",
					self,
					"courier_tooltip",
					"file://{resources}/layout/custom_game/tooltips/courier/courier.xml",
					"courier_name=" + ItemName + "&rotationspeed=2");
			}.bind(self));
		
			self.SetPanelEvent("onmouseout", function () {
				$.DispatchEvent("UIHideCustomLayoutTooltip", self, "courier_tooltip");
			}.bind(self));
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
								let Panel = $("#ChatWheelMessages").FindChildTraverse("Player" + localPlayerID + "_" + ItemData.ItemName);
								Panel = ReloadPanel(Panel, "Panel", $("#ChatWheelMessages"), "Player" + localPlayerID + "_" + ItemData.ItemName);
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
							let Panel = $("#ChatWheelMessages").FindChildTraverse("Player" + localPlayerID + "_" + ItemData.ItemName);
							Panel = ReloadPanel(Panel, "Panel", $("#ChatWheelMessages"), "Player" + localPlayerID + "_" + ItemData.ItemName);
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
			if (ItemData.Purchaseable == "1") {
				let Panel = $("#ChatWheelMessages").FindChildTraverse(ItemData.ItemName);
				Panel = ReloadPanel(Panel, "Panel", $("#ChatWheelMessages"), ItemData.ItemName);
				LoadStoreItem(Panel);
				Panel.SetStoreItem(ItemData);
			}
		}
	}
}
(function () {
	let HUD = $.GetContextPanel().GetParent().GetParent().GetParent();
	Update();

	CustomNetTables.SubscribeNetTableListener("service", UpdateServiceNetTable);

	UpdateServiceNetTable("service", "store_item", CustomNetTables.GetTableValue("service", "store_item"));

	CustomNetTables.SubscribeNetTableListener("service", UpdateServiceNetTable);

	UpdateServiceNetTable("service", "player_data", CustomNetTables.GetTableValue("service", "player_data"));
	CategoryFilter('all');
})();