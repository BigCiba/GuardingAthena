LinkLuaModifier( "modifier_rubick_0", "abilities/heroes/rubick/rubick_0.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if rubick_0 == nil then
	rubick_0 = class({})
end
function rubick_0:GetAbilityTextureName()
	return AssetModifiers:GetAbilityTextureReplacement(self:GetAbilityName(), self:GetCaster())
end
function rubick_0:Bounce(hTarget, tTargets, flRadius, flDamage, max_count)
	local hCaster = self:GetCaster()
	if IsValid(hCaster) and IsValid(hTarget) then
		local hNewTarget = nil
		local tUnitGroup = FindUnitsInRadiusWithAbility(hCaster, hTarget:GetAbsOrigin(), flRadius, self, FIND_CLOSEST)
		for i = 1, #tUnitGroup do
			if TableFindKey(tTargets, tUnitGroup[i]) == nil then
				hNewTarget = tUnitGroup[i]
				hCaster:DealDamage(hNewTarget, self, flDamage)
				table.insert(tTargets, hNewTarget)
				-- 特效
				local iParticleID = ParticleManager:CreateParticle(AssetModifiers:GetParticleReplacement("particles/units/heroes/hero_rubick/rubick_base_attack.vpcf", hCaster), PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControlEnt(iParticleID, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), false)
				ParticleManager:SetParticleControlEnt(iParticleID, 1, hNewTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hNewTarget:GetAbsOrigin(), false)
				ParticleManager:ReleaseParticleIndex(iParticleID)
				break
			end
		end
		max_count = max_count - 1
		if max_count > 0 and hNewTarget then
			self:Bounce(hNewTarget, tTargets, flRadius, flDamage, max_count)
		end
	end
end
function rubick_0:FadeBolt(hTarget)
	local hCaster = self:GetCaster()
	local flDamage = hCaster:GetIntellect() * self:GetSpecialValueFor("damage_factor")
	local max_count = self:GetSpecialValueFor("max_count")
	local flRadius = self:GetSpecialValueFor("bounce_radius")
	local tTargets = {}
	hCaster:DealDamage(hTarget, self, flDamage)
	table.insert(tTargets, hTarget)
	self:Bounce(hTarget, tTargets, flRadius, flDamage, max_count - 1)
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
	local sParticleName = AssetModifiers:GetParticleReplacement("particles/heroes/chronos_magic/space_phase.vpcf", hCaster)
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