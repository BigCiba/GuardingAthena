LinkLuaModifier( "modifier_rubick_0", "abilities/heroes/rubick/rubick_0.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if rubick_0 == nil then
	rubick_0 = class({})
end
function rubick_0:SpaceRift(vPosition)
	local hCaster = self:GetCaster()
	local flRadius = self:GetSpecialValueFor("radius")
	local flCenterRadius = self:GetSpecialValueFor("center_radius")
	local flCenterDamage = self:GetSpecialValueFor("center_damage") * 0.01
	local flDamage = self:GetSpecialValueFor("damage") * hCaster:GetIntellect()
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, vPosition, flRadius, self)
	for _, hUnit in pairs(tTargets) do
		local _flDamage = flDamage
		if (hUnit:GetAbsOrigin() - vPosition):Length2D() <= flCenterRadius then
			_flDamage = _flDamage + hUnit:GetMaxHealth() * flCenterDamage
		end
		hCaster:DealDamage(hUnit, self, _flDamage)
	end
	-- particle
	local sParticleName = "particles/heroes/chronos_magic/space_phase.vpcf"
	if hCaster.gift then
		sParticleName = "particles/heroes/chronos_magic/space_gold_phase.vpcf"
	end
	local iParticleID = ParticleManager:CreateParticle(sParticleName, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
	EmitSoundOnLocationWithCaster(vPosition, "Hero_SkywrathMage.MysticFlare.Target", hCaster)
end
function rubick_0:GetIntrinsicModifierName()
	return "modifier_rubick_0"
end
---------------------------------------------------------------------
--Modifiers
if modifier_rubick_0 == nil then
	modifier_rubick_0 = class({}, nil, ModifierHidden)
end
function modifier_rubick_0:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end
function modifier_rubick_0:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
		local hParent = self:GetParent()
		hParent.SpaceRift = function (hParent, vPosition)
			self:GetAbility():SpaceRift(vPosition)
		end
	end
	AddModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, self:GetParent())
end
function modifier_rubick_0:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_rubick_0:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()
		hParent.SpaceRift = nil
	end
	RemoveModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, self:GetParent())
end
function modifier_rubick_0:OnAttackLanded(params)
	if IsServer() then
		if params.attacker == self:GetParent() and self:GetParent():GetScepterLevel() >= 1 then
			self:GetParent():SpaceRift(params.target:GetAbsOrigin() + RandomVector(RandomInt(0, self.radius)))
		end
	end
end