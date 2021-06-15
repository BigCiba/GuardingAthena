item_enchant_lifesteal = class({})
function item_enchant_lifesteal:CastFilterResult()
	if IsServer() then
		local hCaster = self:GetCaster()
		local bHasWeapon = false
		hCaster:EachItem(function(hItem)
			if hItem:GetItemType() == "weapon" and hItem:GetCurrentCharges() < 10 then
				bHasWeapon = true
				return true
			end
		end)
		if bHasWeapon then
			return UF_SUCCESS
		end
		return UF_FAIL_OTHER
	end
end

function item_enchant_lifesteal:OnSpellStart()
	local hCaster = self:GetCaster()
	local lifesteal = self:GetSpecialValueFor("lifesteal")
	hCaster:EachItem(function(hItem)
		if hItem:GetItemType() == "weapon" then
			hItem:SetSecondaryCharges(2)
			hItem:SetCurrentCharges(hItem:GetCurrentCharges() + 1)
			hCaster.GetEnchantValue = function()
				return lifesteal
			end
			hCaster._iEnchantStack = hItem:GetCurrentCharges()
			hCaster._iEnchantType = hItem:GetSecondaryCharges()
			return true
		end
	end)
	self:SpendCharge()
end