"use strict";

var m_BubbleTable = {};
var m_HeightOffsets = {
}

function Bubble(unit) {
	this.unit = unit;
	this.mainPanel = $.CreatePanel('Panel',$.GetContextPanel(),"");
	this.mainPanel.BLoadLayoutSnippet('bubble');
	this.__duration = 5;
	this.__is_stop = true;

	// Create think
	var __run
	var self = this
	__run = function () {
		if(self.__is_stop) return;
		if (Game.Time() - self.__start_time >= self.__duration) return self.stop();
		self.run()
		$.Schedule(0.03,__run);
	}
	this.__run = __run;
}

Bubble.prototype.start = function () {
	if (this.__is_stop === true) {
		this.__is_stop = false;
		this.__start_time = Game.Time();
		this.__run();
	}
}

Bubble.prototype.run = function () {
	var origin = Entities.GetAbsOrigin(this.unit);
	var pos = [Game.WorldToScreenX(origin[0],origin[1],origin[2]),Game.WorldToScreenY(origin[0],origin[1],origin[2])];

	var w = Game.GetScreenWidth();
	var h = Game.GetScreenHeight();
	var main = this.mainPanel;

	if( pos[0] > w || pos[0] < 0 || pos[1] > h || pos[1] < 0 )
		main.visible = false;
	else {
		var maxwidth = (w/h)*1080;
		var midwidth = maxwidth/2;
		var newX = ((pos[0] / w) * maxwidth) - main.actuallayoutwidth / 3;
		var newY = ((pos[1] / h) * 1080) - (m_HeightOffsets[Entities.GetUnitName(this.unit)] || 100) - main.actuallayoutheight;

		if (newX>midwidth) {
			newX += ((newX-midwidth)/midwidth)*125;
		}
		else{
			newX -= ((midwidth-newX)/midwidth)*125;
		}

		if (newY>540) {
			newY -= ((540-newY)/540)*50;
		}
		else{
			newY += ((newY-540)/540)*50;
		}

		var newPos = newX + "px " + newY + "px 0px";
        main.style["position"] = newPos;
		main.visible = true;
	}
}

Bubble.prototype.stop = function () {
	this.__is_stop = true;
	this.mainPanel.visible = false;
}

Bubble.prototype.setText = function (text) {
	this.mainPanel.FindChild('Text').text = $.Localize(text);
}

Bubble.prototype.setDuration = function (duration) {
	if (duration > 0) {
		this.__duration = duration
	}
}

Bubble.prototype.refresh = function () {
	this.__start_time = Game.Time();
}

function DisplayBubble(data) {
	var unit = data.unit || -1;
	if (!unit || unit <= 0) return;

	var text = $.Localize(data.text) || "";
	var duration = data.duration || 5;

	var bubble = m_BubbleTable[unit];
	if (!bubble) {
		bubble = new Bubble(unit);
		m_BubbleTable[unit] = bubble;
	}
	bubble.setText(text);
	bubble.setDuration(duration);
	bubble.refresh();
	bubble.start();
}

function DisplayQuestBubble(data) {
	var text = data.text;
	var localize_text = $.Localize(text);
	if (text == localize_text) {
		switch(data.type)
		{
			case 'accept':
				text = "avalon_quest_default_bubble_accept_text";
				break;
			case 'submit':
				text = "avalon_quest_default_bubble_submit_text";
				break;
			default:
				return;
		}
	}
	data.text = text;
	DisplayBubble(data);
}

;(function(){
	GameUI.DisplayBubble = DisplayBubble;
	GameEvents.Subscribe("avalon_display_bubble",DisplayBubble);
	GameEvents.Subscribe("avalon_display_quest_bubble",DisplayQuestBubble);
})()
