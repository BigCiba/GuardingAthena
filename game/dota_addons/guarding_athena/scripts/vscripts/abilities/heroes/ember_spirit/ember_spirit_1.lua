ember_spirit_1 = class({})
function ember_spirit_1:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function ember_spirit_1:SleightOfFist(hTarget)
	local hCaster = self:GetCaster()
	local vCasterPosition = hCaster:GetAbsOrigin()
	local vTargetPosition = hTarget:GetAbsOrigin()
	local vDirection = vTargetPosition - vCasterPosition
	vDirection.z = 0

	local vPosition = vTargetPosition - vDirection:Normalized() * 50

	hCaster:SetAbsOrigin(vPosition)
	hCaster:PerformAttack(hTarget, true, true, true, false, false, false, true)
	hCaster:SetAbsOrigin(vCasterPosition)
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleightoffist_trail.vpcf", PATTACH_WORLDORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vCasterPosition)
	ParticleManager:SetParticleControl(iParticleID, 1, vPosition)
	ParticleManager:ReleaseParticleIndex(iParticleID)

	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleightoffist_tgt.vpcf", PATTACH_CUSTOMORIGIN, hTarget)
	ParticleManager:SetParticleControlEnt(iParticleID, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(iParticleID)
end
function ember_spirit_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local radius = self:GetSpecialValueFor("radius")

	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_cast.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(radius, radius, radius))
	ParticleManager:ReleaseParticleIndex(iParticleID)

	hCaster:RemoveModifierByName("modifier_ember_spirit_1")
	hCaster:AddNewModifier(hCaster, self, "modifier_ember_spirit_1", { vPosition = vPosition })
	hCaster:EmitSound("Hero_EmberSpirit.SleightOfFist.Cast")
end
---------------------------------------------------------------------
--Modifiers
modifier_ember_spirit_1 = eom_modifier({
	Name = "modifier_ember_spirit_1",
	IsHidden = false,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_ember_spirit_1:GetAbilitySpecialValue()
	self.base_damage = self:GetAbilitySpecialValueFor("base_damage")
	self.damage = self:GetAbilitySpecialValueFor("damage")
	self.interval = self:GetAbilitySpecialValueFor("interval")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.count = self:GetAbilitySpecialValueFor("count")
	if IsServer() then
		self.flDamage = self.base_damage + self.damage * self:GetParent():GetAverageTrueAttackDamage(self:GetParent())
	end
end
function modifier_ember_spirit_1:OnCreated(params)
	if IsServer() then
		local hParent = self:GetParent()
		hParent:AddNoDraw()
		local hAbility = self:GetAbility()
		self.vPosition = StringToVector(params.vPosition)
		local hParent = self:GetParent()
		self.tTargets = FindUnitsInRadiusWithAbility(hParent, self.vPosition, self.radius, hAbility)
		self.tExtraTargets = {}
		table.sort(self.tTargets, function(a, b)
			return a:HasModifier("modifier_ember_spirit_0_debuff") and (not b:HasModifier("modifier_ember_spirit_0_debuff"))
		end)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_caster.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hParent, PATTACH_CUSTOMORIGIN_FOLLOW, nil, hParent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlForward(iParticleID, 1, hParent:GetForwardVector())
		self:AddParticle(iParticleID, false, false, -1, false, false)
		self:StartIntervalThink(self.interval)
	end
end
function modifier_ember_spirit_1:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()
		hParent:RemoveNoDraw()
	end
end
function modifier_ember_spirit_1:OnIntervalThink()
	if IsServer() then
		local hAbility = self:GetAbility()
		while #self.tTargets > 0 do
			local hUnit = self.tTargets[1]
			if not IsValid(hUnit) or not hUnit:IsAlive() then
				table.remove(self.tTargets, 1)
			else
				if not hUnit:HasModifier("modifier_ember_spirit_0_debuff") then
					self.count = self.count - 1
				else
					if TableFindKey(self.tExtraTargets, hUnit) == nil then
						table.insert(self.tExtraTargets, hUnit)
					else
						self.count = self.count - 1
					end
				end
				hAbility:SleightOfFist(hUnit)
				break
			end
		end
		if self.count <= 0 or #self.tTargets <= 0 then
			self:Destroy()
		end
	end
end
function modifier_ember_spirit_1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL = 1,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL = 1,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE = 1,
	}
end
function modifier_ember_spirit_1:GetModifierPreAttack_BonusDamage()
	return self.flDamage
end
function modifier_ember_spirit_1:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		-- [MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
	}
end