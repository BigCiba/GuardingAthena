function DeathWish( t )
    local caster = t.caster
    local ability = t.ability
    local hp = caster:GetHealthPercent()
    local stackcount = math.floor((100-hp)/5)
    if stackcount >= 1 then
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_siling_speed_buff", nil)
        caster:SetModifierStackCount("modifier_siling_speed_buff", caster, stackcount)
    end
end
function OnDeath( t )
    local caster = t.caster
    local target = t.attacker
    local ability = t.ability
    local damage = ability:GetSpecialValueFor("damage")
    CauseDamage( caster, target, damage, DAMAGE_TYPE_MAGICAL )
    local particle = CreateParticle( "particles/items_fx/necronomicon_warrior_last_will.vpcf", PATTACH_ABSORIGIN, target )
end
function LifeSteal( t )
    local caster = t.caster
    local target = t.target
    local ability = t.ability
    local damage = ability:GetSpecialValueFor("percent") * target:GetMaxHealth() * 0.01
    --local heal = ability:GetSpecialValueFor("percent") * caster:GetMaxHealth() * 0.01
    CauseDamage( caster, target, damage, DAMAGE_TYPE_MAGICAL )
    Heal( caster, damage, 0, true )
end
function OnManaPurge( t )
    local caster = t.caster
    local target = t.target
    local ability = t.ability
    target:SpendMana(target:GetMana(), ability)
end
function OnDeathArrow( t )
    local caster = t.caster
    local target = t.target
    local ability = t.ability
    local damage = ability:GetSpecialValueFor("damage") * target:GetMaxHealth() * 0.01
    local damageType = ability:GetAbilityDamageType()
    CauseDamage(caster,target,damage,damageType,ability)
end