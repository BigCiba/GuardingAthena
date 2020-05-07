-- Abilities
if item_ice_egg == nil then
	item_ice_egg = class({})
end
function item_ice_egg:OnSpellStart()
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
		hCaster.str_gain = hCaster.str_gain + RandomInt(self:GetSpecialValueFor("max_attribute") * 10, self:GetSpecialValueFor("min_attribute") * 10) / 10
		hCaster.agi_gain = hCaster.agi_gain + RandomInt(self:GetSpecialValueFor("max_attribute") * 10, self:GetSpecialValueFor("min_attribute") * 10) / 10
		hCaster.int_gain = hCaster.int_gain + RandomInt(self:GetSpecialValueFor("max_attribute") * 10, self:GetSpecialValueFor("min_attribute") * 10) / 10
		hCaster:EmitSound("DOTA_Item.Refresher.Activate")
	end
	self:Destroy()
end