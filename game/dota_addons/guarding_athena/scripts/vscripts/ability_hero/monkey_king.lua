function PiercingEye( t )
    local caster = t.caster
    local target = t.unit
    local ability = t.ability
    local damage = caster:GetAgility() * 5
    local change = ability:GetSpecialValueFor("chance")
    if RollPercentage(change) then
        PiercingEyeDamage( caster, target, damage, DAMAGE_TYPE_PURE, ability )
    end
end
function PiercingEyeDamage( caster, target, damage, damageType, ability )
    local damageDeepen = (100 - target:GetHealthPercent()) * 0.05 + 1
    CauseDamage( caster, target, damage * damageDeepen, damageType, ability )
end
function EndlessOffensive( t )
    local caster = t.caster
    local target = t.target
    local ability = t.ability
    local unitGroup = GetUnitsInRadius( caster, ability, target:GetAbsOrigin(), 600 )
    local count = 0
    for k,v in pairs(unitGroup) do
        if count < 3 and v:IsAlive() then
            for i,unit in pairs(caster.illusion_table) do
                if unit.use == false then
                    unit.use = true
                    local heroLevel = caster:GetLevel() - unit:GetLevel()
                    if heroLevel > 0 then 
                        for i=1,heroLevel do
                            unit:HeroLevelUp(false)
                        end
                    end
                    unit:SetAbilityPoints(0)
                    for abilitySlot=0,15 do
                        local illusionAbility = caster:GetAbilityByIndex(abilitySlot)
                        if illusionAbility ~= nil then 
                            local abilityLevel = illusionAbility:GetLevel()
                            local abilityName = illusionAbility:GetAbilityName()
                            local unitAbility = unit:GetAbilityByIndex(abilitySlot)
                            if unitAbility then
                                unitAbility:SetLevel(abilityLevel)
                            end
                        end
                    end
                    for itemSlot=0,5 do
                        local itemOld = unit:GetItemInSlot(itemSlot)
                        if itemOld then
                            unit:RemoveItem(itemOld)
                        end
                        local item = caster:GetItemInSlot(itemSlot)
                        if item ~= nil then
                            local itemName = item:GetName()
                            local newItem = CreateItem(itemName, unit, unit)
                            unit:AddItem(newItem)
                        end
                    end
                    SetUnitPosition(unit,target:GetAbsOrigin() + Vector(RandomInt(-200, 200),RandomInt(-200, 200),0))
                    unit:RemoveModifierByName("modifier_endless_offensive_debuff")
                    unit:MoveToTargetToAttack(target)
                    unit:RemoveNoDraw()
                    local particle = CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_disguise.vpcf", PATTACH_ABSORIGIN, unit)
                    Timers:CreateTimer(2,function ()
                        unit.use = false
                        unit:AddNoDraw()
                        ability:ApplyDataDrivenModifier(unit, unit, "modifier_endless_offensive_debuff", nil)
                        unit:Stop()
                    end)
                    break
                end
            end
            count = count + 1
        else
            break
        end
    end
end
function EndlessOffensiveCleave( t )
    local caster = t.caster
    local target = t.target
    local ability = t.ability
    local damage = t.DamageTaken
    local position = caster:GetAbsOrigin()
    local forwardVector = (target:GetAbsOrigin() - position):Normalized()
    local unitGroup = GetUnitsInSector( caster, ability, position, forwardVector, 300, 300 )
    for k,v in pairs(unitGroup) do
        PiercingEyeDamage( caster, v, damage, DAMAGE_TYPE_PURE, ability )
    end
end
function IllusionAttack( t )
    --[[local caster = t.caster
    local ability = t.ability
    local attacker = t.attacker
    attacker.use = false
    attacker:AddNoDraw()
    ability:ApplyDataDrivenModifier(caster, attacker, "modifier_endless_offensive_debuff", nil)
    attacker:Stop()]]--
