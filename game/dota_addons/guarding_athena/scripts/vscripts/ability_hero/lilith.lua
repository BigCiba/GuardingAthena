function Ashes( keys )
	local caster = keys.caster
	if keys.event_ability:IsItem() then
        return
    end
	if keys.event_ability:IsToggle() then
        return
    end
	local intellect = caster:GetIntellect()
	local ability = caster:GetAbilityByIndex(0)
	if caster:HasModifier("modifier_ashes_buff") then
		ability:ApplyDataDrivenModifier(caster,caster,"modifier_ashes_buff",nil)
		local stackcount = caster:GetModifierStackCount("modifier_ashes_buff",caster)
		caster:SetModifierStackCount("modifier_ashes_buff",caster,stackcount + 1)
	else
		ability:ApplyDataDrivenModifier(caster,caster,"modifier_ashes_buff",nil)
		caster:SetModifierStackCount("modifier_ashes_buff",caster,1)
	end
	caster.const_reduce_damage = caster.const_reduce_damage + intellect
	Timers:CreateTimer(10,function()
		local stackcount = caster:GetModifierStackCount("modifier_ashes_buff",caster)
		if stackcount > 1 then
			caster:SetModifierStackCount("modifier_ashes_buff",caster,stackcount - 1)
		end
		caster.const_reduce_damage = caster.const_reduce_damage - intellect
	end)
end
function AshesDamage( keys )
	local caster = keys.caster
	local ability = keys.ability
	local damageType = ability:GetAbilityDamageType()
	local caster_location = caster:GetAbsOrigin()
	local radius = 300
	local damage = 0.2 * caster:GetIntellect() * caster:GetModifierStackCount("modifier_ashes_buff",nil)
	local unitGroup = GetUnitsInRadius(caster,ability,caster_location,radius)
	for k, v in pairs( unitGroup ) do
        CauseDamage(caster, v, damage, damageType, ability)
    end
