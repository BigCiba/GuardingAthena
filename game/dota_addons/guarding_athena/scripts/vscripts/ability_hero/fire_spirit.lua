function OnCreated( t )
	local caster = t.caster
	local ability = t.ability
	local abilityIndex = t.ability:GetAbilityIndex()
	if abilityIndex == 0 then
		if not caster.firetable then
			caster.firetable = {}
		end
		ability.cooldown_reduce = false
	elseif abilityIndex == 1 then
	elseif abilityIndex == 2 then
	elseif abilityIndex == 3 then
		caster.bonusdamage = ability:GetSpecialValueFor("damage")
	elseif abilityIndex == 4 then
		caster.ultimate = ability:GetSpecialValueFor("damage")
		caster.bonusbuff = ability:GetSpecialValueFor("attack")
		ability.effect = PlayEffect( caster,4 )
		--print(caster.ultimate)
	end
end
function OnDestroy( t )
	local caster = t.caster
	local ability = t.ability
	local abilityIndex = t.ability:GetAbilityIndex()
	if abilityIndex == 0 then
	elseif abilityIndex == 1 then
	elseif abilityIndex == 2 then
	elseif abilityIndex == 3 then
		caster.bonusdamage = false
	elseif abilityIndex == 4 then
		caster.ultimate = 1
		caster.bonusbuff = 0
		caster:RemoveModifierByName("modifier_fire_spirit_4_buff")
		ParticleManager:DestroyParticle(ability.effect,false)
	end
end
function OnAttackLanded( t )
	local caster = t.caster
	local target = t.target
	local ability = t.ability
	local damage = t.DamageTaken * caster.bonusdamage
	DealDamage(caster,target,damage,false)
end
function OnDealDamage( t )
	local caster = t.caster
	local target = t.target
	local ability = t.ability
	ApplyModifier( caster,target,ability )
	if caster:HasModifier("modifier_fire_spirit_1_2") then
		local unitGroup = GetUnitsInRadius( caster, ability, target:GetAbsOrigin(), 600 )
		DealDamage(caster,unitGroup,caster:GetAverageTrueAttackDamage(caster),true)
	end
end
function OnCastAbility( t )
	local abilityIndex = t.ability:GetAbilityIndex()
	if abilityIndex == 0 then
		CastAbility0(t)
	elseif abilityIndex == 1 then
		CastAbility1(t)
	elseif abilityIndex == 2 then
		CastAbility2(t)
	elseif abilityIndex == 3 then
	elseif abilityIndex == 4 then
	end
end
function OnProjectileHitUnit(t)
	local caster = t.caster
	local target = t.target
	local ability = t.ability
	local ability_0 = caster:FindAbilityByName("fire_spirit_0")
	local damage = (caster:GetAgility() * ability:GetSpecialValueFor("damage") + ability:GetSpecialValueFor("base_damage")) * ability.power
	OnDealDamage({caster = caster,target = target,ability = ability_0})
	DealDamage( caster,target,damage,false )
end
function OnIntervalThink( t )
	local caster = t.caster
	local ability = t.ability
	local abilityIndex = ability:GetAbilityIndex()
	if abilityIndex == 0 then
		if HasExclusive(caster,3) then
			local target = t.target
			local ability_0 = caster:FindAbilityByName("fire_spirit_0")
			local damage = target.firemark * caster:GetAgility()
			CauseDamage(caster,target,damage,DAMAGE_TYPE_PHYSICAL)
			if caster.bonusdamage then
				CauseDamage(caster,target,damage * caster.bonusdamage,DAMAGE_TYPE_MAGICAL,ability)
				ApplyModifier( caster,target,ability_0 )
			end
		end
	elseif abilityIndex == 3 then
		if HasExclusive(caster,4) then
			local loc = caster:GetAbsOrigin()
			local ability_0 = caster:FindAbilityByName("fire_spirit_0")
			local ability_1 = caster:FindAbilityByName("fire_spirit_1")
			local damage = 2 * caster:GetAgility() * ability_1:GetSpecialValueFor("damage") + ability_1:GetSpecialValueFor("base_damage")
			local radius = ability:GetSpecialValueFor("radius")
			local unitGroup = GetUnitsInRadius(caster,ability,loc,radius)
			for k,unit in pairs(unitGroup) do
				local p1 = CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleightoffist_trail.vpcf",PATTACH_ABSORIGIN,caster,2)
				ParticleManager:SetParticleControl( p1, 0, caster:GetAbsOrigin())
				ParticleManager:SetParticleControl( p1, 1, unit:GetAbsOrigin())
				caster:PerformAttack(unit,true,true,true,false,false,false,true)
				OnDealDamage({caster = caster,target = unit,ability = ability_0})
				DealDamage( caster,unit,damage,false )
			end
		end
	elseif abilityIndex == 4 then
		local expend_health = caster:GetMaxHealth() * ability:GetSpecialValueFor("health_regen") * 0.1
		local attack = math.floor(expend_health * ability:GetSpecialValueFor("attack"))
		ability:ApplyDataDrivenModifier(caster,caster,"modifier_fire_spirit_4_buff",nil)
		caster:SetModifierStackCount("modifier_fire_spirit_4_buff",caster,attack)
		if caster:GetHealth() > expend_health * 10 then
			if not caster:IsMagicImmune() then
				caster:SetHealth(caster:GetHealth() - expend_health)
			end
		else
			local t_order = 
			{
				UnitIndex = caster:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_TOGGLE,
				AbilityIndex = ability:entindex(),
				Queue = 0
			}
			caster:SetContextThink(DoUniqueString("order") , function() ExecuteOrderFromTable(t_order) end, 0)
		end
	end
