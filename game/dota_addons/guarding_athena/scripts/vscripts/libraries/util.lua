--[[
	AddDamageFilterAttacker(caster,name,callback)
	AddDamageFilterVictim(caster,name,callback)
	AddModifierStackCount(caster,target,ability,modiferName,count,duration,independent)
	CastAbility(caster,orderType,ability,target,position)
	CauseDamage(attacker,victim,damage,damageType,ability,~criticalChance,~criticalDamage)
	ClearBuff(caster,buffType,count)
	Cleave(caster,target,damage,radius,percent)
	CreateSound(soundName,caster,~location,~duration,~delay)
	CreateParticle(particleName,particleAttach,owningEntity,~duration,~immediately)
	CreateLinearProjectile(caster,ability,particleName,spawnOrigin,radius,distance,direction,speed,deleteOnHit)
	CreateTrackingProjectile(caster,target,ability,particleName,speed,~dodgeable,~vision,~visionRadius,~attach)
	CreateNumberEffect(entity,number,duration,msg_type,color,icon_type)
	DeepCopy(table)
	DropItem(item,hero)
	ForWithInterval(count,interval,callback)
	GetExclusive(caster)
	GetOriginalDamage(damage,target)
	GetUnitsInRadius(caster,ability,point,radius)
	GetUnitsInLine(caster,ability,start_point,end_point,width)
	GetUnitsInSector(cacheUnit,ability,position,forwardVector,angle,radius)
	GetRandomPoint(originPoint, minRadius, maxRadius)
	GetRandomUnit(caster, ability, originPoint, radius)
	GetRebornCount(caster)
	GetRotationPoint(originPoint, radius, angle)
	GiveItem(caster,itemName,itemOwner)
	HasExclusive(caster,lv)
	Heal(caster,heal,mana,show)
	IsFullSolt(caster,bagType,tip)
	IsModifierType(caster,buffName,type)
	ItemTypeCheck(caster,item)
	Jump(caster,target_location,speed,height,findPath,callback)
	KnockBack(caster,direction,distance,duration)
	PropertySystem(caster,property,count,duration)
	PrintTable(table)
	RemoveDamageFilterAttacker(caster,name)
	RemoveDamageFilterVictim(caster,name)
	RemoveHealth(caster,health)
	RollDrops(unit)
	SetMaxHealth(caster,value)
	SetModelScale(caster,scale,smooth,duration)
	SetModifierType(caster,buff,type)
	SetUnitPosition(caster,position,setPos)
	SetUnitDamagePercent(caster,percent,duration)
	SetUnitMagicDamagePercent(caster,percent,duration)
	SetUnitIncomingDamageDeepen(caster,percent,duration)
	SetUnitIncomingDamageReduce(caster,percent,duration)
	SetCamera(playerID,arg)
	SetRegionLimit(caster,regionEntity)
	SetBaseResistance(caster,resistance,duration)
	string.split
	Teleport(caster,position)
]]
function CastAbility( ... )
	local caster,orderType,ability,target,position = ...
	if target then target = target:entindex() end
	if ability:IsCooldownReady() and not ability:IsChanneling() then
		local t_order = 
		{
			UnitIndex = caster:entindex(),
			OrderType = orderType,
			TargetIndex = target,
			AbilityIndex = ability:entindex(),
			Position = position,
			Queue = 0
		}
		caster:SetContextThink(DoUniqueString("order") , function() ExecuteOrderFromTable(t_order) end, 0.1)
	end
end
-- 造成伤害
-- 填写ability会判定为技能伤害
-- 暴击率以百分比计算
function CauseDamage( ... )
	local attacker,victim,damage,damageType,ability,criticalChance,criticalDamage = ...
	if attacker:IsNull() then
		return
	end
	-- 修正伤害
	if attacker:GetTeam() ~= DOTA_TEAM_GOODGUYS and damageType == DAMAGE_TYPE_MAGICAL then
		damageType = DAMAGE_TYPE_PURE
	end
	
	if IsValidEntity(victim) then
		if victim:IsAlive() == false then
			return
		end
		if criticalChance then
			if RollPercentage(criticalChance) then
				damage = damage * criticalDamage * 0.01
				CreateNumberEffect(victim,damage,1,MSG_ORIT ,"red",4)
			end
		end
		-- 修正伤害
		if attacker:GetTeam() ~= DOTA_TEAM_GOODGUYS then
			local res = victim:GetBaseMagicalResistanceValue() or 0
			damage = damage * (1 - res)
		end

		local damageTable = {victim = victim,attacker = attacker,damage = damage,damage_type = damageType,ability = ability}
		ApplyDamage(damageTable)
	else
		for k,v in pairs(victim) do
			if v:IsAlive() then
				if criticalChance then
					if RollPercentage(criticalChance) then
						local currentDamage = damage * criticalDamage * 0.01
						CreateNumberEffect(v,currentDamage,1,MSG_ORIT ,"red",4)
					end
				end
				-- 修正伤害
				if attacker:GetTeam() ~= DOTA_TEAM_GOODGUYS then
					local res = v:GetBaseMagicalResistanceValue() or 0
					damage = damage * (1 - res)
				end
				local damageTable = {victim = v,attacker = attacker,damage = damage,damage_type = damageType,ability = ability}
				ApplyDamage(damageTable)
			end
		end
	end
