let GameModeSelectionEndTime = -1;
let PreviewHeroName = "";
let HeroLock = false;
// 默认物品
let PlayerItemData = {
	particle: {
		"1": { ItemName: "default_no_item", Equip: "1", Type: "particle" },
	},
	skin: {},
	pet: {
		"1": { ItemName: "pet_01", Equip: "1", Type: "pet" },
		"2": { ItemName: "pet_02", Equip: "0", Type: "pet" },
		"3": { ItemName: "default_no_item", Equip: "0", Type: "pet" },
	}
};

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
function LoadPlayer(self) {
	self.BLoadLayoutSnippet("PlayerCard");
	self.SetPlayer = function (PlayerID) {
		const tPlayerInfo = Game.GetPlayerInfo(PlayerID);
		let Data = CustomNetTables.GetTableValue("service", "player_" + PlayerID) || {};
		const iLevel = Data.Score == null ? 1 : Math.floor(Data.Score / 10);
		self.FindChildTraverse("AvatarImage").steamid = tPlayerInfo.player_steamid;
		self.FindChildTraverse("UserName").steamid = tPlayerInfo.player_steamid;
		self.FindChildTraverse("BackGroundImage").SetImage(GetBadgesBackground(iLevel));
		self.FindChildTraverse("ItemImage").SetImage(GetBadgesLevel(iLevel));
		self.FindChildTraverse("ProfileLevel").SetImage(GetBadgesBackgroundNumber(iLevel));
		self.SetDialogVariableInt("level", iLevel);
	};
}
function LoadItem(self) {
	self.BLoadLayoutSnippet("EconItem");
	self.SetItem = function (Type, ItemData, Panel) {
		_Type = (Type == "courier" ? "pet" : Type);

		let Quality = "Common";
		// let Quality = ItemData.ItemName == "default_no_item" ? "Common" : GameUI.CustomUIConfig().PlayerItemsKV[ItemData.ItemName].Quality;
		self.FindChildTraverse("EconItemImage").SetImage("file://{images}/custom_game/" + _Type + "/" + ItemData.ItemName + ".png");
		self.FindChildTraverse("Equipped").SetHasClass("hide", ItemData.Equip == "0");
		self.FindChildTraverse("BottomLayer").AddClass(Quality);
		self.Type = _Type;
		self.Panel = Panel;
		self.Image = "file://{images}/custom_game/" + _Type + "/" + ItemData.ItemName + ".png";
		self.SetPanelEvent("onactivate", function () {
			let Contents = $("#Contents").FindChildrenWithClassTraverse("EconItem");
			for (let index = 0; index < Contents.length; index++) {
				const EchoItem = Contents[index];
				EchoItem.FindChildTraverse("Equipped").SetHasClass("hide", EchoItem.id != this.id);
			}
			Request("query.operate", {
				"router": Type + "." + (ItemData.Equip == 0 ? "equip" : "unequip"),
				"ItemName": ItemData.ItemName
			}, data => {
				$.Msg(data);
				if (data.status == 0) {
					if (ItemData.Equip == 0) {
						this.Panel.SetImage(this.Image);
					} else {
						this.Panel.SetImage("file://{images}/custom_game/skin/default_no_item.png");
					}
				}
			});
			// GameEvents.SendCustomGameEventToServer("ToggleItemEquipState", {
			// 	ItemName: this.id,
			// 	Type: this.Type,
			// 	HeroName: PreviewHeroName,
			// });
			$("#ContextMenuBody").ToggleClass("ContextMenuBodyShow");
		}.bind(self));
	};
}
function PreviewHero(HeroName) {
	if (HeroLock) {
		return;
	}
	$("#HeroInfoContent").SetHasClass("HeroLocked", $("#HeroListPanel").FindChildTraverse(HeroName).BHasClass("Unlock") == false);
	const HeroKV = GameUI.CustomUIConfig().HeroesKv[HeroName];
	// 预览英雄属性与名字
	$("#HeroNamePanel").FindChildTraverse("PrimaryAttributeImage").SetImage(GetAttributeIcon(HeroKV.AttributePrimary));
	$("#HeroNamePanel").SetDialogVariable("heroname", $.Localize(HeroName));
	// 预览技能
	$("#HeroAbilityPanel").RemoveAndDeleteChildren();
	for (let index = 1; index <= 5; index++) {
		const AbilityName = HeroKV["Ability" + index];
		let AbilityPanel = $.CreatePanelWithProperties("DOTAAbilityImage", $("#HeroAbilityPanel"), AbilityName, { abilityname: AbilityName });
		AbilityPanel.AddClass("HeroAbility");
		AbilityPanel.SetPanelEvent("onmouseover", function () {
			$.DispatchEvent("DOTAShowAbilityTooltip", AbilityPanel, AbilityName);
		});
		AbilityPanel.SetPanelEvent("onmouseout", function () {
			$.DispatchEvent("DOTAHideAbilityTooltip");
		});
	}

	// 预览模型
	$("#HeroScenePanel").RemoveAndDeleteChildren();
	let HeroScenePanel = $.CreatePanelWithProperties("DOTAScenePanel", $("#HeroScenePanel"), HeroName, { unit: HeroName, light: "global_light", antialias: "true", drawbackground: "false", particleonly: "false", hittest: "false" });
	HeroScenePanel.AddClass("HeroScene");
	HeroScenePanel.SetScenePanelToLocalHero(GameUI.CustomUIConfig().HeroesKv[HeroName].HeroID);
	PreviewHeroName = HeroName;
	UpdataSkinSetting();
	// 更新英雄皮肤
	// let Data = CustomNetTables.GetTableValue("service", "player_data")[Players.GetLocalPlayer()];
	// let ItemList = Data == null ? PlayerItemData["skin"] : Data["skin"];
	// ItemList = ItemList[PreviewHeroName];
	// if (ItemList == null) {
	// 	ItemList = { "1": { "Expiration": "9999-12-31", "ItemName": "default_no_item", "Equip": 1, "Type": "skin" } };
	// }
	// for (const key in ItemList) {
	// 	const ItemData = ItemList[key];
	// 	if (ItemData.Equip == 1) {
	// 		$("#SettingSkin").FindChildrenWithClassTraverse("SettingIcon")[0].SetImage("file://{images}/custom_game/skin/" + ItemData.ItemName + ".png");
	// 		break;
	// 	}
	// }
	$("#ContextMenuBody").RemoveClass("ContextMenuBodyShow");
	Game.EmitSound(GameUI.CustomUIConfig().HeroesKv[PreviewHeroName].HeroSelectSoundEffect);
}
function ShowContextMenu(ID, Type) {
	let LocalPlayerID = Players.GetLocalPlayer();
	let SettingPanel = $("#" + ID);
	let ContextMenuBody = $("#ContextMenuBody");
	let Posistion = GameUI.GetPanelCenter(SettingPanel.FindChildTraverse("MenuArrowContainer"));
	$("#Contents").RemoveAndDeleteChildren();
	let Data = CustomNetTables.GetTableValue("service", "player_" + Type + "_" + LocalPlayerID);
	for (const index in Data) {
		const ItemData = Data[index];
		if (Type != "skin" || ItemData.Hero == PreviewHeroName) {
			let Panel = $("#Contents").FindChildTraverse(ItemData.ItemName);
			Panel = ReloadPanel(Panel, "Panel", $("#Contents"), ItemData.ItemName);
			LoadItem(Panel);
			Panel.SetItem(Type, ItemData, SettingPanel.FindChildrenWithClassTraverse("SettingIcon")[0]);
		}
	}
	$.Schedule(0.06, () => {
		let Width = ContextMenuBody.actuallayoutwidth / 2;
		let Height = ContextMenuBody.actuallayoutheight + SettingPanel.FindChildTraverse("MenuArrowContainer").actuallayoutheight / 2;
		ContextMenuBody.SetPositionInPixels(GameUI.CorrectPositionValue(Posistion.x - Width), GameUI.CorrectPositionValue(Posistion.y - Height), 0);
	});
	if (ContextMenuBody.Type != undefined && ContextMenuBody.Type == Type) {
		ContextMenuBody.ToggleClass("ContextMenuBodyShow");
	} else {
		ContextMenuBody.AddClass("ContextMenuBodyShow");
	}
	ContextMenuBody.Type = Type;
}

