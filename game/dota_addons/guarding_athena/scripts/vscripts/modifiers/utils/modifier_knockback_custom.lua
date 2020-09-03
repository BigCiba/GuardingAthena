if modifier_knockback_custom == nil then
	modifier_knockback_custom = class({}, nil, BothMotionModifier)
end

local public = modifier_knockback_custom

function public:OnCreated(params)
	if IsServer() then
		-- 传入参数
		self.vCenter = StringToVector(params.vCenter)
		self.bStun = params.bStun
		self.knockback_duration = params.knockback_duration
		self.knockback_distance = params.knockback_distance
		self.knockback_height = params.knockback_height
		self.bBlock = params.bBlock
		-- 计算参数
		self.vStart = self:GetParent():GetAbsOrigin()
		self.vSpeed = self.knockback_distance / self.knockback_duration
		self.vDirection = (self.vStart - self.vCenter):Normalized()
		self.flFactor = math.sqrt(self.knockback_height)

		local a = math.sqrt(self.knockback_height)
		self.funcGetJmepHeight = function(x)
			x = (x / self.knockback_distance) * a * 2 - a
			return -(x ^ 2) + self.knockback_height
		end
		if not self:ApplyVerticalMotionController() or not self:ApplyHorizontalMotionController() then
			self:Destroy()
		end
	end
end
function public:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()
		hParent:RemoveHorizontalMotionController(self)
		hParent:RemoveVerticalMotionController(self)
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
	if self.bBlock == 1 and not GridNav:CanFindPath(hParent:GetAbsOrigin(), vPosition) then
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
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}
end
function public:GetOverrideAnimation(params)
	return ACT_DOTA_FLAIL
end
function public:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = self.bStun == 1,
	}
end