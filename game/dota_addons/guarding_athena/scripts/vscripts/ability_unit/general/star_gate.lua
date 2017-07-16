function OnThink( t )
    local caster = t.caster
    local ability = t.ability
    local caster_location = caster:GetAbsOrigin()
    local target_location = GuardingAthena.entAthena:GetAbsOrigin()
    if not GridNav:CanFindPath(caster_location,target_location) then
        if ability:IsCooldownReady() and not ability:IsChanneling() then
            local t_order = 
            {
                UnitIndex = caster:entindex(),
                OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
                TargetIndex = nil,
                AbilityIndex = caster:FindAbilityByName("boss_blink"):entindex(),
                Position = nil,
                Queue = 0
            }
            caster:SetContextThink(DoUniqueString("order") , function() ExecuteOrderFromTable(t_order) end, 0.1)
        end
    end
end
function StarGate( t )
    local caster = t.caster
    local ability = t.ability
    local caster_location = caster:GetAbsOrigin()
    local target_location = GuardingAthena.entAthena:GetAbsOrigin()
    local vector = (target_location - caster_location):Normalized()
    local point = caster_location + vector * 10
    while(GridNav:CanFindPath(point,target_location) == false)
    do
        point = point + vector * 10
    end
    SetUnitPosition(caster, point)
    ParticleManager:DestroyParticle(caster.stargate, false)
end
function StarGateStart( t )
    local caster = t.caster
    local ability = t.ability
    caster.stargate = CreateParticle( "particles/units/heroes/heroes_underlord/abbysal_underlord_darkrift_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
    ParticleManager:SetParticleControl( caster.stargate, 0, caster:GetAbsOrigin() )
    ParticleManager:SetParticleControl( caster.stargate, 1, Vector(600,600,600) )
    ParticleManager:SetParticleControl( caster.stargate, 2, caster:GetAbsOrigin() )
    ParticleManager:SetParticleControl( caster.stargate, 5, caster:GetAbsOrigin() )
    ParticleManager:SetParticleControl( caster.stargate, 20, caster:GetAbsOrigin() )
end
function StarGateStop( t )
    local caster = t.caster
    local ability = t.ability
    ParticleManager:DestroyParticle(caster.stargate, true)
end