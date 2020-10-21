"use strict";

(() => {
	if (!GameUI.CustomUIConfig().tMouseEvents) {
		GameUI.CustomUIConfig().tMouseEvents = [];
	}
	let CONSUME_EVENT = true
	let CONTINUE_PROCESSING_EVENT = false
	GameUI.SetMouseCallback((sEventName, iValue) => {
		let bResult = CONTINUE_PROCESSING_EVENT;
		let aKeys = Object.keys(GameUI.CustomUIConfig().tMouseEvents);

		aKeys.sort((a, b) => GameUI.CustomUIConfig().tMouseEvents[a].iPriority - GameUI.CustomUIConfig().tMouseEvents[b].iPriority)

		for (let index = aKeys.length - 1; index >= 0; index--) {
			let sKey = aKeys[index];
			const tMouseEvent = GameUI.CustomUIConfig().tMouseEvents[sKey];
			if (typeof(tMouseEvent.fCallback) == "function") {
				let bCallbackResult = tMouseEvent.fCallback({
					event_name : sEventName,
					value : iValue,
					result : bResult,
				})
				if (typeof(bCallbackResult) == "boolean") {
					bResult = bResult || bCallbackResult;
				}
			} else {
				GameUI.CustomUIConfig().tMouseEvents[sKey] = undefined;
				delete GameUI.CustomUIConfig().tMouseEvents[sKey];
				aKeys.splice(index, 1);
			}
		}

		return bResult
	})
	GameUI.CustomUIConfig().SubscribeMouseEvent = (sName, fCallback, iPriority = 0) => {
		let tMouseEvent = {fCallback: fCallback, iPriority : iPriority}
		GameUI.CustomUIConfig().tMouseEvents[sName] = tMouseEvent;
	}
})()