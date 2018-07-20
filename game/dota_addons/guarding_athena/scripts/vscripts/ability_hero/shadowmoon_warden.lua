function AbstrusemoonShadow( t )
	local caster = t.caster 
	local target = t.target
	local ability = t.ability
	local bonus_att = math.floor(caster:GetAttackDamage() * 0.04)
	local agi = caster:GetAgility()
	local health = caster:GetMaxHealth() - caster:GetHealth()
	local lifesteal = 0.5
	if HasExclusive(caster,2) then
		agi = agi * 2
	end
	if HasExclusive(caster,1) then
		lifesteal = 1
	end
	if target:IsAlive() and target:IsMagicImmune() == false then
		if agi <= target:GetHealth() then
			target:SetBaseMaxHealth(target:GetBaseMaxHealth() - agi)
			target:SetMaxHealth(target:GetMaxHealth() - agi)
		else
			CauseDamage( caster, target, target:GetHealth(), DAMAGE_TYPE_PURE )
		end
	end
	Heal(caster, agi * lifesteal, 0, false)
	AddModifierStackCount(caster,caster,ability,"modifier_abstrusemoon_shadow_buff",bonus_att,10,true)
end
function ClustersStar( t )
	local caster = t.caster
	local target = t.target
	local ability = t.ability
	if caster:HasModifier("modifier_series") == false then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_series", {duration=1})
	else
		local stackcount = caster:GetModifierStackCount("modifier_series",t.ability)
		if stackcount == 0 then
			if RollPercentage(25) == true then
				stackcount = 2
				if RollPercentage(25) == true then
					stackcount = 3
					if RollPercentage(25) == true then
						stackcount = 4
					end
				end
			else
				stackcount = 1
			end
			caster:SetModifierStackCount("modifier_series",t.ability,stackcount)
			return
		elseif stackcount > 1 then
			stackcount = stackcount - 1
			caster:SetModifierStackCount("modifier_series",t.ability,stackcount)
		elseif stackcount == 1 then
			caster:RemoveModifierByName("modifier_series")
			return
		end
	end
end
function ClustersStarActive( t )
	local caster = t.caster
	local target = t.target
	local ability = t.ability
	local damage = t.Damage
	local att = caster:GetAverageTrueAttackDamage(caster) * damage
	local critical = t.Critical
	local health = target:GetHealth()
	if caster.gift then
		local fxIndex = CreateParticle("particles/heroes/warden/clusters_stars_active_gold.vpcf",PATTACH_ABSORIGIN_FOLLOW,target,2)
	else
		local fxIndex = CreateParticle("particles/heroes/warden/clusters_stars_active.vpcf",PATTACH_ABSORIGIN_FOLLOW,target,2)
	end
	local damageType = DAMAGE_TYPE_PHYSICAL
	if RollPercentage(30) then
		att = att * critical * 0.01
		CauseDamage(caster,target,att,damageType,ability,100,100)
	else
		CauseDamage(caster,target,att,damageType,ability)
	end
	if att > health then
		Heal(caster,health,0)
	end