end
-- 恢复生命与魔法
function Heal( ... )
	local caster,heal,mana,show = ...
	if show == nil then
		show = true
	end
	if caster:IsAlive()~=true then
		return nil
	end
	if heal and heal ~= 0 then
		if show then
			CreateNumberEffect(caster,heal,1,MSG_HEAL,'green',0)
		end
		caster:Heal(heal, nil)
	end
	if mana and mana ~=0 then
		if show then
			CreateNumberEffect(caster,mana,1,MSG_HEAL,{0,128,255},0)
		end
		caster:GiveMana(mana)
	end
end
-- 基础属性值系统
function PropertySystem( ... )
	local caster,property,count,duration = ...
	if property == 0 then
		caster:ModifyStrength(count)
	elseif property == 1 then
		caster:ModifyAgility(count)
	elseif property == 2 then
		caster:ModifyIntellect(count)
	elseif property == 3 then
		caster:ModifyStrength(count)
		caster:ModifyAgility(count)
		caster:ModifyIntellect(count)
	end
	if duration then
		Timers:CreateTimer(duration,function ()
		 	if property == 0 then
			 	caster:ModifyStrength(-count)
			elseif property == 1 then
				caster:ModifyAgility(-count)
			elseif property == 2 then
				caster:ModifyIntellect(-count)
			elseif property == 3 then
				caster:ModifyStrength(-count)
				caster:ModifyAgility(-count)
				caster:ModifyIntellect(-count)
			end
		end)
	end
end
--给单位添加伤害过滤器
function AddDamageFilterAttacker( ... )
	local caster,name,callback = ...
	if not caster.DamageFilterAttacker then caster.DamageFilterAttacker = {} end
	caster.DamageFilterAttacker[name] = callback
end
--给单位添加伤害过滤器
function AddDamageFilterVictim( ... )
	local caster,name,callback = ...
	if not caster.DamageFilterVictim then caster.DamageFilterVictim = {} end
	caster.DamageFilterVictim[name] = callback
end
-- 增加modifier叠加数量
function AddModifierStackCount( ... )
    local caster,target,ability,modiferName,count,duration,independent = ...
    if not target:IsAlive() then
		return
	end
    local durationTable = {Duration=duration}
    if duration == nil then
        durationTable = {}
    end
    if count == nil then
        count = 1
    end
	if independent then
		if target:HasModifier(modiferName) then
			local stackcount = target:GetModifierStackCount(modiferName, caster)
			ability:ApplyDataDrivenModifier(caster, target, modiferName, {})
			target:SetModifierStackCount(modiferName, caster, stackcount + count)
		else
			ability:ApplyDataDrivenModifier(caster, target, modiferName, {})
			target:SetModifierStackCount(modiferName, caster, count)
		end
		Timers:CreateTimer(duration,function ()
			if not target:IsNull() then
				local stackcount = target:GetModifierStackCount(modiferName, ability)
				if count >= stackcount then
					target:RemoveModifierByName(modiferName)
				else
					target:SetModifierStackCount(modiferName, caster, stackcount - count)
				end
			end
		end)
	else
		if target:HasModifier(modiferName) then
			local stackcount = target:GetModifierStackCount(modiferName, caster)
			ability:ApplyDataDrivenModifier(caster, target, modiferName, durationTable)
			target:SetModifierStackCount(modiferName, caster, stackcount + count)
		else
			ability:ApplyDataDrivenModifier(caster, target, modiferName, durationTable)
			target:SetModifierStackCount(modiferName, caster, count)
		end
	end
end
--创建带有计时器的特效，计时器结束删除特效
function CreateParticle(...)
	local particleName,particleAttach,owningEntity,duration,immediately = ...
	if immediately == nil then
		immediately = false
	end
	local pID = ParticleManager:CreateParticle(particleName,particleAttach,owningEntity)
	if duration then
		Timers:CreateTimer(duration,function ()
			ParticleManager:DestroyParticle(pID,immediately)
			ParticleManager:ReleaseParticleIndex(pID)
		end)
	end
	return pID
