function OnCreated( t )
    local caster = t.caster
    local ability = t.ability
    ability.illusion = {}
    local cd = ability:GetSpecialValueFor("cooldown")
    AddDamageFilterVictim(caster,"doppleganger",function (damage,attacker)
        if ability:IsCooldownReady() then
            ability:StartCooldown(cd)
            damage = 0
            OnDoppleganger(caster,ability)
        end
        return damage
    end)
end
function OnDoppleganger( caster,ability )
    local casterLoc = caster:GetAbsOrigin()
    local damage = ability:GetSpecialValueFor("damage")
    local damageType = ability:GetAbilityDamageType()
    local radius = ability:GetSpecialValueFor("damage_radius")
    local unitGroup = GetUnitsInRadius(caster,ability,casterLoc,radius)
    --CauseDamage(caster,unitGroup,damage,damageType,ability)
    CreateSound("Hero_NagaSiren.MirrorImage",caster)
    local illusionRadius = ability:GetSpecialValueFor("illusion_radius")
    unitGroup = GetUnitsInRadius(caster,ability,casterLoc,illusionRadius)
    local point = GetRandomPoint(casterLoc,600,700)
    -- 杀死幻象
    for k,v in pairs(ability.illusion) do
        if not v:IsNull() then
            v:AddNoDraw()
            v:ForceKill(false)
        end
    end
    ability.illusion = {}
    if #unitGroup > 0 then
        point = unitGroup[1]:GetAbsOrigin()
    end
    local p = CreateParticle("particles/econ/items/naga/naga_ti8_immortal_tail/naga_ti8_immortal_riptide.vpcf",PATTACH_ABSORIGIN,caster,3)
    ParticleManager:SetParticleControl( p, 0, casterLoc)
    ParticleManager:SetParticleControl( p, 1, Vector(radius,radius,radius))
    ParticleManager:SetParticleControl( p, 3, Vector(radius,0,0))
    local randomInt = RandomInt(1,6)
    for i = randomInt, randomInt + 5 do
        if i == randomInt then
            caster:AddNoDraw()
            ability:ApplyDataDrivenModifier(caster, caster, "modifier_doppleganger_buff", {duration = 1})
            Timers:CreateTimer(1,function ()
                local targetLoc = GetRotationPoint(unitGroup[1]:GetAbsOrigin(),175,i * 60)
                CreateParticle("particles/units/heroes/hero_siren/naga_siren_mirror_image_h.vpcf",PATTACH_ABSORIGIN,caster,2)
                SetUnitPosition(caster,targetLoc)
                caster:RemoveNoDraw()
            end)
        else
            Timers:CreateTimer(1,function ()
                local targetLoc = GetRotationPoint(unitGroup[1]:GetAbsOrigin(),175,i * 60)
                PrecacheUnitByNameAsync("captain_guai_33_illusion",function()
                    local illusion = CreateUnitByName("captain_guai_33_illusion", targetLoc, true, nil, nil, DOTA_TEAM_BADGUYS )
                    illusion:SetBaseMaxHealth(caster:GetBaseMaxHealth())
                    illusion:SetMaxHealth(caster:GetBaseMaxHealth())
                    illusion:SetHealth(caster:GetHealth())
                    table.insert( ability.illusion, illusion )
                    CreateParticle("particles/units/heroes/hero_siren/naga_siren_mirror_image_h.vpcf",PATTACH_ABSORIGIN,illusion,2)
                    SetUnitDamagePercent(illusion,-70)
                    SetUnitIncomingDamageDeepen(illusion,1200)
                    illusion:AddNewModifier(illusion, nil, "modifier_kill", {duration=2})
                end)
            end)
        end
    end
end
function SeaErode( t )
    local caster = t.caster
    local ability = t.ability
    local casterLoc = caster:GetAbsOrigin()
    local damage = ability:GetSpecialValueFor("damage")
    local radius = ability:GetSpecialValueFor("radius")
    local unitGroup = GetUnitsInRadius(caster,ability,casterLoc,radius)
    CauseDamage(caster,unitGroup,damage,DAMAGE_TYPE_MAGICAL,ability)
    CauseDamage(caster,unitGroup,damage,DAMAGE_TYPE_PHYSICAL,ability)
    local p = CreateParticle("particles/units/heroes/hero_siren/naga_siren_riptide.vpcf",PATTACH_ABSORIGIN,caster,3)
    ParticleManager:SetParticleControl( p, 0, casterLoc)
    ParticleManager:SetParticleControl( p, 1, Vector(radius,radius,radius))
    ParticleManager:SetParticleControl( p, 3, Vector(radius,0,0))
end