import React, { useEffect, useState, useRef, useReducer } from 'react';
import { render, useGameEvent, useNetTableKey } from 'react-panorama';
function Store() {
	const storePage = useRef<Panel>(null);
	const [playerData, UpdataPlayerData] = useState(CustomNetTables.GetTableValue("service", "player_data"));
	return (
		<Panel id="StorePage" className="DotaPlusContainer" ref={storePage}>
			<Panel id="SearchAndCategoriesContainer">
				<Panel id="CurrencyContainer">
					<Panel className="SearchOptionsTitleCategories">
						<Label text="#Wallet" />
						<Panel className="FillWidth" />
						<Button id="RefreshButton" />
						<Button id="MoneyComeButton" />
					</Panel>
					<Panel id="CurrencyAmountContainer">
						<Panel className="EventPointsValueIcon ShardSubscription" />
						<Label id="CurrentCurrencyAmount" text={playerData[Game.GetLocalPlayerID()].Shard} />
					</Panel>
					<Panel id="PriceAmountContainer">
						<Panel className="EventPointsValueIcon PriceSubscription" />
						<Label id="CurrentPriceAmount" text={playerData[Game.GetLocalPlayerID()].Price} />
					</Panel>
				</Panel>
				<Panel id="SearchOptionsContainer">
					<Panel className="SearchOptionsTitleCategories">
						<Label text="#DOTA_Search" />
					</Panel>

					<Panel id="SearchContainer">
						<Panel id="SearchBox">
							<TextEntry id="SearchTextEntry" placeholder="#DOTA_StoreBrowse_Search_Placeholder" />
							<Button id="ClearSearchButton" className="CloseButton" />
						</Panel>
					</Panel>
				</Panel>
				<Panel id="SearchCategories">
					<GenericPanel type="TabButton" id="CategoryAll" selected={true} className="SearchCategory" group="search_categories">
						<Panel className="SearchCategoryBackground" />
						<Panel className="SearchCategoryArtOverlay" />
						<Panel className="SearchCategoryText">
							<Label className="SearchCategoryName" text="#CategoryAll" />
							<Label className="SearchCategoryDetails" text="#CategoryAll_Description" />
						</Panel>
					</GenericPanel>
					<GenericPanel type="TabButton" id="CategoryHero" className="SearchCategory" group="search_categories">
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
				</Panel>
			</Panel>
			<Panel className="StoreTabContents">
				<StoreItemContainer tabid="CategoryAll" />
				<StoreItemContainer tabid="CategoryHero" />
				<StoreItemContainer tabid="CategorySkin" />
				<StoreItemContainer tabid="CategoryParticle" />
				<StoreItemContainer tabid="CategoryPet" />
				<StoreItemContainer tabid="CategoryGamePlay" />
			</Panel>
		</Panel>
	)
}
function StoreItemContainer({ tabid }: { tabid: string }) {
	return (
		<GenericPanel type="TabContents" tabid={tabid} group="search_categories" className="StoreItemContainer" selected={tabid == "CategoryAll" ? true : false}>
			<Panel className="StoreHeader">
				<Label localizedText={tabid} />
				<Button className="CloseButton" />
			</Panel>
			<Panel className="StoreItemContainer">

			</Panel>
		</GenericPanel>
	)
}
render(<Store />, $.GetContextPanel());