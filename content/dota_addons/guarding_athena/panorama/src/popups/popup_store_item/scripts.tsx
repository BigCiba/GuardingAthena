import React, { useEffect, useState, useRef, useReducer } from 'react';
import { render, useGameEvent, useNetTableKey } from 'react-panorama';
import { Request } from '../../utils/utils';
function Popup() {
	const parent = useRef<Panel>(null)
	const [title, setTitle] = useState($.Localize($.GetContextPanel().GetAttributeString("item_name", "商品")));
	return (
		<Panel id="PopupPanel" ref={parent}>
			<Button className="CloseButton" onactivate={() => { $.DispatchEvent("UIPopupButtonClicked", $.GetContextPanel()); }} />
			<Panel id="Main">
				<Label id="PopupTitle" className="PopupTitle" text={title} />
				<TextButton className="ButtonCancel" text="取消" onactivate={() => { $.DispatchEvent("UIPopupButtonClicked", $.GetContextPanel()); }} />
				<TextButton className="ButtonCommon" text="购买" onactivate={() => {
					let conf = {
						itemid: $.GetContextPanel().GetAttributeInt("ID", 1),
						type: $.GetContextPanel().GetAttributeString("type", "free")
					}
					// $.Msg("[Popup BuyItem] ", conf)
					Request('order.buyitem', conf, data => {
						if (data.code == 1) {
							setTitle("Success");
							//@ts-ignore
							var vSequence = new RunSequentialActions();
							//@ts-ignore
							vSequence.actions.push(new WaitAction(2));
							//@ts-ignore
							vSequence.actions.push(new RunFunctionAction(function () { $.DispatchEvent("UIPopupButtonClicked", $.GetContextPanel()); }));
							//@ts-ignore
							RunSingleAction(vSequence);
							// $.Msg("[Popup BuyItem] Success")
						} else {
							setTitle("Failure");
							//@ts-ignore
							var vSequence = new RunSequentialActions();
							//@ts-ignore
							vSequence.actions.push(new WaitAction(2));
							//@ts-ignore
							vSequence.actions.push(new RunFunctionAction(function () { $.DispatchEvent("UIPopupButtonClicked", $.GetContextPanel()); }));
							//@ts-ignore
							RunSingleAction(vSequence);
							// $.Msg("[Popup BuyItem] Failure")
						}
					})
				}} />
			</Panel>
		</Panel>
	)
}
$.GetContextPanel().SetPanelEvent("onload", () => {
	let panel = $.GetContextPanel();
	render(<Popup />, panel);
})