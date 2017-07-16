function SolarLifesteal( keys )
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local damage = target:GetHealth() * 0.1
    local damagePercent = damage / target:GetMaxHealth()
    local healAmount = damagePercent * caster:GetMaxHealth()
    local damageType = ability:GetAbilityDamageType()
    CauseDamage(caster,target,damage,damageType)
    Heal(caster,healAmount,0)
end
function SolarScare( keys )
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    if not ability:IsCooldownReady() then
        return
    end
    local t_order = 
    {
        UnitIndex = caster:entindex(),
        OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
        TargetIndex = target:entindex(),
        AbilityIndex = ability:entindex(),
        Position = nil,
        Queue = 0
    }
    caster:SetContextThink(DoUniqueString("order") , function() ExecuteOrderFromTable(t_order) end, 0.1)
end
function SolarMagicFire( keys )
    local caster = keys.caster
    local target
    local ability = keys.ability
    local duration = ability:GetSpecialValueFor("duration")
    if not ability:IsCooldownReady() then
        return
    end
    local caster_location = caster:GetAbsOrigin()
    local targetTeam = ability:GetAbilityTargetTeam()
    local targetType = ability:GetAbilityTargetType()
    local targetFlag = ability:GetAbilityTargetFlags()
    local radius = 600
    local enemy = FindUnitsInRadius(caster:GetTeamNumber(), caster_location, caster, radius, targetTeam, targetType, targetFlag, 0, false)
    if #enemy >= 1 then
        for k,v in pairs(enemy) do
            if not v:HasModifier("modifier_solar_magic_fire_debuff") then
                target = v
                break
            else
                if #enemy == 1 then
                    target = v
                end
            end
        end
        local t_order = 
        {
            UnitIndex = caster:entindex(),
            OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
            TargetIndex = target:entindex(),
            AbilityIndex = ability:entindex(),
            Position = nil,
            Queue = 0
        }
        caster:SetContextThink(DoUniqueString("order") , function() ExecuteOrderFromTable(t_order) end, 0.1)
        ability.particle = CreateParticle("particles/units/solar_magic_fire.vpcf",PATTACH_CUSTOMORIGIN_FOLLOW,target,duration)
        ParticleManager:SetParticleControl( ability.particle, 0, target:GetAbsOrigin()+Vector(0,0,64) )
        ParticleManager:SetParticleControl( ability.particle, 1, caster:GetAbsOrigin()+Vector(0,0,64) )
    end
end
function SolarMagicFireborken( t )
    local caster = t.caster
    local target = t.target
    local ability = t.ability
    local distance = (caster:GetAbsOrigin() - target:GetAbsOrigin()):Length2D()
    if distance > 900 or target:IsMagicImmune() or target:IsInvulnerable() then
        target:RemoveModifierByName("modifier_solar_magic_fire_debuff")
        ParticleManager:DestroyParticle(ability.particle,false)
    end
end
function SolarNoiceWave( keys )
    local caster = keys.caster
    local target = keys.target
    local caster_location = caster:GetAbsOrigin()
    local target_location = target:GetAbsOrigin()
    local point = (target_location - caster_location):Normalized() * 600
    local ability = keys.ability
    local damage = ability:GetSpecialValueFor("damage") * 0.01
    local teamNumber = caster:GetTeamNumber()
    local targetTeam = ability:GetAbilityTargetTeam()
    local targetType = ability:GetAbilityTargetType()
    local targetFlag = ability:GetAbilityTargetFlags()
    local damageType = ability:GetAbilityDamageType()
    local p1 = CreateParticle("particles/units/solar_noice_wave.vpcf",PATTACH_ABSORIGIN,caster,3)
    ParticleManager:SetParticleControl( p1, 1, Vector(400,400,400))
    local unitGroup = FindUnitsInLine( teamNumber, caster_location, point, nil, 450, targetTeam, targetType, FIND_CLOSEST)
    for k, v in pairs( unitGroup ) do
        CauseDamage(caster, v, v:GetHealth() * damage, damageType)
        for i=1,5 do
            if v:GetAbilityByIndex(i-1) then
                local ability = v:GetAbilityByIndex(i-1)
                if not ability:IsCooldownReady() then
                    local cd = ability:GetCooldownTimeRemaining() + 20
                    ability:StartCooldown(cd)
                end
            end
        end
    end