function UpdateCommonNetTable(tableName, tableKeyName, table) {
	var localPlayerID = Players.GetLocalPlayer();

	if (tableKeyName == "game_mode_info") {
		GameModeSelectionEndTime = table.game_mode_selection_end_time;
	}
}
function UpdateServiceData() {
	$.GetContextPanel().SetHasClass("ServerChecked", true);
	let PlayerID = Players.GetLocalPlayer();
	// 解锁英雄
	let playerHeroData = CustomNetTables.GetTableValue("service", "player_hero_" + PlayerID);
	for (const index in playerHeroData) {
		const ItemData = playerHeroData[index];
		const HeroName = "npc_dota_hero_" + ItemData.ItemName;
		$("#HeroListPanel").FindChildTraverse(HeroName).AddClass("Unlock");
	}
	// 宠物
	UpdataCourierSetting();
	// 皮肤
	UpdataSkinSetting();
	// 特效
	UpdataParticleSetting();
	// 更新玩家卡片
	let AllPlayerID = Game.GetAllPlayerIDs();
	for (let index = 0; index < AllPlayerID.length; index++) {
		const PlayerID = AllPlayerID[index];
		$("#PlayerContent").FindChildTraverse("Player" + PlayerID).SetPlayer(Number(PlayerID));
	}
}
// 更新信使设置预览
function UpdataCourierSetting() {
	let PlayerID = Players.GetLocalPlayer();
	let playerCourierData = CustomNetTables.GetTableValue("service", "player_courier_" + PlayerID);
	for (const index in playerCourierData) {
		const ItemData = playerCourierData[index];
		// $.Msg(ItemData);
		if (ItemData.Equip == 1) {
			$("#SettingPet").FindChildrenWithClassTraverse("SettingIcon")[0].SetImage("file://{images}/custom_game/pet/" + ItemData.ItemName + ".png");
			break;
		}
		$("#SettingPet").FindChildrenWithClassTraverse("SettingIcon")[0].SetImage("file://{images}/custom_game/pet/default_no_item.png");
	}
}
// 更新皮肤设置预览
function UpdataSkinSetting() {
	let PlayerID = Players.GetLocalPlayer();

	let playerSkinData = CustomNetTables.GetTableValue("service", "player_skin_" + PlayerID);
	$.Msg(playerSkinData)
	for (const index in playerSkinData) {
		const ItemData = playerSkinData[index];
		if (ItemData.Equip == 1 && ItemData.Hero == PreviewHeroName) {
			$("#SettingSkin").FindChildrenWithClassTraverse("SettingIcon")[0].SetImage("file://{images}/custom_game/skin/" + ItemData.ItemName + ".png");
			break;
		}
		$("#SettingSkin").FindChildrenWithClassTraverse("SettingIcon")[0].SetImage("file://{images}/custom_game/skin/default_no_item.png");
	}
}
// 更新特效设置预览
function UpdataParticleSetting() {
	let PlayerID = Players.GetLocalPlayer();
	let playerParticleData = CustomNetTables.GetTableValue("service", "player_particle_" + PlayerID);
	$.Msg(playerParticleData);
	for (const index in playerParticleData) {
		const ItemData = playerParticleData[index];
		if (ItemData.Equip == 1) {
			$("#SettingParticle").FindChildrenWithClassTraverse("SettingIcon")[0].SetImage("file://{images}/custom_game/particle/" + ItemData.ItemName + ".png");
			break;
		}
		$("#SettingParticle").FindChildrenWithClassTraverse("SettingIcon")[0].SetImage("file://{images}/custom_game/particle/default_no_item.png");
	}
}
function UpdateServiceNetTable(tableName, tableKeyName, table) {
	let localPlayerID = Players.GetLocalPlayer();

	if (tableKeyName == "player_data") {
		for (let sPlayerID in table) {
			let tData = table[sPlayerID];
			// 更新玩家等级
			$("#PlayerContent").FindChildTraverse("Player" + sPlayerID).SetPlayer(Number(sPlayerID));
			// 解锁英雄
			for (const key in tData["hero"]) {
				const HeroInfo = tData["hero"][key];
				const HeroName = "npc_dota_hero_" + HeroInfo.ItemName;
				$("#HeroListPanel").FindChildTraverse(HeroName).AddClass("Unlock");
			}
			// 更新装备物品
			for (const Type in tData) {
				if (Type == "pet" || Type == "particle") {
					let ItemList = tData[Type];
					let id = "#Setting" + Type.replace(Type[0], Type[0].toUpperCase());
					for (const key in ItemList) {
						const ItemData = ItemList[key];
						if (ItemData.Equip == 1) {
							$(id).FindChildrenWithClassTraverse("SettingIcon")[0].SetImage("file://{images}/custom_game/" + Type + "/" + ItemData.ItemName + ".png");
							break;
						}
						$(id).FindChildrenWithClassTraverse("SettingIcon")[0].SetImage("file://{images}/custom_game/" + Type + "/default_no_item.png");
					}
				}
			}
			const ItemList = tData["skin"][PreviewHeroName];
			for (const key in ItemList) {
				const ItemData = ItemList[key];
				if (ItemData.Equip == 1) {
					$("#SettingSkin").FindChildrenWithClassTraverse("SettingIcon")[0].SetImage("file://{images}/custom_game/skin/" + ItemData.ItemName + ".png");
					break;
				}
				$("#SettingSkin").FindChildrenWithClassTraverse("SettingIcon")[0].SetImage("file://{images}/custom_game/skin/default_no_item.png");
			}
			// 锁定英雄

		}

	}
	$.GetContextPanel().SetHasClass("ServerChecked", true);
}
function PickHero() {
	if ($("#HeroInfoContent").BHasClass("HeroLocked") == true) {
		return;
	}
	GameEvents.SendCustomGameEventToServer("hero_seletion", {
		"HeroName": PreviewHeroName
	});
	Game.EmitSound(GameUI.CustomUIConfig().HeroesKv[PreviewHeroName].PickSound);
	$.GetContextPanel().SetHasClass("HeroLocked", true);
	HeroLock = true;
}
function SelectDifficulty(Difficulty) {
	GameEvents.SendCustomGameEventToServer("difficulty_seletion", {
		"Difficulty": Difficulty
	});
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


	// GameModeSelectionEndTime = Game.GetGameTime() + Game.GetStateTransitionTime();

	Update();
	// 加载英雄卡片
	for (const key in GameUI.CustomUIConfig().HeroesKv) {
		const HeroKV = GameUI.CustomUIConfig().HeroesKv[key];
		if (HeroKV.override_hero == undefined || HeroKV.UnitLabel == "hide") {
			continue;
		}
		let HeroName = HeroKV.override_hero;
		let Panel = $("#HeroListPanel").FindChildTraverse(HeroName);
		Panel = ReloadPanelWithProperties(Panel, "DOTAHeroMovie", $("#HeroListPanel"), HeroName, { heroname: HeroName });
		Panel.BLoadLayoutSnippet("HeroCard");
		// 上锁
		if (HeroKV.UnitLabel == "lock") {
			Panel.RemoveClass("Unlock");
		}
		Panel.SetPanelEvent("onactivate", function () {
			PreviewHero(HeroName);
		});
	}
	// 加载玩家卡片
	let AllPlayerID = Game.GetAllPlayerIDs();
	for (let index = 0; index < AllPlayerID.length; index++) {
		const PlayerID = AllPlayerID[index];
		let Panel = $("#PlayerContent").FindChildTraverse("Player" + PlayerID);
		Panel = ReloadPanel(Panel, "Panel", $("#PlayerContent"), "Player" + PlayerID);
		LoadPlayer(Panel);
		Panel.SetPlayer(PlayerID);
	}
	// 默认预览
	PreviewHero("npc_dota_hero_omniknight");

	CustomNetTables.SubscribeNetTableListener("common", UpdateCommonNetTable);

	UpdateCommonNetTable("common", "game_mode_info", CustomNetTables.GetTableValue("common", "game_mode_info"));


	// UpdateServiceData();

	GameEvents.Subscribe("service_game_enter", UpdateServiceData);
	// CustomNetTables.SubscribeNetTableListener("service", UpdateServiceNetTable);

	// UpdateServiceNetTable("service", "player_data", CustomNetTables.GetTableValue("service", "player_data"));
})();