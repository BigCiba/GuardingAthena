function OnSpellStart( t )
    local caster = t.caster
    local ability = t.ability
    local point = t.target_points[1]
    local damage = ability:GetSpecialValueFor("damage") * caster:GetPrimaryStatValue()
    print(caster:GetPrimaryStatValue())
    local damageType = ability:GetAbilityDamageType()
    local radius = ability:GetSpecialValueFor("radius")
    local unitGroup = GetUnitsInRadius(caster,ability,point,radius)
    CauseDamage(caster,unitGroup,damage,damageType,ability)
    -- 特效
    local casterLoc = caster:GetAbsOrigin()
    local direction = (point - casterLoc):Normalized()
    local distance = (point - casterLoc):Length2D()
    local cp6 = GetRandomPoint(casterLoc +  direction * distance * 0.7, math.ceil( distance * 0.2 ), math.ceil( distance * 0.25 )) + Vector(0, 0, RandomInt(0, 300))
    local cp10 = GetRandomPoint(casterLoc + direction * distance * 0.3, math.ceil( distance * 0.2 ), math.ceil( distance * 0.25 )) + Vector(0, 0, RandomInt(0, 300)) 
    local p = CreateParticle("particles/econ/items/lion/lion_ti8/lion_spell_finger_ti8.vpcf",PATTACH_ABSORIGIN_FOLLOW,caster,3)
    ParticleManager:SetParticleControl( p, 0, casterLoc + Vector(0,0,64) )
    ParticleManager:SetParticleControl( p, 1, point + Vector(0,0,64) )
    ParticleManager:SetParticleControl( p, 2, point )
    ParticleManager:SetParticleControl( p, 6, cp6 )
    ParticleManager:SetParticleControl( p, 10, cp10 )
    ParticleManager:SetParticleControlForward( p, 10, direction)
    -- 魔法消耗
    local manaCost = distance
    caster:SpendMana(manaCost, ability)
    if caster:GetMana() < manaCost then
        local cd = ability:GetCooldownTimeRemaining() * 2
        ability:EndCooldown()
        ability:StartCooldown(cd)
    end
end