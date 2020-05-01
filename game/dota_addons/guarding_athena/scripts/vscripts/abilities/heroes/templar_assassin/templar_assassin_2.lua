LinkLuaModifier("modifier_templar_assassin_2", "abilities/heroes/templar_assassin/templar_assassin_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_templar_assassin_2_buff", "abilities/heroes/templar_assassin/templar_assassin_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_templar_assassin_2_debuff", "abilities/heroes/templar_assassin/templar_assassin_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_templar_assassin_2_motion", "abilities/heroes/templar_assassin/templar_assassin_2.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
-- Abilities
if templar_assassin_2 == nil then
	templar_assassin_2 = class({})
end
-- function templar_assassin_2:GetManaCost(iLevel)
-- 	return self.BaseClass.GetManaCost(self, iLevel) + self:GetCaster():GetLevel()
-- end
function templar_assassin_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local vPosition = self:GetCursorPosition()
	local speed = self:GetSpecialValueFor("speed")
	local distance = self:GetSpecialValueFor("distance")
	local vDirection = (vPosition - hCaster:GetAbsOrigin()):Normalized()
	if IsValid(hTarget) then
		hTarget:AddNewModifier(hCaster, self, "modifier_templar_assassin_2_motion", {vPosition = hCaster:GetAbsOrigin() + vDirection * 200})
	else
		if (vPosition - hCaster:GetAbsOrigin()):Length2D() > distance then
			vPosition = hCaster:GetAbsOrigin() + vDirection * distance
		end
		hCaster:AddNewModifier(hCaster, self, "modifier_templar_assassin_2_motion", {vPosition = vPosition})
	end
	-- scepter
	local scepter_refresh_chance = self:GetSpecialValueFor("scepter_refresh_chance")
	if hCaster:GetScepterLevel() >= 3 and RollPercentage(scepter_refresh_chance) then
		self:RefreshCharges()
	end
end
---------------------------------------------------------------------
-- Modifiers
if modifier_templar_assassin_2_motion == nil then
	modifier_templar_assassin_2_motion = class({})
end
function modifier_templar_assassin_2_motion:IsHidden()
	return true
end
function modifier_templar_assassin_2_motion:IsPurgable()
	return false
end
function modifier_templar_assassin_2_motion:IsPurgeException()
	return false
end
function modifier_templar_assassin_2_motion:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end
function modifier_templar_assassin_2_motion:GetEffectName()
	return "particles/heroes/revelater/revelater_motion.vpcf"
end
function modifier_templar_assassin_2_motion:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_templar_assassin_2_motion:GetPriority()
	return MODIFIER_PRIORITY_NORMAL
end
function modifier_templar_assassin_2_motion:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_STUNNED] = self:GetParent() ~= self:GetCaster(),
		-- 魔免只对自身有效
		[MODIFIER_STATE_MAGIC_IMMUNE] = self:GetParent() == self:GetCaster(),
	}
end
function modifier_templar_assassin_2_motion:OnCreated(params)
	self.speed = self:GetAbilitySpecialValueFor("speed")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.base_damage = self:GetAbilitySpecialValueFor("base_damage")
	self.damage = self:GetAbilitySpecialValueFor("damage")

	if IsServer() then
		if self:ApplyHorizontalMotionController() == false then
			self:Destroy()
		end
		
		self.vOrigin = self:GetParent():GetAbsOrigin()
		self.vPosition = StringToVector(params.vPosition)
		self.flDistance = (self.vPosition - self.vOrigin):Length2D()
		self.vDirection = (self.vPosition - self.vOrigin):Normalized()
		
		self.tTargets = {}
		self:GetParent():EmitSound("Hero_FacelessVoid.TimeDilation.Cast")
		if self:GetParent() == self:GetCaster() then
			ProjectileManager:ProjectileDodge(self:GetParent())
		end
	end
end
function modifier_templar_assassin_2_motion:OnDestroy(params)
	if IsServer() then
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()
		hParent:InterruptMotionControllers(true)
		-- 对自身加速
		if hParent == hCaster then
			hCaster:AddNewModifier(hCaster, self:GetAbility(), "modifier_templar_assassin_2_buff", {duration = self.duration})
			ProjectileManager:ProjectileDodge(hParent)
		else
			-- 对敌人减速
			hParent:AddNewModifier(hCaster, self:GetAbility(), "modifier_templar_assassin_2_debuff", {duration = self.duration * hParent:GetStatusResistanceFactor()})
			-- 对灵魂冲散状态的敌人造成晕眩并提前结束冲散效果
			if hParent:HasModifier("modifier_templar_assassin_1_debuff") then
				local hModifier = hParent:FindModifierByName("modifier_templar_assassin_1_debuff")
				local flRemainingTime = hModifier:GetRemainingTime()
				hParent:AddNewModifier(hCaster, self:GetAbility(), "modifier_stunned", {duration = flRemainingTime * hParent:GetStatusResistanceFactor()})
				hModifier:Destroy()
			end
		end
	end
end
function modifier_templar_assassin_2_motion:OnHorizontalMotionInterrupted()
	
end
function modifier_templar_assassin_2_motion:UpdateHorizontalMotion(me, dt)
	local hAbility = self:GetAbility()
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	local vPos = hParent:GetAbsOrigin()

	if (vPos - self.vOrigin):Length2D() >= self.flDistance then
		FindClearSpaceForUnit(hParent, self.vPosition, true)
		self:Destroy()
		return
	end

	vPos = vPos + self.vDirection * self.speed * dt

	hParent:SetAbsOrigin(vPos)
	-- 伤害碰到的单位
	local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), vPos, nil, self.radius, hAbility:GetAbilityTargetTeam(), hAbility:GetAbilityTargetType(), hAbility:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
	for _, hUnit in pairs(tTargets) do
		if not TableFindKey(self.tTargets, hUnit) then
			table.insert( self.tTargets, hUnit )
			hCaster:DealDamage(hUnit, hAbility, self.base_damage + self.damage * self:GetCaster():GetAgility())
		end
	end
end
function modifier_templar_assassin_2_motion:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
end
function modifier_templar_assassin_2_motion:GetOverrideAnimation()
	if self:GetParent() == self:GetCaster() then
		return ACT_DOTA_VERSUS
	else
		return ACT_DOTA_DISABLED
	end
end
---------------------------------------------------------------------
if modifier_templar_assassin_2_buff == nil then
	modifier_templar_assassin_2_buff = class({}, nil, ModifierPositiveBuff)
end
function modifier_templar_assassin_2_buff:OnCreated(params)
	self.movespeed = self:GetAbilitySpecialValueFor("movespeed")
end
function modifier_templar_assassin_2_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT
	}
end
function modifier_templar_assassin_2_buff:GetModifierMoveSpeedBonus_Percentage()
	return self.movespeed
end
function modifier_templar_assassin_2_buff:GetModifierIgnoreMovespeedLimit()
	return 1
end
---------------------------------------------------------------------
if modifier_templar_assassin_2_debuff == nil then
	modifier_templar_assassin_2_debuff = class({}, nil, ModifierDebuff)
end
function modifier_templar_assassin_2_debuff:OnCreated(params)
	self.movespeed = self:GetAbilitySpecialValueFor("movespeed")
end
function modifier_templar_assassin_2_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
end
function modifier_templar_assassin_2_debuff:GetModifierMoveSpeedBonus_Percentage()
	return -self.movespeed
end