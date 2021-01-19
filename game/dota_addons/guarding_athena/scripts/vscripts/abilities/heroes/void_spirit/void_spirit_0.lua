LinkLuaModifier("modifier_void_spirit_0", "abilities/heroes/void_spirit/void_spirit_0.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if void_spirit_0 == nil then
	void_spirit_0 = class({})
end
function void_spirit_0:Spawn()
	local hCaster = self:GetCaster()
	self.tIllusion = {}
	hCaster.tAetherRemnant = self.tIllusion
	hCaster.AetherRemnant = function(hCaster, vPosition)
		self:AetherRemnant(vPosition)
	end
	hCaster:GameTimer(0, function()
		if self:IsFullyCastable() and self:GetAutoCastState() == true then
			local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), hCaster:GetAbsOrigin(), nil, self:GetCastRange(vec3_invalid, nil), DOTA_UNIT_TARGET_TEAM_ENEMY, self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
			if IsValid(tTargets[1]) then
				hCaster:SetCursorPosition(tTargets[1]:GetAbsOrigin())
				hCaster:StartGesture(ACT_DOTA_CAST_ABILITY_1)
				self:OnSpellStart()
				self:UseResources(true, false, true)
				-- ExecuteOrder(self:GetCaster(), DOTA_UNIT_ORDER_CAST_POSITION, niil, self, tTargets[1]:GetAbsOrigin())
			end
		end
		return AI_THINK_TICK_TIME
	end)
end
function void_spirit_0:OnUpgrade()
	if self:GetLevel() == 1 and not self:GetCaster():IsIllusion() then
		self:ToggleAutoCast()
	end
end
function void_spirit_0:AetherRemnant(vPosition)
	local hCaster = self:GetCaster()
	local flDuration = self:GetSpecialValueFor("duration")
	local illusions = CreateIllusions(hCaster, hCaster, { duration = flDuration, outgoing_damage = 100, incoming_damage = 100 }, 1, 100, false, false)
	illusions[1]:SetAbsOrigin(vPosition)
	illusions[1]:AddNewModifier(hCaster, self, "modifier_void_spirit_0", nil)
	table.insert(self.tIllusion, illusions[1])
	return illusions[1]
end
function void_spirit_0:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local flDistance = (vPosition - hCaster:GetAbsOrigin()):Length2D()
	local vDirection = (vPosition - hCaster:GetAbsOrigin()):Normalized()
	CreateLinearProjectile(hCaster, self, "particles/units/heroes/hero_void_spirit/aether_remnant/void_spirit_aether_remnant_run.vpcf", hCaster:GetAbsOrigin(), 0, flDistance, vDirection, 900, false)
end
function void_spirit_0:OnProjectileHit(hTarget, vLocation)
	if hTarget == nil then
		self:AetherRemnant(vLocation)
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_void_spirit_0 == nil then
	modifier_void_spirit_0 = class({}, nil, ModifierHidden)
end
function modifier_void_spirit_0:OnCreated(params)
	self.scepter_cooldown = self:GetAbilitySpecialValueFor("scepter_cooldown")
	if IsServer() then
		self:SetStackCount(1)
		self.hAbility = self:GetParent():FindAbilityByName("void_spirit_3")
		self.max_travel_distance = self.hAbility:GetSpecialValueFor("max_travel_distance")
		self.tRecord = {}
	end
	AddModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, self:GetParent())
	AddModifierEvents(MODIFIER_EVENT_ON_ATTACK_RECORD, self, self:GetParent())
	AddModifierEvents(MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY, self, self:GetParent())
end
function modifier_void_spirit_0:OnIntervalThink()
	self:SetStackCount(1)
	self:StartIntervalThink(-1)
end
function modifier_void_spirit_0:OnDestroy()
	if IsServer() then
		ArrayRemove(self:GetAbility().tIllusion, self:GetParent())
	end
	RemoveModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, self:GetParent())
	RemoveModifierEvents(MODIFIER_EVENT_ON_ATTACK_RECORD, self, self:GetParent())
	RemoveModifierEvents(MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY, self, self:GetParent())
end
function modifier_void_spirit_0:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
	}
end
function modifier_void_spirit_0:GetModifierAttackRangeBonus()
	if self:GetStackCount() == 1 then
		return self.max_travel_distance
	end
end
function modifier_void_spirit_0:CheckState()
	return {
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_TEAM_SELECT] = true,
	}
end
function modifier_void_spirit_0:OnAttackRecord(params)
	if IsServer() then
		table.insert(self.tRecord, params.record)
	end
end
function modifier_void_spirit_0:OnAttackRecordDestroy(params)
	if IsServer() then
		ArrayRemove(self.tRecord, params.record)
	end
end
function modifier_void_spirit_0:OnAttackLanded(params)
	if IsServer() then
		if TableFindKey(self.tRecord, params.record) then
			self:SetStackCount(0)
			self:StartIntervalThink(self.scepter_cooldown)
			self.hAbility:AstralStepScepter(params.target:GetAbsOrigin())
		end
	end
end