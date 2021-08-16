import React, { useEffect, useState, useRef, useReducer } from 'react';
import { render, useGameEvent, useNetTableKey } from '@demon673/react-panorama';
import { BuyButton, CommonBalance, CommonMoneyContainer } from '../../elements/Common/Common';
import { GetHeroIDByName, GetHeroKV, Request } from '../../utils/utils';
import { CreateQRCode } from '../../utils/qrcode';
import classNames from 'classnames';
let iShowPaytypeCount = 3;
const tPaytypes = GetPaytypes();
enum ORDER_STATUS {
	ERR_NOT_FOUND = -1,// 单号无效，或参数错误
	ERR_QUERY_FAILED = -2,// 查询失败，需要重新查询
	ERR_UPDATE_FAILED = -3,// 支付成功，但是状态更新失败，需要重新查询 并更新
	ERR_NOTPAY = -4,// 订单未支付
	ERR_CLOSED = -5,// 订单关闭
	ERR_THIRD = -6,// 第三方查询错误，重新查询
	WAIT = 0,// 等待支付
	SUCCESS = 1, // 订单查询成功，并且已支付成功
	EXIST = 2, // 订单已存在，并且已支付成功
}
function PaymentResultToText(status: ORDER_STATUS) {
	switch (status) {
		case ORDER_STATUS.ERR_NOT_FOUND:
			return $.Localize("#Pay_OrderError");
		case ORDER_STATUS.ERR_QUERY_FAILED:
			return $.Localize("#Pay_Waiting");
		case ORDER_STATUS.ERR_UPDATE_FAILED:
			return $.Localize("#Pay_Waiting");
		case ORDER_STATUS.ERR_NOTPAY:
			return $.Localize("#Pay_Waiting");
		case ORDER_STATUS.ERR_CLOSED:
			return $.Localize("#Pay_OrderError");
		case ORDER_STATUS.ERR_THIRD:
			return $.Localize("#Pay_Waiting");
		case ORDER_STATUS.SUCCESS:
			return $.Localize("#Pay_Success");
		case ORDER_STATUS.EXIST:
			return $.Localize("#Pay_Success");
		case ORDER_STATUS.WAIT:
			return $.Localize("#Pay_Waiting");
		default:
			return $.Localize("#Pay_Waiting");
	}
}
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
		<>
			<Panel id="PopupPanel" className="PopupPanel" ref={parent}>
				<Button className="CloseButton" onactivate={() => { $.DispatchEvent("UIPopupButtonClicked", $.GetContextPanel()); }} />
				<Label id="PopupTitle" className="PopupTitle" localizedText={"充值"} />
				<Panel className="PaymentTypeSelection">
					<Panel className="FirstStep">
						<Payment Pay={(data: any) => { setPayType(data); $.Msg(data); }} />
						{/* <Panel className="PayTypeList">
						<GenericPanel type="TabButton" selected="true" group="payment" id="PaymentAlipay" onselect={() => setPayType(1000)} />
						<GenericPanel type="TabButton" group="payment" id="PaymentWeChatPay" onselect={() => setPayType(2000)} />
					</Panel> */}
						<Panel id="PaymentAddition">
							<Button id="Addition_0" className="PaymentAdditionButton" onactivate={() => UpdateTicketsAmount(10)}>
								<Image src="file://{images}/dota_plus/dotaplus_logo_small_png.png" />
								<Label text="10" />
							</Button>
							<Button id="Addition_1" className="PaymentAdditionButton" onactivate={() => UpdateTicketsAmount(30)}>
								<Image src="file://{images}/dota_plus/dotaplus_logo_small_png.png" />
								<Label text="30" />
							</Button>
							<Button id="Addition_2" className="PaymentAdditionButton" onactivate={() => UpdateTicketsAmount(70)}>
								<Image src="file://{images}/dota_plus/dotaplus_logo_small_png.png" />
								<Label text="70" />
							</Button>
							<Button id="Addition_3" className="PaymentAdditionButton" onactivate={() => UpdateTicketsAmount(1000)}>
								<Image src="file://{images}/dota_plus/dotaplus_logo_small_png.png" />
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
						<Image src="file://{images}/dota_plus/dotaplus_logo_small_png.png" />
					</Panel>
					<Panel id="Notice">
						<Label text="充值疑问加QQ:584665414" />
					</Panel>
					<Button id="Pay" onactivate={Pay}>
						<Label text="立即充值" />
					</Button>
				</Panel>

			</Panel>
			<Panel id="ExtraPaymentContainer" >
				<Label id="PopupTitle" className="PopupTitle" localizedText={"选择支付方式"} />
				<Button className="CloseButton" onactivate={() => { pSelf.RemoveClass("ShowExtraPayment"); }} />
				<ExtraPayment Pay={(data: any) => { $.Msg(data); }} />
			</Panel>
		</>
	);
}
// <GenericPanel type="TabButton" selected="true" group="payment" id="PaymentAlipay" onselect={() => setPayType(1000)} />
function Payment({ Pay }: any) {
	return (
		<Panel id="Payment">
			{
				tPaytypes.map((v: string, key: number) => {
					if (key >= iShowPaytypeCount) return;
					return (
						<GenericPanel type="TabButton" group="payment" key={key.toString()} className="Paytype" onactivate={panel => { Pay(v); }}>
							{/* <Button key={key.toString()} className="Paytype" onactivate={panel => { Pay(v); }}> */}
							<Image src={GetPayTypeImg(v)} />
						</GenericPanel>
					);
				})
			}
			<Button id="ExtraPaytype" className="Paytype" onactivate={(self: Button) => { pSelf.AddClass("ShowExtraPayment"); }} onmouseover={(self: Button) => { $.DispatchEvent("DOTAShowTextTooltip", self, "点击选择其他支付方式"); }} onmouseout={(self: Button) => { $.DispatchEvent("DOTAHideTextTooltip", self); }} >
				<Label localizedText="#Pay_ExtraPaytype" />
				<Image id="ExtraPaytypeImage" />
			</Button>
		</Panel>
	);
}
function ExtraPayment({ Pay }: any) {
	return (
		<Panel id="ExtraPayment">
			{
				tPaytypes.map((v: string, key: number) => {
					if (key < iShowPaytypeCount) return;
					return (
						<GenericPanel type="TabButton" group="payment" key={key.toString()} className="Paytype" onactivate={panel => { Pay(v); }}>
							{/* <Button key={key.toString()} className="Paytype" onactivate={panel => { Pay(v); }}> */}
							{/* @ts-ignore */}
							<Image src={GetPayTypeImg(v)} />
						</GenericPanel>
					);
				})
			}
		</Panel>
	);
}
$.GetContextPanel().SetPanelEvent("onload", () => {
	let panel = $.GetContextPanel();
	render(<Popup />, panel);
});