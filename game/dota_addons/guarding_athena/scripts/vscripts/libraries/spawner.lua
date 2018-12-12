--[[ 
	包含以下功能：
	-进攻刷怪
	-突袭刷怪
	-野怪刷新
	-属性设定
	-自动进攻
	-左上任务标题
	-练功房积分
	-召唤沙王
	使用：
	-在游戏开始前Spawner:Init()
	-在第一次开始刷怪的时间使用Spawner:AutoSpawn()
]]
if Spawner == nil then
	--print ( '[Spawner] creating Spawner' )
	Spawner = {}
	Spawner.__index = Spawner
end
-- 初始化
function Spawner:Init()
  --print ( '[Spawner] Spawner Init' )
  self:ReadKeyValue()
  self:Setting()
  self:AttackOnTarget()
  self:QuestCountDown()
  ListenToGameEvent('entity_killed', Dynamic_Wrap(Spawner, 'OnUnitKilled'), self)
end
-- 读取kv数据
function Spawner:ReadKeyValue()
  --print ( '[Spawner] Spawner ReadKeyValue' )
  self.kvTable = LoadKeyValues("scripts/kv/spawn_info.kv")
end
-- 设定数据
function Spawner:Setting()
	--print ( '[Spawner] Spawner Setting' )
	local kv = self.kvTable
	self.maxWave = kv.max_wave													--最大波数
	self.spawnList = kv.spawn_list												--刷怪表
	self.spawnInterval = kv.spawn_interval										--刷怪间隔
	self.spawnerList = kv.spawner_list											--刷怪实体
	self.spawnerLocation = {}													--刷怪实体位置
	for k, v in pairs( self.spawnerList ) do
		self.spawnerLocation[k] = Entities:FindByName(nil,v):GetAbsOrigin()
	end
	self.wayPoint = Entities:FindByName(nil,"athena"):GetAbsOrigin()			--进攻位置
	self.bossSpawnPoint = Entities:FindByName(nil,"path_mid"):GetAbsOrigin()	--Boss刷新点
	self.specialRushSpawnPoint = {												--突袭刷怪点
		Entities:FindByName(nil,"special_rush_1"):GetAbsOrigin(),
		Entities:FindByName(nil,"special_rush_2"):GetAbsOrigin(),
		Entities:FindByName(nil,"special_rush_3"):GetAbsOrigin(),
		Entities:FindByName(nil,"special_rush_4"):GetAbsOrigin(),
	}
	self.playerCount = PlayerResource:GetPlayerCount()							--玩家数量
	self.attackOrderInterval = 5												--自动发布攻击命令间隔
	self.unitRemaining = {}														--进攻怪剩余表
	self.bossCurrent = false													--当前Boss
	self.spawnerTimer = nil														--刷怪计时器
	self.difficulty = GameRules:GetDifficulty() or 2							--难度
	self.gameRound = 0															--游戏波数
	self.spawnCount = 0															--刷怪数量
	self.unitFactor = {
		maxDamageRandomFactor = self.difficulty * 0.2 + 1.2,					--最大攻击系数
		maxArmorRandomFactor = self.difficulty * 0.2 + 1.2,						--最大护甲系数
		maxHealthRandomFactor = self.difficulty * 0.2 + 1.2,					--最大生命系数
		maxMeleeDamageFactor = 1,												--最大近战攻击系数
		difficultyFactor = 1.5 ^ self.difficulty,								--难度系数
		waveFactor = 1 + 0.01 * self.difficulty,								--波数系数
		eliteFactor = 1 + 0.01 * self.difficulty								--精英怪系数
	}
	self.damageRecorder = {}													--每波施加伤害记录器
	self.victimRecorder = {}													--每波承受伤害记录器
	-- 野怪
	self.natureList = kv.nature_list											--读取野怪资料
	self.natureSpawnInterval = 20												--野怪刷新间隔
	self.natureRemaining = {}													--野怪剩余数量
	self.natureName = {}														--野怪名字
	self.natureBossName = {}													--野怪首领名字
	self.natureMaxCount = {}													--野怪最大数量
	self.natureBossSpawnRate = {}												--野怪首领刷新率
	self.natureCampLocation = {}												--野怪营地位置
	for k, v in pairs( self.natureList ) do
		self.natureRemaining[k] = {}
		self.natureName[k] = self.natureList[k].unitName
		self.natureBossName[k] = self.natureList[k].bossName
		self.natureMaxCount[k] = self.natureList[k].maxCount
		self.natureBossSpawnRate[k] = self.natureList[k].bossRate
		self.natureCampLocation[k] = Entities:FindByName(nil,self.natureList[k].campName):GetAbsOrigin()
	end
	self.natureFactor = {
		maxDamageRandomFactor = self.difficulty * 0.2 + 1.2,					--野怪最大攻击系数
		maxArmorRandomFactor = self.difficulty * 0.2 + 1.2,						--野怪最大护甲系数
		maxHealthRandomFactor = self.difficulty * 0.2 + 1.2,					--野怪最大生命系数
		maxMeleeDamageFactor = 0,												--野怪最大近战攻击系数
		difficultyFactor = 1,													--难度系数
		waveFactor = 1 + 0.01 * self.difficulty									--波数系数
	}
	-- 特殊进攻
	self.specialRushList = kv.special_rush_list									--读取图像资料
	self.specialRushUnitList = {}												--突袭单位列表
	self.specialRush = 0														--突袭波数
	self.specialRushTime = 130													--突袭持续时间
	self.specialRushIntervalTime = 8 - self.difficulty							--突袭刷怪间隔
	self.specialRushUnitRemaining = {}											--突袭怪物剩余
	self.specialRushFactor = {
		maxDamageRandomFactor = self.difficulty * 0.2 + 1.2,					--最大攻击系数
		maxArmorRandomFactor = self.difficulty * 0.2 + 1.2,						--最大护甲系数
		maxHealthRandomFactor = self.difficulty * 0.2 + 1.2,					--最大生命系数
		maxMeleeDamageFactor = 0,												--最大近战攻击系数
		difficultyFactor = 1.5 ^ self.difficulty,								--难度系数
		waveFactor = 1 + 0.01 * self.difficulty									--波数系数
	}
