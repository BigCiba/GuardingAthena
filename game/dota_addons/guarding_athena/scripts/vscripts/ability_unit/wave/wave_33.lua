function OnCreated( t )
    local caster = t.caster
    local ability = t.ability
    local cd = ability:GetSpecialValueFor("cooldown")
    AddDamageFilterVictim(caster,"doppleganger",function (damage,attacker)
        if ability:IsCooldownReady() then
            damage = 0
            OnDoppleganger(caster,ability)
            ability:StartCooldown(cd)
        end
        return damage
    end)
end
function OnDoppleganger( caster,ability )
    local unitGroup = GetUnitsInRadius(caster,ability,caster:GetAbsOrigin(),900)
    if #unitGroup > 0 then
        local point = unitGrou[1]:GetAbsOrigin()
        for i=1,6 do
            if i == 1 then
                SetUnitPosition(caster,GetRotationPoint(point,175,i * 60))
            else
                PrecacheUnitByNameAsync("captain_guai_34_split",function()
                    local illusion = CreateUnitByName("captain_guai_34_split", GetRotationPoint(point,175,i * 60), true, nil, nil, DOTA_TEAM_BADGUYS ) 
                    illusion:SetBaseDamageMin(caster:GetBaseDamageMin() * 0.3)
                    illusion:SetBaseDamageMax(caster:GetBaseDamageMax() * 0.3)
                    SetMaxHealth(illusion,caster:GetBaseMaxHealth() * 0.3)
                    illusion:SetPhysicalArmorBaseValue(caster:GetPhysicalArmorBaseValue() * 0.3)
                    SetUnitPosition(illusion,GetRotationPoint(point,175,i * 60))
                end)
            end
        end
    end
end