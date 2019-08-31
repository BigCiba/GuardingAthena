function Init( t )
    local hCaster = t.caster
    local hAbility = hCaster:AddAbility("drow_ranger_0_2")
    hAbility:SetLevel(1)
    hAbility:SetHidden(true)
    hCaster:AddAbility("drow_ranger_1_2"):SetHidden(true)
end
function OnToggle( t )
    local hCaster = t.caster
    local hAbility = t.ability
    if hAbility:GetAbilityName() == "drow_ranger_0_1" then
        hCaster:SwapAbilities("drow_ranger_0_1", "drow_ranger_0_2", false, true)
        hCaster:SwapAbilities("drow_ranger_1_1", "drow_ranger_1_2", false, true)
        hCaster:FindAbilityByName("drow_ranger_1_2"):SetLevel(hCaster:FindAbilityByName("drow_ranger_1_1"):GetLevel())
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
    end
end