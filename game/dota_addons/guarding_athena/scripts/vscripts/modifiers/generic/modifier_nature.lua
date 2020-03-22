if modifier_nature == nil then
	modifier_nature = class({}, nil, ModifierBasic)
end
function modifier_nature:IsHidden()
	return true
end
function modifier_nature:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end
function modifier_nature:OnCreated(params)
	self.iWatchRadius = 400	-- 看守范围
	self.iPursueTime = 5	-- 追击时间
	self.iRepursueTime = 3	-- 重新追击时间
	if IsServer() then
		self.vSpawnLoc = self:GetParent():GetAbsOrigin()
		self.iAcquisitionRange = self:GetParent():GetAcquisitionRange()
		self.sState = "Idle"
		if self:GetParent():IsNeutralUnitType() == false then
			self:StartIntervalThink(0)
		end
	end
end
function modifier_nature:OnIntervalThink()
	if IsServer() then
		local hParent = self:GetParent()
		-- 静止状态
		if hParent:IsIdle() and hParent:IsPositionInRange(self.vSpawnLoc, hParent:GetHullRadius()) then
			if self.sState ~= "Idle" then
				self.sState = "Idle"
				hParent:SetAcquisitionRange(self.iAcquisitionRange)
				self:StartIntervalThink(0)
			end
			return
		end
		if self.sState == "Idle" and not hParent:IsIdle() then
			self.sState = "Watch"
			hParent:SetAcquisitionRange(1200)
		end
		-- 超出看守范围
		if self.sState == "Watch" and (self:GetParent():GetAbsOrigin() - self.vSpawnLoc):Length2D() > self.iWatchRadius then
			self.sState = "Pursue"
			self:StartIntervalThink(self.iPursueTime)
			return
		end
		-- 5秒后返回
		if self.sState == "Pursue" then
			self.sState = "Return"
			ExecuteOrder(self:GetParent(), DOTA_UNIT_ORDER_MOVE_TO_POSITION, nil, nil, self.vSpawnLoc)
			self:StartIntervalThink(0)
		end
		-- 3秒后重新获得仇恨
		-- if self.sState == "Return" then
		-- 	ExecuteOrder(self:GetParent(), DOTA_UNIT_ORDER_ATTACK_MOVE, nil, nil, self.vSpawnLoc)
		-- 	self:StartIntervalThink(0)
		-- end
		-- -- 重新吸引仇恨
		-- if self.sState == "Return" and hParent:GetAggroTarget() ~= nil then
		-- 	self.sState = "Repursue"
		-- 	self:StartIntervalThink(self.iRepursueTime)
		-- end
		-- -- 返回
		-- if self.sState == "Repursue" then
		-- 	self.sState = "Return"
		-- 	ExecuteOrder(self:GetParent(), DOTA_UNIT_ORDER_MOVE_TO_POSITION, nil, nil, self.vSpawnLoc)
		-- 	self:StartIntervalThink(self.iRepursueTime)
		-- end
	end
end