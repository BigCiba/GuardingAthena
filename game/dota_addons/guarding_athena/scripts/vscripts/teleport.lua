function PracticeTeleport( trigger )
	local caster = trigger.activator
	local caller = trigger.caller:GetName()
	print(caster:GetUnitName())
	if (caster:GetAbsOrigin() - trigger.caller:GetAbsOrigin()):Length2D() < 150 then
		for i=1,4 do
			if caller == "practice_teleport_"..tostring(i) then
				local ent = Entities:FindByName(nil,"practice_"..tostring(i))
				local point=ent:GetAbsOrigin()
				trigger.activator:Stop()
				Timers:CreateTimer(0.1,
				function()
					PlayerResource:SetCameraTarget(trigger.activator:GetPlayerOwnerID(), nil)
				end)
				caster:AddNewModifier(nil, nil, "modifier_phased", {duration=0.2})
				Teleport(trigger.activator, point)
				--[[targetCaller = Entities:FindByName(nil,"practice_"..tostring(i))
				PracticeStart( {activator=caster,caller=targetCaller} )
				Timers:CreateTimer(4,function ()
					targetCaller.used = targetCaller.used - 1
				end)]]
				PlayerResource:SetCameraTarget(trigger.activator:GetPlayerOwnerID(), trigger.activator)
				--caster.onthink = true
				break
			end
		end
	end
end
-- 转生
function HeroReborn( trigger )
	local caster = trigger.activator
	local level = caster:GetLevel()
	local reborn_times = caster.reborn_time or 0
	local playerid = caster:GetPlayerID()
	local player = PlayerResource:GetPlayer(caster:GetPlayerID())
	local location = caster:GetAbsOrigin()
	if caster.trigger_iapetos == nil then
		caster.trigger_iapetos = false
	end
	-- 转生判断
	if caster.can_reborn then
		if level >= (reborn_times + 1) * 100 then
			if gift then
				if caster:GetUnitName() == "npc_dota_hero_nevermore" or caster:GetUnitName() == "npc_dota_hero_crystal_maiden" then
					caster:AddAbility("wing_gold_sf")
					caster:FindAbilityByName("wing_gold_sf"):SetLevel(1)
				else
					caster:AddAbility("wing_gold")
					caster:FindAbilityByName("wing_gold"):SetLevel(1)
				end
			else
				caster:AddAbility("wing")
				caster:FindAbilityByName("wing"):SetLevel(1)
			end
			caster.can_reborn = false
			caster.reborn_time = reborn_times + 1
			caster.reborn = true
			caster.kill_iapetos = false
			local particle = CreateParticle("particles/units/heroes/hero_winter_wyvern/wyvern_winters_curse_ground.vpcf", PATTACH_ABSORIGIN, caster)
			ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle, 2, caster:GetAbsOrigin())
			caster:EmitSound("Hero_FacelessVoid.TimeWalk")
			print(XP_PER_LEVEL_TABLE[caster.reborn_time * 100 + 1])
			print(caster:GetCurrentXP())
			caster:AddExperience(XP_PER_LEVEL_TABLE[caster.reborn_time * 100 + 1] - caster:GetCurrentXP(), 1, false, false)
		end
	elseif level ~= 1 + (reborn_times * 100) and reborn_times <= 3 and caster.kill_iapetos == false  then
		if GuardingAthena.iapetos == nil then
			local ent = Entities:FindByName(nil,"boss_lapetos_reborn")
	 		local point = ent:GetAbsOrigin()
	 		Teleport(caster, point)
	 		caster:Stop()
			SetRegionLimit(caster,Entities:FindByName(nil,"reborn_room"))
			SetCamera(playerid,caster)
		    PrecacheUnitByNameAsync("boss_iapetos",function()
		    	local unit = CreateUnitByName("boss_iapetos", point, true, nil, nil, DOTA_TEAM_BADGUYS ) 
				unit:AddNewModifier(nil, nil, "modifier_phased", {duration=0.2})
				unit:CreatureLevelUp(reborn_times)
				unit.caller = caster
				caster.iapetos = unit
				SetRegionLimit(unit,Entities:FindByName(nil,"reborn_room"))
				for i=1,16 do
					if unit:GetAbilityByIndex(i-1) then
						local ability = unit:GetAbilityByIndex(i-1)
					    ability:SetLevel(unit:GetLevel())
					end
				end
				GuardingAthena.iapetos = unit
			end)
		end
	end
end
function RebornRoom( trigger )
	--[[local caster = trigger.activator
	local caller = trigger.caller
	if GuardingAthena.iapetos ~= nil then
		local iapetos = GuardingAthena.iapetos
		Timers:CreateTimer(function ()
			if iapetos:IsNull() then
				return
			end
			local heros = FindUnitsInRadius(iapetos:GetTeamNumber(), iapetos:GetAbsOrigin(), iapetos, 1800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)
			print(#heros)
			if #heros == 0 then
				if iapetos.canRemove and GuardingAthena.iapetos then
					GuardingAthena.iapetos:RemoveSelf()
					GuardingAthena.iapetos = nil
				else
					iapetos.canRemove = true
					return 1
				end
			else
				iapetos.canRemove = false
				return 1
			end
		end)
	end]]
end