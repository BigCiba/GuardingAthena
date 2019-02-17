function OnCreated( t )
    local caster = t.caster
    local ability = t.ability
    local interval = ability:GetSpecialValueFor("interval")
    local sheildPercent = ability:GetSpecialValueFor("shield") * 0.01
    ability.shield_health = 0
    caster.ShieldFilter = function (damage,damageType,caster)
        if damageType == DAMAGE_TYPE_PURE then
            if ability.shield_health > damage then
                ability.shield_health = ability.shield_health - damage
                damage = 0
            else
                damage = damage - ability.shield_health
                ability.shield_health = 0
                if caster.shield_particle then
                    ParticleManager:DestroyParticle(caster.shield_particle, false)
                    caster.shield_particle = nil
                end
            end
        end
        return damage
    end
    caster.death_cloak_timer = Timers:CreateTimer(function ()
        ability.shield_health = caster:GetMaxHealth() * sheildPercent
        if caster.shield_particle == nil then
            caster.shield_particle = CreateParticle("particles/units/heroes/hero_medusa/medusa_mana_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
        end
        return interval
    end)
end
function OnDestroy( t )
    local caster = t.caster
    local ability = t.ability
    caster.ShieldFilter = nil
    if caster.shield_particle then
        ParticleManager:DestroyParticle(caster.shield_particle, false)
        caster.shield_particle = nil
    end
    Timers:RemoveTimer(caster.death_cloak_timer)
end
function OnSpellStart(t)
    SetUnitDamagePercent(t.caster,t.ability:GetSpecialValueFor("damage_increase"),t.ability:GetSpecialValueFor("duration"))
    --Refresh all abilities on the caster.
    for i=0, 15, 1 do  --The maximum number of abilities a unit can have is currently 16.
        local current_ability = t.caster:GetAbilityByIndex(i)
        if current_ability ~= nil then
            current_ability:EndCooldown()
        end
    end
    
    --Refresh all items the caster has.
    for i=0, 5, 1 do
        local current_item = t.caster:GetItemInSlot(i)
        if current_item ~= nil then
            if current_item:GetName() ~= "item_refresher1" or current_item:GetName() ~= "item_death_cloak" then  --Refresher Orb does not refresh itself.
                current_item:EndCooldown()
            end
        end
    end
end