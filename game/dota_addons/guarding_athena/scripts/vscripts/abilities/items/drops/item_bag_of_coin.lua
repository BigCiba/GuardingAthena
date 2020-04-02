-- Abilities
if item_bag_of_coin == nil then
	item_bag_of_coin = class({})
end
function item_bag_of_coin:OnSpellStart()
	local iPlayerID = self:GetCaster():GetOwner():GetPlayerID()
	self:GetCaster():EmitSound("ui.comp_coins_tick")
	PlayerResource:ModifyGold(iPlayerID, self:GetSpecialValueFor("gold"), true, 0)
	self:Destroy()
end