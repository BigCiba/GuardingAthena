import classNames from 'classnames';
import React, { useEffect, useState, useRef, useReducer } from 'react';
import { render, useGameEvent, useNetTableKey } from '@demon673/react-panorama';
import { HideTextTooltip, OpenPopup, Request, ShowTextTooltip } from '../utils/utils';

function Inventory() {
	const storePage = useRef<Panel>(null);
	const filterInput = useRef<TextEntry>(null);
	const [filterWord, SetFilterWord] = useState("");	// 搜索过滤词
	const [playerData, UpdataPlayerData] = useState(CustomNetTables.GetTableValue("service", "player_" + Game.GetLocalPlayerID()));
	// $.Msg(playerData);
	useEffect(() => {
		// 切换面板
		const toggleWindow = GameEvents.Subscribe("toggle_window", data => {
			if (data.name === "Inventory") {
				storePage.current?.ToggleClass('HideStorePage');
			} else {
				storePage.current?.SetHasClass("HideStorePage", true);
			}
		});
		const listener = CustomNetTables.SubscribeNetTableListener("service", (_, eventKey, eventValue) => {
			if ("player_" + Game.GetLocalPlayerID() === eventKey) {
				UpdataPlayerData(eventValue);
			}
		});
		return () => {
			GameEvents.Unsubscribe(toggleWindow);
			CustomNetTables.UnsubscribeNetTableListener(listener);
		};
	}, []);
	const OpenRecharge = () => {
		OpenPopup("popus_recharge/popus_recharge");
	};
	const Refresh = () => {
		Request("query.operate", {
			router: "player.get"
		}, data => {
			$.Msg(data);
		});
	};
	return (
		<Panel id="StorePage" className="DotaPlusContainer HideStorePage" ref={storePage}>
			<Panel className="StorePageMain">
				<Panel id="SearchAndCategoriesContainer">
					<Panel id="CurrencyContainer">
						<Panel className="SearchOptionsTitleCategories">
							<Label text="#Wallet" />
							<Panel className="FillWidth" />
							<Button id="RefreshButton" onmouseover={(self) => ShowTextTooltip(self, "Refresh")} onmouseout={HideTextTooltip} onactivate={Refresh} />
							{/* <Button id="MoneyComeButton" onactivate={OpenRecharge} /> */}
						</Panel>
						<Panel id="CurrencyAmountContainer" onmouseover={(self) => ShowTextTooltip(self, "Shard_Description")} onmouseout={HideTextTooltip}>
							<Panel className="EventPointsValueIcon ShardSubscription" />
							<Label id="CurrentCurrencyAmount" text={playerData.Shard} />
						</Panel>
						<Panel id="PriceAmountContainer" onmouseover={(self) => ShowTextTooltip(self, "Price_Description")} onmouseout={HideTextTooltip}>
							<Panel className="EventPointsValueIcon PriceSubscription" />
							<Label id="CurrentPriceAmount" text={playerData.Price} />
							<TextButton className="Recharge" text="充值" onactivate={OpenRecharge} />
						</Panel>
					</Panel>
					<Panel id="SearchOptionsContainer">
						<Panel className="SearchOptionsTitleCategories">
							<Label text="#DOTA_Search" />
						</Panel>

						<Panel id="SearchContainer">
							<Panel id="SearchBox">
								<TextEntry ref={filterInput} id="SearchTextEntry" placeholder="#DOTA_StoreBrowse_Search_Placeholder" ontextentrychange={(a) => { a.text == "" && SetFilterWord(""); }} oninputsubmit={(a) => SetFilterWord(a.text)} />
								<Button id="ClearSearchButton" className="CloseButton" onactivate={() => { storePage.current?.SetHasClass("Hidden", true); }} />
							</Panel>
						</Panel>
					</Panel>
					<Panel id="SearchCategories">
						{/* <GenericPanel type="TabButton" id="CategoryAll" selected={true} className="SearchCategory" group="search_categories">
							<Panel className="SearchCategoryBackground" />
							<Panel className="SearchCategoryArtOverlay" />
							<Panel className="SearchCategoryText">
								<Label className="SearchCategoryName" text="#CategoryAll" />
								<Label className="SearchCategoryDetails" text="#CategoryAll_Description" />
							</Panel>
						</GenericPanel> */}
						<GenericPanel type="TabButton" id="CategoryHero" className="SearchCategory" group="search_categories" selected={true}>
							<Panel className="SearchCategoryBackground" />
							<Panel className="SearchCategoryArtOverlay" />
							<Panel className="SearchCategoryText">
								<Label className="SearchCategoryName" text="#CategoryHero" />
								<Label className="SearchCategoryDetails" text="#CategoryHero_Description" />
							</Panel>
						</GenericPanel>
						<GenericPanel type="TabButton" id="CategorySkin" className="SearchCategory" group="search_categories">
							<Panel className="SearchCategoryBackground" />
							<Panel className="SearchCategoryArtOverlay" />
							<Panel className="SearchCategoryText">
								<Label className="SearchCategoryName" text="#CategorySkin" />
								<Label className="SearchCategoryDetails" text="#CategorySkin_Description" />
							</Panel>
						</GenericPanel>
						<GenericPanel type="TabButton" id="CategoryParticle" className="SearchCategory" group="search_categories">
							<Panel className="SearchCategoryBackground" />
							<Panel className="SearchCategoryArtOverlay" />
							<Panel className="SearchCategoryText">
								<Label className="SearchCategoryName" text="#CategoryParticle" />
								<Label className="SearchCategoryDetails" text="#CategoryParticle_Description" />
							</Panel>
						</GenericPanel>
						<GenericPanel type="TabButton" id="CategoryPet" className="SearchCategory" group="search_categories">
							<Panel className="SearchCategoryBackground" />
							<Panel className="SearchCategoryArtOverlay" />
							<Panel className="SearchCategoryText">
								<Label className="SearchCategoryName" text="#CategoryPet" />
								<Label className="SearchCategoryDetails" text="#CategoryPet_Description" />
							</Panel>
						</GenericPanel>
						<GenericPanel type="TabButton" id="CategoryGamePlay" className="SearchCategory" group="search_categories">
							<Panel className="SearchCategoryBackground" />
							<Panel className="SearchCategoryArtOverlay" />
							<Panel className="SearchCategoryText">
								<Label className="SearchCategoryName" text="#CategoryGamePlay" />
								<Label className="SearchCategoryDetails" text="#CategoryGamePlay_Description" />
							</Panel>
						</GenericPanel>
						<GenericPanel type="TabButton" id="CategoryOther" className="SearchCategory" group="search_categories">
							<Panel className="SearchCategoryBackground" />
							<Panel className="SearchCategoryArtOverlay" />
							<Panel className="SearchCategoryText">
								<Label className="SearchCategoryName" text="#CategoryOther" />
								<Label className="SearchCategoryDetails" text="#CategoryOther_Description" />
							</Panel>
						</GenericPanel>
					</Panel>
				</Panel>
				<Panel className="StoreTabContents">
					{/* <StoreItemContainer word={filterWord} tabid="CategoryAll" type="all" /> */}
					<StoreItemContainer word={filterWord} tabid="CategoryHero" type="hero" />
					<StoreItemContainer word={filterWord} tabid="CategorySkin" type="skin" />
					<StoreItemContainer word={filterWord} tabid="CategoryParticle" type="particle" />
					<StoreItemContainer word={filterWord} tabid="CategoryPet" type="pet" />
					<StoreItemContainer word={filterWord} tabid="CategoryGamePlay" type="gameplay" />
					<StoreItemContainer word={filterWord} tabid="CategoryOther" type="other" />
				</Panel>
			</Panel>
			<Button className="CloseButton" onactivate={() => { storePage.current?.ToggleClass('HideStorePage'); }} />
		</Panel>
	);
}
function StoreItemContainer({ word, tabid, type }: { word: string, tabid: string, type: string; }) {
	let _type = type == "pet" ? "courier" : type;
	let itemDatas = CustomNetTables.GetTableValue("service", "info_store");
	let [inventoryData, setInventoryData] = useState(CustomNetTables.GetTableValue("service", "player_" + _type + "_" + Game.GetLocalPlayerID()));
	useEffect(() => {
		const listener = CustomNetTables.SubscribeNetTableListener("service", (_, eventKey, eventValue) => {
			if ("player_" + _type + "_" + Game.GetLocalPlayerID() === eventKey) {
				setInventoryData(eventValue);
			}
		});
		return () => {
			CustomNetTables.UnsubscribeNetTableListener(listener);
		};
	}, []);
	return (
		<GenericPanel type="TabContents" tabid={tabid} group="search_categories" className="StoreItemContainer" selected={tabid == "CategoryHero" ? true : false}>
			<Panel className="StoreHeader">
				<Label localizedText={tabid} />
				{/* <Button className="CloseButton" /> */}
			</Panel>
			<Panel className="StoreItemList">
				{Object.keys(itemDatas).map((key) => {
					if ((itemDatas[key].Type == type || type == "all")) {
						let ItemName = itemDatas[key].ItemName;
						if (itemDatas[key].Type == "hero") {
							ItemName = "npc_dota_hero_" + ItemName;
						}
						// 遍历物品
						for (const index in inventoryData) {
							const itemData = inventoryData[index];
							if (itemData.ItemName == itemDatas[key].ItemName) {
								if (word == "" || $.Localize(ItemName).search(word) != -1) {
									return <StoreItem key={key} itemData={itemDatas[key]} playerData={itemData} />;
								}
							}
						}
					}
				})}
			</Panel>
		</GenericPanel>
	);
}
function StoreItem({ itemData, playerData }: { itemData: any; playerData: any; }) {
	let _type = itemData.Type == "pet" ? "courier" : itemData.Type;
	let ShowCourierTooltip = (self: Panel) => {
		if (itemData.Type == "pet") {
			$.DispatchEvent(
				"UIShowCustomLayoutParametersTooltip",
				self,
				"courier_tooltip",
				"file://{resources}/layout/custom_game/tooltips/courier/courier.xml",
				"courier_name=" + itemData.ItemName + "&rotationspeed=2");
		}
	};
	let HideCourierTooltip = (self: Panel) => {
		if (itemData.Type == "pet") {
			$.DispatchEvent("UIHideCustomLayoutTooltip", self, "courier_tooltip");
		}
	};
	let Query = (mod: string, action: string) => {
		Request("query.operate", {
			"router": mod + "." + action,
			"ItemName": itemData.ItemName
		}, data => {
			$.Msg(data);
		});
	};
	let ShowItemDetail = (self: Panel) => {
		OpenPopup("popup_inventory_item/popup_inventory_item", { itemData: JSON.stringify(itemData) });
	};
	return (
		<Panel className={classNames("AthenaStoreItem",
			{ HeroItem: itemData.Type == "hero" },
			{ HeroItem: itemData.Type == "skin" },
			{ Prefab_courier: itemData.Type == "pet" },
			{ Prefab_ward: itemData.Type == "particle" },
			{ Prefab_bundle: itemData.Type == "gameplay" },
		)}
			onmouseover={ShowCourierTooltip}
			onmouseout={HideCourierTooltip}
			onactivate={ShowItemDetail}
		>
			<Panel id="ItemImageContainer">
				<Image id="ItemImage" scaling="stretch-to-fit-preserve-aspect" src={"file://{images}/custom_game/" + itemData.Type + "/" + itemData.ItemName + ".png"}>
					<Panel id="SkillPreview">
					</Panel>
				</Image>
			</Panel>
			<Label id="ItemName" localizedText={itemData.Type == "hero" ? "npc_dota_hero_" + itemData.ItemName : itemData.ItemName} />
			<Panel id="ItemType">
				<Panel id="UnitIcon">
					{itemData.Type == "hero" &&
						<DOTAHeroImage id="HeroIcon" heroimagestyle="icon" heroname={"npc_dota_hero_" + itemData.ItemName} scaling="stretch-to-fit-preserve-aspect" />
					}
					{itemData.Type == "skin" &&
						<DOTAHeroImage id="HeroIcon" heroimagestyle="icon" heroname={GameUI.CustomUIConfig().PlayerItemsKV[itemData.ItemName].Hero} scaling="stretch-to-fit-preserve-aspect" />
					}
					<Panel id="ItemTypeIcon" />
				</Panel>
				<Label id="ItemTypeLabel" text={"StoreItemType_" + itemData.Type} />
			</Panel>

			<Panel className="PurchaseButtonList">
				{/* {itemData.Shard > 0 &&
					<Button id="ShardPurchaseButton" className="DotaPlusPurchaseButton">
						<Panel id="Contents" className="ButtonCenter">
							<Panel id="EventIcon" className="DotaPlusCurrencyIcon" />
							<Label id="ShardCost" text={itemData.Shard} />
						</Panel>
					</Button>
				}
				{itemData.Price > 0 &&
					<Button id="PricePurchaseButton" className="DotaPlusPurchaseButton">
						<Panel id="Contents" className="ButtonCenter">
							<Panel id="EventIcon" className="DotaPlusPriceCurrencyIcon" />
							<Label id="PriceCost" text={itemData.Price} />
						</Panel>
					</Button>
				} */}
				{(playerData.Equip && playerData.Equip == 0) &&
					<Button id="PricePurchaseButton" className="DotaPlusPurchaseButton" onactivate={() => Query(_type, "equip")}>
						<Panel id="Contents" className="ButtonCenter">
							{/* <Panel id="EventIcon" className="DotaPlusPriceCurrencyIcon" /> */}
							<Label id="PriceCost" localizedText="Equip" />
						</Panel>
					</Button>
				}
				{(playerData.Equip && playerData.Equip == 1) &&
					<Button id="PricePurchaseButton" className="DotaPlusPurchaseButton" onactivate={() => Query(_type, "unequip")}>
						<Panel id="Contents" className="ButtonCenter">
							{/* <Panel id="EventIcon" className="DotaPlusPriceCurrencyIcon" /> */}
							<Label id="PriceCost" localizedText="UnEquip" />
						</Panel>
					</Button>
				}
				{playerData.Equip == undefined &&
					<Button id="PricePurchaseButton" className="DotaPlusPurchaseButton">
						<Panel id="Contents" className="ButtonCenter">
							{/* <Panel id="EventIcon" className="DotaPlusPriceCurrencyIcon" /> */}
							<Label id="PriceCost" localizedText="HasItem" />
						</Panel>
					</Button>
				}
			</Panel>
		</Panel>
	);
}
render(<Inventory />, $.GetContextPanel());