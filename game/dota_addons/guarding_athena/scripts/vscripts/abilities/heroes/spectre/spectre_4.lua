LinkLuaModifier( "modifier_spectre_4_lock", "abilities/heroes/spectre/spectre_4.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_spectre_4_debuff", "abilities/heroes/spectre/spectre_4.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_spectre_4_silence", "abilities/heroes/spectre/spectre_4.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if spectre_4 == nil then
	spectre_4 = class({})
end
function spectre_4:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	hTarget:AddNewModifier(hCaster, self, "modifier_spectre_4_lock", {duration = self:GetSpecialValueFor("stun_duration")})
	hTarget:AddNewModifier(hCaster, self, "modifier_spectre_4_debuff", {duration = self:GetSpecialValueFor("duration")})
	-- 沉默
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, hTarget:GetAbsOrigin(), self:GetSpecialValueFor("radius"), self)
	for _, hUnit in pairs(tTargets) do
		hUnit:AddNewModifier(hCaster, self, "modifier_spectre_4_silence", {duration = 5})
	end
	-- sound
	hCaster:EmitSound("Hero_Necrolyte.ReapersScythe.Cast")
	hTarget:EmitSound("Hero_Necrolyte.ReapersScythe.Target")
end
---------------------------------------------------------------------
--Modifiers
if modifier_spectre_4_lock == nil then
	modifier_spectre_4_lock = class({}, nil, ModifierDebuff)
end
function modifier_spectre_4_lock:IsPurgable()
	return false
end
function modifier_spectre_4_lock:IsPurgeException()
	return false
end
function modifier_spectre_4_lock:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_PERMANENT
end
function modifier_spectre_4_lock:OnCreated(params)
	self.damage_deepen = self:GetAbilitySpecialValueFor("damage_deepen")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.damage = self:GetAbilitySpecialValueFor("damage")
	self.max_bonus_damage = self:GetAbilitySpecialValueFor("max_bonus_damage")
	self.damage_count = self:GetAbilitySpecialValueFor("damage_count")
	self.damage_time_point = self:GetAbilitySpecialValueFor("damage_time_point")
	self.MagicArmor = self:GetParent():GetBaseMagicalResistanceValue()
	self:StartIntervalThink(self.damage_time_point)
	if IsServer() then
	else
		local hParent = self:GetParent()
		-- 锁链
		local iParticleID = ParticleManager:CreateParticle("particles/heroes/spectre/spectre_4_lock.vpcf", PATTACH_CUSTOMORIGIN, hParent)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
		-- 烟雾
		local iParticleID = ParticleManager:CreateParticle("particles/heroes/spectre/spectre_4_somke.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(600,600,600))
		self:AddParticle(iParticleID, false, false, -1, false, false)
		-- 死神虚影
		for i = 1, self.damage_count do
			local iParticleID = ParticleManager:CreateParticle("particles/heroes/spectre/spectre_4.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
			ParticleManager:SetParticleControl(iParticleID, 1, hParent:GetAbsOrigin())
			ParticleManager:SetParticleControlForward(iParticleID, 0, Rotation2D(Vector(0, 1, 0), math.rad(90 * i)))
			ParticleManager:SetParticleControlForward(iParticleID, 1, Rotation2D(Vector(0, 1, 0), math.rad(90 * i)))
			self:AddParticle(iParticleID, false, false, -1, false, false)
			local iParticleID = ParticleManager:CreateParticle("particles/heroes/spectre/spectre_4_impact.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(iParticleID, 0, Rotation2D(Vector(0, 600, 0), math.rad(90 * i)))
			ParticleManager:SetParticleControl(iParticleID, 1, Rotation2D(Vector(0, 600, 0), math.rad(90 * i)))
			self:AddParticle(iParticleID, false, false, -1, false, false)
		end
	end
end
function modifier_spectre_4_lock:OnIntervalThink()
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	if IsServer() then
		local flLosePct = math.min((100 - hParent:GetHealthPercent()), self.max_bonus_damage)
		local flBonusDamage = flLosePct * hParent:GetMaxHealth() * 0.01
		local flDamage = self.damage * hCaster:GetStrength() + flBonusDamage / self.damage_count
		local tTargets = FindUnitsInRadiusWithAbility(hCaster, hParent:GetAbsOrigin(), self.radius, self:GetAbility())
		for i = 1, self.damage_count do
			hCaster:DealDamage(tTargets, self:GetAbility(), flDamage)
		end
	else
		-- 地面特效
		local iParticleID = ParticleManager:CreateParticle("particles/heroes/spectre/spectre_4_explode.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(600,600,600))
		ParticleManager:ReleaseParticleIndex(iParticleID)
		-- self:AddParticle(iParticleID, false, false, -1, false, false)
		-- 命中特效
		local iParticleID = ParticleManager:CreateParticle("particles/heroes/spectre/spectre_4_impact_f.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
		ParticleManager:SetParticleControl(iParticleID, 1, hParent:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(iParticleID)
		-- self:AddParticle(iParticleID, false, false, -1, false, false)
	end
	self:StartIntervalThink(-1)
end
function modifier_spectre_4_lock:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BASE_PERCENTAGE,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_DIRECT_MODIFICATION,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end
function modifier_spectre_4_lock:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_PASSIVES_DISABLED] = true,
	}
end
function modifier_spectre_4_lock:GetModifierPhysicalArmorBase_Percentage()
	return 0
end
function modifier_spectre_4_lock:GetModifierMagicalResistanceDirectModification()
	return -self.MagicArmor
end
function modifier_spectre_4_lock:GetModifierIncomingDamage_Percentage()
	return self.damage_deepen
end
---------------------------------------------------------------------
if modifier_spectre_4_debuff == nil then
	modifier_spectre_4_debuff = class({}, nil, ModifierDebuff)
end
function modifier_spectre_4_debuff:IsPurgable()
	return false
end
function modifier_spectre_4_debuff:IsPurgeException()
	return false
end
function modifier_spectre_4_debuff:OnCreated(params)
	self.soul_loss = self:GetAbilitySpecialValueFor("soul_loss")
end
function modifier_spectre_4_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE
	}
end
function modifier_spectre_4_debuff:GetModifierTotalDamageOutgoing_Percentage()
	return -self.soul_loss
end
function modifier_spectre_4_debuff:GetModifierExtraHealthPercentage()
	return -self.soul_loss
end
---------------------------------------------------------------------
if modifier_spectre_4_silence == nil then
	modifier_spectre_4_silence = class({}, nil, ModifierDebuff)
end
function modifier_spectre_4_silence:CheckState()
	return {
		[MODIFIER_STATE_SILENCED] = true,
	}
end