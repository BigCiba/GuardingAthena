---@class 击退
modifier_knockback_custom = eom_modifier({
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
	LuaModifierType = LUA_MODIFIER_MOTION_BOTH
})

local public = modifier_knockback_custom

function public:OnCreated(params)
	if IsServer() then
		local hParent = self:GetParent()
		-- 传入参数
		self.vDirection = (StringToVector(params.vDirection)):Normalized()
		self.knockback_duration = params.knockback_duration
		self.knockback_distance = params.knockback_distance
		self.knockback_height = params.knockback_height
		self.bStun = params.bStun == 1 and true or false
		self.bBlock = params.bBlock == 1 and true or false
		-- 计算参数
		self.vStart = hParent:GetAbsOrigin()
		self.vSpeed = self.knockback_distance / self.knockback_duration
		self.flFactor = math.sqrt(self.knockback_height)

		local a = math.sqrt(self.knockback_height)
		self.funcGetJmepHeight = function(x)
			x = (x / self.knockback_duration) * a * 2 - a
			return -(x ^ 2) + self.knockback_height
		end
		if not self:ApplyVerticalMotionController() or not self:ApplyHorizontalMotionController() then
			self:Destroy()
		end
		hParent.GetKnockbackDirection = function(hParent)
			return self.vDirection
		end
		hParent.GetKnockbackDistance = function(hParent)
			return self.knockback_distance
		end
		hParent.GetKnockbackDuration = function(hParent)
			return self.knockback_duration
		end
	end
end
function public:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()
		hParent:RemoveHorizontalMotionController(self)
		hParent:RemoveVerticalMotionController(self)
		if self.callback then
			self.callback()
		end
		-- FireModifierEvent({
		-- 	event_name = MODIFIER_EVENT_ON_DASH_END,
		-- 	unit = hParent
		-- })
	end
end
function public:OnHorizontalMotionInterrupted()
	self:Destroy()
end
function public:OnVerticalMotionInterrupted()
	self:Destroy()
end
function public:UpdateHorizontalMotion(hParent, dt)
	local vPosition = hParent:GetAbsOrigin() + self.vDirection * self.vSpeed * dt
	if self.bBlock == true and not GridNav:CanFindPath(hParent:GetAbsOrigin(), vPosition) then
		return
	end
	hParent:SetAbsOrigin(vPosition)
end
function public:UpdateVerticalMotion(hParent, dt)
	local flDistance = (hParent:GetAbsOrigin() - self.vStart):Length2D()
	local flHeight = self.vStart.z + self.funcGetJmepHeight(flDistance)
	local vPosition = hParent:GetAbsOrigin()
	hParent:SetAbsOrigin(Vector(vPosition.x, vPosition.y, flHeight))
end
function public:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	-- MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
	}
end
function public:GetOverrideAnimation(params)
	return ACT_DOTA_FLAIL
end
-- function public:GetActivityTranslationModifiers()
-- 	return "forcestaff_friendly"
-- end
function public:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = self.bStun,
	}
end