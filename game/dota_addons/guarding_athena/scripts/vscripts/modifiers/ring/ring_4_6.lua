ring_4_6 = class({})

function ring_4_6:DeclareFunctions()
    local funcs = {
        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
    }
    return funcs
end
function ring_4_6:OnAbilityExecuted( t )
    if IsServer() then
        if t.unit == self:GetParent() then
            local caster = t.unit
            local ability = t.ability
            if ability:IsItem() or ability:IsToggle() or ability:GetCooldown(1) == 0 then
                return
            end
            if caster.dodge_damage == nil then
                caster.dodge_damage = 0
            end
            caster.dodge_damage = caster.dodge_damage + 1
            CreateParticle("particles/items/ring/ring_4_6.vpcf", PATTACH_ABSORIGIN_FOLLOW,caster,1)
            Timers:CreateTimer(1,function ()
                caster.dodge_damage = caster.dodge_damage - 1
                if caster.dodge_damage <= 0 then
                    caster.dodge_damage = nil
                end
            end)
        end
    end
end
function ring_4_6:CheckState()
    local bool = false
    if self:GetParent().dodge_damage then
        bool = true
    end
	local state = {
	    [MODIFIER_STATE_MAGIC_IMMUNE] = bool,
	}
	return state
end
function ring_4_6:IsHidden() 
	return false
end
function ring_4_6:GetTexture()
    return "item_ring_secret"
end