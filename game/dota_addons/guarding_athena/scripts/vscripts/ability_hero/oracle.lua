function OnDeath(t)
    local caster = t.caster
    local target = t.target
    local ability = t.ability
    local lv = caster:GetLevel()
    local reborntimes = caster.reborn_time or 0
    AddModifierStackCount(caster,caster,ability,"modifier_oracle_0_stack",1)
	if lv >= (reborntimes + 1) * 100 then
		return
	end
    local exp = math.ceil((XP_PER_LEVEL_TABLE[lv+1] - XP_PER_LEVEL_TABLE[lv]) * 0.3)
    caster:AddExperience(exp, DOTA_ModifyXP_CreepKill, false, false)
end
function AutoCast( t )
    local caster = t.caster
    local ability = t.ability
    ability.timers = Timers:CreateTimer(function ()
        local unitGroup = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), caster, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY,  DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, 0, false)
        local target = unitGroup[RandomInt(1, #unitGroup)]
        if ability:GetAutoCastState() and ability:IsCooldownReady() and target then
            CastAbility(caster,DOTA_UNIT_ORDER_CAST_TARGET,ability,target)
        end
        return 0.5
    end)
end
function OnCreated(t)
    local caster = t.caster
    local ability = t.ability
    local abilityIndex = ability:GetAbilityIndex()
    if abilityIndex == 0 then
        local target = t.target
        if target:GetTeam() == caster:GetTeam() then
            AddDamageFilterVictim(target,"oracle_0",function (damage,attacker)
                if damage >= target:GetHealth() then
                    Heal(target,target:GetMaxHealth(),target:GetMaxMana(),true)
                    CreateParticle("particles/items_fx/aegis_respawn.vpcf",PATTACH_ABSORIGIN,target,5)
                    target:RemoveModifierByName("modifier_oracle_0_buff")
                    return 0
                end
                return damage
            end)
        else
            local bonusDamage = ability:GetSpecialValueFor("bonus_damage") + caster:GetModifierStackCount("modifier_oracle_0_stack", caster) * ability:GetSpecialValueFor("bonus_damage_add")
            AddDamageFilterVictim(target,"oracle_0",function (damage,attacker)
                if attacker == caster then
                    damage = damage * (1 + bonusDamage * 0.01)
                end
                return damage
            end)
        end
    elseif abilityIndex == 1 then
        local percent = ability:GetSpecialValueFor("damage_reduce")
        SetUnitDamagePercent(t.target,percent)
    elseif abilityIndex == 2 then
        local duration = ability:GetSpecialValueFor("duration")
        local reduce_old = caster.oracleReduce or 0
        caster.orecle_2_reduce_rate = ability:GetSpecialValueFor("cooldown") * 0.01
        caster.oracleReduce = reduce_old + caster.orecle_2_reduce_rate
        if HasExclusive(caster,3) then
            PropertySystem(caster,2,math.ceil(caster:GetBaseIntellect() * 0.15),duration)
        end
    elseif abilityIndex == 3 then
        local block_count = ability:GetSpecialValueFor("block_count")
        local block_duration = ability:GetSpecialValueFor("block_duration")
        caster:SetModifierStackCount("modifier_oracle_3", caster, block_count)
        AddDamageFilterVictim(caster,"oracle_3",function (damage,attacker)
            if not caster:HasModifier("modifier_oracle_3_block") then
                ability:ApplyDataDrivenModifier(caster, caster, "modifier_oracle_3_block", {duration=block_duration})
                CreateParticle("particles/heroes/oracle/oracle_3_block.vpcf",PATTACH_ABSORIGIN_FOLLOW,caster,block_duration)
                local stackCount = caster:GetModifierStackCount("modifier_oracle_3", caster)
                if stackCount == 1 then
                    Timers:CreateTimer(block_duration,function ()
                        caster:RemoveModifierByName("modifier_oracle_3")
                    end)
                else
                    caster:SetModifierStackCount("modifier_oracle_3", caster, stackCount - 1)
                end
            end
            if attacker.oracle_3_block == nil then
                CreateTrackingProjectile(caster,attacker,ability,"particles/units/heroes/hero_oracle/oracle_fortune_prj.vpcf",2000)
                attacker.oracle_3_block = true
                Timers:CreateTimer(block_duration,function ()
                attacker.oracle_3_block = nil
                end)
            end
            return 0
        end)
    end
end
function OnDestroy(t)
    local caster = t.caster
    local ability = t.ability
    local abilityIndex = ability:GetAbilityIndex()
    if abilityIndex == 0 then
        local target = t.target
        RemoveDamageFilterVictim(target,"oracle_0")
    elseif abilityIndex == 1 then
        local percent = ability:GetSpecialValueFor("damage_reduce")
        SetUnitDamagePercent(t.target,-percent)
    elseif abilityIndex == 2 then
        caster.oracleReduce = caster.oracleReduce - caster.orecle_2_reduce_rate
    elseif abilityIndex == 3 then
        RemoveDamageFilterVictim(caster,"oracle_3")
    end
end
function OnSpellStart(t)
    local caster = t.caster
    local ability = t.ability
    local abilityIndex = ability:GetAbilityIndex()
    if abilityIndex == 0 then
        local target = t.target
        if target:GetTeam() == caster:GetTeam() then
            if HasExclusive(caster,1) then
                ability:ApplyDataDrivenModifier(caster, target, "modifier_oracle_0_buff", nil)
            else
                ability:EndCooldown()
                caster:GiveMana(50)
            end
        else
            ability:ApplyDataDrivenModifier(caster, target, "modifier_oracle_0_debuff", nil)
        end
    elseif abilityIndex == 1 then
        if t.cd == nil then
            local reduce = caster.oracleReduce or 0
            ability:EndCooldown()
            ability:StartCooldown(ability:GetCooldown( ability:GetLevel() - 1 ) * (1 - reduce))
        end
        local point = t.target_points[1]
        local level = ability:GetLevel() - 1
        \][jk890-\]
        local bonus_level = caster:HasModifier("modifier_oracle_2") and caster:FindAbilityByName("oracle_2"):GetSpecialValueFor("base_level") or 0
        local damage = (ability:GetSpecialValueFor("intellect_damage") + increment_intellect_damage * bonus_level) * caster:GetIntellect() + (ability:GetSpecialValueFor("base_damage") + increment_base_damage * bonus_level)
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
    elseif abilityIndex == 2 then
    elseif abilityIndex == 3 then
    elseif abilityIndex == 4 then
        local point = t.target_points[1]
        local level = ability:GetLevel() - 1
        local increment_intellect_damage = ability:GetLevelSpecialValueFor("intellect_damage", 2) - ability:GetLevelSpecialValueFor("intellect_damage", 1)
        local bonus_level = caster:HasModifier("modifier_oracle_2") and caster:FindAbilityByName("oracle_2"):GetSpecialValueFor("util_level") or 0
        local damage = (ability:GetSpecialValueFor("intellect_damage") + increment_intellect_damage * bonus_level) * caster:GetIntellect()
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
                            return damage * 2
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
        local level = ability:GetLevel() - 1
        local increment_intellect_damage = ability:GetLevelSpecialValueFor("damage_per_second", 2) - ability:GetLevelSpecialValueFor("damage_per_second", 1)
        local bonus_level = caster:HasModifier("modifier_oracle_2") and caster:FindAbilityByName("oracle_2"):GetSpecialValueFor("base_level") or 0
        local damage = (ability:GetSpecialValueFor("damage_per_second") + increment_intellect_damage * bonus_level) * caster:GetIntellect()
        if target == caster then
            local heal = damage * ability:GetSpecialValueFor("interval")
            Heal(caster,heal,0,false)
        else
            damage = damage * ability:GetSpecialValueFor("interval") * target:GetModifierStackCount("modifier_oracle_1_debuff", caster)
            local damageType = ability:GetAbilityDamageType()
            CauseDamage(caster,target,damage,damageType,ability)
        end
    elseif abilityIndex == 2 then

    elseif abilityIndex == 3 then

    elseif abilityIndex == 4 then
        
    end
