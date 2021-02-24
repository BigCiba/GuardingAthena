import React, { useEffect, useState, useRef, useReducer } from 'react';
import { render, useGameEvent, useNetTableKey } from 'react-panorama';
import { BuyButton, CommonBalance, CommonMoneyContainer } from '../../elements/Common/Common';
import { GetHeroIDByName, GetHeroKV, Request } from '../../utils/utils';
function Popup({ itemData, hasItem }: { itemData: any; hasItem: boolean; }) {
	const parent = useRef<Panel>(null);
	const ItemName = itemData.Type == "hero" ? "npc_dota_hero_" + itemData.ItemName : itemData.ItemName;
	return (
		<Panel id="PopupPanel" className="PopupPanel" ref={parent}>
			<Button className="CloseButton" onactivate={() => { $.DispatchEvent("UIPopupButtonClicked", $.GetContextPanel()); }} />
			<Label id="PopupTitle" className="PopupTitle" localizedText={ItemName} />
			<Panel className="StoreItemDetail">
				{itemData.Type == "hero" &&
					<HeroItemDetail heroName={itemData.ItemName} />
				}
				{itemData.Type == "pet" &&
					<PetItemDetail petName={itemData.ItemName} />
				}
				{(itemData.Type == "skin" || itemData.Type == "particle") &&
					<ParticleItemDetail itemData={itemData} />
				}
				{itemData.Type == "gameplay" &&
					<CommonItemDetail itemData={itemData} />
				}
			</Panel>
			<Panel className="MoneyContainer">
				<Panel className="RechargeContainer">
					<CommonBalance type={Number(itemData.Shard) > 0 ? "Shard" : "Price"} count={Number(itemData.Shard) > 0 ? Number(itemData.Shard) : Number(itemData.Price)} />
				</Panel>
			</Panel>
			{/* 按钮 */}
			<Panel className="PopupButtonRow">
				{(!hasItem && itemData.Shard > 0) &&
					<BuyButton type="Shard" count={itemData.Shard} id={itemData.ID} itemName={itemData.ItemName} />
				}
				{(!hasItem && itemData.Price > 0) &&
					<BuyButton type="Price" count={itemData.Price} id={itemData.ID} itemName={itemData.ItemName} />
				}
				{hasItem &&
					<TextButton localizedText="HasItem" className="DotaPlusPurchaseButton" />
				}
			</Panel>
			{/* 通知界面 */}
			<Panel className="PopusNotify">
				<Image />
			</Panel>
		</Panel>
	);
}
// 英雄商品界面
function HeroItemDetail({ heroName }: { heroName: string; }) {
	const heroScene = useRef<ScenePanel>(null);
	const fullName = "npc_dota_hero_" + heroName;
	const heroData = GameUI.CustomUIConfig().HeroesKv[fullName];
	useEffect(() => {
		heroScene.current?.SetScenePanelToLocalHero(GetHeroIDByName(fullName));
	}, []);
	return (
		<Panel className="Full">
			<DOTAScenePanel
				unit={fullName}
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
			<Panel className="AttributeContainer">
				<Panel className="TopContainer">
					<Panel className="HeroStatsSection" >
						<Label className="HeroStatsHeader" text="#DOTA_HeroStats_Castegory_HealthMana" />
						<Panel id="HealthRow" className="HeroResourceRow">
							<Label className="MaxResource MonoNumbersFont" localizedText="{d:max_health}" dialogVariables={{ max_health: heroData.AttributeBaseStrength * 20 + GetHeroKV(fullName, "StatusHealth") }} />
							<Label className="ResourceRegen MonoNumbersFont" localizedText="+{s:health_regen}" dialogVariables={{ health_regen: (heroData.AttributeBaseStrength * 0.09 + GetHeroKV(fullName, "StatusHealthRegen")).toFixed(1) }} />
						</Panel>
						<Panel id="ManaRow" className="HeroResourceRow">
							<Label className="MaxResource MonoNumbersFont" localizedText="{d:max_mana}" dialogVariables={{ max_mana: heroData.AttributeBaseIntelligence * 12 + GetHeroKV(fullName, "StatusMana") }} />
							<Label className="ResourceRegen MonoNumbersFont" localizedText="+{s:mana_regen}" dialogVariables={{ mana_regen: (heroData.AttributeBaseIntelligence * 0.05 + GetHeroKV(fullName, "StatusManaRegen")).toFixed(1) }} />
						</Panel>
					</Panel>
				</Panel>
				<Panel className="TopContainer">
					<Panel className="HeroStatsSection" >
						<Label className="HeroStatsHeader" text="#DOTA_HeroStats_Castegory_Attributes" />
						<Panel className="HeroStatsRow">
							<Panel className="HeroStatsIcon StrengthIcon" />
							<Label className="MonoNumbersFont" localizedText="DOTA_HeroLoadout_StrengthAttribute" dialogVariables={{ base_str: String(heroData.AttributeBaseStrength), str_per_level: String(heroData.AttributeStrengthGain) }} />
						</Panel>
						<Panel className="HeroStatsRow">
							<Panel className="HeroStatsIcon AgilityIcon" />
							<Label className="MonoNumbersFont" localizedText="DOTA_HeroLoadout_AgilityAttribute" dialogVariables={{ base_agi: String(heroData.AttributeBaseAgility), agi_per_level: String(heroData.AttributeAgilityGain) }} />
						</Panel>
						<Panel className="HeroStatsRow">
							<Panel className="HeroStatsIcon IntelligenceIcon" />
							<Label className="MonoNumbersFont" localizedText="DOTA_HeroLoadout_IntelligenceAttribute" dialogVariables={{ base_int: String(heroData.AttributeBaseIntelligence), int_per_level: String(heroData.AttributeIntelligenceGain) }} />
						</Panel>
					</Panel>
				</Panel>
				<Panel className="TopContainer">
					<Panel className="HeroStatsSection" >
						<Label className="HeroStatsHeader" text="#DOTA_HeroStats_Castegory_Attack" />
						<Panel className="HeroStatsRow">
							<Panel className="HeroStatsIcon DamageIcon" />
							<Label className="MonoNumbersFont" localizedText="{d:damage_min} - {d:damage_max}" dialogVariables={{ damage_min: heroData.AttackDamageMin, damage_max: heroData.AttackDamageMax }} />
						</Panel>
						<Panel className="HeroStatsRow">
							<Panel className="HeroStatsIcon BaseAttackTimeIcon" />
							<Label className="MonoNumbersFont" localizedText="{s:attack_rate}" dialogVariables={{ attack_rate: String(heroData.AttackRate) }} />
						</Panel>
						<Panel className="HeroStatsRow">
							<Panel className="HeroStatsIcon AttackRangeIcon" />
							<Label className="MonoNumbersFont" localizedText="{d:attack_range}" dialogVariables={{ attack_range: heroData.AttackRange }} />
						</Panel>
						{(heroData.ProjectileSpeed && heroData.ProjectileSpeed > 0) &&
							<Panel id="ProjectileSpeedRow" className="HeroStatsRow">
								<Panel className="HeroStatsIcon ProjectileSpeedIcon" />
								<Label className="MonoNumbersFont" localizedText="{d:projectile_speed}" dialogVariables={{ projectile_speed: heroData.ProjectileSpeed }} />
							</Panel>
						}
					</Panel>
					<Panel className="HeroStatsSection" >
						<Label className="HeroStatsHeader" text="#DOTA_HeroStats_Castegory_Defense" />
						<Panel className="HeroStatsRow">
							<Panel className="HeroStatsIcon ArmorIcon" />
							<Label className="MonoNumbersFont" localizedText="{s:armor}" dialogVariables={{ armor: String(heroData.ArmorPhysical) }} />
						</Panel>
						<Panel className="HeroStatsRow">
							<Panel className="HeroStatsIcon MagicResistIcon" />
							<Label className="MonoNumbersFont" localizedText="{d:magic_resistance}%" dialogVariables={{ magic_resistance: heroData.MagicalResistance }} />
						</Panel>
					</Panel>
					<Panel className="HeroStatsSection" >
						<Label className="HeroStatsHeader" text="#DOTA_HeroStats_Castegory_Mobility" />
						<Panel className="HeroStatsRow">
							<Panel className="HeroStatsIcon MovementSpeedIcon" />
							<Label className="MonoNumbersFont" localizedText="{d:movement_speed}" dialogVariables={{ movement_speed: heroData.MovementSpeed }} />
						</Panel>
						<Panel className="HeroStatsRow">
							<Panel className="HeroStatsIcon TurnRateIcon" />
							<Label className="MonoNumbersFont" localizedText="{s:turn_rate}" dialogVariables={{ turn_rate: String(heroData.MovementTurnRate) }} />
						</Panel>
					</Panel>
				</Panel>
			</Panel>
		</Panel>
	);
}
// 宠物商品界面
function PetItemDetail({ petName }: { petName: string; }) {
	const SetPreview = useRef<Panel>(null);
	const petData = GameUI.CustomUIConfig().PetsKv[petName];
	useEffect(() => {
		if (SetPreview.current) {
			$.DispatchEvent("DOTAEconSetPreviewSetRotationSpeed", SetPreview.current, 0);
			$.DispatchEventAsync(2, "DOTAEconSetPreviewSetRotationSpeed", SetPreview.current, 2);
		}
	}, []);
	return (
		<Panel className="Full" >
			<Panel id="SetPreview">
				<GenericPanel type="DOTAUIEconSetPreview" itemdef={GameUI.CustomUIConfig().PetsKv[petName].ItemDef} itemstyle={GameUI.CustomUIConfig().PetsKv[petName].ItemStyle || 0} displaymode="loadout_small" drawbackground={true} antialias={true} ref={SetPreview} />
			</Panel>
			<Panel className="PetAbilityList">
				{(() => {
					let list = [];
					for (let index = 1; index < 16; index++) {
						const abilityName = petData["Ability" + index];
						if (abilityName) {
							list.push(
								<DOTAAbilityImage key={abilityName} abilityname={abilityName} showtooltip={true} />
							);
						}
					}
					return list;
				})()}
			</Panel>
		</Panel>
	);
}
// 特效商品界面
function ParticleItemDetail({ itemData }: { itemData: any; }) {
	return (
		<Panel className="Full" >
			<Panel className="MoviePanel">
				<GenericPanel type="MoviePanel" id="ParticleViewContainer" key={itemData.ItemName} src={"file://{resources}/videos/" + itemData.Type + "/" + itemData.ItemName + ".webm"} repeat={true} autoplay="onload" />
				<Label localizedText="特效预览" />
			</Panel>
			<Panel className="ParticleItemDescription">
				<Label localizedText={itemData.ItemName + "_Description"} />
			</Panel>
		</Panel>
	);
}
// 通用商品界面
function CommonItemDetail({ itemData }: { itemData: any; }) {
	return (
		<Panel className="Full" >
			<Panel id="ItemImageContainer">
				<Image id="ItemImage" scaling="stretch-to-fit-preserve-aspect" src={"file://{images}/custom_game/" + itemData.Type + "/" + itemData.ItemName + ".png"} />
			</Panel>
			<Panel className="CommonItemDescription">
				<Label localizedText={itemData.ItemName + "_Description"} />
			</Panel>
		</Panel>
	);
}
$.GetContextPanel().SetPanelEvent("onload", () => {
	let panel = $.GetContextPanel();
	let itemData = JSON.parse($.GetContextPanel().GetAttributeString("itemData", "{}"));
	let hasItem = $.GetContextPanel().GetAttributeString("hasItem", "0") == "1" ? true : false;
	render(<Popup itemData={itemData} hasItem={hasItem} />, panel);
});