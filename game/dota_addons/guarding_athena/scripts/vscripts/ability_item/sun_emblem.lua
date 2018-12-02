function OnSpellStart( t )
    local caster = t.caster
    local point = t.target_points[1]
    local ability = t.ability
    local radius = ability:GetSpecialValueFor("radius")
    local damage = ability:GetSpecialValueFor("damage") * 0.01
    local damageType = ability:GetAbilityDamageType()
    local unitGroup = GetUnitsInRadius(caster,ability,point,radius)
    for k,v in pairs(unitGroup) do
        CauseDamage(caster,v,damage * v:GetHealth(),damageType,ability)
        ability:ApplyDataDrivenModifier(caster, v, "modifier_item_sun_emblem_debuff", nil)
    end
    local p = CreateParticle("particles/units/heroes/hero_invoker/invoker_sun_strike.vpcf",PATTACH_ABSORIGIN,caster,2)
    ParticleManager:SetParticleControl(p, 0, point)
end