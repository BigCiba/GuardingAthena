function UpdateTicketsAmount(amount) {
	$("#PaymentTextEntry").text = amount;
}
function Pay() {
	if ($("#PaymentTextEntry").text == "") {
		return;
	}
	let data = {}
	let id = $("#PaymentTypeBody").FindChildTraverse("PaymentAlipay").GetSelectedButton().id;
	if (id == "PaymentAlipay") {
		data.istype = 1;
	} else if (id == "PaymentWeChatPay") {
		data.istype = 2;
	}
	data.price = Number($("#PaymentTextEntry").text) / 10;
	GameEvents.SendCustomGameEventToServer("RequestPay", data);
}
function OnShowQrcode(data) {
	$.Msg(data);
	$("#PaymentTypeSelection").AddClass("ShowQrcode");
	$("#PaymentQrcode").SetURL("https://pay.bearsoftware.net.cn/get_code_image_show_image?url=" + data.qrcode);
	$("#RealPrice").SetDialogVariable("price", String(Number(data.price).toFixed(2)));
	$("#OrderID").SetDialogVariable("orderid", data.orderid);
	if (data.istype == "1") {
		$("#PaymentIcon").AddClass("Alipay");
	} else if (data.istype == "2") {
		$("#PaymentIcon").AddClass("WeChatPay");
	}
}
function OnPaySuccess(data) {
	$.Msg(data);
}
GameEvents.Subscribe("show_qrcode", OnShowQrcode);
GameEvents.Subscribe("pay_success", OnPaySuccess);