end
function ShadowmoonWheeldance( t )
	local att = t.caster:GetAverageTrueAttackDamage(caster)
	local caster = t.caster			 --获取施法者
	local ability = t.ability
	local bonus_att = caster:GetAttackDamage() * 0.05
	local targets = t.target_entities   --获取传递进来的单位组
	local duration = ability:GetSpecialValueFor("duration")
	local damage= att * t.DexTaken + ability:GetSpecialValueFor("base_damage")
	local cooldamage = damage * 36
	local damageType = ability:GetAbilityDamageType()
	local void_level = ability:GetLevel()
	local scale = 100 + void_level * 25
	local particleName = "particles/skills/shadowdance.vpcf"
	if caster.gift then
		particleName = "particles/skills/shadowdance_gold.vpcf"
	end
	local fxIndex = CreateParticle(particleName,PATTACH_ABSORIGIN_FOLLOW,caster,0.5)
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_shadowmoon_wheeldance_kill", nil)
	--利用Lua的循环迭代，循环遍历每一个单位组内的单位
	for i,unit in pairs(targets) do
		if RollPercentage(30) then
			if HasExclusive(caster,3) then
				CauseDamage(caster,unit,damage * 2,damageType,ability,100,scale)
			else
				CauseDamage(caster,unit,damage,damageType,ability,100,scale)
			end
		else
			CauseDamage(caster,unit,damage,damageType,ability)
		end
		ability:ApplyDataDrivenModifier(caster, unit, "modifier_shadowmoon_wheeldance_stun", nil)
		ability:ApplyDataDrivenModifier(caster, unit, "modifier_shadowmoon_wheeldance", {duration=duration})
		local particle = CreateParticle("particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/pa_arcana_event_glitch.vpcf",PATTACH_ABSORIGIN,caster,2)
		ParticleManager:SetParticleControl( particle, 0, unit:GetAbsOrigin() )
		AbstrusemoonShadow({caster=caster,target=unit,ability=caster:GetAbilityByIndex(0)})
	end
	if HasExclusive(caster,4) and caster:HasModifier("modifier_shadow_rift_garrotte") then
		ability:EndCooldown()
		ability:StartCooldown(0.25)
	end
end
function ShadowmoonWheeldanceCooldown( t )
	local caster = t.caster
	local ability = t.ability
	local cooldown_remaining = ability:GetCooldownTimeRemaining() * 0.9
	if ability:IsCooldownReady() == false then
		ability:EndCooldown()
		ability:StartCooldown(cooldown_remaining)
	end
end
function VoidBlink(t)
	local caster = t.caster
	local ability = t.ability
	local target_location = t.target_points[1]
	local caster_location = caster:GetAbsOrigin()
	local difference = target_location - caster_location
	local range = ability:GetSpecialValueFor("blink_range")
	if difference:Length2D() > range then
		target_location = caster_location + (target_location - caster_location):Normalized() * range
	end
	local teamNumber = caster:GetTeamNumber()
	local targetTeam = ability:GetAbilityTargetTeam()
	local targetType = ability:GetAbilityTargetType()
	local distance = (target_location - caster_location):Length2D()
	local targetDirection = (target_location - caster_location):Normalized()
	local particleName = "particles/skills/void_blink.vpcf"
	if caster.gift then
		particleName = "particles/skills/void_blink_gold_start.vpcf"
	end
	local fxIndex = CreateParticle(particleName,PATTACH_ABSORIGIN,caster,0.5)
	ParticleManager:SetParticleControlForward(fxIndex,0,targetDirection)
	ParticleManager:SetParticleControl( fxIndex, 2, targetDirection * distance )
	caster:SetForwardVector(targetDirection)
	ProjectileManager:ProjectileDodge(caster)
	local unitGroup = FindUnitsInLine( teamNumber, caster_location, target_location, nil, 200, targetTeam, targetType, FIND_CLOSEST)
	for k,v in pairs(unitGroup) do
		local damage = ability:GetSpecialValueFor("damage") * caster:GetAverageTrueAttackDamage(caster)  + ability:GetSpecialValueFor("base_damage")
		local damageType = t.ability:GetAbilityDamageType()
		local void_level = caster:GetAbilityByIndex(3):GetLevel()
		local scale = 100 + void_level * 25
		if RollPercentage(30) then
			if HasExclusive(caster,3) then
				CauseDamage(caster,v,damage * 2,damageType,ability,100,scale)
			else
				CauseDamage(caster,v,damage,damageType,ability,100,scale)
			end
		else
			CauseDamage(caster,v,damage,damageType,ability)
		end
		AbstrusemoonShadow({caster=caster,target=v,ability=caster:GetAbilityByIndex(0)})
	end
	SetUnitPosition(caster, target_location)
