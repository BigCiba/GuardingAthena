function ManaBreak( t )
    local caster = t.caster
    local target = t.target
    local ability = t.ability
    local manaCost = target:GetMaxMana() * ability:GetSpecialValueFor("mana") * 0.01
    local damage = manaCost
    damage = damage * (200 - target:GetManaPercent()) * 0.01
    target:SpendMana(manaCost, nil)
    CauseDamage(caster,target,damage,DAMAGE_TYPE_MAGICAL,ability)
end