function OnCreated( t )
    local ability = t.ability
    local abilityIndex = ability:GetAbilityIndex()
    if abilityIndex == 0 then
        ability.cooldown_reduce = false
    elseif abilityIndex == 3 then
        t.ability.MagicBlade = true
    end
end
function AutoCast( t )
    local caster = t.caster
    local ability = t.ability
    local soulCount = 50
    local stackcount = caster:GetModifierStackCount("modifier_demon_hunter_buff", caster)
    ability.timers = Timers:CreateTimer(function ()
        stackcount = caster:GetModifierStackCount("modifier_demon_hunter_buff", caster)
        if HasExclusive(caster,1) then soulCount = 100 end
        if ability:GetAutoCastState() and ability:IsCooldownReady() and ability:IsActivated() then
            if stackcount >= soulCount then
                ability:StartCooldown(10.1)
                DemonHunterSpell(t)
            end
        end
        return 0.5
    end)
end
function DemonHunter( keys )
	local caster = keys.caster
	local ability = keys.ability
    local soulCount = 50
    local add = 1
	if HasExclusive(caster,1) then
        soulCount = 100
    end
    if HasExclusive(caster,2) then
        add = 2
    end
    if HasExclusive(caster,4) then
        if caster:HasModifier("modifier_metamorphosis") then
            if caster.soul_stack == nil then
                caster.soul_stack = 0
            end
            caster.soul_stack = caster.soul_stack + add
            if caster.soul_stack >= 100 then
                caster.soul_stack = caster.soul_stack - 100
                caster:SetBaseStrength(caster:GetBaseStrength() + 10)
                caster:SetBaseAgility(caster:GetBaseAgility() + 10)
                caster:SetBaseIntellect(caster:GetBaseIntellect() + 10)
                caster:CalculateStatBonus()
            end
        end
    end
    if caster:HasModifier("modifier_demon_hunter_spell") then
        soulCount = soulCount + 50
        if HasExclusive(caster,1) then
            soulCount = soulCount + 50
        end
    end
	if caster:HasModifier("modifier_demon_hunter_buff") == false then
		ability:ApplyDataDrivenModifier(caster,caster,"modifier_demon_hunter_buff",nil)
		caster:SetModifierStackCount("modifier_demon_hunter_buff",caster,1)
		EmitSoundOn("Hero_Terrorblade.Attack.Rip", caster)
		caster:CalculateStatBonus()
	else
        local stackcount = caster:GetModifierStackCount("modifier_demon_hunter_buff", caster)
		if stackcount < soulCount then
			caster:SetModifierStackCount("modifier_demon_hunter_buff",caster,stackcount + add)
			EmitSoundOn("Hero_Terrorblade.Attack.Rip", caster)
			caster:CalculateStatBonus()
		end
	end
