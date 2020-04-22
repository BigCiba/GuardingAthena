-- Abilities
if item_blood_fruit == nil then
	item_blood_fruit = class({})
end
function item_blood_fruit:OnSpellStart()
	local hCaster = self:GetCaster()
	local iLevel = GuardingAthena.clotho_lv
	hCaster.str_gain = hCaster.str_gain + 1
	hCaster.agi_gain = hCaster.agi_gain + 1
	hCaster.int_gain = hCaster.int_gain + 1
	hCaster:ModifyPrimaryAttribute(RandomInt(iLevel, iLevel * 5))
	self:Destroy()
end