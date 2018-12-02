-- DamageFilter
--[[
	bonus_magic_damage				百分比增加魔法伤害
	bonus_physical_damage			物理伤害穿透额外无视护甲伤害
    percent_bonus_damage			百分比增加/减少伤害输出
    victim.const_reduce_damage		减少固定值伤害
    percent_reduce_damage			减少百分比伤害
    dodge_damage					闪避所有伤害
	]]
function GuardingAthena:ExecuteOrderFilter( args )
	--PrintTable(args)
	local playerid = args.issuer_player_id_const
    -- 攻击指令
	if args.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET then
		local target = EntIndexToHScript( args.entindex_target )
		if target == self.entAthena then
			return false
		end
	end
	--[[ 给予物品
	if args.order_type == DOTA_UNIT_ORDER_GIVE_ITEM then
		
	end]]
	--[[ 禁止拆分
	if args.order_type == DOTA_UNIT_ORDER_DISASSEMBLE_ITEM then
		return false
	end]]
	-- 购买物品
	if args.order_type == DOTA_UNIT_ORDER_PURCHASE_ITEM then
		--[[for k, v in pairs( args ) do
			print( k, v )
		end]]--
 

		-- 属性书
        local tombTable = {
            id = {1002,1003,1004,1709,1710,1711},
            cost = {10000,10000,10000,95000,95000,95000},
            stat = {0,1,2,0,1,2},
            count = {10,10,10,100,100,100}
        }
        for i=1,6 do
            if args.entindex_ability == tombTable.id[i] then
                if PlayerResource:GetGold(playerid) >= tombTable.cost[i] then
                    PlayerResource:SpendGold( playerid, tombTable.cost[i], 0 )
                    local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero()
                    PropertySystem( hero, tombTable.stat[i], tombTable.count[i])
                    EmitSoundOn("DOTA_Item.Refresher.Activate", hero)
                    CreateParticle("particles/units/heroes/hero_dragon_knight/dragon_knight_transform_blue.vpcf",PATTACH_CUSTOMORIGIN_FOLLOW,hero,1)
                end
                return false
            end
        end
	end
	return true
