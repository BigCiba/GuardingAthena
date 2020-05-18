LinkLuaModifier( "modifier_spectre_0", "abilities/heroes/spectre/spectre_0.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_spectre_0_show", "abilities/heroes/spectre/spectre_0.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if spectre_0 == nil then
	spectre_0 = class({})
end
function spectre_0:OnSpellStart()
	local hCaster = self:GetCaster()
	for i = #self.tIllusions, 1, -1 do
		self.tIllusions[i]:RemoveModifierByName("modifier_spectre_0_show")
	end
	self:StartCooldown(self:GetCooldown(self:GetLevel() - 1))
end
function spectre_0:GetIntrinsicModifierName()
	return "modifier_spectre_0"
end
---------------------------------------------------------------------
--Modifiers
if modifier_spectre_0 == nil then
	modifier_spectre_0 = class({}, nil, ModifierHidden)
end
function modifier_spectre_0:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end
function modifier_spectre_0:OnCreated(params)
	self.unit_limit = self:GetAbilitySpecialValueFor("unit_limit")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.health = self:GetAbilitySpecialValueFor("health")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	if IsServer() then
		local hParent = self:GetParent()
		local hAbility = self:GetAbility()
		hAbility.tIllusions = {}
	end
	AddModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, self:GetParent())
end
function modifier_spectre_0:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_spectre_0:OnDestroy()
	if IsServer() then
	end
	RemoveModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, self:GetParent())
end
function modifier_spectre_0:SummonIllusion()
	if #self:GetAbility().tIllusions < self.unit_limit then
		local hParent = self:GetParent()
		local hAbility = self:GetAbility()
		local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.radius, hAbility)
		local hTarget = RandomValue(tTargets)
		if IsValid(hTarget) then
			local vPosition = hTarget:GetAbsOrigin() + RandomVector(125)
			local hUnit = CreateUnitByName("spectre", vPosition, true, hParent, hParent, hParent:GetTeamNumber())
			hUnit:SetBaseMaxHealth(hParent:GetMaxHealth())
			hUnit:SetMaxHealth(hParent:GetMaxHealth())
			hUnit:SetHealth(hUnit:GetMaxHealth() * self.health * 0.01)
			hUnit:SetAbsOrigin(vPosition)
			hUnit:SetForwardVector((hTarget:GetAbsOrigin() - vPosition):Normalized())
			hUnit:AddNewModifier(hParent, hAbility, "modifier_spectre_0_show", {duration = self.duration})
			hUnit:AddAbility("spectre_2"):SetLevel(hParent:FindAbilityByName("spectre_2"):GetLevel())
			hUnit:AddAbility("spectre_3"):SetLevel(hParent:FindAbilityByName("spectre_3"):GetLevel())
			table.insert(hAbility.tIllusions, hUnit)
		end
	end
end
function modifier_spectre_0:OnAttackLanded(params)
	if IsServer() then
		if params.attacker == self:GetParent() then
			self:SummonIllusion()
		end
	end
end
---------------------------------------------------------------------
if modifier_spectre_0_show == nil then
	modifier_spectre_0_show = class({}, nil, ModifierHidden)
end
function modifier_spectre_0_show:OnCreated(params)
	self.attack_count = self:GetAbilitySpecialValueFor("attack_count")
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/heroes/spectre/spectre_2_illusion.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
	AddModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, self:GetParent())
end
function modifier_spectre_0_show:OnRemoved()
	if IsServer() then
		-- 伤害
		local hParent = self:GetParent()
		local hModifier = hParent:FindModifierByName("modifier_spectre_3")
		if IsValid(hModifier) then
			hModifier:OnTakeDamage({unit = hParent, damage = hParent:GetHealth()})
		end
		hParent:ForceKill(false)
		hParent:AddNoDraw()
		ArrayRemove(self:GetAbility().tIllusions, self:GetParent())
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_spectre/spectre_death.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
		ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(iParticleID)
	end
	RemoveModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, self:GetParent())
end
function modifier_spectre_0_show:CheckState()
	return {
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true
	}
end
function modifier_spectre_0_show:OnAttackLanded(params)
	if IsServer() then
		if params.attacker == self:GetParent() then
			if self.attack_count > 0 then
				self.attack_count = self.attack_count - 1
			end
			if self.attack_count <= 0 then
				self:Destroy()
			end
		end
	end
end