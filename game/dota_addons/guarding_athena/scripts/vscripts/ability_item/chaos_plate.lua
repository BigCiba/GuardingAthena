function OnCreated( t )
    local caster = t.caster
    local ability = t.ability
    local interval = ability:GetSpecialValueFor("interval")
    local sheildPercent = ability:GetSpecialValueFor("shield") * 0.01
    ability.shield_health = 0
    caster.ShieldFilter = function (damage,caster)
        if ability.shield_health > damage then
            ability.shield_health = ability.shield_health - damage
			damage = 0
		else
			damage = damage - ability.shield_health
            ability.shield_health = 0
            if caster.shield_particle then
                ParticleManager:DestroyParticle(caster.shield_particle, false)
                caster.shield_particle = nil
            end
        end
        return damage
    end
    caster.resurrection = function (damage)
        if ability:IsCooldownReady() then
            ability:StartCooldown(ability:GetCooldown(1))
            CreateParticle("particles/items_fx/aegis_respawn.vpcf",PATTACH_ABSORIGIN,caster,5)
            ability:ApplyDataDrivenModifier(caster, caster, "modifier_item_chaos_plate_buff", nil)
            caster:SetHealth(caster:GetMaxHealth())
            return 0
        else
            return damage
        end
    end
    caster.percent_reduce_damage = caster.percent_reduce_damage + ability:GetSpecialValueFor("damage_reduce")
    caster.chaos_plate_timer = Timers:CreateTimer(function ()
        ClearBuff(caster,"debuff")
        ability.shield_health = caster:GetMaxHealth() * sheildPercent
        if caster.shield_particle == nil then
            caster.shield_particle = CreateParticle("particles/items/chaos_plate/chaos_plate_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
        end
        return interval
    end)
end
function OnDestroy( t )
    local caster = t.caster
    local ability = t.ability
    caster.percent_reduce_damage = caster.percent_reduce_damage - ability:GetSpecialValueFor("damage_reduce")
    caster.resurrection = nil
    caster.ShieldFilter = nil
    if caster.shield_particle then
        ParticleManager:DestroyParticle(caster.shield_particle, false)
        caster.shield_particle = nil
    end
    Timers:RemoveTimer(caster.chaos_plate_timer)
end