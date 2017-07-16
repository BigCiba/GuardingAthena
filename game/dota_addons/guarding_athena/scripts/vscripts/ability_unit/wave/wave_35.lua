function OnDeath( t )
    local caster = t.caster
    local ability = t.ability
    local caster_location = caster:GetAbsOrigin()
    local radius = ability:GetSpecialValueFor("radius")
    local unitGroup = GetUnitsInRadius( caster, ability, caster_location, radius )
    for i,unit in pairs(unitGroup) do
        if not caster:IsNull() and not caster.fuhuozhong then
            local ability_fuhuo = unit:FindAbilityByName("fuhuosishi")
            if unit:HasModifier("modifier_fuhuosishi_death_check") and ability_fuhuo:IsCooldownReady() then
                caster.fuhuozhong = true
                unit:StartGesture( ACT_DOTA_CAST_ABILITY_1 )
                ability_fuhuo:StartCooldown(30)
                local particle = CreateParticle( "particles/units/heroes/hero_skeletonking/wraith_king_death.vpcf", PATTACH_CUSTOMORIGIN, caster )
                ParticleManager:SetParticleControl( particle, 0, caster:GetAbsOrigin() )
                ParticleManager:SetParticleControl( particle, 1, caster:GetAbsOrigin() )
                EmitSoundOn("Hero_SkeletonKing.Reincarnate", caster)
                Timers:CreateTimer(1,function ()
                    caster:RespawnUnit()
                    caster:AddNewModifier(unit, nil, "modifier_kill", {duration = 60})
                    caster.corpse = true
                    caster.fuhuozhong = false
                end)
            end
        end
    end
end
function ManaBurn( t )
    local caster = t.caster
    local target = t.target
    local ability = t.ability
    local mana_burn = ability:GetSpecialValueFor("mana")
    local cd = ability:GetSpecialValueFor("cooldown")
    if ability:IsCooldownReady() then
        local mana = target:GetMaxMana() * mana_burn * 0.01
        target:ReduceMana( mana )
        CauseDamage( caster, target, mana, DAMAGE_TYPE_MAGICAL )
        ability:StartCooldown(cd)
        local particle = CreateParticle( "particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
        EmitSoundOn("Hero_NyxAssassin.ManaBurn.Target", target)
    end
end