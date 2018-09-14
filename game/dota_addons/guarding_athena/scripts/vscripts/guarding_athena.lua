TIME_BOSS_REBORN = 60
GOLD_USED_TABLE ={}
SF_USED_TABLE ={}
HERO_TABLE = {}
GameRules.QuestKill = {}
GameRules.subQuestKill = {}
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

function GuardingAthena:InitGameMode()
	--print('[GuardingAthena] Starting to load GuardingAthena gamemode...')

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
	self.SelectDifficulty = {}
	self.DifficultySelected = false
	self.Players = {}
	self.GameStartTime = 0
	self.is_cheat = false
	self.timeStamp = nil
	self.randomStr = nil
	self.signature = nil

	if not self.entAthena then
		--print( "Athena entity not found!" )
	end

	if IsInToolsMode() then
		HERO_SELECTION_TIME = 2
	end

	-- 初始化游戏参数
    self:ReadGameConfiguration()
    -- 设置游戏系统规则
    GameRules:SetHeroRespawnEnabled( ENABLE_HERO_RESPAWN )
    GameRules:SetSameHeroSelectionEnabled( ALLOW_SAME_HERO_SELECTION )
	GameRules:SetHeroSelectionTime( HERO_SELECTION_TIME )
	CustomNetTables:SetTableValue( "difficulty", "setting", {hero_selection_time = HERO_SELECTION_TIME} )
    GameRules:SetPreGameTime( PRE_GAME_TIME )
    GameRules:SetPostGameTime( POST_GAME_TIME )
    GameRules:SetTreeRegrowTime( TREE_REGROW_TIME )
    GameRules:SetUseCustomHeroXPValues( USE_CUSTOM_XP_VALUES )
    GameRules:SetGoldPerTick(GOLD_PER_TICK)
    GameRules:SetGoldTickTime(GOLD_TICK_TIME)
    GameRules:SetUseBaseGoldBountyOnHeroes( USE_STANDARD_HERO_GOLD_BOUNTY )
    GameRules:SetFirstBloodActive( ENABLE_FIRST_BLOOD )
    GameRules:SetHideKillMessageHeaders( HIDE_KILL_BANNERS )
    GameRules:SetUseUniversalShopMode( UNIVERSAL_SHOP_MODE )
    GameRules:SetHeroMinimapIconScale( MINIMAP_ICON_SIZE )          
    GameRules:SetCreepMinimapIconScale( MINIMAP_CREEP_ICON_SIZE )
    GameRules:SetCustomGameEndDelay( GAME_END_DELAY )
    GameRules:SetCustomVictoryMessageDuration( VICTORY_MESSAGE_DURATION )
    GameRules:SetStartingGold( STARTING_GOLD )
    for team,number in pairs(CUSTOM_TEAM_PLAYER_COUNT) do
        GameRules:SetCustomGameTeamMaxPlayers(team, number)
    end
    if USE_CUSTOM_TEAM_COLORS then
        for team,color in pairs(TEAM_COLORS) do
          SetTeamCustomHealthbarColor(team, color[1], color[2], color[3])
        end
    end
    if SKIP_TEAM_SETUP then
        GameRules:SetCustomGameSetupAutoLaunchDelay( 0 )
        GameRules:LockCustomGameSetupTeamAssignment( true )
        GameRules:EnableCustomGameSetupAutoLaunch( true )
    else
        GameRules:SetCustomGameSetupAutoLaunchDelay( AUTO_LAUNCH_DELAY )
        GameRules:LockCustomGameSetupTeamAssignment( LOCK_TEAM_SETUP )
        GameRules:EnableCustomGameSetupAutoLaunch( ENABLE_AUTO_LAUNCH )
    end
  	GameRules.DropTable = LoadKeyValues("scripts/kv/item_drops.kv")
  	GameRules.ItemInfoKV = LoadKeyValues("scripts/kv/item_info.kv")
  	GameRules.VipTable = LoadKeyValues("scripts/kv/vip_list.kv")
  	GameRules.sandking = true


  	-- 设置游戏规则
    GameMode = GameRules:GetGameModeEntity()        
    if FORCE_PICKED_HERO ~= nil then
      GameMode:SetCustomGameForceHero( FORCE_PICKED_HERO )
    end
    GameMode:SetRecommendedItemsDisabled( RECOMMENDED_BUILDS_DISABLED )
    GameMode:SetTopBarTeamValuesOverride ( USE_CUSTOM_TOP_BAR_VALUES )
    GameMode:SetTopBarTeamValuesVisible( TOP_BAR_VISIBLE )
    GameMode:SetUseCustomHeroLevels ( USE_CUSTOM_HERO_LEVELS )
    GameMode:SetTowerBackdoorProtectionEnabled( ENABLE_TOWER_BACKDOOR_PROTECTION )
    GameMode:SetGoldSoundDisabled( DISABLE_GOLD_SOUNDS )
    GameMode:SetRemoveIllusionsOnDeath( REMOVE_ILLUSIONS_ON_DEATH )
    GameMode:SetAnnouncerDisabled( DISABLE_ANNOUNCER )
    GameMode:SetAlwaysShowPlayerInventory( SHOW_ONLY_PLAYER_INVENTORY )
    GameMode:SetLoseGoldOnDeath( LOSE_GOLD_ON_DEATH )
    GameMode:SetCameraDistanceOverride( CAMERA_DISTANCE_OVERRIDE )
    GameMode:SetCustomXPRequiredToReachNextLevel( XP_PER_LEVEL_TABLE )
    GameMode:SetFogOfWarDisabled( DISABLE_FOG_OF_WAR_ENTIRELY )
    GameMode:SetUnseenFogOfWarEnabled( USE_UNSEEN_FOG_OF_WAR )
    GameMode:SetCustomHeroMaxLevel ( MAX_LEVEL )
    GameMode:SetFixedRespawnTime(FIXED_RESPAWN_TIME)
    GameMode:SetFountainConstantManaRegen( FOUNTAIN_CONSTANT_MANA_REGEN )
    GameMode:SetFountainPercentageHealthRegen( FOUNTAIN_PERCENTAGE_HEALTH_REGEN )
    GameMode:SetFountainPercentageManaRegen( FOUNTAIN_PERCENTAGE_MANA_REGEN )
    GameMode:SetBuybackEnabled( BUYBACK_ENABLED )
    GameMode:SetCustomBuybackCooldownEnabled( CUSTOM_BUYBACK_COOLDOWN_ENABLED )
    GameMode:SetCustomBuybackCostEnabled( CUSTOM_BUYBACK_COST_ENABLED )
    GameMode:SetMaximumAttackSpeed( MAXIMUM_ATTACK_SPEED )
    GameMode:SetMinimumAttackSpeed( MINIMUM_ATTACK_SPEED )
    GameMode:SetStashPurchasingDisabled ( DISABLE_STASH_PURCHASING )
    GameMode:SetBotThinkingEnabled( USE_STANDARD_DOTA_BOT_THINKING )
    GameMode:SetDaynightCycleDisabled( DISABLE_DAY_NIGHT_CYCLE )
    GameMode:SetKillingSpreeAnnouncerDisabled( DISABLE_KILLING_SPREE_ANNOUNCER )
    GameMode:SetStickyItemDisabled( DISABLE_STICKY_ITEM )
	GameMode:SetExecuteOrderFilter( Dynamic_Wrap( GuardingAthena, "ExecuteOrderFilter" ), self )
	GameMode:SetDamageFilter( Dynamic_Wrap( GuardingAthena, "DamageFilter" ), self )
	GameMode:SetItemAddedToInventoryFilter( Dynamic_Wrap( GuardingAthena, "ItemAddedFilter" ), self )
	GameMode:SetModifyExperienceFilter( Dynamic_Wrap( GuardingAthena, "ModifyExperienceFilter" ), self )
	GameMode:SetModifyGoldFilter( Dynamic_Wrap( GuardingAthena, "ModifyGoldFilter" ), self )
	GameMode:SetThink("DetectCheatsThinker")
	-- 设定平衡常数
	--[[GameMode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_STRENGTH_DAMAGE,1)
	GameMode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_STRENGTH_HP,20)
	GameMode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_STRENGTH_HP_REGEN_PERCENT,0.003)
	GameMode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_STRENGTH_STATUS_RESISTANCE_PERCENT,0)
	GameMode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_AGILITY_DAMAGE,1)
	GameMode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_AGILITY_ARMOR,0.17)
	GameMode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_AGILITY_ATTACK_SPEED,1)
	GameMode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_AGILITY_MOVE_SPEED_PERCENT,0)
	GameMode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_INTELLIGENCE_DAMAGE,1)
	GameMode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_INTELLIGENCE_MANA,11)
	GameMode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_INTELLIGENCE_MANA_REGEN_PERCENT,0.002)
	GameMode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_INTELLIGENCE_SPELL_AMP_PERCENT,0)
	GameMode:SetCustomAttributeDerivedStatValue(DOTA_ATTRIBUTE_INTELLIGENCE_MAGIC_RESISTANCE_PERCENT,0)]]
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
	
	--玩家可买物品最大数目，不限制
	SendToServerConsole("dota_max_physical_items_purchase_limit 9999")
	--GameRules:GetGameModeEntity():SetThink( "OnThink", self, 30 ) 
