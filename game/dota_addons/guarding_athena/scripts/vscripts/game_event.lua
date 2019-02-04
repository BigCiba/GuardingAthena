-- 监听实体死亡
function GuardingAthena:OnEntityKilled( event )
	--print( '[GuardingAthena] OnEntityKilled Called' )
	
	-- The Unit that was Killed
	local killedUnit = EntIndexToHScript(event.entindex_killed)
	local killerUnit = EntIndexToHScript(event.entindex_attacker)
	local playerID
	-- 幻象击杀判定
	if killerUnit:IsIllusion() then
		if killerUnit.caster_hero then
			killerUnit = killerUnit.caster_hero
		end
	end
	-- 买活设定
	if killedUnit:IsRealHero() then
		-- 设定买活金钱
		playerID = killedUnit:GetPlayerID()
		local cost = killedUnit:GetLevel() * 500
		if cost > 50000 then
			cost = 50000
		end
		PlayerResource:SetCustomBuybackCost(playerID, cost)
		-- 设定区域限制解除
		killedUnit.limitRegion = nil
		if killedUnit.iapetos then
			if GuardingAthena.iapetos then
				GuardingAthena.iapetos:RemoveSelf()
			end
			GuardingAthena.iapetos = nil
			killedUnit.iapetos = nil
		end
	end
	-- 雅典娜重生
	if killedUnit == self.entAthena then
		if self.athena_reborn then
			Timers:CreateTimer(0.1,function ()
		    	killedUnit:RespawnUnit()
				--killedUnit:AddAbility("athena_reborn"):SetLevel(1)
				local ability = killedUnit:FindAbilityByName("athena_reborn")
				ability:ApplyDataDrivenModifier(killedUnit, killedUnit, "modifier_athena_reborn", nil)
				PrecacheUnitByNameAsync("ciba",function()
		            local unit = CreateUnitByName("ciba", killedUnit:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS )
		            unit:AddNewModifier(nil, nil, "modifier_phased", {duration=60})
		            Timers:CreateTimer(60,function ()
		            	unit:ForceKill(true)
			    	end) 
		        end)
				Timers:CreateTimer(60,function ()
					killedUnit:SetPhysicalArmorBaseValue(self.athena_armor_lv + 10)
					killedUnit:SetBaseHealthRegen(self.athena_regen_lv * 10 + 10)
		    	end)
		    	self.athena_reborn = false
		    end)
		else
			Timers:CreateTimer(1,function ()
				GameRules:MakeTeamLose( DOTA_TEAM_GOODGUYS )
			end)
			HeroState:SendFinallyData()
		end
	end
	if self.final_boss then
		if self.final_boss:GetHealth() <= 0 then
			Timers:CreateTimer(10,function ()
		    	GameRules:SetGameWinner( DOTA_TEAM_GOODGUYS )
				if self.is_cheat == false then
					--giveScore()
					Server:UpdataScore()
				end
		    end)
			HeroState:SendFinallyData()
		end
	end
	if killedUnit:IsCreature() then
        RollDrops(killedUnit)
	end
	if killerUnit.trial then
		if killerUnit.trial == killedUnit then
			killerUnit.trial = nil
			ParticleManager:DestroyParticle(killedUnit.trial_wall, false)
		end
	end
	if killedUnit.trial then
		killedUnit.trial:ForceKill(false)
		ParticleManager:DestroyParticle(killedUnit.trial.trial_wall, false)
		killedUnit.trial = nil
	end
    if killedUnit and string.find(killedUnit:GetUnitName(), "guai") then
		-- 排除复活单位与非测试单位
		if killedUnit.corpse or killedUnit.wave == nil then
			return
		end
    	-- 守家buff
    	if killerUnit:IsRealHero() then
	    	killerUnit.killguai = killerUnit.killguai + 1
	    	if killerUnit.killguai == 300 then
	    		killerUnit:AddAbility("guarding_1")
				killerUnit:FindAbilityByName("guarding_1"):SetLevel(1)
			elseif killerUnit.killguai == 700 then
				killerUnit:RemoveModifierByName("modifier_guarding_1")
				killerUnit:RemoveAbility("guarding_1")
				killerUnit:AddAbility("guarding_2")
				killerUnit:FindAbilityByName("guarding_2"):SetLevel(1)
			elseif killerUnit.killguai == 1600 then
				killerUnit:RemoveModifierByName("modifier_guarding_2")
				killerUnit:RemoveAbility("guarding_2")
				killerUnit:AddAbility("guarding_3")
				killerUnit:FindAbilityByName("guarding_3"):SetLevel(1)
			elseif killerUnit.killguai == 2400 then
				killerUnit:RemoveModifierByName("modifier_guarding_3")
				killerUnit:RemoveAbility("guarding_3")
				killerUnit:AddAbility("guarding_4")
				killerUnit:FindAbilityByName("guarding_4"):SetLevel(1)
			end
		end
    end
    
	if killedUnit:GetUnitName() == "boss_sandking" then
		local target_location = killedUnit:GetAbsOrigin()
		local units = FindUnitsInRadius( 0, target_location, nil, 600,  DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO , DOTA_UNIT_TARGET_FLAG_NONE , FIND_CLOSEST, false)
	    for _,unit in ipairs(units) do
			PropertySystem(unit,3,RandomInt(5, 10))
	    end
	end
	if killedUnit:GetUnitName() == "boss_visage" then
		local target_location = killedUnit:GetAbsOrigin()
		local units = FindUnitsInRadius( 0, target_location, nil, 600,  DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO , DOTA_UNIT_TARGET_FLAG_NONE , FIND_CLOSEST, false)
	    for _,unit in ipairs(units) do
	    	PropertySystem(unit,3,RandomInt(5, 10))
	    end
	    Timers:CreateTimer(TIME_BOSS_REBORN,function ()
	    	local point = Entities:FindByName( nil, "boss_visage_reborn" ):GetAbsOrigin()
	    	PrecacheUnitByNameAsync("boss_visage",
			    function()
					local unit = CreateUnitByName("boss_visage", point, true, nil, nil, DOTA_TEAM_BADGUYS )
			end)
	    end)
	end
	if killedUnit:GetUnitName() == "boss_treant" then
		local target_location = killedUnit:GetAbsOrigin()
		local units = FindUnitsInRadius( killedUnit:GetTeamNumber(), target_location, nil, 600,  DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO , DOTA_UNIT_TARGET_FLAG_NONE , FIND_CLOSEST, false)
	    for _,unit in ipairs(units) do
	    	PropertySystem(unit,3,RandomInt(5, 10))
	    end
	    Timers:CreateTimer(120,function ()
	    	local point = Entities:FindByName( nil, "boss_treant_reborn" ):GetAbsOrigin()
	    	PrecacheUnitByNameAsync("boss_treant",
			    function()
					local unit = CreateUnitByName("boss_treant", point, true, nil, nil, DOTA_TEAM_BADGUYS )
			end)
	    end)
	end
	if killedUnit:GetUnitName() == "boss_fire_demon" then
		local target_location = killedUnit:GetAbsOrigin()
		local units = FindUnitsInRadius( 0, target_location, nil, 600,  DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO , DOTA_UNIT_TARGET_FLAG_NONE , FIND_CLOSEST, false)
	    for _,unit in ipairs(units) do
	    	PropertySystem(unit,3,RandomInt(5, 10))
	    end
	    Timers:CreateTimer(TIME_BOSS_REBORN,function ()
	    	local point = Entities:FindByName( nil, "boss_fire_demon_reborn" ):GetAbsOrigin()
	    	PrecacheUnitByNameAsync("boss_fire_demon",
			    function()
					local unit = CreateUnitByName("boss_fire_demon", point, true, nil, nil, DOTA_TEAM_BADGUYS )
			end)
	    end)
	end
	if killedUnit:GetUnitName() == "boss_clotho" then
		local target_location = killedUnit:GetAbsOrigin()
		local units = FindUnitsInRadius( 0, target_location, nil, 600,  DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO , DOTA_UNIT_TARGET_FLAG_NONE , FIND_CLOSEST, false)
	    for _,unit in ipairs(units) do
	    	PropertySystem(unit,3,RandomInt(5, 10))
	    end
	    Timers:CreateTimer(TIME_BOSS_REBORN,function ()
	    	local point = Entities:FindByName( nil, "spawner_clotho" ):GetAbsOrigin()
	    	PrecacheUnitByNameAsync("boss_clotho",
			    function()
					local unit = CreateUnitByName("boss_clotho", point, true, nil, nil, DOTA_TEAM_BADGUYS ) 
	    			unit:CreatureLevelUp(self.clotho_lv)
	    			for i=1,16 do
						if unit:GetAbilityByIndex(i-1) then
							local ability = unit:GetAbilityByIndex(i-1)
						    ability:SetLevel(self.clotho_lv)
						end
					end
					self.clotho_lv = self.clotho_lv + 1
			end)
	    end)
	end
	if killedUnit:GetUnitName() == "boss_iapetos" then
		GuardingAthena.iapetos = nil
		local caller = killedUnit.caller
		local hRelay = Entities:FindByName( nil, "gate_demon_relay" )
		hRelay:Trigger()
		-- 转生许可
		caller.kill_iapetos = true
		caller.limitRegion = nil
		if caller:IsRealHero() then
        	caller.can_reborn = true
		end
		-- 掉落补天石
		local item = CreateItem("item_butianshi", caller, caller)
        item:SetPurchaseTime(GameRules:GetGameTime() - 10)
        if not IsFullSolt(caller,12,false) then
        	caller:AddItem(item)
        else
        	if not IsFullSolt(caller.courier,6,false) then
        		caller.courier:AddItem(item)
        	else
		        local pos = killedUnit:GetAbsOrigin()
		        local drop = CreateItemOnPositionSync( pos, item )
		        local pos_launch = pos+RandomVector(RandomFloat(0,50))
		        item:LaunchLoot(false, 200, 0.75, pos_launch)
		    end
		end
	end
	if killedUnit:GetUnitName() == "zeus" then
		PrecacheUnitByNameAsync("zeus_reborn",
		    function()
				Timers:CreateTimer(function ()
					local Difficulty = GameRules:GetDifficulty()
					local unit = CreateUnitByName("zeus_reborn", killedUnit:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS ) 
					unit:MoveToPositionAggressive(Entities:FindByName( nil, "athena" ):GetAbsOrigin())
					unit:SetBaseDamageMin(unit:GetBaseDamageMin() * Difficulty * RandomFloat(1, (1.2+Difficulty*0.2)))
					unit:SetBaseDamageMax(unit:GetBaseDamageMax() * Difficulty * RandomFloat(1, (1.2+Difficulty*0.2)))
					unit:SetBaseMaxHealth(unit:GetBaseMaxHealth() * Difficulty * RandomFloat(1, (1.2+Difficulty*0.2)))
					unit:Heal(unit:GetBaseMaxHealth() - unit:GetHealth(), nil)
					unit:SetPhysicalArmorBaseValue(unit:GetPhysicalArmorBaseValue() * Difficulty * RandomFloat(1, (1.2+Difficulty*0.2)))
					for i=1,16 do
						if unit:GetAbilityByIndex(i-1) then
							local ability = unit:GetAbilityByIndex(i-1)
						    ability:SetLevel(Difficulty)
						end
					end
					GuardingAthena.final_boss = unit
					Spawner.bossCurrent = unit
					--table.insert(SPAWNER, unit)
			        local t_order = 
			        {
			            UnitIndex = unit:entindex(),
			            OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			            TargetIndex = nil,
			            AbilityIndex = unit:FindAbilityByName("thunder_wrath"):entindex(),
			            Position = nil,
			            Queue = 0
			        }
			        unit:SetContextThink(DoUniqueString("order") , function() ExecuteOrderFromTable(t_order) end, 0.1)
				end)
		end)
	end
