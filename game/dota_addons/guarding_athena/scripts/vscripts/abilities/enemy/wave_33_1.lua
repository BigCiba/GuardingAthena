LinkLuaModifier( "modifier_wave_33_1", "abilities/enemy/wave_33_1.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if wave_33_1 == nil then
	wave_33_1 = class({})
end
function wave_33_1:GetIntrinsicModifierName()
	return "modifier_wave_33_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_wave_33_1 == nil then
	modifier_wave_33_1 = class({}, nil, ModifierHidden)
end
function modifier_wave_33_1:OnCreated(params)
	self.mana_burn = self:GetAbilitySpecialValueFor("mana_burn")
	if IsServer() then
	end
	AddModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, self:GetParent())
end
function modifier_wave_33_1:OnRefresh(params)
	self.mana_burn = self:GetAbilitySpecialValueFor("mana_burn")
	if IsServer() then
	end
end
function modifier_wave_33_1:OnDestroy()
	if IsServer() then
	end
	RemoveModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, self:GetParent())
end
function modifier_wave_33_1:OnAttackLanded(params)
	if not IsValid(params.target) or params.target:GetClassname() == "dota_item_drop" then return end
	if params.attacker == self:GetParent() and not params.attacker:PassivesDisabled() then
		params.target:SpendMana(self.mana_burn, self:GetAbility())
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_chen/chen_teleport_flash.vpcf", PATTACH_ABSORIGIN_FOLLOW, params.target)
		self:AddParticle(iParticleID, false, false, -1, false, false)
		params.target:EmitSound("Hero_Antimage.ManaBreak")
	end
end