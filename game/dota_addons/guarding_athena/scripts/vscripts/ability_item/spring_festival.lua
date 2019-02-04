function Firecracker(t)
    local p = CreateParticle("particles/econ/events/new_bloom/firecracker_explode.vpcf",PATTACH_ABSORIGIN,t.caster,10)
    ParticleManager:SetParticleControl( p, 0, t.target_points[1])
end
function FirecrackerBig(t)
    local p = CreateParticle("particles/themed_fx/cny_firecrackers_direend.vpcf",PATTACH_ABSORIGIN,t.caster,10)
    ParticleManager:SetParticleControl( p, 0, t.caster:GetAbsOrigin())
end