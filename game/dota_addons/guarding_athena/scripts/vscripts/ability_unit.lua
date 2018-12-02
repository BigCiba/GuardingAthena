athena_sound = {
    "crystalmaiden_cm_lose_01",
    "crystalmaiden_cm_lose_05",
    "crystalmaiden_cm_anger_04",
    "crystalmaiden_cm_anger_05",
    "crystalmaiden_cm_anger_10",
    "crystalmaiden_cm_anger_11",
    "crystalmaiden_cm_pain_01",
    "crystalmaiden_cm_pain_02",
    "crystalmaiden_cm_pain_03",
    "crystalmaiden_cm_pain_04",
    "crystalmaiden_cm_pain_05",
    "crystalmaiden_cm_scream_01",
    "crystalmaiden_cm_scream_02",
    "crystalmaiden_cm_scream_03",
    "crystalmaiden_cm_underattack_01"
}
athena_sound_underattack = "crystalmaiden_cm_underattack_01"
function KvDamage( t )
    local caster = t.caster
    local target = t.target_entities or t.target
    local ability = t.ability
    local damage = t.damage
    local damageType = ability:GetAbilityDamageType() or DAMAGE_TYPE_PURE
    CauseDamage(caster,target,damage,damageType,ability)
end
function AthenaHeal( caster,ability )
	local hp = ability:GetSpecialValueFor("health") + GuardingAthena.athena_regen_lv * 40
	local mp = ability:GetSpecialValueFor("mana") + GuardingAthena.athena_regen_lv * 8
	local duration = ability:GetSpecialValueFor("duration") + GuardingAthena.athena_hp_lv
    local time = 0
    CreateParticle("particles/units/athena/athena_heal.vpcf",PATTACH_ABSORIGIN_FOLLOW,caster,duration)
    EmitSoundOn("Hero_Huskar.Inner_Vitality", caster)
	Timers:CreateTimer(function()
        if time < duration then
            Heal(caster,hp,mp,false)
            time = time + 1
            return 1
        end
    end)
end
function AthenaGuard()
    local caster = GuardingAthena.entAthena
    local ability = caster:FindAbilityByName("athena_guard")
    local duration = ability:GetSpecialValueFor("duration") + GuardingAthena.athena_hp_lv
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_athena_guard_aura", {duration=duration})
    local unitGroup = GetUnitsInRadius( caster, ability, caster:GetAbsOrigin(), 99999 )
    for k,v in pairs(unitGroup) do
	    v:AddNewModifier(caster,ability,"athena_guard",{duration=duration})
        EmitSoundOn("Hero_Lich.FrostArmor", v)
        local particle = CreateParticle("particles/units/heroes/hero_lich/lich_frost_armor.vpcf",PATTACH_OVERHEAD_FOLLOW,v,duration)
		ParticleManager:SetParticleControl(particle, 0, v:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle, 1, Vector(1,0,0))
		ParticleManager:SetParticleControlEnt(particle, 2, v, PATTACH_ABSORIGIN_FOLLOW, "attach_origin", v:GetAbsOrigin(), true)
    end
end
function AthenaArmorFix( t )
    local caster = t.caster
    local spawnedUnit = t.target
    if spawnedUnit:GetPhysicalArmorValue() > 0 then
        local fixStack = spawnedUnit:GetModifierStackCount("modifier_athena_guard_armor_fix", caster)
        local armor = spawnedUnit:GetPhysicalArmorValue() + fixStack
        local reduceOld = (armor * 0.05) / (1 + armor * 0.05)
        if reduceOld > 0.9 then reduceOld = 0.9 end
        local fixArmor = (0.9 * reduceOld) / (0.052 - 0.048 * reduceOld)
        fixStack = armor - fixArmor
        spawnedUnit:SetModifierStackCount("modifier_athena_guard_armor_fix", caster, fixStack)
    end
