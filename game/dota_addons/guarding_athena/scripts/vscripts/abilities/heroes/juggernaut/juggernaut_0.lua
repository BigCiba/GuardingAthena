LinkLuaModifier( "modifier_juggernaut_0", "abilities/heroes/juggernaut/juggernaut_0.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if juggernaut_0 == nil then
	juggernaut_0 = class({})
end
function juggernaut_0:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_juggernaut_0", {duration = self:GetSpecialValueFor("duration")})
	if hCaster:GetScepterLevel() >= 1 then
		local illusions = Load(hCaster, "manta_illusion_table") or {}
		for i = #illusions, 1, -1 do
			local hIllusion = illusions[i]
			if not hIllusion:IsNull() then 
				hIllusion:AddNewModifier(hCaster, self, "modifier_juggernaut_0", {duration = self:GetSpecialValueFor("duration")})
			end
		end
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_juggernaut_0 == nil then
	modifier_juggernaut_0 = class({}, nil, ModifierPositiveBuff)
end
function modifier_juggernaut_0:OnCreated(params)
	self.critical = self:GetAbilitySpecialValueFor("critical")
	self.attackspeed = self:GetAbilitySpecialValueFor("attackspeed")
	if IsServer() then
		local hParent = self:GetParent()
		self.flAttackTimeReduce = math.min(hParent:GetBaseAgility() * 0.001 + 0.1, 1)
		hParent:SetBaseAttackTime(hParent:GetBaseAttackTime() - self.flAttackTimeReduce)
	end
end
function modifier_juggernaut_0:OnRefresh(params)
	if IsServer() then
		local hParent = self:GetParent()
		hParent:SetBaseAttackTime(hParent:GetBaseAttackTime() + self.flAttackTimeReduce)
		self.flAttackTimeReduce = math.min(hParent:GetBaseAgility() * 0.001 + 0.1, 1)
		hParent:SetBaseAttackTime(hParent:GetBaseAttackTime() - self.flAttackTimeReduce)
	end
end
function modifier_juggernaut_0:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()
		hParent:SetBaseAttackTime(hParent:GetBaseAttackTime() + self.flAttackTimeReduce)
	end
end
function modifier_juggernaut_0:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE,
		MODIFIER_PROPERTY_CHANGE_ABILITY_VALUE
	}
end
function modifier_juggernaut_0:GetModifierOverrideAbilitySpecial()
	return 1
end
function modifier_juggernaut_0:GetModifierOverrideAbilitySpecialValue()
	return 1000
end
function modifier_juggernaut_0:GetModifierChangeAbilityValue()
	return 1000
end
function modifier_juggernaut_0:GetModifierAttackSpeedBonus_Constant()
	return self.attackspeed
end
function modifier_juggernaut_0:GetModifierBaseDamageOutgoing_Percentage()
	return self.critical
end