end
-- 监听玩家完全连接
function GuardingAthena:OnConnectFull(keys)
	--PrintTable(keys)
	print ('[GuardingAthena] OnConnectFull')
	local playerEntity = PlayerResource:GetPlayer(keys.PlayerID)
	self.Players[keys.PlayerID] = playerEntity
	local entIndex = keys.index+1
	-- The Player entity of the joining user
	local player = EntIndexToHScript(entIndex)

	-- The Player ID of the joining player
	local playerID = player:GetPlayerID()
	local steamid = PlayerResource:GetSteamAccountID(playerID)
	CustomNetTables:SetTableValue( "playerInfo", tostring(playerID), {steamid=tostring(steamid)} )
	-- 初始化分数
	--setScore(playerID,0)
	Server:GetPlayerInfo(playerID,function()
		--local hero = player:GetAssignedHero()
		--hero.boss_point = player.ServerInfo.score
	end)
	Server:GetScore(playerID)

	GameRules:GetGameModeEntity():SetHUDVisible(8, false)
	GameRules:GetGameModeEntity():SetHUDVisible(9, false)
	local gamestat = GameRules:State_Get()
	local heroEntity = playerEntity:GetAssignedHero()
	if gamestat == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		if heroEntity:GetUnitName() == "npc_dota_hero_wisp" then
			local randomHeroTable = {
				"npc_dota_hero_omniknight",
				"npc_dota_hero_windrunner",
				"npc_dota_hero_phantom_assassin",
				"npc_dota_hero_rubick",
				"npc_dota_hero_juggernaut",
				"npc_dota_hero_antimage",
				"npc_dota_hero_lina",
				"npc_dota_hero_legion_commander",
				"npc_dota_hero_ember_spirit"
			}
			local currentHero = randomHeroTable[RandomInt(1,9)]
			--print(currentHero)
			PrecacheUnitByNameAsync(currentHero,function()
				PlayerResource:ReplaceHeroWith(playerID,currentHero,PlayerResource:GetGold(heroEntity:GetPlayerID()),0)
				heroEntity:RemoveSelf()
			end)
		end
	end
