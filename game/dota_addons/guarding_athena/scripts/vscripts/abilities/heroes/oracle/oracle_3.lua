LinkLuaModifier( "modifier_oracle_3", "abilities/heroes/oracle/oracle_3.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_oracle_3_root", "abilities/heroes/oracle/oracle_3.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if oracle_3 == nil then
	oracle_3 = class({})
end
-- 处理2技能的减冷却效果
function oracle_3:GetCooldown(iLevel)
	local hCaster = self:GetCaster()
	local flCooldown = self.BaseClass.GetCooldown(self, iLevel)
	if hCaster:HasModifier("modifier_oracle_2") then
		return hCaster:GetOracleCooldown(flCooldown)
	end
	return flCooldown
end
function oracle_3:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	hTarget:AddNewModifier(hCaster, self, "modifier_oracle_3", {duration = self:GetSpecialValueFor("duration")})
	hCaster:EmitSound("Hero_Oracle.FatesEdict.Cast")
	hTarget:EmitSound("Hero_Oracle.FatesEdict")
end
function oracle_3:Fortune(hSource, hTarget)
	local hCaster = self:GetCaster()
	local tProjectileInfo = {
		Target = hTarget,
		Ability = self,
		EffectName = "particles/units/heroes/hero_oracle/oracle_fortune_prj.vpcf",
		bDodgeable = false,
		iMoveSpeed = 2000,
		vSourceLoc = hSource:GetAttachmentOrigin(hSource:ScriptLookupAttachment( "attach_hitloc" )),
	}
	ProjectileManager:CreateTrackingProjectile( tProjectileInfo )
end
function oracle_3:OnProjectileHit(hTarget, vLocation)
	local hCaster = self:GetCaster()
	if IsValid(hTarget) then
		if hCaster:GetScepterLevel() >= 3 then
			local radius = self:GetSpecialValueFor("scepter_root_radius")
			local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), vLocation, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
			for _, hUnit in ipairs(tTargets) do
				hCaster:DealDamage(hUnit, self)
				hUnit:AddNewModifier(hCaster, self, "modifier_oracle_3_root", {duration = self:GetSpecialValueFor("scepter_root_duration")})
				-- local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_fortune_aoe.vpcf", PATTACH_CUSTOMORIGIN, nil)
				-- ParticleManager:SetParticleControl(iParticleID, 0, vLocation)
				-- ParticleManager:SetParticleControl(iParticleID, 1, Vector(radius, 0, 0))
				-- ParticleManager:ReleaseParticleIndex(iParticleID)
			end
		else
			hCaster:DealDamage(hTarget, self)
		end
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_oracle_3 == nil then
	modifier_oracle_3 = class({}, nil, ModifierPositiveBuff)
end
function modifier_oracle_3:OnCreated(params)
	self.movespeed = self:GetAbilitySpecialValueFor("movespeed")
	self.block_count = self:GetAbilitySpecialValueFor("block_count")
	self.block_duration = self:GetAbilitySpecialValueFor("block_duration")
	if IsServer() then
		self.bCooldownReady = true
		-- 设置格挡次数
		self:SetStackCount(self.block_count)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_fatesedict_arc_pnt.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_oracle_3:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_oracle_3:OnIntervalThink()
	self.bCooldownReady = true
end
function modifier_oracle_3:OnDestroy()
	if IsServer() then
	end
end
function modifier_oracle_3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_AVOID_DAMAGE
	}
end
function modifier_oracle_3:GetModifierMoveSpeedBonus_Constant()
	return self.movespeed
end
function modifier_oracle_3:GetModifierAvoidDamage(params)
	if IsServer() then
		if self.bCooldownReady == true then
			self.bCooldownReady = false
			self:StartIntervalThink(self.block_duration)
			local iParticleID = ParticleManager:CreateParticle("particles/heroes/oracle/oracle_3_block.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			self:DecrementStackCount()
			if self:GetStackCount() == 0 then
				self:SetDuration(self.block_duration, true)
				self:StartIntervalThink(-1)
			end
		end
		self:GetAbility():Fortune(self:GetParent(), params.attacker)
		return 1
	end
end
---------------------------------------------------------------------
if modifier_oracle_3_root == nil then
	modifier_oracle_3_root = class({}, nil, ModifierDebuff)
end
function modifier_oracle_3_root:OnCreated(params)
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_fortune_purge.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_oracle_3_root:CheckState()
	return {
		[MODIFIER_STATE_ROOTED] = true,
	}
end