LinkLuaModifier("modifier_chaos_plate", "abilities/items/artifact/item_chaos_plate.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaos_plate_shield", "abilities/items/artifact/item_chaos_plate.lua", LUA_MODIFIER_MOTION_NONE)
-- Abilities
if item_chaos_plate == nil then
	item_chaos_plate = class({})
end
function item_chaos_plate:GetIntrinsicModifierName()
	return "modifier_chaos_plate"
end
---------------------------------------------------------------------
-- Modifier
if modifier_chaos_plate == nil then
	modifier_chaos_plate = class({})
end
function modifier_chaos_plate:IsHidden()
	return true
end
function modifier_chaos_plate:IsDebuff()
	return false
end
function modifier_chaos_plate:IsPurgable()
	return false
end
function modifier_chaos_plate:IsPurgeException()
	return false
end
function modifier_chaos_plate:IsStunDebuff()
	return false
end
function modifier_chaos_plate:AllowIllusionDuplicate()
	return false
end
function modifier_chaos_plate:OnCreated(params)
	self.attribute = self:GetAbility():GetSpecialValueFor("attribute")
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
	self.damage_reduce = self:GetAbility():GetSpecialValueFor("damage_reduce")
	self.shield = self:GetAbility():GetSpecialValueFor("shield")
	self.health_bonus = self:GetAbility():GetSpecialValueFor("health_bonus")
	self.interval = self:GetAbility():GetSpecialValueFor("interval")
	if IsServer() then
		self:StartIntervalThink(self.interval)
		self:OnIntervalThink()
	end
end
function modifier_chaos_plate:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveModifierByName("modifier_chaos_plate_shield")
	end
end
function modifier_chaos_plate:OnIntervalThink()
	if IsServer() then
		self:GetParent():Purge(false, true, false, true, true)
		self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_chaos_plate_shield", nil)
	end
end
function modifier_chaos_plate:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_REINCARNATION,
	}
end
function modifier_chaos_plate:GetModifierHealthBonus()
	return self.health_bonus
end
function modifier_chaos_plate:GetModifierBonusStats_Strength()
	return self.attribute
end
function modifier_chaos_plate:GetModifierBonusStats_Agility()
	return self.attribute
end
function modifier_chaos_plate:GetModifierBonusStats_Intellect()
	return self.attribute
end
function modifier_chaos_plate:GetModifierIncomingDamage_Percentage()
	return self.damage_reduce
end
function modifier_chaos_plate:ReincarnateTime()
	if IsServer() then
		if self:GetAbility():IsCooldownReady() then
			self:GetAbility():UseResources(true, true, true)
			self:GetParent():RefreshAbilities()
			local iParticleID = ParticleManager:CreateParticle("particles/items_fx/aegis_respawn.vpcf", PATTACH_ABSORIGIN, self:GetParent())
			ParticleManager:ReleaseParticleIndex(iParticleID)
			return 1
		end
	end
end
---------------------------------------------------------------------
if modifier_chaos_plate_shield == nil then
	modifier_chaos_plate_shield = class({})
end
function modifier_chaos_plate_shield:IsHidden()
	return false
end
function modifier_chaos_plate_shield:IsDebuff()
	return false
end
function modifier_chaos_plate_shield:IsPurgable()
	return false
end
function modifier_chaos_plate_shield:IsPurgeException()
	return false
end
function modifier_chaos_plate_shield:IsStunDebuff()
	return false
end
function modifier_chaos_plate_shield:AllowIllusionDuplicate()
	return false
end
function modifier_chaos_plate_shield:OnCreated(params)
	self.shield = self:GetAbility():GetSpecialValueFor("shield")
	local hParent = self:GetParent()
	if IsServer() then
		self.flShieldHealth = hParent:GetMaxHealth() * self.shield * 0.01
	else
		-- particle
		local iParticleID = ParticleManager:CreateParticle("particles/items/chaos_plate/chaos_plate_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_chaos_plate_shield:OnRefresh(params)
	self.shield = self:GetAbility():GetSpecialValueFor("shield")
	if IsServer() then
		self.flShieldHealth = self:GetParent():GetMaxHealth() * self.shield * 0.01
	end
end
function modifier_chaos_plate_shield:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
	}
end
function modifier_chaos_plate_shield:GetModifierTotal_ConstantBlock(params)
	if IsServer() then
		local flBlock = self.flShieldHealth
		self.flShieldHealth = self.flShieldHealth - params.damage
		if self.flShieldHealth < 0 then
			self:Destroy()
		end
		return flBlock
	end
end