end
-- 监听npc出生，包括英雄
function GuardingAthena:OnNPCSpawned(keys)
	--print("[GuardingAthena] NPC Spawned")
	--DeepPrintTable(keys)
	local spawnedUnit = EntIndexToHScript( keys.entindex )
	if spawnedUnit:IsRealHero() then
		-- 重置买活惩罚
		--PlayerResource:ResetBuybackCostTime(spawnedUnit:GetPlayerID())
		-- 单人buff
		Timers:CreateTimer(0.1,function ()
			if spawnedUnit:IsNull() then
				return
			else
		    	spawnedUnit:SetBuybackCooldownTime(0)
		    	spawnedUnit:RemoveModifierByName("modifier_buyback_gold_penalty")
		    end
	    end)
		local Players = PlayerResource:GetPlayerCountForTeam( DOTA_TEAM_GOODGUYS )
		if Players == 1 and spawnedUnit:HasAbility("singlehero") == false and self.is_cheat== false then
			spawnedUnit:AddAbility("singlehero")
			spawnedUnit:FindAbilityByName("singlehero"):SetLevel(1)
		end
		-- 初始化经验获得率
		if spawnedUnit.GetExpRate == nil then
			spawnedUnit.GetExpRate = 0
		end
		-- 初始化转生击杀
		if spawnedUnit.kill_iapetos == nil then
			spawnedUnit.kill_iapetos = false
		end
		-- 初始化守家积分
		if spawnedUnit.killguai == nil then
			spawnedUnit.killguai = 0
		end
		-- 初始化练功积分
		if spawnedUnit.practice == nil then
			spawnedUnit.practice = 0
		end
		-- 天赋技能
	    local ability = spawnedUnit:GetAbilityByIndex(0)
	    if ability:GetLevel() == 0 then
	        ability:SetLevel(1)
		end
		
	    -- 作者buff
	    if PlayerResource:GetSteamAccountID(spawnedUnit:GetPlayerID()) == 128320546 then
	    	--spawnedUnit:AddAbility("autor_buff")
			--spawnedUnit:FindAbilityByName("autor_buff"):SetLevel(1)
			--CreateParticle( "particles/player/vip.vpcf", PATTACH_ABSORIGIN_FOLLOW, spawnedUnit )
			--CustomUI:DynamicHud_Create(spawnedUnit:GetPlayerID(),"VipParticleBackGround","file://{resources}/layout/custom_game/vip_particle.xml",nil)
		end
		
	end
