ModifierBasic = class({})

if ModifierBasic == nil then
	ModifierBasic = class({})

	--封装OnCreated等到子类同函数
	-- local _class = class
	-- function class(...)
	-- 	local c = _class(...)
	-- 	if instanceof(c, ModifierBasic) then
	-- 		getmetatable(c).__newindex = function(...)
	-- 			return c._newindex(...)
	-- 		end
	-- 	end
	-- 	return c
	-- end
	-- function ModifierBasic._newindex(t, k, v)
	-- 	if 'OnCreated' == k or 'OnRefresh' == k or 'OnDestroy' == k then
	-- 		rawset(t, k, function(...)
	-- 			local res = v(...)
	-- 			ModifierBasic[k](...)
	-- 			return res
	-- 		end)
	-- 	else
	-- 		rawset(t, k, v)
	-- 	end
	-- end
end
function ModifierBasic:IsHidden()
	return false
end
function ModifierBasic:IsDebuff()
	return false
end
function ModifierBasic:IsPurgable()
	return false
end
function ModifierBasic:IsPurgeException()
	return false
end
function ModifierBasic:IsStunDebuff()
	return false
end
function ModifierBasic:IsHexDebuff()
	return false
end
function ModifierBasic:AllowIllusionDuplicate()
	return false
end
---------------------------------------------------------------------
ModifierItemBasic = class({})

if ModifierItemBasic == nil then
	ModifierItemBasic = class({})
end
function ModifierItemBasic:IsHidden()
	return true
end
function ModifierItemBasic:IsDebuff()
	return false
end
function ModifierItemBasic:IsPurgable()
	return false
end
function ModifierItemBasic:IsPurgeException()
	return false
end
function ModifierItemBasic:IsStunDebuff()
	return false
end
function ModifierItemBasic:IsHexDebuff()
	return false
end
function ModifierItemBasic:AllowIllusionDuplicate()
	return false
end
function ModifierItemBasic:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
---------------------------------------------------------------------
ModifierDebuff = class({})

if ModifierDebuff == nil then
	ModifierDebuff = class({})
end
function ModifierDebuff:IsHidden()
	return false
end
function ModifierDebuff:IsDebuff()
	return true
end
function ModifierDebuff:IsPurgable()
	return true
end
function ModifierDebuff:IsPurgeException()
	return true
end
function ModifierDebuff:IsStunDebuff()
	return false
end
function ModifierDebuff:IsHexDebuff()
	return false
end
function ModifierDebuff:AllowIllusionDuplicate()
	return false
end
---------------------------------------------------------------------
ModifierPositiveBuff = class({})

if ModifierPositiveBuff == nil then
	ModifierPositiveBuff = class({})
end
function ModifierPositiveBuff:IsHidden()
	return false
end
function ModifierPositiveBuff:IsDebuff()
	return false
end
function ModifierPositiveBuff:IsPurgable()
	return true
end
function ModifierPositiveBuff:IsPurgeException()
	return true
end
function ModifierPositiveBuff:IsStunDebuff()
	return false
end
function ModifierPositiveBuff:IsHexDebuff()
	return false
end
function ModifierPositiveBuff:AllowIllusionDuplicate()
	return false
end
---------------------------------------------------------------------
ModifierHidden = class({})

if ModifierHidden == nil then
	ModifierHidden = class({})
end
function ModifierHidden:IsHidden()
	return true
end
function ModifierHidden:IsDebuff()
	return false
end
function ModifierHidden:IsPurgable()
	return false
end
function ModifierHidden:IsPurgeException()
	return false
end
function ModifierHidden:IsStunDebuff()
	return false
end
function ModifierHidden:IsHexDebuff()
	return false
end
function ModifierHidden:AllowIllusionDuplicate()
	return false
end
---------------------------------------------------------------------
ParticleModifier = class({})

if ParticleModifier == nil then
	ParticleModifier = class({})
end
function ParticleModifier:IsHidden()
	return true
end
function ParticleModifier:IsDebuff()
	return false
end
function ParticleModifier:IsPurgable()
	return false
end
function ParticleModifier:IsPurgeException()
	return false
end
function ParticleModifier:IsStunDebuff()
	return false
end
function ParticleModifier:AllowIllusionDuplicate()
	return false
end
function ParticleModifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

---------------------------------------------------------------------
ModifierThinker = class({})

if ModifierThinker == nil then
	ModifierThinker = class({})
end
function ModifierThinker:IsHidden()
	return true
end
function ModifierThinker:IsDebuff()
	return false
end
function ModifierThinker:IsPurgable()
	return false
