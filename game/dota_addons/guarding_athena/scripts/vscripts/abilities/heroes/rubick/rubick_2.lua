LinkLuaModifier("modifier_rubick_2_root", "abilities/heroes/rubick/rubick_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_rubick_2_shield", "abilities/heroes/rubick/rubick_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if rubick_2 == nil then
	rubick_2 = class({})
end
function rubick_2:GetAbilityTextureName()
	return AssetModifiers:GetAbilityTextureReplacement(self:GetAbilityName(), self:GetCaster())
end
function rubick_2:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function rubick_2:GetCastRange(vLocation, hTarget)
	if self:GetCaster():GetScepterLevel() >= 2 then
		return self.BaseClass.GetCastRange(self, vLocation, hTarget) * self:GetSpecialValueFor("scepter_factor")
	end
	return self.BaseClass.GetCastRange(self, vLocation, hTarget)
end
function rubick_2:OnAbilityPhaseStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	self.tParticleID = {}
	local iParticleID = ParticleManager:CreateParticle(AssetModifiers:GetParticleReplacement("particles/heroes/chronos_magic/teleport_open.vpcf", hCaster), PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, hCaster:GetAbsOrigin())
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(200, 200, 1))
	table.insert(self.tParticleID, iParticleID)
	local iParticleID = ParticleManager:CreateParticle(AssetModifiers:GetParticleReplacement("particles/heroes/chronos_magic/teleport_open.vpcf", hCaster), PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(200, 200, 1))
	table.insert(self.tParticleID, iParticleID)
	-- sound
	hCaster:EmitSound(AssetModifiers:GetSoundReplacement("Hero_ObsidianDestroyer.AstralImprisonment.End", hCaster))
	-- 动作
	-- hCaster:ForcePlayActivityOnce(ACT_DOTA_CAST_ABILITY_4)
	hCaster:ClearActivityModifiers()
	hCaster:AddActivityModifier("void_spirit_resonant_pulse")
	return true
end
function rubick_2:OnAbilityPhaseInterrupted()
	-- self:GetCaster():RemoveGesture(ACT_DOTA_CAST_ABILITY_4)
	if self.tParticleID then
		for i, iParticleID in ipairs(self.tParticleID) do
			ParticleManager:DestroyParticle(iParticleID, false)
			ParticleManager:ReleaseParticleIndex(iParticleID)
		end
	end
	self.tParticleID = nil
end
function rubick_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local vCasterLoc = hCaster:GetAbsOrigin()
	local vPosition = self:GetCursorPosition()
	local flRadius = self:GetSpecialValueFor("radius")
	local shield_duration = self:GetSpecialValueFor("shield_duration")
	local flDelay = hCaster:GetScepterLevel() >= 2 and self:GetSpecialValueFor("scepter_delay") or self:GetSpecialValueFor("delay")
	local flDamage = self:GetSpecialValueFor("base_damage") + self:GetSpecialValueFor("damage") * hCaster:GetIntellect()
	flDamage = hCaster:GetScepterLevel() >= 2 and flDamage * 2 or flDamage
	hCaster:AddNewModifier(hCaster, self, "modifier_rubick_2_root", { duration = flDelay })
	hCaster:AddNewModifier(hCaster, self, "modifier_rubick_2_shield", { duration = shield_duration })
	hCaster:GameTimer(flDelay, function()
		-- 伤害
		local tTargets = FindUnitsInRadiusWithAbility(hCaster, vCasterLoc, flRadius, self)
		hCaster:DealDamage(tTargets, self, flDamage)
		local tTargets = FindUnitsInRadiusWithAbility(hCaster, vPosition, flRadius, self)
		hCaster:DealDamage(tTargets, self, flDamage)
		-- 传送
		FindClearSpaceForUnit(hCaster, vPosition, true)
		-- 动作
		hCaster:ForcePlayActivityOnce(ACT_DOTA_MK_SPRING_END)
		-- 天赋
		hCaster:SpaceRift(vCasterLoc + RandomVector(RandomInt(0, flRadius)))
		hCaster:SpaceRift(vPosition + RandomVector(RandomInt(0, flRadius)))
		-- particle
		local iParticleID = ParticleManager:CreateParticle(AssetModifiers:GetParticleReplacement("particles/heroes/chronos_magic/teleport_startleague.vpcf", hCaster), PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, vCasterLoc)
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(200, 200, 1))
		ParticleManager:ReleaseParticleIndex(iParticleID)
		local iParticleID = ParticleManager:CreateParticle(AssetModifiers:GetParticleReplacement("particles/heroes/chronos_magic/teleport_endflash_nexon_hero_cp_2014.vpcf", hCaster), PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(200, 200, 1))
		ParticleManager:ReleaseParticleIndex(iParticleID)
		-- sound
		hCaster:EmitSound(AssetModifiers:GetSoundReplacement("Hero_Furion.Teleport_Disappear", hCaster))
	end)
end
---------------------------------------------------------------------
--Modifiers
if modifier_rubick_2_root == nil then
	modifier_rubick_2_root = class({}, nil, ModifierHidden)
end
function modifier_rubick_2_root:CheckState()
	return {
		[MODIFIER_STATE_ROOTED] = true,
	}
end
---------------------------------------------------------------------
if modifier_rubick_2_shield == nil then
	modifier_rubick_2_shield = class({}, nil, ModifierPositiveBuff)
end
function modifier_rubick_2_shield:OnCreated(params)
	self.shield_factor = self:GetAbilitySpecialValueFor("shield_factor")
	self.cooldown_reduction = self:GetAbilitySpecialValueFor("cooldown_reduction")
	local hParent = self:GetParent()
	if IsServer() then
		self.flShieldHealth = hParent:GetIntellect() * self.shield_factor
	else
		-- particle
		local iParticleID = ParticleManager:CreateParticle(AssetModifiers:GetParticleReplacement("particles/units/heroes/hero_rubick/rubick_2_shield.vpcf", hParent), PATTACH_ABSORIGIN_FOLLOW, hParent)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_rubick_2_shield:OnRefresh(params)
	self.shield_factor = self:GetAbilitySpecialValueFor("shield_factor")
	self.cooldown_reduction = self:GetAbilitySpecialValueFor("cooldown_reduction")
	if IsServer() then
		self.flShieldHealth = self.flShieldHealth + self:GetParent():GetIntellect() * self.shield_factor
	end
end
function modifier_rubick_2_shield:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE
	}
end
function modifier_rubick_2_shield:GetModifierTotal_ConstantBlock(params)
	if IsServer() then
		local flBlock = self.flShieldHealth
		self.flShieldHealth = self.flShieldHealth - params.damage
		if self.flShieldHealth < 0 then
			self:Destroy()
		end
		return flBlock
	end
end
function modifier_rubick_2_shield:GetModifierPercentageCooldown()
	if self:GetParent().HasArcana then
		return self.cooldown_reduction
	end
end