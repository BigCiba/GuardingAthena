// 显示错误提示
function ShowError(data) {
    $( "#ErrorMsg" ).text = $.Localize(data.text);
    //$( "#DOTAErrorMsg" ).SetHasClass( "ShowErrorMsg", false );
    $( "#DotaErrorMsg" ).RemoveClass("PopOutEffect");
    $( "#DotaErrorMsg" ).RemoveClass("ShowErrorMsg");
    $( "#DotaErrorMsg" ).AddClass("PopOutEffect");
    $( "#DotaErrorMsg" ).AddClass("ShowErrorMsg");
    $.Schedule(1,HideError);
}
function HideError() {
    $( "#DotaErrorMsg" ).RemoveClass("PopOutEffect");
    $( "#DotaErrorMsg" ).RemoveClass("ShowErrorMsg");
}
GameEvents.Subscribe( "show_error", ShowError );