end
-- 开始自动刷怪
function Spawner:AutoSpawn()
	--print ( '[Spawner] Spawner AutoSpawn' )
	self.spawnerTimer = Timers:CreateTimer(function()
		self:UpData()
		self:DoSpawn()
		self:QuestPanel()
		if self.spawnSound then
			for i=1,PlayerResource:GetPlayerCountForTeam( DOTA_TEAM_GOODGUYS ) do
				EmitSoundOnClient(self.spawnSound, PlayerResource:GetPlayer(i-1))
			end
		end
		if self.gameRound < self.maxWave then
			return self.spawnInterval
		end
	end)
end
-- 暂停刷怪
function Spawner:PauseSpawn(duration)
	Timers:RemoveTimer(self.spawnerTimer)
	Timers:CreateTimer(duration,function ()
		self.AutoSpawn()
	end)
end
-- 刷怪
function Spawner:DoSpawn()
	--print ( '[Spawner] Spawner DoSpawn' )
	for i=1,self.spawnCount do
		for k, v in pairs( self.spawnerLocation ) do
			PrecacheUnitByNameAsync(self.unitName,function()
		    	local unit = CreateUnitByName(self.unitName, self.spawnerLocation[k], true, nil, nil, DOTA_TEAM_BADGUYS ) 
		    	self:UnitProperty(unit,self.unitFactor)
		    	table.insert(self.unitRemaining, unit)
		    	unit.wave = self.gameRound
			end)
		end
	end
	if self.captainName then
		for k, v in pairs( self.spawnerLocation ) do
			PrecacheUnitByNameAsync(self.captainName,function()
		    	local unit = CreateUnitByName(self.captainName, self.spawnerLocation[k], true, nil, nil, DOTA_TEAM_BADGUYS ) 
				self:UnitProperty(unit,self.unitFactor)
		    	table.insert(self.unitRemaining, unit)
		    	unit.wave = self.gameRound
				AI:CreateAI(unit)
			end)
		end
	end
	if self.bossName then
		Timers:CreateTimer(self.bossSpawnDelay,function ()
			PrecacheUnitByNameAsync(self.bossName,function()
		    	local boss = CreateUnitByName(self.bossName, self.bossSpawnPoint, true, nil, nil, DOTA_TEAM_BADGUYS ) 
		    	self.bossCurrent = boss
		    	self:UnitProperty(boss,self.unitFactor)
		    	Notifications:TopToTeam(2, {text="#"..self.bossName, style={color="red", ["font-size"]="80px"}, duration=3, continue = false})
		    	for i=1,PlayerResource:GetPlayerCountForTeam( DOTA_TEAM_GOODGUYS ) do
					EmitSoundOnClient(self.bossSpawnSound, PlayerResource:GetPlayer(i-1))
				end
			end)
		end)
	end
	if self.specialRush then
		self:InitSpecialRush(self.specialRush)
	end
