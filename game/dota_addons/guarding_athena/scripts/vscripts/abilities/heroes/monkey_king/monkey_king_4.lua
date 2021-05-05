monkey_king_4 = class({})
function monkey_king_4:OnSpellStart()
	---@type CDOTA_BaseNPC
	local hCaster = self:GetCaster()
	local vCasterLoc = hCaster:GetAbsOrigin()
	local vPosition = self:GetCursorPosition()
	local thump_damage = self:GetSpecialValueFor("thump_damage") * hCaster:GetAverageTrueAttackDamage(hCaster)
	local thump_radius = self:GetSpecialValueFor("thump_radius")
	local thump_duration = self:GetSpecialValueFor("thump_duration")
	local crush_damage = self:GetSpecialValueFor("crush_damage") * hCaster:GetAverageTrueAttackDamage(hCaster)
	local crush_radius = self:GetSpecialValueFor("crush_radius")
	local crush_duration = self:GetSpecialValueFor("crush_duration")
	for i = 1, 18 do
		local vTargetPosition = RotatePosition(vCasterLoc, QAngle(0, 20 * i, 0), vCasterLoc + (vPosition - vCasterLoc):Normalized() * thump_radius)
		local vTargetDirection = (vTargetPosition - vCasterLoc):Normalized()
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_strike_cast.vpcf", PATTACH_ABSORIGIN, hCaster)
		ParticleManager:SetParticleControlForward(iParticleID, 0, vTargetDirection)
		ParticleManager:ReleaseParticleIndex(iParticleID)
	end
	hCaster:EmitSound("Hero_MonkeyKing.Strike.Cast")
	self:GameTimer(0.2, function()
		for i = 1, 18 do
			local vTargetPosition = RotatePosition(vCasterLoc, QAngle(0, 20 * i, 0), vCasterLoc + (vPosition - vCasterLoc):Normalized() * thump_radius)
			local vTargetDirection = (vTargetPosition - vCasterLoc):Normalized()
			local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_strike.vpcf", PATTACH_ABSORIGIN, hCaster)
			ParticleManager:SetParticleControlForward(iParticleID, 0, vTargetDirection)
			ParticleManager:SetParticleControl(iParticleID, 1, vTargetPosition)
			ParticleManager:ReleaseParticleIndex(iParticleID)
		end
		CreateSound("Hero_MonkeyKing.Strike.Impact", hCaster)
		local tTargets = FindUnitsInRadiusWithAbility(hCaster, vCasterLoc, thump_radius, self)
		for _, hUnit in ipairs(tTargets) do
			hCaster:DealDamage(hUnit, self, thump_damage, DAMAGE_TYPE_PURE, DOTA_DAMAGE_FLAG_REFLECTION)
			local vDirection = (hUnit:GetAbsOrigin() - hCaster:GetAbsOrigin()):Normalized()
			hUnit:KnockBack(vDirection, 50, 150, 1)
		end
	end)
	local iCount = 1
	if hCaster:GetScepterLevel() >= 4 then
		iCount = self:GetSpecialValueFor("scepter_count")
		crush_damage = crush_damage * self:GetSpecialValueFor("scepter_damage") * 0.01
	end
	self:GameTimer(1, function()
		if iCount > 0 then
			CreateModifierThinker(hCaster, self, "modifier_monkey_king_4_thinker", { duration = 0.3 }, vPosition + RandomVector(RandomInt(0, 100)), hCaster:GetTeamNumber(), false)
			iCount = iCount - 1
			vPosition = vPosition
			return 1
		end
	end)
end
function monkey_king_4:GetIntrinsicModifierName()
	return "modifier_monkey_king_4"
end
---------------------------------------------------------------------
--Modifiers
modifier_monkey_king_4 = eom_modifier({
	Name = "modifier_monkey_king_4",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_monkey_king_4:GetAbilitySpecialValue()
	self.pure_pct = self:GetAbilitySpecialValueFor("pure_pct")
end
function modifier_monkey_king_4:OnCreated(params)
	if IsServer() then
	end
end
function modifier_monkey_king_4:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_monkey_king_4:OnDestroy()
	if IsServer() then
	end
end

function modifier_monkey_king_4:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE = { self:GetParent() }
	}
end
function modifier_monkey_king_4:OnTakeDamage(params)
	if IsServer() then
		if params.unit:HasModifier("modifier_monkey_king_4_debuff") then
			if params.damage_flags and
			(bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION or
			bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS) then
				return
			end
			self:GetParent():DealDamage(params.unit, self:GetAbility(), params.original_damage * self.pure_pct * 0.01, DAMAGE_TYPE_PURE, DOTA_DAMAGE_FLAG_REFLECTION)
		end
	end
end
---------------------------------------------------------------------
modifier_monkey_king_4_thinker = eom_modifier({
	Name = "modifier_monkey_king_4_thinker",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
}, nil, ModifierThinker)
function modifier_monkey_king_4_thinker:GetAbilitySpecialValue()
	self.crush_radius = self:GetAbilitySpecialValueFor("crush_radius")
	self.crush_damage = self:GetAbilitySpecialValueFor("crush_damage")
	self.crush_duration = self:GetAbilitySpecialValueFor("crush_duration")
end
function modifier_monkey_king_4_thinker:OnCreated(params)
	if IsServer() then
	else
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/jingubang.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
		ParticleManager:SetParticleControl(iParticleID, 1, hParent:GetAbsOrigin())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_monkey_king_4_thinker:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_monkey_king_4_thinker:OnDestroy()
	if IsServer() then
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()
		local hAbility = self:GetAbility()
		local flDamage = self.crush_damage * hCaster:GetAverageTrueAttackDamage(hCaster)
		local tTargets = FindUnitsInRadiusWithAbility(hCaster, hParent:GetAbsOrigin(), self.crush_radius, hAbility)
		for _, hUnit in ipairs(tTargets) do
			hCaster:DealDamage(hUnit, hAbility, flDamage, DAMAGE_TYPE_PURE, DOTA_DAMAGE_FLAG_REFLECTION)
			hUnit:AddNewModifier(hCaster, hAbility, "modifier_monkey_king_4_debuff", { duration = self.crush_duration })
		end
		EmitSoundOnLocationWithCaster(hParent:GetAbsOrigin(), "Hero_ElderTitan.EchoStomp", hCaster)
		if IsValid(self:GetParent()) then
			UTIL_Remove(self:GetParent())
		end
	end
end
---------------------------------------------------------------------
modifier_monkey_king_4_debuff = eom_modifier({
	Name = "modifier_monkey_king_4_debuff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_monkey_king_4_debuff:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true
	}
end