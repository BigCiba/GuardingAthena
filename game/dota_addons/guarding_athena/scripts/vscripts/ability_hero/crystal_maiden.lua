function FrostSigilCreate( t )
    local caster = t.caster
    if caster.FrostSigil == nil then
        caster.FrostSigil = 0
    end
end
function FrostSigilCast( t )
    local caster = t.caster
    local ability = t.event_ability
    if HasExclusive(caster,3) then
        if RollPercentage(15) then
            Timers:CreateTimer(0.03,function ()
                ability:EndCooldown()
            end)
        end
    end
end
function OnSpellStart( t )
    local caster = t.caster
    local ability = t.ability
    local abilityIndex = ability:GetAbilityIndex()
    if abilityIndex == 0 then
        FrostSigil( caster,t.target:GetAbsOrigin() )
    end
end
function FrostSigil( caster,position )
    local particle = CreateParticle("particles/heroes/crystal_maiden/frost_sigil_gound_b.vpcf",PATTACH_ABSORIGIN,caster,10)
    ParticleManager:SetParticleControl( particle, 0, position )
    local count = 0
    local used = false
    Timers:CreateTimer(function ()
        if count < 10 then
            local distance = (caster:GetAbsOrigin() - position):Length2D()
            if distance < 600 then
                if not used then
                    caster.FrostSigil = caster.FrostSigil + 1
                    used = true
                end
            else
                if used then
                    caster.FrostSigil = caster.FrostSigil - 1
                    used = false
                end
            end
            count = count + 1
            return 1
        else
            if used then
                caster.FrostSigil = caster.FrostSigil - 1
            end
        end
    end)
end
function ChillinessBurst( t )
    local caster = t.caster
    local ability = t.ability
    local caster_location = caster:GetAbsOrigin()
    local radius = (ability:GetSpecialValueFor("radius") + (100 * caster.FrostSigil)) / 6
    local radiusParticle = ability:GetSpecialValueFor("radius") + (100 * caster.FrostSigil)
    local currentRadius = 0
    local damage = (ability:GetSpecialValueFor("damage") * caster:GetIntellect() + ability:GetSpecialValueFor("base_damage")) * (1 + 0.3 * caster.FrostSigil)
    local damageType = ability:GetAbilityDamageType()
    local frozenTime = ability:GetSpecialValueFor("frozen_duration") + (0.1 * caster.FrostSigil)
    local saveGroup = {}
    -- 天赋
    FrostSigil( caster,caster_location )
    --local unitGroup = GetUnitsInRadius( caster, ability, caster_location, radius )
    local particle = CreateParticle("particles/heroes/crystal_maiden/chilliness_burst.vpcf",PATTACH_CUSTOMORIGIN,caster,3,true)
    ParticleManager:SetParticleControl( particle, 0, caster_location )
    ParticleManager:SetParticleControl( particle, 1, Vector(radiusParticle,radiusParticle,radiusParticle) )
    local spreadTime = 0.6
    local counter = 0
    Timers:CreateTimer(function ()
        if counter < spreadTime then
            currentRadius = currentRadius + radius
            local unitGroup = GetUnitsInRadius( caster, ability, caster_location, currentRadius )
            for k,v in pairs(unitGroup) do
                local saved = false
                for i,unit in pairs(saveGroup) do
                    if v == unit then
                        saved = true
                    end
                end
                if not saved then
                    table.insert(saveGroup,v)
                    CauseDamage( caster, v, damage, damageType, ability )
                    ability:ApplyDataDrivenModifier(caster, v, "modifier_chilliness_burst_frozen", {duration = frozenTime})
                end
            end
            counter = counter + 0.1
            return 0.1
        end
    end)
end
function OnFrozenRemove( t )
    local caster = t.caster
    local target = t.target
    local ability = t.ability
    local moveSpeed = ability:GetSpecialValueFor("movespeed")
    local attackSpeed = ability:GetSpecialValueFor("attackspeed")
    local duration = ability:GetSpecialValueFor("duration")
    local regenInterval = math.floor(moveSpeed / duration)
    local interval = 1
    local time = 0
    local stackcount = target:GetModifierStackCount("modifier_chilliness_burst_debuff", caster) + moveSpeed
    ability:ApplyDataDrivenModifier(caster, target, "modifier_chilliness_burst_debuff", {duration = duration})
    target:SetModifierStackCount("modifier_chilliness_burst_debuff", caster, stackcount)
    Timers:CreateTimer(1,function ()
        if time < 5 then
            stackcount = target:GetModifierStackCount("modifier_chilliness_burst_debuff", caster) - regenInterval
            target:SetModifierStackCount("modifier_chilliness_burst_debuff", caster, stackcount)
            time = time + 1
            return interval
        end
    end)
