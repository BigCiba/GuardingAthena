function BattlefuryRingAbsorb( keys )
    local caster = keys.caster
    if not caster:IsRealHero() then return end
    local caster_location = caster:GetAbsOrigin()
    local ability = keys.ability
    local aura_radius = ability:GetSpecialValueFor("aura_radius")
    local aura_damage = ability:GetSpecialValueFor("aura_damage") * 0.01
    local aura_interval = ability:GetSpecialValueFor("aura_interval")
    local bonus_damage = ability:GetSpecialValueFor("bonus_damage")
    SetUnitDamagePercent(caster,bonus_damage)
    ability.no_damage_filter = true
    Timers:CreateTimer(function ()
        caster_location = caster:GetAbsOrigin()
        local unitGroup = GetUnitsInRadius( caster, ability, caster_location, aura_radius )
        local interval = aura_interval - 0.2 * (100 - caster:GetHealthPercent()) / 10
        local absorbAmount = 0
        for i,unit in pairs(unitGroup) do
            local damageValue = unit:GetHealth() * 0.01
            CauseDamage(caster, unit, damageValue, DAMAGE_TYPE_PURE, ability)
            absorbAmount = absorbAmount + damageValue
            local bonusAttack = unit:GetAttackDamage() * 0.01
            if unit:IsRangedAttacker() == false then
                if string.find(unit:GetUnitName(), "guai_") then
                    bonusAttack = bonusAttack / ((Spawner.gameRound^2 - Spawner.gameRound + 100) * 0.01)
                end
            end
            bonusAttack = math.floor(bonusAttack)
            AddModifierStackCount( caster, caster, ability, "modifier_meteorite_ring_buff",bonusAttack,10,true)
        end
        caster:Heal(absorbAmount,nil)
        PropertySystem( caster, 3, 1)
        return interval
    end)
end
function BattlefuryMeteoriteRing( keys )
    local caster = keys.caster             --获取施法者
    local ability = keys.ability
    local caster_location = caster:GetAbsOrigin()
    local ability = keys.ability
    local skill_radius = ability:GetSpecialValueFor("skill_radius")
    local skill_damage = ability:GetSpecialValueFor("skill_damage")
    local suicide = ability:GetSpecialValueFor("suicide")
    local healthPercent = caster:GetHealthPercent()
    local damage = (caster:GetStrength() + caster:GetAgility() + caster:GetIntellect()) * skill_damage * GameRules:GetDifficulty() * (1 + Spawner.gameRound * 0.01)
    local absorbAmount = 0
    local unitGroup = GetUnitsInRadius( caster, ability, caster_location, skill_radius )
    for i,unit in pairs(unitGroup) do
        local absorbHealth = unit:GetMaxHealth() * 0.02
        absorbAmount = absorbAmount + absorbHealth
        CauseDamage(caster, unit, absorbHealth, DAMAGE_TYPE_PURE,ability)
    end
    for i,unit in pairs(unitGroup) do
        CauseDamage(caster, unit, damage + absorbAmount, DAMAGE_TYPE_PURE,ability)
    end
    if caster:HasModifier("modifier_war_honor") then
        local ability = caster:FindAbilityByName("war_honor")
        local damagetaken = caster:GetHealth() * 0.9
        local table = {caster=caster,ability=ability,DamageTaken=damagetaken}
        WarHonor(table)
    end
    if healthPercent > suicide then
        caster:SetHealth(caster:GetMaxHealth() * (healthPercent - suicide) * 0.01)
    else
        CauseDamage(caster, caster, caster:GetMaxHealth() * 0.5, DAMAGE_TYPE_PURE,ability)
    end
    local p = CreateParticle("particles/items/battlefury_ring.vpcf",PATTACH_ABSORIGIN,caster,5)
    ParticleManager:SetParticleControl(p, 1, Vector(600,1,1))
    ParticleManager:SetParticleControl(p, 2, Vector(1,1,600))
    SetUnitDamagePercent(caster,50,3)
end