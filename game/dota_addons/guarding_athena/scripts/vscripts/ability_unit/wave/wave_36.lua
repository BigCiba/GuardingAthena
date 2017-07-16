function SlardarCrushAI( t )
    local caster = t.caster
    local target = t.attacker
    local ability = t.ability
    local distance = (caster:GetAbsOrigin() - target:GetAbsOrigin()):Length2D()
    if ability:IsCooldownReady() and distance <= 350 then
        local t_order = 
        {
            UnitIndex = caster:entindex(),
            OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
            TargetIndex = nil,
            AbilityIndex = caster:FindAbilityByName("slardar_crush"):entindex(),
            Position = nil,
            Queue = 0
        }
        caster:SetContextThink(DoUniqueString("order") , function() ExecuteOrderFromTable(t_order) end, 0.1)
    end
end
function SlardarCrush( t )
    local caster = t.caster
    local ability = t.ability
    local caster_location = caster:GetAbsOrigin()
    local radius = ability:GetSpecialValueFor("radius")
    local damage = ability:GetSpecialValueFor("damage")
    local unitGroup = GetUnitsInRadius( caster, ability, caster_location, radius )
    for k,unit in pairs(unitGroup) do
        ability:ApplyDataDrivenModifier(caster, target, "modifier_slardar_crush_debuff", nil)
        CauseDamage( caster, unit, damage, DAMAGE_TYPE_MAGICAL )
    end
end