function OnAttackLanded( t )
    local caster = t.caster
    local target = t.target
    local ability = t.ability
    if caster:HasModifier("modifier_item_chui_buff") or ability:IsCooldownReady() then
        local radius = ability:GetSpecialValueFor("radius")
        local stun_chance = ability:GetSpecialValueFor("stun_chance")
        local stun_duration = ability:GetSpecialValueFor("stun_duration")
        local stun_cooldown = ability:GetSpecialValueFor("stun_cooldown")
        local damage = caster:GetPrimaryStatValue() * ability:GetSpecialValueFor("damage")
        local damageType = ability:GetAbilityDamageType()

        if RollPercentage(stun_chance) then
            local unitGroup = GetUnitsInRadius(caster,ability,target:GetAbsOrigin(),radius)
            for k,v in pairs(unitGroup) do
                CauseDamage(caster,v,damage,damageType,ability)
                v:AddNewModifier(caster, ability, "modifier_stunned", {duration=stun_duration})
                ability:ApplyDataDrivenModifier(caster, v, "modifier_item_chui_debuff", {duration=3})
                local p = CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning_head.vpcf",PATTACH_CUSTOMORIGIN,caster,1)
                ParticleManager:SetParticleControlEnt(p, 0, caster, PATTACH_CUSTOMORIGIN_FOLLOW, "attach_origin", caster:GetAbsOrigin(), true)
                ParticleManager:SetParticleControlEnt(p, 1, v, PATTACH_CUSTOMORIGIN_FOLLOW, "attach_origin", v:GetAbsOrigin(), true)
            end
            ability:StartCooldown(stun_cooldown)
        end
    end
end