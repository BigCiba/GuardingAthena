ring_1_2 = class({})

function ring_1_2:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end
function ring_1_2:OnAttackLanded( t )
	if IsServer() then
		if t.attacker == self:GetParent() then
			Heal( t.attacker, t.attacker:GetMaxHealth() * 0.08, t.attacker:GetMaxMana() * 0.08, true )
		end
	end
end

function ring_1_2:IsHidden() 
	return false
end
function ring_1_2:GetTexture()
	return "item_ring_secret"
end