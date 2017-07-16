function OnAttackLanded(t)
    local caster = t.caster
    local target = t.target
    local ability = t.ability
    local damage = t.DamageTaken
    local critical = ability:GetSpecialValueFor("critical") * 0.01
    damage = damage * critical
    CauseDamage(caster,target,damage,DAMAGE_TYPE_PURE)
end