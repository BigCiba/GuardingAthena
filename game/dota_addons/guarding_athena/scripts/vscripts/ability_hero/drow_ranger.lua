function Init( t )
    local hCaster = t.caster
    local hAbility = hCaster:AddAbility("drow_ranger_0_2")
    hAbility:SetLevel(1)
    hAbility:SetHidden(true)
    hCaster:AddAbility("drow_ranger_1_2"):SetHidden(true)
    hCaster:AddAbility("drow_ranger_3_2"):SetHidden(true)
end
function OnToggle( t )
    local hCaster = t.caster
    local hAbility = t.ability
    if hAbility:GetAbilityName() == "drow_ranger_0_1" then
        hCaster:SwapAbilities("drow_ranger_0_1", "drow_ranger_0_2", false, true)
        hCaster:SwapAbilities("drow_ranger_1_1", "drow_ranger_1_2", false, true)
        hCaster:SwapAbilities("drow_ranger_3_1", "drow_ranger_3_2", false, true)
        hCaster:FindAbilityByName("drow_ranger_1_2"):SetLevel(hCaster:FindAbilityByName("drow_ranger_1_1"):GetLevel())
        hCaster:FindAbilityByName("drow_ranger_3_2"):SetLevel(hCaster:FindAbilityByName("drow_ranger_3_1"):GetLevel())
        -- hCaster:RemoveModifierByName("modifier_drow_ranger_0_1")
    end
end
function OnAttackLanded(t)
    local hCaster = t.caster
    local hTarget = t.target
    local hAbility = t.ability
    local iAbilityIndex = hAbility:GetAbilityIndex()
    if iAbilityIndex == 0 then
        local chance = hAbility:GetSpecialValueFor("chance")
        local radius = hAbility:GetSpecialValueFor("radius")
        local delay = hAbility:GetSpecialValueFor("delay")
        local damage = hAbility:GetSpecialValueFor("damage") * hCaster:GetAverageTrueAttackDamage(hCaster)
        if RollPercentage(chance) then
            local tUnitGroup = GetUnitsInRadius(hCaster,hAbility,hTarget:GetAbsOrigin(),radius)
            for _, hUnit in pairs(tUnitGroup) do
                local p = CreateParticle("particles/units/heroes/hero_mirana/mirana_starfall_attack.vpcf",PATTACH_ABSORIGIN,hCaster,2)
                ParticleManager:SetParticleControl(p, 0, hUnit:GetAbsOrigin())
            end
            Timers:CreateTimer(delay,function ()
                CauseDamage(hCaster,tUnitGroup,damage,hAbility:GetAbilityDamageType(),hAbility)
            end)
        end
    elseif iAbilityIndex == 1 then
        ForWithInterval(4,0.3,function (  )
            local info = {
                Target = hTarget,
                Source = hCaster,
                Ability = hAbility,
                EffectName = "particles/econ/items/clinkz/clinkz_maraxiform/clinkz_maraxiform_searing_arrow_deso.vpcf",
                bDodgeable = false,
                bProvidesVision = false,
                iMoveSpeed = 900,
                iVisionRadius = 0,
                iVisionTeamNumber = hCaster:GetTeamNumber(),
                vSourceLoc= hCaster:GetAbsOrigin() + Vector(RandomInt(-300, 300),RandomInt(-300, 300),0),
            }
            if hTarget:IsAlive() then
                ProjectileManager:CreateTrackingProjectile( info )
            end
        end)
    elseif iAbilityIndex == 3 then
        if hAbility:GetAbilityName() == "drow_ranger_3_1" then
            ColdArrow( t )
        elseif hAbility:GetAbilityName() == "drow_ranger_3_2" then
            HotArrow( t )
        end
    end
end
function ColdArrow(t)
    local hCaster = t.caster
    local hTarget = t.target
    local hAbility = hCaster:FindAbilityByName("drow_ranger_3_1")
    local reduce_duration = hAbility:GetSpecialValueFor("reduce_duration")
    local curse_duration = hAbility:GetSpecialValueFor("curse_duration")
    local require_count = hAbility:GetSpecialValueFor("require_count")
    AddModifierStackCount(hCaster,hTarget,hAbility,"modifier_drow_ranger_3_1_movespeed",1,reduce_duration)
    if hTarget:GetModifierStackCount("modifier_drow_ranger_3_1_movespeed", hCaster) >= require_count then
        hTarget:RemoveModifierByName("modifier_drow_ranger_3_1_movespeed")
        hAbility:ApplyDataDrivenModifier(hCaster, hTarget, "modifier_drow_ranger_3_1_freeze", {duration = curse_duration})
    end
end
function HotArrow( t )
    local hCaster = t.caster
    local hTarget = t.target
    local hAbility = hCaster:FindAbilityByName("drow_ranger_3_2")
    local duration = hAbility:GetSpecialValueFor("duration")
    local debuff_duration = hAbility:GetSpecialValueFor("debuff_duration")
    local require_count = hAbility:GetSpecialValueFor("require_count")
    local agility_percent = hAbility:GetSpecialValueFor("agility_percent") + hAbility:GetSpecialValue("agility_percent_lv")
    local attack_damage = hAbility:GetSpecialValue("base_damage") + hAbility:GetSpecialValue("attack_agility_damage") * hCaster:GetAgility()
    local damage = hAbility:GetSpecialValue("agility_damage") * hCaster:GetAgility()
    CauseDamage(hCaster,hTarget,attack_damage,hAbility:GetAbilityDamageType(),hAbility)
    AddModifierStackCount(hCaster,hTarget,hAbility,"modifier_drow_ranger_3_2_debuff",1,debuff_duration)
    if hTarget:GetModifierStackCount("modifier_drow_ranger_3_2_debuff", hCaster) >= require_count then
        hTarget:RemoveModifierByName("modifier_drow_ranger_3_2_debuff")
        CauseDamage(hCaster,hTarget,damage,hAbility:GetAbilityDamageType(),hAbility)
        hAbility:ApplyDataDrivenModifier(hCaster, hCaster, "modifier_drow_ranger_3_2_agility", {duration = duration})
        hCaster:SetModifierStackCount("modifier_drow_ranger_3_2_agility", hCaster, math.ceil( hCaster:GetAgility() * agility_percent * 0.01 ))
    end
end
function OnCurseDamage( t )
    local hCaster = t.caster
    local hTarget = t.unit
    local hAbility = t.ability
    if hAbility.use == nil then
        hAbility.use = true
    end
    local damage = hAbility:GetSpecialValue("base_damage") + hAbility:GetSpecialValue("agility_damage") * hCaster:GetAgility()
    if hAbility.use then
        hAbility.use = false
        CauseDamage(hCaster,hTarget,damage,hAbility:GetAbilityDamageType(),hAbility)
        hAbility.use = true
    end
end