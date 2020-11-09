import React, { useEffect, useState, useRef, useReducer } from 'react';
import { render, useGameEvent, useNetTableKey } from 'react-panorama';
function Store() {
	const storePage = useRef<Panel>(null);
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
						<Label id="CurrentCurrencyAmount" text="{s:shard}" html={true} />
					</Panel>
					<Panel id="PriceAmountContainer">
						<Panel className="EventPointsValueIcon PriceSubscription" />
						<Label id="CurrentPriceAmount" text="{s:price}" html={true} />
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
					<GenericPanel type="TabButton" id="AllItemCategory" selected={true} className="SearchCategory" group="search_categories">
						<Panel className="SearchCategoryBackground" />
						<Panel className="SearchCategoryArtOverlay" />
						<Panel className="SearchCategoryText">
							<Label className="SearchCategoryName" text="#CategoryAll" />
							<Label className="SearchCategoryDetails" text="# CategoryAll_Description" />
						</Panel>
					</GenericPanel>
				</Panel>
			</Panel>
		</Panel>
	)
}
render(<Store />, $.GetContextPanel());