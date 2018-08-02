function OnShockWave( t )
    local caster = t.caster
    local ability = t.ability
    local radius = ability:GetSpecialValueFor("radius")
    local distance = ability:GetSpecialValueFor("distance")
    local speed = ability:GetSpecialValueFor("speed")
    local casterLoc = caster:GetAbsOrigin()
    local particleName = "particles/units/wave_23/shock_wave.vpcf"
    local angle = 0
    for i=1,16 do
        local point = GetRotationPoint(casterLoc,radius,angle)
        local direction = (point - casterLoc):Normalized()
        CreateLinearProjectile(caster,ability,particleName,casterLoc,300,distance,direction,speed,false)
        angle = angle + (360 / 16)
    end
end
function OnBounce( t )
    local caster = t.caster
    local target = t.target
    local ability = t.ability
    local radius = ability:GetSpecialValueFor("radius")
    local distance = ability:GetSpecialValueFor("distance") / 2
    local speed = ability:GetSpecialValueFor("speed") / 2
    local targetLoc = target:GetAbsOrigin()
    local particleName = "particles/units/wave_23/shock_wave.vpcf"
    local angle = 0
    for i=1,8 do
        local point = GetRotationPoint(targetLoc,radius,angle)
        local direction = (point - targetLoc):Normalized()
        CreateLinearProjectile(caster,caster:GetAbilityByIndex(2),particleName,targetLoc,300,distance,direction,speed,false)
        angle = angle + (360 / 8)
    end
end
function OnEnchantTotem( t )
    local caster = t.caster
    local target = t.target
    local ability = t.ability
    local radius = 300
    local delay = 1.5
    local damage  = 0.5
    local damageType = ability:GetAbilityDamageType()
    local targetLoc = target:GetAbsOrigin()
    local distance = ability:GetSpecialValueFor("distance")
    local speed = ability:GetSpecialValueFor("speed")
    local p = CreateParticle("particles/units/wave_23/enchant_totem_earth_shock.vpcf",PATTACH_ABSORIGIN,caster,4)
    ParticleManager:SetParticleControl(p, 0, targetLoc)
    Timers:CreateTimer(delay,function ()
        CreateSound("Hero_EarthShaker.EchoSlamSmall",caster)
        local unitGroup = GetUnitsInRadius(caster,ability,targetLoc,radius)
        for k,v in pairs(unitGroup) do
            CauseDamage(caster,v,v:GetMaxHealth() * damage,damageType,ability)
            ability:ApplyDataDrivenModifier(caster, v, "modifier_enchant_totem_debuff", nil)
        end
    end)
end
function OnEarthShake( t )
    local caster = t.caster
    local ability = t.ability
    local damage = ability:GetSpecialValueFor("damage") * 0.01
    local damageType = ability:GetAbilityDamageType()
    local casterLoc = caster:GetAbsOrigin()
    local distance = 2000
    local angle = 0
    local delay = ability:GetSpecialValueFor("delay")
    for i=1,16 do
        local point = GetRotationPoint(casterLoc,distance,angle + RandomInt(-15, 15))
        local p = CreateParticle("particles/units/heroes/hero_elder_titan/elder_titan_earth_splitter.vpcf",PATTACH_ABSORIGIN,caster)
        ParticleManager:SetParticleControl(p, 0, casterLoc)
        ParticleManager:SetParticleControl(p, 1, point)
        ParticleManager:SetParticleControl(p, 3, Vector(0,delay,0))
        ParticleManager:SetParticleControl(p, 11, point)
        ParticleManager:SetParticleControl(p, 12, point)
        angle = angle + (360 / 16)
        Timers:CreateTimer(delay,function ()
            local unitGroup = GetUnitsInLine(caster,ability,casterLoc,point,200)
            for k,unit in pairs(unitGroup) do
                CauseDamage(caster,unit,unit:GetMaxHealth() * damage,damageType,ability)
            end
        end)
    end
    Timers:CreateTimer(delay,function ()
        CreateSound("Hero_ElderTitan.EarthSplitter.Destroy",caster)
    end)
end