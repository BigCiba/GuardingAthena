LinkLuaModifier("modifier_item_yata_mirror", "abilities/items/artifact/item_yata_mirror.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_yata_mirror_buff", "abilities/items/artifact/item_yata_mirror.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_yata_mirror_shield", "abilities/items/artifact/item_yata_mirror.lua", LUA_MODIFIER_MOTION_NONE)
-- Abilities
if item_yata_mirror == nil then
	item_yata_mirror = class({})
end
function item_yata_mirror:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_item_yata_mirror_buff", {duration = self:GetSpecialValueFor("duration")})
	-- sound
	hCaster:EmitSound("Hero_ObsidianDestroyer.EssenceAura")
end
function item_yata_mirror:GetIntrinsicModifierName()
	return "modifier_item_yata_mirror"
end
---------------------------------------------------------------------
-- Modifier
if modifier_item_yata_mirror == nil then
	modifier_item_yata_mirror = class({}, nil, ModifierItemBasic)
end
function modifier_item_yata_mirror:OnCreated(params)
	self.bonus_attribute = self:GetAbilitySpecialValueFor("bonus_attribute")
	self.bonus_resistance = self:GetAbilitySpecialValueFor("bonus_resistance")
	self.interval = self:GetAbilitySpecialValueFor("interval")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.ability_critical_chance = self:GetAbilitySpecialValueFor("ability_critical_chance")
	self.ability_critical_damage = self:GetAbilitySpecialValueFor("ability_critical_damage")
	if IsServer() then
		self:StartIntervalThink(self.interval)
	else
		local p = ParticleManager:CreateParticle("particles/econ/items/shadow_fiend/sf_desolation/sf_desolation_ambient_blade_energy.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
		ParticleManager:SetParticleControlEnt(p, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), false)
		self:AddParticle(p, false, false, -1, false, false)
	end
	SetSpellCriticalStrike(self:GetParent(), self.ability_critical_chance, self.ability_critical_damage, self)
end
function modifier_item_yata_mirror:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveModifierByName("modifier_item_yata_mirror_shield")
	end
	SetSpellCriticalStrike(self:GetParent(), nil, nil, self)
end
function modifier_item_yata_mirror:OnIntervalThink()
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_yata_mirror_shield", {duration = self.duration})
end
function modifier_item_yata_mirror:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
end
function modifier_item_yata_mirror:GetModifierMagicalResistanceBonus()
	return self.bonus_resistance
end
function modifier_item_yata_mirror:GetModifierBonusStats_Strength()
	return self.bonus_attribute
end
function modifier_item_yata_mirror:GetModifierBonusStats_Agility()
	return self.bonus_attribute
end
function modifier_item_yata_mirror:GetModifierBonusStats_Intellect()
	return self.bonus_attribute
end
---------------------------------------------------------------------
if modifier_item_yata_mirror_buff == nil then
	modifier_item_yata_mirror_buff = class({}, nil, ModifierPositiveBuff)
end
function modifier_item_yata_mirror_buff:OnCreated(params)
	self.damage = self:GetAbilitySpecialValueFor("damage")
	local hParent = self:GetParent()
	if IsClient() then
		local p = ParticleManager:CreateParticle("particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_prison_top_orb.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(p, false, false, -1, false, false)
	end
end
function modifier_item_yata_mirror_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}
end
function modifier_item_yata_mirror_buff:GetModifierSpellAmplify_Percentage()
	return self.damage
end
---------------------------------------------------------------------
if modifier_item_yata_mirror_shield == nil then
	modifier_item_yata_mirror_shield = class({}, nil, ModifierHidden)
end
function modifier_item_yata_mirror_shield:OnCreated(params)
	local hParent = self:GetParent()
	if IsServer() then
		for i=1,8 do
			local vPosition = hParent:GetAbsOrigin() + RotatePosition(Vector(0, 0, 0), QAngle(0, 45 * i, 0), hParent:GetForwardVector()) * 120
			local p = ParticleManager:CreateParticle("particles/items/yata_mirror/yata_mirror.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl( p, 0, vPosition)
			ParticleManager:SetParticleControlForward(p, 0, (vPosition - hParent:GetAbsOrigin()):Normalized())
		end
	end
end
function modifier_item_yata_mirror_shield:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
	}
end
function modifier_item_yata_mirror:GetAbsoluteNoDamageMagical()
	return 1
end