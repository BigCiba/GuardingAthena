function ThumpCreate( t )
    local target = t.target
    local ability = t.ability
    SetUnitDamagePercent(caster,-80)
end
function ThumpRemove( t )
    local target = t.target
    local ability = t.ability
    SetUnitDamagePercent(caster,80)
end
function TrollBlinkStart( keys )
    local caster = keys.caster
    local x = RandomInt(3150,6400)
    local y = RandomInt(-6200,-3300)
    local z = 384
    local point = Vector(x,y,z)
    Timers:CreateTimer(0.1,function (  )
        SetUnitPosition(caster,point)
        CreateParticle("particles/units/troll_blink.vpcf",PATTACH_ABSORIGIN,caster,2)
        CreateSound("DOTA_Item.BlinkDagger.Activate",caster,2)
    end)
end
function TrollBlink( keys )
    local caster = keys.caster
    local caster_location = caster:GetAbsOrigin()
    local damage = keys.DamageTaken
    local ability = keys.ability
    local cd = ability:GetSpecialValueFor("cooldown")
    local point = GetRandomPoint(caster_location,400,600)
    while(point.x > 7000 or point.y < -7000)
    do
        point = GetRandomPoint(caster_location,400,600)
    end
    if ability:IsCooldownReady() then
        Heal(caster,damage,0,false)
        CreateParticle("particles/units/troll_blink.vpcf",PATTACH_ABSORIGIN,caster,2)
        CreateSound("DOTA_Item.BlinkDagger.Activate",caster,2)
        SetUnitPosition(caster,point)
        ProjectileManager:ProjectileDodge(caster)
        local modifier_table = caster:FindAllModifiers()
        for i=1,#modifier_table do
            local modifier_name = caster:GetModifierNameByIndex(i)
            if modifier_name ~= "modifier_troll_fireball" then
                caster:RemoveModifierByName(modifier_name)
            end
        end
        ability:StartCooldown(cd)
    end
end
function TrollFireBallAI( keys )
    local caster = keys.caster
    local caster_location = caster:GetAbsOrigin()
    local ability = keys.ability
    local t_order = 
    {
        UnitIndex = caster:entindex(),
        OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
        TargetIndex = nil,
        AbilityIndex = caster:FindAbilityByName("troll_fireball"):entindex(),
        Position = nil,
        Queue = 0
    }
    caster:SetContextThink(DoUniqueString("order") , function() ExecuteOrderFromTable(t_order) end, 0.1)
end
function TrollFireBall( keys )
    local caster = keys.caster
    local casterOrigin = caster:GetAbsOrigin()
    local ability = keys.ability
    local forwardVector = caster:GetForwardVector()
    local distance = 2000
    local speed = 600
    local velocity = forwardVector * speed
    local travelDuration = distance / speed
    local startTime = GameRules:GetGameTime()
    local endTime = startTime + travelDuration
    local projID = ProjectileManager:CreateLinearProjectile( {
        Ability             = ability,
        EffectName          = "particles/linear_projectile/fire_ball.vpcf",
        vSpawnOrigin        = casterOrigin,
        fDistance           = distance,
        fStartRadius        = 100,
        fEndRadius          = 100,
        Source              = caster,
        bHasFrontalCone     = false,
        bReplaceExisting    = false,
        iUnitTargetTeam     = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags    = DOTA_UNIT_TARGET_FLAG_NONE,
        iUnitTargetType     = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        fExpireTime         = endTime,
        bDeleteOnHit        = false,
        vVelocity           = velocity,
        bProvidesVision     = true,
        iVisionRadius       = 200,
        iVisionTeamNumber   = caster:GetTeamNumber(),
    } )
    Timers:CreateTimer(5,function (  )
        ProjectileManager:DestroyLinearProjectile(projID)
    end)
end
function ConcentrateAI( keys )
    local caster = keys.caster
    local ability = keys.ability
    local caster_location = caster:GetAbsOrigin()
    local targetTeam = ability:GetAbilityTargetTeam()
    local targetType = ability:GetAbilityTargetType()
    local targetFlag = ability:GetAbilityTargetFlags()
    local enemy = FindUnitsInRadius(caster:GetTeamNumber(), caster_location, caster, 1000, targetTeam, targetType, targetFlag, 0, false)
    if #enemy == 1 then
        local unit = enemy[1]
        local vector = (caster_location - unit:GetAbsOrigin()):Normalized()
        local position = caster_location + vector * 200
        if GridNav:CanFindPath(caster_location,position) then
            caster:MoveToPosition(position)
        end
    end
end