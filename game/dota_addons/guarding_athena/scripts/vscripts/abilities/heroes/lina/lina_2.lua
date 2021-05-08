lina_2 = class({})
function lina_2:OnAbilityPhaseStart()
	---@type CDOTA_BaseNPC
	local hCaster = self:GetCaster()
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_phase_start.vpcf", PATTACH_ABSORIGIN, hCaster)
	ParticleManager:ReleaseParticleIndex(iParticleID)
	hCaster:EmitSound("Hero_Invoker.Invoke")
	return true
end
function lina_2:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function lina_2:OnSpellStart()
	---@type CDOTA_BaseNPC
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	self:LightStrikeArray(vPosition)
	if hCaster:GetScepterLevel() >= 2 then
		local count = 2
		self:GameTimer(0.2, function()
			if count > 0 then
				count = count - 1
				self:LightStrikeArray(vPosition, "particles/units/heroes/hero_lina/lina_2_secondary.vpcf")
				hCaster:FindModifierByName("modifier_lina_0"):OnValidAbilityExecuted()
				return 0.2
			end
		end)
	end
end
function lina_2:LightStrikeArray(vPosition, sEffect)
	---@type CDOTA_BaseNPC
	local hCaster = self:GetCaster()
	local sParticleName = sEffect or "particles/units/heroes/hero_lina/lina_2.vpcf"
	-- local vPosition = self:GetCursorPosition()
	local radius = self:GetSpecialValueFor("radius")
	local stun_duration = self:GetSpecialValueFor("stun_duration")
	local duration = self:GetSpecialValueFor("duration")
	local ignite_count = self:GetSpecialValueFor("ignite_count")
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, vPosition, radius, self)
	for _, hUnit in ipairs(tTargets) do
		hUnit:AddNewModifier(hCaster, self, "modifier_stunned", { duration = stun_duration })
		hCaster:DealDamage(hUnit, self)
		hCaster:_LinaIgnite(hUnit, ignite_count)
	end
	local iParticleID = ParticleManager:CreateParticle(sParticleName, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(radius, 0, 0))
	ParticleManager:ReleaseParticleIndex(iParticleID)
	hCaster:EmitSound("Ability.LightStrikeArray")

	CreateModifierThinker(hCaster, self, "modifier_lina_2_thinker", { duration = duration }, vPosition, hCaster:GetTeamNumber(), false)
end
---------------------------------------------------------------------
--Modifiers
modifier_lina_2_thinker = eom_modifier({
	Name = "modifier_lina_2_thinker",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
}, nil, ModifierThinker)
function modifier_lina_2_thinker:GetAbilitySpecialValue()
	self.interval = self:GetAbilitySpecialValueFor("interval")
	self.tick_damage = self:GetAbilitySpecialValueFor("tick_damage")
	self.radius = self:GetAbilitySpecialValueFor("radius")
end
function modifier_lina_2_thinker:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(self.interval)
	end
end
function modifier_lina_2_thinker:OnIntervalThink()
	---@type CDOTA_BaseNPC
	local hCaster = self:GetCaster()
	---@type CDOTA_BaseNPC
	local hParent = self:GetParent()
	---@type CDOTABaseAbility
	local hAbility = self:GetAbility()
	local flDamage = hCaster:GetIntellect() * self.tick_damage
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, hParent:GetAbsOrigin(), self.radius, hAbility)
	hCaster:DealDamage(tTargets, hAbility, flDamage)
end