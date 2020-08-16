LinkLuaModifier( "modifier_crystal_maiden_0", "abilities/heroes/crystal_maiden/crystal_maiden_0.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_0_buff", "abilities/heroes/crystal_maiden/crystal_maiden_0.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_crystal_maiden_0_thinker", "abilities/heroes/crystal_maiden/crystal_maiden_0.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if crystal_maiden_0 == nil then
	crystal_maiden_0 = class({})
end
function crystal_maiden_0:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	hTarget:AddNewModifier(hCaster, self, "modifier_crystal_maiden_0_buff", {duration = self:GetSpecialValueFor("duration")})

	CreateModifierThinker(hCaster, self, "modifier_crystal_maiden_0_thinker", {duration = 10}, hTarget:GetAbsOrigin(), hCaster:GetTeamNumber(), false)
	
end
function crystal_maiden_0:GetIntrinsicModifierName()
	return "modifier_crystal_maiden_0"
end
---------------------------------------------------------------------
--Modifiers
if modifier_crystal_maiden_0 == nil then
	modifier_crystal_maiden_0 = class({})
end
function modifier_crystal_maiden_0:OnCreated(params)
	if IsServer() then
	end
end
function modifier_crystal_maiden_0:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_crystal_maiden_0:OnDestroy()
	if IsServer() then
	end
end
function modifier_crystal_maiden_0:DeclareFunctions()
	return {
	}
end
---------------------------------------------------------------------
if modifier_crystal_maiden_0_buff == nil then
	modifier_crystal_maiden_0_buff = class({}, nil, ModifierDebuff)
end
function modifier_crystal_maiden_0_buff:OnCreated(params)
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/winter_wyvern/winter_wyvern_ti7/wyvern_cold_embrace_ti7buff.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_crystal_maiden_0_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL
	}
end
function modifier_crystal_maiden_0_buff:CheckState()
	return {
		[MODIFIER_STATE_FROZEN] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}
end
function modifier_crystal_maiden_0_buff:GetAbsoluteNoDamagePhysical()
	return 1
end
---------------------------------------------------------------------
if modifier_crystal_maiden_0_thinker == nil then
	modifier_crystal_maiden_0_thinker = class({}, nil, ModifierThinker)
end
function modifier_crystal_maiden_0_thinker:OnCreated(params)
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/heroes/crystal_maiden/frost_sigil_gound_b.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end