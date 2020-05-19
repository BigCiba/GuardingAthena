LinkLuaModifier( "modifier_juggernaut_3", "abilities/heroes/juggernaut/juggernaut_3.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if juggernaut_3 == nil then
	juggernaut_3 = class({})
end
function juggernaut_3:GetIntrinsicModifierName()
	return "modifier_juggernaut_3"
end
---------------------------------------------------------------------
--Modifiers
if modifier_juggernaut_3 == nil then
	modifier_juggernaut_3 = class({}, nil, ModifierBasic)
end
function modifier_juggernaut_3:OnCreated(params)
	self.damage = self:GetAbilitySpecialValueFor("damage")
	self.base_damage = self:GetAbilitySpecialValueFor("base_damage")
	self.bonus_attack_speed = self:GetAbilitySpecialValueFor("bonus_attack_speed")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.scepter_damage_pct = self:GetAbilitySpecialValueFor("scepter_damage_pct")
	self.scepter_reduce_pct = self:GetAbilitySpecialValueFor("scepter_reduce_pct")
	self.scepter_ignore_armor_chance = self:GetAbilitySpecialValueFor("scepter_ignore_armor_chance")
	if IsServer() then
		self.tData = {}
	end
	AddModifierEvents(MODIFIER_EVENT_ON_ATTACK_START, self, self:GetParent())
	AddModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, self:GetParent())
end
function modifier_juggernaut_3:OnRefresh(params)
	self.damage = self:GetAbilitySpecialValueFor("damage")
	self.base_damage = self:GetAbilitySpecialValueFor("base_damage")
	self.bonus_attack_speed = self:GetAbilitySpecialValueFor("bonus_attack_speed")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.scepter_damage_pct = self:GetAbilitySpecialValueFor("scepter_damage_pct")
	self.scepter_reduce_pct = self:GetAbilitySpecialValueFor("scepter_reduce_pct")
	self.scepter_ignore_armor_chance = self:GetAbilitySpecialValueFor("scepter_ignore_armor_chance")
	if IsServer() then
	end
end
function modifier_juggernaut_3:OnDestroy()
	if IsServer() then
	end
	RemoveModifierEvents(MODIFIER_EVENT_ON_ATTACK_START, self, self:GetParent())
	RemoveModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, self:GetParent())
end
function modifier_juggernaut_3:OnIntervalThink()
	local flTime = GameRules:GetGameTime()
	for i = #self.tData, 1, -1 do
		if self.tData[i].flDieTime >= flTime then
			table.remove(self.tData, i)
			self:DecrementStackCount()
		end
	end
	-- 暂停计时器
	if #self.tData == 0 then
		self:StartIntervalThink(-1)
	end
end
function modifier_juggernaut_3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_IGNORE_PHYSICAL_ARMOR
	}
end
function modifier_juggernaut_3:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed * self:GetStackCount()
end
function modifier_juggernaut_3:OnAttackStart(params)
	if params.attacker == self:GetParent() then
		local iParticleID = ParticleManager:CreateParticle( "particles/skills/blade_dance.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(iParticleID, 2, Vector(RandomInt(0, 180),RandomInt(0, 180),RandomInt(0, 180)))
		ParticleManager:ReleaseParticleIndex(iParticleID)
	end
end
function modifier_juggernaut_3:OnAttackLanded(params)
	if IsServer() then
		if params.attacker == self:GetParent() then
			local hParent = self:GetParent()
			local hAbility = self:GetAbility()
			local flDamage = self.base_damage + self.damage * hParent:GetAverageTrueAttackDamage(params.unit)
			local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.radius, hAbility)
			hParent:DealDamage(tTargets, hAbility, flDamage)
			-- 叠加攻速
			if self:GetStackCount() == 0 then
				-- self:StartIntervalThink(0)
			end
			self:IncrementStackCount()
			table.insert(self.tData, {
				flDieTime = GameRules:GetGameTime() + self.duration
			})
		end
	end
end
function modifier_juggernaut_3:GetModifierIncomingDamage_Percentage()
	if self:GetParent():GetScepterLevel() >= 4 then
		return -self.scepter_reduce_pct * self:GetStackCount()
	end
end
function modifier_juggernaut_3:GetModifierTotalDamageOutgoing_Percentage()
	if self:GetParent():GetScepterLevel() >= 4 then
		return self.scepter_damage_pct * self:GetStackCount()
	end
end
function modifier_juggernaut_3:GetModifierIgnorePhysicalArmor()
	if self:GetParent():GetScepterLevel() >= 3 and RollPercentage(self.scepter_ignore_armor_chance) then
		return 1
	end
end