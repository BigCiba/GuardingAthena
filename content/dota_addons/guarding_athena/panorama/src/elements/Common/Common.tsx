import classNames from 'classnames';
import React, { useEffect, useState, useRef, useReducer } from 'react';
import { render, useGameEvent, useNetTableKey } from 'react-panorama';
import { GetHeroIDByName, GetHeroKV, OpenPopup, Request } from '../../utils/utils';

export function CommonMoneyContainer({ type, count }: { type: string, count: number; }) {
	return (
		<Panel className="CommonMoneyContainer">
			<Image className={classNames({ ShardIcon: type == "Shard", PriceIcon: type == "Price" })} />
			<Label text={count} />
		</Panel>
	);
}
export function CommonBalance({ type, count }: { type: string, count: number; }) {
	const [playerData, UpdataPlayerData] = useState(CustomNetTables.GetTableValue("service", "player_data"));
	return (
		<Panel className="CommonBalance">
			<Label className="CurrentBalance" text="当前余额：" />
			<CommonMoneyContainer type="Shard" count={playerData[Game.GetLocalPlayerID()].Shard} />
			<CommonMoneyContainer type="Price" count={playerData[Game.GetLocalPlayerID()].Price} />
			<TextButton className="RechargeButton" text="立即充值" onactivate={() => OpenPopup("popus_recharge/popus_recharge")} />
		</Panel>
	);
}
export function BuyButton({ type, count, id, itemName }: { type: string, count: number, id: number, itemName: string; }) {
	const buyButton = useRef<Panel>(null);
	const Buy = () => {
		let tData = CustomNetTables.GetTableValue("service", "player_data");
		let Price = tData[Players.GetLocalPlayer()].Price;
		let Shard = tData[Players.GetLocalPlayer()].Shard;
		if ((type == "Shard" && Shard > count) || (type == "Price" && Price > count)) {
			GameEvents.SendCustomGameEventToServer("PurchaseItem", {
				ItemName: itemName,
				Currency: type
			});
		}
	};
	useEffect(() => {
		const id = GameEvents.Subscribe("purchase_complete", (data) => {
			buyButton.current?.FindAncestor("PopupPanel").AddClass("PaySuccess");
			$.Schedule(2, () => {
				$.DispatchEvent("UIPopupButtonClicked", $.GetContextPanel());
			});
		});
		return () => {
			GameEvents.Unsubscribe(id);
		};
	}, []);
	return (
		<Button id={type == "Shard" ? "ShardPurchaseButton" : "PricePurchaseButton"} className="DotaPlusPurchaseButton" onactivate={Buy} ref={buyButton}>
			<Panel id="Contents" className="ButtonCenter">
				<Panel id="EventIcon" className={classNames({ DotaPlusCurrencyIcon: type == "Shard" }, { DotaPlusPriceCurrencyIcon: type == "Price" })} />
				<Label id={type == "Shard" ? "ShardCost" : "PriceCost"} text={count} />
			</Panel>
		</Button>
	);
}