end
-- 更新下一波数据
function Spawner:UpData()
	--print ( '[Spawner] Spawner UpData' )
	self.gameRound = self.gameRound + 1
	self.spawnCount = self.spawnList["wave_"..self.gameRound].unitCount
	self.spawnSound = self.spawnList["wave_"..self.gameRound].spawnSound or false
	self.unitName = self.spawnList["wave_"..self.gameRound].unitName
	self.captainName = self.spawnList["wave_"..self.gameRound].captainName or false
	self.bossName = self.spawnList["wave_"..self.gameRound].bossName or false
	self.bossSpawnDelay = self.spawnList["wave_"..self.gameRound].spawnDelay or 0
	self.bossSpawnSound = self.spawnList["wave_"..self.gameRound].bossSpawnSound or ""
	self.specialRush = self.spawnList["wave_"..self.gameRound].specialRush or false
	self.damageRecorder[self.gameRound] = 0
end
-- 设置单位属性
function Spawner:UnitProperty( unit,factor )
	HeroState:InitUnit(unit)
	if factor.maxMeleeDamageFactor == 1 then
		if not unit:IsRangedAttacker() then
			factor.maxMeleeDamageFactor = (self.gameRound ^ 2 - self.gameRound +100) * 0.01
		end
	else
		factor.maxMeleeDamageFactor = 1
	end
	local unitDamageFactor = RandomFloat(1,factor.maxDamageRandomFactor) * factor.difficultyFactor * factor.maxMeleeDamageFactor * factor.waveFactor ^ self.gameRound
	local unitArmorFactor = RandomFloat(1,factor.maxArmorRandomFactor) * factor.difficultyFactor * factor.waveFactor ^ self.gameRound
	local unitHealthFactor = RandomFloat(1,factor.maxHealthRandomFactor) * factor.difficultyFactor * factor.waveFactor ^ self.gameRound
	unit:SetDeathXP(unit:GetDeathXP() * 1.6)
	unit:SetMinimumGoldBounty(unit:GetGoldBounty() * 1.6)
	unit:SetMaximumGoldBounty(unit:GetGoldBounty() * 1.6)
	unit:SetBaseDamageMin(unit:GetBaseDamageMin() * unitDamageFactor)
	unit:SetBaseDamageMax(unit:GetBaseDamageMax() * unitDamageFactor)
	--unit:SetBaseDamageMin(unit:GetBaseDamageMin() * (1 + 0.1 * self.difficulty))
	--unit:SetBaseDamageMax(unit:GetBaseDamageMax() * (1 + 0.15 * self.difficulty))
	unit:SetBaseMaxHealth(unit:GetBaseMaxHealth() * unitHealthFactor)
	unit:SetMaxHealth(unit:GetBaseMaxHealth())
	unit:SetHealth(unit:GetBaseMaxHealth())
    --unit:SetBaseMagicalResistanceValue(unit:GetBaseMagicalResistanceValue() * 2)
	--unit:SetPhysicalArmorBaseValue(unit:GetPhysicalArmorBaseValue() * unitArmorFactor)
	-- 精英怪
	--if self.difficulty >= 3 and self.gameRound > 3 and unit:GetUnitName() == "guai_"..self.gameRound then
	if self.difficulty >= 3 and unit:GetUnitName() == "guai_"..self.gameRound then
		if RollPercentage(self.difficulty * 2) then
			unit:AddAbility("elite")
		end
	end
	for i=1,16 do
		if unit:GetAbilityByIndex(i-1) then
			local ability = unit:GetAbilityByIndex(i-1)
		    ability:SetLevel(self.difficulty)
		end
	end
