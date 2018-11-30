function OnAttack( t )
    local caster = t.caster
    local target = t.target
    local ability = t.ability
    local ability_1 = caster:GetAbilityByIndex(1)
    local chance = ability:GetSpecialValueFor("chance")
    local points = {}
    points[1] = target:GetAbsOrigin()
    if RollPercentage(chance) and HasExclusive(caster,4) then
        DoubleMultipleShoot( {caster = caster, ability = ability_1, target_points = points} )
    end
end
function ChaseMoonAndStar( t )
	local caster = t.caster
	local target = t.target
	local ability = t.ability
    local speed = 1000
	local particleName = "particles/skills/moonstar_gold.vpcf"
    local rate = ability:GetSpecialValueFor("rate")
    if RollPercentage(rate) then
        CreateTrackingProjectile( caster, target, ability, particleName, speed)
    end
end
function MultipleAttack( t )
    local caster = t.caster
	local target = t.target
	local ability = t.ability
    local speed = 1000
	local particleName = "particles/skills/moonstar_gold.vpcf"
    if HasExclusive(caster) then
        unitGroup = GetUnitsInRadius( caster, ability, target:GetAbsOrigin(), 400 )
        local Maxcount = ability:GetSpecialValueFor("count")
        local count = 0
        for k,v in pairs(unitGroup) do
            if count < Maxcount then
                CreateTrackingProjectile( caster, v, ability, particleName, speed)
                count = count + 1
            else
                break
            end
        end
    end
end
function ChaseMoonAndStarDamage( t )
	local caster = t.caster
    local target = t.target
    local ability = t.ability
    local rate = ability:GetSpecialValueFor("rate") * 0.5
    local damage = caster:GetAgility() * ability:GetSpecialValueFor("damage")
    local armor = ability:GetSpecialValueFor("armor")
    local duration = ability:GetSpecialValueFor("duration")
    if HasExclusive(caster,1) then
        damage = damage * 2
    end
    local damageType = ability:GetAbilityDamageType()
    local modiferName = "modifier_star_buff"
    CauseDamage( caster, target, damage, damageType, ability )
    AddModifierStackCount(caster,target,ability,modiferName,armor,duration,true)
    -- 纪念碑
    if target:GetUnitName() == "hero_statue_1" or target:GetUnitName() == "hero_statue_2" then
    	Anneal({caster=target, attacker=caster})
    end
    -- 连续触发
    if RollPercentage(rate) then
        ContinueTrigger( t )
    end
    -- 专属
    local ability_1 = caster:GetAbilityByIndex(1)
    local chance = ability:GetSpecialValueFor("chance") * 0.5
    local points = {}
    points[1] = target:GetAbsOrigin()
    if RollPercentage(chance) then
        DoubleMultipleShoot( {caster = caster, ability = ability_1, target_points = points} )
    end
end
function ContinueTrigger( t )
    local caster = t.caster
	local target = t.target
	local ability = t.ability
    local speed = 1500
	local particleName = "particles/skills/moonstar_gold.vpcf"
    CreateTrackingProjectile( caster, target, ability, particleName, speed)
end
function MultipleShoot( t )
    local caster = t.caster
    local ability = t.ability
    local particleName = "particles/units/heroes/hero_windrunner/windrunner_spell_powershot.vpcf"
    if caster.gift then
		particleName = "particles/skills/multiple_shoot_gold.vpcf"
	end
    local point = t.target_points[1]
    local radius = ability:GetSpecialValueFor("radius")
    local distance = ability:GetSpecialValueFor("range")
    local speed = ability:GetSpecialValueFor("speed")
    local casterOrigin = caster:GetAbsOrigin()
    ability.castPosition = casterOrigin
    local lengthx = point.x - casterOrigin.x
    local lengthy = point.y - casterOrigin.y
    local midAngle = 0
    if lengthx < 0 then
    	midAngle = math.atan(lengthy / lengthx) + 180 * (3.141 / 180.0)
    else
    	midAngle = math.atan(lengthy / lengthx)
    end
    local angle = {}
    angle[1] = midAngle + 30 * (3.141 / 180.0)
    angle[2] = midAngle + 15 * (3.141 / 180.0)
    angle[3] = midAngle
    angle[4] = midAngle - 15 * (3.141 / 180.0)
    angle[5] = midAngle - 30 * (3.141 / 180.0)
    local targetDirection = {}
    for i=1,5 do
    	targetDirection[i]= ( Vector(math.cos(angle[i]) * 900,math.sin(angle[i]) * 900,0) ):Normalized() 
    end
    for i=1,5 do
        CreateLinearProjectile( caster, ability, particleName, casterOrigin, radius, distance, targetDirection[i], speed, false )
    end
    Timers:CreateTimer(0.4,function()
        if RollPercentage(60) == true then
            DoubleMultipleShoot( t )
            ability.damageType = DAMAGE_TYPE_MAGICAL
        end
    end)
end
function MultipleShootDamage( t )
	local caster = t.caster
	local target = t.target
	local ability = t.ability
	local damage = t.Damage * caster:GetAverageTrueAttackDamage(caster)
    local damgeDeepen = (target:GetAbsOrigin() - ability.castPosition):Length2D() / 240 + 1
    damage = damage * damgeDeepen
    local damageType = ability:GetAbilityDamageType()
	if ability.damageType == DAMAGE_TYPE_MAGICAL then
		damageType = DAMAGE_TYPE_MAGICAL
	end
    CauseDamage( caster, target, damage, damageType, ability )
