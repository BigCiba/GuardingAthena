function StartMonsterRemaining(data){
	var str = $.Localize("#MonsterRemaining");
	str = str.replace("%wave",data.wave);
	str = str.replace("%count",data.count);
	str = str.replace("%maxcount",data.max_count);
	var MonsterRemainingPanel = $("#EventLabel");
	MonsterRemainingPanel.AddClass("EventListLabelOut");
	MonsterRemainingPanel.text = str;
}
function UpdataRemaining(data){
	var str = $.Localize("#MonsterRemaining");
	str = str.replace("%wave",data.wave);
	str = str.replace("%count",data.count);
	str = str.replace("%maxcount",data.max_count);
	var MonsterRemainingPanel = $("#EventLabel");
	MonsterRemainingPanel.text = str;
	if(data.count == data.max_count){
		$("#EventLabel").RemoveClass("EventListLabelOut");
	}
}
GameEvents.Subscribe( "monster_remaining", StartMonsterRemaining);
GameEvents.Subscribe( "monster_kill", UpdataRemaining);