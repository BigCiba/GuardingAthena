LinkLuaModifier("modifier_essence", "abilities/items/essence/essence.lua", LUA_MODIFIER_MOTION_NONE)

if item_essence == nil then
	item_essence = class({})
end
function item_essence:Upgrade()
	local iLevel = self:GetLevel()
	local sItemName = self:GetAbilityName()
	local iSlot = self:GetItemSlot()
	local sBaseName = string.sub( sItemName, 0, 17 )
	local hCaster = self:GetCaster()
	local hItem = CreateItem(sBaseName..(iLevel + 1), hCaster, hCaster)
	hCaster:TakeItem(self)
	hCaster:AddItem(hItem)
	if hItem.Upgrade then
		hItem:SetCurrentCharges(self:GetCurrentCharges())
	end
	if hItem:GetCaster() ~= nil then
		hItem:GetIntrinsicModifier():OnRefresh()
	end
	hCaster:SwapItems(hItem:GetItemSlot(), iSlot)
	UTIL_Remove(self)
end
function item_essence:AddCharges(iCharges)
	local require_count = self:GetSpecialValueFor("require_count")
	self:SetCurrentCharges(self:GetCurrentCharges() + iCharges)
	if self:GetCurrentCharges() >= require_count then
		self:SetCurrentCharges(self:GetCurrentCharges() - require_count)
		self:Upgrade()
	end
end
function item_essence:OnSpellStart()
	local hCaster = self:GetCaster()
	local sItemName = self:GetAbilityName()
	local iSlot = self:GetItemSlot()
	if string.find( sItemName, "str" ) ~= nil then
		sItemName = string.gsub( sItemName, "str", "agi" )
	elseif string.find( sItemName, "agi" ) ~= nil then
		sItemName = string.gsub( sItemName, "agi", "int" )
	elseif string.find( sItemName, "int" ) ~= nil then
		sItemName = string.gsub( sItemName, "int", "str" )
	end
	local hItem = CreateItem(sItemName, hCaster, hCaster)
	hCaster:TakeItem(self)
	hCaster:AddItem(hItem)
	hItem:SetLevel(self:GetLevel())
	hItem:SetCurrentCharges(self:GetCurrentCharges())
	hItem:GetIntrinsicModifier():OnRefresh()
	hCaster:SwapItems(hItem:GetItemSlot(), iSlot)
	UTIL_Remove(self)
end
function item_essence:GetIntrinsicModifierName()
	return "modifier_essence"
end