end
function GuardingAthena:DamageFilter( args )
	--PrintTable(args)
	local damage = args.damage
	local damageType = args.damagetype_const
	local caster
	--[[if not args.entindex_attacker_const then
		if args.damage == EntIndexToHScript(args.entindex_victim_const):GetMaxHealth() then
			EntIndexToHScript(args.entindex_victim_const):RemoveSelf()
			return
		end
	end--]]
	if args.entindex_attacker_const then
		caster = EntIndexToHScript(args.entindex_attacker_const)
	else
		return
	end	
	local victim = EntIndexToHScript(args.entindex_victim_const)
	--修正智力伤害系数
	if args.entindex_inflictor_const then
		-- 不适用伤害修改的技能
		local ability = EntIndexToHScript(args.entindex_inflictor_const)
		if ability.no_damage_filter then
			return true
		end
		-- 修正智力伤害
		--[[if caster:IsRealHero() then
			local x = 0.0007
			if caster:GetPrimaryAttribute() == 2 then x = 0.00087 end
			args.damage = args.damage / (1 + caster:GetIntellect() * x)
		end]]
	end

	-- 特殊处理
	if caster.DamageFilterAttacker then
		for name,filter in pairs(caster.DamageFilterAttacker) do
			args.damage = filter(args.damage,victim)
		end
	end
	if victim.DamageFilterVictim then
		for name,filter in pairs(victim.DamageFilterVictim) do
			args.damage = filter(args.damage,caster)
		end
	end
	-- 魔法伤害
	if damageType == DAMAGE_TYPE_MAGICAL then
        -- 百分比增加魔法伤害
		if caster.bonus_magic_damage and caster.bonus_magic_damage > 0 then
			args.damage = args.damage * (1 + caster.bonus_magic_damage * 0.01)
		end
	end
	-- 物理伤害
	if damageType == DAMAGE_TYPE_PHYSICAL then
		-- 计算原始伤害
		local armor = victim:GetPhysicalArmorValue()
		local initdamage = args.damage
		if armor > 0 then
			local reduce = (armor * 0.052)/(0.9 + armor * 0.048)
			initdamage = args.damage / (1 - reduce)
		end
        -- 物理伤害穿透额外无视护甲伤害
		if caster.bonus_physical_damage then
			args.damage = initdamage
		end
	end
	-- 纯粹伤害
	if damageType == DAMAGE_TYPE_PURE then
		if caster:GetTeam() ~= DOTA_TEAM_GOODGUYS then
			local res = victim:GetBaseMagicalResistanceValue()
			args.damage = args.damage * (1 - res)
		end
	end
    -- 百分比增加/减少伤害输出
    if caster.percent_bonus_damage and caster.percent_bonus_damage ~= 0 then
        args.damage = args.damage * (1 + caster.percent_bonus_damage * 0.01)
	end
	-- 护盾
	if victim.ShieldFilter then
		args.damage = victim.ShieldFilter(args.damage,victim)
	end
    -- 减少固定值伤害
    if victim.const_reduce_damage and victim.const_reduce_damage > 0 then
        args.damage = args.damage - victim.const_reduce_damage
	end
	-- 增加百分比伤害
    if victim.percent_increase_damage and victim.percent_increase_damage > 0 then
        args.damage = args.damage * (1 + victim.percent_increase_damage * 0.01)
    end
    -- 减少百分比伤害
	if victim.percent_reduce_damage and victim.percent_reduce_damage > 0 then
		local reduce = victim.percent_reduce_damage
		if reduce > 99 then
			reduce = 99
		end
        args.damage = args.damage * (1 - reduce * 0.01)
    end
	-- 技能伤害处理
	if args.entindex_inflictor_const then
		if caster.ability_critical_chance then
			if RollPercentage(caster.ability_critical_chance) then
				args.damage = args.damage * (1 + caster.ability_critical_damage * 0.01)
				CreateNumberEffect(victim,args.damage,1,MSG_ORIT ,{0,153,255},4)
			end
		end
	end
    -- 闪避所有伤害
    if victim.dodge_damage then
        return false
	end
	-- 重生
	if victim.resurrection then
		if args.damage > victim:GetHealth() then
			args.damage = victim.resurrection(args.damage)
		end
	end
    -- 伤害记录
	if caster:IsRealHero() then
		if victim == Spawner.bossCurrent then
			caster.boss_damage = caster.boss_damage + args.damage
		end
	end
	if victim:IsRealHero() then
		if caster.wave then
			local wave = caster.wave
			Spawner.damageRecorder[wave] = Spawner.damageRecorder[wave] + args.damage
		end
	end
	return true
