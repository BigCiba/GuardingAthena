function OriginalPick( keys )
    local caster = keys.caster
    local ability = keys.ability
    local abilityName = ability:GetAbilityName()
    local hasOriginal = false
    for i=0,5 do
        local item = caster:GetItemInSlot(i)
        if item then
            local itemName = item:GetAbilityName() or 0
            if string.sub(itemName,0,14) == "item_original_" and tonumber(string.sub(itemName,19,string.len(itemName))) ~= 15 then
                local charges = item:GetCurrentCharges()
                item:SetCurrentCharges(charges + 100)
                if charges + 100 >= 150 then
                    caster:RemoveItem(item)
                    local newItem
                    if caster:IsRealHero() then
                        newItem = CreateItem(string.sub(itemName,0,18)..(tonumber(string.sub(itemName,19,string.len(itemName))) + 1), caster, caster)
                    else
                        newItem = CreateItem(string.sub(itemName,0,18)..(tonumber(string.sub(itemName,19,string.len(itemName))) + 1), caster.currentHero, caster.currentHero)
                    end
                    caster:AddItem(newItem)
                    if tonumber(string.sub(newItem:GetAbilityName(),19,string.len(itemName))) ~= 15 then
                        newItem:SetCurrentCharges(charges - 50)
                    end
                end
                hasOriginal = true
                break
            end
        end
    end
    if hasOriginal == false then
        local newItem = CreateItem(string.sub(abilityName,0,18)..tonumber(1), caster, caster)
        caster:AddItem(newItem)
    end
    caster:Stop()
    local tableitem = Entities:FindAllByName(abilityName)
    for i=1,#tableitem do
        if tableitem[i]:GetOwner() then
            tableitem[i]:RemoveSelf()
        end
    end
end
function OriginalKill( keys )
    local caster = keys.caster
    local ability = keys.ability
    for i=0,5 do
        local item = caster:GetItemInSlot(i)
        if item then
            local itemName = item:GetAbilityName() or 0
            if item and ability:GetAbilityName() == itemName then
                local charges = item:GetCurrentCharges()
                item:SetCurrentCharges(charges + 1)
                if charges >= 149 then
                    caster:RemoveItem(item)
                    local newItem = CreateItem(string.sub(itemName,0,18)..(tonumber(string.sub(itemName,19,string.len(itemName))) + 1), caster, caster)
                    caster:AddItem(newItem)
                end
                break
            end
        end
    end
end
function RemoveItem( keys )
    --[[local abilityName = keys.ability:GetAbilityName()
    local tableitem = Entities:FindAllByName(abilityName)
    for i=1,#tableitem do
        if tableitem[i]:GetOwner() then
            tableitem[i]:RemoveSelf()
        end
    end]]--
end
function Clarity( keys )
    local caster = keys.caster
    local ability = keys.ability
    local abilityName = ability:GetAbilityName()
    local modifierName = "modifier_"..abilityName
    if caster:IsRealHero() then
        ability:ApplyDataDrivenModifier(caster,caster,modifierName,nil)
    else
        local target = caster.currentHero
        ability:ApplyDataDrivenModifier(target,target,modifierName,nil)
        EmitSoundOn("DOTA_Item.ClarityPotion.Activate",target)
    end
end
function Salve( keys )
    local caster = keys.caster
    local ability = keys.ability
    local abilityName = ability:GetAbilityName()
    local modifierName = "modifier_"..abilityName
    if caster:IsRealHero() then
        ability:ApplyDataDrivenModifier(caster,caster,modifierName,nil)
    else
        local target = caster.currentHero
        ability:ApplyDataDrivenModifier(target,target,modifierName,nil)
        EmitSoundOn("DOTA_Item.HealingSalve.Activate",target)
    end
end
function HealPercent( keys )
    local caster = keys.caster
    local percent = keys.Percent
    local healamount = caster:GetMaxHealth() * percent * 0.01
    local manaamount = caster:GetMaxMana() * percent * 0.01
    Heal(caster, healamount, manaamount)
end
function item_huixue(keys)
    keys.caster:Heal(keys.HealthRestore, keys.caster)
    keys.caster:GiveMana(keys.ManaRestore)
    
    --Reduce the charges left on the item by 1.  Remove the item if there are no charges left.
    local new_charges = keys.ability:GetCurrentCharges() - 1
    if new_charges <= 0 then
        keys.caster:RemoveItem(keys.ability)
    else  --new_charges > 0 
        keys.ability:SetCurrentCharges(new_charges)
    end
end
function item_blink1_on_spell_start (keys)
    --PrintTable(keys)
    local point = keys.target_points[1]
    local caster = keys.caster
    local casterPos = caster:GetAbsOrigin()
    local pid = caster:GetPlayerID()
    local difference = point - casterPos
    local ability = keys.ability
    local range = ability:GetLevelSpecialValueFor("blink_range", (ability:GetLevel() - 1))
    
    ProjectileManager:ProjectileDodge(caster)

    if difference:Length2D() > range then
        point = casterPos + (point - casterPos):Normalized() * range
    end

    SetUnitPosition(caster, point) 
