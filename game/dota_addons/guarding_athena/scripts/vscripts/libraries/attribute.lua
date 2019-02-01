if not Attributes then
    Attributes = class({})
end
function Attributes:Init()
    self.itemTable = LoadKeyValues("scripts/npc/npc_items_custom.txt")
    self.abilityTable = LoadKeyValues("scripts/npc/npc_abilities_custom.txt")
    -- Custom Values
    self.HP_PER_STR           = 20
    self.HP_REGEN_PER_STR     = 0.06
    self.MANA_PER_INT         = 12
    self.MANA_REGEN_PER_INT   = 0.04
    self.ARMOR_PER_AGI        = 0
    self.ATKSPD_PER_AGI       = 0.05
    self.MAX_MS               = 750
    self.SP_INT			   = 0
    -- Default Dota Values
    self.DEFAULT_HP_PER_STR = 18
    self.DEFAULT_HP_REGEN_PER_STR = 0.55
    self.DEFAULT_RES_PER_STR = 0.08
    self.DEFAULT_MANA_PER_INT = 12
    self.DEFAULT_MANA_REGEN_PER_INT = 1.8
    self.DEFAULT_SPELLDMG_PER_INT = 0.07
    self.DEFAULT_ARMOR_PER_AGI = 0.16
    self.DEFAULT_ATKSPD_PER_AGI = 1
    self.DEFAULT_MOVSPD_PER_AGI = 0.05

    --[[self.hp_adjustment = self.HP_PER_STR - self.DEFAULT_HP_PER_STR
    self.mana_adjustment = self.MANA_PER_INT - self.DEFAULT_MANA_PER_INT
    self.armor_adjustment = self.ARMOR_PER_AGI
    self.spellpower_adjustment = self.DEFAULT_SPELLDMG_PER_INT
    self.movespd_adjustment = self.DEFAULT_MOVSPD_PER_AGI]]

    self.applier = CreateItem("item_stat_modifier", nil, nil)
end

function Attributes:CalculateAdjustment(hero)
    local attribute = hero:GetPrimaryAttribute()
    hero.hp_adjustment = self.HP_PER_STR - self.DEFAULT_HP_PER_STR
    hero.mana_adjustment = self.MANA_PER_INT - self.DEFAULT_MANA_PER_INT
    hero.armor_adjustment = self.DEFAULT_ARMOR_PER_AGI
    hero.spellpower_adjustment = self.DEFAULT_SPELLDMG_PER_INT
    hero.movespd_adjustment = self.DEFAULT_MOVSPD_PER_AGI
    hero.resistance_adjustment = self.DEFAULT_RES_PER_STR
    if attribute == DOTA_ATTRIBUTE_STRENGTH then
        hero.hp_adjustment = self.HP_PER_STR - self.DEFAULT_HP_PER_STR * 1
        hero.resistance_adjustment = self.DEFAULT_RES_PER_STR * 1
    elseif attribute == DOTA_ATTRIBUTE_AGILITY then
        hero.movespd_adjustment = self.DEFAULT_MOVSPD_PER_AGI * 1
        hero.armor_adjustment = self.DEFAULT_ARMOR_PER_AGI * 1
    elseif attribute == DOTA_ATTRIBUTE_INTELLECT then
        hero.spellpower_adjustment = self.DEFAULT_SPELLDMG_PER_INT * 1
        hero.mana_adjustment = self.MANA_PER_INT - self.DEFAULT_MANA_PER_INT * 1
    end
end