end
function ApplyNoCooldown( t )
    t.ability.cooldown_reduce = false
end
function CreateFrozenAura( t )
    local caster = t.target
    local ability = t.ability
    local reduceRate = ability:GetSpecialValueFor("reduce")
    if caster:HasModifier("modifier_frozen_aura_buff_active") then
        caster:RemoveModifierByName("modifier_frozen_aura_buff_active")
    end
    caster.frozenAura = reduceRate
end
function RemoveFrozenAura( t )
    local caster = t.target
    caster.frozenAura = 0
end
function CreateFrozenAuraActive( t )
    local caster = t.target
    local ability = t.ability
    local reduceRate = ability:GetSpecialValueFor("reduce")
    if caster:HasModifier("modifier_frozen_aura_buff") then
        caster:RemoveModifierByName("modifier_frozen_aura_buff")
    end
    caster.frozenAura = reduceRate
    if caster == t.caster then
        caster.frozenAura = reduceRate * 2
    end
end
function RemoveFrozenAuraActive( t )
    local caster = t.target
    caster.frozenAura = 0
end
function RegenMana( t )
    local caster = t.caster
    local ability = t.event_ability
    local rate = t.ability:GetSpecialValueFor("regen_rate")
    local manaCost = ability:GetManaCost(ability:GetLevel()-1)
    if RollPercentage(rate) then
        Heal( caster, 0, manaCost, false )
    end
end
function FrozenAuraActive( t )
    local caster = t.caster
    local ability = t.ability
    local reduceRate = ability:GetSpecialValueFor("reduce")
    local duration = ability:GetSpecialValueFor("duration") + (1 * caster.FrostSigil)
    local reduceOld = caster.frozenAura or 0
    caster:RemoveModifierByName("modifier_frozen_aura")
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_frozen_aura_active", {duration=duration})
    local cd = ability:GetCooldown(1) - duration
    Timers:CreateTimer(cd,function ()
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_frozen_aura", nil)
    end)
end
function CreateSlow( t )
    --[[local caster = t.caster
    local ability = t.ability
    local castAbility
    local abilityIndex
    if abilityIndex == 1 then
        local point
        local radius
       ]]--
end
function Snowstorm( t )
    local caster = t.caster
    local ability = t.ability
    local damageType = ability:GetAbilityDamageType()
    local target_location = t.target_points[1]
    local damage = ability:GetSpecialValueFor("damage") * caster:GetIntellect() + ability:GetSpecialValueFor("base_damage")
    local slowDuration = ability:GetSpecialValueFor("slow_duration")
    local singleRadius = ability:GetSpecialValueFor("single_radius") + (10 * caster.FrostSigil)
    local radius = ability:GetSpecialValueFor("radius")
    local interval = ability:GetSpecialValueFor("interval") - (0.03 * caster.FrostSigil)
    if interval < 0.1 then
        interval = 0.1
    end
    local bonusRate = ability:GetSpecialValueFor("bonus_rate") + (5 * caster.FrostSigil)
    local duration = ability:GetSpecialValueFor("duration")
    local count = 0
    -- 天赋
    FrostSigil( caster,target_location )
    local particleGound = CreateParticle( "particles/heroes/crystal_maiden/snowgound_gound_a.vpcf", PATTACH_ABSORIGIN, caster )
    ParticleManager:SetParticleControl( particleGound, 0, target_location )
    Timers:CreateTimer(function ()
        if count < duration then
            local bonus = 4
            if RollPercentage(bonusRate) then
                bonus = 8
            end
            for i=1,bonus do
                local point = GetRandomPoint( target_location, 0, radius )
                local rate = 110 - caster.FrostSigil * 12
                if rate > 100 then rate = 100 end
                if rate < 8 then rate = 8 end
                if RollPercentage(rate) then
                    local particle = CreateParticle( "particles/heroes/crystal_maiden/snowstorm.vpcf", PATTACH_ABSORIGIN, caster )
                    ParticleManager:SetParticleControl( particle, 0, point )
                end
                EmitSoundOnLocationForAllies(target_location, "Hero_Morphling.attack", caster)
                --ParticleManager:SetParticleControl( particle, 1, point+Vector(0,0,600) )
                Timers:CreateTimer(0.5,function ()
                    local unitGroup = GetUnitsInRadius( caster, ability, point, singleRadius )
                    for k,v in pairs(unitGroup) do
                        CauseDamage( caster, v, damage, damageType, ability )
                        AddModifierStackCount( caster, v, ability, "modifier_snowstorm_debuff", count, slowDuration)
                    end
                end)
            end
            count = count + interval
            return interval
        else
            ParticleManager:DestroyParticle(particleGound,false)
        end
    end)