end
function OnChannelFinish( t )
	local caster = t.caster
	local target = t.target
	local ability = t.ability
	Timers:RemoveTimer(ability.timer)
	local distance = 850 + 500 * ability.power
	local caster_location = caster:GetAbsOrigin()
	local point = ability.target_point
	local startTime = GameRules:GetGameTime()
    local endTime = startTime + 2
    local velocity = (point - caster_location):Normalized() * 3600
	local projID = ProjectileManager:CreateLinearProjectile( {
	        Ability             = ability,
	        EffectName          = "particles/skills/fire_spirit_2_0.vpcf",
	        vSpawnOrigin        = caster_location,
	        fDistance           = distance,
	        fStartRadius        = 200,
	        fEndRadius          = 200,
	        Source              = caster,
	        bHasFrontalCone     = false,
	        bReplaceExisting    = false,
	        iUnitTargetTeam     = DOTA_UNIT_TARGET_TEAM_ENEMY,
	        iUnitTargetFlags    = DOTA_UNIT_TARGET_FLAG_NONE,
	        iUnitTargetType     = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	        fExpireTime         = endTime,
	        bDeleteOnHit        = false,
	        vVelocity           = velocity,
	        bProvidesVision     = true,
	        iVisionRadius       = 0,
	        iVisionTeamNumber   = caster:GetTeamNumber(),
	    } )
end
function OnRemoveModifier( t )
	-- 单位死亡，持续时间结束，主动触发
	local caster = t.caster
	local target = t.target
	local ability = t.ability
	local caster_location = caster:GetAbsOrigin()
	local unitGroup = GetUnitsInRadius(caster,ability,caster_location,200)
	local stackcount = target.firemark
	target.firemark = 0
	local damage = caster:GetAgility() * stackcount
	DeleteUnit( caster,target )
	DealDamage(caster,unitGroup,damage,true)
	PlaySound(caster,0)
	PlayEffect(target,0)
end
function DealDamage( caster,unitGroup,damage,group )
	local ultimate = caster.ultimate or 1
	local ability_0 = caster:FindAbilityByName("fire_spirit_0")
	if group then
		for k,v in pairs(unitGroup) do
			local stackcount = v.firemark or 0
			if stackcount > 200 then stackcount = 200 end
			damage = damage * (1 + stackcount * 0.01) * ultimate
			CauseDamage(caster,v,damage,DAMAGE_TYPE_PHYSICAL,ability)
			if caster.bonusdamage then
				CauseDamage(caster,v,damage * caster.bonusdamage,DAMAGE_TYPE_MAGICAL,ability)
				ApplyModifier( caster,v,ability_0 )
			end
		end
	else
		local stackcount = unitGroup.firemark or 0
		if stackcount > 200 then stackcount = 200 end
		damage = damage * (1 + stackcount * 0.01) * ultimate
		CauseDamage(caster,unitGroup,damage,DAMAGE_TYPE_PHYSICAL)
		if caster.bonusdamage then
			CauseDamage(caster,unitGroup,damage *caster.bonusdamage,DAMAGE_TYPE_MAGICAL,ability)
			ApplyModifier( caster,unitGroup,ability_0 )
		end
	end
