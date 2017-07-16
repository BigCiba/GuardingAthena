fumo_armor_debuff = class({})

function fumo_armor_debuff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
    return funcs
end
function fumo_armor_debuff:GetModifierPhysicalArmorBonus( t )
    --[[if IsServer() then
        local armor_constant = self:GetAbility():GetSpecialValueFor("armor_loss_constant")
        local armor_percent = self:GetAbility():GetSpecialValueFor("armor_loss_percent")
        local total_armor_loss = armor_constant + armor_percent * self:GetParent():GetPhysicalArmorBaseValue()
        print(total_armor_loss)
        return -total_armor_loss
    else
        print(self:GetParent())
        local total_armor_loss = 80 + 0.8 * self:GetParent():GetPhysicalArmorBaseValue()
        return -total_armor_loss
    end]]--
    return -1000
end
function fumo_armor_debuff:IsDebuff() 
	return true
end
function fumo_armor_debuff:GetTexture()
    return "item_jian_9"
end
