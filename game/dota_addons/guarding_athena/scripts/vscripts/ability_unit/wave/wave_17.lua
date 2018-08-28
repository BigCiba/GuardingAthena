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
            local casterLoc = caster:GetAbsOrigin()
            local unitGroup = GetUnitsInRadius(caster,ability,casterLoc,alertRange)
            if #unitGroup > 0 then
                -- 是否跳跃中
                if not caster:HasModifier("modifier_hunt_jump") then
                    -- 选择最近的单位
                    local closestUnit = unitGroup[1]
                    for k,unit in pairs(unitGroup) do
                        if unit ~= closestUnit then
                            local length = (casterLoc - unit:GetAbsOrigin()):Length2D()
                            if length < (casterLoc - closestUnit:GetAbsOrigin()):Length2D() then
                                closestUnit = unit
                            end
                        end
                    end
                    if ability:IsCooldownReady() then
                        local targetLoc = closestUnit:GetAbsOrigin()
                        local forward = (targetLoc - casterLoc):Normalized()
                        caster:SetForwardVector(forward)
                        ability:ApplyDataDrivenModifier(caster, target, "modifier_hunt_jump", {duration = 1})
                        caster:StartGesture(ACT_DOTA_ATTACK)
                        Jump(caster,targetLoc,1800,200,true,function()
                            -- 目标离跳跃地点不超过一定距离
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
                        -- 选择下一个路径点
                        local point = GetRandomPoint(closestUnit:GetAbsOrigin(), minDistance, maxDistance)
                        local distance_1 = (closestUnit:GetAbsOrigin() - point):Length2D()
                        local distance_2 = (casterLoc - point):Length2D()
                        while distance_2 > distance_1  do
                            point = GetRandomPoint(closestUnit:GetAbsOrigin(), minDistance, maxDistance)
                            distance_1 = (closestUnit:GetAbsOrigin() - point):Length2D()
                            distance_2 = (casterLoc - point):Length2D()
                        end 
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