end
-- 创建跟踪投射物
function CreateTrackingProjectile( ... )
	local caster,target,ability,particleName,speed,dodgeable,vision,visionRadius,attach = ...
	if dodgeable == nil then
		dodgeable = true
	end
	if vision == nil then
		vision = false
	end
	if visionRadius == nil then
		visionRadius = 0
	end
	if attach == nil then
		attach = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
	end
	local info = {
		Target = target,
		Source = caster,
		Ability = ability,
		EffectName = particleName,
		bDodgeable = dodgeable,
		bProvidesVision = vision,
		iMoveSpeed = speed,
		iVisionRadius = visionRadius,
		iVisionTeamNumber = caster:GetTeamNumber(),
		iSourceAttachment = attach
	}
	if target:IsAlive() then
		ProjectileManager:CreateTrackingProjectile( info )
	end
end
-- 创建跟踪投射物
function CreateLinearProjectile( ... )
	local caster,ability,particleName,spawnOrigin,radius,distance,direction,speed,deleteOnHit = ...
	local projID = ProjectileManager:CreateLinearProjectile( {
	        Ability             = ability,
	        EffectName          = particleName,
	        vSpawnOrigin        = spawnOrigin,
	        fDistance           = distance,
	        fStartRadius        = radius,
	        fEndRadius          = radius,
	        Source              = caster,
	        iUnitTargetTeam     = ability:GetAbilityTargetTeam(),
	        iUnitTargetFlags    = ability:GetAbilityTargetFlags(),
	        iUnitTargetType     = ability:GetAbilityTargetType(),
	        fExpireTime         = GameRules:GetGameTime() + distance / speed,
	        bDeleteOnHit        = deleteOnHit,
	        vVelocity           = direction * speed,
	        bProvidesVision     = false,
	    } )
	return projID
end
-- 获取专属装备
function GetExclusive( ... )
	local caster = ...
	local exclusive = caster.exclusive or false
	return exclusive
end
-- 获取原始伤害
function GetOriginalDamage( ... )
	local damage,target = ...
	local armor = target:GetPhysicalArmorValue()
    local reduce = (armor * 0.052)/(0.9 + armor * 0.048)
	local initDamage = damage / (1 - reduce)
	return initDamage
end
-- 寻找圆形范围单位
function GetUnitsInRadius( ... )
	local caster,ability,point,radius = ...
	local teamNumber = caster:GetTeamNumber()
	local targetTeam = ability:GetAbilityTargetTeam()
	local targetType = ability:GetAbilityTargetType()
	local targetFlag = ability:GetAbilityTargetFlags()
	local unitGroup = FindUnitsInRadius(teamNumber, point, caster, radius, targetTeam, targetType, targetFlag, 0, false)
    return unitGroup
end
-- 创建物品给单位
function GiveItem( ... )
	local caster,itemName,itemOwner = ...
	if itemOwner == nil then
		itemOwner = caster
	end
	if IsFullSolt( caster, 12, true ) == false then
		local newItem = CreateItem(itemName, itemOwner, itemOwner)
		caster:AddItem(newItem)
		return newItem
	else
		return false
	end
end
-- 寻找直线范围单位
function GetUnitsInLine( ... )
	local caster,ability,start_point,end_point,width = ...
	local teamNumber = caster:GetTeamNumber()
	local targetTeam = ability:GetAbilityTargetTeam()
	local targetType = ability:GetAbilityTargetType()
	local targetFlag = ability:GetAbilityTargetFlags()
	local unitGroup = FindUnitsInLine( teamNumber, start_point, end_point, caster, width, targetTeam, targetType, targetFlag)
    return unitGroup
