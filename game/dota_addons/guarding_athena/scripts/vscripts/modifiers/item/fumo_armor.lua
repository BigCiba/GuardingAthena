fumo_armor = class({})

function fumo_armor:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
    }
    return funcs
end
function fumo_armor:OnAttackLanded( t )
    if IsServer() then
        if t.attacker == self:GetParent() then
            t.target:AddNewModifier(t.attacker, self:GetAbility(), "fumo_armor_debuff", {duration=10})
        end
    end
end
function fumo_armor:IsHidden() 
	return false
end
function fumo_armor:GetTexture()
    return "item_jian_9"
end
LinkLuaModifier("fumo_armor_debuff","modifiers/item/fumo_armor_debuff.lua",LUA_MODIFIER_MOTION_NONE)