end
function OnProjectileHitUnit(t)
    local caster = t.caster
    local ability = t.ability
    local abilityIndex = ability:GetAbilityIndex()
    if abilityIndex == 0 then

    elseif abilityIndex == 1 then

    elseif abilityIndex == 2 then

    elseif abilityIndex == 3 then
        local target = t.target
        local level = ability:GetLevel() - 1
        local increment_intellect_damage = ability:GetLevelSpecialValueFor("damage", 2) - ability:GetLevelSpecialValueFor("damage_per_second", 1)
        local increment_base_damage = ability:GetLevelSpecialValueFor("base_damage", 2) - ability:GetLevelSpecialValueFor("base_damage", 1)
        local bonus_level = caster:HasModifier("modifier_oracle_2") and caster:FindAbilityByName("oracle_2"):GetSpecialValueFor("base_level") or 0
        local damage = (ability:GetSpecialValueFor("damage") + increment_intellect_damage * bonus_level) * caster:GetIntellect() + (ability:GetSpecialValueFor("base_damage") + increment_base_damage * bonus_level)
        local damageType = ability:GetAbilityDamageType()
        CauseDamage(caster,target,damage,damageType,ability)
        if HasExclusive(caster,2) then
            ability:ApplyDataDrivenModifier(caster, target, "modifier_oracle_3_root", nil)
        end
    elseif abilityIndex == 4 then
        
    end
end
function OnExclusiveThink(t)
    local caster = t.caster
    local ability = t.ability
    if HasExclusive(caster,4) then
        local target_points = {}
        local unit = GetRandomUnit(caster,ability,caster:GetAbsOrigin(),1200)
        if unit then
            target_points[1] = unit:GetAbsOrigin()
        else
            target_points[1] = GetRandomPoint(caster:GetAbsOrigin(), 100, 800)
        end
        local abilityData = {caster=caster,ability=caster:FindAbilityByName("oracle_1"),target_points=target_points,cd=false}
        OnSpellStart(abilityData)
    end
end
function OnInit(t)
    t.ability.cooldown_reduce = false
end