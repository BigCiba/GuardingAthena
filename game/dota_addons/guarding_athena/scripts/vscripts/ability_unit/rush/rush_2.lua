function AlienLine( t )
    local caster = t.caster
    local ability = t.ability
    if not ability:IsCooldownReady() then
        return
    end
    local damageType = ability:GetAbilityDamageType()
    local caster_location = caster:GetAbsOrigin()
    local damage = t.DamageTaken
    local damageRate = ability:GetSpecialValueFor("damage")
    local max_hp = caster:GetMaxHealth()
    if damage > max_hp then
        damage = max_hp
    end
    local percent = damage / caster:GetMaxHealth()
    local hp_cri_value = ability:GetSpecialValueFor("hp") * 0.01
    if percent > hp_cri_value then
        local point = GetRandomPoint(caster_location,1200,1800)
        local p1 = CreateParticle("particles/units/alien_line_tinker_laser.vpcf",PATTACH_ABSORIGIN,caster,2)
        ParticleManager:SetParticleControl( p1, 9, caster_location )
        ParticleManager:SetParticleControl( p1, 1, point )
        local unitGroup = GetUnitsInLine( caster, ability, caster_location, point, 200 )
        for k, v in pairs( unitGroup ) do
            CauseDamage(caster, v, damageRate, damageType)
        end
        CreateSound("Hero_Tinker.Laser",caster,2)
        ability:StartCooldown(1)
    end
end
function AlienSplit( t )
    local caster = t.caster
    local ability = t.ability
    local count = ability:GetSpecialValueFor("count")
    local caster_location = caster:GetAbsOrigin()
    --[[if #GetUnitsInRadius( caster, ability, caster:GetAbsOrigin(), 10000 ) > 160 then
        return
    end]]--
    local unitName = "alien_enigma_split"
    if caster:GetUnitName() == "alien_enigma" then
        unitName = "alien_enigma_small"
    end
    for i=1,count do
        PrecacheUnitByNameAsync(unitName,function()
            local brith_location = GetRandomPoint(caster_location,20,40)
            local nature = CreateUnitByName(unitName, brith_location, true, nil, nil, DOTA_TEAM_BADGUYS )
            nature:RemoveAbility("alien_split")
            nature:RemoveModifierByName("modifier_alien_split")
            ability:ApplyDataDrivenModifier(caster,nature,"modifier_alien_split_knockback",nil)
            CreateParticle("particles/econ/events/pw_compendium_2014/teleport_end_ground_flash_pw2014.vpcf",PATTACH_ABSORIGIN,nature,1)
            Spawner:UnitProperty(nature,Spawner.specialRushFactor)
            table.insert(Spawner.specialRushUnitRemaining, nature)
        end)
    end
end
function AlienGrowth( t )
    local caster = t.caster
    local ability = t.ability
    local duration = ability:GetSpecialValueFor("duration")
    local unitName = "alien_enigma_small"
    if caster:GetUnitName() == "alien_enigma_small" then
        unitName = "alien_enigma"
    end
    Timers:CreateTimer(duration,function ()
        if not caster:IsNull() then
            if caster:HasModifier("modifier_alien_growth") and caster:IsAlive() then
                PrecacheUnitByNameAsync(unitName,function()
                    caster:RemoveModifierByName("modifier_alien_split")
                    caster:ForceKill(false)
                    local caster_location = caster:GetAbsOrigin()
                    local nature = CreateUnitByName(unitName, caster_location, true, nil, nil, DOTA_TEAM_BADGUYS )
                    nature:RemoveAbility("alien_split")
                    nature:RemoveModifierByName("modifier_alien_split")
                    Spawner:UnitProperty(nature,Spawner.specialRushFactor)
                    table.insert(Spawner.specialRushUnitRemaining, nature)
                end)
            end
        end
    end)