end
-- 寻找扇形单位
function GetUnitsInSector( ... )
	local cacheUnit,ability,position,forwardVector,angle,radius = ...
	local teamNumber = cacheUnit:GetTeamNumber()
	local teamFilter = ability:GetAbilityTargetTeam()
	local typeFilter = ability:GetAbilityTargetType()
	local flagFilter = ability:GetAbilityTargetFlags()
	local unitGroup = FindUnitsInRadius( teamNumber, position, cacheUnit, radius, teamFilter, typeFilter, flagFilter, 0, false )
	local returnGroup = {}
	for k, v in pairs( unitGroup ) do
		local unitPosition = v:GetAbsOrigin()
		local unitVector = unitPosition - position
		local NAN = math.floor(unitVector:Dot(forwardVector) / math.sqrt((unitVector.x ^ 2 + unitVector.y ^ 2) * (forwardVector.x ^ 2 + forwardVector.y ^ 2)))
		--print("nan:"..nan)
		if NAN == 1 then
			table.insert( returnGroup, v )
			--print("nan")
		else
			local unitAngle = math.abs(math.deg(math.acos( unitVector:Dot(forwardVector) / math.sqrt((unitVector.x ^ 2 + unitVector.y ^ 2) * (forwardVector.x ^ 2 + forwardVector.y ^ 2)))))
			--print("angle:"..unitAngle)
			--print("dot:"..unitVector:Dot(forwardVector))
			--print("acos"..( unitVector:Dot(forwardVector) / math.sqrt((unitVector.x ^ 2 + unitVector.y ^ 2) * (forwardVector.x ^ 2 + forwardVector.y ^ 2))))
			local deleteAngle = angle * 0.5
			if unitAngle < deleteAngle then
				table.insert( returnGroup, v )
				--print("units:"..#returnGroup)
			end
		end
	end
    return returnGroup
end
-- 丢弃物品
function DropItem( item, hero )
    -- Error Sound
    EmitSoundOnClient("General.CastFail_InvalidTarget_Hero", hero:GetPlayerOwner())
    -- Create a new empty item
    local newItem = CreateItem( item:GetName(), nil, nil )
    newItem:SetPurchaseTime(item:GetPurchaseTime())
    newItem:SetCurrentCharges( item:GetCurrentCharges() )
    -- Make a new item and launch it near the hero
    local spawnPoint = Vector( 0, 0, 0 )
    spawnPoint = hero:GetAbsOrigin()
    local drop = CreateItemOnPositionSync( spawnPoint, newItem )
    newItem:LaunchLoot( false, 200, 0.75, spawnPoint + RandomVector( RandomFloat( 50, 150 ) ) )
    --finally, remove the item
    hero:RemoveItem(item)
    return newItem
end
-- 带延迟for循环
function ForWithInterval( count,interval,callback )
	local temp = 0
	Timers:CreateTimer(function ()
		if temp < count then
			temp = temp + 1
			callback()
		end
		return interval 
	end)
end
--给攻击单位删除伤害过滤器
function RemoveDamageFilterAttacker( ... )
	local caster,name = ...
	caster.DamageFilterAttacker[name] = nil
end
--给受伤单位删除伤害过滤器
function RemoveDamageFilterVictim( ... )
	local caster,name = ...
	caster.DamageFilterVictim[name] = nil
end
-- 生命移除
function RemoveHealth( ... )
	local caster,health = ...
	local currentHealth = caster:GetHealth()
	if currentHealth > health then
		caster:SetHealth(currentHealth - health)
	else
		caster:SetHealth(1)
	end
end
-- 随机掉落物品
function RollDrops(unit)
    local DropInfo = GameRules.DropTable[unit:GetUnitName()]
    if DropInfo then
        --print("Rolling Drops for "..unit:GetUnitName())
        for k,ItemTable in pairs(DropInfo) do
            local item_name
            if ItemTable.ItemSets then
                local count = 0
                for i,v in pairs(ItemTable.ItemSets) do
                    count = count+1
                end
                local random_i = RandomInt(1,count)
                item_name = ItemTable.ItemSets[tostring(random_i)]
            else
                item_name = ItemTable.Item
            end
            local chance = ItemTable.Chance or 100
			-- 修改宝石掉率
            if string.find(item_name, "baoshi") then
            	local Players = PlayerResource:GetPlayerCountForTeam( DOTA_TEAM_GOODGUYS )
            	chance = chance + Players * 15
            end
            local max_drops = ItemTable.Multiple or 1
            for i=1,max_drops do
                if RollPercentage(chance) then
                    local item = CreateItem(item_name, nil, nil)
                    item:SetPurchaseTime(GameRules:GetGameTime())
                    local pos = unit:GetAbsOrigin()
                    local drop = CreateItemOnPositionSync( pos, item )
                    local pos_launch = pos+RandomVector(RandomFloat(0,50))
                    item:LaunchLoot(false, 200, 0.75, pos_launch)
                end
            end
        end
    end
end
-- 创建音效
function CreateSound( ... )
	local soundName,caster,location,duration,delay = ...
	if location then
		if type(location) == "userdata" then
			if delay == nil then
				delay = 0
			end
			Timers:CreateTimer(delay,function (  )
				EmitSoundOnLocationWithCaster(location,soundName,caster)
			end)
		elseif type(location) == "number" then
			delay = duration or 0
			duration = location
			Timers:CreateTimer(delay,function (  )
				EmitSoundOn(soundName,caster)
			end)
		end
	else
		EmitSoundOn(soundName,caster)
	end
	if duration then
		Timers:CreateTimer(duration,function (  )
			StopSoundOn(soundName,caster)
		end)
	end
end
-- 选取范围内随机点
function GetRandomPoint( ... )
	local originPoint, minRadius, maxRadius = ...
	local minDistance = minRadius
    local maxDistance = maxRadius
	local castDistance = RandomInt( minDistance, maxDistance )
    local angle = RandomInt( 0, 90 )
    local dy = castDistance * math.sin( angle )
    local dx = castDistance * math.cos( angle )
    local attackPoint = Vector( 0, 0, 0 )
    attackPoint = Vector( originPoint.x - dx, originPoint.y + dy, originPoint.z )
    return attackPoint
end
function GetRandomUnit( ... )
	local caster,ability,originPoint,radius = ...
	local unitGroup = GetUnitsInRadius(caster,ability,originPoint,radius)
	if #unitGroup > 0 then
		local index = RandomInt(1, #unitGroup)
		return unitGroup[index]
	else
		return false
	end
end
-- 获取单位转生次数
function GetRebornCount( ... )
	local caster = ...
	return caster.reborn_time or 0
end
-- 获取旋转后的点
function GetRotationPoint( ... )
	local originPoint, radius, angle = ...
	local radAngle = math.rad(angle)
	local x = math.cos(radAngle) * radius + originPoint.x
	local y = math.sin(radAngle) * radius + originPoint.y
	local position = Vector(x, y, originPoint.z)
	return position
end
-- 清除buff
function ClearBuff( ... )
	local caster,buffType,count = ...
	if count == nil then
		count = caster:GetModifierCount()
	end
	allBuffs = caster:FindAllModifiers()
	if buffType == "buff" then
		for i=1,count do
			if allBuffs[i]:IsDebuff() == false and allBuffs[i]:IsPurgable() then
				caster:RemoveModifierByName(caster:GetModifierNameByIndex(i))
			end
		end
	end
	if buffType == "debuff" then
		for i=1,count do
			local buffName = caster:GetModifierNameByIndex(i-1)
			local buff = caster:FindModifierByName(buffName)
			if buff and IsModifierType(caster,buffName,"unpurgable") == false then
				local owner = buff:GetCaster()
				if owner then
					if owner:GetTeamNumber() ~= caster:GetTeamNumber() then
						caster:RemoveModifierByName(buffName)
					end
				else
					caster:RemoveModifierByName(buffName)
				end
			end
			--[[if buff:IsDebuff() and buff:IsPurgable() then
			end]]
			--print(buff:GetName())
		end
	end
	if buffType == "stun" then
		for i=1,count do
			local buffName = caster:GetModifierNameByIndex(i-1)
			local buff = caster:FindModifierByName(buffName)
			if buff and IsModifierType(caster,buffName,"stun") then
				local owner = buff:GetCaster()
				if owner then
					if owner:GetTeamNumber() ~= caster:GetTeamNumber() then
						caster:RemoveModifierByName(buffName)
					end
				else
					caster:RemoveModifierByName(buffName)
				end
			end
		end
	end
end
function Cleave( ... )
	local caster,target,damage,radius,percent = ...
	local casterLoc = caster:GetAbsOrigin()
	local targetLoc = target:GetAbsOrigin()
	local direction = (targetLoc - casterLoc):Normalized()
	local point = casterLoc + direction * radius
	local teamNumber = caster:GetTeamNumber()
	local targetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY
	local targetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	local targetFlag = DOTA_UNIT_TARGET_FLAG_NONE
	local unitGroup = FindUnitsInRadius(teamNumber, point, caster, radius, targetTeam, targetType, targetFlag, 0, false)
	damage = damage * percent * 0.01
	for k,v in pairs(unitGroup) do
        if v ~= target then
            CauseDamage(caster,v,damage,DAMAGE_TYPE_PURE,nil)
        end
    end
end
-- 设置区域限制
function SetRegionLimit( ... )
	local caster,regionEntity = ...
	local regionPos = regionEntity:GetAbsOrigin()
	local boundingMax = regionEntity:GetBoundingMaxs()
	local boundingMin = regionEntity:GetBoundingMins()
	local width = boundingMax.x - boundingMin.x
	local height = boundingMax.y - boundingMin.y
	local limitRegion = {}
	limitRegion.Top = regionPos.y + height / 2
	limitRegion.bottom = regionPos.y - height / 2
	limitRegion.left = regionPos.x - width / 2
	limitRegion.right = regionPos.x + width / 2
	caster.limitRegion = limitRegion
end
-- 设置单位魔抗
function SetBaseResistance( ... )
	local caster,resistance,duration = ...
	local temp = caster:GetBaseMagicalResistanceValue()
	caster:SetBaseMagicalResistanceValue(resistance)
	if duration then
		Timers:CreateTimer(duration,function ()
			caster:SetBaseMagicalResistanceValue(temp)
		end)
	end
end
-- 设置生命上限
function SetMaxHealth( ... )
	local caster,value = ...
	caster:SetBaseMaxHealth(value)
	caster:SetMaxHealth(value)
	caster:SetHealth(value)
end
-- 设置单位模型
function SetModelScale( ... )
	local caster,scale,smooth,duration = ...
	if not smooth then smooth = true end
	local scaleDifference = scale - caster:GetModelScale()
	local scaleInterval = scaleDifference * 0.1 
	local c = 0
	if smooth then
		Timers:CreateTimer(function ()
			if c < 10 then
				caster:SetModelScale(caster:GetModelScale() + scaleInterval)
				c = c + 1
				return 0.05
			end
		end)
	else
		caster:SetModelScale(scale)
	end
	if duration then
		local d = 0
		if smooth then
			Timers:CreateTimer(duration,function ()
				if d < 10 then
					caster:SetModelScale(caster:GetModelScale() - scaleInterval)
					d = d + 1
					return 0.05
				end
			end)
		else
			caster:SetModelScale(caster:GetModelScale() - scaleDifference)
		end
	end
end
-- 设置buff类型
--[[ type = ["stun"	"晕眩"
			"unpurgable"	"不可净化"]
]]
function SetModifierType( ... )
	local caster,buffName,type = ...
	local buff = caster:FindModifierByName(buffName)
	if buff then
		if not buff.type then buff.type = {} end
		buff.type[type] = true
	end
end
-- 设置单位位置
function SetUnitPosition( ... )
	local caster,position,setPos = ...
	if position.z<-1000 then
		position.z = 0
	end
	if caster.limitRegion then
		local limitRegion = caster.limitRegion
		if position.x > limitRegion.right then
			position.x = limitRegion.right
		elseif position.x < limitRegion.left then
			position.x = limitRegion.left
		end
		if position.y > limitRegion.Top then
			position.y = limitRegion.Top
		elseif position.y < limitRegion.bottom then
			position.y = limitRegion.bottom
		end
	end
	if setPos then
		caster:SetAbsOrigin(position)
	else
		FindClearSpaceForUnit(caster, position, false)
	end
end
-- 设置单位百分比伤害输出
function SetUnitDamagePercent( ... )
	local caster,percent,duration = ...
	if caster.percent_bonus_damage == nil then
		caster.percent_bonus_damage = 0
	end
	caster.percent_bonus_damage = caster.percent_bonus_damage + percent
	if duration then
		Timers:CreateTimer(duration,function ()
			if not caster:IsNull() then
				caster.percent_bonus_damage = caster.percent_bonus_damage - percent
			end
		end)
	end
end
-- 设置单位魔法百分比伤害输出
function SetUnitMagicDamagePercent( ... )
	local caster,percent,duration = ...
	if caster.bonus_magic_damage == nil then
		caster.bonus_magic_damage = 0
	end
	caster.bonus_magic_damage = caster.bonus_magic_damage + percent
	if duration then
		Timers:CreateTimer(duration,function ()
			if not caster:IsNull() then
				caster.bonus_magic_damage = caster.bonus_magic_damage - percent
			end
		end)
	end
end
-- 设置单位接受伤害加深百分比
function SetUnitIncomingDamageDeepen( ... )
	local caster,percent,duration = ...
	if caster.percent_increase_damage == nil then
		caster.percent_increase_damage = 0
	end
	caster.percent_increase_damage = caster.percent_increase_damage + percent
	if duration then
		Timers:CreateTimer(duration,function ()
			if not caster:IsNull() then
				caster.percent_increase_damage = caster.percent_increase_damage - percent
			end
		end)
	end
end
-- 设置单位接受伤害降低百分比
function SetUnitIncomingDamageReduce( ... )
	local caster,percent,duration = ...
	if caster.percent_reduce_damage == nil then
		caster.percent_reduce_damage = 0
	end
	caster.percent_reduce_damage = caster.percent_reduce_damage + percent
	if duration then
		Timers:CreateTimer(duration,function ()
			if not caster:IsNull() then
				caster.percent_reduce_damage = caster.percent_reduce_damage - percent
			end
		end)
	end
end
-- 打印表
function PrintTable( keys )
	print("----------------------------------")
	for k, v in pairs( keys ) do
		print( k, v )
	end
	print("----------------------------------")
end
-- 满格
function IsFullSolt( ... )
	local caster,bagType,tip = ...
	if bagType == nil then
		bagType = 6
	end
	local itemCount = 0
	for i=1,bagType do
        local itemSolt = caster:GetItemInSlot(i-1)
        if itemSolt then
        	itemCount = itemCount + 1
        end
    end
    if itemCount == bagType then
	    if tip then
	    	local unit = caster
	    	if not unit:IsRealHero() then
	    		unit = caster.currentHero
	    	end
	    	local playerid = unit:GetPlayerOwnerID()
	    	Notifications:Bottom(playerid, {text="物品栏已满", style={color="red"}, duration=1, continue = false})
	    	EmitSoundOnClient("General.CastFail_InvalidTarget_Hero", unit:GetPlayerOwner())
	    end
    	return true
    else
    	return false
    end
end
-- 判断buff类型
function IsModifierType( ... )
	local caster,buffName,type = ...
	local buff = caster:FindModifierByName(buffName)
	if not buff.type then buff.type = {} end
	if buff.type[type] then 
		return true 
	else
		return false
	end
end
-- 同类装备检查
function ItemTypeCheck( ... )
	local caster,item = ...
	local currentItemInfo = GameRules.ItemInfoKV[item:GetAbilityName()]
	local currentItemType = "currentItemType"
	for i=0,11 do
    	local bagItem = caster:GetItemInSlot(i)
    	if bagItem then
    		local bagItemInfo = GameRules.ItemInfoKV[bagItem:GetAbilityName()]
    		local bagItemType = "bagItemType"
    		if bagItemInfo then
        		bagItemType = bagItemInfo.itemType
        	end
        	if currentItemType == bagItemType then
        		DropItem(item, caster)
        		Notifications:Bottom(caster:GetPlayerID(), {text="你已经拥有一个同类装备", style={color="red"}, duration=2, continue = false})
        		return true
        	end
        end
    end
    return false
end
-- 设置镜头位置
function SetCamera( ... )
	local playerID,arg = ...
	if type(arg) == "table" then
		PlayerResource:SetCameraTarget(playerID, arg)
	elseif type(arg) == "userdata" then
		PrecacheUnitByNameAsync("majia",function()
			local target = CreateUnitByName("majia", arg, true, nil, nil, DOTA_TEAM_BADGUYS )
			PlayerResource:SetCameraTarget(playerID, target)
			target:ForceKill(false)
		end)
	end
	Timers:CreateTimer(0.1,function()
		PlayerResource:SetCameraTarget(playerID, nil)
	end)
end
-- 跳跃
function Jump( ... )
	local caster,target_location,speed,height,findPath,callback = ...
	local caster_location = caster:GetAbsOrigin()
	local fix_location = target_location
	local direction = (target_location - caster_location):Normalized()
	if findPath then
		if GridNav:CanFindPath(caster_location, target_location) == false then
			while(GridNav:CanFindPath(caster_location, fix_location) == false)
			do
				fix_location = fix_location - direction * 50
			end
			target_location = fix_location
		end
	end
	local distance = (target_location - caster:GetAbsOrigin()):Length2D()
	local height_fix = (caster_location.z - target_location.z) / distance
	local currentPos = Vector(0,0,0)
	speed = speed / 30
	local traveled_distance = 0
	Timers:CreateTimer(function ()
		if traveled_distance < distance then
			currentPos = caster:GetAbsOrigin() + direction * speed
			currentPos.z = caster_location.z + (-4 * height) / (distance ^ 2) * traveled_distance ^ 2 + (4 * height) / distance * traveled_distance - height_fix * traveled_distance
			SetUnitPosition(caster, currentPos, true)
			traveled_distance = traveled_distance + speed
			return 0.01
		else
			SetUnitPosition(caster, target_location)
			if callback ~= nil then callback() end
		end
	end)
end
-- 拥有专属
function HasExclusive( ... )
	local caster,lv = ...
	if not lv then lv = 0 end
	local exclusiveName = "modifier_"..caster:GetUnitName()
	if caster:HasModifier(exclusiveName) and GetRebornCount(caster) >= lv then 
		return true 
	end
	return false
end
-- 简易击退
function KnockBack( ... )
	local caster,direction,distance,duration = ...
	local caster_location = caster:GetAbsOrigin()
	local interval = 0.02
	local time = 0
	local point
	local speed = distance / duration * interval
	caster:AddNewModifier(nil, nil, "modifier_phased", {duration=duration})
	--caster:AddNewModifier(nil, nil, "modifier_stunned", {duration=duration})
	Timers:CreateTimer(function (  )
		if time < duration then
			time = time + interval
			point = caster:GetAbsOrigin() + speed * direction
			SetUnitPosition(caster,point,false)
			return interval
		end
	end)
end
--颜色
local __msg_type = {}
local __color = {
	red 	={255,0,0},
	orange	={255,127,0},
	yellow	={255,255,0},
	green 	={0,255,0},
	blue 	={0,0,255},
	indigo 	={0,255,255},
	purple 	={255,0,255},
}

--定义常量
MSG_BLOCK 		= "particles/msg_fx/msg_block.vpcf"
MSG_ORIT 		= "particles/msg_fx/msg_crit.vpcf"
MSG_DAMAGE 		= "particles/msg_fx/msg_damage.vpcf"
MSG_EVADE 		= "particles/msg_fx/msg_evade.vpcf"
MSG_GOLD 		= "particles/msg_fx/msg_gold.vpcf"
MSG_HEAL 		= "particles/msg_fx/msg_heal.vpcf"
MSG_MANA_ADD 	= "particles/msg_fx/msg_mana_add.vpcf"
MSG_MANA_LOSS 	= "particles/msg_fx/msg_mana_loss.vpcf"
MSG_MISS 		= "particles/msg_fx/msg_miss.vpcf"
MSG_POISION 	= "particles/msg_fx/msg_poison.vpcf"
MSG_SPELL 		= "particles/msg_fx/msg_spell.vpcf"
MSG_XP 			= "particles/msg_fx/msg_xp.vpcf"

table.insert(__msg_type,MSG_BLOCK)
table.insert(__msg_type,MSG_ORIT)
table.insert(__msg_type,MSG_DAMAGE)
table.insert(__msg_type,MSG_EVADE)
table.insert(__msg_type,MSG_GOLD)
table.insert(__msg_type,MSG_HEAL)
table.insert(__msg_type,MSG_MANA_ADD)
table.insert(__msg_type,MSG_MANA_LOSS)
table.insert(__msg_type,MSG_MISS)
table.insert(__msg_type,MSG_POISION)
table.insert(__msg_type,MSG_SPELL)
table.insert(__msg_type,MSG_XP)

--显示数字特效，可指定颜色，符号
function CreateNumberEffect( ... )
	local entity,number,duration,msg_type,color,icon_type = ...
	--判断实体
	if entity:IsAlive()==nil then
		return
	end
	icon_type = icon_type or 9
	
	--对采用的特效进行判断
	local is_msg_type = false
	for k,v in pairs(__msg_type) do
		if msg_type == v then
			is_msg_type = true;
			break;
		end
	end

	--判断颜色
	if type(color)=="string" then
		color = __color[color] or {255,255,255}
	else
		if #color ~=3 then
		end
	end
	local color_r = tonumber(color[1]) or 255;
	local color_g = tonumber(color[2]) or 255;
	local color_b = tonumber(color[3]) or 255;
	local color_vec = Vector(color_r,color_g,color_b);

	--处理数字
	number = math.floor(number)
	local number_count = #tostring(number) + 1

	--创建特效
    local particle = CreateParticle(msg_type,PATTACH_CUSTOMORIGIN_FOLLOW,entity,duration)
    ParticleManager:SetParticleControlEnt(particle,0,entity,5,"attach_hitloc",entity:GetOrigin(),true)
    ParticleManager:SetParticleControl(particle,1,Vector(10,number,icon_type))
    ParticleManager:SetParticleControl(particle,2,Vector(duration,number_count,0))
    ParticleManager:SetParticleControl(particle,3,color_vec)
end
-- 拆分字符
function string.split(input, delimiter)  
    input = tostring(input)  
    delimiter = tostring(delimiter)  
    if (delimiter=='') then return false end  
    local pos,arr = 0, {}  
    -- for each divider found  
    for st,sp in function() return string.find(input, delimiter, pos, true) end do  
        table.insert(arr, string.sub(input, pos, st - 1))  
        pos = sp + 1  
    end  
    table.insert(arr, string.sub(input, pos))  
    return arr  
end
-- 复制表
function DeepCopy( obj )      
    local InTable = {};  
    local function Func(obj)  
        if type(obj) ~= "table" then   --判断表中是否有表  
            return obj;  
        end  
        local NewTable = {};  --定义一个新表  
        InTable[obj] = NewTable;  --若表中有表，则先把表给InTable，再用NewTable去接收内嵌的表  
        for k,v in pairs(obj) do  --把旧表的key和Value赋给新表  
            NewTable[Func(k)] = Func(v);  
        end  
        return setmetatable(NewTable, getmetatable(obj))--赋值元表  
    end  
    return Func(obj) --若表中有表，则把内嵌的表也复制了  
end 
-- 传送专用
function Teleport( ... )
	local caster,position = ...
	if position.z<-1000 then
		position.z = 0
	end
	if caster.limitRegion then
		local limitRegion = caster.limitRegion
		if position.x > limitRegion.right then
			position.x = limitRegion.right
		elseif position.x < limitRegion.left then
			position.x = limitRegion.left
		end
		if position.y > limitRegion.Top then
			position.y = limitRegion.Top
		elseif position.y < limitRegion.bottom then
			position.y = limitRegion.bottom
		end
	end
	FindClearSpaceForUnit(caster, position, true)
end