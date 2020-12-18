import React, { useEffect, useState, useRef, useReducer } from 'react';
import { render, useGameEvent, useNetTableKey } from 'react-panorama';
import { GetHeroIDByName, Request } from '../../utils/utils';
function Popup({ itemData }: { itemData: any }) {
	const parent = useRef<Panel>(null)
	const [title, setTitle] = useState($.Localize($.GetContextPanel().GetAttributeString("item_name", "商品")));
	return (
		<Panel id="PopupPanel" className="PopupPanel" ref={parent}>
			<Button className="CloseButton" onactivate={() => { $.DispatchEvent("UIPopupButtonClicked", $.GetContextPanel()); }} />
			<Label id="PopupTitle" className="PopupTitle" text={title} />
			<Panel className="StoreItemDetail">
				<HeroItemDetail heroName={itemData.ItemName} />
			</Panel>
			{/* 按钮 */}
			<Panel className="PopupButtonRow">
				<TextButton className="PopupButton" text="取消" onactivate={() => { $.DispatchEvent("UIPopupButtonClicked", $.GetContextPanel()); }} />
				<TextButton className="PopupButton" text="购买" onactivate={() => {
					let conf = {
						itemid: $.GetContextPanel().GetAttributeInt("ID", 1),
						type: $.GetContextPanel().GetAttributeString("type", "free")
					}
					Request('order.buyitem', conf, data => {
						if (data.code == 1) {
							// $.Msg("[Popup BuyItem] Success")
						} else {
							// $.Msg("[Popup BuyItem] Failure")
						}
					})
				}} />
			</Panel>
		</Panel>
	)
}
function HeroItemDetail({ heroName }: { heroName: string }) {
	const heroScene = useRef<ScenePanel>(null);
	const heroData = GameUI.CustomUIConfig().HeroesKv["npc_dota_hero_" + heroName];
	$.Msg(heroData.AttributeStrengthGain)
	useEffect(() => {
		heroScene.current?.SetScenePanelToLocalHero(GetHeroIDByName("npc_dota_hero_" + heroName));
	}, []);
	return (
		<Panel className="Full">
			<DOTAScenePanel
				unit={"npc_dota_hero_" + heroName}
				className="PopupHeroScene"
				light="global_light"
				antialias={true}
				drawbackground={false}
				particleonly={false}
				ref={heroScene}
			/>
			<Panel className="AbilityList">
				<DOTAAbilityImage abilityname={heroData.Ability1} showtooltip={true} />
				<DOTAAbilityImage abilityname={heroData.Ability2} showtooltip={true} />
				<DOTAAbilityImage abilityname={heroData.Ability3} showtooltip={true} />
				<DOTAAbilityImage abilityname={heroData.Ability4} showtooltip={true} />
				<DOTAAbilityImage abilityname={heroData.Ability5} showtooltip={true} />
			</Panel>
			<Panel className="HeroStatsSection" onmouseover={(self) => { $.DispatchEvent("DOTAShowAttributesHelpTooltip", self) }} onmouseout={(self) => { $.DispatchEvent("DOTAHideAttributesHelpTooltip", self) }}>
				<Label className="HeroStatsHeader" text="#DOTA_HeroStats_Castegory_Attributes" />
				<Panel className="HeroStatsRow">
					<Panel className="HeroStatsIcon StrengthIcon" />
					<Label className="MonoNumbersFont" localizedText="DOTA_HeroLoadout_StrengthAttribute" dialogVariables={{ "base_str": heroData.AttributeBaseStrength, "str_per_level": heroData.AttributeStrengthGain }} />
				</Panel>
				<Panel className="HeroStatsRow">
					<Panel className="HeroStatsIcon AgilityIcon" />
					<Label className="MonoNumbersFont" text="#DOTA_HeroLoadout_AgilityAttribute" />
				</Panel>
				<Panel className="HeroStatsRow">
					<Panel className="HeroStatsIcon IntelligenceIcon" />
					<Label className="MonoNumbersFont" text="#DOTA_HeroLoadout_IntelligenceAttribute" />
				</Panel>
			</Panel>
		</Panel>
	)
}
$.GetContextPanel().SetPanelEvent("onload", () => {
	let panel = $.GetContextPanel();
	let itemData = JSON.parse($.GetContextPanel().GetAttributeString("itemData", "{}"));
	render(<Popup itemData={itemData} />, panel);
})