end
function AlienObsidianStar( t )
    local caster = t.caster
    local ability = t.ability
    local point = t.target_points[1]
    local damage = ability:GetSpecialValueFor("damage") / 33
    local p1 = CreateParticle("particles/units/alien_obsidian_star.vpcf",PATTACH_ABSORIGIN,caster,2)
    ParticleManager:SetParticleControl( p1, 0, point + Vector(0,0,200) )
    ParticleManager:SetParticleControl( p1, 1, Vector(200,200,200) )
    local time = 1
    Timers:CreateTimer(function()
        if time<=66 then
            local unitGroup = GetUnitsInRadius( caster, ability, point, 400 )
            for _,unit in ipairs(unitGroup) do
                if unit:IsAlive() then
                    local unit_location = unit:GetAbsOrigin()
                    local vector_distance = point - unit_location
                    local distance = (vector_distance):Length2D()
                    local direction = (vector_distance):Normalized()
                    local speed = distance / 10
                    --unit:AddNewModifier(nil, nil, "modifier_phased", {duration=0.2})
                    --unit:SetAbsOrigin(unit_location + direction * speed)
                    CauseDamage(caster, unit, damage - ((distance / 400) * damage), DAMAGE_TYPE_PURE)
                else
                    table.remove(unitGroup,_)
                end
            end
            time = time + 1
            return 0.03
        else
            local unitGroup = GetUnitsInRadius( caster, ability, point, 400 )
            CauseDamage(caster, unitGroup, damage * 10, DAMAGE_TYPE_PURE)
        end
    end)
end
function AlienObsidianStarAI( t )
    local caster = t.caster
    local ability = t.ability
    if not ability:IsCooldownReady() then
        return
    end
    local caster_location = caster:GetAbsOrigin()
    local radius = 700
    local unitGroup = GetUnitsInRadius( caster, ability, caster_location, radius )
    if #unitGroup >= 1 then
        local t_order = 
        {
            UnitIndex = caster:entindex(),
            OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
            TargetIndex = nil,
            AbilityIndex = caster:FindAbilityByName("alien_obsidian_star"):entindex(),
            Position = unitGroup[1]:GetAbsOrigin(),
            Queue = 0
        }
        caster:SetContextThink(DoUniqueString("order") , function() ExecuteOrderFromTable(t_order) end, 0.1)
    end
end
function AlienBlackHole( t )
    local caster = t.caster
    local ability = t.ability
    local caster_location = caster:GetAbsOrigin()
    local damage = ability:GetSpecialValueFor("damage") / 33
    local radius = 800
    local teamNumber = caster:GetTeamNumber()
    local target_teams = ability:GetAbilityTargetTeam() 
    local target_types = ability:GetAbilityTargetType() 
    local target_flags = DOTA_UNIT_TARGET_FLAG_NONE
    local unitGroup
    local time = 1
    CreateParticle("particles/units/alien_blackhole.vpcf",PATTACH_ABSORIGIN,caster,6)
    Timers:CreateTimer(function()
        if time<=167 then
            unitGroup = FindUnitsInRadius(teamNumber, caster_location, nil, radius, target_teams, target_types, target_flags, FIND_CLOSEST, false)
            for _,unit in ipairs(unitGroup) do
                local unit_location = unit:GetAbsOrigin()
                local vector_distance = caster_location - unit_location
                local distance = (vector_distance):Length2D()
                local direction = (vector_distance):Normalized()
                local speed = distance / 40
                unit:AddNewModifier(nil, nil, "modifier_phased", {duration=0.2})
                unit:SetAbsOrigin(unit_location + direction * speed)
                --print("damage:"..damage.." distance:"..distance)
                CauseDamage(caster, unit, damage - ((distance / 400) * damage), DAMAGE_TYPE_PURE)
            end
            time = time + 1
            radius = radius - 3
            return 0.03
        end
    end)