end
function AttackEffect( t )
    local effectName = {
        "particles/units/heroes/hero_monkey_king/monkey_king_attack_01_blur_cud.vpcf",
        "particles/units/heroes/hero_monkey_king/monkey_king_attack_01_near_blur_cud.vpcf",
        "particles/units/heroes/hero_monkey_king/monkey_king_attack_03_near_blur_cud.vpcf",
        "particles/units/heroes/hero_monkey_king/monkey_king_attack_05_blur_cud.vpcf",
        "particles/units/heroes/hero_monkey_king/monkey_king_attack_05_near_blur_cud.vpcf",
        "particles/units/heroes/hero_monkey_king/monkey_king_attack_06_blur_cud.vpcf",
        "particles/units/heroes/hero_monkey_king/monkey_king_attack_06_near_blur_cud.vpcf"
    }
    local caster = t.attacker
    local ability = t.ability
    local particleIndex = RandomInt(1, 6)
    local particle = CreateParticle(effectName[particleIndex], PATTACH_ABSORIGIN_FOLLOW, caster)
    --ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_ABSORIGIN, "attach_hitloc", caster:GetAbsOrigin(), true)
end
function EndlessOffensiveCreate( t )
    local caster = t.caster
    local ability = t.ability
    print(caster:IsIllusion())
    print(caster.caster_hero)
    if caster.illusion_table or caster.caster_hero then
        return
    end
    caster.illusion_table ={}
    for i=1,9 do
        local unit = CreateUnitByName("npc_dota_hero_monkey_king", caster:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS )
        local heroLevel = caster:GetLevel() - unit:GetLevel()
        if heroLevel > 0 then 
            for i=1,heroLevel do
                unit:HeroLevelUp(false)
            end
        end
        unit:SetAbilityPoints(0)
        --[[for abilitySlot=0,6 do
            local illusionAbility = caster:GetAbilityByIndex(abilitySlot)
            if illusionAbility ~= nil then 
                local abilityLevel = illusionAbility:GetLevel()
                local unitAbility = unit:GetAbilityByIndex(abilitySlot)
                if unitAbility then
                    unitAbility:SetLevel(abilityLevel)
                end
            end
        end]]--
        for itemSlot=0,5 do
            local itemOld = unit:GetItemInSlot(itemSlot)
            if itemOld then
                unit:RemoveItem(itemOld)
            end
            local item = caster:GetItemInSlot(itemSlot)
            if item ~= nil then
                local itemName = item:GetName()
                local newItem = CreateItem(itemName, unit, unit)
                unit:AddItem(newItem)
            end
        end
        unit.caster_hero = caster
        HeroState:InitIllusion(unit)
        unit:MakeIllusion()
        ability:ApplyDataDrivenModifier(caster, unit, "modifier_endless_offensive_illusion", nil)
        unit.use = false
        unit:AddNoDraw()
        ability:ApplyDataDrivenModifier(caster, unit, "modifier_endless_offensive_debuff", nil)
        table.insert(caster.illusion_table,unit)
        local particle = CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_tap_buff.vpcf", PATTACH_ABSORIGIN, unit)
        ParticleManager:SetParticleControlEnt(particle, 0, unit, PATTACH_POINT_FOLLOW, "attach_weapon_top", unit:GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(particle, 2, unit, PATTACH_POINT_FOLLOW, "attach_weapon_top", unit:GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(particle, 3, unit, PATTACH_POINT_FOLLOW, "attach_weapon_bot", unit:GetAbsOrigin(), true)
    end
end
function EndlessOffensiveActive( t )
    local caster = t.caster
    local ability = t.ability
    local duration = ability:GetSpecialValueFor("duration")
    local particle = CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_tap_buff.vpcf", PATTACH_ABSORIGIN, caster)
    ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_weapon_top", caster:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(particle, 2, caster, PATTACH_POINT_FOLLOW, "attach_weapon_top", caster:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(particle, 3, caster, PATTACH_POINT_FOLLOW, "attach_weapon_bot", caster:GetAbsOrigin(), true)
    Timers:CreateTimer(duration,function ()
        ParticleManager:DestroyParticle(particle,false)
    end)
end