LinkLuaModifier( "modifier_rubick_2_root", "abilities/heroes/rubick/rubick_2.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_rubick_2_shield", "abilities/heroes/rubick/rubick_2.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if rubick_2 == nil then
	rubick_2 = class({})
end
function rubick_2:GetAbilityTextureName()
	return AssetModifiers:GetAbilityTextureReplacement(self:GetAbilityName(), self:GetCaster())
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
	local sParticleName = "particles/heroes/chronos_magic/teleport_open.vpcf"
	if hCaster.gift then
		sParticleName = "particles/heroes/chronos_magic/teleport_open_gold.vpcf"
	end
	self.tParticleID = {}
	local iParticleID = ParticleManager:CreateParticle(sParticleName, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, hCaster:GetAbsOrigin())
	table.insert(self.tParticleID, iParticleID)
	local iParticleID = ParticleManager:CreateParticle(sParticleName, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
	table.insert(self.tParticleID, iParticleID)
	-- sound
	hCaster:EmitSound("Hero_ObsidianDestroyer.AstralImprisonment.End")
	-- 动作
	hCaster:ForcePlayActivityOnce(ACT_DOTA_CAST_ABILITY_4)
	return true
end
function rubick_2:OnAbilityPhaseInterrupted()
	self:GetCaster():RemoveGesture(ACT_DOTA_CAST_ABILITY_4)

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
	hCaster:AddNewModifier(hCaster, self, "modifier_rubick_2_root", {duration = flDelay})
	hCaster:AddNewModifier(hCaster, self, "modifier_rubick_2_shield", {duration = shield_duration})
	hCaster:GameTimer(flDelay, function ()
		-- 伤害
		local tTargets = FindUnitsInRadiusWithAbility(hCaster, vCasterLoc, flRadius, self)
		hCaster:DealDamage(tTargets, self, flDamage)
		local tTargets = FindUnitsInRadiusWithAbility(hCaster, vPosition, flRadius, self)
		hCaster:DealDamage(tTargets, self, flDamage)
		-- 传送
		FindClearSpaceForUnit(hCaster, vPosition, true)
		-- 天赋
		hCaster:SpaceRift(vCasterLoc + RandomVector(RandomInt(0, flRadius)))
		hCaster:SpaceRift(vPosition + RandomVector(RandomInt(0, flRadius)))
		-- particle
		local iParticleID = ParticleManager:CreateParticle("particles/heroes/chronos_magic/teleport_startleague.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, vCasterLoc)
		ParticleManager:ReleaseParticleIndex(iParticleID)
		local iParticleID = ParticleManager:CreateParticle("particles/heroes/chronos_magic/teleport_endflash_nexon_hero_cp_2014.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
		ParticleManager:ReleaseParticleIndex(iParticleID)
		-- sound
		hCaster:EmitSound("Hero_Furion.Teleport_Disappear")
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
	local hParent = self:GetParent()
	if IsServer() then
		self.flShieldHealth = hParent:GetIntellect() * self.shield_factor
	else
		-- particle
		local iParticleID = ParticleManager:CreateParticle(AssetModifiers:GetParticleReplacement("particles/units/heroes/hero_rubick/rubick_2_shield.vpcf", hParent), PATTACH_ABSORIGIN_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_rubick_2_shield:OnRefresh(params)
	self.shield_factor = self:GetAbilitySpecialValueFor("shield_factor")
	if IsServer() then
		self.flShieldHealth = self.flShieldHealth + self:GetParent():GetIntellect() * self.shield_factor
	end
end
function modifier_rubick_2_shield:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
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