end

-- 监听玩家选择英雄
function GuardingAthena:OnPlayerPickHero(keys)
	--print ('[GuardingAthena] OnPlayerPickHero')
	--PrintTable(keys)
	if keys.hero == "npc_dota_hero_wisp" then
		--EntIndexToHScript(keys.heroindex):SetModelScale(0.01)
		-- vip
		local count = 0
		local heroEntity = EntIndexToHScript(keys.heroindex)
		local player = heroEntity:GetPlayerOwner()
		local playerID = heroEntity:GetPlayerID()
		Timers:CreateTimer(function ( )
			if player.ServerInfo then
				if player.ServerInfo.vip == "1" then
					player.gold_gift = true
					player.potion_gift = true
					CustomUI:DynamicHud_Create(playerID,"VipParticleBackGround","file://{resources}/layout/custom_game/custom_hud/vip_particle.xml",nil)
					CustomGameEventManager:Send_ServerToPlayer( player, "vip", {playerid=playerID} )
				end
				if player.ServerInfo.sf == "1" then
					CustomGameEventManager:Send_ServerToPlayer( player, "unlock", {heroName="npc_dota_hero_nevermore"} )
				end
				if player.ServerInfo.ta == "1" then
					CustomGameEventManager:Send_ServerToPlayer( player, "unlock", {heroName="npc_dota_hero_templar_assassin"} )
				end
				if player.ServerInfo.spe == "1" then
					CustomGameEventManager:Send_ServerToPlayer( player, "unlock", {heroName="npc_dota_hero_spectre"} )
				end
				if player.ServerInfo.gold == "1" then
					player.gold_gift = true
				end
				if player.ServerInfo.potion == "1" then
					player.potion_gift = true
				end
			else
				if count < 300 then
					count = count + 1
					return 1
				end
			end
		end)
		--[[local req = CreateHTTPRequestScriptVM("GET", "http://q-w-q.com/haha2.php" )
		req:Send(function(result)
			local vipTable = JSON:decode(result.Body)
			local heroEntity = EntIndexToHScript(keys.heroindex)
			local player = heroEntity:GetPlayerOwner()
			local playerID = heroEntity:GetPlayerID()
			for k,v in pairs(vipTable) do
				if tonumber(v) == PlayerResource:GetSteamAccountID(playerID) then
					player.gold_gift = true
					player.potion_gift = true
					CustomGameEventManager:Send_ServerToPlayer( player, "vip", {playerid=playerID} )
				end
			end
		end)]]
		return
	end
	local heroEntity = EntIndexToHScript(keys.heroindex)
	if keys.player == -1 then
		return
	end
	
	local player = heroEntity:GetPlayerOwner()
	local playerID = heroEntity:GetPlayerID()
	HeroState:InitHero(heroEntity)
	Attributes:ModifyBonuses(heroEntity)
	-- 记录当前英雄
	HERO_TABLE[playerID + 1] = heroEntity
	-- 垃圾v社
	local tpScroll = heroEntity:GetItemInSlot(15)
	if tpScroll then
		if tpScroll:GetAbilityName() == "item_tpscroll" then
			heroEntity:RemoveItem(tpScroll)
		end
	end
	-- 金色特效
	if player.gold_gift then
		heroEntity.gift = true
		if heroEntity:GetUnitName() == "npc_dota_hero_nevermore" then
			CreateParticle( "particles/wings/wing_sf_goldsky_gold.vpcf", PATTACH_ABSORIGIN_FOLLOW, heroEntity )
		else
			local particle = CreateParticle( "particles/skills/wing_sky_gold.vpcf", PATTACH_ABSORIGIN_FOLLOW, heroEntity )
			--ParticleManager:SetParticleControlEnt(particle, 0, heroEntity, PATTACH_POINT_FOLLOW, "attach_hitloc", heroEntity:GetAbsOrigin(), true)
		end
	end
	-- vip
	--[[local req = CreateHTTPRequestScriptVM("GET", "http://q-w-q.com/haha2.php" )
	req:Send(function(result)
		local vipTable = JSON:decode(result.Body)
		--PrintTable(vipTable)
		for k,v in pairs(vipTable) do
			if tonumber(v) == PlayerResource:GetSteamAccountID(playerID) then
				CustomUI:DynamicHud_Create(playerID,"VipParticleBackGround","file://{resources}/layout/custom_game/custom_hud/vip_particle.xml",nil)
			end
		end
	end)]]
	local playerCount = PlayerResource:GetPlayerCountForTeam( DOTA_TEAM_GOODGUYS )
	if self.creatCourier < playerCount then
		local heroEntity = EntIndexToHScript(keys.heroindex)
		for i=16,23 do
			local ability = heroEntity:GetAbilityByIndex(i)
			if ability then
				ability:SetLevel(1)
			end
		end
		PrecacheUnitByNameAsync("ji",function()
			local courier = CreateUnitByName("ji", heroEntity:GetAbsOrigin(), true, heroEntity:GetPlayerOwner(), heroEntity:GetPlayerOwner(), DOTA_TEAM_GOODGUYS )
			courier.bag = {}
			courier:SetOwner(heroEntity:GetPlayerOwner())
			courier:SetControllableByPlayer(heroEntity:GetPlayerID(),true)
			courier.owner = heroEntity:GetPlayerOwner()
			courier.currentHero = heroEntity
			heroEntity.courier = courier
			self.creatCourier = self.creatCourier + 1
			-- 药水礼包
			if player.potion_gift then
				if not IsFullSolt(courier,6,true) then
					local clarity = CreateItem("item_clarity1", courier, courier)
					local salve = CreateItem("item_salve1", courier, courier)
					courier:AddItem(clarity)
					courier:AddItem(salve)
					clarity:SetCurrentCharges(30)
					salve:SetCurrentCharges(30)
				end
			end
		end)
	end
	-- 设定通关积分
	local count = 0
	Timers:CreateTimer(function ()
		if player.ServerInfo then
			heroEntity.boss_point = player.ServerInfo.score
		else
			if count < 300 then
				count = count + 1
				return 1
			end
		end
	end)
