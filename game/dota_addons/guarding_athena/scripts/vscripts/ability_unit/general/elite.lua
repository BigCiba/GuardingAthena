function OnTakeDamage( t )
    local caster = t.caster
    local damage = t.DamageTaken
    SetUnitIncomingDamageReduce(caster,0)
    local reduce = caster.percent_reduce_damage
    if reduce > 99 then
        reduce = 99
    end
    damage = damage * (1 - (reduce * 0.01))
    if damage > caster:GetMaxHealth() then
        damage = caster:GetMaxHealth()
    end
    local percent = damage / caster:GetMaxHealth() * 100
    if percent > 0 then
        SetUnitDamagePercent(caster,percent *  5,10)
        SetUnitIncomingDamageReduce(caster, percent * 2.5, 10)
    end 
end
function OnCreated( t )
    local unit = t.caster
    unit:SetModelScale(unit:GetModelScale() + 0.5)
    unit:SetDeathXP(unit:GetDeathXP() * Spawner.difficulty * Spawner.unitFactor.eliteFactor ^ Spawner.gameRound)
    unit:SetMinimumGoldBounty(unit:GetGoldBounty() * Spawner.difficulty  * Spawner.unitFactor.eliteFactor ^ Spawner.gameRound)
    unit:SetMaximumGoldBounty(unit:GetGoldBounty() * Spawner.difficulty  * Spawner.unitFactor.eliteFactor ^ Spawner.gameRound)
    unit:SetBaseDamageMin(unit:GetBaseDamageMin() * Spawner.difficulty  * Spawner.unitFactor.eliteFactor ^ Spawner.gameRound)
    unit:SetBaseDamageMax(unit:GetBaseDamageMax() * Spawner.difficulty  * Spawner.unitFactor.eliteFactor ^ Spawner.gameRound)
    unit:SetBaseMaxHealth(unit:GetBaseMaxHealth() * Spawner.difficulty  * Spawner.unitFactor.eliteFactor ^ Spawner.gameRound)
    unit:SetMaxHealth(unit:GetBaseMaxHealth())
    unit:SetHealth(unit:GetBaseMaxHealth())
    unit:SetPhysicalArmorBaseValue(unit:GetPhysicalArmorBaseValue() * Spawner.difficulty * Spawner.unitFactor.eliteFactor ^ Spawner.gameRound)
end