end
function invoker_chaos_meteor_datadriven_on_spell_start(keys)
    local caster_point = keys.caster:GetAbsOrigin()
    local target_point = keys.target_points[1]
    
    local caster_point_temp = Vector(caster_point.x, caster_point.y, 0)
    local target_point_temp = Vector(target_point.x, target_point.y, 0)
    
    local point_difference_normalized = (target_point_temp - caster_point_temp):Normalized()
    local velocity_per_second = point_difference_normalized * keys.TravelSpeed
    keys.caster:EmitSound("Hero_Invoker.ChaosMeteor.Loop")

    local chaos_demon = {
                            "boss_chaos_demon_1",
                            "boss_chaos_demon_2",
                            "boss_chaos_demon_3",
                            "boss_chaos_demon_4",
                            "boss_chaos_demon_5",
                            "boss_chaos_demon_6",
                        }
    local randomDemon = RandomInt(1, 6)           
    --Create a particle effect consisting of the meteor falling from the sky and landing at the target point.
    local meteor_fly_original_point = (target_point - (velocity_per_second * keys.LandTime)) + Vector (0, 0, 1000)  --Start the meteor in the air in a place where it'll be moving the same speed when flying and when rolling.
    local chaos_meteor_fly_particle_effect = CreateParticle("particles/units/heroes/hero_invoker/invoker_chaos_meteor_fly.vpcf", PATTACH_ABSORIGIN, keys.caster)
    ParticleManager:SetParticleControl(chaos_meteor_fly_particle_effect, 0, meteor_fly_original_point)
    ParticleManager:SetParticleControl(chaos_meteor_fly_particle_effect, 1, target_point)
    ParticleManager:SetParticleControl(chaos_meteor_fly_particle_effect, 2, Vector(1.3, 0, 0))
    Timers:CreateTimer(1.3,function ()
        local chaoland = CreateParticle("particles/units/heroes/hero_warlock/warlock_rain_of_chaos_start.vpcf", PATTACH_ABSORIGIN, keys.caster)
        ParticleManager:SetParticleControl(chaoland, 0, target_point)
        ParticleManager:SetParticleControl(chaoland, 1, target_point)
        ParticleManager:SetParticleControl(chaoland, 2, target_point)
        keys.caster:EmitSound("Hero_Warlock.RainOfChaos_buildup")
        keys.caster:StopSound("Hero_Invoker.ChaosMeteor.Loop")
    end)
    Timers:CreateTimer(1.5,function ()
        local chaoland_1 = CreateParticle("particles/units/heroes/hero_warlock/warlock_rain_of_chaos.vpcf", PATTACH_ABSORIGIN, keys.caster)
        ParticleManager:SetParticleControl(chaoland_1, 0, target_point)
        ParticleManager:SetParticleControl(chaoland_1, 1, target_point)
        ParticleManager:SetParticleControl(chaoland_1, 2, target_point)
        ParticleManager:SetParticleControl(chaoland_1, 5, target_point)
        keys.caster:EmitSound("Hero_Warlock.RainOfChaos")
        PrecacheUnitByNameAsync(chaos_demon[randomDemon],
            function()
                local unit = CreateUnitByName(chaos_demon[randomDemon], target_point, true, nil, nil, DOTA_TEAM_BADGUYS )
                local forward = Vector(RandomFloat(-150,150),RandomFloat(-150,150),0):Normalized()
                unit:SetForwardVector(forward)
        end)
        local targets = keys.target_entities
        local damageType = DAMAGE_TYPE_PURE
        for i,unit in pairs(targets) do
            CauseDamage(caster,unit,20000,damageType)
        end
    end)
end

function item_refresher1_on_spell_start(keys)
    --Refresh all abilities on the caster.
    for i=0, 15, 1 do  --The maximum number of abilities a unit can have is currently 16.
        local current_ability = keys.caster:GetAbilityByIndex(i)
        if current_ability ~= nil then
            current_ability:EndCooldown()
        end
    end
    
    --Refresh all items the caster has.
    for i=0, 5, 1 do
        local current_item = keys.caster:GetItemInSlot(i)
        if current_item ~= nil then
            if current_item:GetName() ~= "item_refresher1" then  --Refresher Orb does not refresh itself.
                current_item:EndCooldown()
            end
        end
    end
end
function AddCooldownReduceRate(keys)
    local caster = keys.caster
    local reduceRate = keys.ReduceRate * 0.01 
    local reduceRateOld = caster.reduceRate or 0
    reduceRateNew = reduceRateOld + reduceRate
    caster.reduceRate = reduceRateNew
    --print("add"..caster.reduceRate)
end

function RemoveCooldownReduceRate(keys)
    local caster = keys.caster
    local reduceRate = keys.ReduceRate * 0.01 
    local reduceRateOld = caster.reduceRate or 0
    reduceRateNew = reduceRateOld - reduceRate
    caster.reduceRate = reduceRateNew
    --print("remove"..caster.reduceRate)
end
function AddMagicDamage(keys)
    local caster = keys.caster
    local magicDamage = keys.BonusDamage
    local magicDamageOld = caster.bonus_magic_damage or 0
    magicDamageNew = magicDamageOld + magicDamage
    caster.bonus_magic_damage = magicDamageNew
end