end
function AshesEffect( keys )
	local caster = keys.caster
	local ability = keys.ability
	local p1 = CreateParticle( "particles/skills/ashes_body.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
	--ParticleManager:SetParticleControlEnt( p1, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetOrigin(), false )
	ParticleManager:SetParticleControlEnt( p1, 1, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetOrigin(), false )
	ParticleManager:SetParticleControl( p1, 0, caster:GetOrigin() )
	ability.effect = p1
	--ParticleManager:SetParticleControl( p1, 2, Vector(300,300,300) )
	--ParticleManager:SetParticleControl( p1, 3, Vector(300,0,0) )
end
function AshesEffectRemove( keys )
	local caster = keys.caster
	local ability = keys.ability
	ParticleManager:DestroyParticle(ability.effect,false)
end
function DarkFire( keys )
	local caster = keys.caster
	local ignite_duration = 5
	if caster:HasModifier("modifier_zhuanshulina") then
		ignite_duration = 10
	end
	local ability = keys.ability
	local caster_location = caster:GetAbsOrigin()
	local point = keys.target_points[1]
	local target_point = caster_location + (point - caster_location):Normalized() * 2000
	local damage = ability:GetSpecialValueFor("damage") + ability:GetSpecialValueFor("intellect") * caster:GetIntellect()
	local teamNumber = caster:GetTeamNumber()
	local targetTeam = ability:GetAbilityTargetTeam()
	local targetType = ability:GetAbilityTargetType()
	local targetFlag = ability:GetAbilityTargetFlags()
	local damageType = ability:GetAbilityDamageType()
	local p1 = CreateParticle( "particles/skills/dark_fire.vpcf", PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( p1, 0, caster_location + Vector(0,0,100) )
	ParticleManager:SetParticleControl( p1, 1, target_point + Vector(0,0,100) )
	ParticleManager:SetParticleControl( p1, 2, target_point + Vector(0,0,100) )
	ParticleManager:SetParticleControl( p1, 3, target_point + Vector(0,0,100) )
	ParticleManager:SetParticleControl( p1, 9, caster_location + Vector(0,0,100) )
	Timers:CreateTimer(4,function()
		ParticleManager:DestroyParticle(p1,false)
	end)
	local times = 0
	Timers:CreateTimer(function()
		if times < 30 and caster:IsChanneling() then
			local unitGroup = FindUnitsInLine( teamNumber, caster_location, target_point, nil, 200, targetTeam, targetType, FIND_CLOSEST)
			for k, v in pairs( unitGroup ) do
		        CauseDamage(caster, v, damage * 0.1, damageType,ability)
		        ability:ApplyDataDrivenModifier(caster,v,"modifier_dark_fire_debuff",nil)
		        if times == 9 or times == 19 or times == 29 then
		        	local ability_3 = caster:GetAbilityByIndex(3)
		        	if ability_3:GetLevel() >=1 then
			        	if v:HasModifier("modifier_ignite_debuff") then
							ability_3:ApplyDataDrivenModifier(caster,v,"modifier_ignite_debuff",{duration=ignite_duration})
							local stackcount = v:GetModifierStackCount("modifier_ignite_debuff",nil)
							v:SetModifierStackCount("modifier_ignite_debuff",caster,stackcount + 1)
						else
							ability_3:ApplyDataDrivenModifier(caster,v,"modifier_ignite_debuff",{duration=ignite_duration})
							v:SetModifierStackCount("modifier_ignite_debuff",caster,1)
						end
						Timers:CreateTimer(ignite_duration,function()
							if v:IsNull() == false then
								local stackcount = v:GetModifierStackCount("modifier_ignite_debuff",nil)
								if stackcount > 1 then
									v:SetModifierStackCount("modifier_ignite_debuff",caster,stackcount - 1)
								end
							end
						end)
					end
				end
		    end
			times = times + 1
			return 0.1
		else
			ParticleManager:DestroyParticle(p1,false)
		end
	end)
end
function DarkFireUp( keys )
	local caster = keys.caster
	local ignite_duration = 5
	if caster:HasModifier("modifier_zhuanshulina") then
		ignite_duration = 10
	end
	local ability = keys.ability
	local caster_location = caster:GetAbsOrigin()
	local point = keys.target_points[1]
	local target_point = caster_location + (point - caster_location):Normalized() * 2000
	local damage = ability:GetSpecialValueFor("damage") + ability:GetSpecialValueFor("intellect") * caster:GetIntellect()
	local teamNumber = caster:GetTeamNumber()
	local targetTeam = ability:GetAbilityTargetTeam()
	local targetType = ability:GetAbilityTargetType()
	local targetFlag = ability:GetAbilityTargetFlags()
	local damageType = ability:GetAbilityDamageType()
	local p1 = CreateParticle( "particles/skills/dark_fire.vpcf", PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( p1, 0, caster_location + Vector(0,0,100) )
	ParticleManager:SetParticleControl( p1, 1, target_point + Vector(0,0,100) )
	ParticleManager:SetParticleControl( p1, 2, target_point + Vector(0,0,100) )
	ParticleManager:SetParticleControl( p1, 3, target_point + Vector(0,0,100) )
	ParticleManager:SetParticleControl( p1, 9, caster_location + Vector(0,0,100) )
	Timers:CreateTimer(4,function()
		ParticleManager:DestroyParticle(p1,false)
	end)
	local times = 0
	Timers:CreateTimer(function()
		if times < 30 then
			local unitGroup = FindUnitsInLine( teamNumber, caster_location, target_point, nil, 200, targetTeam, targetType, FIND_CLOSEST)
			for k, v in pairs( unitGroup ) do
		        CauseDamage(caster, v, damage * 0.1, damageType, ability)
		        ability:ApplyDataDrivenModifier(caster,v,"modifier_dark_fire_debuff",nil)
		        if times == 9 or times == 19 or times == 29 then
		        	local ability_3 = caster:GetAbilityByIndex(3)
		        	if ability_3:GetLevel() >=1 then
			        	if v:HasModifier("modifier_ignite_debuff") then
							ability_3:ApplyDataDrivenModifier(caster,v,"modifier_ignite_debuff",{duration=ignite_duration})
							local stackcount = v:GetModifierStackCount("modifier_ignite_debuff",nil)
							v:SetModifierStackCount("modifier_ignite_debuff",caster,stackcount + 1)
						else
							ability_3:ApplyDataDrivenModifier(caster,v,"modifier_ignite_debuff",{duration=ignite_duration})
							v:SetModifierStackCount("modifier_ignite_debuff",caster,1)
						end
						Timers:CreateTimer(ignite_duration,function()
							if v:IsNull() == false then
								local stackcount = v:GetModifierStackCount("modifier_ignite_debuff",nil)
								if stackcount > 1 then
									v:SetModifierStackCount("modifier_ignite_debuff",caster,stackcount - 1)
								end
							end
						end)
					end
				end
		    end
			times = times + 1
			return 0.1
		else
			ParticleManager:DestroyParticle(p1,false)
		end
	end)
end
function DarkFireStart( keys )
	local caster = keys.caster
	local caster_location = caster:GetAbsOrigin()
	local p1 = CreateParticle( "particles/skills/dark_fire_circle.vpcf", PATTACH_ABSORIGIN, caster )
	ParticleManager:SetParticleControl( p1, 0, caster_location )
	ParticleManager:SetParticleControl( p1, 1, caster_location )
	Timers:CreateTimer(4,function()
		ParticleManager:DestroyParticle(p1,false)
	end)
end
function FireButterfly( keys )
	local caster = keys.caster
	local ignite_duration = 5
	if caster:HasModifier("modifier_zhuanshulina") then
		ignite_duration = 10
	end
	local ability = keys.ability
	local radius = 300
	local point = keys.target_points[1]
	local damage = ability:GetSpecialValueFor("intellect") * caster:GetIntellect()
	local teamNumber = caster:GetTeamNumber()
	local targetTeam = ability:GetAbilityTargetTeam()
	local targetType = ability:GetAbilityTargetType()
	local targetFlag = ability:GetAbilityTargetFlags()
	local damageType = ability:GetAbilityDamageType()
	local p1 = CreateParticle( "particles/units/heroes/hero_lina/lina_spell_light_strike_array.vpcf", PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( p1, 0, point )
	ParticleManager:SetParticleControl( p1, 1, Vector(300,300,300) )
	ParticleManager:SetParticleControl( p1, 3, point )
	Timers:CreateTimer(4,function()
		ParticleManager:DestroyParticle(p1,false)
	end)
	local p2 = CreateParticle( "particles/skills/fire_butterfly_gound.vpcf", PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( p2, 0, point )
	Timers:CreateTimer(4,function()
		ParticleManager:DestroyParticle(p2,false)
	end)
	local unitGroup = GetUnitsInRadius(caster,ability,point,radius)
	for k, v in pairs( unitGroup ) do
        CauseDamage(caster, v, damage, damageType, ability)
        ability:ApplyDataDrivenModifier(caster,v,"modifier_light_array_debuff",nil)
        local ability_3 = caster:GetAbilityByIndex(3)
        if ability_3:GetLevel() >=1 then
	    	if v:HasModifier("modifier_ignite_debuff") then
				ability_3:ApplyDataDrivenModifier(caster,v,"modifier_ignite_debuff",{duration=ignite_duration})
				local stackcount = v:GetModifierStackCount("modifier_ignite_debuff",nil)
				v:SetModifierStackCount("modifier_ignite_debuff",caster,stackcount + 1)
			else
				ability_3:ApplyDataDrivenModifier(caster,v,"modifier_ignite_debuff",{duration=ignite_duration})
				v:SetModifierStackCount("modifier_ignite_debuff",caster,1)
			end
			Timers:CreateTimer(ignite_duration,function()
				if v:IsNull() == false then
					local stackcount = v:GetModifierStackCount("modifier_ignite_debuff",nil)
					if stackcount > 3 then
						v:SetModifierStackCount("modifier_ignite_debuff",caster,stackcount - 1)
					end
				end
			end)
		end
    end
    local times = 0
	Timers:CreateTimer(function()
		if times < 30 then
			local unitGroup = GetUnitsInRadius(caster,ability,point,radius)
			for k, v in pairs( unitGroup ) do
		        CauseDamage(caster, v, damage * 0.1 * 0.25, damageType, ability)
		        if times == 9 or times == 19 or times == 29 then
		        	local ability_3 = caster:GetAbilityByIndex(3)
		        	if ability_3:GetLevel() >=1 then
			        	if v:HasModifier("modifier_ignite_debuff") then
							ability_3:ApplyDataDrivenModifier(caster,v,"modifier_ignite_debuff",{duration=ignite_duration})
							local stackcount = v:GetModifierStackCount("modifier_ignite_debuff",nil)
							v:SetModifierStackCount("modifier_ignite_debuff",caster,stackcount + 1)
						else
							ability_3:ApplyDataDrivenModifier(caster,v,"modifier_ignite_debuff",{duration=ignite_duration})
							v:SetModifierStackCount("modifier_ignite_debuff",caster,1)
						end
						Timers:CreateTimer(10,function()
							if v:IsNull() == false then
								local stackcount = v:GetModifierStackCount("modifier_ignite_debuff",nil)
								if stackcount > 1 then
									v:SetModifierStackCount("modifier_ignite_debuff",caster,stackcount - 1)
								end
							end
						end)
					end
				end
		    end
			times = times + 1
			return 0.1
		end
	end)
end
function Ignite( keys )
	local caster = keys.caster
	local ignite_duration = 5
	if caster:HasModifier("modifier_zhuanshulina") then
		ignite_duration = 10
	end
	local target = keys.target
	local ability = keys.ability
	if target:HasModifier("modifier_ignite_debuff") then
		ability:ApplyDataDrivenModifier(caster,target,"modifier_ignite_debuff",{duration=ignite_duration})
		local stackcount = target:GetModifierStackCount("modifier_ignite_debuff",nil)
		target:SetModifierStackCount("modifier_ignite_debuff",caster,stackcount + 1)
	else
		ability:ApplyDataDrivenModifier(caster,target,"modifier_ignite_debuff",{duration=ignite_duration})
		target:SetModifierStackCount("modifier_ignite_debuff",caster,1)
	end
	Timers:CreateTimer(ignite_duration,function()
		if target:IsNull() == false then
			local stackcount = target:GetModifierStackCount("modifier_ignite_debuff",nil)
			if stackcount > 1 then
				target:SetModifierStackCount("modifier_ignite_debuff",caster,stackcount - 1)
			end
		end
	end)
end
function IgniteDamage( keys )
	local caster = keys.caster
	local target = keys.target
	if target:IsNull() then
		return
	end
	local ability = keys.ability
	local damageType = ability:GetAbilityDamageType()
	local damage = ability:GetSpecialValueFor("damage") * caster:GetIntellect() * target:GetModifierStackCount("modifier_ignite_debuff",nil) * 0.1
    CauseDamage(caster, target, damage, damageType, ability)
end
function IgniteFire( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local p1 = CreateParticle( "particles/skills/ignite_fire_odl.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
	--ParticleManager:SetParticleControlEnt( p1, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetOrigin(), false )
	ParticleManager:SetParticleControlEnt( p1, 0, target, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetOrigin(), false )
	target.IgniteFire = p1
end
function IgniteRemove( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	ParticleManager:DestroyParticle(target.IgniteFire,false)
end
function MeteorStorm( keys )
	local caster = keys.caster
	local ignite_duration = 5
	if caster:HasModifier("modifier_zhuanshulina") then
		ignite_duration = 10
	end
	local ability = keys.ability
	local damage = ability:GetSpecialValueFor("damage") * caster:GetIntellect()
	local radius = ability:GetSpecialValueFor("radius")
	local max_radius = ability:GetSpecialValueFor("max_radius")
	local damageType = ability:GetAbilityDamageType()
	local teamNumber = caster:GetTeamNumber()
	local targetTeam = ability:GetAbilityTargetTeam()
	local targetType = ability:GetAbilityTargetType()
	local targetFlag = ability:GetAbilityTargetFlags()
	local caster_location = caster:GetAbsOrigin()
	local p1 = CreateParticle( "particles/skills/meteor_circle.vpcf", PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( p1, 0, caster_location )
	Timers:CreateTimer(4,function()
		ParticleManager:DestroyParticle(p1,false)
	end)
	local time = 0
	local randompoint
    Timers:CreateTimer(1,function (  )
    	CreateSound("Hero_Invoker.ChaosMeteor.Loop",caster,1.3)
    	CreateSound("Ability.LightStrikeArray",caster,nil,1.3)
    	if time <= 12 then
    		for i=1,2 do
		    	randompoint = GetRandomPoint(caster_location,0,max_radius)
		    	local particle = CreateParticle( "particles/skills/meteor_fly.vpcf", PATTACH_ABSORIGIN, caster )
		    	ParticleManager:SetParticleControl(particle, 0, randompoint + Vector (300, 300, 1000))
			    ParticleManager:SetParticleControl(particle, 1, randompoint)
			    ParticleManager:SetParticleControl(particle, 2, Vector(1.3, 0, 0))
			    Timers:CreateTimer(4,function()
					ParticleManager:DestroyParticle(particle,false)
				end)
				local point_save = randompoint
				Timers:CreateTimer(1.3,function (  )
					local particle = CreateParticle( "particles/skills/rain_of_chaos_landding_immortal1.vpcf", PATTACH_ABSORIGIN, caster )
			    	ParticleManager:SetParticleControl(particle, 0, point_save)
			    	Timers:CreateTimer(4,function()
						ParticleManager:DestroyParticle(particle,false)
					end)
			    	local unitGroup = FindUnitsInRadius(teamNumber, point_save, caster, radius, targetTeam, targetType, targetFlag, 0, false)
			    	for k, v in pairs( unitGroup ) do
				        CauseDamage(caster, v, damage, damageType, ability)
			    		ability:ApplyDataDrivenModifier(caster,v,"modifier_meteor_storm_debuff",nil)
			    		local ability_3 = caster:GetAbilityByIndex(3)
			        	if v:HasModifier("modifier_ignite_debuff") then
							ability_3:ApplyDataDrivenModifier(caster,v,"modifier_ignite_debuff",{duration=ignite_duration})
							local stackcount = v:GetModifierStackCount("modifier_ignite_debuff",nil)
							v:SetModifierStackCount("modifier_ignite_debuff",caster,stackcount + 3)
						else
							ability_3:ApplyDataDrivenModifier(caster,v,"modifier_ignite_debuff",{duration=ignite_duration})
							v:SetModifierStackCount("modifier_ignite_debuff",caster,3)
						end
						Timers:CreateTimer(ignite_duration,function()
							if v:IsNull() == false then
								local stackcount = v:GetModifierStackCount("modifier_ignite_debuff",nil)
								if stackcount > 3 then
									v:SetModifierStackCount("modifier_ignite_debuff",caster,stackcount - 3)
								end
							end
						end)
				    end
	    		end)
    		end
		    time = time + 1
		    return 0.25
		end
    end)
end