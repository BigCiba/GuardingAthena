if GuardingAthena == nil then
	GuardingAthena = {}
end
local public = GuardingAthena

gamestates =
{
	[0] = "DOTA_GAMERULES_STATE_INIT",
	[1] = "DOTA_GAMERULES_STATE_WAIT_FOR_PLAYERS_TO_LOAD",
	[2] = "DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP",
	[3] = "DOTA_GAMERULES_STATE_HERO_SELECTION",
	[4] = "DOTA_GAMERULES_STATE_STRATEGY_TIME",
	[5] = "DOTA_GAMERULES_STATE_TEAM_SHOWCASE",
	[6] = "DOTA_GAMERULES_STATE_PRE_GAME",
	[7] = "DOTA_GAMERULES_STATE_GAME_IN_PROGRESS",
	[8] = "DOTA_GAMERULES_STATE_POST_GAME",
	[9] = "DOTA_GAMERULES_STATE_DISCONNECT"
}
-- function public:init(bReload)
function GuardingAthena:InitGameMode()
	--print('[GuardingAthena] Starting to load GuardingAthena gamemode...')
	_G.Activated = true

	_G.ATTACK_EVENTS_DUMMY = CreateModifierThinker(nil, nil, "modifier_events", nil, Vector(0,0,0), DOTA_TEAM_NOTEAM, false)

	-- 初始化游戏参数
	self.entAthena = Entities:FindByName( nil, "athena" )				--寻找基地
	self.athena_hp_lv = 0
	self.athena_regen_lv = 0
	self.athena_armor_lv = 0
	self.sandking = 0
	self.athena_reborn = true
	self.final_boss = nil
	self.player_gold_save = {0,0,0,0}
	self.clotho_lv = 1
	self.iapetos = nil
	self.athena_momian = 0
	self.athena_wudi = 0
	self.player_count = 0
	self.SelectedHeroName = {}
	self.ToggleFly = {}
	self.ToggleGold = {}
	self.SelectDifficulty = {}
	self.DifficultySelected = false
	self.Players = {}
	self.GameStartTime = 0
	self.is_cheat = false
	self.timeStamp = nil
	self.randomStr = nil
	self.signature = nil
	self.tPlayerSelectionInfo = {}
	self.GameModeSelectionEndTime = -1

	if not self.entAthena then
		--print( "Athena entity not found!" )
	end

	if IsInToolsMode() then
		GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("collectgarbage"), function()
			local m = collectgarbage('count')
			print(string.format("[Lua Memory]  %.3f KB  %.3f MB", m, m/1024))
			return 20
		end, 0)
	end

	-- 初始化游戏参数
    self:ReadGameConfiguration()
    
	--GameMode:SetAbilityTuningValueFilter( Dynamic_Wrap( GuardingAthena, "AbilityTuningValueFilter" ), self )

	--监听事件
	ListenToGameEvent('entity_killed', Dynamic_Wrap(GuardingAthena, 'OnEntityKilled'), self)
	ListenToGameEvent('player_connect_full', Dynamic_Wrap(GuardingAthena, 'OnConnectFull'), self)
	ListenToGameEvent('npc_spawned', Dynamic_Wrap(GuardingAthena, 'OnNPCSpawned'), self)
	ListenToGameEvent('dota_player_pick_hero', Dynamic_Wrap(GuardingAthena, 'OnPlayerPickHero'), self)
	ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(GuardingAthena, 'OnGameRulesStateChange'), self)
	ListenToGameEvent('player_chat', Dynamic_Wrap(GuardingAthena, 'OnPlayerChat'), self)
	ListenToGameEvent('dota_player_gained_level', Dynamic_Wrap(GuardingAthena, 'OnPlayerLevelUp'), self)
	ListenToGameEvent('dota_player_used_ability', Dynamic_Wrap(GuardingAthena, 'OnUsedAbility'), self )
	ListenToGameEvent('dota_item_purchased', Dynamic_Wrap(GuardingAthena, 'OnItemPurchased'), self )
	ListenToGameEvent('custom_npc_first_spawned', Dynamic_Wrap(GuardingAthena, 'OnNPCFirstSpawned'), self )

	GameRules:GetGameModeEntity():SetThink("DetectCheatsThinker")
	-- GameEvent("custom_npc_first_spawned", Dynamic_Wrap(self, "OnNPCFirstSpawned"), self)

	--自定义控制台命令
	Convars:RegisterCommand( "-testmode", function(...) return self:TestMode( ... ) end, "Test Mode.", FCVAR_CHEAT )

	CustomGameEventManager:RegisterListener( "hg_click", OnHgClick )
	CustomGameEventManager:RegisterListener( "hp_click", OnHpClick )
	CustomGameEventManager:RegisterListener( "regen_click", OnRegenClick )
	CustomGameEventManager:RegisterListener( "armor_click", OnArmorClick )
	CustomGameEventManager:RegisterListener( "gift_potion", OnGiftPotion )
	CustomGameEventManager:RegisterListener( "gold_gift", OnGoldGift )
	CustomGameEventManager:RegisterListener( "selection_hero_click", OnSelectClick )
	CustomGameEventManager:RegisterListener( "selection_hero_hover", OnSelectHover )
	CustomGameEventManager:RegisterListener( "selection_difficulty_click", OnSelectDifficultyClick )
	CustomGameEventManager:RegisterListener( "hero_selected", HeroSelected )
	CustomGameEventManager:RegisterListener( "vip_particle", OnVipParticle )
	CustomGameEventManager:RegisterListener( "UI_BuyItem", UI_BuyItem )
	CustomGameEventManager:RegisterListener( "UI_BuyReward", UI_BuyReward )
	CustomGameEventManager:RegisterListener( "Trial", CreateTrial )

	CustomUIEvent("hero_seletion", Dynamic_Wrap(public, "HeroSelectionEvent"), public)
	CustomUIEvent("difficulty_seletion", Dynamic_Wrap(public, "DifficultySelectionEvent"), public)
