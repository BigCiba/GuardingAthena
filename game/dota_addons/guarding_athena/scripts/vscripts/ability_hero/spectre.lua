LinkLuaModifier("health_extra","modifiers/generic/health_extra.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("armor","modifiers/generic/armor.lua",LUA_MODIFIER_MOTION_NONE)
--LinkLuaModifier("resistance","modifiers/generic/resistance.lua",LUA_MODIFIER_MOTION_NONE)
function OnCreated( t )
    local caster = t.caster
    local ability = t.ability
    if ability:GetAbilityIndex() == 2 then
        ability.damageRecorder = 0
    elseif ability:GetAbilityIndex() == 3 then
        ability.canTrigger = true
        ability.damageRecorder = 0
        ability.stackLevel = 0
    end
end
function OnAttackLanded( t )
    local caster = t.caster
    local target = t.target
    local ability = t.ability
    local damageMax = ((ability.damageRecorder / caster:GetMaxHealth()) + 1)
    local damage = RandomFloat(1, ability:GetSpecialValueFor("damage") * caster:GetStrength() * damageMax )
    ability.damageRecorder = 0
    local damageType = ability:GetAbilityDamageType()
    ability.no_damage_filter = true
    CauseDamage(caster,caster,caster:GetMaxHealth() * 0.01,damageType,ability)
    ability.no_damage_filter = nil
    CauseDamage(caster,target,damage,damageType,ability)
    CreateNumberEffect(target,damage,1,MSG_ORIT,{199,21,133},6)
end
function GetSummonPoints( t )
    local caster = t.caster
    local casterPos = caster:GetAbsOrigin()
    local ability = caster:GetAbilityByIndex(2)
    local unitGroup = GetUnitsInRadius(caster,ability,casterPos,600)
    local point = GetRandomPoint(casterPos,100,600)
    if #unitGroup > 0 then 
        for i,v in ipairs(unitGroup) do
            if v:IsAlive() then
                point = GetRandomPoint(v:GetAbsOrigin(),125,150)
            end
        end
    end
    local result = {}
	table.insert(result, point)
    return result
end
function OnSpawn( t )
    local caster = t.caster
    local target = t.target
    local ability = t.ability
    local health = ability:GetSpecialValueFor("health")
    target:SetBaseMaxHealth(caster:GetMaxHealth() * health)
    target:SetMaxHealth(target:GetMaxHealth())
    target:SetHealth(target:GetMaxHealth())
    target.attack_count = 3
    ability:ApplyDataDrivenModifier(caster, target, "modifier_spectre_0_illusion", nil)
    CreateParticle("particles/heroes/spectre/spectre_2_illusion.vpcf",PATTACH_ABSORIGIN,target,2)
end
function OnIllusionAttackLanded( t )
    local caster = t.attacker
    local owner = t.caster
    local target = t.target
    local ability = t.ability
    local damage = RandomFloat(1, owner:GetAbilityByIndex(2):GetSpecialValueFor("damage") * owner:GetStrength() * ability:GetSpecialValueFor("damage") * 0.01) 
    local damageType = ability:GetAbilityDamageType()
    ability.no_damage_filter = true
    CauseDamage(caster,caster,caster:GetMaxHealth() * 0.01,damageType,ability)
    ability.no_damage_filter = nil
    CauseDamage(owner,target,damage,damageType,ability)
    CreateNumberEffect(target,damage,1,MSG_ORIT,{148,0,211},6)
    caster.attack_count = caster.attack_count - 1
    if caster.attack_count <= 0 then
        caster:ForceKill(false)
    end
end
function OnIllusionTakeDamage( t )
    local caster = t.unit
    local owner = t.caster
    local ability_0 = owner:GetAbilityByIndex(3)
    local ability_3 = owner:GetAbilityByIndex(3)
    local damage_limit = ability_3:GetSpecialValueFor("damage_limit")
    local radius = ability_3:GetSpecialValueFor("radius")
    local percent = t.DamageTaken / caster:GetMaxHealth()
    local illusionDamageScale = ability_0:GetSpecialValueFor("damage") * 0.01
    if percent < damage_limit then percent = damage_limit end
    local damage = math.ceil(percent * owner:GetStrength() * ability_3:GetSpecialValueFor("damage") * 100  * illusionDamageScale)
    local damageType = ability_3:GetAbilityDamageType()
    radius = radius + 300 * percent
    local unitGroup = GetUnitsInRadius(caster,ability_3,caster:GetAbsOrigin(),radius)
    if ability_3.canTrigger then
        ability_3.canTrigger = false
        CauseDamage(owner,unitGroup,damage,damageType,ability_3)
    end
    ability_3.canTrigger = true
    if caster.timer then
        Timers:ResetDelayTime(caster.timer,1)
    else
        local p = CreateParticle("particles/heroes/spectre/spectre_3.vpcf",PATTACH_ABSORIGIN_FOLLOW,caster)
        caster.timer = Timers:CreateTimer(1,function ()
            ParticleManager:DestroyParticle(p, false)
            if not caster:IsNull() then
                caster.timer = nil
            end
        end)
    end
end
function OnIllusionDeath( t )
    local caster = t.unit
    local owner = t.caster
    caster:AddNoDraw()
    local p = CreateParticle("particles/units/heroes/hero_spectre/spectre_death.vpcf",PATTACH_ABSORIGIN,ownerr,2)
    ParticleManager:SetParticleControl(p, 0, caster:GetAbsOrigin())
    OnIllusionTakeDamage( {unit=caster,caster=owner,DamageTaken=caster:GetMaxHealth()} )
end
function OnTakeDamage( t )
    local caster = t.caster
    local ability = t.ability
    if ability:GetAbilityIndex() == 2 then
        ability.damageRecorder = ability.damageRecorder + t.DamageTaken
    elseif ability:GetAbilityIndex() == 3 then
        local damage_limit = ability:GetSpecialValueFor("damage_limit")
        local regen = ability:GetSpecialValueFor("regen")
        local str = ability:GetSpecialValueFor("str")
        local heal = ability:GetSpecialValueFor("healamount")
        local healAmount = caster:GetStrength() * 0.01 * heal * (100 - caster:GetHealthPercent())
        Heal(caster,healAmount,0,false)
        ability.damageRecorder = ability.damageRecorder + t.DamageTaken
        if ability.damageRecorder > caster:GetMaxHealth() then
            ability.damageRecorder = ability.damageRecorder - caster:GetMaxHealth()
            ability.stackLevel = ability.stackLevel + 1
            PropertySystem(caster,0,str)
            caster:SetBaseHealthRegen(caster:GetBaseHealthRegen() + regen)
        end
        local radius = ability:GetSpecialValueFor("radius")
        local percent = t.DamageTaken / caster:GetMaxHealth()
        if percent < damage_limit then percent = damage_limit end
        local damage = math.ceil(percent * caster:GetStrength() * ability:GetSpecialValueFor("damage") * 100)
        local damageType = ability:GetAbilityDamageType()
        radius = radius + 300 * percent
        local unitGroup = GetUnitsInRadius(caster,ability,caster:GetAbsOrigin(),radius)
        if ability.canTrigger then
            ability.canTrigger = false
            CauseDamage(caster,unitGroup,damage,damageType,ability)
        end
        ability.canTrigger = true
        if ability.timer then
            Timers:ResetDelayTime(ability.timer,1)
        else
            local p = CreateParticle("particles/heroes/spectre/spectre_3.vpcf",PATTACH_ABSORIGIN_FOLLOW,caster)
            ability.timer = Timers:CreateTimer(1,function ()
                ParticleManager:DestroyParticle(p, false)
                ability.timer = nil
            end)
        end
    end
end
function OnSpellStart( t )
    local caster = t.caster
    local ability = t.ability
    if ability:GetAbilityIndex() == 1 then
        if caster.useAbility1 == nil then caster.useAbility1 = false end
        if caster.useAbility1 == false then
            local point = t.target_points[1]
            local casterPos = caster:GetAbsOrigin()
            local direction = (point - casterPos):Normalized()
            local speed = ability:GetSpecialValueFor("speed")
            local radius = ability:GetSpecialValueFor("radius")
            local maxDistance = ability:GetSpecialValueFor("distance")
            point = casterPos + direction * maxDistance
            PrecacheUnitByNameAsync("majia",function()
                local target = CreateUnitByName("majia", point, true, nil, nil, DOTA_TEAM_BADGUYS )
                target:AddNewModifier(target, nil, "modifier_kill", {duration=1.6})
                ability:ApplyDataDrivenModifier(caster, target, "modifier_spectre_1", {duration=1.6})
                CreateTrackingProjectile(caster,target,ability,"particles/econ/items/spectre/spectre_transversant_soul/spectre_transversant_spectral_dagger_tracking.vpcf",speed)
                CreateLinearProjectile(caster,ability,"",casterPos,radius,maxDistance,direction,speed,false)
                local abilityHelp = caster:AddAbility("spectre_1_0")
                abilityHelp:SetLevel(1)
                abilityHelp.casterPos = casterPos
                abilityHelp.target = target
                abilityHelp.speed = speed
                abilityHelp.direction = direction
                abilityHelp.startTime = GameRules:GetGameTime()
                caster:SwapAbilities("spectre_1", "spectre_1_0", false, true)
                caster.useAbility1 = true
                Timers:CreateTimer(1.5,function ()
                    if caster.useAbility1 then
                        caster.useAbility1 = false
                        caster:SwapAbilities("spectre_1", "spectre_1_0", true, false)
                        caster:RemoveAbility("spectre_1_0")
                    end
                end)
            end)
            --CreateLinearProjectile(caster,ability,"particles/econ/items/spectre/spectre_transversant_soul/spectre_transversant_spectral_dagger.vpcf",casterPos,radius,maxDistance,direction,speed,false)
        else
            local time = GameRules:GetGameTime() - ability.startTime
            local pos = ability.casterPos + ability.direction * ability.speed * time
            CreateParticle("particles/heroes/spectre/spectre_2_illusion.vpcf",PATTACH_ABSORIGIN,caster,2)
            SetUnitPosition(ability.target,pos)
            SetUnitPosition(caster,pos)
            CreateParticle("particles/heroes/spectre/spectre_2_illusion.vpcf",PATTACH_ABSORIGIN,caster,2)
            caster.useAbility1 = false
            caster:SwapAbilities("spectre_1", "spectre_1_0", true, false)
            caster:RemoveAbility("spectre_1_0")
        end
    elseif ability:GetAbilityIndex() == 4 then
        local target = t.target
        local damage = ability:GetSpecialValueFor("damage") * caster:GetStrength()
        local damageType = ability:GetAbilityDamageType()
        local damageCount = ability:GetSpecialValueFor("damage_count")
        local soulLoss = ability:GetSpecialValueFor("soul_loss")
        local maxDamageBonus = ability:GetSpecialValueFor("max_bonus_damage")
        local duration = ability:GetSpecialValueFor("duration")
        local stunDuration = ability:GetSpecialValueFor("stun_duration")
        local armor = target:GetPhysicalArmorValue()
        local resistance = target:GetMagicalArmorValue() * 100
        local targetHealthPercent = target:GetHealthPercent()
        -- buff
        ability:ApplyDataDrivenModifier(caster, target, "modifier_spectre_4_stun", {duration=stunDuration})
        ability:ApplyDataDrivenModifier(caster, target, "modifier_spectre_4_debuff", {duration=duration})
        target:AddNewModifier(caster, ability, "armor", {armor=-armor,duration=stunDuration})
        --target:AddNewModifier(caster, ability, "resistance", {resistance=-resistance,duration=stunDuration})
        SetBaseResistance(target,0,stunDuration + 0.1)
        SetUnitMagicDamagePercent(target,-soulLoss,duration)
        target:AddNewModifier(caster, ability, "health_extra", {health=-target:GetMaxHealth() * soulLoss * 0.01,duration=duration})
        -- damage
        Timers:CreateTimer(stunDuration,function ()
            local loseHealthPercent = targetHealthPercent - target:GetHealthPercent()
            local bonusDamage = 0
            if loseHealthPercent > 0 then
                if loseHealthPercent > 10 then loseHealthPercent = 10 end
                bonusDamage = target:GetMaxHealth() * loseHealthPercent * 0.01
            end
            for i=1,damageCount do
                CauseDamage(caster,target,damage + bonusDamage,damageType,ability)
                print(target:GetMagicalArmorValue())
            end
        end)
        -- particle
        local pLock = CreateParticle("particles/heroes/spectre/spectre_4_lock.vpcf",PATTACH_CUSTOMORIGIN_FOLLOW,caster,4)
        ParticleManager:SetParticleControlEnt(pLock, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
        for i=1,4 do
            local p = CreateParticle("particles/heroes/spectre/spectre_4.vpcf",PATTACH_ABSORIGIN,caster,4)
            ParticleManager:SetParticleControl(p, 0, target:GetAbsOrigin())
            ParticleManager:SetParticleControl(p, 1, target:GetAbsOrigin())
            local direction = (GetRotationPoint(target:GetAbsOrigin(),100,i*90)-target:GetAbsOrigin()):Normalized()
            ParticleManager:SetParticleControlForward(p, 0, direction)
            ParticleManager:SetParticleControlForward(p, 1, direction)
            local impact = CreateParticle("particles/heroes/spectre/spectre_4_impact.vpcf",PATTACH_ABSORIGIN,caster,4)
            ParticleManager:SetParticleControl(impact, 0, GetRotationPoint(target:GetAbsOrigin(),600,i*90))
            ParticleManager:SetParticleControl(impact, 1, GetRotationPoint(target:GetAbsOrigin(),600,i*90))
        end
    end
end
function OnProjectileHitUnit( t )
    local caster = t.caster
    local target = t.target
    local ability = t.ability
    local damage = ability:GetSpecialValueFor("damage") * caster:GetStrength()
    local damageType = ability:GetAbilityDamageType()
    CauseDamage(caster,target,damage,damageType,ability)
end