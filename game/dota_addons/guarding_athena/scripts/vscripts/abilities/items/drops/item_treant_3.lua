-- Abilities
if item_treant_3 == nil then
	item_treant_3 = class({})
end
function item_treant_3:OnSpellStart()
	CreateTempTree(self:GetCursorPosition(), self:GetSpecialValueFor("duration"))
end