end
--读取游戏配置
function GuardingAthena:ReadGameConfiguration()
	print("[GuardingAthena] Read Game Configuration")
	Entities:FindByName( nil, "practice_1" ).onthink = false
	Entities:FindByName( nil, "practice_2" ).onthink = false
	Entities:FindByName( nil, "practice_3" ).onthink = false
	Entities:FindByName( nil, "practice_4" ).onthink = false
	self.creatCourier = 0
	-- 商店
	local shopInfo = LoadKeyValues("scripts/kv/shop.kv")
	local costInfo = LoadKeyValues("scripts/npc/npc_items_custom.txt")
	local shopTable = {}
	local costTable = {}
	local refreshTable = {}
	local canBuyTable = {}
	for k,v in pairs(shopInfo) do
		shopTable[k] = {}
		local length = 0
		for k in pairs(v) do
			length = length + 1
		end
		for i=1,length do
			table.insert(shopTable[k], v["item"..i])
		end
	end
	for k,v in pairs(shopTable) do
		CustomNetTables:SetTableValue( "shop", k, v )
	end
	for k,v in pairs(costInfo) do
		if type(v) ~= "number" then
			costTable[k] = {}
			costTable[k] = v.ItemCost or 0
		end
	end
	for k,v in pairs(costInfo) do
		if type(v) ~= "number" then
			refreshTable[k] = {}
			refreshTable[k] = v.ItemStockTime or 0
		end
	end
	for k,v in pairs(costInfo) do
		if type(v) ~= "number" then
			canBuyTable[k] = {}
			canBuyTable[k] = true
		end
	end
	CustomNetTables:SetTableValue( "shop", "cost", costTable )
	CustomNetTables:SetTableValue( "shop", "refresh", refreshTable )
	CustomNetTables:SetTableValue( "shop", "can_buy", canBuyTable )
end

