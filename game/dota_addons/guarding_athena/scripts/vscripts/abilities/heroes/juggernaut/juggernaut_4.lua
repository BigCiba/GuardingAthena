LinkLuaModifier( "modifier_juggernaut_4", "abilities/heroes/juggernaut/juggernaut_4.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_juggernaut_4_buff", "abilities/heroes/juggernaut/juggernaut_4.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if juggernaut_4 == nil then
	juggernaut_4 = class({})
end
function juggernaut_4:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function juggernaut_4:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local duration = self:GetSpecialValueFor("duration")
	hCaster:AddNewModifier(hCaster, self, "modifier_juggernaut_4", {duration = duration, vPosition = vPosition})
end
---------------------------------------------------------------------
--Modifiers
if modifier_juggernaut_4 == nil then
	modifier_juggernaut_4 = class({}, nil, ModifierBasic)
end
function modifier_juggernaut_4:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.interval = self:GetAbilitySpecialValueFor("interval")
	self.damage = self:GetAbilitySpecialValueFor("damage")
	self.buff_duration = self:GetAbilitySpecialValueFor("buff_duration")
	if IsServer() then
		self.vPosition = StringToVector(params.vPosition)
		self:StartIntervalThink(self.interval)
		self:OnIntervalThink()
	end
end
function modifier_juggernaut_4:OnDestroy()
	if IsServer() then
		FindClearSpaceForUnit(self:GetParent(), self.vPosition, true)
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_juggernaut_4_buff", {duration = self.buff_duration})
		self:GetParent():EmitSound("Hero_Juggernaut.ArcanaTrigger")
	end
end
function modifier_juggernaut_4:OnIntervalThink()
	local hParent = self:GetParent()
	local tTargets = FindUnitsInRadiusWithAbility(hParent, self.vPosition, self.radius, self:GetAbility())
	local vRandom = RandomVector(RandomInt(300, self.radius))
	local vStart = self.vPosition + vRandom
	local vEnd = self.vPosition + Rotation2D(vRandom, math.rad(RandomInt(120, 240)))
	local iParticleID = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_omni_slash_tgt_serrakura.vpcf", PATTACH_ABSORIGIN, hParent)
	ParticleManager:SetParticleControl( iParticleID, 0, vStart)
	ParticleManager:SetParticleControl( iParticleID, 1, vEnd + Vector(0,0,50))
	local iParticleID = ParticleManager:CreateParticle("particles/heroes/juggernaut/phantom_sword_dance_a.vpcf", PATTACH_ABSORIGIN, hParent)
	ParticleManager:SetParticleControl( iParticleID, 0, vStart)
	ParticleManager:SetParticleControl( iParticleID, 2, vEnd + Vector(0,0,50))
	local hTarget = RandomValue(tTargets)
	if IsValid(hTarget) then
		hParent:SetAbsOrigin(hTarget:GetAbsOrigin())
		hParent:PerformAttack(hTarget, true, true, true, false, false, false, true)
	else
		hParent:EmitSound("Hero_Juggernaut.Attack")
	end
	hParent:SetAbsOrigin(vEnd)
	hParent:SetForwardVector((vEnd - vStart):Normalized())
end
function modifier_juggernaut_4:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL
	}
end
function modifier_juggernaut_4:CheckState()
	return {
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP_FOR_ENEMIES] = true,
	}
end
function modifier_juggernaut_4:GetAbsoluteNoDamageMagical()
	return 1
end
function modifier_juggernaut_4:GetAbsoluteNoDamagePhysical()
	return 1
end
function modifier_juggernaut_4:GetAbsoluteNoDamagePure()
	return 1
end
function modifier_juggernaut_4:GetOverrideAnimation()
	return ACT_DOTA_OVERRIDE_ABILITY_4
end
function modifier_juggernaut_4:GetModifierProcAttack_BonusDamage_Physical(params)
	if params.target then
		return self.damage * self:GetParent():GetAverageTrueAttackDamage(params.target)
	end
end
---------------------------------------------------------------------
if modifier_juggernaut_4_buff == nil then
	modifier_juggernaut_4_buff = class({}, nil, ModifierBasic)
end
function modifier_juggernaut_4_buff:OnCreated(params)
	self.damage = self:GetAbilitySpecialValueFor("damage")
	if IsClient() then
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_trigger.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_juggernaut_4_buff:CheckState()
	return {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
	}
end
function modifier_juggernaut_4_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
		MODIFIER_PROPERTY_PROCATTACK_BONUS_DAMAGE_PHYSICAL
	}
end
function modifier_juggernaut_4_buff:GetAbsoluteNoDamageMagical()
	return 1
end
function modifier_juggernaut_4_buff:GetAbsoluteNoDamagePhysical()
	return 1
end
function modifier_juggernaut_4_buff:GetAbsoluteNoDamagePure()
	return 1
end
function modifier_juggernaut_4_buff:GetModifierProcAttack_BonusDamage_Physical(params)
	if params.target then
		return self.damage * self:GetParent():GetAverageTrueAttackDamage(params.target)
	end
end