LinkLuaModifier( "modifier_rubick_1", "abilities/heroes/rubick/rubick_1.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_rubick_1_thinker", "abilities/heroes/rubick/rubick_1.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if rubick_1 == nil then
	rubick_1 = class({})
end
function rubick_1:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function rubick_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local flRadius = self:GetSpecialValueFor("radius")
	local flDuration = self:GetSpecialValueFor("pull_duration")
	local tTargets, iHashIndex = CreateHashtable()
	tTargets = FindUnitsInRadiusWithAbility(hCaster, hCaster:GetAbsOrigin(), flRadius, self)
	for _, hUnit in pairs(tTargets) do
		hUnit:AddNewModifier(hCaster, self, "modifier_rubick_1", {duration = flDuration, flUnitCount = #tTargets, vPosition = vPosition})
	end
	-- 传送伤害
	CreateModifierThinker(hCaster, self, "modifier_rubick_1_thinker", {duration = flDuration, iHashIndex = iHashIndex}, vPosition, hCaster:GetTeamNumber(), false)
	-- 天赋
	hCaster:SpaceRift(hCaster:GetAbsOrigin() + RandomVector(RandomInt(0, flRadius)))
	-- particle
	local iParticleID = ParticleManager:CreateParticle("particles/skills/chronos_magic.vpcf", PATTACH_CENTER_FOLLOW, hCaster)
	-- sound
	hCaster:EmitSound("Hero_Dark_Seer.Vacuum")
end
function rubick_1:GetIntrinsicModifierName()
	return "modifier_rubick_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_rubick_1 == nil then
	modifier_rubick_1 = class({}, nil, HorizontalMotionModifier)
end
function modifier_rubick_1:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end
function modifier_rubick_1:OnCreated(params)
	self.pull_damage = self:GetAbilitySpecialValueFor("pull_damage")
	self.pull_bonus = self:GetAbilitySpecialValueFor("pull_bonus")
	if IsServer() then
		local hCaster = self:GetCaster()
		self.vDir = (self:GetCaster():GetAbsOrigin() - self:GetParent():GetAbsOrigin()):Normalized()
		self.vPosition = StringToVector(params.vPosition)
		-- damage
		local flDamage = self.pull_damage * hCaster:GetIntellect() * (1 + params.flUnitCount * self.pull_bonus * 0.01)
		hCaster:DealDamage(self:GetParent(), self:GetAbility(), flDamage)
		-- motion
		if not self:ApplyHorizontalMotionController() then
			self:Destroy()
			return
		end
	end
end
function modifier_rubick_1:OnDestroy()
	if IsServer() then
		self:RemoveHorizontalMotionController(self)
		-- 传送
		local hParent = self:GetParent()
		FindClearSpaceForUnit(hParent, self.vPosition, true)
	end
end
function modifier_rubick_1:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_rubick_1:UpdateHorizontalMotion(me, dt)
	if IsServer() then
		local hCaster = self:GetCaster()
		local flDistance = (me:GetAbsOrigin() - hCaster:GetAbsOrigin()):Length2D()
		local flSpeed= flDistance / 20

		local vPosition = me:GetAbsOrigin() + self.vDir * flSpeed * dt
		me:SetAbsOrigin(vPosition)
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_rubick_1_thinker == nil then
	modifier_rubick_1_thinker = class({}, nil, ModifierThinker)
end
function modifier_rubick_1_thinker:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.open_damage = self:GetAbilitySpecialValueFor("open_damage")
	self.pull_bonus = self:GetAbilitySpecialValueFor("pull_bonus")
	if IsServer() then
		self.iHashIndex = params.iHashIndex
	end
end
function modifier_rubick_1_thinker:OnDestroy()
	if IsServer() then
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()
		local tTargets = FindUnitsInRadiusWithAbility(hCaster, hParent:GetAbsOrigin(), self.radius, self:GetAbility())
		local tPullTargets = GetHashtableByIndex(self.iHashIndex)
		-- 合并单位组
		tTargets = TableOverride(tTargets, tPullTargets)
		-- 造成伤害
		local flDamage = self.open_damage * hCaster:GetIntellect() * (1 + #tTargets * self.pull_bonus * 0.01)
		hCaster:DealDamage(tTargets, self:GetAbility(), flDamage)
		-- 天赋
		hCaster:SpaceRift(hParent:GetAbsOrigin() + RandomVector(RandomInt(0, self.radius)))
		-- particle
		local sParticleName = "particles/heroes/chronos_magic/chronos_magic_open.vpcf"
		if hCaster.gift then
			sParticleName = "particles/heroes/chronos_magic/chronos_magic_gold_open.vpcf"
		end
		local iParticleID = ParticleManager:CreateParticle(sParticleName, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin())
		self:AddParticle(iParticleID, false, false, -1, false, false)
		-- 清空哈希
		RemoveHashtable(self.iHashIndex)
	end
end