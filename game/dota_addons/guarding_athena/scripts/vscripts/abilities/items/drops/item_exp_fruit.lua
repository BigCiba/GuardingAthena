-- Abilities
if item_exp_fruit == nil then
	item_exp_fruit = class({})
end
function item_exp_fruit:OnSpellStart()
	local hCaster = self:GetCaster()
	local iLevel = GuardingAthena.clotho_lv
	hCaster.exp_rate = hCaster.exp_rate + 0.1
	hCaster:ModifyPrimaryAttribute(RandomInt(iLevel, iLevel * 5))
end