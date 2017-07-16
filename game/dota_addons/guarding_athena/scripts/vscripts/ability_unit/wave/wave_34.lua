function OnAttackLanded(t)
    local caster = t.caster
    local target = t.target
    local ability = t.ability
    local modifierName = "modifier_poison_sting_debuff"
    AddModifierStackCount(caster,target,ability,modifierName)
end
function OnIntervalThink( t )
    local caster = t.caster
    local target = t.target
    local ability = t.ability
    local damage = target:GetModifierStackCount("modifier_poison_sting_debuff", caster) * ability:GetSpecialValueFor("damage")
    CauseDamage(caster,target,damage,DAMAGE_TYPE_MAGICAL)
end