end
function SolarNoiceWaveAI( keys )
    local caster = keys.caster
    local target = keys.attacker
    local ability = keys.ability
    if not ability:IsCooldownReady() then
        return
    end
    if caster:IsChanneling() then
        return
    end
    if RollPercentage(15) then
        local t_order = 
        {
            UnitIndex = caster:entindex(),
            OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
            TargetIndex = target:entindex(),
            AbilityIndex = ability:entindex(),
            Position = nil,
            Queue = 0
        }
        caster:SetContextThink(DoUniqueString("order") , function() ExecuteOrderFromTable(t_order) end, 0.1)
    end
end
function SolarLockAI( keys )
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    if not ability:IsCooldownReady() then
        return
    end
    local t_order = 
    {
        UnitIndex = caster:entindex(),
        OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
        TargetIndex = target:entindex(),
        AbilityIndex = ability:entindex(),
        Position = nil,
        Queue = 0
    }
    caster:SetContextThink(DoUniqueString("order") , function() ExecuteOrderFromTable(t_order) end, 0.1)
end
function SolarGhost( keys )
    local caster = keys.caster
    local ability = keys.ability
    caster:MoveToPositionAggressive(Entities:FindByName( nil, "athena" ):GetAbsOrigin() + Vector(RandomInt(-1500, 1500),RandomInt(-1500, 1500),0))
    local teamNumber = caster:GetTeamNumber()
    local targetTeam = ability:GetAbilityTargetTeam()
    local targetType = ability:GetAbilityTargetType()
    local targetFlag = ability:GetAbilityTargetFlags()
    local damageType = ability:GetAbilityDamageType()
    local unitGroup = FindUnitsInRadius( teamNumber, caster:GetAbsOrigin(), caster, 1500, targetTeam, targetType, targetFlag, 0, false )
    for k,v in pairs(unitGroup) do
        local target_location = v:GetAbsOrigin()
        local target_forward = v:GetForwardVector():Normalized()
        local spawn_point = target_location - target_forward * 125
        local illusion = CreateUnitByName("solar_ghost", spawn_point, true, caster, nil, teamNumber)
        illusion:SetForwardVector(target_forward)
        illusion:RemoveAbility("solar_ghost")
        illusion:RemoveModifierByName("modifier_solar_ghost")
        illusion:AddNewModifier(caster, ability, "modifier_illusion", { duration = 1, outgoing_damage = 100, incoming_damage = 0 })
        illusion:MakeIllusion()
        ability:ApplyDataDrivenModifier(caster,illusion,"modifier_solar_ghost_illusion",nil)
        illusion:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
        illusion:SetAttacking(v)
    end
end
function SolarGhostIllusion( keys )
    local caster = keys.caster
    local target = keys.target
    CauseDamage(caster,target,target:GetMaxHealth() * 0.1,DAMAGE_TYPE_MAGICAL)
end
function SolarFire( keys )
    local caster = keys.caster
    local ability = keys.ability
    if caster:GetLevel() < 100 and caster:IsAlive() then
        local hp_percent = caster:GetHealthPercent() * 0.01 + 0.01
        --print(hp_percent)
        caster:CreatureLevelUp(1)
        caster:SetModelScale(caster:GetModelScale() + 0.03)
        caster:SetHealth(caster:GetMaxHealth() * hp_percent)
    end
end
function SolarBarrenAura( t )
    local caster = t.caster
    local ability = t.ability
    local caster_location = caster:GetAbsOrigin()
    local unitGroup = GetUnitsInRadius( caster, ability, caster_location, 600 )
    for k,v in pairs(unitGroup) do
        if not v:HasModifier("modifier_solar_barren_aura_buff_2") then
            ability:ApplyDataDrivenModifier(caster, v, "modifier_solar_barren_aura_buff_2", {duration = 1})
        end
    end
end
function FireAttack( t )
    local caster = t.caster
    local target = t.target
    local ability = t.ability
    local level = caster:GetLevel()
    local damage = ability:GetSpecialValueFor("damage") * (1 + (level * 0.1))
    CauseDamage( caster, target, damage, DAMAGE_TYPE_MAGICAL )
end