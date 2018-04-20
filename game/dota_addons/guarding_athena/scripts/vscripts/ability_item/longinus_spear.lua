function OnCreated( t )
    local caster = t.caster
    local ability = t.ability
    caster.bonus_magic_damage = caster.bonus_magic_damage + ability:GetSpecialValueFor("magic_damage_increase")
end
function OnDestroy( t )
    local caster = t.caster
    local ability = t.ability
    caster.bonus_magic_damage = caster.bonus_magic_damage - ability:GetSpecialValueFor("magic_damage_increase")
end
function OnTakeDamage( t )
    local caster = t.caster
    local target = t.attacker
    local ability = t.ability
    local damage = t.DamageTaken
    local mana = caster:GetMaxMana()
    local currentMana = caster:GetMana() - mana * 0.1
    local direction = (target:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized()
    if damage < mana * 0.1 then
        Heal(caster,damage,0,false)
        local p = CreateParticle("particles/items/longinus_spear/longinus_spear_atfield.vpcf",PATTACH_ABSORIGIN,caster,2)
        ParticleManager:SetParticleControl(p, 0, caster:GetAbsOrigin() + direction * 100)
        ParticleManager:SetParticleControlForward(p, 0, direction)
    elseif caster:GetManaPercent() > 10 then
        if damage < currentMana then
            Heal(caster,damage,0,false)
            caster:SpendMana(damage, ability)
        elseif damage > currentMana then
            Heal(caster,damage - currentMana,0,false)
            caster:SpendMana(currentMana, ability)
        end
        CreateParticle("particles/items/longinus_spear/longinus_spear_atfield.vpcf",PATTACH_ABSORIGIN,caster,2)
    end
end
function OnSpellStart( t )
    local caster = t.caster
    local target = t.target
    local ability = t.ability
    local p = CreateParticle("particles/items/longinus_spear/longinus_spear_active.vpcf",PATTACH_ABSORIGIN,caster,3)
    ParticleManager:SetParticleControl(p, 0, target:GetAbsOrigin())
    ParticleManager:SetParticleControl(p, 1, caster:GetAbsOrigin())
    Timers:CreateTimer(0.3,function ()
        CauseDamage(caster,target,target:GetMaxHealth() * 0.3,DAMAGE_TYPE_MAGICAL,ability)
    end)
end