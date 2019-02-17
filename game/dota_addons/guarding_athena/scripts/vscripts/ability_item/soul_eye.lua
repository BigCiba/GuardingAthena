function OnSpellStart(t)
    local caster = t.caster
    local point = t.target_points[1]
    local ability = t.ability
    local radius = ability:GetSpecialValueFor("radius")
    local duration = ability:GetSpecialValueFor("duration")
    local increase_damage = ability:GetSpecialValueFor("increase_damage")
    local unitGroup = GetUnitsInRadius(caster,ability,point,radius)
    local p = CreateParticle("particles/items2_fx/veil_of_discord.vpcf",PATTACH_ABSORIGIN,caster,2)
    ParticleManager:SetParticleControl(p, 0, point)
    ParticleManager:SetParticleControl(p, 1, Vector(radius,radius,1))
    for _, unit in pairs(unitGroup) do
        ability:ApplyDataDrivenModifier(caster, unit, "modifier_item_soul_eye_debuff", nil)
        SetUnitIncomingDamageDeepen(unit,increase_damage,duration)
    end
end