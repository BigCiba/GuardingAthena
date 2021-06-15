item_enchant_critical = class({})
function item_enchant_critical:CastFilterResult()
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

function item_enchant_critical:OnSpellStart()
	local hCaster = self:GetCaster()
	local critical_chance = self:GetSpecialValueFor("critical_chance")
	local critical_mutiple = self:GetSpecialValueFor("critical_mutiple")
	hCaster:EachItem(function (hItem)
		if hItem:GetItemType() == "weapon" then
			hItem:SetSecondaryCharges(1)
			hItem:SetCurrentCharges(hItem:GetCurrentCharges() + 1)
			hCaster.GetEnchantValue = function()
				return critical_mutiple
			end
			hCaster._iEnchantStack = hItem:GetCurrentCharges()
			hCaster._iEnchantType = hItem:GetSecondaryCharges()
			return true
		end
	end)
	self:SpendCharge()
end