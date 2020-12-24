import classNames from 'classnames';
import React, { useEffect, useState, useRef, useReducer } from 'react';
import { render, useGameEvent, useNetTableKey } from 'react-panorama';
import { GetHeroIDByName, GetHeroKV, Request } from '../../utils/utils';

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
			<TextButton className="RechargeButton" text="立即充值" />
		</Panel>
	);
}
export function BuyButton({ type, count }: { type: string, count: number; }) {
	return (
		<Button id={type == "Shard" ? "ShardPurchaseButton" : "PricePurchaseButton"} className="DotaPlusPurchaseButton">
			<Panel id="Contents" className="ButtonCenter">
				<Panel id="EventIcon" className={classNames({ DotaPlusCurrencyIcon: type == "Shard" }, { DotaPlusPriceCurrencyIcon: type == "Price" })} />
				<Label id={type == "Shard" ? "ShardCost" : "PriceCost"} text={count} />
			</Panel>
		</Button>
	);
}