end
--读取游戏配置
function GuardingAthena:ReadGameConfiguration()
	print("[GuardingAthena] Read Game Configuration")
	Entities:FindByName( nil, "practice_1" ).onthink = false
	Entities:FindByName( nil, "practice_2" ).onthink = false
	Entities:FindByName( nil, "practice_3" ).onthink = false
	Entities:FindByName( nil, "practice_4" ).onthink = false
	self.creatCourier = 0
	-- 技能表
	local AbilityInfo = LoadKeyValues("scripts/npc/npc_heroes_custom.txt")
	local AbilityTable = {}
	for k,v in pairs(AbilityInfo) do
		if type(v) ~= "number" then
			AbilityTable[v.override_hero] = {}
			for i=1,5 do
				table.insert(AbilityTable[v.override_hero], v["Ability"..i])
			end
		end
	end
	for k,v in pairs(AbilityTable) do
		CustomNetTables:SetTableValue( "ability_table", k, v )
	end
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
		Attributes:Init()
	end
	
	--选择英雄阶段
	if newState == DOTA_GAMERULES_STATE_HERO_SELECTION then
	end

	--游戏在准备阶段
	if newState == DOTA_GAMERULES_STATE_PRE_GAME then
		
		--难度计算
		Timers:CreateTimer(HERO_SELECTION_TIME, function()
			self.GameStartTime = GameRules:GetGameTime()
			-- 难度投票计算
			local difficulty_count = {0,0,0,0,0}
			for playerID,difficulty_select in pairs(self.SelectDifficulty) do
				difficulty_count[difficulty_select] = difficulty_count[difficulty_select] + 1
			end
			local index = 1             -- maximum index
		    local max = difficulty_count[index]          -- maximum value
		    for i,value in ipairs(difficulty_count) do
		       if value >= max then
		           index = i
		           max = value
		       end
		    end
		    if max == 0 then
		    	index = 2
		    end
			local select_difficulty = index
			CustomGameEventManager:Send_ServerToAllClients("difficulty", {difficulty=select_difficulty})
			GameRules:SetCustomGameDifficulty(select_difficulty)
			if GameRules:GetDifficulty() == 1 then
			    GameRules:SetGoldPerTick(9)
			    GameMode:SetFixedRespawnTime(5)
			    for i=1,PlayerResource:GetPlayerCountForTeam( DOTA_TEAM_GOODGUYS ) do
			    	PlayerResource:ModifyGold(i - 1 ,300, true, 0)
			    end
			elseif GameRules:GetDifficulty() == 2 then
			    GameRules:SetGoldPerTick(6)
			    GameMode:SetFixedRespawnTime(10)
			    for i=1,PlayerResource:GetPlayerCountForTeam( DOTA_TEAM_GOODGUYS ) do
			    	PlayerResource:ModifyGold(i - 1 ,200, true, 0)
			    end
			elseif GameRules:GetDifficulty() == 3 then
			    GameRules:SetGoldPerTick(3)	
			    GameMode:SetFixedRespawnTime(15)
			    for i=1,PlayerResource:GetPlayerCountForTeam( DOTA_TEAM_GOODGUYS ) do
			    	PlayerResource:ModifyGold(i - 1 ,100, true, 0)
			    end
			elseif GameRules:GetDifficulty() == 4 then
			    GameRules:SetGoldPerTick(0)
			    GameMode:SetFixedRespawnTime(20)
			elseif GameRules:GetDifficulty() == 5 then
			    GameRules:SetGoldPerTick(0)
			    GameMode:SetFixedRespawnTime(25)
			end
			--初始化刷怪
			Spawner:Init()
			updateScore(function ()
			end)
			
		end)
		local Players = PlayerResource:GetPlayerCountForTeam( DOTA_TEAM_GOODGUYS )
		self.player_count = Players
		for i=1,Players do
			local playerid = i - 1 
			CustomNetTables:SetTableValue( "scoreboard", tostring(i-1), { lv=1, str=0, agi=0, int=0, wavedef=0, damagesave=0, goldsave=0 } )
			CustomNetTables:SetTableValue( "shop", tostring(i-1), { def_point=0, boss_point=0, practice_point=0})
		end
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
--自定义控制台命令
function GuardingAthena:TestMode( cmdName, goldToDrop )
	--print("[GuardingAthena] Test Mode")
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