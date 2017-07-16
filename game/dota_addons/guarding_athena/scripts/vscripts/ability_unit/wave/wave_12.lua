function LifeAbsorb( keys )
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local damage = keys.Damage
    local particleName = "particles/units/heroes/hero_pugna/pugna_life_drain.vpcf"
    local particle = CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
    local time = 0
    Timers:CreateTimer(function ()
    if time < 15 and target:IsAlive() and caster:IsAlive() and (caster:GetAbsOrigin() - target:GetAbsOrigin()):Length2D() < 900 and target:IsMagicImmune() == false and target:IsInvulnerable() == false then
            CauseDamage(caster, target, damage, DAMAGE_TYPE_MAGICAL)
            Heal(caster, damage * 10, 0)
            time = time + 1
            return 1
        else
            ParticleManager:DestroyParticle(particle, false)
        end
    end)
end
function LifeAbsorbAI( keys )
    local caster = keys.caster
    local target = keys.attacker
    local ability = keys.ability
    if caster:GetHealthPercent() <= 80 and ability:IsCooldownReady() then
        local t_order = 
        {
            UnitIndex = caster:entindex(),
            OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
            TargetIndex = target:entindex(),
            AbilityIndex = caster:FindAbilityByName("life_absorb"):entindex(),
            Position = nil,
            Queue = 0
        }
        caster:SetContextThink(DoUniqueString("order") , function() ExecuteOrderFromTable(t_order) end, 0.1)
    end
end