end
function AlienParasitismAI( t )
    local caster = t.caster
    local ability = t.ability
    local caster_location = caster:GetAbsOrigin()
    local targetTeam = ability:GetAbilityTargetTeam()
    local targetType = ability:GetAbilityTargetType()
    local targetFlag = ability:GetAbilityTargetFlags()
    local radius = 150
    local enemy = FindUnitsInRadius(caster:GetTeamNumber(), caster_location, caster, 150, targetTeam, targetType, targetFlag, 0, false)
    if #enemy >= 1 then
        ability:ApplyDataDrivenModifier(caster,caster,"modifier_alien_parasitism_buff",nil)
        caster:RemoveModifierByName("modifier_alien_parasitism")
        caster:SetModelScale(0.1)
        caster:MoveToNPC(enemy[1])
        caster.parasitism_target = enemy[1]
        caster.growlevel = 0
    end
end
function AlienParasitism( t )
    local caster = t.caster
    local ability = t.ability
    local target = caster.parasitism_target
    local target_location = target:GetAbsOrigin()
    local absorb = caster:GetMaxHealth() * 0.03
    local damage = ability:GetSpecialValueFor("damage") * 0.01
    if target:IsAlive() then
        caster:SetAbsOrigin(target_location)
        if caster:GetHealthPercent() < 100 then
            Heal(caster,absorb,0,false)
            CauseDamage(caster,target,absorb,DAMAGE_TYPE_MAGICAL)
        else
            if caster.growlevel < 30 then
                CauseDamage(caster,target,absorb,DAMAGE_TYPE_MAGICAL)
                caster.growlevel = caster.growlevel + 1
            else
                CauseDamage(caster,target,target:GetHealth() * damage,DAMAGE_TYPE_PURE)
                caster:ForceKill(true)
                PrecacheUnitByNameAsync("alien_worm_boss",function()
                    local brith_location = Vector( target_location.x + RandomFloat(-100,100), target_location.y + RandomFloat(-100,100), target_location.z )
                    local nature = CreateUnitByName("alien_worm_boss", brith_location, true, nil, nil, DOTA_TEAM_BADGUYS )
                    CreateParticle("particles/econ/events/pw_compendium_2014/teleport_end_ground_flash_pw2014.vpcf",PATTACH_ABSORIGIN,nature,1)
                    Spawner:UnitProperty(nature,Spawner.specialRushFactor)
                    nature:CreatureLevelUp(math.floor(caster.growlevel))
                    table.insert(Spawner.specialRushUnitRemaining, nature)
                end)
            end
        end
    else
        caster:ForceKill(true)
        PrecacheUnitByNameAsync("alien_worm_boss",function()
            local brith_location = Vector( target_location.x + RandomFloat(-100,100), target_location.y + RandomFloat(-100,100), target_location.z )
            local nature = CreateUnitByName("alien_worm_boss", brith_location, true, nil, nil, DOTA_TEAM_BADGUYS )
            nature:SetModelScale(caster.growlevel / 30 + 1)
            CreateParticle("particles/econ/events/pw_compendium_2014/teleport_end_ground_flash_pw2014.vpcf",PATTACH_ABSORIGIN,nature,1)
            Spawner:UnitProperty(nature,Spawner.specialRushFactor)
            nature:CreatureLevelUp(math.floor(caster.growlevel))
            table.insert(Spawner.specialRushUnitRemaining, nature)
        end)
    end
end
function AlienParasitismAttack( t )
    local caster = t.caster
    local target = t.target
    local ability = t.ability
    local brith_location = target:GetAbsOrigin()
    local level = caster:GetLevel()
    local damage = ability:GetSpecialValueFor("damage") * (1 + 0.1 * level)
    local count = ability:GetSpecialValueFor("count")
    CauseDamage( caster, target, damage, DAMAGE_TYPE_PURE )
    if damage > target:GetHealth() then
        for i=1,count do
            PrecacheUnitByNameAsync("alien_worm",function()
                local nature = CreateUnitByName("alien_worm", brith_location, true, nil, nil, DOTA_TEAM_BADGUYS )
                CreateParticle("particles/econ/events/pw_compendium_2014/teleport_end_ground_flash_pw2014.vpcf",PATTACH_ABSORIGIN,nature,1)
                Spawner:UnitProperty(nature,Spawner.specialRushFactor)
                table.insert(Spawner.specialRushUnitRemaining, nature)
            end)
        end
    end
end