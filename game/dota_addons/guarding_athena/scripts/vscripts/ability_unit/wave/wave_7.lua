function LightningChain( t )
    CauseDamage(t.caster,t.target,t.ability:GetSpecialValueFor("damage"),t.ability:GetAbilityDamageType(),t.ability)
end
function OnFatalBonds( t )
    local caster = t.caster
    local ability = t.ability
    local duration = ability:GetSpecialValueFor("duration")
    local radius = ability:GetSpecialValueFor("radius")
    ability.unitGroup = GetUnitsInRadius(caster,ability,caster:GetAbsOrigin(),radius)
    for k,unit in pairs(ability.unitGroup) do
        ability:ApplyDataDrivenModifier(caster, unit, "modifier_fatal_bonds_debuff", nil)
    end
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_fatal_bonds_debuff", nil)
    table.insert( ability.unitGroup, caster )
    -- 不反弹此技能造成的伤害
    ability.damage_tag = true
    Timers:CreateTimer(12,function ()
        ability.unitGroup = nil
    end)
end
function OnTakeDamage( t )
    local caster = t.caster
    local target = t.target
    local ability = t.ability
    local damage = t.damage
    local damageType = ability:GetAbilityDamageType()
    if ability.damage_tag and ability:IsCooldownReady() then
        ability.damage_tag = false
        for k,unit in pairs(ability.unitGroup) do
            if unit ~= target then
                CauseDamage(caster,unit,damage,damageType,ability)
                local p = CreateParticle("particles/units/heroes/hero_warlock/warlock_fatal_bonds_pulse.vpcf",PATTACH_ABSORIGIN,caster,duration)
                ParticleManager:SetParticleControlEnt(p, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
                ParticleManager:SetParticleControlEnt(p, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
            end
        end
        ability:StartCooldown(0.05)
        ability.damage_tag = true
    end
end
function OnShadowWord( t )
    local caster = t.caster
    local target = t.target
    local ability = t.ability
    local regen = math.floor(target:GetHealthRegen())
    local damage = ability:GetSpecialValueFor("damage") + regen
    local duration = ability:GetSpecialValueFor("duration")
    local damageType = ability:GetAbilityDamageType()
    local runTime = 0
    Timers:CreateTimer(function ()
        if runTime < duration then
            CauseDamage(caster,target,damage,damageType,ability)
            runTime = runTime + 1
            return 1
        end
    end)
end
function OnUpheaval( t )
    local caster = t.caster
    local ability = t.ability
    local point = t.target_points[1]
    local duration = ability:GetSpecialValueFor("duration")
    local radius = ability:GetSpecialValueFor("radius")
    local runTime = 0
    local p = CreateParticle("particles/units/heroes/hero_warlock/warlock_upheaval.vpcf",PATTACH_ABSORIGIN,caster,duration)
    ParticleManager:SetParticleControl(p, 0, point)
    ParticleManager:SetParticleControl(p, 1, Vector(900,1,1))
    Timers:CreateTimer(function ()
        if runTime < duration then
            local unitGroup = GetUnitsInRadius(caster,ability,point,radius)
            for k,unit in pairs(unitGroup) do
                ability:ApplyDataDrivenModifier(caster, unit, "modifier_upheaval_debuff", {duration = 1})
            end
            runTime = runTime + 1
            return 1
        end
    end)
end
function OnRainOfChaos( t )
    local caster = t.caster
    local ability = t.ability
    local duration = ability:GetSpecialValueFor("duration")
    local radius = ability:GetSpecialValueFor("radius")
    local damage = ability:GetSpecialValueFor("damage")
    local damageType = ability:GetAbilityDamageType()
    local travelSpeed = 300
    local landTime = 1.3

    local caster_point = caster:GetAbsOrigin()
    local target_point = t.target_points[1]
    
    local caster_point_temp = Vector(caster_point.x, caster_point.y, 0)
    local target_point_temp = Vector(target_point.x, target_point.y, 0)
    
    local point_difference_normalized = (target_point_temp - caster_point_temp):Normalized()
    local velocity_per_second = point_difference_normalized * travelSpeed
    caster:EmitSound("Hero_Invoker.ChaosMeteor.Loop")

    local chaos_demon = {
                            "boss_chaos_demon_1",
                            "boss_chaos_demon_2",
                            "boss_chaos_demon_3",
                            "boss_chaos_demon_4",
                            "boss_chaos_demon_5",
                            "boss_chaos_demon_6",
                        }
    local randomDemon = RandomInt(1, 6)           
    --Create a particle effect consisting of the meteor falling from the sky and landing at the target point.
    local meteor_fly_original_point = (target_point - (velocity_per_second * landTime)) + Vector (0, 0, 1000)  --Start the meteor in the air in a place where it'll be moving the same speed when flying and when rolling.
    local chaos_meteor_fly_particle_effect = CreateParticle("particles/units/heroes/hero_invoker/invoker_chaos_meteor_fly.vpcf", PATTACH_ABSORIGIN, t.caster)
    ParticleManager:SetParticleControl(chaos_meteor_fly_particle_effect, 0, meteor_fly_original_point)
    ParticleManager:SetParticleControl(chaos_meteor_fly_particle_effect, 1, target_point)
    ParticleManager:SetParticleControl(chaos_meteor_fly_particle_effect, 2, Vector(1.3, 0, 0))
    Timers:CreateTimer(1.3,function ()
        local chaoland = CreateParticle("particles/units/heroes/hero_warlock/warlock_rain_of_chaos_start.vpcf", PATTACH_ABSORIGIN, t.caster)
        ParticleManager:SetParticleControl(chaoland, 0, target_point)
        ParticleManager:SetParticleControl(chaoland, 1, target_point)
        ParticleManager:SetParticleControl(chaoland, 2, target_point)
        caster:EmitSound("Hero_Warlock.RainOfChaos_buildup")
        caster:StopSound("Hero_Invoker.ChaosMeteor.Loop")
    end)
    Timers:CreateTimer(1.5,function ()
        local chaoland_1 = CreateParticle("particles/units/heroes/hero_warlock/warlock_rain_of_chaos.vpcf", PATTACH_ABSORIGIN, t.caster)
        ParticleManager:SetParticleControl(chaoland_1, 0, target_point)
        ParticleManager:SetParticleControl(chaoland_1, 1, target_point)
        ParticleManager:SetParticleControl(chaoland_1, 2, target_point)
        ParticleManager:SetParticleControl(chaoland_1, 5, target_point)
        caster:EmitSound("Hero_Warlock.RainOfChaos")
        --[[PrecacheUnitByNameAsync(chaos_demon[randomDemon],function()
            local unit = CreateUnitByName(chaos_demon[randomDemon], target_point, true, nil, nil, DOTA_TEAM_BADGUYS )
            local forward = Vector(RandomFloat(-150,150),RandomFloat(-150,150),0):Normalized()
            unit:SetForwardVector(forward)
        end)]]
        local unitGroup = GetUnitsInRadius(caster,ability,target_point,radius)
        for i,unit in pairs(unitGroup) do
            CauseDamage(caster,unit,damage,damageType,ability)
            ability:ApplyDataDrivenModifier(caster, unit, "modifier_rain_of_chaos_debuff", nil)
        end
    end)
end