end
function ModifierThinker:IsPurgeException()
	return false
end
function ModifierThinker:IsStunDebuff()
	return false
end
function ModifierThinker:AllowIllusionDuplicate()
	return false
end
function ModifierThinker:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
function ModifierThinker:OnDestroy()
	if IsServer() then
		if IsValid(self:GetParent()) then
			UTIL_Remove(self:GetParent())
			-- self:GetParent():RemoveSelf()
		end
	end
end
function ModifierThinker:CheckState()
	return {
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true
	}
end
---------------------------------------------------------------------
VerticalMotionModifier = class({})

if VerticalMotionModifier == nil then
	VerticalMotionModifier = class({})
end
function VerticalMotionModifier:IsHidden()
	return true
end
function VerticalMotionModifier:IsDebuff()
	return false
end
function VerticalMotionModifier:IsPurgable()
	return false
end
function VerticalMotionModifier:IsPurgeException()
	return false
end
function VerticalMotionModifier:IsStunDebuff()
	return false
end
function VerticalMotionModifier:AllowIllusionDuplicate()
	return false
end
---------------------------------------------------------------------
HorizontalMotionModifier = class({})

if HorizontalMotionModifier == nil then
	HorizontalMotionModifier = class({})
end
function HorizontalMotionModifier:IsHidden()
	return true
end
function HorizontalMotionModifier:IsDebuff()
	return false
end
function HorizontalMotionModifier:IsPurgable()
	return false
end
function HorizontalMotionModifier:IsPurgeException()
	return false
end
function HorizontalMotionModifier:IsStunDebuff()
	return false
end
function HorizontalMotionModifier:AllowIllusionDuplicate()
	return false
end
---------------------------------------------------------------------
BothMotionModifier = class({})

if BothMotionModifier == nil then
	BothMotionModifier = class({})
end
function BothMotionModifier:IsHidden()
	return true
end
function BothMotionModifier:IsDebuff()
	return false
end
function BothMotionModifier:IsPurgable()
	return false
end
function BothMotionModifier:IsPurgeException()
	return false
end
function BothMotionModifier:IsStunDebuff()
	return false
end
function BothMotionModifier:AllowIllusionDuplicate()
	return false
end
---------------------------------------------------------------------
AssetModifier = class({})

if AssetModifier == nil then
	AssetModifier = class({})
end
function AssetModifier:IsHidden()
	return true
end
function AssetModifier:IsDebuff()
	return false
end
function AssetModifier:IsPurgable()
	return false
end
function AssetModifier:IsPurgeException()
	return false
end
function AssetModifier:IsStunDebuff()
	return false
end
function AssetModifier:IsHexDebuff()
	return false
end
function AssetModifier:AllowIllusionDuplicate()
	return false
end
function AssetModifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end
function AssetModifier:Init()
	local hParent = self:GetParent()
	hParent.GetSkinName = function(hParent)
		return string.sub(self:GetName(), 10, -1)
	end
end
function AssetModifier:OnCreated(params)
	self:Init()
end
---------------------------------------------------------------------
ParticleModifier = class({})

if ParticleModifier == nil then
	ParticleModifier = class({})
end
function ParticleModifier:IsHidden()
	return true
end
function ParticleModifier:IsDebuff()
	return false
end
function ParticleModifier:IsPurgable()
	return false
end
function ParticleModifier:IsPurgeException()
	return false
end
function ParticleModifier:IsStunDebuff()
	return false
end
function ParticleModifier:IsHexDebuff()
	return false
end
function ParticleModifier:AllowIllusionDuplicate()
	return false
end
function ParticleModifier:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end
----------------------------------------物品基类----------------------------------------
if item_base == nil then
	item_base = class({})
