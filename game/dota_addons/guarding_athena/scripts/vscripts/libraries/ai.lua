if AI == nil then
    --print ( '[AI] creating AI' )
    AI = {}
    AI.__index = AI
end
-- 初始化
function AI:CreateAI( ... )
    local caster = ...
    -- 获取所有技能
    caster.noTargetType = {}
    caster.unitType = {}
    caster.pointType = {}
    local abilityTable = {}
	for i=1,8 do
		if caster:GetAbilityByIndex(i-1) then
			local ability = caster:GetAbilityByIndex(i-1)
            if ability then
                table.insert( abilityTable, ability )
            end
		end
    end
    -- 技能分类
    for k,ability in pairs(abilityTable) do
        local behavior = ability:GetBehavior()
        if behavior == DOTA_ABILITY_BEHAVIOR_NO_TARGET then
            table.insert( caster.noTargetType, ability )
        elseif behavior == DOTA_ABILITY_BEHAVIOR_UNIT_TARGET then
            table.insert( caster.unitType, ability )
        elseif behavior == DOTA_ABILITY_BEHAVIOR_POINT then
            table.insert( caster.pointType, ability )
        end
    end
    self:SetAutoCast(caster)
end
function AI:SetAbilityType( ability )
    local behavior = ability:GetBehavior()
    if behavior == DOTA_ABILITY_BEHAVIOR_NO_TARGET then
        table.insert( self.noTargetType, ability )
    elseif behavior == DOTA_ABILITY_BEHAVIOR_UNIT_TARGET then
        table.insert( self.unitType, ability )
    elseif behavior == DOTA_ABILITY_BEHAVIOR_POINT then
        table.insert( self.pointType, ability )
    end
end
function AI:SetAutoCast( caster )
    Timers:CreateTimer(function ()
        if not caster:IsNull() then
            -- 是否施放技能
            local castState = false
            -- 无目标技能
            if castState == false then
                for k,ability in pairs(caster.noTargetType) do
                    if ability:IsCooldownReady() then
                        -- 有影响范围的技能
                        local radius = ability:GetSpecialValueFor("radius") or 0
                        if radius > 0 then
                            local point = caster:GetAbsOrigin()
                            local unitGroup = GetUnitsInRadius(caster,ability,point,radius)
                            if #unitGroup > 0 then
                                castState = true
                                ClearBuff(caster,"debuff")
                                CastAbility(caster,DOTA_UNIT_ORDER_CAST_NO_TARGET,ability,nil,nil)
                            end
                        else
                            castState = true
                            ClearBuff(caster,"debuff")
                            CastAbility(caster,DOTA_UNIT_ORDER_CAST_NO_TARGET,ability,nil,nil)
                        end
                    end
                end
            end
            -- 单位技能
            if castState == false then
                for k,ability in pairs(caster.unitType) do
                    if ability:IsCooldownReady() then
                        -- 施法距离
                        local casterLoc = caster:GetAbsOrigin()
                        local radius = ability:GetCastRange()
                        local unitGroup = GetUnitsInRadius(caster,ability,casterLoc,radius)
                        if #unitGroup > 0 then
                            for k,unit in pairs(unitGroup) do
                                castState = true
                                ClearBuff(caster,"debuff")
                                CastAbility(caster,DOTA_UNIT_ORDER_CAST_TARGET,ability,unit,nil)
                            end
                        end
                    end
                end
            end
            -- 点技能
            if castState == false then
                for k,ability in pairs(caster.pointType) do
                    if ability:IsCooldownReady() then
                        -- 施法距离
                        local casterLoc = caster:GetAbsOrigin()
                        local radius = ability:GetCastRange()
                        local unitGroup = GetUnitsInRadius(caster,ability,casterLoc,radius)
                        if #unitGroup > 0 then
                            for k,unit in pairs(unitGroup) do
                                castState = true
                                ClearBuff(caster,"debuff")
                                CastAbility(caster,DOTA_UNIT_ORDER_CAST_POSITION,ability,nil,unit:GetAbsOrigin())
                            end
                        end
                    end
                end
            end
            return 1
        end
    end)
end