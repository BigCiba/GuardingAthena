lina_1 = class({})
function lina_1:OnAbilityPhaseStart()
	---@type CDOTA_BaseNPC
	local hCaster = self:GetCaster()
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_phase_start.vpcf", PATTACH_ABSORIGIN, hCaster)
	ParticleManager:ReleaseParticleIndex(iParticleID)
	hCaster:EmitSound("Hero_Invoker.Invoke")
	return true
end
function lina_1:OnSpellStart()
	---@type CDOTA_BaseNPC
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local distance = self:GetSpecialValueFor("distance")
	local width = self:GetSpecialValueFor("width")
	local stun_duration = self:GetSpecialValueFor("stun_duration")
	local miss_duration = self:GetSpecialValueFor("miss_duration")
	local ignite_count = self:GetSpecialValueFor("ignite_count")
	local vStart = hCaster:GetAbsOrigin()
	local vEnd = vStart + (vPosition - vStart):Normalized() * distance
	local tTargets = FindUnitsInLineWithAbility(hCaster, vStart, vEnd, width, self)
	for _, hUnit in ipairs(tTargets) do
		hUnit:AddNewModifier(hCaster, self, "modifier_stunned", { duration = stun_duration })
		hUnit:AddNewModifier(hCaster, self, "modifier_lina_1_debuff", { duration = miss_duration })
		hCaster:DealDamage(hUnit, self)
		hCaster:_LinaIgnite(hUnit, ignite_count)
	end
	-- 特效
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/dark_fire.vpcf", PATTACH_CUSTOMORIGIN, nil)
	-- ParticleManager:SetParticleControlEnt(iParticleID, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_attack1", hCaster:GetAbsOrigin(), false)
	ParticleManager:SetParticleControl(iParticleID, 0, vStart + Vector(0, 0, 100))
	ParticleManager:SetParticleControl(iParticleID, 1, vEnd + Vector(0, 0, 100))
	ParticleManager:ReleaseParticleIndex(iParticleID)
	-- 音效
	hCaster:EmitSound("Ability.LagunaBladeImpact")

	-- 专属一
	if hCaster:GetScepterLevel() >= 1 then
		local scepter_duration = self:GetSpecialValueFor("scepter_duration")
		local scepter_damage_pct = self:GetSpecialValueFor("scepter_damage_pct")
		local tData = {
			duration = scepter_duration,
			flDamage = (self:GetSpecialValueFor("base_damage") + self:GetSpecialValueFor("damage") * hCaster:GetIntellect()) * scepter_damage_pct * 0.01,
			vEndX = vEnd.x,
			vEndY = vEnd.y,
		}
		CreateModifierThinker(hCaster, self, "modifier_lina_1_thinker", tData, vStart, hCaster:GetTeamNumber(), false)
	end
end
---------------------------------------------------------------------
--Modifiers
modifier_lina_1_debuff = eom_modifier({
	Name = "modifier_lina_1_debuff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = true,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_lina_1_debuff:GetAbilitySpecialValue()
	self.miss = self:GetAbilitySpecialValueFor("miss")
end
function modifier_lina_1_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MISS_PERCENTAGE = self.miss or 0
	}
end
---------------------------------------------------------------------
modifier_lina_1_thinker = eom_modifier({
	Name = "modifier_lina_1_thinker",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
}, nil, ModifierThinker)
function modifier_lina_1_thinker:GetAbilitySpecialValue()
	self.width = self:GetAbilitySpecialValueFor("width")
end
function modifier_lina_1_thinker:OnCreated(params)
	if IsServer() then
		---@type CDOTA_BaseNPC
		local hParent = self:GetParent()
		self.vEnd = GetGroundPosition(Vector(params.vEndX, params.vEndY, 0), hParent)
		self.flDamage = params.flDamage
		self:StartIntervalThink(1)
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/jakiro/jakiro_ti10_immortal/jakiro_ti10_macropyre.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
		ParticleManager:SetParticleControl(iParticleID, 1, self.vEnd)
		ParticleManager:SetParticleControl(iParticleID, 2, Vector(self:GetDuration(), 0, 0))
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_lina_1_thinker:OnIntervalThink()
	---@type CDOTA_BaseNPC
	local hCaster = self:GetCaster()
	---@type CDOTA_BaseNPC
	local hParent = self:GetParent()
	---@type CDOTABaseAbility
	local hAbility = self:GetAbility()
	local tTargets = FindUnitsInLineWithAbility(hCaster, hParent:GetAbsOrigin(), self.vEnd, self.width, hAbility)
	for _, hUnit in ipairs(tTargets) do
		hCaster:DealDamage(hUnit, hAbility, self.flDamage)
		hCaster:_LinaIgnite(hUnit, 1)
	end
end