function Attributes:ModifyBonuses(hero)
    self:CalculateAdjustment(hero)
    Timers:CreateTimer(function()

        if not IsValidEntity(hero) then
            return
        end

        -- Initialize value tracking
        if not hero.custom_stats then
            hero.custom_stats = true
            hero.strength = 0
            hero.agility = 0
            hero.intellect = 0
            hero.base_armor = hero:GetPhysicalArmorBaseValue() - hero:GetAgility() * self.DEFAULT_ARMOR_PER_AGI
        end

        -- Get player attribute values
        local strength = hero:GetStrength()
        local agility = hero:GetAgility()
        local intellect = hero:GetIntellect()
        
        -- Base Armor Bonus
        local armor = agility * hero.armor_adjustment
        hero:SetPhysicalArmorBaseValue(hero.base_armor - armor)
        --[[if not hero:HasModifier("modifier_armor_bonus") then
            self.applier:ApplyDataDrivenModifier(hero, hero, "modifier_armor_bonus", {})
        end
        if hero:GetPhysicalArmorValue() > 0 then
            local fixStack = hero:GetModifierStackCount("modifier_armor_bonus", hero)
            local armor = hero:GetPhysicalArmorValue() + fixStack
            local reduceOld = (armor * 0.05) / (1 + armor * 0.05)
            local fixArmor = (0.9 * reduceOld) / (0.052 - 0.048 * reduceOld)
            fixStack = armor - fixArmor
            hero:SetModifierStackCount("modifier_armor_bonus", hero, fixStack)
        end]]
        --hero:SetPhysicalArmorBaseValue(-fixarmor - armor)
        -- Base Magic Resistance
        local resistance = {}
        local itemRes = 0
        for i=1,6 do
            -- 获取物品
            local item = hero:GetItemInSlot(i-1)
            if item then
                if item:IsNull() then break end
                local itemName = item:GetAbilityName()
                -- 循环所有物品判断是否是身上的物品
                for k,v in pairs(self.itemTable) do
                    if k == itemName and v.Modifiers then
                        for k,v in pairs(v.Modifiers) do
                            if hero:FindModifierByName(k) then
                                -- 判断是否有魔抗属性
                                if v.Properties then
                                    for k,v in pairs(v.Properties) do
                                        if k == "MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS" then
                                            if string.sub(v,0,1) == "%" then
                                                itemRes = item:GetSpecialValueFor(string.sub(v,2,string.len(v)))
                                                table.insert( resistance, itemRes * 0.01 )
                                            else
                                                itemRes = v
                                                table.insert( resistance, itemRes * 0.01 )
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        local abilityRes = 0
        for i=1,hero:GetModifierCount() do
            local modifierName = hero:GetModifierNameByIndex(i)
            local modifier = hero:FindModifierByName(modifierName)
            if not modifier then break end
            local ability = modifier:GetAbility()
            if not ability then break end
            local abilityName = hero:FindModifierByName(modifierName):GetAbility():GetAbilityName()
            -- 循环所有技能判断是否是身上的modifier所属技能
            for k,v in pairs(self.abilityTable) do
                if k == abilityName then
                    if v.Modifiers then
                        for k,v in pairs(v.Modifiers) do
                            if k == modifierName then
                                -- 判断是否有魔抗属性
                                if v.Properties then
                                    for k,v in pairs(v.Properties) do
                                        if k == "MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS" then
                                            if string.sub(v,0,1) == "%" then
                                                abilityRes = ability:GetSpecialValueFor(string.sub(v,2,string.len(v)))
                                                table.insert( resistance, abilityRes * 0.01 )
                                            else
                                                abilityRes = v
                                                table.insert( resistance, abilityRes * 0.01 )
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        local res = 0
        for i=1,#resistance do
            if i == 1 then
                res = resistance[i]
            else
                res = res + ((1 - res) * resistance[i])
            end
        end
        hero:SetBaseMagicalResistanceValue(res)
        -- STR
        if strength ~= hero.strength then
            
            -- HP Bonus
            if not hero:HasModifier("modifier_health_bonus") then
                self.applier:ApplyDataDrivenModifier(hero, hero, "modifier_health_bonus", {})
            end

            local health_stacks = math.abs(strength * hero.hp_adjustment)
            hero:SetModifierStackCount("modifier_health_bonus", self.applier, health_stacks)

            -- Magic Resistance
            --[[if not hero:HasModifier("modifier_magical_resistance_bonus") then
                self.applier:ApplyDataDrivenModifier(hero, hero, "modifier_magical_resistance_bonus", {})
            end
            
            local magic_stacks = math.floor(strength * hero.resistance_adjustment)
            print(magic_stacks)
            hero:SetModifierStackCount("modifier_magical_resistance_bonus", self.applier, magic_stacks)]]
        end

        -- AGI
        if agility ~= hero.agility then        

            -- Move Speed Bonus
            if not hero:HasModifier("modifier_movespeed_bonus_percentage") then
                self.applier:ApplyDataDrivenModifier(hero, hero, "modifier_movespeed_bonus_percentage", {})
            end
            local movespeed_stacks = math.abs(hero.movespd_adjustment * agility)
            hero:SetModifierStackCount("modifier_movespeed_bonus_percentage", self.applier, movespeed_stacks)
        end

        -- INT
        if intellect ~= hero.intellect then
            
            -- Mana Bonus
            if not hero:HasModifier("modifier_mana_bonus") then
                Attributes.applier:ApplyDataDrivenModifier(hero, hero, "modifier_mana_bonus", {})
            end

            local mana_stacks = math.abs(intellect * hero.mana_adjustment)
            hero:SetModifierStackCount("modifier_mana_bonus", self.applier, mana_stacks)
           --[[print("MANA STACKS A:")
            print(mana_stacks)
            if hero:HasModifier("modifier_halcyon_soul_glove") then
               mana_stacks = mana_stacks - intellect*MANA_PER_INT*0.5
            end
            print("MANA STACKS B:")
            print(mana_stacks)
            if hero:GetMaxMana() - mana_stacks > 300 then
             hero:SetModifierStackCount("modifier_mana_bonus", Attributes.applier, mana_stacks)
            end

            -- Mana Regen Bonus
            if not hero:HasModifier("modifier_base_mana_regen") then
                Attributes.applier:ApplyDataDrivenModifier(hero, hero, "modifier_base_mana_regen", {})
            end

            local mana_regen_stacks = math.abs(intellect * Attributes.mana_regen_adjustment * 100)
            if hero:HasModifier("modifier_halcyon_soul_glove") then
               mana_regen_stacks = mana_regen_stacks + intellect*MANA_REGEN_PER_INT*0.5
            end
            hero:SetModifierStackCount("modifier_base_mana_regen", Attributes.applier, mana_regen_stacks)]]

            --SPELL DAMAGE STACKS
            if not hero:HasModifier("modifier_spell_damage_constant") then
                self.applier:ApplyDataDrivenModifier(hero, hero, "modifier_spell_damage_constant", {})
            end

            local spellpower_stacks = intellect * hero.spellpower_adjustment * 100
            hero:SetModifierStackCount("modifier_spell_damage_constant", self.applier, spellpower_stacks)

            
        end

        -- Update the stored values for next timer cycle
        hero.strength = strength
        hero.agility = agility
        hero.intellect = intellect

        hero:CalculateStatBonus()
        return 0.03
    end)
end

-- if not Attributes.applier then Attributes:Init() end