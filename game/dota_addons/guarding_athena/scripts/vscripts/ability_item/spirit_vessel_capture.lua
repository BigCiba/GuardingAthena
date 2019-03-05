LinkLuaModifier("modifier_spirit_vessel_health","modifiers/item/modifier_spirit_vessel_health.lua",LUA_MODIFIER_MOTION_NONE)
function OnHit(t)
    local caster = t.caster
    local target = t.target
    local ability = t.ability
    local duration = ability:GetSpecialValueFor("duration")
    local damage = (ability:GetSpecialValueFor("damage_percent") + ability:GetSpecialValueFor("damage_per_soul") * ability:GetCurrentCharges()) * target:GetMaxHealth() * 0.01
    local health = damage > caster:GetMaxHealth() * 10 and caster:GetMaxHealth() * 10 or damage
    caster:AddNewModifier(caster, ability, "modifier_spirit_vessel_health", {duration=duration,health=health})
    ability:ApplyDataDrivenModifier(caster, target, "modifier_spirit_vessel_capture_debuff", nil)
    ability.no_damage_filter = true
    CauseDamage(caster,target,damage,DAMAGE_TYPE_MAGICAL,ability)
    ability.no_damage_filter = nil
    Timers:CreateTimer(duration,function()
        if not target:IsNull() then
            Heal(target,damage,0,false)
        end
    end)
end
function OnDestroy(t)
    local caster = t.caster
    local target = t.target
    local ability = t.ability
    if not target:IsAlive() then
        caster:TakeItem(ability)
        local item = CreateItem("item_spirit_vessel_release", caster, caster)
        caster:AddItem(item)
        item.original_item = ability
        item.capture_unit_name = target:GetUnitName()
        item.capture_unit_attack_min = target:GetBaseDamageMin()
        item.capture_unit_attack_max = target:GetBaseDamageMax()
        item.capture_unit_health = target:GetMaxHealth()
    end
end
function OnDeath(t)
    local caster = t.caster
    local target = t.target
    local ability = t.ability
    UTIL_Remove(target)
end
function OnRelease(t)
    local caster = t.caster
    local point = t.target_points[1]
    local ability = t.ability
    local original_ability = ability.original_item
    if not original_ability then return end
    local duration = ability:GetSpecialValueFor("duration")
    local unit = CreateUnitByName(ability.capture_unit_name, point, true, nil, nil, DOTA_TEAM_GOODGUYS )
    unit.soul_unit = true
    unit:SetOwner(caster:GetPlayerOwner())
    unit:SetControllableByPlayer(caster:GetPlayerID(), true)
    unit:SetMaxHealth(ability.capture_unit_health)
    unit:SetHealth(ability.capture_unit_health)
    unit:SetBaseMaxHealth(ability.capture_unit_health)
    unit:SetBaseDamageMin(ability.capture_unit_attack_min)
    unit:SetBaseDamageMax(ability.capture_unit_attack_max)
    unit:AddNewModifier(unit, nil, "modifier_kill", {duration=duration})
    original_ability:ApplyDataDrivenModifier(caster, unit, "modifier_spirit_vessel_capture_buff", nil)
    caster:RemoveItem(ability)
    caster:AddItem(original_ability)
end
function OnAttack(t)
    local caster = t.caster
    local target = t.target
    local ability = t.ability
    CauseDamage(caster,target,t.attacker:GetBaseDamageMax() + caster:GetPrimaryStatValue() * 10,DAMAGE_TYPE_MAGICAL,ability)
end