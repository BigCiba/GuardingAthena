import React, { useState, useRef, useEffect } from 'react';
import { render, useGameEvent, useNetTableKey } from 'react-panorama';

// 预处理禁用官方的选英雄相关功能
var HUD = $.GetContextPanel().GetParent().GetParent().GetParent();
var PreGame = HUD.FindChildTraverse("PreGame");
if (PreGame)
	PreGame.enabled = true;
PreGame.style.opacity = "1";
var HeroPickScreen = PreGame.FindChildTraverse("HeroPickScreen");
if (HeroPickScreen)
	HeroPickScreen.enabled = false;
HeroPickScreen.style.opacity = "0";
var PreMinimapContainer = PreGame.FindChildTraverse("PreMinimapContainer");
if (PreMinimapContainer)
	PreMinimapContainer.enabled = false;
PreMinimapContainer.style.opacity = "0";
var Header = PreGame.FindChildTraverse("Header");
if (Header)
	Header.enabled = false;
Header.style.opacity = "0";
// 
let GameModeSelectionEndTime = 9999;
let pSelf = $.GetContextPanel();
Update();
function Update() {
	// if (Game.GameStateIsAfter(DOTA_GameState.DOTA_GAMERULES_STATE_PRE_GAME)) {
	// 	return;
	// }
	if (GameModeSelectionEndTime != -1) {
		let time = GameModeSelectionEndTime - Game.GetGameTime();
		pSelf.SetDialogVariableInt("count_time", Math.ceil(time));
	}
	$.Schedule(1, Update);
}