end
-- 循环进攻命令
function Spawner:AttackOnTarget()
	Timers:CreateTimer(function()
		for k, v in pairs( self.unitRemaining ) do
			if v then
				if not v:IsNull() then
					v:MoveToPositionAggressive(self.wayPoint)
				end
			end
		end
		if self.bossCurrent then
			if not self.bossCurrent:IsNull() then
				self.bossCurrent:MoveToPositionAggressive(self.wayPoint)
			end
		end
		for k, v in pairs( self.specialRushUnitRemaining ) do
			if v then
				if not v:IsNull() then
					v:MoveToPositionAggressive(self.wayPoint)
				end
			end
		end
		return self.attackOrderInterval
	end)
end
-- 进攻倒计时
function Spawner:QuestCountDown()
	Timers:CreateTimer(function()
		CustomGameEventManager:Send_ServerToAllClients("time_remaining", {wave=self.gameRound+1})
		if self.gameRound < self.maxWave then
			return self.spawnInterval
		end
	end)
end
-- 直接进入下一波
function Spawner:CallNextWave()
	Timers:ResetDelayTime(self.spawnerTimer,0)
end
-- 怪物剩余
function Spawner:QuestPanel(...)
	local wave = ...
	local key = "monster_remaining"
	local currentWave = self.gameRound
	local count = 0
	local maxCount = self.spawnCount * 4
	if self.captainName then maxCount = maxCount + 4 end
	if wave then
		count = maxCount - table.getn(self.unitRemaining)
		key = "monster_kill"
	end
	CustomGameEventManager:Send_ServerToAllClients(key, {wave=currentWave,max_count=maxCount,count=count})
	if wave == currentWave then
	end
end
-- 野怪刷新
function Spawner:NatureStart()
	self:NatureThink()
end
function Spawner:NatureThink()
	Timers:CreateTimer(function ()
		for k, v in pairs( self.natureList ) do
			if #self.natureRemaining[k] == 0 then
				self:DoNatureSpawn(k)
			end
		end
		return self.natureSpawnInterval
	end)
end
function Spawner:DoNatureSpawn(k)
	for i=1,self.natureMaxCount[k] do
		local point = self.natureCampLocation[k]
		local random_point = Vector( point.x + RandomFloat(-150,150), point.y + RandomFloat(-150,150), point.z )
		if RollPercentage(self.natureBossSpawnRate[k]) then
			PrecacheUnitByNameAsync(self.natureBossName[k],function()
				local nature = CreateUnitByName(self.natureBossName[k], random_point, true, nil, nil, DOTA_TEAM_BADGUYS ) 
				self:UnitProperty(nature,self.natureFactor)
				nature.campIndex = k
				table.insert(self.natureRemaining[k], nature)
			end)
		else
			PrecacheUnitByNameAsync(self.natureName[k],function()
				local nature = CreateUnitByName(self.natureName[k], random_point, true, nil, nil, DOTA_TEAM_BADGUYS ) 
				self:UnitProperty(nature,self.natureFactor)
				nature.campIndex = k
				table.insert(self.natureRemaining[k], nature)
			end)
		end
	end
end
-- 特殊进攻
function Spawner:InitSpecialRush(round)
	self:UpDataSpecialRush(round)
	self:StartSpecialRush()
end
function Spawner:UpDataSpecialRush(round)
	self.currentSpecialRush = self.specialRushList[round]
	self.specialRushSpawnInterval = self.currentSpecialRush["interval"]
	self.specialRushUnit = self.currentSpecialRush["unitType"]
	self.specialRushUnitSpawnRate = self.currentSpecialRush["spawn_rate"]
	self.specialRushEndTime = GameRules:GetGameTime() + self.specialRushTime - (50/self.difficulty)
end
function Spawner:StartSpecialRush()
	Notifications:TopToTeam(2, {text="#"..self.specialRush, style={color="red", ["font-size"]="80px"}, duration=3, continue = false})
	--self:QuestRush("#quest_rush",self.specialRushTime - (50/self.difficulty))
	self:CheckErrorSpawn( self.wayPoint, 4000, 120 )
	Timers:CreateTimer(function ()
		local timeRemaining = self.specialRushEndTime - GameRules:GetGameTime()
		if timeRemaining >= 0 then
			self:DoSpecialRushSpawn()
			return self.specialRushSpawnInterval - self.playerCount
		end
	end)
