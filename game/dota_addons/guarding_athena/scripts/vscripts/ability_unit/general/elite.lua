function OnTakeDamage( t )
    local caster = t.caster
    local damage = t.DamageTaken
    SetUnitIncomingDamageReduce(caster,0)
    SetUnitDamagePercent(caster,0)
    local reduce = caster.percent_reduce_damage
    local increace = caster.percent_bonus_damage
    if reduce > 80 then
        reduce = 80
    end
    -- 计算减少后的伤害
    damage = damage * (1 - (reduce * 0.01))
    -- 最大伤害不超过生命值
    if damage > caster:GetMaxHealth() then
        damage = caster:GetMaxHealth()
    end
    -- 伤害所占百分比
    local percent = damage / caster:GetMaxHealth() * 100
    local damagePercent = percent *  5
    local damageReduce = percent * 2.5
    -- 最大减伤不超过80%
    if reduce + damageReduce > 80 then
        damageReduce = 80 - reduce
    end
    -- 最大增伤不超过50%
    if increace + damagePercent > 50 then
        damagePercent = 50 - increace
    end
    if percent > 0 then
        SetUnitDamagePercent(caster, damagePercent, 10)
        SetUnitIncomingDamageReduce(caster, damageReduce, 10)
    end 
end
function OnBossTakeDamage( t )
    local caster = t.caster
    local damage = t.DamageTaken
    SetUnitIncomingDamageReduce(caster,0)
    SetUnitDamagePercent(caster,0)
    local reduce = caster.percent_reduce_damage
    local increace = caster.percent_bonus_damage
    if reduce > 50 then
        reduce = 50
    end
    -- 计算减少后的伤害
    damage = damage * (1 - (reduce * 0.01))
    -- 最大伤害不超过生命值
    if damage > caster:GetMaxHealth() then
        damage = caster:GetMaxHealth()
    end
    -- 伤害所占百分比
    local percent = damage / caster:GetMaxHealth() * 100
    local damageReduce = percent
    -- 最大减伤不超过80%
    if reduce + damageReduce > 50 then
        damageReduce = 50 - reduce
    end
    if percent > 0 then
        SetUnitIncomingDamageReduce(caster, damageReduce, 10)
    end 
end
function OnCreated( t )
     local unit = t.caster
    unit:SetModelScale(unit:GetModelScale() + 0.5)
    unit:SetDeathXP(unit:GetDeathXP() * Spawner.difficulty * Spawner.unitFactor.eliteFactor ^ Spawner.gameRound)
    unit:SetMinimumGoldBounty(unit:GetGoldBounty() * (Spawner.difficulty / 2 + 0.5)  * Spawner.unitFactor.eliteFactor ^ Spawner.gameRound)
    unit:SetMaximumGoldBounty(unit:GetGoldBounty() * (Spawner.difficulty / 2 + 0.5)  * Spawner.unitFactor.eliteFactor ^ Spawner.gameRound)
    unit:SetBaseDamageMin(unit:GetBaseDamageMin() * (Spawner.difficulty / 2 + 0.5)  * Spawner.unitFactor.eliteFactor ^ Spawner.gameRound)
    unit:SetBaseDamageMax(unit:GetBaseDamageMax() * (Spawner.difficulty / 2 + 0.5)  * Spawner.unitFactor.eliteFactor ^ Spawner.gameRound)
    unit:SetBaseMaxHealth(unit:GetBaseMaxHealth() * (Spawner.difficulty / 2 + 0.5)  * Spawner.unitFactor.eliteFactor ^ Spawner.gameRound)
    unit:SetMaxHealth(unit:GetBaseMaxHealth())
    unit:SetHealth(unit:GetBaseMaxHealth())
    --unit:SetPhysicalArmorBaseValue(unit:GetPhysicalArmorBaseValue() * Spawner.difficulty * Spawner.unitFactor.eliteFactor ^ Spawner.gameRound)
end