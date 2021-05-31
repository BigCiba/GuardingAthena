courier_bag = class({})
function courier_bag:Spawn()
	self.tItemBag = {}
end
function courier_bag:OnSpellStart()
	---@type CDOTA_BaseNPC
	local hCaster = self:GetCaster()

	local tItemTable = {}
	for i = 0, 5 do
		local hItem = hCaster:GetItemInSlot(i)
		if hItem then
			tItemTable[tostring(i)] = hCaster:TakeItem(hItem)
		end
	end
	for k, v in pairs(self.tItemBag) do
		if v then
			local hItem = hCaster:AddItem(v)
			local iSlot = tonumber(k)
			if hItem:GetItemSlot() ~= iSlot then
				hCaster:SwapItems(iSlot, hItem:GetItemSlot())
			end
		end
	end
	self.tItemBag = tItemTable
end