end
function DoubleMultipleShoot( t )
    local caster = t.caster
    local ability = t.ability
    local particleName = "particles/skills/multiple_shoot_magic.vpcf"
    --[[if caster.gift then
		particleName = "particles/skills/multiple_shoot_gold.vpcf"
	end]]
    local point = t.target_points[1]
    local radius = ability:GetSpecialValueFor("radius")
    local distance = ability:GetSpecialValueFor("range")
    local speed = ability:GetSpecialValueFor("speed")
    local casterOrigin = caster:GetAbsOrigin()
    ability.castPosition = casterOrigin
    local lengthx = point.x - casterOrigin.x
    local lengthy = point.y - casterOrigin.y
    local midAngle = 0
    if lengthx < 0 then
    	midAngle = math.atan(lengthy / lengthx) + 180 * (3.141 / 180.0)
    else
    	midAngle = math.atan(lengthy / lengthx)
    end
    local angle = {}
    angle[1] = midAngle + 30 * (3.141 / 180.0)
    angle[2] = midAngle + 15 * (3.141 / 180.0)
    angle[3] = midAngle
    angle[4] = midAngle - 15 * (3.141 / 180.0)
    angle[5] = midAngle - 30 * (3.141 / 180.0)
    local targetDirection = {}
    for i=1,5 do
    	targetDirection[i]= ( Vector(math.cos(angle[i]) * 900,math.sin(angle[i]) * 900,0) ):Normalized() 
    end
    EmitSoundOn("Ability.Powershot",t.caster)
    for i=1,5 do
        CreateLinearProjectile( caster, ability, particleName, casterOrigin, radius, distance, targetDirection[i], speed, false )
    end
    Timers:CreateTimer(0.5,function()
        ability.damageType = nil
    end)
end
function GustDamage( t )
	local caster = t.caster
	local target = t.target
    local ability = t.ability
	local damage = caster:GetAgility() * t.intellect
	local damageType = t.ability:GetAbilityDamageType()
    CauseDamage( caster, target, damage, damageType, ability )
end
function ArrowStromStart( t )
	local caster = t.caster
    local ability = t.ability
	local particleName = "particles/skills/arrow_strom_1.vpcf"
	local casterLocation = t.caster:GetAbsOrigin()
	local attackPoint_1 = Vector( casterLocation.x, casterLocation.y, 2000 )
	local attackPoint_2 = Vector( casterLocation.x, casterLocation.y, casterLocation.z -300 )
	local fxIndex = CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster, 6)
    ParticleManager:SetParticleControl( fxIndex, 0, attackPoint_1 )
    ParticleManager:SetParticleControl( fxIndex, 6, attackPoint_2 )
    EmitSoundOn("Hero_DrowRanger.Attack",t.caster)
    Timers:CreateTimer(0.5,function()
        if HasExclusive(caster,3) then 
            ability:ApplyDataDrivenModifier(caster, caster, "modifier_arrow_strom", {duration=8})
        else
            ability:ApplyDataDrivenModifier(caster, caster, "modifier_arrow_strom", {duration=4})
        end
    end)
end
function ArrowStrom( t )
	local ability = t.ability
    local caster = t.caster
    local casterLocation = t.caster:GetAbsOrigin()
    local abilityDamage = t.Damage * caster:GetAverageTrueAttackDamage(caster)
    local minDistance = 0
    local maxDistance = 1200
    local radius = 200
    local particleName = "particles/skills/arrow_strom.vpcf"
    local magic = false
    if RollPercentage(60) then
        magic = true
        particleName = "particles/skills/arrow_strom_magic.vpcf"
    end
    if caster.gift then
    	particleName = "particles/skills/arrow_strom_gold.vpcf"
        if magic then
            particleName = "particles/skills/arrow_strom_gold_magic.vpcf"
        end
    end
    local soundEventName = "hero_Crystal.freezingField.explosion"
    local targetTeam = ability:GetAbilityTargetTeam() -- DOTA_UNIT_TARGET_TEAM_ENEMY
    local targetType = ability:GetAbilityTargetType() -- DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
    local targetFlag = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
    local damageType = ability:GetAbilityDamageType()
	local castDistance = RandomInt( minDistance, maxDistance )
    local angle = RandomInt( 0, 90 )
    local dy = castDistance * math.sin( angle )
    local dx = castDistance * math.cos( angle )
    local attackPoint = Vector( 0, 0, 0 )
    if HasExclusive(caster,2) then
        trackUnits = GetUnitsInRadius( caster, ability, caster:GetAbsOrigin(), 1200 )
        if #trackUnits > 0 then
            for k, v in pairs( trackUnits ) do
                attackPoint = v:GetAbsOrigin() + Vector(RandomInt(-100, 100), RandomInt(-100, 100), 0)
                break
            end
        else
            attackPoint = Vector( casterLocation.x - dx, casterLocation.y + dy, casterLocation.z )
        end
    else
        attackPoint = Vector( casterLocation.x - dx, casterLocation.y + dy, casterLocation.z )
    end
    local units = FindUnitsInRadius( caster:GetTeamNumber(), attackPoint, caster, radius,
            targetTeam, targetType, targetFlag, 0, false )
    for k, v in pairs( units ) do
        CauseDamage(caster,v,abilityDamage,damageType,ability)
        if magic then
        	CauseDamage(caster,v,abilityDamage,DAMAGE_TYPE_MAGICAL,ability)
        end
    end
    local fxIndex = CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster, 2)
    ParticleManager:SetParticleControl( fxIndex, 0, attackPoint )
    ParticleManager:SetParticleControl( fxIndex, 1, attackPoint )
    EmitSoundOn("Hero_DrowRanger.Attack",t.caster)
end