end
function GuardingAthena:ItemAddedFilter( keys )
	--PrintTable(keys)
	--print(EntIndexToHScript(keys.item_entindex_const):GetAbilityName())
	--keys.item_parent_entindex_const = keys.inventory_parent_entindex_const
	--keys.suggested_slot = RandomInt(0,11)
	local currentItem = EntIndexToHScript(keys.item_entindex_const)
	local currentItemName = currentItem:GetAbilityName()
	local currentUnit = EntIndexToHScript(keys.inventory_parent_entindex_const)
	local itemOwner = EntIndexToHScript(keys.item_parent_entindex_const)
	if currentItemName == "item_chaos_plate" then
		if RollPercentage(5) then
			currentUnit:AddItem(CreateItem("item_world_editor", currentUnit, currentUnit))
			currentItem:RemoveSelf()
			return false
		elseif RollPercentage(5) then
			currentUnit:AddItem(CreateItem("item_longinus_spear", currentUnit, currentUnit))
			currentItem:RemoveSelf()
			return false
		elseif RollPercentage(5) then
			currentUnit:AddItem(CreateItem("item_mystletainn", currentUnit, currentUnit))
			currentItem:RemoveSelf()
			return false
		elseif RollPercentage(5) then
			currentUnit:AddItem(CreateItem("item_yata_mirror", currentUnit, currentUnit))
			currentItem:RemoveSelf()
			return false
		end
	end
	-- 原核与金袋
	if string.sub(currentItemName,0,14) == "item_original_" then
		return true
	elseif currentItemName == "item_bag_of_gold" then
		local playerID
		if currentUnit:IsRealHero() then
			playerID = currentUnit:GetPlayerID()
		else
			playerID = currentUnit.currentHero:GetPlayerID()
		end
		PlayerResource:ModifyGold(playerID,5000, true, 0)
		currentItem:RemoveSelf()
		return false
	-- 专属装备
	elseif currentItemName == "item_zhuanshu" then
		local currentUnitName = currentUnit:GetUnitName()
		local newItemName = "item_"..currentUnitName
		local item = CreateItem(newItemName, currentUnit, currentUnit)
		currentUnit:AddItem(item)
		for i=0,14 do
			local slotItem = currentUnit:GetItemInSlot(i)
			if slotItem == item then
				currentUnit:SwapItems(i,15)
				item:ApplyDataDrivenModifier(currentUnit, currentUnit, "modifier_"..currentUnitName, {})
			end
		end
		currentItem:RemoveSelf()
		return false
	elseif currentItemName == "item_ring_shop" then
		--[[
			6-8     晨辉      生命魔法回复6%/s          晨辉+宝石       受到伤害时有25%%的几率回复10%%的生命
			8-12    宝石      每次击杀+10金钱           晨辉+黑夜       施放技能有25%%的几率减少50%%的冷却
			12-18   恶魔      提升10%主属性             恶魔+黑夜       每次施法提升10%%的主属性，持续10秒          
			18-24   石化      减少10%的伤害             恶魔+石化       攻击者减少60%%攻击力
			0-2     诡丝      增加50%的伤害             石化+诡丝       受到伤害时有15%%的几率反弹伤害比例
			2-6     黑夜      减少1秒技能冷却           宝石+黑夜       每击杀一个单位减少1秒的技能冷却，内置冷却2秒
		]]
		local timeTable = {
			am0 = 0,
			am2 = 0.08299,
			am6 = 0.25099,
			am8 = 0.33419,
			am12 = 0.50059,
			pm18 = 0.75019,
			pm24 = 0.99979
		}
		local ringTable = {
			ringName = {"item_ring_1","item_ring_2","item_ring_3","item_ring_4","item_ring_5","item_ring_6"},
			timeStart = {timeTable.am6,timeTable.am8,timeTable.am12,timeTable.pm18,timeTable.am0,timeTable.am2},
			timeOver = {timeTable.am8,timeTable.am12,timeTable.pm18,timeTable.pm24,timeTable.am2,timeTable.am6},
		}
		-- 满格取消
		--[[if IsFullSolt(currentUnit,12,true) then
			DropItem(currentItem,currentUnit)
			return false
		end]]--
		local time = GameRules:GetTimeOfDay()
		if currentUnit.ringCount < 2 then
			for i=1,6 do
				if time > ringTable.timeStart[i] and time < ringTable.timeOver[i] then
					local item = CreateItem(ringTable.ringName[i], currentUnit, currentUnit)
					currentUnit:AddItem(item)
				end
			end
			currentUnit.ringCount = currentUnit.ringCount + 1
			currentItem:RemoveSelf()
			return false
		else
			currentUnit.def_point = currentUnit.def_point + 1200
			Notifications:Bottom(currentUnit:GetPlayerID(), {text="#ring_limit", style={color="red"}, duration=1, continue = false})
			currentItem:RemoveSelf()
			return false
		end
		return false
	elseif string.sub(currentItemName,0,10) == "item_ring_" then
		if currentUnit:IsRealHero() then
			local id = tonumber(string.sub(currentItemName,11,12))
			if type(id) == "number" then
				table.insert(currentUnit.ringList,id)
			end
		end
	elseif currentItemName == "item_athena_momian" then
		local athena = self.entAthena
		local ability = athena:FindAbilityByName("athena_heal")
		ability:ApplyDataDrivenModifier(athena, athena, "modifier_athena_heal_3", nil)
		return false
	elseif currentItemName == "item_athena_wudi" then
		local athena = self.entAthena
		local ability = athena:FindAbilityByName("athena_heal")
		ability:ApplyDataDrivenModifier(athena, athena, "modifier_athena_heal_2", nil)
		return false
	elseif currentItemName == "item_athena_heal" then
		AthenaHeal( currentUnit,currentItem )
		return false
	elseif currentItemName == "item_athena_guard" then
		AthenaGuard()
		return false
	elseif currentItemName == "item_salve1_pack" or currentItemName == "item_clarity1_pack" then
		local itemName = "item_salve1"
		if string.sub(currentItemName,0,13) == "item_clarity1" then
			itemName = "item_clarity1"
		end
		local item = CreateItem(itemName, currentUnit, currentUnit)
		local itemBuyTime = currentItem:GetPurchaseTime()
		item:SetCurrentCharges(50)
		item:SetPurchaseTime(itemBuyTime-10)
		currentUnit:AddItem(item)
		currentItem:RemoveSelf()
		return false
	else
		if currentUnit:IsRealHero() then 	-- 英雄拾取
			if itemOwner == currentUnit then 	-- 是自己的物品
				currentItem.currentUnitName = currentUnit:GetUnitName() 	--物品绑定单位
				if ItemTypeCheck(currentUnit,currentItem) then 	--重复装备判定
					return false
				else
					return true
				end
			else 	-- 不是自己的物品
				if currentItem.currentUnitName ~= currentUnit:GetUnitName() then
					if not IsFullSolt(currentUnit,12,true) then
						local itemBuyTime = currentItem:GetPurchaseTime()
						local itemCharge = currentItem:GetCurrentCharges()
						local item = CreateItem(currentItemName, currentUnit, currentUnit)
						item.currentUnitName = currentUnit:GetUnitName()
						item:SetCurrentCharges(itemCharge)
						item:SetPurchaseTime(itemBuyTime)
						currentUnit:AddItem(item)
						currentItem:RemoveSelf()
						return false
					end
				end
			end
		else 	-- 信使拾取
			if itemOwner == currentUnit then
				--currentItem.currentUnitName = currentUnit:GetUnitName()
				return true
			else
				if GameRules:GetGameTime() - currentItem:GetPurchaseTime() < 10 then
					if currentItem.currentUnitName ~= currentUnit.currentHero:GetUnitName() then
						DropItem(currentItem, currentUnit)
						Notifications:Bottom(currentUnit.currentHero:GetPlayerID(), {text="#courier_cant_pick", style={color="red"}, duration=2, continue = false})
						return false
					end
				else
					if currentItemName == "item_battlefury_ring" then
						DropItem(currentItem, currentUnit)
						return false
					else
						if currentItem.currentUnitName ~= currentUnit:GetUnitName() then
							if not IsFullSolt(currentUnit,6,true) then
								local itemBuyTime = currentItem:GetPurchaseTime()
								local itemCharge = currentItem:GetCurrentCharges()
								local item = CreateItem(currentItemName, currentUnit.currentHero, currentUnit.currentHero)
								item.currentUnitName = currentUnit:GetUnitName()
								item:SetCurrentCharges(itemCharge)
								item:SetPurchaseTime(itemBuyTime)
								currentUnit:AddItem(item)
								currentItem:RemoveSelf()
								return false
							end
						end
					end
				end
			end
		end
	end
	return true
