function SetupPaymentConfirm() {
	let CostType = $.GetContextPanel().GetAttributeString("CostType", "");
	
	if (CostType == "Shard") {
		let Shard = $.GetContextPanel().GetAttributeInt("Shard", 0);
		$("#ShardCost").SetDialogVariable("shard_cost", Shard);
		$("#EventIcon").AddClass("DotaPlusCurrencyIcon");
	} else {
		let Price = $.GetContextPanel().GetAttributeInt("Price", 0);
		$("#EventIcon").AddClass("DotaPlusPriceCurrencyIcon");
		$("#ShardCost").SetDialogVariable("shard_cost", Price);
	}
	$("#ItemImage").SetImage($.GetContextPanel().GetAttributeString("Image", ""));
}
function Confirm() {
	let CostType = $.GetContextPanel().GetAttributeString("CostType", "");
	let ItemName = $.GetContextPanel().GetAttributeString("ItemName", "0");
	if (CostType == "Shard") {
		let ShardCost = $.GetContextPanel().GetAttributeInt("Shard", 0);
		let Shard = GetPlayerShard(Players.GetLocalPlayer());
		if (Shard >= ShardCost) {
			GameEvents.SendCustomGameEventToServer("PurchaseItem", {
				ItemName: ItemName,
				Currency: "Shard"
			});
		}
	} else {
		let PriceCost = $.GetContextPanel().GetAttributeInt("Price", 0);
		let Price = GetPlayerPrice(Players.GetLocalPlayer());
		if (Price >= PriceCost) {
			GameEvents.SendCustomGameEventToServer("PurchaseItem", {
				ItemName: ItemName,
				Currency: "Price"
			});
		}
	}
}
function OnPurchaseComplete() {
	$.DispatchEvent("UIPopupButtonClicked",$.GetContextPanel());
}
GameEvents.Subscribe("purchase_complete", OnPurchaseComplete);