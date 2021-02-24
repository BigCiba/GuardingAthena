import React, { useEffect, useState, useRef, useReducer } from 'react';
import { render, useGameEvent, useNetTableKey } from 'react-panorama';
import { BuyButton, CommonBalance, CommonMoneyContainer } from '../../elements/Common/Common';
import { GetHeroIDByName, GetHeroKV, Request } from '../../utils/utils';
import { CreateQRCode } from '../../utils/qrcode';
import classNames from 'classnames';
function Popup() {
	const parent = useRef<Panel>(null);
	const PaymentTextEntry = useRef<TextEntry>(null);
	const [payType, setPayType] = useState(1000);
	const [price, setPrice] = useState("0");
	const UpdateTicketsAmount = (count: number) => {
		if (count && PaymentTextEntry.current) {
			PaymentTextEntry.current.text = String(count);
			setPrice(String(count / 10));
		}
	};
	const Pay = () => {
		Request("order.create", {
			amount: Number(PaymentTextEntry.current?.text) / 10,
			itemcount: Number(PaymentTextEntry.current?.text),
			paytype: payType,
			pmid: "",
			title: "Dota2守卫雅典娜勋章充值",
			body: "Dota2守卫雅典娜勋章充值"
		}, data => {
			$.Msg(data);
			if (data.status == 1) {

				parent.current?.AddClass("ShowQrcode");
				CreateQRCode(data.data.link, parent.current?.FindChildTraverse("QRCode"), 200);
				// parent.current?.SetDialogVariable("price", String(Number(data.price).toFixed(2)));
				parent.current?.SetDialogVariable("orderid", data.data.order);
			}
		});
		// GameEvents.SendCustomGameEventToServer("RequestPay", {
		// 	istype: payType,
		// 	price: Number(PaymentTextEntry.current?.text) / 10
		// });
	};
	useEffect(() => {
		const show_qrcode = GameEvents.Subscribe("show_qrcode", (data) => {
			parent.current?.AddClass("ShowQrcode");
			CreateQRCode(data.qrcode, parent.current?.FindChildTraverse("QRCode"), 200);
			parent.current?.SetDialogVariable("price", String(Number(data.price).toFixed(2)));
			parent.current?.SetDialogVariable("orderid", data.orderid);
		});
		const payment_complete = GameEvents.Subscribe("payment_complete", (data) => {
			parent.current?.AddClass("Complete");
			$.Schedule(1, function () {
				$.DispatchEvent("UIPopupButtonClicked", $.GetContextPanel());
			});
		});
		const payment_faild = GameEvents.Subscribe("payment_faild", (data) => {
			parent.current?.AddClass("Faild");
			$.Schedule(1, function () {
				$.DispatchEvent("UIPopupButtonClicked", $.GetContextPanel());
			});
		});
		return () => {
			GameEvents.Unsubscribe(show_qrcode);
			GameEvents.Unsubscribe(payment_complete);
			GameEvents.Unsubscribe(payment_faild);
		};
	}, []);
	return (
		<Panel id="PopupPanel" className="PopupPanel" ref={parent}>
			<Button className="CloseButton" onactivate={() => { $.DispatchEvent("UIPopupButtonClicked", $.GetContextPanel()); }} />
			<Label id="PopupTitle" className="PopupTitle" localizedText={"充值"} />
			<Panel className="PaymentTypeSelection">
				<Panel className="FirstStep">
					<Panel className="PayTypeList">
						<GenericPanel type="TabButton" selected="true" group="payment" id="PaymentAlipay" onselect={() => setPayType(1000)} />
						<GenericPanel type="TabButton" group="payment" id="PaymentWeChatPay" onselect={() => setPayType(2000)} />
					</Panel>
					<Panel id="PaymentAddition">
						<Button id="Addition_0" className="PaymentAdditionButton" onactivate={() => UpdateTicketsAmount(10)}>
							<Image src="file://{images}/dotaplus_logo_small.png" />
							<Label text="10" />
						</Button>
						<Button id="Addition_1" className="PaymentAdditionButton" onactivate={() => UpdateTicketsAmount(30)}>
							<Image src="file://{images}/dotaplus_logo_small.png" />
							<Label text="30" />
						</Button>
						<Button id="Addition_2" className="PaymentAdditionButton" onactivate={() => UpdateTicketsAmount(70)}>
							<Image src="file://{images}/dotaplus_logo_small.png" />
							<Label text="70" />
						</Button>
						<Button id="Addition_3" className="PaymentAdditionButton" onactivate={() => UpdateTicketsAmount(1000)}>
							<Image src="file://{images}/dotaplus_logo_small.png" />
							<Label text="1000" />
						</Button>
					</Panel>
					<Panel className="AdjustPanel">
						<TextEntry id="PaymentTextEntry" placeholder="请输入充值金额" ref={PaymentTextEntry} ontextentrychange={(self) => { setPrice(String(Number(self.text) / 10)); }} />
					</Panel>
				</Panel>
				<Panel className="SecondStep">
					<Image id="PaymentIcon" className={classNames({ Alipay: true })} />
					<Label id="RealPrice" localizedText="￥{s:price}" dialogVariables={{ price: price }} />
					<Label id="PaymentNotice" text="如果因为网络原因没有到账请使用补单功能" />
					<Panel className="QRCodeContainer" >
						<Panel id="QRCode" />
						<Panel className="PaymentResultPanel">
							<Label id="PaymentCompleteLabel" className="PaymentResult" text="支付成功" />
							<Label id="PaymentFaildLabel" className="PaymentResult" text="二维码过期" />
						</Panel>
					</Panel>
					<Label id="ShowBrowser" text="二维码无法显示？点击这里" />
					<Label id="OrderID" localizedText="订单：{s:orderid}" />
				</Panel>
				<Panel id="ChargeAmountShow">
					<Label text="1RMB = 10" />
					<Image src="file://{images}/dotaplus_logo_small.png" />
				</Panel>
				<Panel id="Notice">
					<Label text="充值疑问加QQ:584665414" />
				</Panel>
				<Button id="Pay" onactivate={Pay}>
					<Label text="立即充值" />
				</Button>
			</Panel>
		</Panel>
	);
}
$.GetContextPanel().SetPanelEvent("onload", () => {
	let panel = $.GetContextPanel();
	render(<Popup />, panel);
});