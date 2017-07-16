function HpButton() {
         GameEvents.SendCustomGameEventToServer( "hp_click", {} );
}
function RegenButton() {
         // 发送数据到Lua请求打开UI
         // 即使没有数据第二个参数也要填
         GameEvents.SendCustomGameEventToServer( "regen_click", {} );
}
function ArmorButton() {
         // 发送数据到Lua请求打开UI
         // 即使没有数据第二个参数也要填
         GameEvents.SendCustomGameEventToServer( "armor_click", {} );
}
(function () {
   $.Schedule(21, function(){$("#UpgradeBG").style.visibility = "visible";});
})();