end
LinkLuaModifier("athena_guard","modifiers/unit/athena_guard.lua",LUA_MODIFIER_MOTION_NONE)
function AthenaOnAttacked( keys )
	local caster = keys.caster
    if caster.onattack == nil then
        caster.onattack = true
    end
	if caster.onattack then
        if RandomInt(1, 10) < 5 then
		    EmitGlobalSound(athena_sound[RandomInt(1, 14)])
        else
            EmitGlobalSound(athena_sound_underattack)
        end
		caster.onattack = false
		Timers:CreateTimer(1.5,function ()
			caster.onattack = true
		end)
	end
end
function QuestInit( t )
    local caster = t.caster
    Timers:CreateTimer(10,function ()
        local p1 = CreateParticle("particles/map/quest.vpcf",PATTACH_OVERHEAD_FOLLOW,caster)
        ParticleManager:SetParticleControlEnt(p1, 0, caster, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
    end)
end
function Ciba( keys )
    local caster = keys.caster
    local ability = keys.ability
    local targetTeam = ability:GetAbilityTargetTeam()
    local targetType = ability:GetAbilityTargetType()
    local targetFlag = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
    local damageType = DAMAGE_TYPE_PURE
    local time = 0
    Timers:CreateTimer(function ()
        if time < 60 then
            caster:MoveToPositionAggressive(Entities:FindByName( nil, "athena" ):GetAbsOrigin() + Vector(RandomInt(-900, 900),RandomInt(-900, 900),0))
            unitGroup = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), caster, 300, targetTeam, targetType, targetFlag, 0, false )
            for k, v in pairs( unitGroup ) do
                CauseDamage(caster,v,10000,damageType)
            end
            time = time + 1
            return 1
        end
    end)
end
function HealNormal( keys )
    local caster = keys.caster
    local healamount = keys.HealAmount
    Heal(caster,healamount)
end
function ApplyWingsCooldown( keys )
    local caster = keys.caster
    local reduction_const = caster.reduction_const or 0
    caster.reduction_const = reduction_const + 2
    local wingsType = "particles/skills/wing_sky.vpcf"
    if caster:GetUnitName() == "npc_dota_hero_omniknight" then wingsType = "particles/skills/wing_thunder.vpcf" end
    if caster:GetUnitName() == "npc_dota_hero_windrunner" then wingsType = "particles/skills/wing_wind.vpcf" end
    if caster:GetUnitName() == "npc_dota_hero_rubick" then wingsType = "particles/skills/wing_space.vpcf" end
    if caster:GetUnitName() == "npc_dota_hero_lina" then wingsType = "particles/skills/wing_fire.vpcf" end
    if caster:GetUnitName() == "npc_dota_hero_nevermore" then wingsType = "particles/skills/wing_hell.vpcf" end
    if caster:GetUnitName() == "npc_dota_hero_legion_commander" then wingsType = "particles/skills/wing_hell.vpcf" end
    if caster:GetUnitName() == "npc_dota_hero_fire_spirit" then wingsType = "particles/skills/wing_fire.vpcf" end
    if caster:GetUnitName() == "npc_dota_hero_revelater" then wingsType = "particles/skills/wing_sky.vpcf" end
    if caster:GetUnitName() == "npc_dota_hero_juggernaut" then wingsType = "particles/skills/wing_sky.vpcf" end
    if caster:GetUnitName() == "npc_dota_hero_antimage" then wingsType = "particles/skills/wing_sky.vpcf" end
    if caster:GetUnitName() == "npc_dota_hero_crystal_maiden" then wingsType = "particles/skills/wing_ice.vpcf" end
    if caster:GetUnitName() == "npc_dota_hero_monkey_king" then wingsType = "particles/skills/wing_sky.vpcf" end
    if caster:GetUnitName() == "npc_dota_hero_spectre" then wingsType = "particles/skills/wing_sky.vpcf" end
    CreateParticle(wingsType,PATTACH_ABSORIGIN_FOLLOW,caster)
end
function CourierBlink(keys)
	--PrintTable(keys)
	local point = keys.target_points[1]
	local caster = keys.caster
	SetUnitPosition(caster, point)	