end
-- 监听玩家聊天
function GuardingAthena:OnPlayerChat(keys)
	--print("[GuardingAthena] On Player Chat")
	--DeepPrintTable(keys)
	--teamonly ( bool ): true if team only chat
	--userid( short ): chatting player
	--text( string ): chat text
	local playerid = keys.userid - 1
	local text = keys.text
	Cheats =
	{
		"-lvlup",
		"-levelbots",
		"-gold",
		"-item",
		"-givebots",
		"-refresh",
		"-respawn",
		"-startgame",
		"-spawncreeps",
		"-spawnneutrals",
		"-disablecreepspawn",
		"-enablecreepspawn",
		"-spawnrune",
		"-killwards",
		"-createhero",
		"-dumpbots",
		"-wtf",
		"-unwtf",
		"-allvision",
		"-normalvision",
	}
	for k,cheat in pairs(Cheats) do
        if string.match(text, cheat) then
            self.is_cheat = true
        end
	end
	--专属
	if text == "-givezs" then
		local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
		local heroName = hero:GetUnitName()
		hero:AddItem(CreateItem("item_"..heroName, hero, hero))
	end
	if text == "givezs" then
		local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
		local heroName = hero:GetUnitName()
		hero:AddItem(CreateItem("item_"..heroName, hero, hero))
	end
	--设置波数
	if string.sub(text,0,6) == "waveto" then
		local wave = tonumber(string.sub(text,7,string.len(text)))
		if wave >= 0 then
			Spawner.gameRound = wave - 1
		end
	end
	if text == "createhero" then
		self.testhero = CreateHeroForPlayer("npc_dota_hero_omniknight", PlayerResource:GetPlayer(playerid))
	end
	if text == "movehero" then
		local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
		self.testhero:SetAbsOrigin(hero:GetAbsOrigin())
	end
	if string.sub(text,0,5) == "troll" then
		local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
		PrecacheUnitByNameAsync(text,function()
			local nature = CreateUnitByName(text, hero:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS ) 
		end)
	end
	if text == "point" then
		local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
		hero.def_point = 90000
	end
	if text == "printtbl" then
		printtbl()
	end
	if text == "getlocation" then
		print(tostring(PlayerResource:GetPlayer(playerid):GetAssignedHero():GetAbsOrigin()))
	end 
	if text == "getdisobb" then
		local dis = CalcDistanceBetweenEntityOBB(PlayerResource:GetPlayer(playerid):GetAssignedHero(), Entities:FindByName(nil, "test_entity"))
		print(dis)
	end 
	if text == "getscore" then
		updateScore(function()

			print("haha")
			print(getPlayerScore(0))
		end)
	end 
	if text == "defpoint" then
		local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
		hero.practice_point = 90000
	end 
	if text == "time" then
		print(GameRules:GetTimeOfDay())
	end
	if text == "-allring" then
		local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
		hero:AddNewModifier(hero, nil, "ring_0_1", nil)
		hero:AddNewModifier(hero, nil, "ring_0_2", nil)
		hero:AddNewModifier(hero, nil, "ring_0_3", nil)
		hero:AddNewModifier(hero, nil, "ring_0_4", nil)
		hero:AddNewModifier(hero, nil, "ring_0_5", nil)
		hero:AddNewModifier(hero, nil, "ring_0_6", nil)
		hero:AddNewModifier(hero, nil, "ring_1_2", nil)
		hero:AddNewModifier(hero, nil, "ring_1_3", nil)
		hero:AddNewModifier(hero, nil, "ring_1_4", nil)
		hero:AddNewModifier(hero, nil, "ring_1_5", nil)
		hero:AddNewModifier(hero, nil, "ring_1_6", nil)
		hero:AddNewModifier(hero, nil, "ring_2_3", nil)
		hero:AddNewModifier(hero, nil, "ring_2_4", nil)
		hero:AddNewModifier(hero, nil, "ring_2_5", nil)
		hero:AddNewModifier(hero, nil, "ring_2_6", nil)
		hero:AddNewModifier(hero, nil, "ring_3_4", nil)
		hero:AddNewModifier(hero, nil, "ring_3_5", nil)
		hero:AddNewModifier(hero, nil, "ring_3_6", nil)
		hero:AddNewModifier(hero, nil, "ring_4_5", nil)
		hero:AddNewModifier(hero, nil, "ring_4_6", nil)
		hero:AddNewModifier(hero, nil, "ring_5_6", nil)
	end
	--测试模式
	if text == "test" then
		PlayerResource:SetGold( playerid, 999999, false )
		self.player_gold_save[playerid + 1] = 99999999
		local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
		for i=1,99 do
			hero:HeroLevelUp(false)
		end
		hero:SetAbilityPoints(0)
		local skill_1 = hero:GetAbilityByIndex(1)
		local skill_2 = hero:GetAbilityByIndex(2)
		local skill_3 = hero:GetAbilityByIndex(3)
		local skill_4 = hero:GetAbilityByIndex(4)
		skill_1:SetLevel(20)
		skill_2:SetLevel(20)
		skill_3:SetLevel(20)
		skill_4:SetLevel(8)
		--hero:AddItem(CreateItem("item_ring_world_3_6", hero, hero))
		hero:AddItem(CreateItem("item_dun_5", hero, hero))
		hero:AddItem(CreateItem("item_jian_9", hero, hero))
		hero:AddItem(CreateItem("item_"..hero:GetUnitName(), hero, hero))
		hero.reborn_time = 4
	end
	if string.sub(text,0,9) == "autospawn" then
		local location = PlayerResource:GetPlayer(playerid):GetAssignedHero():GetAbsOrigin()
		local name = string.sub(text,10,string.len(text))
		self.timer = Timers:CreateTimer(function (  )
			PrecacheUnitByNameAsync(name,function()
				local nature = CreateUnitByName(name, location, true, nil, nil, DOTA_TEAM_BADGUYS )
			end)
			return 1
		end)
	end
	if string.sub(text,0,5) == "spawn" then
		local location = PlayerResource:GetPlayer(playerid):GetAssignedHero():GetAbsOrigin()
		local name = string.sub(text,6,string.len(text))
		PrecacheUnitByNameAsync(name,function()
			local nature = CreateUnitByName(name, location, true, nil, nil, DOTA_TEAM_BADGUYS )
			nature:AddNewModifier(nature, nil, "modifier_kill", {duration=60})
			if name == "testunit" then
				self.testunit = nature
			end
			Spawner:UnitProperty(nature,Spawner.unitFactor)
			AI:CreateAI(nature)
		end)
	end
	if text == "trial" then
		local location = PlayerResource:GetPlayer(playerid):GetAssignedHero():GetAbsOrigin()
		local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
		local name = "trial_creep"
		PrecacheUnitByNameAsync(name,function()
			local nature = CreateUnitByName(name, location, true, nil, nil, DOTA_TEAM_BADGUYS )
			nature:SetBaseMaxHealth(hero:GetMaxHealth() * 10)
			nature:SetMaxHealth(hero:GetMaxHealth() * 10)
			nature:SetHealth(hero:GetMaxHealth() * 10)
			nature:SetBaseDamageMin(hero:GetBaseDamageMin() * 10)
			nature:SetBaseDamageMax(hero:GetBaseDamageMax() * 10)
			nature:SetPhysicalArmorBaseValue(hero:GetPhysicalArmorBaseValue() * 10)
		end)
	end
	if text == "testpay" then
		local ent = Entities:FindByName( nil, "athena" )
		ent:FireOutput("OnUser2", ent, ent, ent, 0)
	end
	if string.sub(text,0,8) == "addskill" then
		local unit = self.testunit
		unit:AddAbility(string.sub(text,9,string.len(text)))
	end
	if string.sub(text,0,10) == "addability" then
		local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
		hero:AddAbility(string.sub(text,11,string.len(text)))
	end
	if text == "endautospawn" then
		Timers:RemoveTimer(self.timer)
	end
	if text == "pause" then
		Spawner:PauseSpawn(30)
	end
	if text == "testmode" then
		--GameRules:SetGameWinner( DOTA_TEAM_BADGUYS )
		--local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
		--HeroState:SendFinallyData()
		--CustomUI:DynamicHud_Create(-1,"HeroSelectionBackground","file://{resources}/layout/custom_game/pick_hero.xml",nil)
		self.testmode = true
		--CustomUI:DynamicHud_Create(playerid,"Dialog","file://{resources}/layout/custom_game/custom_hud/dialog.xml",nil)
	end
	--取消测试
	if text == "untest" then
		SPAWN_COUNT = 20
		SPAWN_INTERVAL = 120
	end
	if text == "getabsorigin" then
		local heroabs = PlayerResource:GetPlayer(playerid):GetAssignedHero():GetAbsOrigin()
		local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero():GetOrigin()
		print(tostring(heroabs))
		print(tostring(hero))
	end
	--放技能
	if string.sub(text,0,10) == "useskill" then
		local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
		local target = Entities:FindByName(nil, "boss_clotho")
		local t_order = 
        {
            UnitIndex = hero:entindex(),
            OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
            TargetIndex = target:entindex(),
            AbilityIndex = hero:FindAbilityByName("clusters_stars"):entindex(),
            Position = nil,
            Queue = 0
        }
        hero:SetContextThink(DoUniqueString("order") , function() ExecuteOrderFromTable(t_order) end, 0.1)
	end
	--设置攻击力
	if string.sub(text,0,10) == "-setattack" then
		local attack = tonumber(string.sub(text,11,string.len(text)))
		if attack >= 0 then
			local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
			hero:SetBaseDamageMax(attack)
			hero:SetBaseDamageMin(attack)
		end
	end
	--设置攻击间隔
	if string.sub(text,0,13) == "setattackrate" then
		local attackrate = tonumber(string.sub(text,14,string.len(text)))
		if attackrate >= 0 then
			local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
			hero:SetBaseAttackTime(attackrate)
		end
	end
	--设置移动
	if string.sub(text,0,7) == "setmove" then
		local move = tonumber(string.sub(text,8,string.len(text)))
		if move >= 0 then
			local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
			hero:SetBaseMoveSpeed(move)
		end
	end
	--设置移动
	if string.sub(text,0,6) == "setint" then
		local move = tonumber(string.sub(text,7,string.len(text)))
		if move >= 0 then
			local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
			hero:SetBaseIntellect(move)
		end
	end
	if string.sub(text,0,6) == "setagi" then
		local move = tonumber(string.sub(text,7,string.len(text)))
		if move >= 0 then
			local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
			hero:SetBaseAgility(move)
		end
	end
	if string.sub(text,0,6) == "setstr" then
		local move = tonumber(string.sub(text,7,string.len(text)))
		if move >= 0 then
			local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
			hero:SetBaseStrength(move)
			print("str:"..hero:GetStrength().."res:"..hero:GetMagicalArmorValue())
		end
	end
	--设置最大生命
	if string.sub(text,0,8) == "setmaxhp" then
		local hp = tonumber(string.sub(text,9,string.len(text)))
		if hp >= 0 then
			local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
			hero:SetBaseMaxHealth(hp)
		end
	end
	--设置生命
	if string.sub(text,0,5) == "sethp" then
		local hp = tonumber(string.sub(text,6,string.len(text)))
		if hp >= 0 then
			local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
			hero:SetBaseMaxHealth(hp)
			hero:SetMaxHealth(hp)
			hero:SetHealth(hp)
			Spawner:CheckErrorSpawn()
		end
	end
	if string.sub(text,0,4) == "time" then
		local wave = string.sub(text,5,string.len(text))
		CustomGameEventManager:Send_ServerToAllClients("time_remaining", {wave=wave})
	end
	--设置生命回复
	if string.sub(text,0,10) == "sethpregen" then
		local hpregen = tonumber(string.sub(text,11,string.len(text)))
		if hpregen >= 0 then
			local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
			hero:SetBaseHealthRegen(hpregen)
		end
	end
	--设置魔法回复
	if string.sub(text,0,10) == "setmpregen" then
		local mpregen = tonumber(string.sub(text,11,string.len(text)))
		if mpregen >= 0 then
			local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
			hero:SetBaseManaRegen(mpregen)
		end
	end
	--设置护甲
	if string.sub(text,0,8) == "setarmor" then
		local armor = tonumber(string.sub(text,9,string.len(text)))
		if armor >= 0 then
			local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
			hero:SetPhysicalArmorBaseValue(armor)
		end
	end
	--设置魔抗
	if string.sub(text,0,8) == "setmagic" then
		local magic = tonumber(string.sub(text,9,string.len(text)))
		if magic >= 0 then
			local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
			hero:SetBaseMagicalResistanceValue(magic)
		end
	end
	--设置胜利
	if string.sub(text,0,7) == "victory" then
		--GameRules:SetGameWinner( DOTA_TEAM_GOODGUYS )
		HeroState:SendFinallyData()
		CustomUI:DynamicHud_Create(-1,"EndScreenPanel","file://{resources}/layout/custom_game/end_screen.xml",nil)
	end
	--设置模型
	if text == "modeldemon" then
		local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
		hero:SetOriginalModel("models/items/warlock/golem/hellsworn_golem/hellsworn_golem.vmdl")
	end
	if text == "modelpa" then
		local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
		hero:SetOriginalModel("models/heroes/phantom_assassin/phantom_assassin.vmdl")
	end
	if text == "modelpa2" then
		local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
		hero:SetOriginalModel("models/heroes/phantom_assassin/pa_arcana.vmdl")
	end
	if text == "modelomni" then
		local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
		hero:SetOriginalModel("models/heroes/omniknight/omniknight.vmdl")
	end
	if text == "modelcm" then
		local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
		hero:SetOriginalModel("models/heroes/crystal_maiden/crystal_maiden_arcana.vmdl")
	end
	if text == "modelstatue" then
		local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
		hero:SetOriginalModel("models/props_structures/tower_bad_sfm.vmdl")
	end
