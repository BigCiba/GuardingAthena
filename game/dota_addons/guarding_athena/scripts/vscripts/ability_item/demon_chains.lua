function OnCreated(t)
    local caster = t.caster
    local ability = t.ability
    if ability.demon == nil and caster:IsRealHero() then
        CreateDemon(caster,ability)
    end
end
function OnDeath(t)
    local caster = t.caster
    local target = t.target
    local ability = t.ability
    Timers:CreateTimer(ability:GetSpecialValueFor("respawn_time"),function ()
        if ability.demon then
            CreateDemon(caster,ability)
        end
    end)
end
function CreateDemon(caster,ability)
    local spawnLoc = GetRandomPoint(caster:GetAbsOrigin(), 200, 400)
    ability.demon = CreateUnitByName("demon_chains_summoned", spawnLoc, true, caster, caster, DOTA_TEAM_GOODGUYS )
    ability.demon:SetControllableByPlayer(caster:GetPlayerID(), true)
    -- ability.demon:SetOwner(caster:GetPlayerOwner())
    ability:ApplyDataDrivenModifier(caster, ability.demon, "modifier_item_demon_chains_buff", nil)
    SetMaxHealth(ability.demon,ability.demon:GetMaxHealth() + caster:GetPrimaryStatValue() * 1000)
    ability.demon:SetBaseDamageMin(ability.demon:GetBaseDamageMin() + caster:GetPrimaryStatValue() * 100)
    ability.demon:SetBaseDamageMax(ability.demon:GetBaseDamageMax() + caster:GetPrimaryStatValue() * 100)
end
function OnDestroy(t)
    local caster = t.caster
    local ability = t.ability
    if caster:IsRealHero() then
        if not ability.demon:IsNull() then
            UTIL_Remove(ability.demon)
        end
        ability.demon = nil
    end
end
function OnSpellStart(t)
    local caster = t.caster
    local ability = t.ability
    local point = t.target_points[1]
    if not t.target then
        if ability.demon and not ability.demon:IsNull() then
            FindClearSpaceForUnit(ability.demon, t.target_points[1], true)
            ability:EndCooldown()
        end
    else
        if ability.demon and ability.demon:IsAlive() then
            local target = t.target
            local duration = ability:GetSpecialValueFor("duration")
            local interval = ability:GetSpecialValueFor("interval")
            ability:ApplyDataDrivenModifier(caster, target, "modifier_item_demon_chains_debuff", {duration=duration})
            --[[ability.particle_chain = CreateParticle("particles/units/heroes/hero_grimstroke/grimstroke_soulchain.vpcf",PATTACH_CUSTOMORIGIN,caster,duration)
            ParticleManager:SetParticleControlEnt(ability.particle_chain, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
            ParticleManager:SetParticleControlEnt(ability.particle_chain, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)]]
            ForWithInterval(duration / interval,interval,function()
                if not target:IsNull() and target:IsAlive() and ability.demon then
                    CreateParticle("particles/items/demon_chains/demon_chains.vpcf",PATTACH_ABSORIGIN,target,1)
                    ability.demon:PerformAttack(target, true, false, true, true, true, false, true)
                end
            end)
        else
            ability:EndCooldown()
        end
    end
end
function Stop(t)
    local caster = t.caster
    local target = t.target
    local ability = t.ability
    --ParticleManager:DestroyParticle(ability.particle_chain, true)
end
function OnAttackLanded(t)
    local caster = t.caster
    local target = t.target
    local ability = t.ability
    local damage = ability:GetSpecialValueFor("bonus_damage") * caster:GetOwner():GetPrimaryStatValue()
    local damageType = ability:GetAbilityDamageType()
    local cleave_radius = ability:GetSpecialValueFor("cleave_radius")
    local unitGroup = GetUnitsInRadius(caster,ability,target:GetAbsOrigin(),cleave_radius)
    CauseDamage(caster,unitGroup,damage,damageType,ability)
end
function OnIntervalThink(t)
    local caster = t.caster
    local target = t.target
    local ability = t.ability
    local damage = ability:GetSpecialValueFor("damage") * caster:GetOwner():GetPrimaryStatValue()
    local damageType = ability:GetAbilityDamageType()
    CauseDamage(caster,target,damage,damageType,ability)
end