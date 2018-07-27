function OnShockWave( t )
    local caster = t.caster
    local ability = t.ability
    local radius = ability:GetSpecialValueFor("radius")
    local casterLoc = caster:GetAbsOrigin()
    local angle = 0
    for i=1,16 do
        local point = GetRotationPoint(casterLoc,radius,angle)
        local direction = (point - casterLoc):Normalized()
        CreateLinearProjectile(caster,ability,particleName,casterLoc,200,900,direction,speed,deleteOnHit)
        angle = angle + (360 / 16)
    end
end