end
-- 监听玩家英雄升级
function GuardingAthena:OnPlayerLevelUp(keys)
	local player = EntIndexToHScript(keys.player)
	local hero = player:GetAssignedHero()
	local level = keys.level
	-- 额外属性成长
	if hero.str_gain then
		PropertySystem(hero,DOTA_ATTRIBUTE_STRENGTH,hero.str_gain)
	end
	if hero.agi_gain then
		PropertySystem(hero,DOTA_ATTRIBUTE_AGILITY,hero.agi_gain)
	end
	if hero.int_gain then
		PropertySystem(hero,DOTA_ATTRIBUTE_INTELLECT,hero.int_gain)
	end
	-- 修正技能点17 19 21 22 23 24
	if level <= 188 then
		local mod = math.fmod(level,3)
		if level > 8 then
			if mod == 2 then
				if level >= 17 and level < 25 then
					hero:SetAbilityPoints(hero:GetAbilityPoints() + 1)
				end
			else
				if level < 17 or level > 24 then
					hero:SetAbilityPoints(hero:GetAbilityPoints() - 1)
				end
				if level == 18 then
					hero:SetAbilityPoints(hero:GetAbilityPoints() - 2)
				end
				if level == 20 then
					hero:SetAbilityPoints(hero:GetAbilityPoints() - 1)
				end
			end
		end
	else
		hero:SetAbilityPoints(hero:GetAbilityPoints() - 1)
	end