end
function ChillingTouch( t )
    local caster = t.caster
    local caster_location = caster:GetAbsOrigin()
    local ability = t.ability
    local damage = (ability:GetSpecialValueFor("damage") * caster:GetIntellect() + ability:GetSpecialValueFor("base_damage")) * (1 + 0.2 * caster.FrostSigil) * 0.1
    local damageType = ability:GetAbilityDamageType()
    local radius = ability:GetSpecialValueFor("radius")
    local duration = ability:GetSpecialValueFor("duration")
    local interval = 0.5
    -- 天赋
    FrostSigil( caster,caster:GetAbsOrigin() )
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_chilling_touch", {duration=interval})
    local particleGound = CreateParticle("particles/heroes/crystal_maiden/snow_aura.vpcf",PATTACH_ABSORIGIN,caster,duration)
    local count = 0
    Timers:CreateTimer(function ()
        if count < duration then
            local unitGroup = GetUnitsInRadius( caster, ability, caster_location, radius )
            for k,v in pairs(unitGroup) do
                CauseDamage( caster, v, damage, damageType, ability )
                ability:ApplyDataDrivenModifier(caster, v, "modifier_chilling_touch_debuff", nil)
                if v:GetMoveSpeedModifier(v:GetBaseMoveSpeed()) < 150 then
                    ability:ApplyDataDrivenModifier(caster, v, "modifier_chilling_touch_freeze", {duration=interval})
                end
            end
            if (caster:GetAbsOrigin() - caster_location):Length2D() < 600 then
                ability:ApplyDataDrivenModifier(caster, caster, "modifier_chilling_touch", {duration=interval})
            end
            if HasExclusive(caster,2) then
                local unitGroup = FindUnitsInRadius( caster:GetTeamNumber(), caster_location, caster, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, 0, 0, false )
                for k,v in pairs(unitGroup) do
                    if caster ~= v then
                        ability:ApplyDataDrivenModifier(caster, v, "modifier_chilling_touch", {duration=interval})
                    end
                end
            end
            count = count + interval
            return interval
        end
        caster:RemoveModifierByName("modifier_chilling_touch")
    end)
end
function OnAttackLanded( t )
    local caster = t.caster
    local target = t.target
    local ability = t.ability
    local rate = ability:GetSpecialValueFor("chance")
    if RollPercentage(rate) and HasExclusive(caster,1) then
        ability:ApplyDataDrivenModifier(caster, target, "modifier_npc_dota_hero_crystal_maiden_debuff", nil)
    end
end
function OnAbilityExecuted( t )
    local caster = t.caster
    if caster.ice_shield < 9 and HasExclusive(caster,4) then
        caster.ice_shield = caster.ice_shield + 1
    end
end
function OnCreated( t )
    local caster = t.caster
    if not caster.ice_shield then 
        caster.ice_shield = 0
    end
    AddDamageFilterVictim(caster,"exclusive",function (damage,attacker)
        if caster.ice_shield > 0 and HasExclusive(caster,4) then
            damage = 0
            caster.ice_shield = caster.ice_shield -1
        end
        return damage
    end)
end
function OnDestroy( t )
    local caster = t.caster
    RemoveDamageFilterVictim(caster,"exclusive")
end