-- The overall game state has changed
function GuardingAthena:OnGameRulesStateChange(keys)
	local newState = GameRules:State_Get()

	--print("[GuardingAthena] GameRules State Changed: ",gamestates[newState])

	if newState == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		for k,v in pairs(self.Players) do
			CustomNetTables:SetTableValue( "player_hero", tostring(k), {heroname="npc_dota_hero_omniknight"} )
			--CustomNetTables:SetTableValue( "scoreboard", tostring(k), { lv=1, str=0, agi=0, int=0, wavedef=0, damagesave=0, goldsave=0 } )
			CustomNetTables:SetTableValue( "difficulty", tostring(k), {difficulty="NoSelect"} )
		end
	
		--初始化英雄数据
		HeroState:Init()
		Quest:Init()
		--Attributes:Init()
	end
	
	--选择英雄阶段
	if newState == DOTA_GAMERULES_STATE_HERO_SELECTION then
		self.GameModeSelectionEndTime = GameRules:GetGameTime() + HERO_SELECTION_TIME
		self:UpdateNetTables()
		local tRandomHero = {}
		for sHeroName, v in pairs(KeyValues.HeroesKv) do
			if v.UnitLabel ~= "lock" then
				table.insert(tRandomHero, sHeroName)
			end
		end
		GuardingAthena:EachPlayer(function(iNth, iPlayerID)
			self.tPlayerSelectionInfo[iPlayerID] = {
				-- player_selected_hero = TableFindKey(KeyValues.HeroesKv, RandomValue(KeyValues.HeroesKv)),
				player_selected_hero = tRandomHero[RandomInt(1, #tRandomHero)],
				player_selected_difficulty = nil
			}
		end)
	end
	--策略阶段
	if newState == DOTA_GAMERULES_STATE_STRATEGY_TIME then
		local tVoteList = {0,0,0,0,0}
		-- 选择英雄
		GuardingAthena:EachPlayer(function(iNth, iPlayerID)
			local hPlayer = PlayerResource:GetPlayer(iPlayerID)
			if IsValid(hPlayer) then
				hPlayer:SetSelectedHero(self.tPlayerSelectionInfo[iPlayerID].player_selected_hero)
				-- 计算难度
				local iDifficulty = self.tPlayerSelectionInfo[iPlayerID].player_selected_difficulty
				if iDifficulty then
					tVoteList[tonumber(iDifficulty)] = tVoteList[tonumber(iDifficulty)] and tVoteList[tonumber(iDifficulty)] + 1 or 1
				end
				CustomNetTables:SetTableValue( "scoreboard", tostring(iPlayerID), { lv=1, str=0, agi=0, int=0, wavedef=0, damagesave=0, goldsave=0 } )
				CustomNetTables:SetTableValue( "shop", tostring(iPlayerID), { def_point=0, boss_point=0, practice_point=0})
				Service:RequestUpDataEquip(iPlayerID)
			end
		end)
		local iDifficulty,_ = table.max(tVoteList)
		CustomGameEventManager:Send_ServerToAllClients("difficulty", {difficulty=iDifficulty})
		GameRules:SetCustomGameDifficulty(iDifficulty)
		GameRules:SetGoldPerTick(DIFFICULTY_GOLD_TICK[iDifficulty])
		GameRules:GetGameModeEntity():SetFixedRespawnTime(DIFFICULTY_RESPAWN_TIME[iDifficulty])
		GameRules:SetStartingGold(DIFFICULTY_INIT_GOLD[iDifficulty])
		Spawner:Init()
		updateScore(function ()
		end)
	end

	--游戏在准备阶段
	if newState == DOTA_GAMERULES_STATE_PRE_GAME then
	end

	if newState == DOTA_GAMERULES_STATE_STRATEGY_TIME then
		--CustomUI:DynamicHud_Create(-1,"HgButton","file://{resources}/layout/custom_game/hg_button.xml",nil)
		--CustomUI:DynamicHud_Create(-1,"athena","file://{resources}/layout/custom_game/athena_up.xml",nil)
	end

	--游戏开始
	if newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then 
		if self.testmode then
			return
		end
		-- 开始刷怪
		Spawner:AutoSpawn()
		Spawner:NatureStart()
		-- 定时清除地上物品
		Timers:CreateTimer(function()
			local items = Entities:FindAllByClassname("dota_item_drop") 
			for _,item in pairs(items) do
				if item.shouldCollect then
					item:SetAbsOrigin(Vector(5000,5000,-200))
					item:GetContainedItem():RemoveSelf()
					UTIL_Remove(item) 
				else
					item.shouldCollect = true
				end
			end
			return 120
		end)
		-- 定时兑换金钱
		Timers:CreateTimer(function()
			local Players = PlayerResource:GetPlayerCountForTeam( DOTA_TEAM_GOODGUYS )
			for i=1,Players do
				local playerid = i - 1 
				local playerGold = PlayerResource:GetGold(playerid)
				if playerGold > 95000 then
					local goldSave = playerGold - 95000
					self.player_gold_save[i] = self.player_gold_save[i] + goldSave
					PlayerResource:SpendGold( playerid, goldSave, 0 )
				end
				if playerGold < 95000 then
					local goldSaveSpend = 95000 - playerGold
					local goldSave = self.player_gold_save[i]
					if goldSave >= goldSaveSpend then
						PlayerResource:ModifyGold( playerid, goldSaveSpend, true, 0)
						self.player_gold_save[i] = self.player_gold_save[i] - goldSaveSpend
					else
						PlayerResource:ModifyGold( playerid, goldSave, true, 0)
						self.player_gold_save[i] = self.player_gold_save[i] - goldSave
					end
				end
			end
			return 1
		end)
	end
end
function GuardingAthena:UpdateNetTables()
	local gameModeInfo = {
		game_mode_selection_end_time = self.GameModeSelectionEndTime,
	}
	CustomNetTables:SetTableValue("common", "game_mode_info", gameModeInfo)
end
function GuardingAthena:OnItemPurchased(t)
	--[[
		game_event_name	dota_item_purchased
		itemname	item_salve1
		game_event_listener	1736441865
		PlayerID	0
		itemcost	50
		splitscreenplayer	-1
	]]
	local iSaveGold = self.player_gold_save[t.PlayerID + 1]
	if iSaveGold > t.itemcost then
		PlayerResource:ModifyGold( t.PlayerID, t.itemcost, true, 0)
		self.player_gold_save[t.PlayerID + 1] = iSaveGold - t.itemcost
	end
end
--自定义控制台命令
function GuardingAthena:TestMode( cmdName, goldToDrop )
	--print("[GuardingAthena] Test Mode")
end

function GuardingAthena:GetPlayerLevel(iScore)
	return math.floor( iScore / PLAYER_XP_PER_LEVEL )
end

function public:HeroSelectionEvent(eventSourceIndex, events)
	local iPlayerID = events.PlayerID
	local sHeroName = events.HeroName
	local tPlayerInfo = self.tPlayerSelectionInfo[iPlayerID]
	local bUnlock = Service:CheckHeroUnlock(iPlayerID, sHeroName)
	if bUnlock then
		tPlayerInfo.player_selected_hero = sHeroName
	end
end
function public:DifficultySelectionEvent(eventSourceIndex, events)
	local iPlayerID = events.PlayerID
	local iDifficulty = events.Difficulty
	local tPlayerInfo = self.tPlayerSelectionInfo[iPlayerID]
	tPlayerInfo.player_selected_difficulty = iDifficulty
end
function public:EachPlayer(iTeamNumber, func)
	if type(iTeamNumber) == "function" then
		func = iTeamNumber
		for iTeamNumber = DOTA_TEAM_FIRST, DOTA_TEAM_CUSTOM_MAX, 1 do
			for n = 1, PlayerResource:GetPlayerCountForTeam(iTeamNumber), 1 do
				local playerID = PlayerResource:GetNthPlayerIDOnTeam(iTeamNumber, n)
				if PlayerResource:IsValidPlayerID(playerID) then
					if func(n, playerID) == true then
						break
					end
				end
			end
		end
	else
		for n = 1, PlayerResource:GetPlayerCountForTeam(iTeamNumber), 1 do
			local playerID = PlayerResource:GetNthPlayerIDOnTeam(iTeamNumber, n)
			if PlayerResource:IsValidPlayerID(playerID) then
				if func(n, playerID) == true then
					break
				end
			end
		end
	end
end

function SetQuest( playerID,luatitle,luacount,questcount,questtype )
	if questcount == 1 then
		--CustomUI:DynamicHud_Create(playerID,"QuestPanel","file://{resources}/layout/custom_game/quest.xml",nil)
		CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(playerID), "set_quest", {playerid=playerID,title=luatitle,count=luacount,questid=questtype} )
		EmitAnnouncerSoundForPlayer("ui.quest_select", playerID)
	else
		--CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(playerID), "set_quest", {playerid=playerID,title=luatitle,count=luacount,questid=questtype} )
		EmitAnnouncerSoundForPlayer("ui.quest_select", playerID)
	end
end
function SetQuestKillCount( playerID,luakillcount,luacount,questtype )
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(playerID), "set_quest_kill_count", {playerid=playerID,count=luacount,killcount=luakillcount-1,questid=questtype} )
end
function CloseQuest( playerID,questtype,questcount )
	if questcount == 0 then
		CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(playerID), "close_quest", {playerid=playerID,questid=questtype} )
		EmitAnnouncerSoundForPlayer("ui.quest_highlight", playerID)
		--[[Timers:CreateTimer(0.5,function ()
			CustomUI:DynamicHud_Destroy(playerID, "QuestPanel")
		end)]]
	else
		CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(playerID), "close_quest", {playerid=playerID,questid=questtype} )
		EmitAnnouncerSoundForPlayer("ui.quest_highlight", playerID)
	end
end
function DetectCheatsThinker ()
	if (Convars:GetBool("sv_cheats")) then
		GuardingAthena.is_cheat= true
		return nil
	end
	return 1
end