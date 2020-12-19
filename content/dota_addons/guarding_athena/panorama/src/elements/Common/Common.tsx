import classNames from 'classnames';
import React, { useEffect, useState, useRef, useReducer } from 'react';
import { render, useGameEvent, useNetTableKey } from 'react-panorama';
import { GetHeroIDByName, GetHeroKV, Request } from '../../utils/utils';

export function CommonMoneyContainer({ type, count }: { type: string, count: number }) {
	return (
		<Panel className="CommonMoneyContainer">
			<Image className={classNames({ ShardIcon: type == "Shard", PriceIcon: type == "Price" })} />
			<Label text={count} />
		</Panel>
	)
}
export function CommonBalance({ type, count }: { type: string, count: number }) {
	const [playerData, UpdataPlayerData] = useState(CustomNetTables.GetTableValue("service", "player_data"));
	return (
		<Panel className="CommonBalance">
			<Label className="CurrentBalance" text="当前余额：" />
			<CommonMoneyContainer type={type} count={type == "Shard" ? playerData[Game.GetLocalPlayerID()].Shard : playerData[Game.GetLocalPlayerID()].Price} />
			<TextButton className="RechargeButton" text="立即充值" />
		</Panel>
	)
}