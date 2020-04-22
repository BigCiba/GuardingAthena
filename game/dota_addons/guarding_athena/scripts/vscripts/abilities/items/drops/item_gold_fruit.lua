-- Abilities
if item_gold_fruit == nil then
	item_gold_fruit = class({})
end
function item_gold_fruit:OnSpellStart()
	local hCaster = self:GetCaster()
	local iLevel = GuardingAthena.clotho_lv
	hCaster.gold_rate = hCaster.gold_rate + 0.1
	hCaster:ModifyPrimaryAttribute(RandomInt(iLevel, iLevel * 5))
	self:Destroy()
end	