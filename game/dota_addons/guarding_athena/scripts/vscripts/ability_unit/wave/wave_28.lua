function FurDanceAI( t )
    local caster = t.caster
    local ability = t.ability
    local duration = ability:GetSpecialValueFor("duration")
    if ability:IsCooldownReady() and caster:GetHealthPercent() <= 60 then
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_fur_dance_buff", nil)
        caster:StartGestureWithPlaybackRate(ACT_DOTA_FLAIL, 3)
        ability:StartCooldown(20)
        Timers:CreateTimer(duration,function ()
            caster:RemoveGesture(ACT_DOTA_FLAIL)
        end)
    end
end