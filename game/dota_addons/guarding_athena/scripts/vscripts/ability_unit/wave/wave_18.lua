function OnAttackLanded(t)
    local caster = t.caster
    local target = t.target
    local ability = t.ability
    local duration = ability:GetSpecialValueFor("duration")
    ability:ApplyDataDrivenModifier(caster, target, "modifier_jugg_attack_debuff", nil)
end