end
function GuardingAthena:ModifyExperienceFilter( keys )
	--PrintTable(keys)
	local playerID = keys.player_id_const
	local hero = PlayerResource:GetPlayer(playerID):GetAssignedHero()
	local reborntimes = hero.reborn_time or 0
	if hero:GetLevel() >= (reborntimes + 1) * 100 then
		keys.experience = 0
		return true
	end
	if keys.reason_const == 2 then
		if hero.reborn_time then
			keys.experience = keys.experience * (hero.reborn_time * 0.5 + 1.25)
		end
		if hero.single then
			keys.experience = keys.experience + 10
		end
		if hero.exp_rate then
			keys.experience = keys.experience * (1 + hero.exp_rate * 0.01)
		end
	end
	return true
end
function GuardingAthena:ModifyGoldFilter( keys )
	--PrintTable(keys)
	local playerID = keys.player_id_const
	local hero = PlayerResource:GetPlayer(playerID):GetAssignedHero()
	if keys.reason_const == DOTA_ModifyGold_CreepKill then
		if hero.reborn_time then
			keys.gold = keys.gold * (hero.reborn_time * 0.1 + 1) + hero.reborn_time * 2
		end
		if hero.single then
			keys.gold = keys.gold + 5
		end
		if hero.gold_rate then
			keys.gold = keys.gold * (1 + hero.gold_rate * 0.01)
		end
	end
	hero.total_gold = hero.total_gold + keys.gold
	local playerGold = PlayerResource:GetGold(playerID)
	if playerGold >= 95000 then
		self.player_gold_save[playerID + 1] = self.player_gold_save[playerID + 1] + keys.gold
		PlayerResource:SpendGold( playerID, keys.gold, 0 )
	end
	return true
end