LinkLuaModifier( "modifier_wave_9_1", "abilities/enemy/wave_9_1.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if wave_9_1 == nil then
	wave_9_1 = class({})
end
function wave_9_1:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_wave_9_1", {duration = self:GetDuration()})
	hCaster:EmitSound("Hero_LegionCommander.PressTheAttack")
end
---------------------------------------------------------------------
--Modifiers
if modifier_wave_9_1 == nil then
	modifier_wave_9_1 = class({}, nil, ModifierPositiveBuff)
end
function modifier_wave_9_1:OnCreated(params)
	self.attackspeed = self:GetAbilitySpecialValueFor("attackspeed")
	self.heal = self:GetAbilitySpecialValueFor("heal")
	if IsServer() then
	else
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_commander_press_owner.vpcf", PATTACH_CUSTOMORIGIN, hParent)
		ParticleManager:SetParticleControlEnt(iParticleID, 2, hParent, PATTACH_POINT_FOLLOW, "attach_attack1", hParent:GetAbsOrigin(), false)
	end
end
function modifier_wave_9_1:OnRefresh(params)
	self.attackspeed = self:GetAbilitySpecialValueFor("attackspeed")
	self.heal = self:GetAbilitySpecialValueFor("heal")
end
function modifier_wave_9_1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
	}
end
function modifier_wave_9_1:GetModifierAttackSpeedBonus_Constant()
	return self.attackspeed
end
function modifier_wave_9_1:GetModifierConstantHealthRegen()
	return self.heal
end