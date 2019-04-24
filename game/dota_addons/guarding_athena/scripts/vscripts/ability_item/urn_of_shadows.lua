LinkLuaModifier("modifier_urn_of_shadows_health","modifiers/item/modifier_urn_of_shadows_health.lua",LUA_MODIFIER_MOTION_NONE)
function OnHit(t)
    local caster = t.caster
    local target = t.target
    local ability = t.ability
    local duration = ability:GetSpecialValueFor("duration")
    local damage = (ability:GetSpecialValueFor("damage_percent") + ability:GetSpecialValueFor("damage_per_soul") * ability:GetCurrentCharges()) * target:GetMaxHealth() * 0.01
    local health = damage > caster:GetMaxHealth() * 10 and caster:GetMaxHealth() * 10 or math.ceil(damage)
    caster:AddNewModifier(caster, ability, "modifier_urn_of_shadows_health", {duration=duration,health=health})
    ability:ApplyDataDrivenModifier(caster, target, "modifier_urn_of_shadows_debuff", nil)
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
    local charges = ability:GetCurrentCharges()
    local max_soul = ability:GetSpecialValueFor("max_soul")
    if not target:IsAlive() then
        ability:SetCurrentCharges(charges + 1)
    end
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_urn_of_shadow_buff", nil)
    caster:SetModifierStackCount("modifier_item_urn_of_shadow_buff", caster, charges + 1)
    if charges + 1 >= max_soul then
        caster:RemoveItem(ability)
        local item = CreateItem("item_spirit_vessel_capture", caster, caster)
        caster:AddItem(item)
    end
end
function OnCreated(t)
    local caster = t.caster
    local target = t.target
    local ability = t.ability
    local charges = ability:GetCurrentCharges()
    if charges > 0 then
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_urn_of_shadow_buff", nil)
        caster:SetModifierStackCount("modifier_item_urn_of_shadow_buff", caster, charges)
    end
end
function OnDrop(t)
    local caster = t.caster
    caster:RemoveModifierByName("modifier_item_urn_of_shadow_buff")
end