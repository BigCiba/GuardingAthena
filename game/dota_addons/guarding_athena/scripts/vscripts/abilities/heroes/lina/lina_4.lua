lina_4 = class({})
function lina_4:OnSpellStart()
	---@type CDOTA_BaseNPC
	local hCaster = self:GetCaster()
	CreateModifierThinker(hCaster, self, "modifier_lina_4", nil, hCaster:GetAbsOrigin(), hCaster:GetTeamNumber(), false)
	hCaster:EmitSound("Hero_Invoker.Invoke")
end
---------------------------------------------------------------------
--Modifiers
modifier_lina_4 = eom_modifier({
	Name = "modifier_lina_4",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
}, nil, ModifierThinker)
function modifier_lina_4:GetAbilitySpecialValue()
	self.interval = self:GetAbilitySpecialValueFor("interval")
	self.wave_count = self:GetAbilitySpecialValueFor("wave_count")
	self.count_per_wave = self:GetAbilitySpecialValueFor("count_per_wave")
	self.delay = self:GetAbilitySpecialValueFor("delay")
	self.max_radius = self:GetAbilitySpecialValueFor("max_radius")
end
function modifier_lina_4:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(self.delay)
	else
		---@type CDOTA_BaseNPC
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_4_start.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_lina_4:OnDestroy()
	if IsServer() then
		---@type CDOTA_BaseNPC
		local hParent = self:GetParent()
		hParent:StopSound("Hero_Invoker.ChaosMeteor.Loop")
		if IsValid(hParent) then
			UTIL_Remove(hParent)
		end
	end
end
function modifier_lina_4:OnIntervalThink()
	---@type CDOTA_BaseNPC
	local hCaster = self:GetCaster()
	---@type CDOTA_BaseNPC
	local hParent = self:GetParent()
	---@type CDOTABaseAbility
	local hAbility = self:GetAbility()
	for i = 1, self.count_per_wave do
		local vPosition = hParent:GetAbsOrigin() + RandomVector(RandomInt(0, self.max_radius))
		if hCaster:GetScepterLevel() >= 4 then
			local tTargets = FindUnitsInRadiusWithAbility(hCaster, hParent:GetAbsOrigin(), self.max_radius, hAbility)
			if IsValid(tTargets[1]) then
				vPosition = tTargets[1]:GetAbsOrigin()
			end
		end
		CreateModifierThinker(hCaster, hAbility, "modifier_lina_4_meteor", {duration = 1.3}, vPosition, hCaster:GetTeamNumber(), false)
	end
	self.wave_count = self.wave_count - 1
	if self.wave_count <= 0 then
		self:Destroy()
	end
	if self.delay ~= self.interval then
		self.delay = self.interval
		self:StartIntervalThink(self.interval)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_4.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
		self:AddParticle(iParticleID, false, false, -1, false, false)
		hParent:EmitSound("Hero_Invoker.ChaosMeteor.Loop")
	end
end
---------------------------------------------------------------------
--Modifiers
modifier_lina_4_meteor = eom_modifier({
	Name = "modifier_lina_4_meteor",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
}, nil, ModifierThinker)
function modifier_lina_4_meteor:GetAbilitySpecialValue()
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.ignite_count = self:GetAbilitySpecialValueFor("ignite_count")
	self.stun_duration = self:GetAbilitySpecialValueFor("stun_duration")
end
function modifier_lina_4_meteor:OnCreated(params)
	---@type CDOTA_BaseNPC
	local hParent = self:GetParent()
	if IsServer() then
	else
		local vPosition = hParent:GetAbsOrigin()
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_4_meteor.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, vPosition + Vector(300, 300, 1000))
		ParticleManager:SetParticleControl(iParticleID, 1, vPosition)
		ParticleManager:SetParticleControl(iParticleID, 2, Vector(1.3, 0, 0))
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_lina_4_meteor:OnDestroy()
	if IsServer() then
		---@type CDOTA_BaseNPC
		local hCaster = self:GetCaster()
		---@type CDOTA_BaseNPC
		local hParent = self:GetParent()
		---@type CDOTABaseAbility
		local hAbility = self:GetAbility()
		local vPosition = hParent:GetAbsOrigin()
		local flDamage = hAbility:GetSpecialValueFor("base_damage") + hAbility:GetSpecialValueFor("damage") * self:GetPrimaryStatValue()
		if hCaster:GetScepterLevel() >= 4 then
			flDamage = flDamage * (1 + hAbility:GetSpecialValueFor("scepter_damage_pct") * 0.01)
		end
		local tTargets = FindUnitsInRadiusWithAbility(hCaster, vPosition, self.radius, hAbility)
		for _, hUnit in ipairs(tTargets) do
			hCaster:_LinaIgnite(hUnit, self.ignite_count)
			hUnit:AddNewModifier(hCaster, hAbility, "modifier_stunned", { duration = self.stun_duration })
			hCaster:DealDamage(hUnit, hAbility)
		end
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_4_landding.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
		ParticleManager:ReleaseParticleIndex(iParticleID)
		if IsValid(hParent) then
			UTIL_Remove(hParent)
		end
	end
end