end
function Spawner:DoSpecialRushSpawn()
	for i=1,#self.specialRushSpawnPoint do
		local point = self.specialRushSpawnPoint[i]
		local randomFactor = RandomInt(1,100)
		local spawnUnitName
		local minRate = 1000
		for k, v in pairs( self.specialRushUnitSpawnRate ) do
			if randomFactor <= self.specialRushUnitSpawnRate[k] then
				if self.specialRushUnitSpawnRate[k] < minRate then
					minRate = self.specialRushUnitSpawnRate[k]
					spawnUnitName = self.specialRushUnit[k]
				end
			end
		end
		local random_point = Vector( point.x + RandomFloat(-500,500), point.y + RandomFloat(-500,500), point.z )
		PrecacheUnitByNameAsync(spawnUnitName,function()
			local nature = CreateUnitByName(spawnUnitName, random_point, true, nil, nil, DOTA_TEAM_BADGUYS )
			nature.wave = self.gameRound
			CreateParticle("particles/econ/events/pw_compendium_2014/teleport_end_ground_flash_pw2014.vpcf",PATTACH_ABSORIGIN,nature,1)
			self:UnitProperty(nature,self.specialRushFactor)
			table.insert(self.specialRushUnitRemaining, nature)
		end)
	end
end
-- 监听死亡
function Spawner:OnUnitKilled( t )
	local caster = EntIndexToHScript(t.entindex_killed)
	local attacker = EntIndexToHScript(t.entindex_attacker)
	if attacker:IsIllusion() then
		if attacker.caster_hero then
			attacker = attacker.caster_hero
		end
	end
	if not attacker:IsRealHero() then
		HeroState:InitUnit(attacker)
	end
	-- 练功房
	if caster.practicer then
		local room = caster.room
		for i, unit in pairs( room.unitRemaining ) do
			if caster == unit then
				table.remove( room.unitRemaining, i )
				break
			end
		end
    	-- 练功积分
    	if attacker:IsRealHero() then
    		attacker.practice = attacker.practice + 1
			attacker.practice_kill = attacker.practice_kill + 1
			attacker.practice_point = attacker.practice_point + 1
    	end
	end
	-- 进攻怪
	for i, unit in pairs( self.unitRemaining ) do
		if caster == unit then
			local point = unit.wave
			-- 守家积分
			if self.spawnCount < 20 then point = 4 * point end
			attacker.wave_def = attacker.wave_def + 1
			attacker.def_point = attacker.def_point + point
			table.remove( self.unitRemaining, i )
			self:QuestPanel(caster.wave)
			break
		end
	end
	for i, unit in pairs( self.specialRushUnitRemaining ) do
		if caster == unit then
			attacker.wave_def = attacker.wave_def + 1
			table.remove( self.specialRushUnitRemaining, i )
			break
		end
	end
	-- 野怪
	if caster.campIndex then
		for i, unit in pairs( self.natureRemaining[caster.campIndex] ) do
			if caster == unit then
				table.remove(self.natureRemaining[caster.campIndex], i)
				break
			end
		end
		local clearZombie = 0
		for i=1,4 do
			if #self.natureRemaining["nature_1"..i] == 0 then
				clearZombie = clearZombie + 1
			end
		end
		if clearZombie == 4 then
			PrecacheUnitByNameAsync("boss_sandking",function()
		    	local point = Entities:FindByName( nil, "boss_sandking_reborn" ):GetAbsOrigin()
		    	if GameRules.sandking then
		    		local unit = CreateUnitByName("boss_sandking", point, true, nil, nil, DOTA_TEAM_BADGUYS )
		    		GameRules.sandking = false
			    	Timers:CreateTimer(TIME_BOSS_REBORN,function ()
			    		GameRules.sandking = true
				    end)
		    	end
			end)
		end
	end
	if caster == self.bossCurrent then
		self.bossCurrent = false
	end
end
-- 检查0血单位
function Spawner:CheckErrorSpawn( point, radius, duration )
	local time = 0
	Timers:CreateTimer(function ()
		if time < duration then
			local unitGroup = FindUnitsInRadius(GuardingAthena.entAthena:GetTeamNumber(), point, GuardingAthena.entAthena, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_DEAD, 0, false)
			for k,v in pairs(unitGroup) do
				if v:GetMaxHealth() <= 0 then
					for i, unit in pairs( self.specialRushUnitRemaining ) do
						if v == unit then
							table.remove( self.specialRushUnitRemaining, i )
							break
						end
					end
					v:RemoveSelf()
				end
			end
			return 1
		end
	end)
end