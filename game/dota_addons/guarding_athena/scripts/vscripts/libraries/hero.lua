if HeroState == nil then
    --HeroState = class({})
    HeroState = {}
    HeroState.__index = HeroState
end
function HeroState:Init()
    self.heroTable = {}
end
function HeroState:InitHero(hero)
    -- 初始化伤害系数
    hero.bonus_magic_damage = 0         --额外百分比魔法伤害
    hero.bonus_physical_damage = 0      --额外无视护甲物理伤害
    hero.percent_bonus_damage = 0       --额外百分比所有伤害
    hero.const_reduce_damage = 0        --定值伤害减少
    hero.percent_reduce_damage = 0      --百分比伤害减少
    hero.percent_increase_damage = 0    --百分比伤害增加
    -- 初始化需要记录的数据
    hero.str_gain = 0                   --力量成长
    hero.agi_gain = 0                   --敏捷成长
    hero.int_gain = 0                   --智力成长
    hero.total_gold = 0                 --获取金钱总量
    hero.boss_damage = 0                --对Boss造成伤害总量
    hero.dps = 0                        --每秒伤害
    hero.wave_def = 0                   --防守数量
    hero.practice_kill = 0              --练习数量
    hero.exp_rate = 1                   --经验获取率
    hero.gold_rate = 1                  --金钱获取率
    hero.reborn_time = 0                --转生次数
    hero.def_point = 0                  --防守积分
    --local score = hero:GetPlayerOwner().ServerInfo.score or 0
    hero.boss_point = 0                 --Boss积分
    hero.practice_point = 0             --练习积分
    -- 戒指
    hero.ringCount = 0                  --记录戒指数量
    hero.ringList = {}                  --记录最后获得的戒指

    hero.courier = nil                  --信使
    hero.bag_item = {}                  --背包物品
    table.insert(self.heroTable,hero)
    Timers:CreateTimer(function ()
        self:UpdateNetTable(hero)
        self:UpdateItemInSlot(hero)
        return 0.1
    end)
end
function HeroState:InitUnit(unit)
    unit.bonus_magic_damage = unit.bonus_magic_damage or 0         --额外百分比魔法伤害
    unit.percent_bonus_damage = unit.percent_bonus_damage or 0       --额外百分比所有伤害
    unit.const_reduce_damage = unit.const_reduce_damage or 0        --定值伤害减少
    unit.percent_reduce_damage = unit.percent_reduce_damage or 0      --百分比伤害减少
    unit.percent_increase_damage = unit.percent_increase_damage or 0    --百分比伤害增加
    unit.str_gain = unit.str_gain or 0
    unit.agi_gain = unit.agi_gain or 0
    unit.int_gain = unit.int_gain or 0
    unit.total_gold = 0
    unit.boss_damage = 0
    unit.wave_def = 0
    unit.def_point = 0
    unit.boss_point = 0
    unit.practice_point = 0
    unit.practice_kill = 0
    unit.exp_rate = 1
    unit.gold_rate = 1
end
function HeroState:InitIllusion(unit)
    unit.bonus_magic_damage = 0         --额外百分比魔法伤害
    unit.percent_bonus_damage = 0       --额外百分比所有伤害
    unit.const_reduce_damage = 0        --定值伤害减少
    unit.percent_reduce_damage = 0      --百分比伤害减少
    unit.percent_increase_damage = 0    --百分比伤害增加
    unit.str_gain = 0
    unit.agi_gain = 0
    unit.int_gain = 0
    unit.total_gold = 0
    unit.boss_damage = 0
    unit.wave_def = 0
    unit.def_point = 0
    unit.boss_point = 0
    unit.practice_point = 0
    unit.practice_kill = 0
    unit.exp_rate = 1
    unit.gold_rate = 1
    -- 戒指
    unit.ringCount = 0                  --记录戒指数量
    unit.ringList = {}                  --记录最后获得的戒指
