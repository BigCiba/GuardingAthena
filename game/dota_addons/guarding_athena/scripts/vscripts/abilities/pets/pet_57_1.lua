LinkLuaModifier("modifier_pet_57_1", "abilities/pets/pet_57_1.lua", LUA_MODIFIER_MOTION_NONE)

--Abilities
if pet_57_1 == nil then
	pet_57_1 = class({})
end
function pet_57_1:GetIntrinsicModifierName()
	return "modifier_pet_57_1"
end
function pet_57_1:IsHiddenWhenStolen()
	return false
end
function pet_57_1:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	if hTarget ~= nil then
		local hCaster = self:GetCaster()
		local damage = self:GetSpecialValueFor("damage")
		hCaster:DealDamage(hTarget, self, damage * hCaster:GetMaster():GetPrimaryStatValue(), DAMAGE_TYPE_MAGICAL)
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_pet_57_1 == nil then
	modifier_pet_57_1 = class({}, nil, ModifierBasic)
end
function modifier_pet_57_1:IsHidden()
	return true
end
function modifier_pet_57_1:OnCreated(params)
	if IsServer() then
		self.interval = self:GetAbilitySpecialValueFor("interval")
		self.speed = self:GetAbilitySpecialValueFor("speed")
		self.distance = self:GetAbilitySpecialValueFor("distance")
		self.width = self:GetAbilitySpecialValueFor("width")
		self:StartIntervalThink(self.interval)
		self:OnIntervalThink()
	end
end
function modifier_pet_57_1:OnIntervalThink()
	local hParent = self:GetParent()
	if self:GetStackCount() < 1 then
		self:SetStackCount(1)
		self:StartIntervalThink(0)
	else
		local hTarget = hParent:GetOwner():GetAttackTarget()
		if IsValid(hTarget) then
			self:SetStackCount(0)
			self:StartIntervalThink(self.interval)

			if (hParent:GetAbsOrigin() - hParent:GetOwner():GetAbsOrigin()):Length2D() > self.distance then
				local vLocation = hParent:GetOwner():GetAbsOrigin() + RandomVector(200)
				hParent:SetAbsOrigin(vLocation)
				ParticleManager:CreateParticle("particles/econ/items/pets/pet_frondillo/pet_flee_frondillo.vpcf", PATTACH_ABSORIGIN, hParent)
			end

			local vDirection = (hTarget:GetAbsOrigin() - hParent:GetAbsOrigin()):Normalized()
			local speed = self.speed
			local distance = self.distance
			local width = self.width
			local tInfo = {
				Ability = self:GetAbility(),
				Source = hParent,
				EffectName = "particles/units/heroes/hero_jakiro/jakiro_dual_breath_fire.vpcf",
				vSpawnOrigin = hParent:GetAbsOrigin(),
				vVelocity = vDirection * speed,
				fDistance = distance,
				fStartRadius = width,
				fEndRadius = width,
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
			}
			ProjectileManager:CreateLinearProjectile(tInfo)
			hParent:EmitSound("Hero_Jakiro.DualBreath.Cast")
		end
	end
end