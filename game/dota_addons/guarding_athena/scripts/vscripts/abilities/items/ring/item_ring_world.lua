LinkLuaModifier( "modifier_item_ring_world", "abilities/items/ring/item_ring_world.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if item_ring_world == nil then
	item_ring_world = class({})
end
function item_ring_world:GetIntrinsicModifierName()
	return "modifier_item_ring_world"
end
--Abilities
if item_ring_world_broken == nil then
	item_ring_world_broken = class({})
end
function item_ring_world_broken:GetIntrinsicModifierName()
	return "modifier_item_ring_world"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_ring_world == nil then
	modifier_item_ring_world = class({}, nil, ModifierItemBasic)
end
function modifier_item_ring_world:OnCreated(params)
	self.bonus_stats = self:GetAbilitySpecialValueFor("bonus_stats")
	self.bonus_health = self:GetAbilitySpecialValueFor("bonus_health")
	self.bonus_mana = self:GetAbilitySpecialValueFor("bonus_mana")
	self.bonus_hp_regen = self:GetAbilitySpecialValueFor("bonus_hp_regen")
	self.bonus_mp_regen = self:GetAbilitySpecialValueFor("bonus_mp_regen")
	self.bonus_armor = self:GetAbilitySpecialValueFor("bonus_armor")
	self.bonus_attack = self:GetAbilitySpecialValueFor("bonus_attack")
	self.bonus_attack_speed = self:GetAbilitySpecialValueFor("bonus_attack_speed")
	if IsServer() then
		local hParent = self:GetParent()
		if hParent:IsRealHero() then
			local iPlayerID = hParent:IsSummoned() and hParent:GetOwner():GetPlayerOwnerID() or hParent:GetPlayerOwnerID()
			self.tRingData = PlayerData:GetRingData(iPlayerID)
			local iFirstIndex = math.min(self.tRingData[1].iRingIndex, self.tRingData[2].iRingIndex)
			local iSecondIndex = math.max(self.tRingData[1].iRingIndex, self.tRingData[2].iRingIndex)
			self.sModifierName = "ring_"..iFirstIndex.."_"..iSecondIndex
			-- 添加所有modifier
			for _, tData in ipairs(self.tRingData) do
				hParent:AddNewModifier(hParent, self:GetAbility(), tData.sModifierName, nil)
			end
			hParent:AddNewModifier(hParent, self:GetAbility(), self.sModifierName, nil)
		end
	end
end
function modifier_item_ring_world:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()
		if hParent:IsRealHero() then
			for _, tData in ipairs(self.tRingData) do
				hParent:RemoveModifierByName(tData.sModifierName)
			end
			hParent:RemoveModifierByName(self.sModifierName)
		end
	end
end
function modifier_item_ring_world:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
end
function modifier_item_ring_world:GetModifierHealthBonus(t)
	return self.bonus_health
end
function modifier_item_ring_world:GetModifierManaBonus( t )
	return self.bonus_mana
end
function modifier_item_ring_world:GetModifierConstantHealthRegen(t)
	return self.bonus_hp_regen
end
function modifier_item_ring_world:GetModifierConstantManaRegen( t )
	return self.bonus_mp_regen
end
function modifier_item_ring_world:GetModifierPhysicalArmorBonus( t )
	return self.bonus_armor
end
function modifier_item_ring_world:GetModifierBaseDamageOutgoing_Percentage( t )
	return self.bonus_attack
end
function modifier_item_ring_world:GetModifierBonusStats_Strength(t)
	return self.bonus_stats
end
function modifier_item_ring_world:GetModifierBonusStats_Agility(t)
	return self.bonus_stats
end
function modifier_item_ring_world:GetModifierBonusStats_Intellect(t)
	return self.bonus_stats
end
function modifier_item_ring_world:GetModifierAttackSpeedBonus_Constant(t)
	return self.bonus_attack_speed
end