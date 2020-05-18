LinkLuaModifier( "modifier_juggernaut_2", "abilities/heroes/juggernaut/juggernaut_2.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if juggernaut_2 == nil then
	juggernaut_2 = class({})
end
function juggernaut_2:OnSpellStart()
	local hCaster = self:GetCaster()
end
function juggernaut_2:GetIntrinsicModifierName()
	return "modifier_juggernaut_2"
end
---------------------------------------------------------------------
--Modifiers
if modifier_juggernaut_2 == nil then
	modifier_juggernaut_2 = class({})
end
function modifier_juggernaut_2:OnCreated(params)
	if IsServer() then
	end
end
function modifier_juggernaut_2:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_juggernaut_2:OnDestroy()
	if IsServer() then
	end
end
function modifier_juggernaut_2:DeclareFunctions()
	return {
	}
end
-- g3183 2车12a