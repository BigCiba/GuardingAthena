LinkLuaModifier( "modifier_elite_34_4", "abilities/enemy/elite_34_4.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if elite_34_4 == nil then
	elite_34_4 = class({})
end
function elite_34_4:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	hTarget:AddNewModifier(hCaster, self, "modifier_elite_34_4", {duration = self:GetDuration()})
	hCaster:EmitSound("Hero_ShadowDemon.Soul_Catcher.Cast")
end
function elite_34_4:GetIntrinsicModifierName()
	return "modifier_elite_34_4"
end
---------------------------------------------------------------------
--Modifiers
if modifier_elite_34_4 == nil then
	modifier_elite_34_4 = class({}, nil, ModifierDebuff)
end
function modifier_elite_34_4:OnCreated(params)
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/solar_lock.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	end
end
function modifier_elite_34_4:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_elite_34_4:OnDestroy()
	if IsServer() then
	end
end
function modifier_elite_34_4:DeclareFunctions()
	return {
	}
end
function modifier_elite_34_4:CheckState()
	return {
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_SILENCED] = true
	}
end