function RemoveMagicDamage(keys)
    local caster = keys.caster
    local magicDamage = keys.BonusDamage
    local magicDamageOld = caster.bonus_magic_damage or 0
    magicDamageNew = magicDamageOld - magicDamage
    if magicDamageNew > 0 then
        caster.bonus_magic_damage = magicDamageNew
    else
        caster.bonus_magic_damage = 0
    end
end
function AddPhysicalDamage(keys)
    local caster = keys.caster
    local physicalDamage = keys.BonusDamage
    local physicalDamageOld = caster.bonus_physical_damage or 0
    physicalDamageNew = physicalDamageOld + physicalDamage
    caster.bonus_physical_damage = physicalDamageNew
end

function RemovePhysicalDamage(keys)
    local caster = keys.caster
    local physicalDamage = keys.BonusDamage
    local physicalDamageOld = caster.bonus_physical_damage or 0
    physicalDamageNew = physicalDamageOld - physicalDamage
    if physicalDamageNew > 0 then
        caster.bonus_physical_damage = physicalDamageNew
    else
        caster.bonus_physical_damage = 0
    end
end
function JianCreated( t )
    local caster = t.caster
    caster.bonus_physical_damage = true
end
function JianRemove( t )
    local caster = t.caster
    caster.bonus_physical_damage = false
