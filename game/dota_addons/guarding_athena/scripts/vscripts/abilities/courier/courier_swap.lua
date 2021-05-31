courier_swap = class({})
function courier_swap:OnSpellStart()
	---@type CDOTA_BaseNPC
	local hCaster = self:GetCaster()
	local hHero = hCaster:GetOwner()
	local hCourierItem = hCaster:TakeItem(hCaster:GetItemInSlot(0))
	local hHeroItem = hHero:TakeItem(hHero:GetItemInSlot(0))
	hCaster:AddItem(hHeroItem)
	hHero:AddItem(hCourierItem)
end