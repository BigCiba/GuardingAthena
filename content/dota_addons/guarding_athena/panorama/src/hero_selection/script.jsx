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
	const [steamid, setSteamID] = useState(() => Game.GetPlayerInfo(playerID).player_steamid);
	const [level, setLevel] = useState(1);
	const PlayerData = useNetTableKey("service", "player_data")[playerID];
	const [bgImage, setBgImage] = useState("file://{images}/profile_badges/bg_01.psd");
	const [itemImage, setItemImage] = useState("file://{images}/profile_badges/level_01.png");
	const [profileLevel, setProfileLevel] = useState("file://{images}/profile_badges/bg_number_01.psd");
	useEffect(() => {
		setLevel(PlayerData.Level);
		setBgImage(GetBadgesBackground(PlayerData.Level));
		setItemImage(GetBadgesLevel(PlayerData.Level));
		setProfileLevel(GetBadgesBackgroundNumber(PlayerData.Level));
	}, [])
	return (
		<Panel className="PlayerContainer">
			<Panel className="PlayerBackground">
				<Panel onload={(panel) => { panel.BLoadLayoutSnippet("AvatarImage"); panel.GetChild(0).steamid = steamid; }} />
				<Panel onload={(panel) => { panel.BLoadLayoutSnippet("HeroImage"); panel.GetChild(0).steamid = steamid; }} />
				<Panel className="UserInfoContainer">
					<DOTAUserName className="UserName" steamid={steamid} />
					<Panel className="SelectDiffBG">
						<Label localizedText="#GameMode_Hell"></Label>
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
		<GenericPanel className={"DiffButton " + diff} type="TabButton" group="diffGroup" selected={selected} localizedText="#GameMode_Easy" >
			<Image className="DiffIcon" src={"s2r://panorama/images/hero_badges/hero_badge_rank_" + index + "_png.vtex"} />
			<Label localizedText={"#GameMode_" + diff} />
		</GenericPanel>
	)
}
function HeroCard({ heroname, lock }) {
	const [lockState, setLockState] = useState("LockImage");
	// const PlayerData = useNetTableKey("service", "player_data")[Game.GetLocalPlayerID];
	// useEffect(() => {
	// 	for (const key in PlayerData["hero"]) {
	// 		const HeroInfo = PlayerData["hero"][key];
	// 		const HeroName = "npc_dota_hero_" + HeroInfo.ItemName;
	// 		if (HeroName == heroname) {
	// 			setLockState("UnLockImage");
	// 		}
	// 	}
	// }, [])
	return (
		<DOTAHeroMovie className="HeroCard Unlock" >
			<Image className={lockState} src="file://{images}/custom_game/lock.png" heroname={heroname} />
		</DOTAHeroMovie>
	)
}
function HeroSelection() {
	const [serverChecked, setServerChecked] = useState(false);
	const [countdown, setCountdown] = useState(15);
	useGameEvent('server_checked', (info) => {
		//info: {"server_checked":1}
		setServerChecked(true);
	}, []);
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
						<DiffButton index="0" diff="Easy" selected={true} />
						<DiffButton index="1" diff="Common" selected={false} />
						<DiffButton index="2" diff="Hard" selected={false} />
						<DiffButton index="3" diff="Nightmare" selected={false} />
						<DiffButton index="4" diff="Hell" selected={false} />
					</Panel>
				</Panel>
				<Panel className="MainPage">
					<Panel className="TimerContent">
						<Label localizedText="{d:count_time}" />
					</Panel>
					<Panel className="HeroListAndChat">
						<Panel className="HeroList">
							<HeroCard key="3" heroname="npc_dota_hero_axe" lock={true}/>
						</Panel>
						<GenericPanel type="DOTAChat" id="Chat" class="PreGameChat" chatstyle="hudpregame" oncancel="SetInputFocus( HeroGrid )" />
					</Panel>
				</Panel>
			</Panel>
		</>
	);
}
render(<HeroSelection />, pSelf);