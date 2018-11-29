function OnSpellStart( t )
    local caster = t.caster
    local target = t.target
    local ability = t.ability
    local damage = ability:GetSpecialValueFor("damage") * target:GetHealth()
    local damageType = ability:GetAbilityDamageType()
    CauseDamage(caster,target,damage,damageType,ability)
end