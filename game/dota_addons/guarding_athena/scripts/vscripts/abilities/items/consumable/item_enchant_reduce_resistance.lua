item_enchant_reduce_resistance = class({})
function item_enchant_reduce_resistance:CastFilterResult()
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
function item_enchant_reduce_resistance:OnSpellStart()
	local hCaster = self:GetCaster()
	local reduce = self:GetSpecialValueFor("reduce")
	hCaster:EachItem(function(hItem)
		if hItem:GetItemType() == "weapon" then
			hItem:SetSecondaryCharges(3)
			hItem:SetCurrentCharges(hItem:GetCurrentCharges() + 1)
			hCaster.GetEnchantValue = function()
				return reduce
			end
			hCaster._iEnchantStack = hItem:GetCurrentCharges()
			hCaster._iEnchantType = hItem:GetSecondaryCharges()
			return true
		end
	end)
	self:SpendCharge()
end