end
function chui( t )
    local caster = t.caster
    local ability = t.ability
    local radius = ability:GetSpecialValueFor("radius")
    local damage = caster:GetPrimaryStatValue() * ability:GetSpecialValueFor("damage")
    local damageType = ability:GetAbilityDamageType()
    local unitGroup = GetUnitsInRadius(caster,ability,caster:GetAbsOrigin(),radius)
    for k,v in pairs(unitGroup) do
        CauseDamage(caster,v,damage,damageType,ability)
        local p = CreateParticle("particles/units/heroes/hero_zuus/zuus_arc_lightning_head.vpcf",PATTACH_CUSTOMORIGIN,caster,1)
        ParticleManager:SetParticleControlEnt(p, 0, caster, PATTACH_CUSTOMORIGIN_FOLLOW, "attach_origin", caster:GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(p, 1, v, PATTACH_CUSTOMORIGIN_FOLLOW, "attach_origin", v:GetAbsOrigin(), true)
    end
end
function jiancd4( keys )
    local caster = keys.caster
    local primaryAttribute = caster:GetPrimaryAttribute()
    local attribute = 0
    if primaryAttribute == 0 then
        attribute = caster:GetBaseStrength() * 0.5
    elseif primaryAttribute == 1 then
        attribute = caster:GetBaseAgility() * 0.5
    elseif primaryAttribute == 2 then
        attribute = caster:GetBaseIntellect() * 0.5
    end
    PropertySystem(caster, caster:GetPrimaryAttribute(), attribute, 10)
end
function BloodFruit( keys )
    local caster = keys.caster
    local level = GuardingAthena.clotho_lv
    caster.str_gain = caster.str_gain + 1
    caster.agi_gain = caster.agi_gain + 1
    caster.int_gain = caster.int_gain + 1
    PropertySystem(caster, caster:GetPrimaryAttribute(), RandomInt(level, level * 5))
end
function ExpFruit( keys )
    local caster = keys.caster
    local level = GuardingAthena.clotho_lv
    PropertySystem(caster, caster:GetPrimaryAttribute(), RandomInt(level, level * 5))
    caster.exp_rate = caster.exp_rate + 0.1
end
function GoldFruit( keys )
    local caster = keys.caster
    local level = GuardingAthena.clotho_lv
    PropertySystem(caster, caster:GetPrimaryAttribute(), RandomInt(level, level * 5))
    caster.gold_rate = caster.gold_rate + 0.1
end
function FenLie( t )
    local caster = t.caster
    local target = t.target
    local ability = t.ability
    local bonus_attack = ability:GetSpecialValueFor("bonus_attack")
    local unitGroup = GetUnitsInRadius(caster,ability,target:GetAbsOrigin(),700)
    local finalGroup = {}
    for i,v in ipairs(unitGroup) do
        if i <= bonus_attack then
            table.insert( finalGroup, v )
            CreateTrackingProjectile(caster,v,ability,caster:GetRangedProjectileName(),1200)
        else
            break
        end
    end
    if #finalGroup < bonus_attack then
        for i=1,bonus_attack - #finalGroup do
            for k,v in pairs(unitGroup) do
                CreateTrackingProjectile(caster,v,ability,caster:GetRangedProjectileName(),1200)
            end
        end
    end
end
function OnProjectileHitUnit( t )
    local caster = t.caster
    local target = t.target
    local ability = t.ability
    local damage = caster:GetAverageTrueAttackDamage(damage)
    local damageType = ability:GetAbilityDamageType()
    CauseDamage(caster,target,damage,damageType,ability)
end
function RangeCheck( keys )
    local caster = keys.caster
    local ability = keys.ability
    if not caster:IsRangedAttacker() then
        caster:RemoveModifierByName("modifier_item_gong_fenlie")
    else
        if not caster:HasModifier("modifier_item_gong_fenlie") then
            ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_gong_fenlie", nil )
        end
    end
end
function RangerCheck( keys )
    local caster = keys.caster
    local ability = keys.ability
    local itemName = ability:GetAbilityName()
    if caster:IsRangedAttacker() then
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_fenlie_"..itemName, nil )
    end
end
function RangerRemove( keys )
    local caster = keys.caster
    local ability = keys.ability
    local itemName = ability:GetAbilityName()
    --print(itemName.."remove")
    if caster:IsRangedAttacker() then
        caster:RemoveModifierByName("modifier_fenlie_"..itemName)
    end
end
function FuMoCheck( keys )
    local caster = keys.caster
    local ability = keys.ability
    local itemName = ability:GetAbilityName()
    if caster.fumo ~= nil then
        if caster.fumo == "xixue" then
            ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_fumo_xixue", ability )
        elseif caster.fumo == "jianjia" then
            ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_fumo_jianjia", ability )
        elseif caster.fumo == "mokang" then
            ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_fumo_mokang", ability )
        elseif caster.fumo == "baoji" then
            ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_fumo_baoji", ability )
        end
    end
end
function FuMoRemove( keys )
    local caster = keys.caster
    local ability = keys.ability
    local itemName = ability:GetAbilityName()
    if caster.fumo == "xixue" then
        caster:RemoveModifierByName("modifier_item_fumo_xixue")
    elseif caster.fumo == "jianjia" then
        caster:RemoveModifierByName("modifier_item_fumo_jianjia")
    elseif caster.fumo == "mokang" then
        caster:RemoveModifierByName("modifier_item_fumo_mokang")
    elseif caster.fumo == "baoji" then
        caster:RemoveModifierByName("modifier_item_fumo_baoji")
    end
end
function FuMo( keys )
    local caster = keys.caster
    local fumo = keys.FuMo
    if caster.fumo == nil then
        caster.fumo = fumo
    else
        older_fumo = caster.fumo
        caster.fumo = nil
        caster:RemoveModifierByName("modifier_item_fumo_"..older_fumo)
        caster.fumo = fumo
    end
end
function ZhanGu( keys )
    local caster = keys.caster
    local ability = keys.ability
    for i=0,5 do
        local item = caster:GetItemInSlot(i)
        if item then
            local itemName = item:GetAbilityName() or 0
            if item and ability:GetAbilityName() == itemName then
                local charges = item:GetCurrentCharges()
                item:SetCurrentCharges(charges + 1)
                break
            end
        end
    end
end
function ZhanGuSpell( keys )
    local caster = keys.caster
    local ability = keys.ability
    for i=0,5 do
        local item = caster:GetItemInSlot(i)
        if item then
            local itemName = item:GetAbilityName() or 0
            if item and ability:GetAbilityName() == itemName then
                local charges = item:GetCurrentCharges()
                item:SetCurrentCharges(0)
                Heal(caster, charges * 20, charges * 8)
                break
            end
        end
    end
end
function ItemCooldown( keys )
    local caster = keys.caster
    local ability = keys.ability
    Timers:CreateTimer(2,function ()
        for i=0,5 do
            local item = caster:GetItemInSlot(i)
            if item then
                local itemName = item:GetAbilityName() or 0
                if item and ability:GetAbilityName() == itemName then
                    ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_chui_stun", nil )
                    break
                end
            end
        end
    end)
end
function FuKill( keys )
    local caster = keys.caster
    local target = keys.unit
    local ability = keys.ability
    local target_location = target:GetAbsOrigin()
    local damage = caster:GetAverageTrueAttackDamage(caster)
    local radius = 270
    local teamNumber = caster:GetTeamNumber()
    local targetTeam = ability:GetAbilityTargetTeam()
    local targetType = ability:GetAbilityTargetType()
    local targetFlag = ability:GetAbilityTargetFlags()
    local damageType = ability:GetAbilityDamageType()
    local units = FindUnitsInRadius(teamNumber, target_location, caster, radius, targetTeam, targetType, targetFlag, 0, false)
    for k, v in pairs( units ) do
        CauseDamage(caster,v,damage,damageType,ability)
    end
end
function MeleeCheck( keys )
    local caster = keys.caster
    local ability = keys.ability
    caster.MeleeCheckTimer = Timers:CreateTimer(function ()
        if caster:IsRangedAttacker() then
            caster:RemoveModifierByName("modifier_item_fu_cleave")
        else
            if not caster:HasModifier("modifier_item_fu_cleave") then
                ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_fu_cleave", nil )
            end
        end
        return 1
    end)
end
function OnFuDestory( t )
    Timers:RemoveTimer(t.caster.MeleeCheckTimer)
end
local timeTable = {
            am0 = 0,
            am2 = 0.08299,
            am6 = 0.25099,
            am8 = 0.33419,
            am12 = 0.50059,
            pm18 = 0.75019,
            pm24 = 0.99979
        }
local ringTable = {
    ringName = {"item_ring_1","item_ring_2","item_ring_3","item_ring_4","item_ring_5","item_ring_6"},
    timeStart = {timeTable.am6,timeTable.am8,timeTable.am12,timeTable.pm18,timeTable.am0,timeTable.am2},
    timeOver = {timeTable.am8,timeTable.am12,timeTable.pm18,timeTable.pm24,timeTable.am2,timeTable.am6},
}
function RingCreate( t )
    local caster = t.caster
    local ability = t.ability
    if caster.caster_hero then
        return
    end
    ability.active = false
    local abilityName = ability:GetAbilityName()
    local timeStart
    local timeOver
    local modifierName
    for i=1,6 do
        if abilityName == ringTable.ringName[i] then
            timeStart = ringTable.timeStart[i]
            timeOver = ringTable.timeOver[i]
            modifierName = "ring_0_"..i
            break
        end
    end
    ability.timer = Timers:CreateTimer(function ()
        if not ability.active then
            local time = GameRules:GetTimeOfDay()
            if time > timeStart and time < timeOver then
                caster:AddNewModifier(caster,ability,modifierName,{})
            else
                caster:RemoveModifierByName(modifierName)
            end 
        end
        return 0.2
    end)
end
function RingRemove( t )
    local caster = t.caster
    local ability = t.ability
    if caster.caster_hero then
        return
    end
    local abilityName = ability:GetAbilityName()
    local modifierName
    for i=1,6 do
        if abilityName == ringTable.ringName[i] then
            modifierName = "ring_0_"..i
            break
        end
    end
    caster:RemoveModifierByName(modifierName)
    Timers:RemoveTimer(ability.timer)
end
function RingActive( t )
    local caster = t.caster
    local ability = t.ability
    local abilityName = ability:GetAbilityName()
    local modifierName
    for i=1,6 do
        if abilityName == ringTable.ringName[i] then
            modifierName = "ring_0_"..i
            break
        end
    end
    caster:AddNewModifier(caster,ability,modifierName,{duration=10})
    ability.active = true
    Timers:CreateTimer(10,function ()
        ability.active = false
    end)
end
LinkLuaModifier("ring_0_1","modifiers/ring/ring_0_1.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ring_0_2","modifiers/ring/ring_0_2.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ring_0_3","modifiers/ring/ring_0_3.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ring_0_4","modifiers/ring/ring_0_4.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ring_0_5","modifiers/ring/ring_0_5.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ring_0_6","modifiers/ring/ring_0_6.lua",LUA_MODIFIER_MOTION_NONE)
function RingSecretCreate( t )
    local caster = t.caster
    local ability = t.ability
    if caster.caster_hero then
        return
    end
    ability.active = false
    local ring_2 = caster.ringList[table.getn(caster.ringList)]
    local ring_1 = caster.ringList[table.getn(caster.ringList)-1]
    if ring_2 < ring_1 then
        ring_1 = caster.ringList[table.getn(caster.ringList)]
        ring_2 = caster.ringList[table.getn(caster.ringList)-1]
    end
    local ring_1_name = "ring_0_"..ring_1
    local ring_2_name = "ring_0_"..ring_2
    local ring_secret = "ring_"..ring_1.."_"..ring_2
    local ringName = {"item_ring_"..ring_1,"item_ring_"..ring_2}
    local timeStart = {}
    local timeOver = {}
    for j=1,2 do
        for i=1,6 do
            if ringName[j] == ringTable.ringName[i] then
                timeStart[j] = ringTable.timeStart[i]
                timeOver[j] = ringTable.timeOver[i]
                break
            end
        end
    end
    ability.timer = Timers:CreateTimer(function ()
        if not ability.active then
            local time = GameRules:GetTimeOfDay()
            if time > timeStart[1] and time < timeOver[1] then
                caster:AddNewModifier(caster,ability,ring_secret,{})
                caster:AddNewModifier(caster,ability,ring_1_name,{})
                caster:AddNewModifier(caster,ability,ring_2_name,{})
            elseif time > timeStart[2] and time < timeOver[2] then
                caster:AddNewModifier(caster,ability,ring_secret,{})
                caster:AddNewModifier(caster,ability,ring_1_name,{})
                caster:AddNewModifier(caster,ability,ring_2_name,{})
            else
                caster:RemoveModifierByName(ring_secret)
                caster:RemoveModifierByName(ring_1_name)
                caster:RemoveModifierByName(ring_2_name)
            end 
        end
        return 0.2
    end)
end
function RingSecretRemove( t )
    local caster = t.caster
    local ability = t.ability
    if caster.caster_hero then
        return
    end
    if caster.ringList == nil then
        return
    end
    local ring_2 = caster.ringList[table.getn(caster.ringList)]
    local ring_1 = caster.ringList[table.getn(caster.ringList)-1]
    if ring_2 < ring_1 then
        ring_1 = caster.ringList[table.getn(caster.ringList)]
        ring_2 = caster.ringList[table.getn(caster.ringList)-1]
    end
    local ring_1_name = "ring_0_"..ring_1
    local ring_2_name = "ring_0_"..ring_2
    local ring_secret = "ring_"..ring_1.."_"..ring_2
    caster:RemoveModifierByName(ring_secret)
    caster:RemoveModifierByName(ring_1_name)
    caster:RemoveModifierByName(ring_2_name)
    Timers:RemoveTimer(ability.timer)
end
function RingSecretActive( t )
    local caster = t.caster
    local ability = t.ability
    local ring_2 = caster.ringList[table.getn(caster.ringList)]
    local ring_1 = caster.ringList[table.getn(caster.ringList)-1]
    if ring_2 < ring_1 then
        ring_1 = caster.ringList[table.getn(caster.ringList)]
        ring_2 = caster.ringList[table.getn(caster.ringList)-1]
    end
    local ring_1_name = "ring_0_"..ring_1
    local ring_2_name = "ring_0_"..ring_2
    local ring_secret = "ring_"..ring_1.."_"..ring_2
    caster:AddNewModifier(caster,ability,ring_secret,{duration=10})
    caster:AddNewModifier(caster,ability,ring_1_name,{duration=10})
    caster:AddNewModifier(caster,ability,ring_2_name,{duration=10})
    ability.active = true
    Timers:CreateTimer(10,function ()
        ability.active = false
    end)
end
-- 创世之戒
function RingWorldCreate( t )
    local caster = t.caster
    local ability = t.ability
    if caster.caster_hero then
        return
    end
    local ring_2 = caster.ringList[table.getn(caster.ringList)]
    local ring_1 = caster.ringList[table.getn(caster.ringList)-1]
    if ring_2 < ring_1 then
        ring_1 = caster.ringList[table.getn(caster.ringList)]
        ring_2 = caster.ringList[table.getn(caster.ringList)-1]
    end
    local ring_1_name = "ring_0_"..ring_1
    local ring_2_name = "ring_0_"..ring_2
    local ring_world = "ring_"..ring_1.."_"..ring_2
    ability.timer = Timers:CreateTimer(function ()
        caster:AddNewModifier(caster,ability,ring_world,{})
        caster:AddNewModifier(caster,ability,ring_1_name,{})
        caster:AddNewModifier(caster,ability,ring_2_name,{})
        return 0.2
    end)
end
function RingWorldRemove( t )
    local caster = t.caster
    local ability = t.ability
    if caster.caster_hero then
        return
    end
    if caster.ringList == nil then
        return
    end
    local ring_2 = caster.ringList[table.getn(caster.ringList)]
    local ring_1 = caster.ringList[table.getn(caster.ringList)-1]
    if ring_2 < ring_1 then
        ring_1 = caster.ringList[table.getn(caster.ringList)]
        ring_2 = caster.ringList[table.getn(caster.ringList)-1]
    end
    local ring_1_name = "ring_0_"..ring_1
    local ring_2_name = "ring_0_"..ring_2
    local ring_world = "ring_"..ring_1.."_"..ring_2
    caster:RemoveModifierByName(ring_world)
    caster:RemoveModifierByName(ring_1_name)
    caster:RemoveModifierByName(ring_2_name)
    Timers:RemoveTimer(ability.timer)
end
LinkLuaModifier("ring_1_1","modifiers/ring/ring_1_1.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ring_1_2","modifiers/ring/ring_1_2.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ring_1_3","modifiers/ring/ring_1_3.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ring_1_4","modifiers/ring/ring_1_4.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ring_1_5","modifiers/ring/ring_1_5.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ring_1_6","modifiers/ring/ring_1_6.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ring_2_2","modifiers/ring/ring_2_2.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ring_2_3","modifiers/ring/ring_2_3.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ring_2_4","modifiers/ring/ring_2_4.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ring_2_5","modifiers/ring/ring_2_5.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ring_2_6","modifiers/ring/ring_2_6.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ring_3_3","modifiers/ring/ring_3_3.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ring_3_4","modifiers/ring/ring_3_4.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ring_3_5","modifiers/ring/ring_3_5.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ring_3_6","modifiers/ring/ring_3_6.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ring_4_4","modifiers/ring/ring_4_4.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ring_4_5","modifiers/ring/ring_4_5.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ring_4_6","modifiers/ring/ring_4_6.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ring_5_5","modifiers/ring/ring_5_5.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ring_5_6","modifiers/ring/ring_5_6.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("ring_6_6","modifiers/ring/ring_6_6.lua",LUA_MODIFIER_MOTION_NONE)
function ApplyRingCooldown( keys )
    local caster = keys.caster
    local reduction_const = caster.reduction_const or 0
    caster.reduction_const = reduction_const + 1
    --print(caster.reduction_const)
end
function RemoveRingCooldown( keys )
    local caster = keys.caster
    local reduction_const = caster.reduction_const or 0
    caster.reduction_const = reduction_const - 1
end
function Ring_1_2( keys )
    local caster = keys.caster
    local ability = keys.ability
    local time = GameRules:GetTimeOfDay()
    if time > 0.25099 and time < 0.33419 then
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_ring_1_2_buff", nil )
    elseif time > 0.33419 and time < 0.50059 then
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_ring_1_2_buff", nil )
    else
        caster:RemoveModifierByName("modifier_item_ring_1_2_buff")
    end
end
function Ring_1_2_Buff( keys )
    local caster = keys.caster
    local healamount = caster:GetMaxHealth() * 0.1
    Heal(caster, healamount, 0)
end
function Ring_1_6( keys )
    local caster = keys.caster
    local ability = keys.ability
    local time = GameRules:GetTimeOfDay()
    if time > 0.25099 and time < 0.33419 then
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_ring_1_6_buff", nil )
    elseif time > 0.08299 and time < 0.25099 then
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_ring_1_6_buff", nil )
    else
        caster:RemoveModifierByName("modifier_item_ring_1_6_buff")
    end
end
function Ring_3_6( keys )
    local caster = keys.caster
    local ability = keys.ability
    local time = GameRules:GetTimeOfDay()
    if time > 0.50059 and time < 0.75019 then
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_ring_3_6_buff", nil )
    elseif time > 0.08299 and time < 0.25099 then
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_ring_3_6_buff", nil )
    else
        caster:RemoveModifierByName("modifier_item_ring_3_6_buff")
    end
end
function Ring_3_6_Buff( keys )
    local caster = keys.caster
    if keys.event_ability:IsItem() then
        return
    end
    if keys.event_ability:IsToggle() then
        return
    end
    if keys.event_ability:GetCooldown(1) == 0 then
        return
    end
    local primaryAttribute = caster:GetPrimaryAttribute()
    local stats = 0
    if primaryAttribute == 0 then
        stats = caster:GetBaseStrength() * 0.1
    elseif primaryAttribute == 1 then
        stats = caster:GetBaseAgility() * 0.1
    elseif primaryAttribute == 2 then
        stats = caster:GetBaseIntellect() * 0.1
    end
    PropertySystem(caster,primaryAttribute,stats,10)
end
function Ring_3_4( keys )
    local caster = keys.caster
    local ability = keys.ability
    local time = GameRules:GetTimeOfDay()
    if time > 0.50059 and time < 0.75019 then
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_ring_3_4_buff", nil )
    elseif time > 0.75019 and time < 0.99979 then
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_ring_3_4_buff", nil )
    else
        caster:RemoveModifierByName("modifier_item_ring_3_4_buff")
    end
end
function Ring_4_5( keys )
    local caster = keys.caster
    local ability = keys.ability
    local time = GameRules:GetTimeOfDay()
    if time > 0.75019 and time < 0.99979 then
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_ring_4_5_buff", nil )
    elseif time > 0 and time < 0.08299 then
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_ring_4_5_buff", nil )
    else
        caster:RemoveModifierByName("modifier_item_ring_4_5_buff")
    end
end
function Ring_4_5_Buff( keys )
    local caster = keys.caster
    local target = keys.attacker
    local ability = keys.ability
    local damage = keys.DamageTaken
    local percent = damage / caster:GetMaxHealth()
    local target_damage = target:GetMaxHealth() * percent
    local damageType = DAMAGE_TYPE_PURE
    if target:IsAncient() then
        damageType = DAMAGE_TYPE_MAGICAL
        target_damage = target_damage * 0.5
    end
    Heal(caster,damage,0,false)
    CauseDamage(caster,target,target_damage,damageType,ability)
end
function Ring_2_6( keys )
    local caster = keys.caster
    local ability = keys.ability
    local time = GameRules:GetTimeOfDay()
    if time > 0.33419 and time < 0.50059 then
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_ring_2_6_buff", nil )
    elseif time > 0.08299 and time < 0.25099 then
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_ring_2_6_buff", nil )
    else
        caster:RemoveModifierByName("modifier_item_ring_2_6_buff")
    end
end
function Ring_2_6_Buff( keys )
    local caster = keys.caster
    local itemAbility = keys.ability
    if caster:HasModifier("modifier_item_ring_2_6_cooldown") == false then
        for i=1,16 do
            if caster:GetAbilityByIndex(i-1) then
                local ability = caster:GetAbilityByIndex(i-1)
                if ability:GetCooldownTimeRemaining() > 0 then
                    local cdRemaining = ability:GetCooldownTimeRemaining()
                    if cdRemaining < 1 then
                        cdRemaining = 1
                    end
                    ability:EndCooldown()
                    ability:StartCooldown( cdRemaining - 1 )
                end
            end
        end
        itemAbility:ApplyDataDrivenModifier(caster, caster, "modifier_item_ring_2_6_cooldown", {duration = 2} )
    end
end
function Ring_Broken( keys )
    local caster = keys.caster
    local ability = keys.ability
    local ring_1 = caster.ring_1
    local ring_2 = caster.ring_2
    local time = GameRules:GetTimeOfDay()
    if ring_1 == 1 or ring_2 == 1 then
        if time > 0.25099 and time < 0.33419 then
            ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_ring_1_buff", nil )
        else
            caster:RemoveModifierByName("modifier_item_ring_1_buff")
        end
    end
    if ring_1 == 2 or ring_2 == 2 then
        if time > 0.33419 and time < 0.50059 then
            ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_ring_2_buff", nil )
        else
            caster:RemoveModifierByName("modifier_item_ring_2_buff")
        end
    end
    if ring_1 == 3 or ring_2 == 3 then
        local statsGain = 0
        local primaryAttribute = caster:GetPrimaryAttribute()
        if time > 0.50059 and time < 0.75019 then
            if primaryAttribute == 0 then
                statsGain = caster:GetBaseStrength() * 0.1
                ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_ring_3_str", nil )
                caster:SetModifierStackCount("modifier_item_ring_3_str",caster,statsGain)
            elseif primaryAttribute == 1 then
                statsGain = caster:GetBaseAgility() * 0.1
                ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_ring_3_agi", nil )
                caster:SetModifierStackCount("modifier_item_ring_3_agi",caster,statsGain)
            elseif primaryAttribute == 2 then
                statsGain = caster:GetBaseIntellect() * 0.1
                ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_ring_3_int", nil )
                caster:SetModifierStackCount("modifier_item_ring_3_int",caster,statsGain)
            end
        else
            caster:RemoveModifierByName("modifier_item_ring_3_str")
            caster:RemoveModifierByName("modifier_item_ring_3_agi")
            caster:RemoveModifierByName("modifier_item_ring_3_int")
        end
    end
    if ring_1 == 4 or ring_2 == 4 then
        if time > 0.75019 and time < 0.99979 then
            ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_ring_4_buff", nil )
        else
            caster:RemoveModifierByName("modifier_item_ring_4_buff")
        end
    end
    if ring_1 == 5 or ring_2 == 5 then
        if time > 0 and time < 0.08299 then
            ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_ring_5_buff", nil )
        else
            caster:RemoveModifierByName("modifier_item_ring_5_buff")
        end
    end
    if ring_1 == 6 or ring_2 == 6 then
        if time > 0.08299 and time < 0.25099 then
            ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_ring_6_buff", nil )
        else
            caster:RemoveModifierByName("modifier_item_ring_6_buff")
        end
    end
end
function Ring_World_Broken( keys )
    local caster = keys.caster
    local ability = keys.ability
    local ring_1 = caster.ring_1
    local ring_2 = caster.ring_2
    local time = GameRules:GetTimeOfDay()
    if ring_1 == 1 or ring_2 == 1 then
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_ring_1_buff", nil )
    end
    if ring_1 == 2 or ring_2 == 2 then
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_ring_2_buff", nil )
    end
    if ring_1 == 3 or ring_2 == 3 then
        local statsGain = 0
        local primaryAttribute = caster:GetPrimaryAttribute()
        if primaryAttribute == 0 then
            statsGain = caster:GetBaseStrength() * 0.1
            ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_ring_3_str", nil )
            caster:SetModifierStackCount("modifier_item_ring_3_str",caster,statsGain)
        elseif primaryAttribute == 1 then
            statsGain = caster:GetBaseAgility() * 0.1
            ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_ring_3_agi", nil )
            caster:SetModifierStackCount("modifier_item_ring_3_agi",caster,statsGain)
        elseif primaryAttribute == 2 then
            statsGain = caster:GetBaseIntellect() * 0.1
            ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_ring_3_int", nil )
            caster:SetModifierStackCount("modifier_item_ring_3_int",caster,statsGain)
        end
    end
    if ring_1 == 4 or ring_2 == 4 then
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_ring_4_buff", nil )
    end
    if ring_1 == 5 or ring_2 == 5 then
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_ring_5_buff", nil )
    end
    if ring_1 == 6 or ring_2 == 6 then
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_ring_6_buff", nil )
    end
end
function Ring_World_3_4( keys )
    local caster = keys.caster
    local ability = keys.ability
    local statsGain = 0
    local primaryAttribute = caster:GetPrimaryAttribute()
    if primaryAttribute == 0 then
        statsGain = caster:GetBaseStrength() * 0.1
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_ring_3_str", nil )
        caster:SetModifierStackCount("modifier_item_ring_3_str",caster,statsGain)
    elseif primaryAttribute == 1 then
        statsGain = caster:GetBaseAgility() * 0.1
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_ring_3_agi", nil )
        caster:SetModifierStackCount("modifier_item_ring_3_agi",caster,statsGain)
    elseif primaryAttribute == 2 then
        statsGain = caster:GetBaseIntellect() * 0.1
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_ring_3_int", nil )
        caster:SetModifierStackCount("modifier_item_ring_3_int",caster,statsGain)
    end
end
function Ogre( keys )
    local caster = keys.caster
    local point = keys.target_points[1]
    local fxIndex = CreateParticle("particles/units/heroes/hero_centaur/centaur_warstomp.vpcf",PATTACH_CUSTOMORIGIN,caster,2)
    ParticleManager:SetParticleControl( fxIndex, 0, point )
    ParticleManager:SetParticleControl( fxIndex, 1, Vector(400,400,400) )
    ParticleManager:SetParticleControl( fxIndex, 2, point )
    ParticleManager:SetParticleControl( fxIndex, 3, point )
    ParticleManager:SetParticleControl( fxIndex, 5, point )
    ParticleManager:SetParticleControl( fxIndex, 6, point )
end
function Reborn_1( keys )
    local caster = keys.caster
    if caster:IsRealHero() then
        caster.can_reborn = true
    else
        caster.currentHero.can_reborn = true
    end
end
function Gem( t )
    local caster = t.caster
    local ability = t.ability
    local unitGroup = GetUnitsInRadius(caster,ability,caster:GetAbsOrigin(),1100)
    for k, v in pairs( unitGroup ) do
        v:AddNewModifier(caster, ability, "modifier_truesight", {duration=1})
    end
end
function JianJiaCreate( t )
    local caster = t.caster
    local target = t.target
    local reduce = t.reduce
    --local armor = target:GetPhysicalArmorBaseValue()
    --target.reduceArmor = math.floor(armor * reduce)
    --target:SetPhysicalArmorBaseValue(armor - target.reduceArmor)
end
function JianJiaRemove( t )
    local target = t.target
    --target:SetPhysicalArmorBaseValue(target:GetPhysicalArmorBaseValue() + target.reduceArmor)
end