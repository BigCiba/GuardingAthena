LinkLuaModifier( "modifier_nevermore_1", "abilities/heroes/nevermore/nevermore_1.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_nevermore_1_debuff", "abilities/heroes/nevermore/nevermore_1.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if nevermore_1 == nil then
	nevermore_1 = class({})
end
function nevermore_1:GetCastAnimation()
	local hCaster = self:GetCaster()
	local hModifier = hCaster:FindModifierByName("modifier_nevermore_1")
	local iStackCount = IsValid(hModifier) and hModifier:GetStackCount() + 1 or 1
	if iStackCount == 1 then
		return ACT_DOTA_RAZE_3
	elseif iStackCount == 2 then
		return ACT_DOTA_RAZE_2
	elseif iStackCount == 3 then
		return ACT_DOTA_RAZE_1
	end
end
-- function nevermore_1:OnAbilityPhaseStart()
-- 	local hCaster = self:GetCaster()
-- 	local tPosition = self:GetPosition()
-- 	for i, vPosition in ipairs(tPosition) do
-- 		local iParticleID = ParticleManager:CreateParticle("particles/heroes/tartarus/destory_hit_circle.vpcf", PATTACH_CUSTOMORIGIN, nil)
-- 		ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
-- 		ParticleManager:ReleaseParticleIndex(iParticleID)
-- 	end
-- 	return true
-- end
function nevermore_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local tPosition = self:GetPosition()
	for i, vPosition in ipairs(tPosition) do
		self:Shadowraze(vPosition)
	end
	hCaster:EmitSound("Hero_Nevermore.Shadowraze")
	self:EndCooldown()
	hCaster:AddNewModifier(hCaster, self, "modifier_nevermore_1", {duration = self:GetSpecialValueFor("combo_duration")})
end
function nevermore_1:GetPosition()
	local hCaster = self:GetCaster()
	local hModifier = hCaster:FindModifierByName("modifier_nevermore_1")
	local iStackCount = IsValid(hModifier) and hModifier:GetStackCount() + 1 or 1
	local vForward = hCaster:GetForwardVector()
	local tDistance = {
		self:GetLevelSpecialValueFor("shadowraze_range", 0),
		self:GetLevelSpecialValueFor("shadowraze_range", 1),
		self:GetLevelSpecialValueFor("shadowraze_range", 2),
	}
	local tPosition = {}
	if iStackCount == 1 then
		table.insert(tPosition, hCaster:GetAbsOrigin() + vForward * tDistance[1])
		table.insert(tPosition, hCaster:GetAbsOrigin() + vForward * tDistance[2])
		table.insert(tPosition, hCaster:GetAbsOrigin() + vForward * tDistance[3])
	elseif iStackCount == 2 then
		table.insert(tPosition, hCaster:GetAbsOrigin() + vForward * tDistance[1])
		table.insert(tPosition, hCaster:GetAbsOrigin() + Rotation2D(vForward, math.rad(20)) * tDistance[2])
		table.insert(tPosition, hCaster:GetAbsOrigin() + Rotation2D(vForward, math.rad(-20)) * tDistance[2])
	else
		table.insert(tPosition, hCaster:GetAbsOrigin() + vForward * tDistance[1])
		table.insert(tPosition, hCaster:GetAbsOrigin() + Rotation2D(vForward, math.rad(60)) * tDistance[1])
		table.insert(tPosition, hCaster:GetAbsOrigin() + Rotation2D(vForward, math.rad(-60)) * tDistance[1])
	end
	return tPosition
end
function nevermore_1:Shadowraze(vPosition)
	local hCaster = self:GetCaster()
	local flRadius = self:GetSpecialValueFor("shadowraze_radius")
	local flDamage = self:GetSpecialValueFor("base_damage") + self:GetSpecialValueFor("damage") * hCaster:GetStrength()
	local flDuration = self:GetSpecialValueFor("duration")
	local flScepterBonusDamage = self:GetSpecialValueFor("scepter_bonus_damage")
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, vPosition, flRadius, self)
	for _, hUnit in pairs(tTargets) do
		local flBonusDamagePct = 0
		-- if hCaster:GetScepterLevel() >= 2 then
			local hModifier = hUnit:FindModifierByName("modifier_nevermore_1_debuff")
			flBonusDamagePct = IsValid(hModifier) and hModifier:GetStackCount() * flScepterBonusDamage * 0.01 or 0
		-- end
		hCaster:DealDamage(hUnit, self, flDamage * (1 + flBonusDamagePct))
		hUnit:AddNewModifier(hCaster, self, "modifier_nevermore_1_debuff", {duration = flDuration})
	end
	
	local iParticleID = ParticleManager:CreateParticle("particles/heroes/tartarus/destory_hit_circle.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
	ParticleManager:ReleaseParticleIndex(iParticleID)
	local iParticleID = ParticleManager:CreateParticle("particles/heroes/tartarus/destory_hit.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
	ParticleManager:ReleaseParticleIndex(iParticleID)
end
---------------------------------------------------------------------
--Modifiers
if modifier_nevermore_1 == nil then
	modifier_nevermore_1 = class({}, nil, ModifierBasic)
end
function modifier_nevermore_1:OnCreated(params)
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_nevermore_1:OnRefresh(params)
	self:OnCreated(params)
end
function modifier_nevermore_1:OnStackCountChanged(iStackCount)
	if iStackCount == 2 then
		self:Destroy()
	end
end
function modifier_nevermore_1:OnDestroy()
	if IsServer() then
		self:GetAbility():UseResources(false, false, true)
	end
end
---------------------------------------------------------------------
if modifier_nevermore_1_debuff == nil then
	modifier_nevermore_1_debuff = class({}, nil, ModifierDebuff)
end
function modifier_nevermore_1_debuff:OnCreated(params)
	self.reduce_damage = self:GetAbilitySpecialValueFor("reduce_damage")
	self.stack_reduce_damage = self:GetAbilitySpecialValueFor("stack_reduce_damage")
	self.max_reduce_damage = self:GetAbilitySpecialValueFor("max_reduce_damage")
	if IsServer() then
		
	end
end
function modifier_nevermore_1_debuff:OnRefresh(params)
	self.reduce_damage = self:GetAbilitySpecialValueFor("reduce_damage")
	self.stack_reduce_damage = self:GetAbilitySpecialValueFor("stack_reduce_damage")
	self.max_reduce_damage = self:GetAbilitySpecialValueFor("max_reduce_damage")
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_nevermore_1_debuff:OnDestroy()
	if IsServer() then
	end
end
function modifier_nevermore_1_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
	}
end
function modifier_nevermore_1_debuff:GetModifierTotalDamageOutgoing_Percentage()
	return math.min(-self.reduce_damage - self.stack_reduce_damage * self:GetStackCount(), -self.max_reduce_damage)
end