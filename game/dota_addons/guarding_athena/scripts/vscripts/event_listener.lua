function UI_BuyItem( index,data )
	local hero = EntIndexToHScript(data.entindex)
	local itemName = data.itemName
	local cost = data.cost
	local type = data.type
	local cd = data.cooldown or 0
	if GiveItem( hero, itemName ) then
		hero[type] = hero[type] - cost
		if cd > 0 then
			local canBuyTable = CustomNetTables:GetTableValue("shop", "can_buy")
			canBuyTable[itemName] = false
			CustomNetTables:SetTableValue( "shop", "can_buy", canBuyTable )
			Timers:CreateTimer(cd,function ()
				canBuyTable = CustomNetTables:GetTableValue("shop", "can_buy")
				canBuyTable[itemName] = true
				CustomNetTables:SetTableValue( "shop", "can_buy", canBuyTable )
			end)
		end
	end
end
function UI_BuyReward( index,data )
	local hero = EntIndexToHScript(data.entindex)
	local itemName = data.itemName
	local particleName = string.sub(itemName,6,11)
	if hero.boss_particle then
		ParticleManager:DestroyParticle(hero.boss_particle,true)
	end
	hero.boss_particle = CreateParticle( "particles/player/"..particleName..".vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
	local R = RandomInt(0, 255)
	local G = RandomInt(0, 255)
	local B = RandomInt(0, 255)
	ParticleManager:SetParticleControl( hero.boss_particle, 1, Vector(R,G,B) )
end
function OnVipParticle( index, keys )
	local playerID = keys.PlayerID
	local hero = PlayerResource:GetPlayer(keys.PlayerID):GetAssignedHero()
	local id = keys.id
	if id ~= 0 then
		if hero.vip_particle then
			ParticleManager:DestroyParticle(hero.vip_particle,true)
		end
		hero.vip_particle = CreateParticle( "particles/player/"..id..".vpcf", PATTACH_ABSORIGIN_FOLLOW, hero )
	else
		if hero.vip_particle then
			ParticleManager:DestroyParticle(hero.vip_particle,true)
		end
	end
end
function HeroSelected( id,keys )
	local playerID = keys.PlayerID
	GuardingAthena.SelectedHeroName[playerID] = keys.hero
	local heroEntity = PlayerResource:GetPlayer(playerID):GetAssignedHero()
	PrecacheUnitByNameAsync(keys.hero,function()
		PlayerResource:ReplaceHeroWith(playerID,keys.hero,PlayerResource:GetGold(playerID),0)
		heroEntity:RemoveSelf()
	end)
end
function OnSelectDifficultyClick( id,keys )
	local playerID = keys.PlayerID
	CustomNetTables:SetTableValue( "difficulty", tostring(playerID), {difficulty=keys.difficulty} )
	local player = PlayerResource:GetPlayer(playerID)
	if keys.difficulty == "EasyButton" then
		GuardingAthena.SelectDifficulty[playerID] = 1
		player.difficulty_select = 1
	elseif keys.difficulty == "NormalButton" then
		GuardingAthena.SelectDifficulty[playerID] = 2
		player.difficulty_select = 2
	elseif keys.difficulty == "HardButton" then
		GuardingAthena.SelectDifficulty[playerID] = 3
		player.difficulty_select = 3
	elseif keys.difficulty == "DemonButton" then
		GuardingAthena.SelectDifficulty[playerID] = 4
		player.difficulty_select = 4
	elseif keys.difficulty == "TeamButton" then
		GuardingAthena.SelectDifficulty[playerID] = 5
		player.difficulty_select = 5
	end
end
function OnSelectClick( id,keys )
	local playerID = keys.PlayerID
	CustomNetTables:SetTableValue( "player_hero", tostring(playerID), {heroname=keys.hero} )
end
function OnSelectHover( id,keys )
	if keys.hero ~= "null" then
		--CustomNetTables:SetTableValue( "player", "heroname", {heroname=keys.hero} )
	end
end
function OnHpClick( index,keys )
	local goldcost = GuardingAthena.athena_hp_lv * 100 + 1000
    if PlayerResource:GetGold(keys.PlayerID) > goldcost and GuardingAthena.athena_hp_lv < 100 then
		PlayerResource:SpendGold( keys.PlayerID, goldcost, 0 )
		local hero = PlayerResource:GetPlayer(keys.PlayerID):GetAssignedHero()
		hero:SetBaseStrength(hero:GetBaseStrength() + RandomInt(1, 5))
		hero:CalculateStatBonus()
		GuardingAthena.athena_hp_lv = GuardingAthena.athena_hp_lv + 1
		GuardingAthena.entAthena:SetBaseMaxHealth(GuardingAthena.entAthena:GetBaseMaxHealth() + 1000)
		GuardingAthena.entAthena:SetMaxHealth(GuardingAthena.entAthena:GetMaxHealth() + 1000)
		GuardingAthena.entAthena:Heal(1000, nil) 
		return true
	else
		return false
	end
end
function OnRegenClick( index,keys )
	local goldcost = GuardingAthena.athena_regen_lv * 100 + 1000
    if PlayerResource:GetGold(keys.PlayerID) > goldcost and GuardingAthena.athena_regen_lv < 100 then
		PlayerResource:SpendGold( keys.PlayerID, goldcost, 0 )
		local hero = PlayerResource:GetPlayer(keys.PlayerID):GetAssignedHero()
	    hero:SetBaseIntellect(hero:GetBaseIntellect() + RandomInt(1, 5))
	    hero:CalculateStatBonus()
	    GuardingAthena.athena_regen_lv = GuardingAthena.athena_regen_lv + 1
		GuardingAthena.entAthena:SetBaseHealthRegen(GuardingAthena.entAthena:GetBaseHealthRegen() + 10)
		return true
	else
		return false
	end
end
function OnArmorClick( index,keys )
	local goldcost = GuardingAthena.athena_armor_lv * 100 + 1000
    if PlayerResource:GetGold(keys.PlayerID) > goldcost and GuardingAthena.athena_armor_lv < 100 then
		PlayerResource:SpendGold( keys.PlayerID, goldcost, 0 )
		local hero = PlayerResource:GetPlayer(keys.PlayerID):GetAssignedHero()
		hero:SetBaseAgility(hero:GetBaseAgility() + RandomInt(1, 5)) 
	    hero:CalculateStatBonus()
	    GuardingAthena.athena_armor_lv = GuardingAthena.athena_armor_lv + 1
		GuardingAthena.entAthena:SetPhysicalArmorBaseValue(GuardingAthena.entAthena:GetPhysicalArmorBaseValue() + 1)
		return true
	else
		return false
	end
end
function OnHgClick( index,keys )
         --index 是事件的index值
         --keys 是一个table，固定包含一个触发的PlayerID，其余的是传递过来的数据

        --[[for i,v in pairs(keys) do
        	print(tostring(i).."="..tostring(v))
    	end]]--
        local hero = PlayerResource:GetPlayer(keys.PlayerID):GetAssignedHero()
		local origin = GuardingAthena.entAthena:GetAbsOrigin()
		local point = Vector( origin.x + RandomInt(-200,200), origin.y + RandomInt(-200,200), origin.z )
		SetUnitPosition(hero, point)
		hero:Stop()
		PlayerResource:SetCameraTarget(keys.PlayerID, hero)
 		Timers:CreateTimer(0.1,
		    function()
		        PlayerResource:SetCameraTarget(keys.PlayerID, nil)
		    end)
end
function OnGiftPotion( index, keys )
	local potion_index = keys.index
	local playerid = keys.PlayerID
	local player = PlayerResource:GetPlayer(keys.PlayerID)
	player.potion_gift = true
end
function OnGoldGift( index, keys )
	local gold_index = keys.index
	local player = PlayerResource:GetPlayer(keys.PlayerID)
	--[[for i=1,#GOLD_USED_TABLE do
		if GOLD_USED_TABLE[i] == gold_index then
			return
		end	
	end
	table.insert(GOLD_USED_TABLE,gold_index)]]--
	player.gold_gift = true
end