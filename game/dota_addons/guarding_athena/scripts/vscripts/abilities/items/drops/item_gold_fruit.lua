-- Abilities
if item_gold_fruit == nil then
	item_gold_fruit = class({})
end
function item_gold_fruit:OnSpellStart()
	local hCaster = self:GetCaster()
	local iLevel = GuardingAthena.clotho_lv
	if hCaster.AddGoldGainPercent then
		hCaster:AddGoldGainPercent(10)
	end
	hCaster:ModifyPrimaryAttribute(RandomInt(iLevel, iLevel * 5))
	self:Destroy()
end	