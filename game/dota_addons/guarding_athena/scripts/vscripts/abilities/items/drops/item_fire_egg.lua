-- Abilities
if item_fire_egg == nil then
	item_fire_egg = class({})
end
function item_fire_egg:OnSpellStart()
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
		hCaster:EmitSound("DOTA_Item.Refresher.Activate")
	end
	self:Destroy()
end