end
function ClustersStars( t )
	local caster = t.caster
	local target = t.target
	local ability = t.ability
	local void_level = t.ability:GetLevel()
	local scale = 100 + void_level * 25
	local damage = caster:GetAverageTrueAttackDamage(caster) * scale * 0.01
	if HasExclusive(caster,3) then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_clusters_stun", nil)
		CauseDamage(caster,target,damage * 2,DAMAGE_TYPE_PHYSICAL,ability,100,200)
	end
end
function ShadowRiftGarrotte(t)
	--PrintTable(t)
	local caster = t.caster
	local ability = t.ability
	local casterPos = caster:GetAbsOrigin()
	local teamNumber = caster:GetTeamNumber()
	local targetTeam = ability:GetAbilityTargetTeam()
	local targetType = ability:GetAbilityTargetType()
	local targetFlag = ability:GetAbilityTargetFlags()
	local time = 0
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_shadow_rift_garrotte", nil)
	Timers:CreateTimer(function ()
		if time < 60 then
			local enemycount = FindUnitsInRadius(teamNumber, casterPos, caster, 900, targetTeam, targetType, targetFlag, 0, false)
			local smallenemycount = FindUnitsInRadius(teamNumber, casterPos, caster, 400, targetTeam, targetType, targetFlag, 0, false)
			local maxrange = 900
			local minrange = -900
			if #enemycount <= 10 and #smallenemycount == #enemycount and #smallenemycount ~= 0 then 
				maxrange = 400
				minrange = -400
			end
			local point = Vector( casterPos.x + RandomInt(minrange,maxrange), casterPos.y + RandomInt(minrange,maxrange), casterPos.z )
			local casterOrigin = caster:GetAbsOrigin()
			local distance = (point - casterOrigin):Length2D()
			local targetDirection = (point - casterOrigin):Normalized() 
			caster:SetForwardVector(targetDirection)
			local particleName = "particles/skills/void_blink.vpcf"
			if caster.gift then
				particleName = "particles/skills/void_blink_gold_start.vpcf"
				if time%2 == 0 then
					CreateParticle("particles/skills/shadowdance_rope_gold.vpcf",PATTACH_ABSORIGIN_FOLLOW,caster,1)
				end
			end
			local fxIndex = CreateParticle(particleName,PATTACH_ABSORIGIN,caster,0.5)
			ParticleManager:SetParticleControlForward(fxIndex,0,targetDirection)
			ParticleManager:SetParticleControl( fxIndex, 2, targetDirection * distance )
			ProjectileManager:ProjectileDodge(caster)
			local unitGroup = FindUnitsInLine( teamNumber, casterPos, point, nil, 200, targetTeam, targetType, FIND_CLOSEST)
			for k,v in pairs(unitGroup) do
				local damage = ability:GetSpecialValueFor("damage") * caster:GetAverageTrueAttackDamage(caster)
				local damageType = t.ability:GetAbilityDamageType()
				local void_level = caster:GetAbilityByIndex(3):GetLevel()
				local scale = 100 + void_level * 25
				if RollPercentage(30) then
					if HasExclusive(caster,3) then
						CauseDamage(caster,v,damage * 2,damageType,ability,100,scale)
					else
						CauseDamage(caster,v,damage,damageType,ability,100,scale)
					end
				else
					CauseDamage(caster,v,damage,damageType,ability)
				end
				AbstrusemoonShadow({caster=caster,target=v,ability=caster:GetAbilityByIndex(0)})
			end
			SetUnitPosition(caster, point)	
			time = time + 1
			caster:PrecacheScriptSound("soundevents/game_sounds_heroes/game_sounds_queenofpain.vsndevts")
			EmitSoundOn("Hero_QueenOfPain.Blink_out",t.caster)
			CreateParticle("particles/heroes/warden/clusters_stars_active_gold.vpcf",PATTACH_ABSORIGIN,caster,2)
			return 0.04
		end
		caster:RemoveModifierByName("modifier_shadow_rift_garrotte")
		SetUnitPosition(caster, casterPos)
	end)
	-- 专属
	if HasExclusive(caster,4) then
		caster:GetAbilityByIndex(1):EndCooldown()
	end
end