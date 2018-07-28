movespeed = class({})

function movespeed:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,
    }
    return funcs
end
function movespeed:IsHidden()
    return true
end

function movespeed:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function movespeed:GetModifierMoveSpeed_Max( params )
    return 1600
end

function movespeed:GetModifierMoveSpeed_Limit( params )
    return 1600
end