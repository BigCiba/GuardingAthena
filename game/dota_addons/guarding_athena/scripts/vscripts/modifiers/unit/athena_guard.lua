athena_guard = class({})

function athena_guard:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        --MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
    }
    return funcs
end
function athena_guard:GetModifierPhysicalArmorBonus()
    if IsServer() then
        local armor = 10 + GuardingAthena.athena_armor_lv * 0.25
        return armor
    end
end
--[[function athena_guard:GetModifierIncomingDamage_Percentage()
    if IsServer() then
        local reduce = 10 + GuardingAthena.athena_armor_lv * 0.5
        return reduce
    end
end]]
function athena_guard:IsHidden() 
	return true
end
function athena_guard:GetTexture()
    return "lich_frost_armor"
end