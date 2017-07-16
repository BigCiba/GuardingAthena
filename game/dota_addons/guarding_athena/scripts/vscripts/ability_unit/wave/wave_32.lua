function HolyAttack( t )
    local caster = t.caster
    local target = t.target
    local ability = t.ability
    local damage = ability:GetSpecialValueFor("damage")
    CauseDamage( caster, target, damage, DAMAGE_TYPE_PURE )
end
function HolyArmorAI( t )
    local caster = t.caster
    local ability = t.ability
    if ability:IsCooldownReady() and caster:GetHealthPercent() <= 70 then
        local t_order = 
        {
            UnitIndex = caster:entindex(),
            OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
            TargetIndex = nil,
            AbilityIndex = caster:FindAbilityByName("holy_armor"):entindex(),
            Position = nil,
            Queue = 0
        }
        caster:SetContextThink(DoUniqueString("order") , function() ExecuteOrderFromTable(t_order) end, 0.1)
    end
end