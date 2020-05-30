if modifier_wave == nil then
	modifier_wave = class({}, nil, ModifierHidden)
end
function modifier_wave:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end
function modifier_wave:OnCreated(params)
	self.BaseAttackSpeed = (KeyValues.UnitsKv[self:GetParent():GetUnitName()].BaseAttackSpeed or 0) * GameRules:GetCustomGameDifficulty() / 2
	if IsServer() then
	end
end
function modifier_wave:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_wave:AllowIllusionDuplicate()
	return true
end
function modifier_wave:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end
function modifier_wave:GetModifierAttackSpeedBonus_Constant()
	return self.BaseAttackSpeed
end