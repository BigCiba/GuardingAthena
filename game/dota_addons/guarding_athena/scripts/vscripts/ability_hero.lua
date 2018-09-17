function Anneal( keys )
	local caster= keys.caster
	local target = keys.attacker
    local damage = 100
    if keys.DamageTaken then damage =  keys.DamageTaken end
    local award = math.floor(damage * 0.2)
    --if award < 20 then award = 20 end
    if award > 100 then award = 100 end
	if target:IsRealHero() then
		PlayerResource:ModifyGold(target:GetPlayerID(),20, true, 0)
        target.total_gold = target.total_gold + 20
		target:AddExperience(40,false,false)
	end
	caster.resurrection = function (damage)
		CreateParticle("particles/items_fx/aegis_respawn.vpcf",PATTACH_ABSORIGIN,caster,5)
		caster:SetHealth(caster:GetMaxHealth())
		return 0
	end
end
function SingleHero( keys )
	local caster = keys.caster
	caster.single = true
end
function Thunder( keys )
	local caster = keys.caster
	local casterLocation = caster:GetAbsOrigin()
	local time = 0
	local randompoint
	-- 控制点3控制云的浓度，控制点4控制云的半径，128的浓度大概对应400范围。
	local fxIndex = CreateParticle( "particles/test/lxq_storm.vpcf", PATTACH_ABSORIGIN, caster )
	ParticleManager:SetParticleControl( fxIndex, 3, Vector(128,0,0) )
    ParticleManager:SetParticleControl( fxIndex, 4, Vector(400,0,0) )
    Timers:CreateTimer(3,
        function()
        	ParticleManager:DestroyParticle(fxIndex,false)
        end
    )
    Timers:CreateTimer(1,function (  )
    	if time <= 50 then
    		-- 随机点，控制点0控制落雷起始点，控制点1控制落雷结束点。
	    	randompoint = GetRandomPoint(casterLocation,0,500)
	    	local particle = CreateParticle( "particles/test/lxq_thunder.vpcf", PATTACH_CUSTOMORIGIN, caster )
		    ParticleManager:SetParticleControl( particle, 0, randompoint + Vector(RandomInt(-100, 100), RandomInt(-100, 100), 512))
		    ParticleManager:SetParticleControl( particle, 1, randompoint )
		    -- 重复
		    randompoint = GetRandomPoint(casterLocation,0,500)
	    	local particle1 = CreateParticle( "particles/test/lxq_thunder.vpcf", PATTACH_CUSTOMORIGIN, caster )
		    ParticleManager:SetParticleControl( particle1, 0, randompoint + Vector(RandomInt(-100, 100), RandomInt(-100, 100), 512))
		    ParticleManager:SetParticleControl( particle1, 1, randompoint )
		    randompoint = GetRandomPoint(casterLocation,0,500)
	    	local particle2 = CreateParticle( "particles/test/lxq_thunder.vpcf", PATTACH_CUSTOMORIGIN, caster )
		    ParticleManager:SetParticleControl( particle2, 0, randompoint + Vector(RandomInt(-100, 100), RandomInt(-100, 100), 512))
		    ParticleManager:SetParticleControl( particle2, 1, randompoint )
		    time = time + 1
		    return 0.03
		end
    end)
end
function stxw( keys )
	local point = keys.target_points[1]
	local caster = keys.caster
	local time = 0
	-- 脚下特效
	local p1 = CreateParticle( "particles/test/lxq_stxw_1.vpcf", PATTACH_ABSORIGIN, caster )
	Timers:CreateTimer(1,function()
    	local p2 = CreateParticle( "particles/test/lxq_stxw_gound.vpcf", PATTACH_ABSORIGIN, caster )
    	-- 控制点0为起始点，控制点1为半径
    	ParticleManager:SetParticleControl( p2, 0, point )
    	ParticleManager:SetParticleControl( p2, 1, Vector(300,0,0) )
    end)
    Timers:CreateTimer(1,function()
    	if time <= 12 then
    		-- 控制点0控制落冰点，控制点1控制落冰起始点。
	    	local p3 = CreateParticle( "particles/test/lxq_stxw_ice.vpcf", PATTACH_ABSORIGIN, caster )
	    	local x = RandomInt(-200, 200)
	    	local y = RandomInt(-200, 200)
	    	ParticleManager:SetParticleControl( p3, 0, Vector(point.x + x, point.y + y, point.z) )
	    	ParticleManager:SetParticleControl( p3, 1, Vector(point.x + x, point.y + y, point.z + 1500) )
	    	time = time + 1
	    	return 0.1
	    end
    end)
end
function txb( keys )
	local caster = keys.caster
	local fxIndex = CreateParticle( "particles/test/lxq_txb_1.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
    Timers:CreateTimer(3,
        function()
        	ParticleManager:DestroyParticle(fxIndex,false)
        end
    )
end
function huoqiu( keys )
	local caster = keys.caster
	local caster_location = caster:GetAbsOrigin()
	local point = keys.target_points[1]
	local direction = point - caster_location
	local p1 = CreateParticle( "particles/test/xb_huoqiu.vpcf", PATTACH_ABSORIGIN, caster )
	-- 控制点6
	ParticleManager:SetParticleControl( p1, 6, direction * 4 )
	Timers:CreateTimer(5,
        function()
        	ParticleManager:DestroyParticle(p1,false)
        end
    )
end
function yunshi( keys )
	local caster = keys.caster
	local point = keys.target_points[1]
	local time = 0
	-- 一个地面特效，控制点0
	local p1 = CreateParticle( "particles/test/xb_yunshi_3.vpcf", PATTACH_ABSORIGIN, caster )
	ParticleManager:SetParticleControl( p1, 0, point )
	Timers:CreateTimer(5,
        function()
        	ParticleManager:DestroyParticle(p1,false)
        end
    )
    -- 很多个陨石特效，控制点0
    for i=1,12 do
    	local p2 = CreateParticle( "particles/test/xb_yunshi_attack.vpcf", PATTACH_ABSORIGIN, caster )
    	randompoint = GetRandomPoint(point,0,300)
    	ParticleManager:SetParticleControl( p2, 0, randompoint )
    end
end
