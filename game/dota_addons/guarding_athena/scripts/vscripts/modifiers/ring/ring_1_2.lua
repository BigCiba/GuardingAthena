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
--[[function ring_1_2:x_Start()
    ListenToGameEvent( "npc_spawned", Dynamic_Wrap( ring_1_2, "x_OnNPCSpawned" ), self )
end
function ring_1_2:x_OnNPCSpawned(keys)
    local hSpawnedUnit = EntIndexToHScript( keys.entindex )
    if hSpawnedUnit then
        if not hSpawnedUnit:HasModifier("ring_1_2") and
            IsValidEntity(hSpawnedUnit) and
            hSpawnedUnit.GetAgility and hSpawnedUnit.GetIntellect and hSpawnedUnit.GetStrength
            then
            hSpawnedUnit:AddNewModifier(hSpawnedUnit,nil,"ring_1_2",{})
        end
    end
end
LinkLuaModifier("ring_1_2","modifiers/ring/ring_1_2.lua",LUA_MODIFIER_MOTION_NONE)
GameRules.Ring_1_2 = ring_1_2()
GameRules.Ring_1_2:x_Start()]]