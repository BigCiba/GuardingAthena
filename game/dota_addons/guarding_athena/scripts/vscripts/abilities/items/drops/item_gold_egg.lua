-- Abilities
if item_gold_egg == nil then
	item_gold_egg = class({})
end
function item_gold_egg:OnSpellStart()
	local iPlayerID = self:GetCaster():GetOwner():GetPlayerID()
	local hCaster = self:GetCaster()
	local bHasEssence = false
	for iSlot = 0, 5 do
		local hItem = hCaster:GetItemInSlot(iSlot)
		if IsValid(hItem) and string.find( hItem:GetAbilityName(), "item_essence" ) and hItem:GetLevel() < 15 then
			if RollPercentage(50) then
				hItem:AddCharges(self:GetSpecialValueFor("charges"))
				bHasEssence = true
			end
			break
		end
	end
	if bHasEssence == false then
		hCaster:ModifyPrimaryAttribute(RandomInt(self:GetSpecialValueFor("max_attribute"), self:GetSpecialValueFor("min_attribute")))
		if hCaster.AddBonusStrengthGain then
			hCaster:AddBonusStrengthGain(RandomInt(self:GetSpecialValueFor("max_gain") * 10, self:GetSpecialValueFor("min_gain") * 10) / 10)
		end
		if hCaster.AddBonusAgilityGain then
			hCaster:AddBonusAgilityGain(RandomInt(self:GetSpecialValueFor("max_gain") * 10, self:GetSpecialValueFor("min_gain") * 10) / 10)
		end
		if hCaster.AddBonusIntelligenceGain then
			hCaster:AddBonusIntelligenceGain(RandomInt(self:GetSpecialValueFor("max_gain") * 10, self:GetSpecialValueFor("min_gain") * 10) / 10)
		end
		hCaster:EmitSound("DOTA_Item.Refresher.Activate")
	end
	self:Destroy()
end