LinkLuaModifier( "modifier_pet_22_4_3_rush", "abilities/pets/pet_22_4_3.lua", LUA_MODIFIER_MOTION_HORIZONTAL )
--Abilities
if pet_22_4_3 == nil then
	pet_22_4_3 = class({})
end
function pet_22_4_3:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()

	local duration = self:GetSpecialValueFor('duration')
	local distance = self:GetSpecialValueFor('distance')
	local speed = self:GetSpecialValueFor('speed')
	hCaster:AddNewModifier(hCaster, self, "modifier_pet_22_4_3_rush", {})
	hCaster:EmitSound("Hero_Magnataur.Skewer.Cast")
end
---------------------------------------------------------------------
--Modifiers
if modifier_pet_22_4_3_rush == nil then
	modifier_pet_22_4_3_rush = class({})
end
function modifier_pet_22_4_3_rush:IsHidden()
	return true
end
function modifier_pet_22_4_3_rush:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_pet_22_4_3_rush:GetPriority()
	return DOTA_MOTION_CONTROLLER_PRIORITY_HIGHEST
end
function modifier_pet_22_4_3_rush:OnCreated(params)
	if IsServer() then
		if not self:ApplyHorizontalMotionController() then
			self:Destroy()
			return
		end
		self.distance = self:GetAbilitySpecialValueFor('distance')
		self.fSpeed = self:GetAbilitySpecialValueFor('speed')
		self.vS = self:GetParent():GetAbsOrigin()
		self.vV = self:GetParent():GetForwardVector() * self.fSpeed
		self.radius = self:GetAbilitySpecialValueFor('radius')
		self.impact_damage = self:GetAbilityDamage() * self:GetParent():GetMaster():GetPrimaryStatValue()
		self.impact_stun_duration = self:GetAbilityDuration()
		self.tTargets = {}
	end
end
function modifier_pet_22_4_3_rush:OnDestroy(params)
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController(self)
		for _, hUnit in pairs(self.tTargets) do
			FindClearSpaceForUnit(hUnit, hUnit:GetAbsOrigin(), true)
		end
	end
end
function modifier_pet_22_4_3_rush:UpdateHorizontalMotion(me, dt)
	if IsServer() then
		local vPos = self.vV * dt + self:GetParent():GetAbsOrigin()
		local fDis = (vPos - self.vS):Length2D()
		if fDis > self.distance or GridNav:CanFindPath(self:GetParent():GetAbsOrigin(), vPos) == false then
			fDis = self.distance
		end
		me:SetAbsOrigin(vPos)

		local tTargets = FindUnitsInRadiusWithAbility(me, vPos, self.radius, self:GetAbility())
		for _, hUnit in pairs(tTargets) do
			if TableFindKey(self.tTargets, hUnit) == nil then
				table.insert(self.tTargets, hUnit)
				me:DealDamage(hUnit, self:GetAbility(), self.impact_damage)
			end
			hUnit:SetAbsOrigin(vPos + self:GetParent():GetForwardVector() * 150)
		end

		if fDis == self.distance then
			self:Destroy()
		end
	end
end
function modifier_pet_22_4_3_rush:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_pet_22_4_3_rush:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
end
function modifier_pet_22_4_3_rush:GetOverrideAnimation(params)
	return ACT_DOTA_MAGNUS_SKEWER_END
end
function modifier_pet_22_4_3_rush:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
	}
end