const REQUEST_TIME_OUT = 60;
let _Request_QueueIndex = 0;
let _Request_Table: { [index: string]: Function; } = {};
export function Request(event: string, params: any, func: (data: any) => void) {
	let index = "-1";
	if (typeof func === "function") {
		index = (_Request_QueueIndex++).toString();
		_Request_Table[index] = func;
	}
	GameEvents.SendCustomGameEventToServer("service_events_req", {
		eventName: event,
		data: JSON.stringify(params),
		queueIndex: index
	});
	$.Schedule(REQUEST_TIME_OUT, function () {
		delete _Request_Table[index];
	});
}
GameEvents.Subscribe("service_events_res", function (data) {
	var index = data.queueIndex || "";
	var func = _Request_Table[index];
	if (!func) return;
	delete _Request_Table[index];
	if (func) {
		func(JSON.parse(data.result));
	};
});
export function OpenPopup(id: string | undefined, data?: { [x: string]: any; }) {
	let params = "";
	if (data) {
		for (let key in data) {
			params += key + "=" + data[key] + "&";
		}
	}
	// $.Msg("OpenPopup", params);
	$.DispatchEvent(
		"UIShowCustomLayoutPopupParameters",
		id,
		"file://{resources}/layout/custom_game/popups/" + id + ".xml",
		params);
}
export function GetHeroIDByName(heroName: string) {
	return GameUI.CustomUIConfig().HeroesKv[heroName].HeroID;
}
export function GetHeroKV(heroName: string, key: string) {
	if (GameUI.CustomUIConfig().HeroesKv[heroName][key]) {
		return GameUI.CustomUIConfig().HeroesKv[heroName][key];
	}
	else if (GameUI.CustomUIConfig().HeroesKv["npc_dota_hero_base"][key]) {
		return GameUI.CustomUIConfig().HeroesKv["npc_dota_hero_base"][key];
	}
	return 0;
}
export function ShowTextTooltip(panel: any, text: string) {
	$.DispatchEvent("UIShowTextTooltip", panel, text);
}
export function HideTextTooltip(panel: any) {
	$.DispatchEvent("UIHideTextTooltip", panel);
}
export function ToggleWindows(sName: string) {
	GameEvents.SendEventClientSide("toggle_window", { name: sName });
}