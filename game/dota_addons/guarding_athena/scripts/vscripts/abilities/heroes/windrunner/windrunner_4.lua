LinkLuaModifier( "modifier_windrunner_4", "abilities/heroes/windrunner/windrunner_4.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if windrunner_4 == nil then
	windrunner_4 = class({})
end
function windrunner_4:Precache(context)
	PrecacheResource("particle", "particles/skills/arrow_strom.vpcf", context)
	PrecacheResource("particle", "particles/skills/arrow_strom_1.vpcf", context)
end
function windrunner_4:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_windrunner_4", {duration = self:GetSpecialValueFor("duration")})
end
function windrunner_4:GetIntrinsicModifierName()
	return "modifier_windrunner_4"
end
---------------------------------------------------------------------
--Modifiers
if modifier_windrunner_4 == nil then
	modifier_windrunner_4 = class({}, nil, ModifierHidden)
end
function modifier_windrunner_4:OnCreated(params)
	self.interval = self:GetAbilitySpecialValueFor("interval")
	self.damage_radius = self:GetAbilitySpecialValueFor("damage_radius")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.base_damage = self:GetAbilitySpecialValueFor("base_damage")
	self.damage = self:GetAbilitySpecialValueFor("damage")
	if IsServer() then
		self.hThinker = CreateModifierThinker(self:GetParent(), self:GetAbility(), "modifier_windrunner_4_thinker", {duration = self:GetDuration()}, self:GetParent():GetAbsOrigin(), self:GetParent():GetTeamNumber(), false)
		self:StartIntervalThink(self.interval)
	end
end
function modifier_windrunner_4:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_windrunner_4:OnIntervalThink()
	self.hThinker:FindModifierByName("modifier_windrunner_4_thinker"):ForceRefresh()
end
function modifier_windrunner_4:DeclareFunctions()
	return {
	}
end