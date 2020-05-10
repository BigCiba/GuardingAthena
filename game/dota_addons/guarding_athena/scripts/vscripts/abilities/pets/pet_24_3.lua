LinkLuaModifier( "modifier_pet_24_3", "abilities/pets/pet_24_3.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_pet_24_3_buff", "abilities/pets/pet_24_3.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_pet_24_3_jump", "abilities/pets/pet_24_3.lua", LUA_MODIFIER_MOTION_BOTH )
--Abilities
if pet_24_3 == nil then
	pet_24_3 = class({})
end
function pet_24_3:GetIntrinsicModifierName()
	return "modifier_pet_24_3"
end
---------------------------------------------------------------------
--Modifiers
if modifier_pet_24_3 == nil then
	modifier_pet_24_3 = class({}, nil, ModifierHidden)
end
function modifier_pet_24_3:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(0)
	end
end
function modifier_pet_24_3:OnIntervalThink()
	if self:GetCaster().GetMaster ~= nil and not self:GetCaster():GetMaster():HasModifier("modifier_pet_24_3_buff") then
		self:GetCaster():GetMaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_pet_24_3_buff", nil)
		self:StartIntervalThink(-1)
	end
end
---------------------------------------------------------------------
if modifier_pet_24_3_buff == nil then
	modifier_pet_24_3_buff = class({}, nil, ModifierHidden)
end
function modifier_pet_24_3_buff:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end
function modifier_pet_24_3_buff:OnCreated(params)
	self.distance = self:GetAbilitySpecialValueFor("distance")
	if IsServer() then
	end
	AddModifierEvents(MODIFIER_EVENT_ON_ORDER, self, self:GetParent())
end
function modifier_pet_24_3_buff:OnRefresh(params)
	self.distance = self:GetAbilitySpecialValueFor("distance")
end
function modifier_pet_24_3_buff:OnDestroy()
	RemoveModifierEvents(MODIFIER_EVENT_ON_ORDER, self, self:GetParent())
end
function modifier_pet_24_3_buff:DeclareFunctions()
	return {
		-- MODIFIER_EVENT_ON_ORDER,
	}
end
function modifier_pet_24_3_buff:OnOrder(params)
	if params.unit == self:GetParent() then
		if params.order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION
		or params.order_type == DOTA_UNIT_ORDER_MOVE_TO_TARGET
		or params.order_type == DOTA_UNIT_ORDER_ATTACK_MOVE
		or params.order_type == DOTA_UNIT_ORDER_ATTACK_TARGET
		then
			local vLocation = params.target == nil and params.new_pos or params.target:GetAbsOrigin()
			local flDistance = (vLocation - params.unit:GetAbsOrigin()):Length2D()
			if self:GetAbility():IsCooldownReady() and flDistance > self.distance / 2 then
				local distance = math.min(self.distance, flDistance)
				params.unit:AddNewModifier(params.unit, self:GetAbility(), "modifier_pet_24_3_jump", {distance = distance, vDir = (vLocation - params.unit:GetAbsOrigin()):Normalized()})
				params.unit:FaceTowards(vLocation)
				self:GetAbility():UseResources(false, false, true)
			end
		end
	end
end
---------------------------------------------------------------------
if modifier_pet_24_3_jump == nil then
	modifier_pet_24_3_jump = class({})
end
function modifier_pet_24_3_jump:IsHidden()
	return false
end
function modifier_pet_24_3_jump:IsDebuff()
	return false
end
function modifier_pet_24_3_jump:IsPurgable()
	return false
end
function modifier_pet_24_3_jump:IsPurgeException()
	return false
end
function modifier_pet_24_3_jump:IsStunDebuff()
	return false
end
function modifier_pet_24_3_jump:AllowIllusionDuplicate()
	return false
end
function modifier_pet_24_3_jump:OnCreated(params)
	if IsServer() then
		if self:ApplyHorizontalMotionController() then 
			-- self:GetParent():EmitSound("Ability.Leap")
			self:GetParent():EmitSound("Hero_Zuus.Taunt.Jump")
			
			
			self.radius = self:GetAbilitySpecialValueFor("radius")
			self.flDamage = self:GetParent():GetPrimaryStatValue() * self:GetAbilityDamage()
			self.stun_duration = self:GetAbilityDuration()
			
			self.distance = params.distance
			self.speed = self:GetAbilitySpecialValueFor("speed")
			self.acceleration = self:GetAbilitySpecialValueFor("acceleration")

			self.vForwardVector = StringToVector(params.vDir)
			self.fDuration = self.distance / self.speed
			self.vVelocity = self.vForwardVector * self.speed
			self.fTime = 0
			if self:ApplyVerticalMotionController() then
				local fHeightDifference = GetGroundHeight(self:GetParent():GetAbsOrigin()+self.vForwardVector*self.distance, self:GetParent()) - (self:GetParent():GetAbsOrigin()).z
				self.vUpVector = self:GetParent():GetUpVector()
				self.vAcceleration = -self.vUpVector * self.acceleration
				self.vStartVerticalVelocity = Vector(0, 0, fHeightDifference)/self.fDuration - self.vAcceleration * self.fDuration/2
			end
		else
			self:Destroy()
		end
	end
end
function modifier_pet_24_3_jump:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController(self)
		self:GetParent():RemoveVerticalMotionController(self)
		local hParent = self:GetParent()
		local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.radius, self:GetAbility())
		for _, hUnit in pairs(tTargets) do
			hUnit:AddNewModifier(hParent, self:GetAbility(), "modifier_stunned", {duration = self.stun_duration * hUnit:GetStatusResistanceFactor()})
			hParent:DealDamage(hUnit, self:GetAbility(), self.flDamage)
		end
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_centaur/centaur_warstomp.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.radius,self.radius,self.radius))
		-- hParent:EmitSound("Hero_Zuus.Taunt.Jump")
	end
end
function modifier_pet_24_3_jump:UpdateHorizontalMotion(me, dt)
	if IsServer() then
		local position = me:GetAbsOrigin()+self.vVelocity*dt

		me:SetAbsOrigin(position)
	end
end
function modifier_pet_24_3_jump:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_pet_24_3_jump:UpdateVerticalMotion(me, dt)
	if IsServer() then
		me:SetAbsOrigin(me:GetAbsOrigin()+(self.vAcceleration*self.fTime+self.vStartVerticalVelocity)*dt)
		self.fTime = self.fTime + dt
		if self.fTime > self.fDuration then
			self:Destroy()
		end
	end
end
function modifier_pet_24_3_jump:OnVerticalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_pet_24_3_jump:CheckState()
	return {
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
	}
end
function modifier_pet_24_3_jump:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_DISABLE_TURNING,
	}
end
function modifier_pet_24_3_jump:GetOverrideAnimation(params)
	return ACT_DOTA_FLAIL
end
function modifier_pet_24_3_jump:GetModifierDisableTurning(params)
	return 1
end