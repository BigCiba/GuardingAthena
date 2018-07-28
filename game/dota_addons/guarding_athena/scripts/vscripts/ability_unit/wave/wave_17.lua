LinkLuaModifier("movespeed","modifiers/generic/movespeed.lua",LUA_MODIFIER_MOTION_NONE)
function OnCreated( t )
    local caster = t.caster
    local ability = t.ability
    local minDistance = 500
    local maxDistance = 900
    local minInterval = ability:GetSpecialValueFor("interval_min")
    local maxInterval = ability:GetSpecialValueFor("interval_max")
    local alertRange = ability:GetSpecialValueFor("alert_range")
    caster:AddNewModifier(caster, ability, "movespeed", nil)
    Timers:CreateTimer(function ()
        -- 死亡后停止计时器
        if caster:IsAlive() then
            local unitGroup = GetUnitsInRadius(caster,ability,caster:GetAbsOrigin(),alertRange)
            if #unitGroup > 0 then
                -- 选择最近的单位
                if not caster:HasModifier("modifier_hunt_jump") then
                    local closestUnit = unitGroup[1]
                    for k,unit in pairs(unitGroup) do
                        if unit ~= closestUnit then
                            local length = (caster:GetAbsOrigin() - unit:GetAbsOrigin()):Length2D()
                            if length < (caster:GetAbsOrigin() - closestUnit:GetAbsOrigin()):Length2D() then
                                closestUnit = unit
                            end
                        end
                    end
                    if ability:IsCooldownReady() then
                        local targetLoc = closestUnit:GetAbsOrigin()
                        local forward = (targetLoc - caster:GetAbsOrigin()):Normalized()
                        caster:SetForwardVector(forward)
                        ability:ApplyDataDrivenModifier(caster, target, "modifier_hunt_jump", {duration = 1})
                        caster:StartGesture(ACT_DOTA_ATTACK)
                        Jump(caster,targetLoc,1800,150,true,function()
                            local length = (targetLoc - closestUnit:GetAbsOrigin()):Length2D()
                            if length < 175 then
                                caster:PerformAttack(closestUnit,true,true,true,false,false,false,true)
                                ability:ApplyDataDrivenModifier(caster, closestUnit, "modifier_hunt_debuff", nil)
                                ability:ApplyDataDrivenModifier(caster, caster, "modifier_hunt_critical", nil)
                                caster:PerformAttack(closestUnit,true,true,true,false,false,false,true)
                                ability:StartCooldown(RandomInt(minInterval, maxInterval))
                            end
                        end)
                    else
                        local point = GetRandomPoint(closestUnit:GetAbsOrigin(), minDistance, maxDistance)
                        caster:MoveToPosition(point)
                    end
                end
            end
            return 0.5
        end
    end)
end
function OnTakeDamage( t )
    local caster = t.caster
    local ability = t.ability
    local cd = ability:GetCooldown(1)
    local duration = ability:GetSpecialValueFor("duration")
    if ability:IsCooldownReady() then
        ClearBuff(caster,"debuff")
        CreateSound("Hero_Lycan.Howl",caster)
        local runTime = 0
        Timers:CreateTimer(function ()
            if runTime < duration then
                caster:RemoveModifierByName("modifier_truesight")
                runTime = runTime + 0.1
                return 0.1
            end
        end)
        ability:StartCooldown(cd)
    end
end