end
-- 监听使用技能
function GuardingAthena:OnUsedAbility(event)
	--PrintTable(event)
	--忽略信使技能
	if string.find(event.abilityname, "courier_") then
		return
	end
    -- 获取玩家使用的英雄
    local hero = PlayerResource:GetPlayer(event.PlayerID):GetAssignedHero()
    -- 获取所使用的技能
    local ability = hero:FindAbilityByName( event.abilityname )
    if ability == nil then
    	return
    end
    if ability.cooldown_reduce == nil then
    	ability.cooldown_reduce = true
    end
	-- 忽略不受冷却效果影响的技能
    if ability.cooldown_reduce == false then
    	return
    end

    -- 如果技能在CD中
    if ability:GetCooldownTimeRemaining() > 0 then
        -- 减少固定数值
        local reduction_const = hero.reduction_const or 0
		-- 减少百分比
        local reduction = hero.reduceRate or 0
		-- 冰女光环
        local frozenAura = hero.frozenAura or 0
		if hero:HasModifier("ring_1_6") then
    		if RollPercentage(50) then
	    		if reduction == 0 then
	    			reduction = 0.5
	    		else
	    			reduction = reduction + 0.5
	    		end
	    	end
    	end

        -- 获取技能的CD时间
        local cdDefault = ability:GetCooldown( ability:GetLevel() - 1 )
        -- 计算减少后的CD
        local cdReduced = (cdDefault - reduction_const) * ( 1.0 - reduction) * (1.0 - frozenAura)
        -- 获取剩余的CD时间
        local cdRemaining = ability:GetCooldownTimeRemaining()

        -- 如果技能的CD时间大于减少后的CD时间
        if cdRemaining > cdReduced then
            -- 计算减少后的CD
            --cdRemaining = cdRemaining - reduction_const - (cdDefault - reduction_const) * (reduction + frozenAura)
			cdRemaining = (cdRemaining - reduction_const) * ( 1.0 - reduction) * (1.0 - frozenAura)
            -- 移除技能的CD
            ability:EndCooldown()
            -- 重新开始CD，CD时间为减少后的CD时间
            ability:StartCooldown( cdRemaining )
        end
    end
end