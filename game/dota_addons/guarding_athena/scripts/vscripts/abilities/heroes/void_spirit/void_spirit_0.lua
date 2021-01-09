LinkLuaModifier("modifier_void_spirit_0", "abilities/heroes/void_spirit/void_spirit_0.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if void_spirit_0 == nil then
	void_spirit_0 = class({})
end
function void_spirit_0:Spawn()
	local hCaster = self:GetCaster()
	hCaster.AetherRemnant = function(hCaster, vPosition)
		self:AetherRemnant(vPosition)
	end
end
function void_spirit_0:AetherRemnant(vPosition)
	local hCaster = self:GetCaster()
	local flDuration = self:GetSpecialValueFor("duration")
	local illusions = CreateIllusions(hCaster, hCaster, { duration = flDuration, outgoing_damage = 100, incoming_damage = 100 }, 1, 100, false, false)
	illusions[1]:SetAbsOrigin(vPosition)
	illusions[1]:AddNewModifier(hCaster, self, "modifier_void_spirit_0", nil)
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
function modifier_void_spirit_0:CheckState()
	return {
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
end