LinkLuaModifier( "modifier_wave_32_1", "abilities/enemy/wave_32_1.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if wave_32_1 == nil then
	wave_32_1 = class({})
end
function wave_32_1:GetIntrinsicModifierName()
	return "modifier_wave_32_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_wave_32_1 == nil then
	modifier_wave_32_1 = class({}, nil, ModifierHidden)
end
function modifier_wave_32_1:OnCreated(params)
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.damage = self:GetAbilitySpecialValueFor("damage")
	if IsServer() then
	end
end
function modifier_wave_32_1:OnRefresh(params)
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.damage = self:GetAbilitySpecialValueFor("damage")
	if IsServer() then
	end
end
function modifier_wave_32_1:OnDestroy()
	if IsServer() then
	end
end
function modifier_wave_32_1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PURE
	}
end
function modifier_wave_32_1:GetModifierProcAttack_BonusDamage_Pure(params)
	if not IsValid(params.target) or params.target:GetClassname() == "dota_item_drop" then return end
	if params.target ~= nil and
	not params.attacker:PassivesDisabled() and
	RollPseudoRandomPercentage( self.chance, self:GetAbility():entindex(), self:GetParent()) then
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_teleport_flash.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.target)
		self:AddParticle(iParticleID, false, false, -1, false, false)
		params.target:EmitSound("Hero_Chen.HolyPersuasionCast")
		return self.damage
	end
end