-- Abilities
if item_blood_fruit == nil then
	item_blood_fruit = class({})
end
function item_blood_fruit:OnSpellStart()
	local hCaster = self:GetCaster()
	local iLevel = GuardingAthena.clotho_lv
	if hCaster.AddBonusStrengthGain then
		hCaster:AddBonusStrengthGain(1)
	end
	if hCaster.AddBonusAgilityGain then
		hCaster:AddBonusAgilityGain(1)
	end
	if hCaster.AddBonusIntelligenceGain then
		hCaster:AddBonusIntelligenceGain(1)
	end
	hCaster:ModifyPrimaryAttribute(RandomInt(iLevel, iLevel * 5))
	self:Destroy()
end