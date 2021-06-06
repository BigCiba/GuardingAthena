---@class 冲刺
modifier_dash = eom_modifier({
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
	LuaModifierType = LUA_MODIFIER_MOTION_BOTH
})

local public = modifier_dash

function public:OnCreated(params)
	if IsServer() then
		local hParent = self:GetParent()
		-- 传入参数
		self.vDirection = (StringToVector(params.vDirection)):Normalized()
		self.knockback_duration = Round(params.knockback_duration, 2)
		self.knockback_distance = Round(params.knockback_distance, 0)
		self.knockback_height = Round(params.knockback_height, 0)
		self.bBlock = params.bBlock
		self:SetDuration(self.knockback_duration, true)
		-- 计算参数
		self.vStart = hParent:GetAbsOrigin()
		self.vSpeed = self.knockback_distance / self.knockback_duration
		self.flFactor = math.sqrt(self.knockback_height)
		self.flTime = 0

		local a = math.sqrt(self.knockback_height)
		self.funcGetJmepHeight = function(x)
			x = (x / self.knockback_duration) * a * 2 - a
			return -(x ^ 2) + self.knockback_height
		end
		if not self:ApplyVerticalMotionController() or not self:ApplyHorizontalMotionController() then
			self:Destroy()
		end
		hParent.GetDashDirection = function(hParent)
			return self.vDirection
		end
		hParent.GetDashDistance = function(hParent)
			return self.knockback_distance
		end
		hParent.GetDashDuration = function(hParent)
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
		if IsValid(self._hIntrinsicModifier) then
			self._hIntrinsicModifier:Destroy()
		end
		FireModifierEvent({
			event_name = MODIFIER_EVENT_ON_DASH_END,
			unit = hParent
		})
	end
end
function public:OnHorizontalMotionInterrupted()
	self:Destroy()
end
function public:OnVerticalMotionInterrupted()
	self:Destroy()
end
function public:UpdateHorizontalMotion(hParent, dt)
	if self.flTime + dt > self.knockback_duration then
		dt = self.knockback_duration - self.flTime
	end
	self.flTime = self.flTime + dt
	local vPosition = hParent:GetAbsOrigin() + self.vDirection * self.vSpeed * dt
	hParent:SetAbsOrigin(vPosition)
end
function public:UpdateVerticalMotion(hParent, dt)
	local flDistance = (hParent:GetAbsOrigin() - self.vStart):Length2D()
	local flHeight = self.vStart.z + self.funcGetJmepHeight(self.flTime)
	local vPosition = hParent:GetAbsOrigin()
	hParent:SetAbsOrigin(Vector(vPosition.x, vPosition.y, flHeight))
end