function OnSpawn(t)
    local caster = t.caster
    local ability = t.ability
    local damage = ability:GetSpecialValueFor("damage") * caster:GetStrength()
    local damageType = ability:GetAbilityDamageType()
    -- 出生时创建双胞胎
    caster.twins = CreateUnitByName("npc_dota_hero_wisp", GetRandomPoint(caster:GetAbsOrigin(), 200, 400), true, caster, caster, DOTA_TEAM_GOODGUYS)
    caster.twins:SetControllableByPlayer(caster:GetPlayerID(), true)
    caster.twins:SetOwner(caster:GetPlayerOwner())
    -- 创建链接特效
    ability.particle_chain = CreateParticle("particles/units/heroes/hero_wisp/wisp_tether.vpcf",PATTACH_CUSTOMORIGIN,caster)
    ParticleManager:SetParticleControlEnt(ability.particle_chain, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(ability.particle_chain, 1, caster.twins, PATTACH_POINT_FOLLOW, "attach_hitloc", caster.twins:GetAbsOrigin(), true)
    -- 对链接碰撞的单位造成伤害
    Timers:CreateTimer(function ()
        if caster:IsAlive() then
            local unitGroup = GetUnitsInLine(caster,ability,caster:GetAbsOrigin(),caster.twins:GetAbsOrigin(),100)
            for _, unit in pairs(unitGroup) do
                if not unit:HasModifier("modifier_wisp_0_cooldown") then
                    ability:ApplyDataDrivenModifier(caster, unit, "modifier_wisp_0_stun", nil)
                    ability:ApplyDataDrivenModifier(caster, unit, "modifier_wisp_0_cooldown", nil)
                    CauseDamage(caster,unit,damage,damageType,ability)
                end
            end
        end
        return 0.01
    end)
end
function OnSpellStart(t)
    local caster = t.caster

end