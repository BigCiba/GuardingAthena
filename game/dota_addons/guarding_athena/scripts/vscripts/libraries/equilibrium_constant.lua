--[[
    使用方法

    修改下面的各常数数值
    将这个文件命名为 equilibrium_constant.lua
    放在 scripts/vscripts 文件夹中
    并在任何单位出生之前 require 'equilibrium_constant' 即可
    每点力量增加生命：10
    每点力量增加生命回复：0.1
    每点力量增加护甲：0.1
    每点力量增加物理伤害：0.05%
    每点敏捷增加攻速：0.5
    每点敏捷增加移动：0.2
    每点敏捷减少伤害：0.05%
    每点敏捷减少冷却时间：0.05%
    每点智力增加魔法：5
    每点智力增加魔法回复：0.05
    每点智力增加魔法伤害：0.05%
    每点智力增加魔抗：0.1
    力量英雄：
        力量：+30生命 +0.10生命回复 + 2攻击 0.02护甲
        敏捷：+0.10攻速 +0.04护甲 +0.01移动 +1攻击
        智力：+11魔法 +0.04魔法回复
    敏捷英雄：
        力量：+25生命 +0.08生命回复 +2攻击
        敏捷：+0.20攻速 +0.06护甲 +0.02移动 +2攻击 +0.005冷却减少
        智力：+13魔法 +0.06魔法回复
    智力英雄：
        力量：+20生命 +0.06生命回复 +0.02魔法回复
        敏捷：+0.05攻速 +0.02护甲
        智力：+15魔法 +0.08魔法回复 +3攻击 +0.01魔法伤害 +0.01魔抗
]]
-- 以下数值修改为自己想要的平衡性常数即可
--[[local DIFF_STR = {}
local DIFF_AGI = {}
local DIFF_INT = {}
local STR_HERO = {}
local AGI_HERO = {}
local INT_HERO = {}

STR_HERO.ATT_PER_STR = 2 -- 力量 - 攻击
STR_HERO.HP_PER_STR = 30 -- 力量 - 血量
STR_HERO.HP_REGEN_PER_STR = 0.1 -- 力量 - 生命恢复
STR_HERO.MP_REGEN_PER_STR = 0 -- 力量 - 魔法恢复
STR_HERO.ARMOR_PER_STR = 0.02 -- 力量 - 护甲
STR_HERO.MANA_PER_INT = 11 -- 智力 - 魔法
STR_HERO.MANA_REGEN_PER_INT = 0.04 -- 智力 - 魔法回复
STR_HERO.RESIST_PER_INT = 0 -- 智力 - 魔法抗性
STR_HERO.ARMOR_PER_AGI = 1/7 -- 敏捷 - 护甲
STR_HERO.ATKSPD_PER_AGI = 0.1 -- 敏捷 - 攻击速度
STR_HERO.MOVSPD_PER_AGI = 0.01-- 敏捷 - 移动速度
STR_HERO.ATT_PER_AGI = 1 -- 敏捷 - 攻击
STR_HERO.MAX_MS = 800 -- 移动速度上限

AGI_HERO.ATT_PER_STR = 2 -- 力量 - 攻击
AGI_HERO.HP_PER_STR = 25 -- 力量 - 血量
AGI_HERO.HP_REGEN_PER_STR = 0.08 -- 力量 - 生命恢复
AGI_HERO.MP_REGEN_PER_STR = 0 -- 力量 - 魔法恢复
AGI_HERO.ARMOR_PER_STR = 0 -- 力量 - 护甲
AGI_HERO.MANA_PER_INT = 13 -- 智力 - 魔法
AGI_HERO.MANA_REGEN_PER_INT = 0.06 -- 智力 - 魔法回复
AGI_HERO.RESIST_PER_INT = 0 -- 智力 - 魔法抗性
AGI_HERO.ARMOR_PER_AGI = 1/7 -- 敏捷 - 护甲
AGI_HERO.ATKSPD_PER_AGI = 0.2 -- 敏捷 - 攻击速度
AGI_HERO.MOVSPD_PER_AGI = 0.02-- 敏捷 - 移动速度
AGI_HERO.ATT_PER_AGI = 2 -- 敏捷 - 攻击
AGI_HERO.MAX_MS = 800 -- 移动速度上限

INT_HERO.ATT_PER_STR = 0 -- 力量 - 攻击
INT_HERO.HP_PER_STR = 20 -- 力量 - 血量
INT_HERO.HP_REGEN_PER_STR = 0.06 -- 力量 - 生命恢复
INT_HERO.MP_REGEN_PER_STR = 0.02 -- 力量 - 魔法恢复
INT_HERO.ARMOR_PER_STR = 0 -- 力量 - 护甲
INT_HERO.MANA_PER_INT = 15 -- 智力 - 魔法
INT_HERO.MANA_REGEN_PER_INT = 0.08 -- 智力 - 魔法回复
INT_HERO.RESIST_PER_INT = 0.01 -- 智力 - 魔法抗性
INT_HERO.ARMOR_PER_AGI = 1/7 -- 敏捷 - 护甲
INT_HERO.ATKSPD_PER_AGI = 0.5 -- 敏捷 - 攻击速度
INT_HERO.MOVSPD_PER_AGI = 0 -- 敏捷 - 移动速度
INT_HERO.ATT_PER_AGI = 0 -- 敏捷 - 攻击
INT_HERO.MAX_MS = 800 -- 移动速度上限

-- DOTA的常量数值
local DEFAULT_HP_PER_STR = 20
local DEFAULT_HP_REGEN_PER_STR = 0.06
local DEFAULT_MANA_PER_INT = 11
local DEFAULT_MANA_REGEN_PER_INT = 0.04
local DEFAULT_SPELL_DAMAGE_PER_INT = 0.07
local DEFAULT_ARMOR_PER_AGI = 1 / 7
local DEFAULT_ATKSPD_PER_AGI = 1

-- 计算差值
DIFF_STR.HP_PER_STR_DIFF = STR_HERO.HP_PER_STR - DEFAULT_HP_PER_STR
DIFF_STR.HP_REGEN_PER_STR_DIFF = STR_HERO.HP_REGEN_PER_STR - DEFAULT_HP_REGEN_PER_STR
DIFF_STR.MANA_PER_INT_DIFF = STR_HERO.MANA_PER_INT - DEFAULT_MANA_PER_INT
DIFF_STR.MANA_REGEN_PER_INT_DIFF = STR_HERO.MANA_REGEN_PER_INT - DEFAULT_MANA_REGEN_PER_INT
DIFF_STR.ARMOR_PER_AGI_DIFF = STR_HERO.ARMOR_PER_AGI - DEFAULT_ARMOR_PER_AGI
DIFF_STR.ATKSPD_PER_AGI_DIFF = STR_HERO.ATKSPD_PER_AGI - DEFAULT_ATKSPD_PER_AGI

DIFF_AGI.HP_PER_STR_DIFF = AGI_HERO.HP_PER_STR - DEFAULT_HP_PER_STR
DIFF_AGI.HP_REGEN_PER_STR_DIFF = AGI_HERO.HP_REGEN_PER_STR - DEFAULT_HP_REGEN_PER_STR
DIFF_AGI.MANA_PER_INT_DIFF = AGI_HERO.MANA_PER_INT - DEFAULT_MANA_PER_INT
DIFF_AGI.MANA_REGEN_PER_INT_DIFF = AGI_HERO.MANA_REGEN_PER_INT - DEFAULT_MANA_REGEN_PER_INT
DIFF_AGI.ARMOR_PER_AGI_DIFF = AGI_HERO.ARMOR_PER_AGI - DEFAULT_ARMOR_PER_AGI
DIFF_AGI.ATKSPD_PER_AGI_DIFF = AGI_HERO.ATKSPD_PER_AGI - DEFAULT_ATKSPD_PER_AGI

DIFF_INT.HP_PER_STR_DIFF = INT_HERO.HP_PER_STR - DEFAULT_HP_PER_STR
DIFF_INT.HP_REGEN_PER_STR_DIFF = INT_HERO.HP_REGEN_PER_STR - DEFAULT_HP_REGEN_PER_STR
DIFF_INT.MANA_PER_INT_DIFF = INT_HERO.MANA_PER_INT - DEFAULT_MANA_PER_INT
DIFF_INT.MANA_REGEN_PER_INT_DIFF = INT_HERO.MANA_REGEN_PER_INT - DEFAULT_MANA_REGEN_PER_INT
DIFF_INT.ARMOR_PER_AGI_DIFF = INT_HERO.ARMOR_PER_AGI - DEFAULT_ARMOR_PER_AGI
DIFF_INT.ATKSPD_PER_AGI_DIFF = INT_HERO.ATKSPD_PER_AGI - DEFAULT_ATKSPD_PER_AGI
]]
local MAX_MS = 750
-- 既作为类，又作为 Lua Modifier
if equilibrium_constant == nil then
    equilibrium_constant = class({})
