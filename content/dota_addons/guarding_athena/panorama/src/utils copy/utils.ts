import React, { useState, useRef, useEffect, DependencyList } from 'react';
import { render, useGameEvent, useNetTableKey, useRegisterForUnhandledEvent } from '@demon673/react-panorama';
import classNames from 'classnames';

export function useToggle(initial = false): [boolean, () => void, (value: boolean) => void] {
	const [value, setValue] = React.useState(initial);
	const toggle = React.useCallback(() => {
		setValue((v) => !v);
	}, []);
	return [value, toggle, setValue];
}

export function useToogleWindow(window_name: string): [boolean, () => void, (value: boolean) => void] {
	const [state, toggleState, setState] = useToggle(false);
	useGameEvent("custom_ui_toggle_windows", data => {
		if (data.window_name == window_name) {
			toggleState();
		} else {
			setState(false);
		}
	}, []);
	return [state, toggleState, setState];
}
export function useRefresh(deps?: DependencyList): [string, React.Dispatch<React.SetStateAction<string>>] {
	const [refresh, setRefresh] = useState("-1");
	useEffect(() => {
		setRefresh(String(Number(refresh) * -1));
	}, deps);
	return [refresh, setRefresh];
}

export function useNetTable<TName extends keyof CustomNetTableDeclarations>(name: TName, key: keyof CustomNetTableDeclarations[TName]): [NetworkedData<CustomNetTableDeclarations[TName][keyof CustomNetTableDeclarations[TName]]>, () => void] {
	const [value, setValue] = useState(() => CustomNetTables.GetTableValue(name, key));
	const refresh = () => setValue(CustomNetTables.GetTableValue(name, key));
	useEffect(() => {
		const listener = CustomNetTables.SubscribeNetTableListener(name, (_, eventKey, eventValue) => {
			if (key === eventKey) {
				setValue(eventValue);
			}
		});
		return () => CustomNetTables.UnsubscribeNetTableListener(listener);
	}, [name, key]);
	return [value, refresh];
}
export function useNetTableJson<TName extends keyof CustomNetTableDeclarations>(name: TName, key: keyof CustomNetTableDeclarations[TName]): [NetworkedData<CustomNetTableDeclarations[TName][keyof CustomNetTableDeclarations[TName]]>, () => void] {
	const [value, setValue] = useState(() => Transform(CustomNetTables.GetTableValue(name, key), name));
	const refresh = () => setValue(Transform(CustomNetTables.GetTableValue(name, key), name));
	useEffect(() => {
		const listener = CustomNetTables.SubscribeNetTableListener(name, (_, eventKey, eventValue) => {
			if (key === eventKey) {
				setValue(Transform(eventValue, name));
			}
		});
		return () => CustomNetTables.UnsubscribeNetTableListener(listener);
	}, [name, key]);
	return [value, refresh];
}
export function useSchedule(Tick: () => boolean | number | void, deps?: any[]) {
	useEffect(() => {
		let id: ScheduleID;
		function Timer() {
			// 最多每1/30秒更新一次
			let result = Tick();
			if (typeof (result) == "number" && result >= 0) {
				id = $.Schedule(result, Timer);
			} else {
				id = -1 as ScheduleID;
			}
		}
		Timer();

		return () => {
			try {
				if (id && id != -1)
					$.CancelScheduled(id);
			} catch (error) {
			}
		};

	}, deps);
}

/**
 * 让一些组件定时刷新
 * @param iInterval 刷新间隔
 */
export function useHeartBeat(iInterval: number) {
	const [fTime, SetTime] = useState(Game.Time());
	useSchedule(() => {
		SetTime(Game.Time());
		return iInterval;
	}, []);
}
/**
 * 使用刷新事件更新组件
 * @param eventName 事件名
 */
export function useRefreshEvent(eventName: string) {
	const [fTime, SetTime] = useState(Game.Time());
	useGameEvent("custom_refresh_order", (event) => {
		if (event.name == eventName) {
			SetTime(Game.Time());
		}
	}, []);
}
// 使用刷新事件的state
export function useRefreshState<S>(eventName: string, initialState: (() => S)): [S, React.Dispatch<React.SetStateAction<S>>] {
	const [state, setState] = useState<S>(initialState());
	useGameEvent("custom_refresh_order", (event) => {
		if (event.name == eventName) {
			setState(initialState());
		}
	}, []);
	return [state, setState];
}
// 使用依赖网表的state
export function useNetTableState<S, TName extends keyof CustomNetTableDeclarations, K extends keyof CustomNetTableDeclarations[TName]>(name: TName, key: K, initialState: S | (() => S), callback: ((dep: NetworkedData<CustomNetTableDeclarations[TName][K]>) => void)): [S, React.Dispatch<React.SetStateAction<S>>] {
	const [value, setValue] = useState(initialState);
	const nettable = useNetTableKey(name, key);
	useEffect(() => {
		callback(nettable);
	}, [nettable]);
	return [value, setValue];
}


