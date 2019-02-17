function OnDeath(t)
    local caster = t.caster
    local target = t.target
    local ability = t.ability
    local lv = caster:GetLevel()
    local exp = math.ceil((XP_PER_LEVEL_TABLE[lv+1] - XP_PER_LEVEL_TABLE[lv]) * 0.3)
    AddModifierStackCount(caster,caster,ability,"modifier_oracle_0_stack",1)
    caster:AddExperience(exp, DOTA_ModifyXP_CreepKill, false, false)
end
function OnCreated(t)
    local caster = t.caster
    local ability = t.ability
    local abilityIndex = ability:GetAbilityIndex()
    if abilityIndex == 0 then
        local target = t.target
        local bonusDamage = ability:GetSpecialValueFor("bonus_damage") + caster:GetModifierStackCount("modifier_oracle_0_stack", caster) * ability:GetSpecialValueFor("bonus_damage_add")
        AddDamageFilterVictim(target,"oracle_0",function (damage,attacker)
            if attacker == caster then
                damage = damage * (1 + bonusDamage * 0.01)
            end
            return damage
        end)
    elseif abilityIndex == 1 then
        local duration = ability:GetSpecialValueFor("duration")
        local percent = ability:GetSpecialValueFor("damage_reduce")
        SetUnitDamagePercent(t.target,percent,duration)
    end
end
function OnDestroy(t)
    local caster = t.caster
    local ability = t.ability
    local abilityIndex = ability:GetAbilityIndex()
    if abilityIndex == 0 then
        local target = t.target
        RemoveDamageFilterVictim(target,"oracle_0")
    end
end
function OnSpellStart(t)
    local caster = t.caster
    local ability = t.ability
    local abilityIndex = ability:GetAbilityIndex()
    if abilityIndex == 0 then

    elseif abilityIndex == 1 then
        local point = t.target_points[1]
        local damage = ability:GetSpecialValueFor("intellect_damage") * caster:GetIntellect() + ability:GetSpecialValueFor("base_damage")
        local damageType = ability:GetAbilityDamageType()
        local duration = ability:GetSpecialValueFor("duration")
        local radius = ability:GetSpecialValueFor("radius")
        local p = CreateParticle("particles/units/heroes/hero_oracle/oracle_purifyingflames_hit.vpcf",PATTACH_ABSORIGIN,caster,duration)
        ParticleManager:SetParticleControl(p, 0, point)
        ParticleManager:SetParticleControl(p, 1, point)
        local unitGroup = GetUnitsInRadius(caster,ability,point,radius)
        for _, unit in pairs(unitGroup) do
            CauseDamage(caster,unit,damage,damageType,ability)
            AddModifierStackCount(caster,unit,ability,"modifier_oracle_1_debuff",1,duration,true)
            --ability:ApplyDataDrivenModifier(caster, unit, "modifier_oracle_1_debuff", nil)
        end
    elseif abilityIndex == 4 then
        local point = t.target_points[1]
        local damage = ability:GetSpecialValueFor("intellect_damage") * caster:GetIntellect()
        local damageType = ability:GetAbilityDamageType()
        local pullDuration = ability:GetSpecialValueFor("pull_duration")
        local stunDuration = ability:GetSpecialValueFor("stun_duration")
        local imprisonDuration = ability:GetSpecialValueFor("imprison_duration")
        local radius = ability:GetSpecialValueFor("radius")
        local p = CreateParticle("particles/heroes/oracle/oracle_4_circle.vpcf",PATTACH_ABSORIGIN,caster,3)
        ParticleManager:SetParticleControl(p, 0, point)
        local unitGroup = GetUnitsInRadius(caster,ability,point,radius)
        for _, unit in pairs(unitGroup) do
            CauseDamage(caster,unit,damage,damageType,ability)
            ability:ApplyDataDrivenModifier(caster, unit, "modifier_oracle_4_debuff", {duration=stunDuration})
        end
        local time = 0
        Timers:CreateTimer(1.5,function()
            local unitGroup = GetUnitsInRadius(caster,ability,point,radius)
            if time <= pullDuration then    --吸引周围单位
                for i,unit in ipairs(unitGroup) do
                    local unit_location = unit:GetAbsOrigin()
                    local vector_distance = point - unit_location
                    local distance = (vector_distance):Length2D()
                    local direction = (vector_distance):Normalized()
                    local speed = distance / 15
                    SetUnitPosition(unit, unit_location + direction * speed, true)
                    unit:AddNewModifier(nil, nil, "modifier_phased", {duration = 0.1})
                    ability:ApplyDataDrivenModifier(caster, unit, "modifier_oracle_4_debuff", {duration=stunDuration - 1.5 - time})
                end
                time = time + 0.03
                return 0.03
            else
                local p = CreateParticle("particles/heroes/oracle/oracle_4_imprison.vpcf",PATTACH_ABSORIGIN,caster,imprisonDuration)
                ParticleManager:SetParticleControl(p, 0, point)
                CreateSound("Hero_ObsidianDestroyer.AstralImprisonment.Cast",caster)
                for i,unit in ipairs(unitGroup) do
                    ability:ApplyDataDrivenModifier(caster, unit, "modifier_oracle_4_debuff", {duration=imprisonDuration})
                    SetModifierType(unit,"modifier_oracle_4_debuff","unpurgable")
                    unit:AddNoDraw()
                    AddDamageFilterVictim(unit,"oracle_4",function (damage,attacker)
                        if attacker == caster then
                            return damage
                        end
                        return 0
                    end)
                    Timers:CreateTimer(imprisonDuration,function ()
                        unit:RemoveNoDraw()
                        RemoveDamageFilterVictim(unit,"oracle_4")
                    end)
                end
            end
        end)
    end
end
function OnIntervalThink(t)
    local caster = t.caster
    local ability = t.ability
    local abilityIndex = ability:GetAbilityIndex()
    if abilityIndex == 0 then

    elseif abilityIndex == 1 then
        local target = t.target
        if target == caster then
            local heal = ability:GetSpecialValueFor("damage_per_second") * caster:GetIntellect() * ability:GetSpecialValueFor("interval")
            Heal(caster,heal,0,false)
        else
            local damage = ability:GetSpecialValueFor("damage_per_second") * caster:GetIntellect() * ability:GetSpecialValueFor("interval") * target:GetModifierStackCount("modifier_oracle_1_debuff", caster)
            local damageType = ability:GetAbilityDamageType()
            CauseDamage(caster,target,damage,damageType,ability)
        end
    elseif abilityIndex == 2 then

    elseif abilityIndex == 3 then

    elseif abilityIndex == 4 then
        
    end
end
function OnHealth(t)
    PrintTable(t)
end
function OnHeal(t)
    PrintTable(t)
end