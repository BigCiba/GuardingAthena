LinkLuaModifier("modifier_templar_assassin_1_debuff", "abilities/heroes/templar_assassin/templar_assassin_1.lua", LUA_MODIFIER_MOTION_NONE)
-- Abilities
if templar_assassin_1 == nil then
	templar_assassin_1 = class({})
end
-- function templar_assassin_1:GetManaCost(iLevel)
-- 	return self.BaseClass.GetManaCost(self, iLevel) + self:GetCaster():GetLevel() * 2
-- end
function templar_assassin_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local speed = self:GetSpecialValueFor("speed")
	local tProjectileInfo = {
		Target = hTarget,
		Source = hCaster,
		Ability = self,
		EffectName = "particles/heroes/revelater/revelater_cash.vpcf",
		bDodgeable = false,
		iMoveSpeed = speed,
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
		ExtraData = {
			x = hCaster:GetAbsOrigin().x,
			y = hCaster:GetAbsOrigin().y
		}
	}
	ProjectileManager:CreateTrackingProjectile( tProjectileInfo )

	hCaster:EmitSound("Hero_TemplarAssassin.Meld.Attack")
end
function templar_assassin_1:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	if not IsValid(hTarget) then
		return
	end
	local hCaster = self:GetCaster()

	local damage = self:GetSpecialValueFor("damage")
	local base_damage = self:GetSpecialValueFor("base_damage")
	local health_pct = self:GetSpecialValueFor("health_pct")
	local angle = self:GetSpecialValueFor("angle")
	local distance = self:GetSpecialValueFor("distance")
	local duration = self:GetSpecialValueFor("duration")
	local bonus_pct = self:GetSpecialValueFor("bonus_pct")

	local flDamage = base_damage + damage * hCaster:GetAgility()
	local flDamagePct = health_pct * hTarget:GetMaxHealth() * 0.01
	local vTargetLoc = hTarget:GetAbsOrigin()
	local vForward = (hTarget:GetAbsOrigin() - Vector(ExtraData.x, ExtraData.y ,0)):Normalized()
	-- 先造成百分比伤害
	hCaster:DealDamage(hTarget, self, flDamagePct, DAMAGE_TYPE_PURE, DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_HPLOSS)
	-- 施加负面状态
	hTarget:AddNewModifier(hCaster, self, "modifier_templar_assassin_1_debuff", {duration = duration * hTarget:GetStatusResistanceFactor()})
	-- 附带一次攻击
	hCaster:PerformAttack(hTarget, true, true, true, false, false, false, true)
	-- 造成伤害
	hCaster:DealDamage(hTarget, self, flDamage)
	-- 溅射
	if hCaster:HasModifier("modifier_templar_assassin_2_buff") or
	hTarget:HasModifier("modifier_templar_assassin_2_debuff") then
		angle = angle * (1 + bonus_pct * 0.01)
		distance = distance * (1 + bonus_pct * 0.01)
	end
	local tTargets = GetUnitsInSector(hCaster, self, vTargetLoc, vForward, angle, distance)
	ArrayRemove(tTargets, hTarget)
	for _,hUnit in pairs(tTargets) do
		hCaster:DealDamage(hUnit, self, flDamage + flDamagePct)
		-- particle
		local iParticleID = CreateParticle( "particles/heroes/revelater/revelater_cash_back.vpcf", PATTACH_CUSTOMORIGIN, hCaster )
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hUnit, PATTACH_POINT_FOLLOW, "attach_hitloc", hUnit:GetAbsOrigin(), true)
	end
end
---------------------------------------------------------------------
-- Modifiers
if modifier_templar_assassin_1_debuff == nil then
	modifier_templar_assassin_1_debuff = class({}, nil, ModifierDebuff)
end
function modifier_templar_assassin_1_debuff:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
function modifier_templar_assassin_1_debuff:GetEffectName()
	return "particles/econ/items/templar_assassin/templar_assassin_focal/templar_meld_focal_overhead.vpcf"
end
function modifier_templar_assassin_1_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end
function modifier_templar_assassin_1_debuff:OnCreated(params)
	self.health_pct = self:GetAbilitySpecialValueFor("health_pct")
end
function modifier_templar_assassin_1_debuff:OnRefresh(params)
	self.health_pct = self:GetAbilitySpecialValueFor("health_pct")
end
function modifier_templar_assassin_1_debuff:OnDestroy()
	if IsServer() then
		-- 提前结束会回复剩余生命
		if self:GetParent():IsAlive() and self:GetRemainingTime() > 0 then
			self:GetParent():Heal(self.health_pct / self:GetDuration() * self:GetRemainingTime() * self:GetParent():GetMaxHealth() * 0.01, self:GetAbility())
		end
	end
end
function modifier_templar_assassin_1_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
	}
end
function modifier_templar_assassin_1_debuff:GetModifierHealthRegenPercentage()
	return self.health_pct / self:GetDuration()
end
function modifier_templar_assassin_1_debuff:GetModifierMoveSpeedBonus_Percentage(params)
	return -RemapVal(self:GetElapsedTime(), 0, self:GetDuration(), self.health_pct, 0)
end
function modifier_templar_assassin_1_debuff:GetModifierIncomingDamage_Percentage(params)
	return RemapVal(self:GetElapsedTime(), 0, self:GetDuration(), self.health_pct, 0)
end
function modifier_templar_assassin_1_debuff:GetModifierTotalDamageOutgoing_Percentage(params)
	return -RemapVal(self:GetElapsedTime(), 0, self:GetDuration(), self.health_pct, 0)
end