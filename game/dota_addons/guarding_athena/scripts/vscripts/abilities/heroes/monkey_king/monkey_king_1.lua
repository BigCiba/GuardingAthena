monkey_king_1 = class({})
function monkey_king_1:OnSpellStart()
	---@type CDOTA_BaseNPC
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local speed = self:GetSpecialValueFor("speed")
	local distance = self:GetSpecialValueFor("distance")
	local radius = self:GetSpecialValueFor("radius")
	local strike_damage = self:GetSpecialValueFor("strike_damage") * hCaster:GetPrimaryStatValue()
	local flDuration = distance / speed
	local vDirection = (vPosition - hCaster:GetAbsOrigin()):Normalized()
	local flDistance = math.min(distance, (vPosition - hCaster:GetAbsOrigin()):Length2D())
	local hModifier = hCaster:AddNewModifier(hCaster, self, "modifier_monkey_king_1", { duration = 0.3 })
	hCaster:StartGesture(ACT_DOTA_MK_STRIKE)
	-- hCaster:StartGestureWithPlaybackRate(ACT_DOTA_MK_STRIKE, 1 - 0.5 * flDuration )
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/stick_wind.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
	hCaster:EmitSound("Hero_Juggernaut.BladeFuryStart")
	hCaster:Dash(vDirection, flDistance, 150, 0.3, function()
		if IsValid(hModifier) then
			hModifier:Destroy()
		end
		ParticleManager:DestroyParticle(iParticleID, false)
		hCaster:StopSound("Hero_Juggernaut.BladeFuryStart")

		local tTargets = FindUnitsInRadiusWithAbility(hCaster, hCaster:GetAbsOrigin(), radius, self)
		for _, hUnit in ipairs(tTargets) do
			hUnit:KnockBack(CalculateDirection(hUnit, hCaster), 1, 150, 1)
			hCaster:DealDamage(hUnit, self, strike_damage)
		end
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/stick_wind_strike.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(radius, 1, 1))
		ParticleManager:SetParticleControl(iParticleID, 2, Vector(radius, 0, 0))
		hCaster:EmitSound("Hero_MonkeyKing.Strike.Impact.Immortal")
	end)
end
---------------------------------------------------------------------
--Modifiers
modifier_monkey_king_1 = eom_modifier({
	Name = "modifier_monkey_king_1",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_monkey_king_1:GetAbilitySpecialValue()
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.duration = self:GetAbilitySpecialValueFor("duration")
end
function modifier_monkey_king_1:OnCreated(params)
	if IsServer() then
		self.tTargets = {}
		self:StartIntervalThink(0)
	end
end
function modifier_monkey_king_1:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_monkey_king_1:OnIntervalThink()
	if IsServer() then
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()
		local hAbility = self:GetAbility()
		local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.radius, hAbility)
		for _, hUnit in ipairs(tTargets) do
			if TableFindKey(self.tTargets, hUnit) == nil then
				table.insert(self.tTargets, hUnit)
				hCaster:DealDamage(hUnit, hAbility)
				hUnit:AddNewModifier(hCaster, hAbility, "modifier_monkey_king_1_debuff", { duration = self.duration })
				hUnit:KnockBack(hCaster:GetDashDirection(), RemapVal(self:GetElapsedTime(), 0, self:GetDuration(), hCaster:GetDashDistance(), 1), 0, self:GetDuration() - self:GetElapsedTime())
			end
		end
	end
end
function modifier_monkey_king_1:CheckState()
	return {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true
	}
end
---------------------------------------------------------------------
modifier_monkey_king_1_debuff = eom_modifier({
	Name = "modifier_monkey_king_1_debuff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_monkey_king_1_debuff:GetAbilitySpecialValue()
	self.miss = self:GetAbilitySpecialValueFor("miss")
end
function modifier_monkey_king_1_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MISS_PERCENTAGE = self.miss or 0
	}
end