/**
 * 显示自定义Tooltip
 * @param {Panel} 面板
 * @param {string} 名字
 */
export function ShowCustomTooltip(panel: Panel, name: string, data: { [key: string]: string | number; }) {
	let params: string = "";
	for (const key in data) {
		params += `${key}=${data[key]}&`;
	}
	params.substr(0, params.length - 1);
	$.DispatchEvent("UIShowCustomLayoutParametersTooltip", panel, name, "file://{resources}/layout/custom_game/tooltips/" + name + "/" + name + ".xml", params);
}
/**
 * 隐藏自定义Tooltip
 * @param {Panel} 面板
 * @param {string} 名字
 */
export function HideCustomTooltip(panel: Panel, name: string) {
	$.DispatchEvent("UIHideCustomLayoutTooltip", panel, name);
}
/**
 * 显示菜单
 * @param {Panel} 面板
 * @param {name} 名字
 * @param {showArrow} 是否显示箭头
 * @return {Panel} 
 */
export function ShowContextMenu(panel: Panel, name: string, showArrow: boolean = true): Panel {
	let contextMenu = $.CreatePanel("ContextMenuScript", panel, "");
	if (showArrow) {
		contextMenu.AddClass("ContextMenuBlackArrow");
	}
	contextMenu.GetContentsPanel().BLoadLayout(`file://{resources}/layout/custom_game/context_menu/${name}/${name}.xml`, false, false);
	return contextMenu.GetContentsPanel();
}
export function HideContextMenu() {
	$.DispatchEvent("DismissAllContextMenus");
}
/**
 * 显示纯文本Tooltip
 * @param {Panel} 面板
 * @param {string} 文本
 */
export function DOTAShowTextTooltip(panel: Panel, text: string) {
	$.DispatchEvent("DOTAShowTextTooltip", panel, text);
}
/**
 * 隐藏纯文本Tooltip
 * @param {Panel} 面板
 */
export function DOTAHideTextTooltip(panel: Panel) {
	$.DispatchEvent("DOTAHideTextTooltip", panel);
}
/**
 * 发布更新UI的指令
 * @param {Panel} 面板
 */
export function DispatchRefreshEvent(sName: string) {
	//@ts-ignore
	GameEvents.SendEventClientSide("custom_refresh_order", { name: sName });
}

export module LogHelper {
	export let IsDebug = true;

	/**
	 * 打印对象
	 * @param args
	 * @returns
	 */
	export function print(...args: any[]): void {
		if (!LogHelper.IsDebug) { return; }
		try {
			throw new Error("");
		}
		catch (e) {
			let stack = e.stack;
			let arr = stack.split("\n");
			let a = arr[2].split(" ");
			let b = a[5].split('.');
			let c = a[6].split('/');
			let file = c[c.length - 1].split(':');
			let file_str = `${file[0]}:${parseInt(file[1]) + 10}|`;
			let len = b.length;
			let cls = b[len - 2];
			let fun = b[len - 1];
			if (cls == null) { cls = '?'; }
			let r = `[${file_str}${cls}:${fun}]:`;
			$.Msg(r, ...args);
		}
	}
	/**
	 * 打印对象
	 * @param args
	 * @returns
	 */
	export function warn(...args: any[]): void {
		if (!LogHelper.IsDebug) { return; }
		try {
			throw new Error("");
		}
		catch (e) {
			let stack = e.stack;
			let arr = stack.split("\n");
			let a = arr[2].split(" ");
			let b = a[5].split('.');
			let c = a[6].split('/');
			let file = c[c.length - 1].split(':');
			let file_str = `${file[0]}:${parseInt(file[1]) + 10}|`;
			let len = b.length;
			let cls = b[len - 2];
			let fun = b[len - 1];
			if (cls == null) { cls = '?'; }
			let r = `[${file_str}${cls}:${fun}]:`;
			$.Warning(r, ...args);
		}
	}

	export function DeepPrintTable(table?: Object) {
		if (!LogHelper.IsDebug) { return; }
	}
}