end
function DemonHunterSpell( keys )
	local caster = keys.caster
	local ability = keys.ability
	local id = caster:GetPlayerID() + 1
    if caster.soul_stack == nil then
        caster.soul_stack = 0
    end
    local count =  caster:GetModifierStackCount("modifier_demon_hunter_buff", caster)
	ability:ApplyDataDrivenModifier(caster,caster,"modifier_demon_hunter_spell",{duration = 10})
	local fxIndex = CreateParticle( "particles/skills/dh_demonhunter.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
	Timers:CreateTimer(10,function ()
		local stackcount = caster:GetModifierStackCount("modifier_demon_hunter_buff", caster)
		caster.soul_stack = caster.soul_stack + stackcount
		ParticleManager:DestroyParticle(fxIndex,false)
		if caster.soul_stack >= 100 then
			caster.soul_stack = caster.soul_stack - 100
			caster:SetBaseStrength(caster:GetBaseStrength() + 10)
			caster:SetBaseAgility(caster:GetBaseAgility() + 10)
			caster:SetBaseIntellect(caster:GetBaseIntellect() + 10)
			caster:CalculateStatBonus()
			caster:SetModifierStackCount("modifier_demon_hunter_buff", caster, caster:GetModifierStackCount("modifier_demon_hunter_buff", caster) - count)
			EmitSoundOn("Hero_Terrorblade.Metamorphosis", caster)
			local particle = CreateParticle( "particles/skills/dh_demonhunter_2.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
			Timers:CreateTimer(5,function() ParticleManager:DestroyParticle(particle,false) end)
			if caster.soul_stack >= 100 then
				caster.soul_stack = caster.soul_stack - 100
				caster:SetBaseStrength(caster:GetBaseStrength() + 10)
				caster:SetBaseAgility(caster:GetBaseAgility() + 10)
				caster:SetBaseIntellect(caster:GetBaseIntellect() + 10)
				caster:CalculateStatBonus()
			end
		else
			caster:SetModifierStackCount("modifier_demon_hunter_buff", caster, caster:GetModifierStackCount("modifier_demon_hunter_buff", caster) - count)
			caster:CalculateStatBonus()
		end
	end)
end
function SoulBlade( keys )
	local caster = keys.caster
	local ability = keys.ability
	local position = caster:GetAbsOrigin()
	local point = keys.target_points[1]
	local forwardVector = (point - position):Normalized()
	local damage = ability:GetSpecialValueFor("damage") * caster:GetAgility() + ability:GetSpecialValueFor("base_damage")
	local stackcount = caster:GetModifierStackCount("modifier_demon_hunter_buff", caster)
	local angle = 140
	local radius = ability:GetSpecialValueFor("radius")
	local damageType = ability:GetAbilityDamageType()
	position = position - forwardVector * 32
    local sound = true
    local scale = 1
    if caster:HasModifier("modifier_metamorphosis") then
        radius = radius * 2
        scale = 2
	end
    local p = CreateParticle("particles/heroes/demon_hunter/soulblade.vpcf",PATTACH_ABSORIGIN,caster,3)
    ParticleManager:SetParticleControl(p, 5, Vector(1,1,scale))
    local unitGroup = GetUnitsInSector(caster,ability,position,forwardVector,angle,radius)
	for k, v in pairs( unitGroup ) do
		if caster:HasModifier("modifier_demon_hunter_spell") then
			local fxIndex = CreateParticle( "particles/skills/dh_soulblade_5.vpcf", PATTACH_POINT, v )
			if v:IsAncient() then
				damage = damage + v:GetHealth() * 0.01 * stackcount * 0.5
			else
				damage = damage + v:GetHealth() * 0.01 * stackcount
			end
			if sound then
				EmitSoundOn("DOTA_Item.EtherealBlade.Target", v)
				sound = false
			end
		end
        CauseDamage(caster,v,damage,damageType,ability)
        local distance = radius - (v:GetAbsOrigin()-caster:GetAbsOrigin()):Length2D()
        KnockBack(v,(v:GetAbsOrigin()-caster:GetAbsOrigin()):Normalized(),distance,0.3)
        Heal(caster,damage * 0.3 ,0,false)
    end
end
function OnAttackLanded( t )
    local caster = t.caster
    local target = t.target
    local direction = (target:GetAbsOrigin() - caster:GetAbsOrigin()):Normalized()
    local length = (target:GetAbsOrigin() - caster:GetAbsOrigin()):Length2D()
    local distance = (800 - length) * 200 / 800
    local duration = 0.3
    if caster:HasModifier("modifier_metamorphosis") and HasExclusive(caster,3) then
        KnockBack(target,direction,distance,duration)
    end
end
function MagicBlade( t )
	local caster = t.caster
	local target = t.unit
	local ability = t.ability
    local attack = math.ceil(ability:GetSpecialValueFor("attack") * 0.01 * target:GetAverageTrueAttackDamage(target))
    local maxAtatck = math.ceil(caster:GetAverageTrueAttackDamage(caster)) * 10
    if attack > maxAtatck then attack = maxAtatck end
	local damage = ability:GetSpecialValueFor("damage") * caster:GetAgility()
    local damageType = ability:GetAbilityDamageType()
    if ability.MagicBlade then
        if target:HasModifier("modifier_magic_blade_debuff") then
            ability:ApplyDataDrivenModifier(caster,caster,"modifier_magic_blade_buff",nil)
            ability:ApplyDataDrivenModifier(caster,target,"modifier_magic_blade_debuff",nil)
            if target.magic_timer then
                Timers:ResetDelayTime(target.magic_timer,5)
            end
        else
            local buffcount =  caster:GetModifierStackCount("modifier_magic_blade_buff",ability)
            ability:ApplyDataDrivenModifier(caster,caster,"modifier_magic_blade_buff",nil)
            caster:SetModifierStackCount("modifier_magic_blade_buff",ability,buffcount + attack)
            target.magic_timer = Timers:CreateTimer(5,function ()
                local buffcount =  caster:GetModifierStackCount("modifier_magic_blade_buff",ability)
                if attack >= buffcount then
					caster:RemoveModifierByName("modifier_magic_blade_buff")
				else
					caster:SetModifierStackCount("modifier_magic_blade_buff", ability, buffcount - attack)
				end
            end)
            ability:ApplyDataDrivenModifier(caster,target,"modifier_magic_blade_debuff",nil)
            target:SetModifierStackCount("modifier_magic_blade_debuff",ability,attack)
        end
        if caster:HasModifier("modifier_demon_hunter_spell") then
            local stackcount = caster:GetModifierStackCount("modifier_demon_hunter_buff", caster)
            damage = damage * (1 + stackcount * 0.01)
            Heal(caster,damage * 0.1,0,false)
        end
        ability.MagicBlade = nil
        CauseDamage(caster,target,damage,damageType,ability)
        ability.MagicBlade = true
        local fxIndex = CreateParticle( "particles/econ/items/antimage/antimage_weapon_basher_ti5/am_manaburn_basher_ti_5.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
        Timers:CreateTimer(2,function() ParticleManager:DestroyParticle(fxIndex,false) end)
        EmitSoundOn("Hero_Antimage.ManaBreak", caster)
    end
end
function SoulRing( keys )
	local caster = keys.caster
	local ability = keys.ability
	local abilityLevel = ability:GetLevel()
	local teamNumber = caster:GetTeamNumber()
	local radius = keys.Radius
	local damage = keys.Damage * caster:GetAgility() + ability:GetSpecialValueFor("base_damage")
	local currentDamage
	local targetTeam = ability:GetAbilityTargetTeam()
	local targetType = ability:GetAbilityTargetType()
	local targetFlag = ability:GetAbilityTargetFlags()
    local damageType = ability:GetAbilityDamageType()
    local fxIndex = CreateParticle("particles/skills/mana_field.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster,15)
	if caster:HasModifier("modifier_metamorphosis") then
		radius = radius * 2
	end
	ParticleManager:SetParticleControl( fxIndex, 1, Vector(radius,radius,radius) )
	EmitSoundOn("Hero_FacelessVoid.TimeWalk", caster)
	local time = 0
	Timers:CreateTimer(function ()
		local position = caster:GetAbsOrigin()
		local targets = FindUnitsInRadius( teamNumber, position, caster, radius, targetTeam, targetType, targetFlag, 0, false )
		for k, v in pairs( targets ) do
		    if caster:HasModifier("modifier_demon_hunter_spell") then
		    	local stackcount = caster:GetModifierStackCount("modifier_demon_hunter_buff", caster)
		    	currentDamage = damage * (1 + stackcount * 0.02)
		    else
		    	currentDamage = damage 
			end
			CauseDamage(caster,v,currentDamage,damageType,ability)
			Heal(caster,currentDamage * 0.05 * abilityLevel * 0.1,0,false)
	    end
	    if time < 15 then
	    	time = time + 1
	    	return 1
	    end
	end)
end
function MetamorphosisDamage( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local damage = keys.DamageTaken
	local teamNumber = caster:GetTeamNumber()
	local radius = keys.Radius
	local position = target:GetAbsOrigin()
	local targetTeam = ability:GetAbilityTargetTeam()
	local targetType = ability:GetAbilityTargetType()
	local targetFlag = ability:GetAbilityTargetFlags()
	local damageType = DAMAGE_TYPE_PURE 
	local unitGroup = FindUnitsInRadius( teamNumber, position, caster, radius, targetTeam, targetType, targetFlag, 0, false )
	for k, v in pairs( unitGroup ) do
		CauseDamage(caster,v,damage,damageType,ability)
    end
end
function ModelSwapStart( keys )
    local caster = keys.caster
    local model = keys.model
    local projectile_model = keys.projectile_model
    
    -- Saves the original model and attack capability
    if caster.caster_model == nil then 
        caster.caster_model = caster:GetModelName()
    end
    caster.caster_attack = caster:GetAttackCapability()

    -- Sets the new model and projectile
    caster:SetOriginalModel(model)
    caster:SetRangedProjectileName(projectile_model)

    -- Sets the new attack type
    caster:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
end

--[[Author: Pizzalol/Noya
    Date: 10.01.2015.
    Reverts back to the original model and attack type
]]
function ModelSwapEnd( keys )
    local caster = keys.caster

    caster:SetModel(caster.caster_model)
    caster:SetOriginalModel(caster.caster_model)
    caster:SetAttackCapability(caster.caster_attack)
end


--[[Author: Noya
    Date: 09.08.2015.
    Hides all dem hats
]]
function HideWearables( event )
    local hero = event.caster
    local ability = event.ability

    hero.hiddenWearables = {} -- Keep every wearable handle in a table to show them later
    local model = hero:FirstMoveChild()
    while model ~= nil do
        if model:GetClassname() == "dota_item_wearable" then
            model:AddEffects(EF_NODRAW) -- Set model hidden
            table.insert(hero.hiddenWearables, model)
        end
        model = model:NextMovePeer()
    end
end

function ShowWearables( event )
    local hero = event.caster

    for i,v in pairs(hero.hiddenWearables) do
        v:RemoveEffects(EF_NODRAW)
    end
end
function ExorcismStart( event )
    local caster = event.caster
    local ability = event.ability
    local playerID = caster:GetPlayerID()
    local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
    local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
    local spirits = ability:GetLevelSpecialValueFor( "spirits", ability:GetLevel() - 1 )
    local delay_between_spirits = ability:GetLevelSpecialValueFor( "delay_between_spirits", ability:GetLevel() - 1 )
    local unit_name = "ghost"
    if HasExclusive(caster,4) then
        CreateParticle( "particles/skills/dh_demonhunter.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster,40 )
        caster:GetAbilityByIndex(0):ApplyDataDrivenModifier(caster,caster,"modifier_demon_hunter_spell",{duration = 40})
        caster:GetAbilityByIndex(0):SetActivated(false)
        Timers:CreateTimer(40,function ()
            caster:GetAbilityByIndex(0):SetActivated(true)
        end)
    end
    -- Witchcraft level
    local witchcraft_ability = caster:FindAbilityByName("metamorphosis")
    if not witchcraft_ability then
        caster:FindAbilityByName("death_prophet_witchcraft")
    end

    -- If witchcraft ability found, get the number of extra spirits and increase
    if witchcraft_ability then
        local extra_spirits = witchcraft_ability:GetLevelSpecialValueFor( "exorcism_1_extra_spirits", witchcraft_ability:GetLevel() - 1 )
        if extra_spirits then
            spirits = spirits + extra_spirits
        end
    end

    -- Initialize the table to keep track of all spirits
    caster.spirits = {}
    --print("Spawning "..spirits.." spirits")
    for i=1,spirits do
        Timers:CreateTimer(i * delay_between_spirits, function()
            local unit = CreateUnitByName(unit_name, caster:GetAbsOrigin(), true, caster, caster, caster:GetTeamNumber())

            -- The modifier takes care of the physics and logic
            ability:ApplyDataDrivenModifier(caster, unit, "modifier_exorcism_spirit", {})
            
            -- Add the spawned unit to the table
            table.insert(caster.spirits, unit)

            -- Initialize the number of hits, to define the heal done after the ability ends
            unit.numberOfHits = 0

            -- Double check to kill the units, remove this later
            Timers:CreateTimer(duration+10, function() if unit and IsValidEntity(unit) then unit:RemoveSelf() end end)
        end)
    end
end

-- Movement logic for each spirit
-- Units have 4 states: 
    -- acquiring: transition after completing one target-return cycle.
    -- target_acquired: tracking an enemy or point to collide
    -- returning: After colliding with an enemy, move back to the casters location
    -- end: moving back to the caster to be destroyed and heal
function ExorcismPhysics( event )
    local caster = event.caster
    local unit = event.target
    local ability = event.ability
    local stackcount = caster:GetModifierStackCount("modifier_demon_hunter_buff", caster)
    local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
    local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
    local spirit_speed = ability:GetLevelSpecialValueFor( "spirit_speed", ability:GetLevel() - 1 )
    local min_damage = 3 * ability:GetLevel() * caster:GetAgility()
    local max_damage = 3 * ability:GetLevel() * caster:GetAgility()
    local average_damage = 3 * ability:GetLevel() * caster:GetAgility()
    local give_up_distance = ability:GetLevelSpecialValueFor( "give_up_distance", ability:GetLevel() - 1 )
    local max_distance = ability:GetLevelSpecialValueFor( "max_distance", ability:GetLevel() - 1 )
    local heal_percent = 0
    local min_time_between_attacks = ability:GetLevelSpecialValueFor( "min_time_between_attacks", ability:GetLevel() - 1 )
    local abilityTargetTeam = ability:GetAbilityTargetTeam()
    local abilityDamageType = ability:GetAbilityDamageType()
    local abilityTargetType = ability:GetAbilityTargetType()
    local particleDamage = "particles/units/heroes/hero_death_prophet/death_prophet_exorcism_attack.vpcf"
    local particleDamageBuilding = "particles/units/heroes/hero_death_prophet/death_prophet_exorcism_attack_building.vpcf"
    --local particleNameHeal = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_vendetta_start_sparks_b.vpcf"

    -- Make the spirit a physics unit
    Physics:Unit(unit)

    -- General properties
    unit:PreventDI(true)
    unit:SetAutoUnstuck(false)
    unit:SetNavCollisionType(PHYSICS_NAV_NOTHING)
    unit:FollowNavMesh(false)
    unit:SetPhysicsVelocityMax(spirit_speed)
    unit:SetPhysicsVelocity(spirit_speed * RandomVector(1))
    unit:SetPhysicsFriction(0)
    unit:Hibernate(false)
    unit:SetGroundBehavior(PHYSICS_GROUND_LOCK)

    -- Initial default state
    unit.state = "acquiring"

    -- This is to skip frames
    local frameCount = 0

    -- Store the damage done
    unit.damage_done = 0

    -- Store the interval between attacks, starting at min_time_between_attacks
    unit.last_attack_time = GameRules:GetGameTime() - min_time_between_attacks

    -- Color Debugging for points and paths. Turn it false later!
    local Debug = false
    local pathColor = Vector(255,255,255) -- White to draw path
    local targetColor = Vector(255,0,0) -- Red for enemy targets
    local idleColor = Vector(0,255,0) -- Green for moving to idling points
    local returnColor = Vector(0,0,255) -- Blue for the return
    local endColor = Vector(0,0,0) -- Back when returning to the caster to end
    local draw_duration = 3

    -- Find one target point at random which will be used for the first acquisition.
    local point = caster:GetAbsOrigin() + RandomVector(RandomInt(radius/2, radius))
    point.z = GetGroundHeight(point,nil)

    -- This is set to repeat on each frame
    unit:OnPhysicsFrame(function(unit)

        -- Move the unit orientation to adjust the particle
        unit:SetForwardVector( ( unit:GetPhysicsVelocity() ):Normalized() )

        -- Current positions
        local source = caster:GetAbsOrigin()
        local current_position = unit:GetAbsOrigin()

        -- Print the path on Debug mode
        if Debug then DebugDrawCircle(current_position, pathColor, 0, 2, true, draw_duration) end

        local enemies = nil

        -- Use this if skipping frames is needed (--if frameCount == 0 then..)
        frameCount = (frameCount + 1) % 3

        -- Movement and Collision detection are state independent

        -- MOVEMENT 
        -- Get the direction
        local diff = point - unit:GetAbsOrigin()
        diff.z = 0
        local direction = diff:Normalized()

        -- Calculate the angle difference
        local angle_difference = RotationDelta(VectorToAngles(unit:GetPhysicsVelocity():Normalized()), VectorToAngles(direction)).y
        
        -- Set the new velocity
        if math.abs(angle_difference) < 5 then
            -- CLAMP
            local newVel = unit:GetPhysicsVelocity():Length() * direction
            unit:SetPhysicsVelocity(newVel)
        elseif angle_difference > 0 then
            local newVel = RotatePosition(Vector(0,0,0), QAngle(0,10,0), unit:GetPhysicsVelocity())
            unit:SetPhysicsVelocity(newVel)
        else        
            local newVel = RotatePosition(Vector(0,0,0), QAngle(0,-10,0), unit:GetPhysicsVelocity())
            unit:SetPhysicsVelocity(newVel)
        end

        -- COLLISION CHECK
        local distance = (point - current_position):Length()
        local collision = distance < 50

        -- MAX DISTANCE CHECK
        local distance_to_caster = (source - current_position):Length()
        if distance > max_distance then 
            unit:SetAbsOrigin(source)
            unit.state = "acquiring" 
        end

        -- STATE DEPENDENT LOGIC
        -- Damage, Healing and Targeting are state dependent.
        -- Update the point in all frames

        -- Acquiring...
        -- Acquiring -> Target Acquired (enemy or idle point)
        -- Target Acquired... if collision -> Acquiring or Return
        -- Return... if collision -> Acquiring

        -- Acquiring finds new targets and changes state to target_acquired with a current_target if it finds enemies or nil and a random point if there are no enemies
        if unit.state == "acquiring" then

            -- This is to prevent attacking the same target very fast
            local time_between_last_attack = GameRules:GetGameTime() - unit.last_attack_time
            --print("Time Between Last Attack: "..time_between_last_attack)

            -- If enough time has passed since the last attack, attempt to acquire an enemy
            if time_between_last_attack >= min_time_between_attacks then
                -- If the unit doesn't have a target locked, find enemies near the caster
                enemies = FindUnitsInRadius(caster:GetTeamNumber(), source, nil, radius, abilityTargetTeam, 
                                              abilityTargetType, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)

                -- Check the possible enemies
                -- Focus the last attacked target if there's any
                local last_targeted = caster.last_targeted
                local target_enemy = nil
                for _,enemy in pairs(enemies) do

                    -- If the caster has a last_targeted and this is in range of the ghost acquisition, set to attack it
                    if last_targeted and enemy == last_targeted then
                        target_enemy = enemy
                    end
                end

                -- Else if we don't have a target_enemy from the last_targeted, get one at random
                if not target_enemy then
                    target_enemy = enemies[RandomInt(1, #enemies)]
                end
                
                -- Keep track of it, set the state to target_acquired
                if target_enemy then
                    unit.state = "target_acquired"
                    unit.current_target = target_enemy
                    point = unit.current_target:GetAbsOrigin()
                    --print("Acquiring -> Enemy Target acquired: "..unit.current_target:GetUnitName())

                -- If no enemies, set the unit to collide with a random idle point.
                else
                    unit.state = "target_acquired"
                    unit.current_target = nil
                    unit.idling = true
                    point = source + RandomVector(RandomInt(radius/2, radius))
                    point.z = GetGroundHeight(point,nil)
                    
                    --print("Acquiring -> Random Point Target acquired")
                    if Debug then DebugDrawCircle(point, idleColor, 100, 25, true, draw_duration) end
                end

            -- not enough time since the last attack, get a random point
            else
                unit.state = "target_acquired"
                unit.current_target = nil
                unit.idling = true
                point = source + RandomVector(RandomInt(radius/2, radius))
                point.z = GetGroundHeight(point,nil)
                
                --print("Waiting for attack time. Acquiring -> Random Point Target acquired")
                if Debug then DebugDrawCircle(point, idleColor, 100, 25, true, draw_duration) end
            end

        -- If the state was to follow a target enemy, it means the unit can perform an attack.      
        elseif unit.state == "target_acquired" then

            -- Update the point of the target's current position
            if unit.current_target then
                if unit.current_target:IsNull() == false then
                    point = unit.current_target:GetAbsOrigin()
                    if Debug then DebugDrawCircle(point, targetColor, 100, 25, true, draw_duration) end
                end
            end

            -- Give up on the target if the distance goes over the give_up_distance
            if distance_to_caster > give_up_distance then
                unit.state = "acquiring"
                --print("Gave up on the target, acquiring a new target.")

            end

            -- Do physical damage here, and increase hit counter. 
            if collision then

                -- If the target was an enemy and not a point, the unit collided with it
                if unit.current_target ~= nil then
                    
                    -- Damage, units will still try to collide with attack immune targets but the damage wont be applied
                    if not unit.current_target:IsAttackImmune() then
                        local damage_table = {}

                        local spirit_damage = RandomInt(min_damage,max_damage)
                        damage_table.victim = unit.current_target
                        damage_table.attacker = caster                  
                        damage_table.damage_type = abilityDamageType
                        damage_table.damage = spirit_damage

                        ApplyDamage(damage_table)
                        Heal(caster,spirit_damage * 0.1,0,false)
                        if caster:HasModifier("modifier_demon_hunter_spell") then
					    	local stackcount = caster:GetModifierStackCount("modifier_demon_hunter_buff", caster)
							CauseDamage(caster,unit.current_target,spirit_damage * stackcount * 0.01,DAMAGE_TYPE_PURE,ability)
						end

                        -- Calculate how much physical damage was dealt
                        local targetArmor = unit.current_target:GetPhysicalArmorValue()
                        local damageReduction = ((0.06 * targetArmor) / (1 + 0.06 * targetArmor))
                        local damagePostReduction = spirit_damage * (1 - damageReduction)

                        unit.damage_done = unit.damage_done + damagePostReduction

                        -- Damage particle, different for buildings
                        if unit.current_target.InvulCount == 0 then
                            local particle = CreateParticle(particleDamageBuilding, PATTACH_ABSORIGIN, unit.current_target)
                            ParticleManager:SetParticleControl(particle, 0, unit.current_target:GetAbsOrigin())
                            ParticleManager:SetParticleControlEnt(particle, 1, unit.current_target, PATTACH_POINT_FOLLOW, "attach_hitloc", unit.current_target:GetAbsOrigin(), true)
                        elseif unit.damage_done > 0 then
                            local particle = CreateParticle(particleDamage, PATTACH_ABSORIGIN, unit.current_target)
                            ParticleManager:SetParticleControl(particle, 0, unit.current_target:GetAbsOrigin())
                            ParticleManager:SetParticleControlEnt(particle, 1, unit.current_target, PATTACH_POINT_FOLLOW, "attach_hitloc", unit.current_target:GetAbsOrigin(), true)
                        end

                        -- Increase the numberOfHits for this unit
                        unit.numberOfHits = unit.numberOfHits + 1 

                        -- Fire Sound on the target unit
                        unit.current_target:EmitSound("Hero_DeathProphet.Exorcism.Damage")
                        
                        -- Set to return
                        unit.state = "returning"
                        point = source
                        --print("Returning to caster after dealing ",unit.damage_done)

                        -- Update the attack time of the unit.
                        unit.last_attack_time = GameRules:GetGameTime()
                        --unit.enemy_collision = true

                    end

                -- In other case, its a point, reacquire target or return to the caster (50/50)
                else
                    if RollPercentage(50) then
                        unit.state = "acquiring"
                        --print("Attempting to acquire a new target")
                    else
                        unit.state = "returning"
                        point = source
                        --print("Returning to caster after idling")
                    end
                end
            end

        -- If it was a collision on a return (meaning it reached the caster), change to acquiring so it finds a new target
        elseif unit.state == "returning" then
            
            -- Update the point to the caster's current position
            point = source
            if Debug then DebugDrawCircle(point, returnColor, 100, 25, true, draw_duration) end

            if collision then 
                unit.state = "acquiring"
            end 

        -- if set the state to end, the point is also the caster position, but the units will be removed on collision
        elseif unit.state == "end" then
            point = source
            if Debug then DebugDrawCircle(point, endColor, 100, 25, true, 2) end

            -- Last collision ends the unit
            if collision then 

                -- Heal is calculated as: a percentage of the units average attack damage multiplied by the amount of attacks the spirit did.
                local heal_done =  unit.numberOfHits * average_damage* heal_percent
                caster:Heal(heal_done, ability)
                caster:EmitSound("Hero_DeathProphet.Exorcism.Heal")
                --print("Healed ",heal_done)

                unit:SetPhysicsVelocity(Vector(0,0,0))
                unit:OnPhysicsFrame(nil)
                unit:ForceKill(false)

            end
        end
    end)
end

-- Change the state to end when the modifier is removed
function ExorcismEnd( event )
    local caster = event.caster
    local targets = caster.spirits

    --print("Exorcism End")
    caster:StopSound("Hero_DeathProphet.Exorcism")
    for _,unit in pairs(targets) do     
        if unit and IsValidEntity(unit) then
            unit.state = "end"
        end
    end

    -- Reset the last_targeted
    caster.last_targeted = nil
end

-- Updates the last_targeted enemy, to focus the ghosts on it.
function ExorcismAttack( event )
    local caster = event.caster
    local target = event.target

    caster.last_targeted = target
    --print("LAST TARGET: "..target:GetUnitName())
end

-- Kill all units when the owner dies or the spell is cast while the first one is still going
function ExorcismDeath( event )
    local caster = event.caster
    local targets = caster.spirits or {}

    --print("Exorcism Death")
    caster:StopSound("Hero_DeathProphet.Exorcism")
    for _,unit in pairs(targets) do     
        if unit and IsValidEntity(unit) then
            unit:SetPhysicsVelocity(Vector(0,0,0))
            unit:OnPhysicsFrame(nil)

            -- Kill
            unit:ForceKill(false)
        end
    end
end

function MetamorphosisGhost( keys )
	local caster = keys.target
	--[[local fxIndex = CreateParticle( "particles/skills/metamorphosis_pnt.vpcf", PATTACH_POINT_FOLLOW, caster )
	ParticleManager:SetParticleControl( fxIndex, 0, caster:GetAbsOrigin() )
	ParticleManager:SetParticleControl( fxIndex, 1, caster:GetAbsOrigin() )
	ParticleManager:SetParticleControl( fxIndex, 3, caster:GetAbsOrigin() )]]--
end