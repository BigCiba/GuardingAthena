ember_spirit_0 = class({})
function ember_spirit_0:Spawn()
	if IsServer() then
		local hCaster = self:GetCaster()
		hCaster.ApplyEmber = function(hCaster, hTarget, iStackCount)
			iStackCount = (iStackCount or 1) + hCaster:GetBonusMarkStackCount()
			local duration = self:GetSpecialValueFor("duration")
			hTarget:AddNewModifier(hCaster, self, "modifier_ember_spirit_0_debuff", { duration = duration, iStackCount = iStackCount })
		end
		self.bPlaySound = false
		hCaster.PlaySound = function(hCaster, vPosition)
			if self.bPlaySound == false then
				self.bPlaySound = true
				local iCount = 6
				hCaster:GameTimer(0, function()
					EmitSoundOnLocationWithCaster(vPosition, "Hero_EmberSpirit.SleightOfFist.Damage", hCaster)
					if iCount > 0 then
						iCount = iCount - 1
						return FrameTime()
					else
						self.bPlaySound = false
					end
				end)
			end
		end
		self.tEmberTargets = {}
	end
end
function ember_spirit_0:OnSpellStart()
	local hCaster = self:GetCaster()
	for _, hUnit in ipairs(self.tEmberTargets) do
		if IsValid(hUnit) then
			hUnit:RemoveModifierByName("modifier_ember_spirit_0_debuff")
		end
	end
	for i = #self.tEmberTargets, 1, -1 do
		if IsValid(self.tEmberTargets[i]) then
			self.tEmberTargets[i]:RemoveModifierByName("modifier_ember_spirit_0_debuff")
			table.remove(self.tEmberTargets, i)
		end
	end
end
function ember_spirit_0:GetIntrinsicModifierName()
	return "modifier_ember_spirit_0"
end
---------------------------------------------------------------------
--Modifiers
modifier_ember_spirit_0 = eom_modifier({
	Name = "modifier_ember_spirit_0",
	IsHidden = true,
	IsDebuff = false,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_ember_spirit_0:GetAbilitySpecialValue()
	self.damage = self:GetAbilitySpecialValueFor("damage")
end
function modifier_ember_spirit_0:OnCreated(params)
	if IsServer() then
	end
end
function modifier_ember_spirit_0:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_ember_spirit_0:OnDestroy()
	if IsServer() then
	end
end
function modifier_ember_spirit_0:DeclareFunctions()
	return {
	}
end
function modifier_ember_spirit_0:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_LANDED = { self:GetParent() }
	}
end
function modifier_ember_spirit_0:OnAttackLanded(params)
	if IsServer() then
		self:GetParent():ApplyEmber(params.target)
	end
end
---------------------------------------------------------------------
modifier_ember_spirit_0_debuff = eom_modifier({
	Name = "modifier_ember_spirit_0_debuff",
	IsHidden = false,
	IsDebuff = true,
	IsPurgable = false,
	IsPurgeException = false,
	IsStunDebuff = false,
	AllowIllusionDuplicate = false,
})
function modifier_ember_spirit_0_debuff:GetAbilitySpecialValue()
	self.radius = self:GetAbilitySpecialValueFor("radius")
end
function modifier_ember_spirit_0_debuff:OnCreated(params)
	if IsServer() then
		table.insert(self:GetAbility().tEmberTargets, self:GetParent())
		self:IncrementStackCount(params.iStackCount)
		if self:GetCaster():GetScepterLevel() >= 3 then
			self:StartIntervalThink(1)
		end
	else
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_targetted_marker.vpcf", PATTACH_OVERHEAD_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, true)
	end
end
function modifier_ember_spirit_0_debuff:OnRefresh(params)
	if IsServer() then
		self:IncrementStackCount(params.iStackCount)
	end
end
function modifier_ember_spirit_0_debuff:OnIntervalThink()
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	hCaster:DealDamage(hParent, hAbility, self:GetStackCount() * hCaster:GetAgility(), DAMAGE_TYPE_MAGICAL)
end
function modifier_ember_spirit_0_debuff:OnDestroy()
	if IsServer() then
		ArrayRemove(self:GetAbility().tEmberTargets, self:GetParent())
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()
		local hAbility = self:GetAbility()
		local flDamage = self:GetStackCount() * hCaster:GetAgility()
		local tTargets = FindUnitsInRadiusWithAbility(hCaster, hParent:GetAbsOrigin(), self.radius, hAbility)
		hCaster:DealDamage(tTargets, hAbility, flDamage)
		local iParticleID = ParticleManager:CreateParticle("particles/skills/fire_spirit_0_1.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
		hCaster:PlaySound(hParent:GetAbsOrigin())
	end
end