courier_suicide = class({})
function courier_suicide:OnSpellStart()
	---@type CDOTA_BaseNPC
	local hCaster = self:GetCaster()
	local hHero = hCaster:GetOwner()
	hHero:ForceKill(true)
end