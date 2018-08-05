function OnAttackLanded(t)
    local caster = t.caster
    local target = t.target
    local ability = t.ability
    local modifierName = "modifier_poison_sting_debuff"
    AddModifierStackCount(caster,target,ability,modifierName)
end
function OnIntervalThink( t )
    local caster = t.caster
    local target = t.target
    local ability = t.ability
    local damage = target:GetModifierStackCount("modifier_poison_sting_debuff", caster) * ability:GetSpecialValueFor("damage")
    CauseDamage(caster,target,damage,DAMAGE_TYPE_MAGICAL)
end
function Ultrasonic( t )
    local caster = t.caster
    local target = t.target
    local caster_location = caster:GetAbsOrigin()
    local target_location = target:GetAbsOrigin()
    local point = (target_location - caster_location):Normalized() * 600
    local ability = t.ability
    local damage = ability:GetSpecialValueFor("damage")
    local damagePercent = ability:GetSpecialValueFor("damage_percent") * 0.01
    local damageType = ability:GetAbilityDamageType()
    local p1 = CreateParticle("particles/units/heroes/hero_queenofpain/queen_sonic_wave.vpcf",PATTACH_ABSORIGIN,caster,3)
    ParticleManager:SetParticleControl( p1, 1, Vector(400,400,400))
    local unitGroup = GetUnitsInLine(caster,ability,caster_location,point,500)
    for k, v in pairs( unitGroup ) do
        CauseDamage(caster, v, damage, damageType, ability)
        for i=1,5 do
            if v:GetAbilityByIndex(i-1) then
                local ability = v:GetAbilityByIndex(i-1)
                if ability:IsCooldownReady() and ability:IsToggle() == false and ability:GetCooldown(0) ~= 0 then
                    ability:StartCooldown(8)
                    CauseDamage(caster, v, v:GetMaxHealth() * damagePercent, damageType, ability)
                end
            end
        end
    end
end
function QueenSplit( t )
    local caster = t.caster
    local ability = t.ability
    local duration = ability:GetSpecialValueFor("duration")
    CreateParticle("particles/units/heroes/hero_queenofpain/queen_scream_of_pain_owner.vpcf",PATTACH_ABSORIGIN,caster,2)
    if caster:GetAbilityByIndex(4):IsActivated() then
        PrecacheUnitByNameAsync("captain_guai_34_split",function()
            local illusion = CreateUnitByName("captain_guai_34_split", GetRandomPoint(caster:GetAbsOrigin(),400,600), true, nil, nil, DOTA_TEAM_BADGUYS )
            illusion:SetBaseDamageMin(caster:GetBaseDamageMin() * 0.5)
            illusion:SetBaseDamageMax(caster:GetBaseDamageMax() * 0.5)
            illusion:SetBaseMaxHealth(caster:GetBaseMaxHealth() * 0.5)
            illusion:SetMaxHealth(caster:GetBaseMaxHealth() * 0.5)
            illusion:SetHealth(caster:GetBaseMaxHealth() * 0.5)
            illusion:SetPhysicalArmorBaseValue(caster:GetPhysicalArmorBaseValue() * 0.5)
            illusion:AddAbility("shadow_strike"):SetLevel(1)
            illusion:SetModelScale(illusion:GetModelScale() + 0.5)
            CreateParticle("particles/units/heroes/hero_queenofpain/queen_blink_end.vpcf",PATTACH_ABSORIGIN,illusion,2)
            caster:GetAbilityByIndex(4):SetActivated(false)
            ability.illusion_1 = illusion
        end)
    end
    if caster:GetAbilityByIndex(5):IsActivated() then
        PrecacheUnitByNameAsync("captain_guai_34_split",function()
            local illusion = CreateUnitByName("captain_guai_34_split", GetRandomPoint(caster:GetAbsOrigin(),400,600), true, nil, nil, DOTA_TEAM_BADGUYS )
            illusion:SetBaseDamageMin(caster:GetBaseDamageMin() * 0.5)
            illusion:SetBaseDamageMax(caster:GetBaseDamageMax() * 0.5)
            illusion:SetBaseMaxHealth(caster:GetBaseMaxHealth() * 0.5)
            illusion:SetMaxHealth(caster:GetBaseMaxHealth() * 0.5)
            illusion:SetHealth(caster:GetBaseMaxHealth() * 0.5)
            illusion:SetPhysicalArmorBaseValue(caster:GetPhysicalArmorBaseValue() * 0.5)
            illusion:AddAbility("sm"):SetLevel(1)
            illusion:SetModelScale(illusion:GetModelScale() + 0.5)
            CreateParticle("particles/units/heroes/hero_queenofpain/queen_blink_end.vpcf",PATTACH_ABSORIGIN,illusion,2)
            AI:CreateAI(illusion)
            caster:GetAbilityByIndex(5):SetActivated(false)
            ability.illusion_2 = illusion
        end)
    end
    Timers:CreateTimer(duration,function ()
        CreateParticle("particles/units/heroes/hero_queenofpain/queen_scream_of_pain_owner.vpcf",PATTACH_ABSORIGIN,caster,2)
        if ability.illusion_1:IsNull() == false then
            if ability.illusion_1:IsAlive() then
                ability.illusion_1:AddNoDraw()
                ability.illusion_1:ForceKill(false)
                if caster:IsNull() == false then
                    if caster:IsAlive() then
                        Heal(caster,caster:GetMaxHealth() * 0.5,false)
                        caster:GetAbilityByIndex(4):SetActivated(true)
                        SetUnitDamagePercent(caster,10)
                    end
                end
            end
        end
        if ability.illusion_2:IsNull() == false then
            if ability.illusion_2:IsAlive() then
                ability.illusion_2:AddNoDraw()
                ability.illusion_2:ForceKill(false)
                if caster:IsNull() == false then
                    if caster:IsAlive() then
                        Heal(caster,caster:GetMaxHealth() * 0.5,false)
                        caster:GetAbilityByIndex(5):SetActivated(true)
                        SetUnitDamagePercent(caster,10)
                    end
                end
                
            end
        end
    end)
end