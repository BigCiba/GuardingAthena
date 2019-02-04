LinkLuaModifier("health_extra","modifiers/generic/health_extra.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("armor","modifiers/generic/armor.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_spectre_health","modifiers/hero/modifier_spectre_health.lua",LUA_MODIFIER_MOTION_NONE)
--LinkLuaModifier("resistance","modifiers/generic/resistance.lua",LUA_MODIFIER_MOTION_NONE)
function OnCreated( t )
    local caster = t.caster
    local ability = t.ability
    if ability:GetAbilityIndex() == 0 then
        ability.cooldown_reduce = false
    elseif ability:GetAbilityIndex() == 2 then
        ability.damageRecorder = 0
    elseif ability:GetAbilityIndex() == 3 then
        ability.canTrigger = true
        ability.damageRecorder = 0
        ability.stackLevel = 0
        ability.health = 0
        caster.bounceTag = false
        AddDamageFilterVictim(caster,"spectre_3",function (damage,attacker)
            local lossHealthPercent = 100 - caster:GetHealthPercent()
            local reduce = (ability:GetSpecialValueFor("max_reduce") / 100) * lossHealthPercent * 0.01
            damage = damage * (1 - reduce)
            return damage
        end)
    end
end
function OnDeath( t )
    local caster = t.caster
    if HasExclusive(caster,2) then
        local ability = caster:GetAbilityByIndex(2)
        local loc = caster:GetAbsOrigin()
        local healthCost = caster:GetHealth() * 0.3
        local radius = ability:GetSpecialValueFor("radius")
        local damage = ability:GetSpecialValueFor("damage_active") * healthCost
        local damageType = ability:GetAbilityDamageType()
        local p = CreateParticle("particles/heroes/spectre/spectre_2_tentacle.vpcf",PATTACH_ABSORIGIN,GuardingAthena.entAthena,2.5)
        ParticleManager:SetParticleControl( p, 0, caster:GetAbsOrigin())
        -- shock
        local unitGroup = GetUnitsInRadius(caster,ability,loc,radius)
        for k,v in pairs(unitGroup) do
            ability:ApplyDataDrivenModifier(caster, v, "modifier_spectre_2_debuff", nil)
            v:Stop()
        end
        local count = 0
        Timers:CreateTimer(function ()
            if count < 30 then
                local unitGroup = GetUnitsInRadius(caster,ability,loc,radius)
                CauseDamage(caster,unitGroup,damage * 0.1,damageType,ability)
                count = count + 1
                return 0.1
            end
        end)
    end
end
function OnExclusiveCreated( t )
    local caster = t.caster
    AddDamageFilterVictim(caster,"spectre",function (damage,attacker)
        if HasExclusive(caster,3) then
            local hpLimit = caster:GetMaxHealth() * 0.25
            if damage > hpLimit then damage = hpLimit end
            return damage
        end
        return damage
    end)
end
function OnExclusiveDestory( t )
    local caster = t.caster
    RemoveDamageFilterVictim(caster,"spectre")
end
function OnAttackLanded( t )
    local caster = t.caster
    local target = t.target
    local ability = t.ability
    local damageMax = ability:GetSpecialValueFor("damage") + ability.damageRecorder
    if damageMax > ability:GetSpecialValueFor("damage_limit") then damageMax = ability:GetSpecialValueFor("damage_limit") end
    local damage = RandomFloat(1, damageMax * caster:GetStrength() )
    ability.damageRecorder = 0
    local damageType = ability:GetAbilityDamageType()
    ability.no_damage_filter = true
    CauseDamage(caster,caster,caster:GetMaxHealth() * 0.01,damageType,ability)
    ability.no_damage_filter = nil
    CauseDamage(caster,target,damage,damageType,ability)
    CreateNumberEffect(target,damage,1,MSG_ORIT,{199,21,133},6)
    local p = CreateParticle("particles/econ/items/spectre/spectre_weapon_diffusal/spectre_desolate_diffusal.vpcf",PATTACH_CUSTOMORIGIN,caster,2)
    ParticleManager:SetParticleControl( p, 0, target:GetAbsOrigin() + Vector(0,0,64))
    ParticleManager:SetParticleControlForward( p, 0, (target:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized())
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
    target:SetBaseMaxHealth(caster:GetMaxHealth())
    target:SetMaxHealth(caster:GetMaxHealth())
    target:SetHealth(target:GetMaxHealth() * health)
    target.attack_count = 3
    ability:ApplyDataDrivenModifier(caster, target, "modifier_spectre_0_illusion", nil)
    CreateParticle("particles/heroes/spectre/spectre_2_illusion.vpcf",PATTACH_ABSORIGIN,target,2)
end
function OnIllusionAttackLanded( t )
    local caster = t.attacker
    local owner = t.caster
    local target = t.target
    local ability = t.ability
    local ability_2 = owner:GetAbilityByIndex(2)
    local damagePercent = ability:GetSpecialValueFor("damage") * 0.01
    if HasExclusive(owner,1) then damagePercent = 1 end
    if ability_2:GetLevel() > 0 then
        local damage = RandomFloat(1, ability_2:GetSpecialValueFor("damage") * owner:GetStrength() * damagePercent) 
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
        local p = CreateParticle("particles/econ/items/spectre/spectre_weapon_diffusal/spectre_desolate_diffusal.vpcf",PATTACH_CUSTOMORIGIN,owner,2)
        ParticleManager:SetParticleControlEnt( p, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true )
        ParticleManager:SetParticleControlEnt( p, 4, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true )
    end
end
function OnIllusionTakeDamage( t )
    local caster = t.unit
    local owner = t.caster
    local ability_0 = owner:GetAbilityByIndex(0)
    local ability_3 = owner:GetAbilityByIndex(3)
    if ability_3:GetLevel() > 0 then
        local damage_limit = ability_3:GetSpecialValueFor("damage_limit")
        local radius = ability_3:GetSpecialValueFor("radius")
        local percent = t.DamageTaken / caster:GetMaxHealth()
        local illusionDamageScale = ability_0:GetSpecialValueFor("damage") * 0.01
        if percent < damage_limit then percent = damage_limit end
        --print(percent.." and "..illusionDamageScale)
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
end
function OnIllusionDeath( t )
    local caster = t.unit
    local owner = t.caster
    caster:AddNoDraw()
    local p = CreateParticle("particles/units/heroes/hero_spectre/spectre_death.vpcf",PATTACH_ABSORIGIN,owner,2)
    ParticleManager:SetParticleControl(p, 0, caster:GetAbsOrigin())
    OnIllusionTakeDamage( {unit=caster,caster=owner,DamageTaken=caster:GetMaxHealth()} )
end
function OnTakeDamage( t )
    local caster = t.caster
    local ability = t.ability
    if ability:GetAbilityIndex() == 2 then
        ability.damageRecorder = ability.damageRecorder + ability:GetSpecialValueFor("damage_add")
    elseif ability:GetAbilityIndex() == 3 then
        local damage_limit = ability:GetSpecialValueFor("damage_limit")
        local regen = ability:GetSpecialValueFor("regen")
        local str = ability:GetSpecialValueFor("str")
        local heal = ability:GetSpecialValueFor("healamount")
        local health = math.ceil(caster:GetMaxHealth() * 0.01)
        local healAmount = caster:GetStrength() * 0.01 * heal * (100 - caster:GetHealthPercent())
        local percent = t.DamageTaken / caster:GetMaxHealth()
        -- damge percent no less than limitation and no more than 1
        if percent < damage_limit then percent = damage_limit end
        if percent > 1 then percent = 1 end
        -- Heal(caster,healAmount,0,false)
        -- damage record
        ability.damageRecorder = ability.damageRecorder + t.DamageTaken
        if ability.damageRecorder > caster:GetMaxHealth() then
            ability.damageRecorder = ability.damageRecorder - caster:GetMaxHealth()
            ability.stackLevel = ability.stackLevel + 1
            PropertySystem(caster,0,str)
            ability.health = ability.health + health
            caster:RemoveModifierByName("modifier_spectre_health")
            caster:AddNewModifier(caster, ability, "modifier_spectre_health", {health=ability.health})
            caster:SetBaseHealthRegen(caster:GetBaseHealthRegen() + regen)
        end
        -- damage
        local radius = ability:GetSpecialValueFor("radius")
        local maxRadius = ability:GetSpecialValueFor("max_radius")
        local damage = math.ceil(percent * caster:GetStrength() * ability:GetSpecialValueFor("damage") * 100)
        local damageType = ability:GetAbilityDamageType()
        radius = radius + 300 * percent
        if radius > maxRadius then radius = maxRadius end
        local unitGroup = GetUnitsInRadius(caster,ability,caster:GetAbsOrigin(),radius)
        if ability.canTrigger then
            ability.canTrigger = false
            caster.bounceTag = true
            CauseDamage(caster,unitGroup,damage,damageType,ability)
            caster.bounceTag = false
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
function OnIntervalThink( t )
    local caster = t.caster
    local target = t.target
    target:MoveToPosition(target:GetAbsOrigin() + Vector(RandomInt(-200, 200),RandomInt(-200, 200),0))
end
function OnSpellStart( t )
    local caster = t.caster
    local ability = t.ability
    if ability:GetAbilityIndex() == 0 then
        local unitGroup = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), caster, 2000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, 0, 0, false)
        for k,v in pairs(unitGroup) do
            if v:GetUnitName() == "spectre" then
                v:ForceKill(false)
            end
        end
    elseif ability:GetAbilityIndex() == 1 then
        local perDamage = ability:GetSpecialValueFor("per_damage") * caster:GetStrength()
        local damageType = ability:GetAbilityDamageType()
        local duration = ability:GetSpecialValueFor("duration")
        local count = duration * 10
        if caster.useAbility1 == nil then caster.useAbility1 = false end
        if caster.useAbility1 == false then
            local point = t.target_points[1]
            local casterPos = caster:GetAbsOrigin()
            local direction = (point - casterPos):Normalized()
            local speed = ability:GetSpecialValueFor("speed")
            local radius = ability:GetSpecialValueFor("radius")
            local maxDistance = ability:GetSpecialValueFor("distance")
            point = casterPos + direction * maxDistance
            local abilityHelp = caster:AddAbility("spectre_1_0")
            abilityHelp:SetLevel(1)
            ability.casterPos = casterPos
            ability.target = target
            ability.speed = speed
            ability.direction = direction
            ability.startTime = GameRules:GetGameTime()
            abilityHelp.ability = ability
            caster:SwapAbilities("spectre_1", "spectre_1_0", false, true)
            caster.useAbility1 = true
            Timers:CreateTimer(1.5,function ()
                if caster.useAbility1 then
                    caster.useAbility1 = false
                    caster:SwapAbilities("spectre_1", "spectre_1_0", true, false)
                    caster:RemoveAbility("spectre_1_0")
                    ForWithInterval(count,duration / count,function ()
                        local unitGroup = GetUnitsInLine(caster,ability,casterPos,point,150)
                        for k,v in pairs(unitGroup) do
                            ability:ApplyDataDrivenModifier(caster, v, "modifier_spectre_1_debuff", {duration=1})
                        end
                        CauseDamage(caster,unitGroup,perDamage / 10,damageType,ability)
                    end)
                end
            end)
            caster.linearP = CreateLinearProjectile(caster,ability,"particles/econ/items/spectre/spectre_transversant_soul/spectre_transversant_spectral_dagger.vpcf",casterPos,radius,maxDistance,direction,speed,false)
        else
            local ability_1 = ability.ability
            local time = GameRules:GetGameTime() - ability_1.startTime
            local pos = ability_1.casterPos + ability_1.direction * ability_1.speed * time
            CreateParticle("particles/heroes/spectre/spectre_2_illusion.vpcf",PATTACH_ABSORIGIN,caster,2)
            SetUnitPosition(caster,pos)
            CreateParticle("particles/heroes/spectre/spectre_2_illusion.vpcf",PATTACH_ABSORIGIN,caster,2)
            caster.useAbility1 = false
            caster:SwapAbilities("spectre_1", "spectre_1_0", true, false)
            caster:RemoveAbility("spectre_1_0")
            ProjectileManager:DestroyLinearProjectile(caster.linearP)
            local perDamage = ability_1:GetSpecialValueFor("per_damage") * caster:GetStrength()
            local damageType = ability_1:GetAbilityDamageType()
            local duration = ability_1:GetSpecialValueFor("duration")
            local count = duration * 10
            ForWithInterval(count,duration / count,function ()
                local unitGroup = GetUnitsInLine(caster,ability_1,ability_1.casterPos,pos,150)
                for k,v in pairs(unitGroup) do
                    ability_1:ApplyDataDrivenModifier(caster, v, "modifier_spectre_1_debuff", {duration=1})
                end
                CauseDamage(caster,unitGroup,perDamage / 10,damageType,ability_1)
            end)
        end
    -- ability2
    elseif ability:GetAbilityIndex() == 2 then
        local healthCost = caster:GetHealth() * 0.3
        local radius = ability:GetSpecialValueFor("radius")
        local heal = ability:GetSpecialValueFor("heal")
        local damage = ability:GetSpecialValueFor("damage_active") * healthCost
        local damageType = ability:GetAbilityDamageType()
        RemoveHealth(caster,healthCost)
        --[[ability.no_damage_filter = true
        CauseDamage(caster,caster,healthCost,DAMAGE_TYPE_PURE,ability)
        ability.no_damage_filter = nil]]
        -- damage max
        caster:GetAbilityByIndex(3).damageRecorder = caster:GetAbilityByIndex(3).damageRecorder + healthCost
        CauseDamage(caster,caster,0,DAMAGE_TYPE_PURE,ability)
        CreateParticle("particles/heroes/spectre/spectre_2_tentacle.vpcf",PATTACH_ABSORIGIN,caster,0.5)
        -- shock
        local unitGroup = GetUnitsInRadius(caster,ability,caster:GetAbsOrigin(),radius)
        for k,v in pairs(unitGroup) do
            ability:ApplyDataDrivenModifier(caster, v, "modifier_spectre_2_debuff", nil)
            v:Stop()
        end
        local count = 0
        Timers:CreateTimer(function ()
            if count < 10 then
                local unitGroup = GetUnitsInRadius(caster,ability,caster:GetAbsOrigin(),radius)
                CauseDamage(caster,unitGroup,damage * 0.1,damageType,ability)
                Heal(caster,heal * damage * #unitGroup * 0.1,0,false)
                count = count + 1
                return 0.1
            end
        end)
    -- ability4
    elseif ability:GetAbilityIndex() == 4 then
        local target = t.target
        local radius = ability:GetSpecialValueFor("radius")
        local damage = ability:GetSpecialValueFor("damage") * caster:GetStrength()
        local damageType = ability:GetAbilityDamageType()
        local damageCount = ability:GetSpecialValueFor("damage_count")
        local soulLoss = ability:GetSpecialValueFor("soul_loss")
        local maxDamageBonus = ability:GetSpecialValueFor("max_bonus_damage")
        local damageDeepen = ability:GetSpecialValueFor("damage_deepen")
        local duration = ability:GetSpecialValueFor("duration")
        local stunDuration = ability:GetSpecialValueFor("stun_duration")
        local damageTimePoint = ability:GetSpecialValueFor("damage_time_point")
        local armor = target:GetPhysicalArmorValue()
        local resistance = target:GetMagicalArmorValue() * 100
        --local targetHealthPercent = target:GetHealthPercent()
        -- buff
        ability:ApplyDataDrivenModifier(caster, target, "modifier_spectre_4_stun", {duration=stunDuration})
        ability:ApplyDataDrivenModifier(caster, target, "modifier_spectre_4_debuff", {duration=duration})
        SetModifierType(target,"modifier_spectre_4_stun","unpurgable")
        SetModifierType(target,"modifier_spectre_4_debuff","unpurgable")
        target:AddNewModifier(caster, ability, "armor", {armor=-armor,duration=stunDuration})
        -- slience
        local unitGroup = GetUnitsInRadius(caster,ability,target:GetAbsOrigin(),radius)
        for k,v in pairs(unitGroup) do
            ability:ApplyDataDrivenModifier(caster, v, "modifier_spectre_4_slience", {duration=5})
        end
        --target:AddNewModifier(caster, ability, "resistance", {resistance=-resistance,duration=stunDuration})
        SetBaseResistance(target,0,stunDuration + 0.1)
        SetUnitDamagePercent(target,-soulLoss,duration)
        --SetUnitMagicDamagePercent(target,-soulLoss,duration)
        target:AddNewModifier(caster, ability, "health_extra", {health=-target:GetMaxHealth() * soulLoss * 0.01,duration=duration})
        -- damage deepen
        SetUnitIncomingDamageDeepen(target,damageDeepen,stunDuration)
        -- damage
        Timers:CreateTimer(damageTimePoint,function ()
            local loseHealthPercent = 100 - target:GetHealthPercent()
            unitGroup = GetUnitsInRadius(caster,ability,target:GetAbsOrigin(),radius)
            local bonusDamage = 0
            if loseHealthPercent > 0 then
                if loseHealthPercent > 10 then loseHealthPercent = 10 end
                bonusDamage = target:GetMaxHealth() * loseHealthPercent * 0.01
            end
            for i=1,damageCount do
                CauseDamage(caster,unitGroup,damage + bonusDamage,damageType,ability)
            end
            local p = CreateParticle("particles/heroes/spectre/spectre_4_explode.vpcf",PATTACH_ABSORIGIN,caster,4)
            ParticleManager:SetParticleControl(p, 0, target:GetAbsOrigin())
            ParticleManager:SetParticleControl(p, 1, Vector(600,600,300))
            local p = CreateParticle("particles/heroes/spectre/spectre_4_impact_f.vpcf",PATTACH_ABSORIGIN,caster,4)
            ParticleManager:SetParticleControl(p, 1, target:GetAbsOrigin())
        end)
        -- particle
        local pLock = CreateParticle("particles/heroes/spectre/spectre_4_lock.vpcf",PATTACH_CUSTOMORIGIN_FOLLOW,caster,stunDuration)
        ParticleManager:SetParticleControlEnt(pLock, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
        local pGound = CreateParticle("particles/heroes/spectre/spectre_4_somke.vpcf",PATTACH_ABSORIGIN,caster,4)
        ParticleManager:SetParticleControl(pGound, 0, target:GetAbsOrigin())
        ParticleManager:SetParticleControl(pGound, 1, Vector(600,600,600))
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
function OnAbilityExecuted( t )
    local caster = t.caster
    if HasExclusive(caster,4) then
        local target = t.target
        local ability = t.event_ability
        local cdReduce = t.ability:GetSpecialValueFor("cd_reduce") * 0.01
        local duration = ability:GetSpecialValueFor("stun_duration") + 0.1
        if ability:GetAbilityName() == "spectre_4" then
            Timers:CreateTimer(duration,function ()
                if not target:IsAlive() then
                    local cdRem = ability:GetCooldownTimeRemaining()
                    ability:EndCooldown()
                    ability:StartCooldown(cdRem * cdReduce)
                end
            end)
        end
    end
end
function OnProjectileHitUnit( t )
    local caster = t.caster
    local target = t.target
    local ability = t.ability
    local damage = ability:GetSpecialValueFor("damage") * caster:GetStrength() + ability:GetSpecialValueFor("base_damage")
    local damageType = ability:GetAbilityDamageType()
    CauseDamage(caster,target,damage,damageType,ability)
end