function PlayerCard({ playerID }) {
	const [steamid, setSteamID] = useState(Game.GetPlayerInfo(playerID).player_steamid);
	const [level, setLevel] = useState(1);
	const [bgImage, setBgImage] = useState("file://{images}/profile_badges/bg_01.psd");
	const [itemImage, setItemImage] = useState("file://{images}/profile_badges/level_01.png");
	const [profileLevel, setProfileLevel] = useState("file://{images}/profile_badges/bg_number_01.psd");
	const [diff, setDiff] = useState($.Localize("GameMode_Easy"));
	// 玩家数据
	const PlayerData = useNetTableKey("service", "player_data")[playerID];
	useEffect(() => {
		setLevel(PlayerData.Level);
		setBgImage(GetBadgesBackground(PlayerData.Level));
		setItemImage(GetBadgesLevel(PlayerData.Level));
		setProfileLevel(GetBadgesBackgroundNumber(PlayerData.Level));
	}, [PlayerData])
	const selectData = useNetTableKey("player_data", "player_datas");
	useEffect(() => {
		setDiff($.Localize(selectData[0].select_diff));
	}, [selectData])
	return (
		<Panel className="PlayerContainer">
			<Panel className="PlayerBackground">
				<Panel className="AvatarAndHeroContainer" onload={(panel) => { panel.BLoadLayoutSnippet("AvatarImage"); panel.GetChild(0).steamid = steamid; }} />
				<Panel className="UserInfoContainer">
					<DOTAUserName className="UserName" steamid={steamid} />
					<Panel className="SelectDiffBG">
						<Label text={diff} />
					</Panel>
				</Panel>
			</Panel>
			<Panel className="PlayerLevelContent">
				<Image src={bgImage} />
				<Image src={itemImage} />
				<Image src={profileLevel}>
					<Label id="ProfileLevelText" text={level} />
				</Image>
			</Panel>
		</Panel>
	);
}
function DiffButton({ index, diff, selected }) {
	return (
		<GenericPanel
			className={"DiffButton " + diff}
			type="TabButton"
			group="diffGroup"
			selected={selected}
			onactivate={() => { GameEvents.SendCustomGameEventToServer("select_diff", { diff: diff }) }}
		>
			<Image className="DiffIcon" src={"s2r://panorama/images/hero_badges/hero_badge_rank_" + index + "_png.vtex"} />
			<Label localizedText={diff} />
		</GenericPanel>
	)
}
function HeroCard({ heroname, lock, setSelectHero }) {
	const [lockState, setLockState] = useState(lock ? "LockImage" : "UnLockImage");
	// const PlayerData = useNetTableKey("service", "player_data")[Game.GetLocalPlayerID]["hero"];

	// useEffect(() => {
	// }, [])
	return (
		<GenericPanel className="HeroCard Unlock" type="TabButton" group="heroCard" selected={false} onselect={() => setSelectHero(heroname)}>
			<DOTAHeroMovie heroname={heroname} >
				<Image className={lockState} src="file://{images}/custom_game/lock.png" />
			</DOTAHeroMovie>
		</GenericPanel>
	)
}
function HeroSelection() {
	const [serverChecked, setServerChecked] = useState(false);
	const [countdown, setCountdown] = useState(15);
	const [selectHero, setSelectHero] = useState("npc_dota_hero_omniknight");
	const playerData = useNetTableKey("player_data", "player_datas")
	useGameEvent('server_checked', (info) => {
		//info: {"server_checked":1}
		setServerChecked(true);
	}, []);
	// useEffect(() => {
	// 	setSelectHero(playerData[Game.GetLocalPlayerID()].select_hero);
	// }, [playerData])
	const ShowAbilityToolTip = (panel) => {
		$.Msg(panel);
		GameUI.CustomUIConfig().ShowAbilityTooltiop(panel, panel.abilityname);
	}
	const HideAbilityToolTip = (panel) => {
		GameUI.CustomUIConfig().HideAbilityTooltiop(panel)
	}
	return (
		<>
			{/* 背景 */}
			<GenericPanel type="MoviePanel" id="BackgroundImage" className="HeroSelectionBackgroundScene" src="file://{resources}/videos/ti10_aegis_frontpage.webm" repeat="true" autoplay="onload" />
			{/* 等待服务器响应 */}
			<Panel id="Waiting" className={serverChecked ? "ServerChecked" : ""}>
				<Panel id="WaitingContent" hittest={false} >
					<Panel id="WaitingSpinner" hittest={false} />
					<Label id="WaitingText" localizedText="#HeroSelection_Waiting" hittest={false} />
					<TextButton className="ButtonBevel" text="check" onactivate={() => setServerChecked(true)} />
				</Panel>
			</Panel>
			<Panel className="MainSelectionPage">
				<Panel className="SideBar">
					<Panel className="PlayerList">
						{Game.GetAllPlayerIDs().map((playerID) => {
							return <PlayerCard key={"PlayerCard" + playerID.toString()} playerID={playerID} />
						})}
					</Panel>
					<Panel className="DiffList">
						<DiffButton index="0" diff="GameMode_Easy" selected={true} />
						<DiffButton index="1" diff="GameMode_Common" selected={false} />
						<DiffButton index="2" diff="GameMode_Hard" selected={false} />
						<DiffButton index="3" diff="GameMode_Nightmare" selected={false} />
						<DiffButton index="4" diff="GameMode_Hell" selected={false} />
					</Panel>
				</Panel>
				<Panel className="MainPage">
					<Panel className="TimerContent">
						<Label localizedText="{d:count_time}" />
					</Panel>
					<Panel className="HeroListAndChat">
						<Panel className="HeroList">
							{(() => {
								let HeroList = []
								for (const key in GameUI.CustomUIConfig().HeroesKv) {
									const HeroKV = GameUI.CustomUIConfig().HeroesKv[key];
									if (HeroKV.UnitLabel == "hide") {
										continue;
									}
									let HeroName = HeroKV.override_hero;
									HeroList.push(
										<HeroCard key={HeroName} heroname={HeroName} lock={HeroKV.UnitLabel == "lock"} setSelectHero={setSelectHero} />
									);
								}
								return HeroList;
							})()}
						</Panel>
						<GenericPanel type="DOTAChat" id="Chat" class="PreGameChat" chatstyle="hudpregame" oncancel="SetInputFocus( HeroGrid )" />
					</Panel>
					<Panel className="HeroInfoContainer">
						<Panel className="HeroName">
							<Image src="s2r://panorama/images/primary_attribute_icons/primary_attribute_icon_strength_psd.vtex" />
							<Label key={selectHero} localizedText={selectHero} />
						</Panel>
						<Panel className="HeroAbilityList">
							<DOTAAbilityImage className="HeroAbility" abilityname={GameUI.CustomUIConfig().HeroesKv[selectHero].Ability1} onmouseover={ShowAbilityToolTip} onmouseout={HideAbilityToolTip} />
							<DOTAAbilityImage className="HeroAbility" abilityname={GameUI.CustomUIConfig().HeroesKv[selectHero].Ability2} onmouseover={ShowAbilityToolTip} onmouseout={HideAbilityToolTip} />
							<DOTAAbilityImage className="HeroAbility" abilityname={GameUI.CustomUIConfig().HeroesKv[selectHero].Ability3} onmouseover={ShowAbilityToolTip} onmouseout={HideAbilityToolTip} />
							<DOTAAbilityImage className="HeroAbility" abilityname={GameUI.CustomUIConfig().HeroesKv[selectHero].Ability4} onmouseover={ShowAbilityToolTip} onmouseout={HideAbilityToolTip} />
							<DOTAAbilityImage className="HeroAbility" abilityname={GameUI.CustomUIConfig().HeroesKv[selectHero].Ability5} onmouseover={ShowAbilityToolTip} onmouseout={HideAbilityToolTip} />
						</Panel>
						<TextButton className="HeroSelectButton" localizedText="#SelectHero" />
					</Panel>
					<Panel className="HeroScenePanel" hittest={false}>
						<GenericPanel
							key={selectHero}
							type="DOTAScenePanel"
							hittest={false}
							className="HeroScene"
							unit={selectHero}
							light="global_light"
							antialias="true"
							drawbackground="false"
							rotateonhover="true"
							yawmin="-180"
							yawmax="180"
							particleonly={false}
							activity-modifier="PostGameIdle"
						/>
					</Panel>
				</Panel>
			</Panel>
		</>
	);
}
render(<HeroSelection />, pSelf);