end

function equilibrium_constant:DeclareFunctions()
    local funcs = {
        --[[MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_MOVESPEED_MAX,
        MODIFIER_PROPERTY_MOVESPEED_LIMIT,]]
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
    return funcs
end

--[[function equilibrium_constant:GetModifierBaseAttack_BonusDamage( params )
    if IsServer() then
        local owner = self:GetParent()
        local AttackBonus
        local heroType = owner:GetPrimaryAttribute()
        if heroType == DOTA_ATTRIBUTE_STRENGTH then
            AttackBonus = owner:GetStrength() + owner:GetAgility()
        elseif heroType == DOTA_ATTRIBUTE_AGILITY then
            AttackBonus = owner:GetStrength() * 2 + owner:GetAgility()
        elseif heroType == DOTA_ATTRIBUTE_INTELLECT then
            AttackBonus = owner:GetIntellect() * 2
        end
        return AttackBonus
    end
end

function equilibrium_constant:GetModifierHealthBonus( params )
    if IsServer() then
        local owner = self:GetParent()
        local str = owner:GetStrength()
        local HealthBonus
        local heroType = owner:GetPrimaryAttribute()
        if heroType == DOTA_ATTRIBUTE_STRENGTH then
            HealthBonus = DIFF_STR.HP_PER_STR_DIFF * str
        elseif heroType == DOTA_ATTRIBUTE_AGILITY then
            HealthBonus = DIFF_AGI.HP_PER_STR_DIFF * str
        elseif heroType == DOTA_ATTRIBUTE_INTELLECT then
            HealthBonus = DIFF_INT.HP_PER_STR_DIFF * str
        end
        return HealthBonus
    end
end

function equilibrium_constant:GetModifierManaBonus( params )
    if IsServer() then
        local owner = self:GetParent()
        local int = owner:GetIntellect()
        local ManaBonus
        local heroType = owner:GetPrimaryAttribute()
        if heroType == DOTA_ATTRIBUTE_STRENGTH then
            ManaBonus = DIFF_STR.MANA_PER_INT_DIFF * int
        elseif heroType == DOTA_ATTRIBUTE_AGILITY then
            ManaBonus = DIFF_AGI.MANA_PER_INT_DIFF * int
        elseif heroType == DOTA_ATTRIBUTE_INTELLECT then
            ManaBonus = DIFF_INT.MANA_PER_INT_DIFF * int
        end
        return ManaBonus
    end
end

function equilibrium_constant:GetModifierAttackSpeedBonus_Constant( params )
    if IsServer() then
        local owner = self:GetParent()
        local agi = owner:GetAgility()
        local AtkSpeedBonus
        local heroType = owner:GetPrimaryAttribute()
        if heroType == DOTA_ATTRIBUTE_STRENGTH then
            AtkSpeedBonus = DIFF_STR.ATKSPD_PER_AGI_DIFF * agi
        elseif heroType == DOTA_ATTRIBUTE_AGILITY then
            AtkSpeedBonus = DIFF_AGI.ATKSPD_PER_AGI_DIFF * agi
        elseif heroType == DOTA_ATTRIBUTE_INTELLECT then
            AtkSpeedBonus = DIFF_INT.ATKSPD_PER_AGI_DIFF * agi
        end
        return AtkSpeedBonus
    end
end


function equilibrium_constant:GetModifierMagicalResistanceBonus( params )
    local ResistBonus = 0
    local attributes = CustomNetTables:GetTableValue("courier_attributes","courier_attributes" .. self:GetParent():GetEntityIndex())
    if attributes and attributes.str then
        local str = attributes.str
        local agi = attributes.agi
        local int = attributes.int
        local x = 0.0008
        if str > agi and str > int then
            x = 0.001
        end
        ResistBonus = -75 * str * x
    end
    return 0
end]]

--[[function equilibrium_constant:GetModifierMoveSpeedBonus_Constant( params )
    if IsServer() then
        local owner = self:GetParent()
        local heroType = owner:GetPrimaryAttribute()
        local x = 0.0005
        if heroType == DOTA_ATTRIBUTE_AGILITY then
            x = 0.00062
        end
        local agi = owner:GetAgility()
        local moveSpeed = owner:GetBaseMoveSpeed()
        local MoveBonus = -(x * agi * moveSpeed) / ( 1 + x * agi)
        return MoveBonus
    end
    local attributes = CustomNetTables:GetTableValue("courier_attributes","courier_attributes" .. self:GetParent():GetEntityIndex())
    if attributes and attributes.agi then
        local agi = attributes.agi
        local x = 0.0005
        local moveSpeed = self:GetParent():GetBaseMoveSpeed()
        local MoveBonus = -(x * agi * moveSpeed) / ( 1 + x * agi)
        return MoveBonus
    end
end]]
--[[function equilibrium_constant:GetModifierConstantHealthRegen()
    if IsServer() then
        -- 如果属性发生了改变，将属性数据发送给客户端
        local parent = self:GetParent()
        parent.vAttributeForClient_equilibrium_constant = parent.vAttributeForClient_equilibrium_constant or {}
        parent.vAttributeForClient_equilibrium_constant.str = parent.vAttributeForClient_equilibrium_constant.str or -1
        parent.vAttributeForClient_equilibrium_constant.agi = parent.vAttributeForClient_equilibrium_constant.agi or -1
        parent.vAttributeForClient_equilibrium_constant.int = parent.vAttributeForClient_equilibrium_constant or -1
        
        local u = false
        local str, agi, int = parent:GetStrength(), parent:GetAgility(), parent:GetIntellect()
        
        if str ~= parent.vAttributeForClient_equilibrium_constant.str then
            u = true; parent.vAttributeForClient_equilibrium_constant.str = str
        end
        if agi ~= parent.vAttributeForClient_equilibrium_constant.agi then
            u = true; parent.vAttributeForClient_equilibrium_constant.agi = agi
        end
        if int ~= parent.vAttributeForClient_equilibrium_constant.int then
            u = true; parent.vAttributeForClient_equilibrium_constant.int = int
        end
        
        CustomNetTables:SetTableValue("courier_attributes","courier_attributes" .. self:GetParent():GetEntityIndex(),parent.vAttributeForClient_equilibrium_constant)
        
        return 0
    end
end]]
--[[function equilibrium_constant:GetModifierMoveSpeedBonus_Percentage( params )
    if IsServer() then
        local owner = self:GetParent()
        local agi = owner:GetAgility()
        local MoveBonus = -0.03 * agi
        return MoveBonus
    end
end]]

--[[function equilibrium_constant:GetModifierConstantManaRegen( params )
    if IsServer() then
        local owner = self:GetParent()
        local str = owner:GetStrength()
        local int = owner:GetIntellect()
        local ManaRegenBonus
        local heroType = owner:GetPrimaryAttribute()
        if heroType == DOTA_ATTRIBUTE_STRENGTH then
            ManaRegenBonus = DIFF_STR.MANA_REGEN_PER_INT_DIFF * int
        elseif heroType == DOTA_ATTRIBUTE_AGILITY then
            ManaRegenBonus = DIFF_AGI.MANA_REGEN_PER_INT_DIFF * int
        elseif heroType == DOTA_ATTRIBUTE_INTELLECT then
            ManaRegenBonus = DIFF_INT.MANA_REGEN_PER_INT_DIFF * int + INT_HERO.MP_REGEN_PER_STR * str
        end
        return ManaRegenBonus
    end
end

function equilibrium_constant:GetModifierConstantHealthRegen( params )
    if IsServer() then
        local owner = self:GetParent()
        local str = owner:GetStrength()
        local HealthRegenBonus
        local heroType = owner:GetPrimaryAttribute()
        if heroType == DOTA_ATTRIBUTE_STRENGTH then
            HealthRegenBonus = DIFF_STR.HP_REGEN_PER_STR_DIFF * str
        elseif heroType == DOTA_ATTRIBUTE_AGILITY then
            HealthRegenBonus = DIFF_AGI.HP_REGEN_PER_STR_DIFF * str
        elseif heroType == DOTA_ATTRIBUTE_INTELLECT then
            HealthRegenBonus = DIFF_INT.HP_REGEN_PER_STR_DIFF * str
        end
        return HealthRegenBonus
    end
end]]
function equilibrium_constant:GetModifierPhysicalArmorBonus( params )
    if IsServer() then
        local owner = self:GetParent()
        local fixStack = owner.armor_mark
        --[[local armor = owner:GetPhysicalArmorValue() + fixStack
        local reduceOld = (armor * 0.05) / (1 + armor * 0.05)
        local fixArmor = (0.9 * reduceOld) / (0.052 - 0.048 * reduceOld)
        fixStack = armor - fixArmor
        owner.armor_mark = fixStack]]
        return 0
    end
end
function equilibrium_constant:OnCreated( )
    if IsServer() then
        local owner = self:GetParent()
        owner.armor_mark = 0
    end
end
function equilibrium_constant:IsHidden()
    return true
end

function equilibrium_constant:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end



--[[function equilibrium_constant:GetModifierMoveSpeed_Max( params )
    return MAX_MS
end

function equilibrium_constant:GetModifierMoveSpeed_Limit( params )
    return MAX_MS
end]]

function equilibrium_constant:x_Start()
    ListenToGameEvent( "npc_spawned", Dynamic_Wrap( equilibrium_constant, "x_OnNPCSpawned" ), self )
end

function equilibrium_constant:x_OnNPCSpawned(keys)
    local hSpawnedUnit = EntIndexToHScript( keys.entindex )
    if hSpawnedUnit then
        if not hSpawnedUnit:HasModifier("equilibrium_constant") and
            IsValidEntity(hSpawnedUnit) and
            hSpawnedUnit.GetAgility and hSpawnedUnit.GetIntellect and hSpawnedUnit.GetStrength
            then
            hSpawnedUnit:AddNewModifier(hSpawnedUnit,nil,"equilibrium_constant",{})
        end
    end
end

LinkLuaModifier("equilibrium_constant","libraries/equilibrium_constant.lua",LUA_MODIFIER_MOTION_NONE)
GameRules.AttributeBonusFix = equilibrium_constant()
GameRules.AttributeBonusFix:x_Start()
