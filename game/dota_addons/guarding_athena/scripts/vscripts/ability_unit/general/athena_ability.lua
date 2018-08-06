function AthenaHeal( t )
    local caster = t.caster
    local target = t.unit
    local ability = t.ability
    if target:GetHealthPercent() <= 80 and ability:IsCooldownReady() then
        local hp = ability:GetSpecialValueFor("health") + GuardingAthena.athena_regen_lv * 40
        local mp = ability:GetSpecialValueFor("mana") + GuardingAthena.athena_regen_lv * 8
        local duration = ability:GetSpecialValueFor("duration") + GuardingAthena.athena_hp_lv
        local radius = ability:GetSpecialValueFor("radius")
        local cd = ability:GetSpecialValueFor("cooldown")
        ability:StartCooldown(cd)
        local unitGroup = GetUnitsInRadius(caster,ability,caster:GetAbsOrigin(),radius)
        local time = 0
        for k,v in pairs(unitGroup) do
            CreateParticle("particles/units/athena/athena_heal.vpcf",PATTACH_ABSORIGIN_FOLLOW,v,duration)
        end
        EmitSoundOn("Hero_Huskar.Inner_Vitality", caster)
        Timers:CreateTimer(function()
            if time < duration then
                for k,v in pairs(unitGroup) do
                    if not v:IsNull() then
                        Heal(v,hp,mp,false)
                    end
                end
                time = time + 1
                return 1
            end
        end)
    end
end
function AthenaGuard( t )
    local caster = t.caster
    local target = t.unit
    local ability = t.ability
    if target:GetHealthPercent() <= 60 and ability:IsCooldownReady() then
        local cd = ability:GetSpecialValueFor("cooldown")
        ability:StartCooldown(cd)
        local duration = ability:GetSpecialValueFor("duration") + GuardingAthena.athena_hp_lv
        SetUnitIncomingDamageReduce(caster,25,duration)
        local unitGroup = GetUnitsInRadius( caster, ability, caster:GetAbsOrigin(), 99999 )
        for k,v in pairs(unitGroup) do
            ability:ApplyDataDrivenModifier(caster, v, "modifier_athena_guard_buff", {duration=duration})
            SetUnitIncomingDamageReduce(v,10 + GuardingAthena.athena_armor_lv * 0.5,duration)
            v:AddNewModifier(caster,ability,"athena_guard",{duration=duration})
            EmitSoundOn("Hero_Lich.FrostArmor", v)
            local particle = CreateParticle("particles/units/heroes/hero_lich/lich_frost_armor.vpcf",PATTACH_OVERHEAD_FOLLOW,v,duration)
            ParticleManager:SetParticleControl(particle, 0, v:GetAbsOrigin())
            ParticleManager:SetParticleControl(particle, 1, Vector(1,0,0))
            ParticleManager:SetParticleControlEnt(particle, 2, v, PATTACH_ABSORIGIN_FOLLOW, "attach_origin", v:GetAbsOrigin(), true)
        end
    end
end