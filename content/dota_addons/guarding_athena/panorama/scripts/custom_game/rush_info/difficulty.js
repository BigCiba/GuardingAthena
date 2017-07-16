function UpDataDifficulty(data){
	var difficulty = data.difficulty;
	var difficultyPanel = $("#EventLabel");
	difficultyPanel.style.visibility = "visible";
	if(difficulty == 1){
		difficultyPanel.text = $.Localize("#EasyDifficulty");
	}
	else if(difficulty == 2){
		difficultyPanel.text = $.Localize("#NormalDifficulty");
	}
	else if(difficulty == 3){
		difficultyPanel.text = $.Localize("#HardDifficulty");
	}
	else if(difficulty == 4){
		difficultyPanel.text = $.Localize("#DemonDifficulty");
	}
	else if(difficulty == 5){
		difficultyPanel.text = $.Localize("#TeamDifficulty");
	}
}
GameEvents.Subscribe( "difficulty", UpDataDifficulty);