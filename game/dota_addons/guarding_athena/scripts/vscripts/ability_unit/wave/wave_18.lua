function OnAttackLanded(t)
    local caster = t.caster
    local target = t.target
    local ability = t.ability
    local duration = ability:GetSpecialValueFor("duration")
    AddModifierStackCount(caster,target,ability,"modifier_jugg_attack_debuff",1,duration,true)
end