end
function HeroState:UpdateNetTable(hero)
    if hero then
        local lv = hero:GetLevel()
        local score = hero:GetPlayerOwner().Score
        local str = math.floor(hero:GetStrength())
        local agi = math.floor(hero:GetAgility())
        local int = math.floor(hero:GetIntellect())
        --local baseStr = math.floor(hero:GetBaseStrength())
        --local baseAgi = math.floor(hero:GetBaseAgility())
        --local baseInt = math.floor(hero:GetBaseIntellect())
        local defPoint = hero.def_point
        local bossPoint = hero.boss_point
        local praPoint = hero.practice_point
        local waveDef = hero.wave_def
        local totalGold = math.floor(hero.total_gold + self:GetTotalGoldPerTick())
        local totalDamage = 0
        for k,v in pairs(self.heroTable) do
            totalDamage = totalDamage + v.boss_damage
        end
        local damagePercent = math.floor((hero.boss_damage / totalDamage) * 100)
        if totalDamage == 0 then
            damagePercent = 0
        end
        CustomNetTables:SetTableValue( "scoreboard", tostring(hero:GetPlayerID()), { lv=lv,
                                                                                     score=score,
                                                                                     str = str, 
                                                                                     agi = agi, 
                                                                                     int = int, 
                                                                                     --baseStr = baseStr,
                                                                                     --baseAgi = baseAgi, 
                                                                                     --baseInt = baseInt,  
                                                                                     wavedef = waveDef, 
                                                                                     damagesave = damagePercent, 
                                                                                     goldsave = totalGold })
        CustomNetTables:SetTableValue( "shop", tostring(hero:GetPlayerID()), { def_point=defPoint, boss_point=bossPoint, practice_point=praPoint})
    end
end
function HeroState:SendFinallyData()
    for i=1,#self.heroTable do
        local hero = self.heroTable[i]
        if hero then
            local practice = hero.practice_kill
            local strGain = hero.str_gain + hero:GetStrengthGain()
            local agiGain = hero.agi_gain + hero:GetAgilityGain()
            local intGain = hero.int_gain + hero:GetIntellectGain()
            local expRate = hero.exp_rate * 100 + 100
            local goldRate = hero.gold_rate * 100 + 100
            local itemTable = {}
            for i=1,6 do
                local item = hero.bag_item[i]
                if item and not item:IsNull() then
                    itemTable[i] = item:GetAbilityName()
                end
            end
            local netTable = {
                practice=practice,
                exp_rate=expRate,
                gold_rate=goldRate,
                strgain=strGain,
                agigain=agiGain,
                intgain=intGain,
                item1 = itemTable[1],
                item2 = itemTable[2],
                item3 = itemTable[3],
                item4 = itemTable[4],
                item5 = itemTable[5],
                item6 = itemTable[6]
            }
            CustomNetTables:SetTableValue( "end_screen", tostring(hero:GetPlayerID()), netTable )
        end
    end
end
function HeroState:UpdateItemInSlot(hero)
    if hero then
        for i=0,5 do
            local item = hero:GetItemInSlot(i)
            if item then
                hero.bag_item[i+1] = item
            end
        end
    end
    self:CheckItemOnly(hero)
end
function HeroState:CheckItemOnly(hero)
    if hero then
        for slot=0,11 do
            local itemType = "thing"
            local nextItemType = "nothing"
            local item = hero:GetItemInSlot(slot)
            if item then
                itemType = "thing"
                if GameRules.ItemInfoKV[item:GetAbilityName()] then
                    itemType = GameRules.ItemInfoKV[item:GetAbilityName()].itemType
                end
            end
            for nextSolt = slot + 1, 11 do
                local nextItem = hero:GetItemInSlot(nextSolt)
                if nextItem then
                    nextItemType = "nothing"
                    if GameRules.ItemInfoKV[nextItem:GetAbilityName()] then
                        nextItemType = GameRules.ItemInfoKV[nextItem:GetAbilityName()].itemType
                    end
                end
                if itemType == nextItemType then
                    DropItem(nextItem, hero)
                    Notifications:Bottom(hero:GetPlayerID(), {text="#eqiut_limit", style={color="red"}, duration=1, continue = false})
                    break
                end
            end
        end
    end
end
function HeroState:GetTotalGoldPerTick(hero)
    local difficulty = GameRules:GetDifficulty()
    local time = GameRules:GetGameTime() - GuardingAthena.GameStartTime - 30
    local initGold = 400 - difficulty * 100
    local goldPerTick = 12 - 3 * difficulty
    if initGold <= 0 then
        initGold =  0
    end
    if goldPerTick <= 0 then
        goldPerTick = 0
    end
    local totalGoldPerTick = goldPerTick * time
    if time < 0 then
        totalGoldPerTick = 0
    end
    local totalGold = math.floor(totalGoldPerTick + initGold)
    if totalGold < 0 then
        totalGold = 0
    end
    return totalGold
end