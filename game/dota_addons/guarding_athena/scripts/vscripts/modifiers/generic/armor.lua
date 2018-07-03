armor = class({})

function armor:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
    return funcs
end
function armor:OnCreated( t )
    if IsServer() then
        self.armor = t.armor
        self.attribute = t.attribute or MODIFIER_ATTRIBUTE_NONE
        CustomNetTables:SetTableValue("courier_attributes","courier_attributes" .. self:GetParent():GetEntityIndex(),{armor=t.armor})
    end
end
function armor:GetAttributes( t )
    if IsServer() then
        return self.attribute
    end
end
function armor:GetModifierPhysicalArmorBonus(t)
    if IsServer() then
        return self.armor
    end
    local armor = CustomNetTables:GetTableValue("courier_attributes","courier_attributes" .. self:GetParent():GetEntityIndex())
    if armor and armor.armor then
        return armor.armor
    end
end
function armor:IsHidden() 
	return true
end