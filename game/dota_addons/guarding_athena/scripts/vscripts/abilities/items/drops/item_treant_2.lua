-- Abilities
if item_treant_2 == nil then
	item_treant_2 = class({})
end
function item_treant_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local hUnit = CreateUnitByName("tree_2", self:GetCursorPosition(), true, hCaster, hCaster, hCaster:GetTeamNumber())
	hUnit:SetControllableByPlayer(hCaster:GetPlayerOwnerID(), true)
	hUnit:AddNewModifier(hCaster, self, "modifier_kill", {duration = self:GetSpecialValueFor("duration")})
	hUnit:EmitSound("Hero_Furion.Sprout")
end