end
function PlaySound( caster,index )
	if caster.playing_sound == nil then
		caster.playing_sound = false
	end
	if index == 0 then
		if caster.playing_sound == false then
			local time = 0
			caster.playing_sound = true
			Timers:CreateTimer(function ()
				if time < 6 then
					CreateSound("Hero_EmberSpirit.SleightOfFist.Damage",caster,2,nil)
					time = time + 1
					return 0.03
				else
					caster.playing_sound = true
				end
			end)
		end
	elseif index == 1 then
		CreateSound("Hero_EmberSpirit.Attack",caster,2,nil)
		caster.playing_sound = true
		Timers:CreateTimer(2,function ()
			caster.playing_sound = false
		end)
	end
end
function PlayEffect( caster,index )
	if index == 0 then
		CreateParticle("particles/skills/fire_spirit_0_1.vpcf",PATTACH_ABSORIGIN,caster,2)
	elseif index == 1 then
		local p0 = CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_caster.vpcf",PATTACH_ABSORIGIN,caster,2)
		return p0
	elseif index == 4 then
		local p0 = CreateParticle( "particles/skills/fire_spirit_4.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, caster )
		ParticleManager:SetParticleControl( p0, 1, Vector(100,100,100))
		ParticleManager:SetParticleControl( p0, 4, Vector(100,100,100))
		return p0
	end
end
function ApplyModifier( caster,target,ability )
	local modifierName = "modifier_fire_spirit_0_debuff"
	if not target:IsAlive() or target:IsMagicImmune() then
		return
	end
	local bonusbuff = caster.bonusbuff or 0
	local buffcount = bonusbuff + 1
	if target:HasModifier(modifierName) then
		ability:ApplyDataDrivenModifier(caster,target,modifierName,nil)
		target:SetModifierStackCount(modifierName,caster,target:GetModifierStackCount(modifierName,caster) + buffcount)
		target.firemark = target.firemark + buffcount
	else
		ability:ApplyDataDrivenModifier(caster,target,modifierName,nil)
		target:SetModifierStackCount(modifierName,caster,buffcount)
		target.firemark = buffcount
		SaveUnit( caster,target )
	end
end
function SaveUnit( caster,unit )
	table.insert(caster.firetable, unit)
end
function DeleteUnit( caster,unit )
	for k, v in pairs( caster.firetable ) do
		if v == unit then
			table.remove(caster.firetable, k)
			break
		end
	end
end
function CastAbility0( t )
	local caster = t.caster
	local newtable = {}
	for k,v in pairs(caster.firetable) do
		if not v:IsNull() then
			table.insert(newtable, v)
		end
	end
	for i, unit in pairs( newtable ) do
		unit:RemoveModifierByName("modifier_fire_spirit_0_debuff")
	end
end
function CastAbility1( t )
	local caster = t.caster
	local target = t.target
	local ability = t.ability
	local caster_location = caster:GetAbsOrigin()
	local target_location = target:GetAbsOrigin()
	local damage = caster:GetAverageTrueAttackDamage(caster) * ability:GetSpecialValueFor("damage") + ability:GetSpecialValueFor("base_damage")
	local center = Vector((caster_location.x + target_location.x) * 0.5, (caster_location.y + target_location.y) * 0.5,caster_location.z)
	local radius = 600
	-- unit filter
	local unitGroup = GetUnitsInRadius(caster,ability,target_location,radius)
	local buffGroup = {}
	local noBuffGroup = {}
	local finalGroup = {}
	-- 筛选单位组
	for k,v in pairs(unitGroup) do
		if v:IsAlive() then
			if v:HasModifier("modifier_fire_spirit_0_debuff") then
				table.insert(buffGroup, v)
			else
				table.insert(noBuffGroup, v)
			end
		end
	end
	-- 把有buff的单位加入最终单位组
	for k,v in pairs(buffGroup) do
		table.insert(finalGroup, v)
	end
	-- 筛选没有buff的6个随机单位
	if #noBuffGroup == 0 then
		for i = 1,6 do
			table.insert(finalGroup, buffGroup[RandomInt(1,#buffGroup)])
		end
	else
		for i = 1,6 do
			table.insert(finalGroup, noBuffGroup[RandomInt(1,#noBuffGroup)])
		end
	end
	local duration = #finalGroup * 0.1
	caster:AddNewModifier(nil, nil, "modifier_phased", {duration=duration})
	ability:ApplyDataDrivenModifier(caster,caster,"modifier_fire_spirit_1",{duration=duration})
	if HasExclusive(caster,2) then
		ability:ApplyDataDrivenModifier(caster,caster,"modifier_fire_spirit_1_2",{duration=duration})
	end
	--caster:AddNoDraw()
	caster:SetModelScale(0.01)
	local p0 = PlayEffect(caster,1)
	local time = 1
	local ability_0 = caster:FindAbilityByName("fire_spirit_0")
	Timers:CreateTimer(function (  )
		if time < #finalGroup then
			local unit = finalGroup[time]
			if unit:IsAlive() then
				local p1 = CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleightoffist_trail.vpcf",PATTACH_ABSORIGIN,caster,2)
				ParticleManager:SetParticleControl( p1, 0, caster:GetAbsOrigin())
				ParticleManager:SetParticleControl( p1, 1, unit:GetAbsOrigin())
				SetUnitPosition(caster,unit:GetAbsOrigin())
				caster:PerformAttack(unit,true,true,true,false,false,false,true)
				SetUnitPosition(caster,caster_location)
				PlaySound(caster,1)
				OnDealDamage({caster = caster,target = unit,ability = ability_0})
				DealDamage( caster,unit,damage,false )
				time = time + 1
				return 0.1
			else
				time = time + 1
				return 0
			end
		else
			local p1 = CreateParticle("particles/units/heroes/hero_ember_spirit/ember_spirit_sleightoffist_trail.vpcf",PATTACH_ABSORIGIN,caster,2)
			ParticleManager:SetParticleControl( p1, 0, caster:GetAbsOrigin())
			ParticleManager:SetParticleControl( p1, 1, target:GetAbsOrigin())
			SetUnitPosition(caster,target:GetAbsOrigin())
			--caster:RemoveNoDraw()
			caster:SetModelScale(1)
			ParticleManager:DestroyParticle(p0,false)
			PlaySound(caster,1)
			--CreateSound("Hero_EmberSpirit.Attack",caster,2,nil)
			OnDealDamage({caster = caster,target = target,ability = ability_0})
			caster:PerformAttack( target, true, true, true, false, false, false, true )
			DealDamage( caster,target,damage,false )
			-- 刷新技能
			if caster:HasModifier("modifier_fire_spirit_1_3") then
				local stack = caster:GetModifierStackCount("modifier_fire_spirit_1_3", caster)
				if stack > 1 then
					caster:SetModifierStackCount("modifier_fire_spirit_1_3", caster, caster:GetModifierStackCount("modifier_fire_spirit_1_3", caster) - 1)
				else
					caster:RemoveModifierByName("modifier_fire_spirit_1_3")
				end
				ability:EndCooldown()
			end
		end
	end)
end
function CastAbility2( t )
	local caster = t.caster
	local target = t.target
	local ability = t.ability
	ability.power = 0
	local caster_location = caster:GetAbsOrigin()
	local point = t.target_points[1]
	ability.target_point = point
	local direction = (point - caster_location):Normalized()
	local time = 0
	caster:AddNewModifier(nil, nil, "modifier_phased", {duration=0.5})
	ability:ApplyDataDrivenModifier(caster,caster,"modifier_fire_spirit_2",{duration=0.5})
	--caster:AddNoDraw()
	caster:SetModelScale(0.01)
	local p3 = CreateParticle("particles/skills/fire_spirit_2_1.vpcf",PATTACH_ABSORIGIN,caster,0.4)
	ParticleManager:SetParticleControl( p3, 0, caster_location)
	ParticleManager:SetParticleControl( p3, 1, direction * -900)
	Timers:CreateTimer(function ()
		if time < 10 and caster:IsChanneling() then
			time = time + 1
			caster_location = caster:GetAbsOrigin()
			SetUnitPosition(caster,caster_location - direction * 35)
			return 0.03
		else
			--caster:RemoveNoDraw()
			caster:SetModelScale(1)
			caster:RemoveModifierByName("modifier_phased")
			caster:RemoveModifierByName("modifier_fire_spirit_2")
			ParticleManager:DestroyParticle(p3,false)
		end
	end)
	ability.timer = Timers:CreateTimer(function ()
		ability.power = ability.power + 0.2
		return 0.1
	end)
end
function OnExclusiveCreated( t )
	local caster = t.caster
	local ability = caster:FindAbilityByName("fire_spirit_1")
	ability.exclusive_timer = Timers:CreateTimer(function ()
		if HasExclusive(caster,1) then
			if caster:GetModifierStackCount("modifier_fire_spirit_1_3", caster) < 2 then
				ability:ApplyDataDrivenModifier(caster, caster, "modifier_fire_spirit_1_3", nil)
				AddModifierStackCount(caster,caster,ability,"modifier_fire_spirit_1_3",1)
			end
		end
		return 8
	end)
end
function OnExclusiveDestroy( t )
	local caster = t.caster
	local ability = caster:FindAbilityByName("fire_spirit_1")
	Timers:RemoveTimer(ability.exclusive_timer)
	caster:RemoveModifierByName("modifier_fire_spirit_1_3")
end