end
function CourierSwap(t)
	local courier = t.caster
    local hero = courier.currentHero
    local courierItem = courier:GetItemInSlot(0)
    local HeroItem = hero:GetItemInSlot(0)
    courierItem = courier:TakeItem(courierItem)
    HeroItem = hero:TakeItem(HeroItem)
    courier:AddItem(HeroItem)
    hero:AddItem(courierItem)
end
function CourierTeleport( keys )
    local caster = keys.caster
    local target = caster.currentHero
    local caster_location = caster:GetAbsOrigin()
    local point = keys.target_points[1]
    Teleport(target, point)
    local p1 = CreateParticle( "particles/units/heroes/hero_keeper_of_the_light/keeper_of_the_light_recall_poof.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
end
function CourierSuicide( keys )
    local caster = keys.caster
    local target = caster.currentHero
    target:ForceKill(true)
end
function CourierBag( keys )
    local caster = keys.caster
    local itemTable = {}
    for i=0,5 do
        local item = caster:GetItemInSlot(i)
        if item then
            local newItem = caster:TakeItem(item)
            table.insert(itemTable, newItem)
        end
    end
    for i=1,6 do
        if caster.bag[i] then
            caster:AddItem(caster.bag[i])
        end
    end
    caster.bag = itemTable
end
function CourierAutoPotionToggle( keys )
    local caster = keys.caster
    local ability = keys.ability
    if keys.Toggle == 0 then
        ability:ApplyDataDrivenModifier(caster,caster,"modifier_courier_auto_potion",nil)
    elseif keys.Toggle == 1 then
        caster:RemoveModifierByName("modifier_courier_auto_potion")
    end
end
function CoutierAutoPotion( keys )
    local caster = keys.caster
    local hero = caster.currentHero
    local salveHealAmount = {600,1500,3000,6000}
    local clarityHealAmount = {150,300,800,2000}
    local salve
    local clarity
    local salveHeal = 0
    local clarityHeal = 0
    local salveLevel = 0
    local clarityLevel = 0
    for i=1,6 do
        local item = caster:GetItemInSlot(i-1)
        if item then
            local itemName = item:GetAbilityName()
            if string.sub(itemName,6,10) == "salve" then
                local currentSalveLevel = tonumber(string.sub(itemName,11,string.len(itemName)))
                if currentSalveLevel > salveLevel then
                    salveLevel = currentSalveLevel
                    salve = item
                end
            end
            if string.sub(itemName,6,12) == "clarity" then
                local currentClarityLevel = tonumber(string.sub(itemName,13,string.len(itemName)))
                if currentClarityLevel > clarityLevel then
                    clarityLevel = currentClarityLevel
                    clarity = item
                end
            end
        end
    end
    if salveLevel > 0 then
        salveHeal = salveHealAmount[salveLevel]
        local lostHp = (hero:GetMaxHealth() - hero:GetHealth()) * 2
        if lostHp > salveHeal and hero:IsAlive() and not hero:HasModifier("modifier_item_salve"..salveLevel) then
           local hp_order = 
            {
                UnitIndex = caster:entindex(),
                OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
                TargetIndex = nil,
                AbilityIndex = salve:entindex(),
                Position = nil,
                Queue = 0
            }
            caster:SetContextThink(DoUniqueString("order") , function() ExecuteOrderFromTable(hp_order) end, 0.1)
        end
    end
    if clarityLevel > 0 then
        clarityHeal = clarityHealAmount[clarityLevel]
        local lostMp = (hero:GetMaxMana() - hero:GetMana()) * 2
        if lostMp > clarityHeal and hero:IsAlive() and not hero:HasModifier("modifier_item_clarity"..clarityLevel) then
           local mp_order = 
            {
                UnitIndex = caster:entindex(),
                OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
                TargetIndex = nil,
                AbilityIndex = clarity:entindex(),
                Position = nil,
                Queue = 0
            }
            caster:SetContextThink(DoUniqueString("order") , function() ExecuteOrderFromTable(mp_order) end, 0.1)
        end
    end
end
function AthenaHealth( keys )
	local caster = keys.caster
	caster:SetMaxHealth(caster:GetMaxHealth() + 1000)
	caster:Heal(1000, nil) 
end
function AthenaRegen( keys )
	local caster = keys.caster
	caster:SetBaseHealthRegen(caster:GetBaseHealthRegen() + 5)
end
function AthenaArmor( keys )
	local caster = keys.caster
	caster:SetPhysicalArmorBaseValue(caster:GetPhysicalArmorBaseValue() + 1)
end
function SoulConnect( t )
    local ability = t.ability
	local damage = t.DamageTaken * 0.5
	local caster = t.caster
	local targets = t.target_entities   --获取传递进来的单位组
	local damageType = t.ability:GetAbilityDamageType()
    --利用Lua的循环迭代，循环遍历每一个单位组内的单位
    if ability:IsCooldownReady() then
        for i,unit in pairs(targets) do
            CauseDamage(caster,unit,damage,damageType)
            ability:StartCooldown(0.2)
        end
    end
end
LinkLuaModifier("modifier_hex", "modifiers/modifier_hex.lua", LUA_MODIFIER_MOTION_NONE)
function voodoo_start( keys )
    local caster = keys.caster
    local ability = keys.ability
    local ability_level = ability:GetLevel() - 1
    local target = keys.target

    local duration = ability:GetLevelSpecialValueFor("duration", ability_level)
    
    if target:IsIllusion() then
        target:ForceKill(true)
    else
        target:AddNewModifier(caster, ability, "modifier_hex", {duration = duration})
    end
end
function fury_swipes_attack( keys )
    -- Variables
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local modifierName = "modifier_fury_swipes_target_datadriven"
    local damageType = ability:GetAbilityDamageType()
    local exceptionName = "put_your_exception_unit_here"
    
    -- Necessary value from KV
    local duration = ability:GetLevelSpecialValueFor( "bonus_reset_time", ability:GetLevel() - 1 )
    local damage_per_stack = ability:GetLevelSpecialValueFor( "damage_per_stack", ability:GetLevel() - 1 )
    if target:GetName() == exceptionName then   -- Put exception here
        duration = ability:GetLevelSpecialValueFor( "bonus_reset_time_roshan", ability:GetLevel() - 1 )
    end
    
    -- Check if unit already have stack
    if target:HasModifier( modifierName ) then
        local current_stack = target:GetModifierStackCount( modifierName, ability )
        
        -- Deal damage
        local damage_table = {
            victim = target,
            attacker = caster,
            damage = damage_per_stack * current_stack,
            damage_type = damageType
        }
        ApplyDamage( damage_table )
        
        ability:ApplyDataDrivenModifier( caster, target, modifierName, { Duration = duration } )
        target:SetModifierStackCount( modifierName, ability, current_stack + 1 )
    else
        ability:ApplyDataDrivenModifier( caster, target, modifierName, { Duration = duration } )
        target:SetModifierStackCount( modifierName, ability, 1 )
    end
end
function SoulHurt( keys )
    local ability= keys.ability
	local damage = keys.DamageTaken * keys.Rate
	local caster = keys.caster
	local target = keys.attacker 
	local damageType = keys.ability:GetAbilityDamageType()
	local caster_location = caster:GetAbsOrigin()
	local target_location = target:GetAbsOrigin() 
    local distance = (caster_location - target_location):Length2D()
    if not caster.bounceTag then
        if ability:IsCooldownReady() then
            if distance <= 400 then
                ability:StartCooldown(0.2)
                CauseDamage(caster,target,damage,damageType)
            end
        end
    end
end
function Sunder( event )
    local caster = event.caster
    local ability = event.ability
    local targets = event.target_entities   --获取传递进来的单位组
	--利用Lua的循环迭代，循环遍历每一个单位组内的单位
	for i,unit in pairs(targets) do
	    -- Show the particle target-> caster
	    local particleName = "particles/units/heroes/hero_terrorblade/terrorblade_sunder.vpcf"  
	    local particle = CreateParticle( particleName, PATTACH_POINT_FOLLOW, caster )

	    ParticleManager:SetParticleControlEnt(particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
	    ParticleManager:SetParticleControlEnt(particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
	end
    local healamount = caster:GetMaxHealth() * 0.8
    Heal(caster,healamount,0)
end
function xiaolan( keys )
	local caster = keys.caster
    local target = keys.target
    local reduce = keys.Mana
    target:ReduceMana( reduce )
end
function ScorchedEarthCheck( keys )
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local modifier = keys.modifier

    if target:GetOwner() == caster or target == caster then
        ability:ApplyDataDrivenModifier(caster, target, modifier, {})
    end
end

-- Stops the sound from playing
function StopSound( keys )
    local target = keys.target
    local sound = keys.sound

    StopSoundEvent(sound, target)
end
function invoker_chaos_meteor_datadriven_on_spell(t)
    local caster = t.caster
    local ability = t.ability
    local damage = ability:GetSpecialValueFor("damage")
    local caster_point = caster:GetAbsOrigin()
    local target_point = t.target:GetAbsOrigin()
    
    local caster_point_temp = Vector(caster_point.x, caster_point.y, 0)
    local target_point_temp = Vector(target_point.x, target_point.y, 0)
    
    local point_difference_normalized = (target_point_temp - caster_point_temp):Normalized()
    local velocity_per_second = point_difference_normalized * t.TravelSpeed
    caster:EmitSound("Hero_Invoker.ChaosMeteor.Loop")         
    --Create a particle effect consisting of the meteor falling from the sky and landing at the target point.
    local meteor_fly_original_point = (target_point - (velocity_per_second * t.LandTime)) + Vector (0, 0, 1000)  --Start the meteor in the air in a place where it'll be moving the same speed when flying and when rolling.
    local chaos_meteor_fly_particle_effect = CreateParticle("particles/units/heroes/hero_invoker/invoker_chaos_meteor_fly.vpcf", PATTACH_ABSORIGIN, caster)
    ParticleManager:SetParticleControl(chaos_meteor_fly_particle_effect, 0, meteor_fly_original_point)
    ParticleManager:SetParticleControl(chaos_meteor_fly_particle_effect, 1, target_point)
    ParticleManager:SetParticleControl(chaos_meteor_fly_particle_effect, 2, Vector(1.3, 0, 0))
    Timers:CreateTimer(1.3,function ()
        local chaoland = CreateParticle("particles/units/heroes/hero_warlock/warlock_rain_of_chaos_start.vpcf", PATTACH_ABSORIGIN, caster)
        ParticleManager:SetParticleControl(chaoland, 0, target_point)
        ParticleManager:SetParticleControl(chaoland, 1, target_point)
        ParticleManager:SetParticleControl(chaoland, 2, target_point)
        caster:EmitSound("Hero_Warlock.RainOfChaos_buildup")
        caster:StopSound("Hero_Invoker.ChaosMeteor.Loop")
    end)
    Timers:CreateTimer(1.5,function ()
        local chaoland_1 = CreateParticle("particles/units/heroes/hero_warlock/warlock_rain_of_chaos.vpcf", PATTACH_ABSORIGIN, caster)
        ParticleManager:SetParticleControl(chaoland_1, 0, target_point)
        ParticleManager:SetParticleControl(chaoland_1, 1, target_point)
        ParticleManager:SetParticleControl(chaoland_1, 2, target_point)
        ParticleManager:SetParticleControl(chaoland_1, 5, target_point)
        caster:EmitSound("Hero_Warlock.RainOfChaos")
        local unitGroup = GetUnitsInRadius(caster,ability,target_point,600)
        CauseDamage(caster,unitGroup,damage,DAMAGE_TYPE_MAGICAL,ability)
        for k,v in pairs(unitGroup) do
            ability:ApplyDataDrivenModifier(caster, v, "modifier_boss_chaos_fall_debuff", {duration = 1})
        end
    end)
end
function HitBack( keys )
    local caster = keys.caster
    local target = keys.target
    local damage = GuardingAthena.clotho_lv * 500 * (1 + GameRules:GetDifficulty() * 0.2)
    local damageType = keys.ability:GetAbilityDamageType()
    CauseDamage(caster,target,damage,damageType)
end
function ArcaneAttack( keys )
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local deepen = ability:GetSpecialValueFor("bonus_damage")
    if target:HasModifier("modifier_arcane_attack_debuff") then
        local charges = target:GetModifierStackCount("modifier_arcane_attack_debuff", caster)
        target:SetModifierStackCount("modifier_arcane_attack_debuff", caster, charges + 1)
        if charges >= 4 then
            --caster:CastAbilityOnPosition(target:GetAbsOrigin(), caster:FindAbilityByName("original_crash"),  -1)
            local t_order = 
            {
                UnitIndex = caster:entindex(),
                OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
                TargetIndex = nil,
                AbilityIndex = caster:FindAbilityByName("original_crash"):entindex(),
                Position = target:GetAbsOrigin(),
                Queue = 0
            }
            caster:SetContextThink(DoUniqueString("order") , function() ExecuteOrderFromTable(t_order) end, 0.1)
        end
    end
end
function ArcaneAttackAI( keys )
    local caster = keys.caster
    local target = keys.attacker
    if caster:GetHealthPercent() <= 15 then
        local t_order = 
        {
            UnitIndex = caster:entindex(),
            OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
            TargetIndex = nil,
            AbilityIndex = caster:FindAbilityByName("original_crash"):entindex(),
            Position = target:GetAbsOrigin(),
            Queue = 0
        }
        caster:SetContextThink(DoUniqueString("order") , function() ExecuteOrderFromTable(t_order) end, 0.1)
    end
end
function OriginalCrash( keys )
    local caster = keys.caster
    local ability = keys.ability
    local targets = FindUnitsInRadius(caster:GetTeamNumber(), keys.target_points[1], caster, 600, ability:GetAbilityTargetTeam(), ability:GetAbilityTargetType(), ability:GetAbilityTargetFlags(), 0, false)
    local ability = keys.ability
    for i,unit in pairs(targets) do
        local target_lv = unit:GetLevel()
        local target_stackcount = unit:GetModifierStackCount("modifier_arcane_attack_debuff", caster)
        local base_damage = ability:GetSpecialValueFor("base_damage")
        local damage = base_damage * (target_lv * 0.1 + 1) * (target_stackcount * 0.1 + 1)
        CauseDamage(caster, unit, damage, DAMAGE_TYPE_MAGICAL)
    end
    local particle = CreateParticle("particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_sanity_eclipse_area.vpcf", PATTACH_CUSTOMORIGIN, keys.caster)
    ParticleManager:SetParticleControl(particle, 0, keys.target_points[1])
    ParticleManager:SetParticleControl(particle, 1, Vector(600, 1, 1))
    ParticleManager:SetParticleControl(particle, 2, Vector(600, 1, 1))
    ParticleManager:SetParticleControl(particle, 3, keys.target_points[1])
end
function AngryWater( keys )
    local caster = keys.caster
    local ability = keys.ability
    local damage = keys.Damage
    local caster_location = caster:GetAbsOrigin()
    local teamNumber = caster:GetTeamNumber()
    local targetTeam = ability:GetAbilityTargetTeam()
    local targetType = ability:GetAbilityTargetType()
    local targetFlag = ability:GetAbilityTargetFlags()
    local radius = 225
    local distance = 0
    local angle = 0
    for i=1,19 do
        local point = GetRotationPoint(caster_location, distance, angle)
        local randomPoint = Vector(point.x + RandomInt(-150, 150), point.y + RandomInt(-150, 150), point.z)
        local particle = CreateParticle("particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_bubbles_fxset.vpcf", PATTACH_CUSTOMORIGIN, caster)
        ParticleManager:SetParticleControl(particle, 0, randomPoint)
        Timers:CreateTimer(1.6,function (  )
            local particle = CreateParticle("particles/econ/items/kunkka/kunkka_weapon_whaleblade/kunkka_spell_torrent_splash_whaleblade.vpcf", PATTACH_CUSTOMORIGIN, caster)
            ParticleManager:SetParticleControl(particle, 0, randomPoint)
            local targets = FindUnitsInRadius(teamNumber, randomPoint, caster, radius, targetTeam, targetType, targetFlag, 0, false)
            for i,v in ipairs(targets) do
                CauseDamage(caster, v, damage, DAMAGE_TYPE_MAGICAL)
                ability:ApplyDataDrivenModifier(caster, v , "modifier_angry_water_debuff", nil)
            end
        end)
        angle = angle + 60
        if angle == 360 and distance == 500 then
            angle = 0
            distance = 1000
        elseif angle == 360 and distance == 1000 then
            angle = 30
            distance = 866
        elseif distance == 0 then
            distance = 500
            angle = 0 
        end
    end
end
function AngryWaterAI( keys )
    local caster = keys.caster
    local target = keys.attacker
    local ability = keys.ability
    if caster:GetHealthPercent() <= 95 and ability:IsCooldownReady() then
        local t_order = 
        {
            UnitIndex = caster:entindex(),
            OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
            TargetIndex = nil,
            AbilityIndex = caster:FindAbilityByName("angry_water"):entindex(),
            Position = nil,
            Queue = 0
        }
        caster:SetContextThink(DoUniqueString("order") , function() ExecuteOrderFromTable(t_order) end, 0.1)
    end
end
function WaterRavage( keys )
    local caster = keys.caster
    local ability = keys.ability
    local damage = keys.Damage
    local caster_location = caster:GetAbsOrigin()
    local teamNumber = caster:GetTeamNumber()
    local targetTeam = ability:GetAbilityTargetTeam()
    local targetType = ability:GetAbilityTargetType()
    local targetFlag = ability:GetAbilityTargetFlags()
    local particle = CreateParticle("particles/units/heroes/hero_tidehunter/tidehunter_spell_ravage.vpcf", PATTACH_CUSTOMORIGIN, caster)
    ParticleManager:SetParticleControl(particle, 0, caster_location)
    ParticleManager:SetParticleControl(particle, 1, Vector(200,1,1))
    ParticleManager:SetParticleControl(particle, 2, Vector(400,1,1))
    ParticleManager:SetParticleControl(particle, 3, Vector(600,1,1))
    ParticleManager:SetParticleControl(particle, 4, Vector(800,1,1))
    ParticleManager:SetParticleControl(particle, 5, Vector(1000,1,1))
end
function WaterRavageAI( keys )
    local caster = keys.caster
    local target = keys.attacker
    local ability = keys.ability
    if caster:GetHealthPercent() <= 60 and ability:IsCooldownReady() then
        local t_order = 
        {
            UnitIndex = caster:entindex(),
            OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
            TargetIndex = nil,
            AbilityIndex = caster:FindAbilityByName("water_ravage"):entindex(),
            Position = nil,
            Queue = 0
        }
        caster:SetContextThink(DoUniqueString("order") , function() ExecuteOrderFromTable(t_order) end, 0.1)
    end
end
function testskill( t )
    local caster = t.caster
    local ability = t.ability
    local particle = CreateParticle("particles/units/heroes/hero_elder_titan/elder_titan_echo_stomp_impact_physical.vpcf", PATTACH_ABSORIGIN, caster)
    ParticleManager:SetParticleControlForward(particle, 1, caster:GetForwardVector())
end
function TowerCreated( t )
    local caster = t.caster
    caster.location = caster:GetAbsOrigin()
end
function TowerTeleport( t )
    local caster = t.caster
    local location = caster:GetAbsOrigin()
    if location ~= caster.location then
        caster:SetAbsOrigin(caster.location)
    end
end
function TowerReborn( t )
    Timers:CreateTimer(0.01,function ()
        t.caster:RespawnUnit()
    end)
end
