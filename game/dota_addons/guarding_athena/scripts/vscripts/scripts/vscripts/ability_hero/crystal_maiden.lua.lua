LinkLuaModifier( "modifier_crystal_maiden", "scripts/vscripts/ability_hero/crystal_maiden.lua.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if crystal_maiden == nil then
	crystal_maiden = class({})
end
function crystal_maiden:GetIntrinsicModifierName()
	return "modifier_crystal_maiden"
end
---------------------------------------------------------------------
--Modifiers
if modifier_crystal_maiden == nil then
	modifier_crystal_maiden = class({})
end
function modifier_crystal_maiden:OnCreated(params)
	if IsServer() then
	end
end
function modifier_crystal_maiden:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_crystal_maiden:OnDestroy()
	if IsServer() then
	end
end
function modifier_crystal_maiden:DeclareFunctions()
	return {
	}
end