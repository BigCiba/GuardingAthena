function LightningChain( t )
    CauseDamage(t.caster,t.target,t.ability:GetSpecialValueFor("damage"),t.ability:GetAbilityDamageType(),t.ability)
end