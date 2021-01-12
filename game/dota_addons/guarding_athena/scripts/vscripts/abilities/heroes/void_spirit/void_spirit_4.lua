LinkLuaModifier("modifier_void_spirit_4_phase", "abilities/heroes/void_spirit/void_spirit_4.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_void_spirit_4_debuff", "abilities/heroes/void_spirit/void_spirit_4.lua", LUA_MODIFIER_MOTION_VERTICAL)
--Abilities
if void_spirit_4 == nil then
	void_spirit_4 = class({})
end
function void_spirit_4:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:EmitSound("Hero_VoidSpirit.Dissimilate.Cast")
	hCaster:EmitSound("Hero_VoidSpirit.Dissimilate.Portals")
	local disappear_time = self:GetSpecialValueFor("disappear_time")
	hCaster:Stop()
	hCaster:AddNewModifier(hCaster, self, "modifier_void_spirit_4_phase", { duration = disappear_time })
end
---------------------------------------------------------------------
--Modifiers
if modifier_void_spirit_4_phase == nil then
	modifier_void_spirit_4_phase = class({})
end
function modifier_void_spirit_4_phase:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()

		local destination_fx_radius = self:GetAbilitySpecialValueFor("destination_fx_radius")
		local portals_per_ring = self:GetAbilitySpecialValueFor("portals_per_ring")
		local angle_per_ring_portal = self:GetAbilitySpecialValueFor("angle_per_ring_portal")
		local first_ring_distance_offset = self:GetAbilitySpecialValueFor("first_ring_distance_offset")

		self.tDoors = {}
		local vPosition = hParent:GetAbsOrigin()
		self:CreateDoor(vPosition, true)
		local vDir = hParent:GetForwardVector()
		for i = 1, portals_per_ring do
			--偏移方向角度
			self:CreateDoor(vPosition + vDir * first_ring_distance_offset)
			vDir = RotatePosition(Vector(0, 0, 0), QAngle(0, 60, 0), vDir)
		end
		-- 隐藏英雄
		hParent:AddNoDraw()
		ProjectileManager:ProjectileDodge(hParent)
	end
end
function modifier_void_spirit_4_phase:OnRefresh(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
	end
end
function modifier_void_spirit_4_phase:OnDestroy()
	if IsServer() then
		if IsServer() then
			local hParent = self:GetParent()
			--现身
			hParent:RemoveNoDraw()
			for iParticleID, vPosition in pairs(self.tDoors) do
				if self.iDoorIDShow == iParticleID then
					FindClearSpaceForUnit(hParent, self.tDoors[self.iDoorIDShow], true)
				else
					hParent:AetherRemnant(vPosition)
				end
			end
			hParent:StartGesture(ACT_DOTA_CAST_ABILITY_3_END)
			--特效
			local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate_exit.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
			ParticleManager:ReleaseParticleIndex(iParticleID)
			local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate_dmg.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
			ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.radius / 1.5, 0, self.radius))
			ParticleManager:ReleaseParticleIndex(iParticleID)

			local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.radius, self:GetAbility())
			for k, hTarget in pairs(tTargets) do
				hParent:DealDamage(hTarget, self:GetAbility())
				-- hTarget:AddNewModifier(hParent, self:GetAbility(), "modifier_stunned", { duration = self.stun_duration })
			end
			hParent:EmitSound('Hero_VoidSpirit.Dissimilate.TeleportIn')
		end
	end
end
function modifier_void_spirit_4_phase:CreateDoor(vPosition, bCenter)
	vPosition = GetGroundPosition(vPosition, nil)
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.radius + 30, 0, 0))
	ParticleManager:SetParticleControl(iParticleID, 2, Vector(0, 0, 0))
	self:AddParticle(iParticleID, false, false, -1, false, false)
	self.tDoors[iParticleID] = vPosition
	if bCenter then
		self.iDoorIDShow = iParticleID
		ParticleManager:SetParticleControl(iParticleID, 2, Vector(1, 0, 0))
	end
	-- 额外吸引怪效果
	local hParent = self:GetParent()
	local tTargets = FindUnitsInRadiusWithAbility(hParent, vPosition, self.radius, self:GetAbility())
	for _, hUnit in ipairs(tTargets) do
		hUnit:AddNewModifier(hParent, self:GetAbility(), "modifier_void_spirit_4_debuff", { duration = self:GetDuration() })
	end
end
function modifier_void_spirit_4_phase:ShowDoor(vPosition)
	local fDis = nil
	local iDoorID
	for iParticleID, vDoorPosition in pairs(self.tDoors) do
		local fDisCur = (vDoorPosition - vPosition):Length2D()
		if not fDis or fDis > fDisCur then
			fDis = fDisCur
			iDoorID = iParticleID
		end
	end
	ParticleManager:SetParticleControl(self.iDoorIDShow, 2, Vector(0, 0, 0))
	self.iDoorIDShow = iDoorID
	ParticleManager:SetParticleControl(iDoorID, 2, Vector(1, 0, 0))
end
function modifier_void_spirit_4_phase:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ORDER,
	}
end
function modifier_void_spirit_4_phase:CheckState()
	return {
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_MUTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
	}
end
function modifier_void_spirit_4_phase:OnOrder(params)
	if params.unit == self:GetParent() then
		if DOTA_UNIT_ORDER_MOVE_TO_POSITION == params.order_type
		or DOTA_UNIT_ORDER_ATTACK_MOVE == params.order_type then
			self:ShowDoor(params.new_pos)
		elseif DOTA_UNIT_ORDER_ATTACK_TARGET == params.order_type
		or DOTA_UNIT_ORDER_MOVE_TO_TARGET == params.order_type then
			if IsValid(params.target) then
				self:ShowDoor(params.target:GetAbsOrigin())
			end
		end
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_void_spirit_4_debuff == nil then
	modifier_void_spirit_4_debuff = class({}, nil, VerticalMotionModifier)
end
function modifier_void_spirit_4_debuff:OnCreated(params)
	self.stun_duration = self:GetAbilitySpecialValueFor("stun_duration")
	if IsServer() then
		self.fMotionDuration = 0.2
		self.fHeight = self:GetParent():GetModelScale() * 100
		self.flSpeed = self.fHeight / self.fMotionDuration
		if self:ApplyVerticalMotionController() then
			self.fTime = 0
		else
			self:Destroy()
		end
	end
end
function modifier_void_spirit_4_debuff:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveVerticalMotionController(self)
		FindClearSpaceForUnit(self:GetParent(), self:GetCaster():GetAbsOrigin(), true)
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = self.stun_duration})
	end
end
function modifier_void_spirit_4_debuff:OnVerticalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_void_spirit_4_debuff:UpdateVerticalMotion(me, dt)
	if IsServer() then
		me:SetAbsOrigin(me:GetAbsOrigin() - Vector(0, 0, self.flSpeed) * dt)
		self.fTime = self.fTime + dt
		if self.fTime > self.fMotionDuration then
			return
		end
	end
end
function modifier_void_spirit_4_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}
end
function modifier_void_spirit_4_debuff:GetOverrideAnimation(params)
	return ACT_DOTA_FLAIL
end
function modifier_void_spirit_4_debuff:CheckState()
	return {
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_MUTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	}
end