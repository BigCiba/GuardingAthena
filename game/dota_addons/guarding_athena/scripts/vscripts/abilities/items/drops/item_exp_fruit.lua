-- Abilities
if item_exp_fruit == nil then
	item_exp_fruit = class({})
end
function item_exp_fruit:OnSpellStart()
	local hCaster = self:GetCaster()
	local iLevel = GuardingAthena.clotho_lv
	if hCaster.AddExperienceGainPercent then
		hCaster:AddExperienceGainPercent(10)
	end
	hCaster:ModifyPrimaryAttribute(RandomInt(iLevel, iLevel * 5))
	self:Destroy()
end