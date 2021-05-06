lina_0 = class({})
function lina_0:GetIntrinsicModifierName()
	return "modifier_lina_0"
end
---------------------------------------------------------------------
--Modifiers
modifier_lina_0 = eom_modifier({
	Name = "modifier_lina_0",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_lina_0:GetAbilitySpecialValue()
	self.duration = self:GetAbilitySpecialValueFor("duration")
end
function modifier_lina_0:OnCreated(params)
	if IsServer() then
	end
end
function modifier_lina_0:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_lina_0:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_VALID_ABILITY_EXECUTED = { self:GetParent() }
	}
end
function modifier_lina_0:OnValidAbilityExecuted(params)
	if IsServer() then
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_lina_0_buff", { duration = self.duration })
	end
end
---------------------------------------------------------------------
modifier_lina_0_buff = eom_modifier({
	Name = "modifier_lina_0_buff",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_lina_0_buff:GetAbilitySpecialValue()
	self.interval = self:GetAbilitySpecialValueFor("interval")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.reduce = self:GetAbilitySpecialValueFor("reduce")
	self.damage = self:GetAbilitySpecialValueFor("damage")
	self.ignite_count = self:GetAbilitySpecialValueFor("ignite_count")
end
function modifier_lina_0_buff:OnCreated(params)
	if IsServer() then
		self.tData = { self:GetDieTime() }
		self:IncrementStackCount()
		self:StartIntervalThink(0)
		self.flTime = 0
	else
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/skills/ashes_body.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hParent, PATTACH_ABSORIGIN_FOLLOW, nil, hParent:GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_lina_0_buff:OnRefresh(params)
	if IsServer() then
		self:IncrementStackCount()
		table.insert(self.tData, self:GetDieTime())
	end
end
function modifier_lina_0_buff:OnIntervalThink()
	---@type CDOTA_BaseNPC
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	self.flTime = self.flTime + FrameTime()
	if self.flTime >= self.interval then
		self.flTime = 0
		local flDamage = hParent:GetIntellect() * self.damage * self:GetStackCount()
		local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.radius, hAbility)
		for _, hUnit in ipairs(tTargets) do
			hParent:DealDamage(hUnit, hAbility, flDamage)
			hParent:_LinaIgnite(hUnit, self.ignite_count)
		end
	end
	local flTime = GameRules:GetGameTime()
	for i = #self.tData, 1, -1 do
		if self.tData[i] < flTime then
			self:DecrementStackCount()
			table.remove(self.tData, i)
		end
	end
end
function modifier_lina_0_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK
	}
end
function modifier_lina_0_buff:GetModifierTotal_ConstantBlock()
	return self:GetStackCount() * self.reduce * self:GetParent():GetIntellect()
end