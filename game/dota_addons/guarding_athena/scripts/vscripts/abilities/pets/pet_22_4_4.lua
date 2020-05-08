LinkLuaModifier( "modifier_pet_22_4_4_hop", "abilities/pets/pet_22_4_4.lua", LUA_MODIFIER_MOTION_HORIZONTAL )
--Abilities
if pet_22_4_4 == nil then
	pet_22_4_4 = class({})
end
function pet_22_4_4:OnAbilityPhaseStart()
	self:GetCaster():StartGesture(ACT_DOTA_LEAP_STUN)
	return true
end
function pet_22_4_4:OnAbilityPhaseInterrupted()
	self:GetCaster():FadeGesture(ACT_DOTA_LEAP_STUN)
end
function pet_22_4_4:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()

	local duration = self:GetSpecialValueFor('duration')
	hCaster:AddNewModifier(hCaster, self, "modifier_pet_22_4_4_hop", { duration = duration, distance = (vPosition - hCaster:GetAbsOrigin()):Length2D() })

end
---------------------------------------------------------------------
--Modifiers
if modifier_pet_22_4_4_hop == nil then
	modifier_pet_22_4_4_hop = class({})
end
function modifier_pet_22_4_4_hop:IsHidden()
	return true
end
function modifier_pet_22_4_4_hop:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_pet_22_4_4_hop:GetPriority()
	return DOTA_MOTION_CONTROLLER_PRIORITY_HIGHEST
end
function modifier_pet_22_4_4_hop:OnCreated(params)
	if IsServer() then
		if not self:ApplyHorizontalMotionController() then
			self:Destroy()
			return
		end
		self.distance = params.distance
		self.fSpeed = self.distance / self:GetDuration()
		self.vS = self:GetParent():GetAbsOrigin()
		self.vV = self:GetParent():GetForwardVector() * self.fSpeed
		self.radius = self:GetAbilitySpecialValueFor('radius')
		self.impact_damage = self:GetAbilityDamage() * self:GetParent():GetMaster():GetPrimaryStatValue()
		self.impact_stun_duration = self:GetAbilityDuration()
	end
end
function modifier_pet_22_4_4_hop:OnDestroy(params)
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController(self)
		self:GetCaster():FadeGesture(ACT_DOTA_LEAP_STUN)
	end
end
function modifier_pet_22_4_4_hop:JumpFinish()
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()

	local iParticleID = ParticleManager:CreateParticle("particles/econ/items/centaur/centaur_ti6/centaur_ti6_warstomp.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, GetGroundPosition(hParent:GetAbsOrigin(), hCaster))
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.radius, self.radius, self.radius))
	hParent:EmitSound("Hero_Centaur.HoofStomp")

	local tTargets = FindUnitsInRadiusWithAbility(hCaster, hParent:GetAbsOrigin(), self.radius, self:GetAbility())
	for _, hUnit in pairs(tTargets) do
		hCaster:DealDamage(hUnit, self:GetAbility(), self.impact_damage)
		hUnit:AddNewModifier(hCaster, self:GetAbility(), "modifier_stunned", {duration = self.impact_stun_duration * hUnit:GetStatusResistanceFactor()})
	end
end
function modifier_pet_22_4_4_hop:UpdateHorizontalMotion(me, dt)
	if IsServer() then
		local vPos = self.vV * dt + self:GetParent():GetAbsOrigin()
		local fDis = (vPos - self.vS):Length2D()
		if fDis > self.distance then
			fDis = self.distance
		end
		me:SetAbsOrigin(vPos)

		if fDis == self.distance then
			--成功着陆
			self:JumpFinish()
			self:Destroy()
		end
	end
end
function modifier_pet_22_4_4_hop:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_pet_22_4_4_hop:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
	}
end