end
function item_base:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
function item_base:OnCreated(params)
	self.auto_attack				= self:GetAbilitySpecialValueFor("auto_attack")
	self.auto_attackspeed			= self:GetAbilitySpecialValueFor("auto_attackspeed")
	self.auto_movespeed				= self:GetAbilitySpecialValueFor("auto_movespeed")
	self.auto_health				= self:GetAbilitySpecialValueFor("auto_health")
	self.auto_mana					= self:GetAbilitySpecialValueFor("auto_mana")
	self.auto_health_regen			= self:GetAbilitySpecialValueFor("auto_health_regen")
	self.auto_mana_regen			= self:GetAbilitySpecialValueFor("auto_mana_regen")
	self.auto_physical_armor		= self:GetAbilitySpecialValueFor("auto_physical_armor")
	self.auto_magical_resistance	= self:GetAbilitySpecialValueFor("auto_magical_resistance")
	self.auto_evade					= self:GetAbilitySpecialValueFor("auto_evade")
	self.auto_cast_range			= self:GetAbilitySpecialValueFor("auto_cast_range")
	self.auto_projectile_speed		= self:GetAbilitySpecialValueFor("auto_projectile_speed")
	self.auto_cooldown_reduce		= self:GetAbilitySpecialValueFor("auto_cooldown_reduce")
	self.auto_spell_amp				= self:GetAbilitySpecialValueFor("auto_spell_amp")
	self.auto_str					= self:GetAbilitySpecialValueFor("auto_str")
	self.auto_agi					= self:GetAbilitySpecialValueFor("auto_agi")
	self.auto_int					= self:GetAbilitySpecialValueFor("auto_int")
	self.auto_all					= self:GetAbilitySpecialValueFor("auto_all")
end
function item_base:OnRefresh(params)
	self.auto_attack				= self:GetAbilitySpecialValueFor("auto_attack")
	self.auto_attackspeed			= self:GetAbilitySpecialValueFor("auto_attackspeed")
	self.auto_movespeed				= self:GetAbilitySpecialValueFor("auto_movespeed")
	self.auto_health				= self:GetAbilitySpecialValueFor("auto_health")
	self.auto_mana					= self:GetAbilitySpecialValueFor("auto_mana")
	self.auto_health_regen			= self:GetAbilitySpecialValueFor("auto_health_regen")
	self.auto_mana_regen			= self:GetAbilitySpecialValueFor("auto_mana_regen")
	self.auto_physical_armor		= self:GetAbilitySpecialValueFor("auto_physical_armor")
	self.auto_magical_resistance	= self:GetAbilitySpecialValueFor("auto_magical_resistance")
	self.auto_evade					= self:GetAbilitySpecialValueFor("auto_evade")
	self.auto_cast_range			= self:GetAbilitySpecialValueFor("auto_cast_range")
	self.auto_cooldown_reduce		= self:GetAbilitySpecialValueFor("auto_cooldown_reduce")
	self.auto_spell_amp				= self:GetAbilitySpecialValueFor("auto_spell_amp")
	self.auto_str					= self:GetAbilitySpecialValueFor("auto_str")
	self.auto_agi					= self:GetAbilitySpecialValueFor("auto_agi")
	self.auto_int					= self:GetAbilitySpecialValueFor("auto_int")
	self.auto_all					= self:GetAbilitySpecialValueFor("auto_all")
end
function item_base:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE = self.auto_attack or 0,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT = self.auto_attackspeed or 0,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT = self.auto_movespeed or 0,
		MODIFIER_PROPERTY_HEALTH_BONUS = self.auto_health or 0,
		MODIFIER_PROPERTY_MANA_BONUS = self.auto_mana or 0,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT = self.auto_health_regen or 0,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT = self.auto_mana_regen or 0,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS = self.auto_physical_armor or 0,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS = self.auto_magical_resistance or 0,
		MODIFIER_PROPERTY_EVASION_CONSTANT = self.auto_evade or 0,
		MODIFIER_PROPERTY_CAST_RANGE_BONUS = self.auto_cast_range or 0,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE = self.auto_cooldown_reduce or 0,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE = self.auto_spell_amp or 0,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS = (self.auto_str or 0) + (self.auto_all or 0),
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS = (self.auto_agi or 0) + (self.auto_all or 0),
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS = (self.auto_int or 0) + (self.auto_all or 0),
	}
end
function item_base:EDeclareFunctions()
	return {
		-- EOM_MODIFIER_PROPERTY_MANA_BONUS = self.auto_mana,
		-- EOM_MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT = self.auto_health_regen,
		-- EOM_MODIFIER_PROPERTY_MANA_REGEN_CONSTANT = self.auto_mana_regen,
		-- EOM_MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		-- EOM_MODIFIER_PROPERTY_MAGICAL_ARMOR_BONUS,
		EOM_MODIFIER_PROPERTY_EVASION_CONSTANT,
		EOM_MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
	}
end
-- function item_base:EOM_GetModifierPhysicalArmorBonus()
-- 	return self.auto_physical_armor
-- end
-- function item_base:EOM_GetModifierMagicalArmorBonus()
-- 	return self.auto_magical_resistance
-- end
-- function item_base:EOM_GetModifierEvasion_Constant()
-- 	return self.auto_evade
-- end
-- function item_base:EOM_GetModifierPercentageCooldown()
-- 	return self.auto_cooldown_reduce
-- end