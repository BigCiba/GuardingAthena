if Demo == nil then
	_G.Demo = class({})
end

local public = Demo

function public:OnRefreshButtonPressed(iEventSourceIndex)
	local heroes = HeroList:GetAllHeroes()
	for n, hHero in pairs(heroes) do
		for i = 0, hHero:GetAbilityCount() - 1 do
			local hAbility = hHero:GetAbilityByIndex(i)
			if hAbility then
				hAbility:AddCharges(1)
				hAbility:RefreshCharges()
			end
		end

		for i = 0, DOTA_ITEM_MAX - 1, 1 do
			local hItem = hHero:GetItemInSlot(i)
			if hItem then
				hItem:EndCooldown()
				hItem:SetCurrentCharges(hItem:GetInitialCharges())
			end
		end

		-- local tModifiers = hHero:FindAllModifiersByName("modifier_charges")
		-- for _, hModifier in pairs(tModifiers) do
		-- 	if hModifier.RefreshCharges ~= nil then
		-- 		hModifier:RefreshCharges()
		-- 	end
		-- end
		hHero:SetHealth(hHero:GetMaxHealth())
		hHero:SetMana(hHero:GetMaxMana())
	end
	-- SendToServerConsole( "dota_dev hero_refresh" )
end
---升级
function public:OnLevelUpButtonPressed(iEventSourceIndex, tData)
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity(tData.PlayerID)
	if hPlayerHero == nil then
		return
	end
	for i = 1, tonumber(tData.str) do
		hPlayerHero:HeroLevelUp(i == tonumber(tData.str))
	end
	-- SendToServerConsole( "dota_dev hero_level 1" )
end
---升级到满级
function public:OnMaxLevelButtonPressed(iEventSourceIndex, tData)
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity(tData.PlayerID)
	if hPlayerHero == nil then
		return
	end

	for i = hPlayerHero:GetLevel() + 1, HERO_MAX_LEVEL, 1 do
		hPlayerHero:HeroLevelUp(i == HERO_MAX_LEVEL)
	end

	for i = 0, hPlayerHero:GetAbilityCount() - 1 do
		local hAbility = hPlayerHero:GetAbilityByIndex(i)
		if hAbility and not hAbility:IsHidden() and not hAbility:IsAttributeBonus() then
			while hAbility:CanAbilityBeUpgraded() == ABILITY_CAN_BE_UPGRADED do
				hPlayerHero:UpgradeAbility(hAbility)
			end
		end
	end

	hPlayerHero:SetAbilityPoints(0)
end

function public:OnDrawPassiveAbilityButtonPressed(iEventSourceIndex, tData)
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity(tData.PlayerID)
	if hPlayerHero == nil then
		return
	end

	PassiveAbility:DrawPassiveAbility(hPlayerHero)
end

function public:OnFreeSpellsButtonPressed(iEventSourceIndex)
	SendToServerConsole("toggle dota_ability_debug")
	if self.m_bFreeSpellsEnabled == false then
		self.m_bFreeSpellsEnabled = true
		self:OnRefreshButtonPressed(iEventSourceIndex)
	elseif self.m_bFreeSpellsEnabled == true then
		self.m_bFreeSpellsEnabled = false
	end
	self:UpdateSettings()
end

function public:OnInvulnerabilityButtonPressed(iEventSourceIndex, tData)
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity(tData.PlayerID)
	local hAllPlayerUnits = {}
	hAllPlayerUnits = hPlayerHero:GetAdditionalOwnedUnits()
	hAllPlayerUnits[#hAllPlayerUnits + 1] = hPlayerHero

	if self.m_bInvulnerabilityEnabled == false then
		for _, hUnit in pairs(hAllPlayerUnits) do
			hUnit:AddNewModifier(hPlayerHero, nil, "lm_take_no_damage", nil)
		end
		self.m_bInvulnerabilityEnabled = true
	elseif self.m_bInvulnerabilityEnabled == true then
		for _, hUnit in pairs(hAllPlayerUnits) do
			hUnit:RemoveModifierByName("lm_take_no_damage")
		end
		self.m_bInvulnerabilityEnabled = false
	end
	self:UpdateSettings()
end

function public:OnSelectHeroButtonPressed(iEventSourceIndex, tData)
	self.m_sHero[tData.PlayerID] = DOTAGameManager:GetHeroUnitNameByID(tonumber(tData.str))
end

function public:OnSpawnAllyButtonPressed(iEventSourceIndex, tData)
	if #self.m_tAlliesList >= 100 then
		return
	end

	local hPlayerHero = PlayerResource:GetSelectedHeroEntity(tData.PlayerID)
	local vPosition = tData.Position

	CreateUnitByNameAsync(self.m_sHero[tData.PlayerID], vPosition, true, hPlayerHero, hPlayerHero, hPlayerHero:GetTeamNumber(), function(hUnit)
		table.insert(self.m_tAlliesList, hUnit:entindex())
		hUnit:SetControllableByPlayer(tData.PlayerID, false)
		hUnit:SetRespawnPosition(vPosition)
		FindClearSpaceForUnit(hUnit, vPosition, false)
		hUnit:Hold()
		hUnit:SetIdleAcquire(false)
		hUnit:SetAcquisitionRange(0)
	end)
end

function public:OnLevelUpAllyButtonPressed(iEventSourceIndex)
	for k, v in pairs(self.m_tAlliesList) do
		local hUnit = EntIndexToHScript(v)
		if IsValid(hUnit) and hUnit:IsRealHero() then
			hUnit:HeroLevelUp(false)
		end
	end
end

function public:OnAllyMaxLevelButtonPressed(iEventSourceIndex)
	for k, v in pairs(self.m_tAlliesList) do
		local hUnit = EntIndexToHScript(v)
		if IsValid(hUnit) and hUnit:IsRealHero() then
			hUnit:AddExperience(XP_PER_LEVEL_TABLE[#XP_PER_LEVEL_TABLE], false, false) -- for some reason maxing your level this way fixes the bad interact with OnHeroReplaced

			for i = 0, hUnit:GetAbilityCount() - 1 do
				local hAbility = hUnit:GetAbilityByIndex(i)
				if hAbility and not hAbility:IsHidden() and not hAbility:IsAttributeBonus() then
					while hAbility:CanAbilityBeUpgraded() == ABILITY_CAN_BE_UPGRADED do
						hUnit:UpgradeAbility(hAbility)
					end
				end
			end

			hUnit:SetAbilityPoints(0)
		end
	end
end

function public:OnSpawnEnemyButtonPressed(iEventSourceIndex, tData)
	if #self.m_tEnemiesList >= 100 then
		return
	end

	local hPlayerHero = PlayerResource:GetSelectedHeroEntity(tData.PlayerID)
	local vPosition = tData.Position

	CreateUnitByNameAsync(self.m_sHero[tData.PlayerID], vPosition, true, hPlayerHero, hPlayerHero, ENEMY_TEAM, function(hEnemy)
		table.insert(self.m_tEnemiesList, hEnemy:entindex())
		hEnemy:SetControllableByPlayer(tData.PlayerID, false)
		hEnemy:SetRespawnPosition(vPosition)
		FindClearSpaceForUnit(hEnemy, vPosition, false)
		hEnemy:Hold()
		hEnemy:SetIdleAcquire(false)
		hEnemy:SetAcquisitionRange(0)
	end)
end

function public:OnLevelUpEnemyButtonPressed(iEventSourceIndex)
	for k, v in pairs(self.m_tEnemiesList) do
		local hUnit = EntIndexToHScript(v)
		if IsValid(hUnit) and hUnit:IsRealHero() then
			hUnit:HeroLevelUp(false)
		end
	end
end

function public:OnEnemyMaxLevelButtonPressed(iEventSourceIndex)
	for k, v in pairs(self.m_tEnemiesList) do
		local hUnit = EntIndexToHScript(v)
		if IsValid(hUnit) and hUnit:IsRealHero() then
			hUnit:AddExperience(HERO_XP_PER_LEVEL_TABLE[#HERO_XP_PER_LEVEL_TABLE], false, false) -- for some reason maxing your level this way fixes the bad interact with OnHeroReplaced

			for i = 0, hUnit:GetAbilityCount() - 1 do
				local hAbility = hUnit:GetAbilityByIndex(i)
				if hAbility and not hAbility:IsHidden() and not hAbility:IsAttributeBonus() then
					while hAbility:CanAbilityBeUpgraded() == ABILITY_CAN_BE_UPGRADED do
						hUnit:UpgradeAbility(hAbility)
					end
				end
			end

			hUnit:SetAbilityPoints(0)
		end
	end
end

function public:OnDummyTargetButtonPressed(iEventSourceIndex, tData)
	local hPlayerHero = PlayerResource:GetSelectedHeroEntity(tData.PlayerID)
	local vPosition = tData.Position

	local hDummy = CreateUnitByName("npc_dota_hero_target_dummy", vPosition, true, hPlayerHero, hPlayerHero, DOTA_TEAM_BADGUYS)
	table.insert(self.m_tEnemiesList, hDummy:entindex())

	hDummy:AddNewModifier(hDummy, nil, "modifier_dummy_damage", nil)
	-- hDummy:SetAbilityPoints(0)
	hDummy:SetControllableByPlayer(tData.PlayerID, false)
	hDummy:Hold()
	hDummy:SetIdleAcquire(false)
	hDummy:SetAcquisitionRange(0)
end

function public:OnRemoveSpawnedUnitsButtonPressed(iEventSourceIndex)
	for k, v in pairs(self.m_tAlliesList) do
		CustomNetTables:SetTableValue("respawn_state", string.format("%d", v), nil)
		local hUnit = EntIndexToHScript(v)
		if hUnit:GetCourier() then
			UTIL_Remove(hUnit:GetCourier())
		end
		if IsValid(hUnit) then
			hUnit:MakeIllusion()
			hUnit:AddNoDraw()
			hUnit:Remove()
		end
		self.m_tAlliesList[k] = nil
	end
	for k, v in pairs(self.m_tEnemiesList) do
		CustomNetTables:SetTableValue("respawn_state", string.format("%d", v), nil)
		local hUnit = EntIndexToHScript(v)
		if IsValid(hUnit) then
			hUnit:MakeIllusion()
			hUnit:AddNoDraw()
			hUnit:Remove()
		end
		self.m_tEnemiesList[k] = nil
	end
end

function public:OnNoCreepsButtonPressed(iEventSourceIndex)
	if self.m_bCreepsEnabled == false then
		self.m_bCreepsEnabled = true
	elseif self.m_bCreepsEnabled == true then
		SendToServerConsole("debug_kill_creeps")
		self.m_bCreepsEnabled = false
	end
	self:UpdateSettings()
end
function public:OnReloadScriptButtonPressed(iEventSourceIndex)
	SendToConsole("cl_script_reload")
	SendToConsole("script_reload")
end

function public:OnSetWinnerPressed(iEventSourceIndex, tData)
	local iTeam = PlayerResource:GetTeam(tData.PlayerID)
	GameRules:SetGameWinner(iTeam)
end

function public:OnRestartButtonPressed(iEventSourceIndex, tData)
	SendToConsole("restart")
end

function public:OnSelectAbilityButtonPressed(iEventSourceIndex, tData)
	self.m_sAbility[tData.PlayerID] = tData.str
end

function public:OnSelectItemButtonPressed(iEventSourceIndex, tData)
	self.m_sItem[tData.PlayerID] = tData.str
end

function public:OnSelectRoundButtonPressed(iEventSourceIndex, tData)
	self.m_iRoundNumber[tData.PlayerID] = tonumber(tData.str)
end

function public:OnAddAbilityButtonPressed(iEventSourceIndex, tData)
	---@type CDOTA_BaseNPC
	local hUnit = tData.Unit
	if IsValid(hUnit) then
		if hUnit:HasAbility(self.m_sAbility[tData.PlayerID]) then
			hUnit:RemoveAbilityByHandle(hUnit:FindAbilityByName(self.m_sAbility[tData.PlayerID]))
		else
			hUnit:AddAbility(self.m_sAbility[tData.PlayerID], 1)
		end
		-- SendToConsole(string.format("debug_add_ability %d %s", hUnit:entindex(), self.m_sAbility[tData.PlayerID]))
	end
end

function public:OnAddItemButtonPressed(iEventSourceIndex, tData)
	local hUnit = tData.Unit
	if IsValid(hUnit) then
		CreateItemToUnit(hUnit, self.m_sItem[tData.PlayerID])
		-- SendToConsole(string.format("debug_add_item %d %s", hUnit:entindex(), self.m_sItem[tData.PlayerID]))
	end
end

function public:OnRemoveInventoryItemsButtonPressed(iEventSourceIndex, tData)
	local hUnit = tData.Unit
	if IsValid(hUnit) and hUnit:HasInventory() then
		for i = DOTA_ITEM_SLOT_1, DOTA_ITEM_SLOT_9, 1 do
			local hItem = hUnit:GetItemInSlot(i)
			if IsValid(hItem) then
				hItem:Remove()
			end
		end
	end
end

function public:OnRollItem1ButtonPressed(iEventSourceIndex, tData)
	SendToConsole(string.format("debug_roll_item_1 %d", tData.Unit:entindex()))
end

function public:OnRollItem2ButtonPressed(iEventSourceIndex, tData)
	SendToConsole(string.format("debug_roll_item_2 %d", tData.Unit:entindex()))
end

function public:OnRollItem3ButtonPressed(iEventSourceIndex, tData)
	SendToConsole(string.format("debug_roll_item_3 %d", tData.Unit:entindex()))
end

function public:OnChangeRoundButtonPressed(iEventSourceIndex, tData)
	SendToConsole(string.format("debug_round_change %d", self.m_iRoundNumber[tData.PlayerID]))
end

function public:OnChangeRoundImmediatelyButtonPressed(iEventSourceIndex, tData)
	SendToConsole(string.format("debug_round_change_immediately %d", self.m_iRoundNumber[tData.PlayerID]))
end

function public:OnSkipButtonPressed(iEventSourceIndex, tData)
	SendToConsole("debug_skip")
end

function public:OnRerollRoundPressed(iEventSourceIndex, tData)
	SendToConsole("debug_round_reroll")
end

function public:OnSelectBuildingButtonPressed(iEventSourceIndex, tData)
	self.m_sBuilding[tData.PlayerID] = tData.str
end

function public:OnAddBuildingButtonPressed(iEventSourceIndex, tData)
	SendToConsole(string.format("debug_add_building %d %s", tData.PlayerID, self.m_sBuilding[tData.PlayerID]))
end

function public:OnRemoveHandBuildingsButtonPressed(iEventSourceIndex, tData)
	SendToConsole(string.format("debug_remove_hand_buildings %d", tData.PlayerID))
end

function public:OnRemoveSelectedBuildingButtonPressed(iEventSourceIndex, tData)
	SendToConsole(string.format("debug_remove_building %d %d", tData.PlayerID, tData.Unit:entindex()))
end

function public:OnBuildingLevelUpButtonPressed(iEventSourceIndex, tData)
	if IsValid(tData.Unit) then
		SendToConsole(string.format("debug_building_level_up %d", tData.Unit:entindex()))
	end
end

function public:OnBuildingMaxLevelButtonPressed(iEventSourceIndex, tData)
	if IsValid(tData.Unit) then
		SendToConsole(string.format("debug_building_max_level %d", tData.Unit:entindex()))
	end
end

function public:OnFreeBuildingOrderButtonPressed(iEventSourceIndex)
	if self.m_bFreeBuildingOrderEnabled == false then
		self.m_bFreeBuildingOrderEnabled = true
	elseif self.m_bFreeBuildingOrderEnabled == true then
		self.m_bFreeBuildingOrderEnabled = false
	end
	self:UpdateSettings()
end

function public:OnBuildingAddStarButtonPressed(iEventSourceIndex, tData)
	if IsValid(tData.Unit) then
		SendToConsole(string.format("debug_building_add_star %d", tData.Unit:entindex()))
	end
end

function public:OnSetBaseHealthButtonPressed(iEventSourceIndex, tData)
	if tonumber(tData.str) ~= nil then
		SendToConsole(string.format("debug_set_base_health %d %d", tData.PlayerID, tData.str))
	end
end

function public:OnDrawAbilityUpgradesButtonPressed(iEventSourceIndex, tData)
	if IsValid(tData.Unit) then
		PlayerData:AddAbilityUpgrade(tData.Unit, tData.str)
		-- SendToConsole(string.format("debug_draw_ability_upgrades %d %s", tData.Unit:entindex(), tData.str))
	end
end

function public:OnGameTimeFrozenButtonPressed(iEventSourceIndex, tData)
	if self.m_bGameTimeFrozen == false then
		self.m_bGameTimeFrozen = true
		GameRules:SetGameTimeFrozen(true)
	elseif self.m_bGameTimeFrozen == true then
		self.m_bGameTimeFrozen = false
		GameRules:SetGameTimeFrozen(false)
	end
	self:UpdateSettings()
end

function public:OnPlayerChangeTeamButtonPressed(iEventSourceIndex, tData)
	local iPlayerID = tData.PlayerID
	local iOldTeamNumber = PlayerResource:GetTeam(iPlayerID)
	local iNewTeamNumber = tonumber(tData.str)
	if iOldTeamNumber ~= iNewTeamNumber then
		PlayerResource:ChangePlayerTeam(iPlayerID, iNewTeamNumber)
	end
end

---重置关卡
function public:OnResetGameLevelPressed(iEventSourceIndex, tData)
	local iPlayerID = tData.PlayerID
	Chapter:End()
	Chapter:SetChapterLevel(1)
	Chapter:Prepare()
end

---移动镜头
function public:OnClickMap(iEventSourceIndex, tData)
	local iPlayerID = tData.PlayerID
	local vOrigin = string.split(tData.str, ",")
	local hChapter = Chapter:GetChapter()
	if hChapter then
		for _, hRoom in ipairs(hChapter:GetRoomList()) do
			if hRoom:GetIndex() == Vector(vOrigin[1], vOrigin[2], 0) then
				local hDummy = CreateModifierThinker(GameRules:GetGameModeEntity(), nil, "modifier_dummy", { duration = 1 }, hRoom:GetOrigin(), DOTA_TEAM_NOTEAM, false)
				FindClearSpaceForUnit(hDummy, hRoom:GetOrigin(), true)
				CenterCameraOnUnit(tData.Unit:GetPlayerID(), hDummy)
				-- 传送
				local hCurrentRoom = Chapter:GetRoomByUnit(tData.Unit)
				if hCurrentRoom == nil or (hCurrentRoom:GetRoomState() == ROOM_STATE_USED and hRoom:GetRoomState() == ROOM_STATE_USED) then
					tData.Unit:Teleport(hRoom:GetOrigin())
				end
			end
		end
	end
end

---切换迷雾
function public:OnToggleFogButtonPressed(iEventSourceIndex, tData)
	local GameMode = GameRules:GetGameModeEntity()
	if self.m_bHasFog == false then
		GameMode:SetFogOfWarDisabled(false)
		GameMode:SetUnseenFogOfWarEnabled(true)
		self.m_bHasFog = true
	elseif self.m_bHasFog == true then
		GameMode:SetFogOfWarDisabled(true)
		GameMode:SetUnseenFogOfWarEnabled(false)
		self.m_bHasFog = false
	end
	self:UpdateSettings()
end

---锁定镜头
function public:OnToggleCameraButtonPressed(iEventSourceIndex, tData)
	local iPlayerID = tData.PlayerID
	if IsValid(tData.Unit) then
		if self.m_bLockCamera == true then
			self.m_bLockCamera = false
			-- PlayerResource:SetCameraTarget(iPlayerID, nil)
		else
			self.m_bLockCamera = true
			-- PlayerResource:SetCameraTarget(iPlayerID, tData.Unit)
		end
	end
	self:UpdateSettings()
end

---解锁鼠标
function public:OnToggleMouseButtonPressed(iEventSourceIndex, tData)
	local iPlayerID = tData.PlayerID
	if IsValid(tData.Unit) then
		if self.m_bUnockMouse == true then
			self.m_bUnockMouse = false
		else
			self.m_bUnockMouse = true
		end
	end
	self:UpdateSettings()
end

---调整游戏速度
function public:OnChangeHostTimescale(iEventSourceIndex, tData)
	SendToConsole("host_timescale " .. tData.str)
end

---更换套装
function public:OnAddWearable(iEventSourceIndex, tData)
	local tWearableData = AssetModifier:GetWearableInfo(tData.str)
	if tWearableData and tWearableData.bundle ~= "base" then
		PlayerData:AddWearable(tData.Unit, PlayerData:Debug_CreateWearable(tData.Unit, tWearableData))
	else
		error("不允许添加基础饰品")
	end
end
---移除所有饰品
function public:OnRemoveAllWearable(iEventSourceIndex, tData)
	local tPlayerWearableList = PlayerData:GetPlayerWearableList(tData.Unit)
	-- 先穿上基础套装
	for i, v in ipairs(tPlayerWearableList) do
		local tWearableData = AssetModifier:GetWearableInfo(v.sWearableIndex)
		if tWearableData.bundle == "base" then
			PlayerData:EquipWearable(tData.Unit, v.sPlayerWearableIndex)
		end
	end
	-- 再移除其他装备
	for i = #tPlayerWearableList, 1, -1 do
		local tWearableData = AssetModifier:GetWearableInfo(tPlayerWearableList[i].sWearableIndex)
		if tWearableData.bundle ~= "base" then
			table.remove(tPlayerWearableList, i)
		end
	end
	PlayerData:UpdateNetTables(tData.PlayerID)
end
---添加被动技能
function public:OnAddPassiveAbility(iEventSourceIndex, tData)
	local hAbility = tData.Unit:AddAbility(tData.str)
	hAbility:SetLevel(1)
	if self.m_tAbilitiesList[tData.Unit:entindex()] == nil then
		self.m_tAbilitiesList[tData.Unit:entindex()] = {}
	end
	table.insert(self.m_tAbilitiesList[tData.Unit:entindex()], hAbility)
end
---移除所有被动技能
function public:OnRemoveAllPassiveAbility(iEventSourceIndex, tData)
	if self.m_tAbilitiesList[tData.Unit:entindex()] then
		for i, v in ipairs(self.m_tAbilitiesList[tData.Unit:entindex()]) do
			tData.Unit:RemoveAbilityByHandle(v)
		end
		self.m_tAbilitiesList[tData.Unit:entindex()] = nil
	end
end
---添加信仰技能
function public:OnAddFaithAbility(iEventSourceIndex, tData)
	Faith:Debug_AddFaithAbility(tData.Unit, tData.str)
end
---移除所有信仰技能
function public:OnRemoveAllFaithAbility(iEventSourceIndex, tData)
	Faith:Debug_RemoveAllFaithAbility(tData.Unit)
end
---更换英雄
function public:OnSwitchHero(iEventSourceIndex, tData)
	local iEntIndex = tData.Unit:entindex()
	-- 取消注册键盘控制
	KeyboardControl:UnregisterKeyboardControl(tData.Unit)
	for sItemSlot, v in pairs(AssetModifier.tWearableEntities[iEntIndex]) do
		AssetModifier:_RemoveWearable(tData.Unit, sItemSlot)
	end
	AssetModifier.tWearableNetTable[iEntIndex] = {}
	AssetModifier.tWearableEntities[iEntIndex] = {}
	AssetModifier.tWearableAmbients[iEntIndex] = {}
	AssetModifier.tWearableParticles[iEntIndex] = {}
	PlayerData:_InitPlayerData(tData.PlayerID)
	if tData.Unit.GetPet then
		UTIL_Remove(tData.Unit:GetPet())
	end
	local hHero = PlayerResource:ReplaceHeroWith(tData.PlayerID, tData.str, 0, 0)
	KeyboardControl:RegisterKeyboardControl(hHero)
	CustomNetTables:SetTableValue("wearable_data", tostring(iEntIndex), AssetModifier.tWearableNetTable[iEntIndex])
	UTIL_Remove(tData.Unit)
end
---创建友军
function public:OnAllyHero(iEventSourceIndex, tData)
	CreateUnitByNameAsync(
	tData.str,
	tData.Unit:GetAbsOrigin(),
	true,
	tData.Unit,
	tData.Unit,
	tData.Unit:GetTeamNumber(),
	function(hUnit)
		table.insert(self.m_tAlliesList, hUnit:entindex())
		hUnit:SetControllableByPlayer(tData.PlayerID, false)
		hUnit:SetRespawnPosition(tData.Unit:GetAbsOrigin())
		FindClearSpaceForUnit(hUnit, tData.Unit:GetAbsOrigin(), false)
		hUnit:Hold()
		hUnit:SetIdleAcquire(false)
		hUnit:SetAcquisitionRange(0)
	end
	)
end
---添加技能词条
function public:OnAddAbilityUpgrade(iEventSourceIndex, tData)
	if IsValid(tData.Unit) then
		AbilityUpgrades:AddAbilityUpgrades(tData.Unit, tData.str)
	end
end
---移除所有技能词条
function public:OnRemoveAllAbilityUpgrad(iEventSourceIndex, tData)
	for sID, iCount in pairs(tData.Unit.tAbilityUpgradesCount) do
		for i = 1, iCount do
			AbilityUpgrades:RemoveAbilityUpgrades(tData.Unit, sID)
		end
	end
end
---添加物品
function public:OnAddItem(iEventSourceIndex, tData)
	local hUnit = tData.Unit
	if IsValid(hUnit) then
		CreateItemToUnit(hUnit, tData.str)
		-- SendToConsole(string.format("debug_add_item %d %s", hUnit:entindex(), self.m_sItem[tData.PlayerID]))
	end
end
---打印单位身上的modifier
function public:OnPrintModifiers(iEventSourceIndex, tData)
	local hUnit = tData.Unit
	if IsValid(hUnit) then
		for i, v in ipairs(hUnit:FindAllModifiers()) do
			Notifications:LeftBottom(tData.PlayerID, { text = v:GetName(), style = { color = "white" }, duration = 10, class = "LeftMessage", continue = false })
		end
	end
end
---创建一个敌人
function public:OnCreateEnemy(iEventSourceIndex, tData)
	local tUnitData = {
		MapUnitName = tData.str,
		teamnumber = DOTA_TEAM_BADGUYS,
		NeverMoveToClearSpace = false,
		IsSummoned = "1",
	}
	local hUnit = CreateUnitFromTable(tUnitData, tData.Position)
	table.insert(self.m_tAlliesList, hUnit)
	if self.m_bEnemyControlable then
		hUnit:SetControllableByPlayer(tData.PlayerID, true)
	end
	hUnit:AddNewModifier(self, nil, "modifier_kill", { duration = 30 })
	-- hUnit:AddNewModifier(self, nil, "modifier_spawn_example", { duration = 1 })
end
---开关控制敌人
function public:OnToggleEnemyControlable(iEventSourceIndex, tData)
	if self.m_bEnemyControlable == false then
		self.m_bEnemyControlable = true
	elseif self.m_bEnemyControlable == true then
		self.m_bEnemyControlable = false
	end
	self:UpdateSettings()
end
---开关弹道画线
function public:OnToggleProjectileDebugMode(iEventSourceIndex, tData)
	if self.m_bProjectileDebugMode == false then
		self.m_bProjectileDebugMode = true
	elseif self.m_bProjectileDebugMode == true then
		self.m_bProjectileDebugMode = false
	end
	print("bigciba", PROJECTILE_DEBUG_MODE, self.m_bProjectileDebugMode)
	PROJECTILE_DEBUG_MODE = self.m_bProjectileDebugMode
	self:UpdateSettings()
end
---画圈
function public:OnDrawCircle(iEventSourceIndex, tData)
	if tData.Unit._iDebugCircleParticle then
		if tonumber(tData.str) <= 0 then
			ParticleManager:DestroyParticle(tData.Unit._iDebugCircleParticle, false)
			tData.Unit._iDebugCircleParticle = ni
		else
			ParticleManager:SetParticleControl(tData.Unit._iDebugCircleParticle, 3, Vector(tData.str, 0, 0))
		end
	else
		tData.Unit._iDebugCircleParticle = ParticleManager:CreateParticle("particles/ui_mouseactions/range_finder_targeted_aoe.vpcf", PATTACH_ABSORIGIN_FOLLOW, tData.Unit)
		ParticleManager:SetParticleControlEnt(tData.Unit._iDebugCircleParticle, 2, tData.Unit, PATTACH_ABSORIGIN_FOLLOW, "", tData.Unit:GetAbsOrigin(), false)
		ParticleManager:SetParticleControl(tData.Unit._iDebugCircleParticle, 3, Vector(tData.str, 0, 0))
	end
end
---完成所有地图
function public:OnUnlockMap(iEventSourceIndex, tData)
	local tRoomList = Chapter:GetChapter():GetRoomList()
	for i, hRoom in ipairs(tRoomList) do
		hRoom:Prepare()
		hRoom:End()
	end
	Chapter:GetChapter():UpdateNetTable()
end
---复活
function public:OnRespawnHero(iEventSourceIndex, tData)
	tData.Unit:RespawnHero(false, false)
	tData.Unit:SetAbsOrigin(tData.Position)
end
---重生次数
function public:OnRebornButtonPressed(iEventSourceIndex, tData)
	if tData.Unit then
		tData.Unit:RemoveModifierByName("modifier_reborn")
		local iRebornCount = tonumber(tData.str)
		if iRebornCount > 0 then
			tData.Unit:AddNewModifier(tData.Unit, nil, "modifier_reborn", nil):SetStackCount(math.min(4, iRebornCount))
		end
	end
end
---刷怪
function public:OnToggleSpawnerButtonPressed(iEventSourceIndex, tData)
	Spawner:TogglePauseSpawn()
	self.m_bHasFog = Spawner.bPause
end
---刷怪
function public:OnChangeRound(iEventSourceIndex, tData)
	Spawner.gameRound = tData.str - 1
end

------------------------------------------------------------------------------------
function public:OnItemPurchased(event)
	local hBuyer = PlayerResource:GetPlayer(event.PlayerID)
	local hBuyerHero = hBuyer:GetAssignedHero()
	if hBuyerHero ~= nil then
		hBuyerHero:ModifyGold(event.itemcost, true, 0)
	end
end

function public:IsFreeSpellsEnabled()
	return self.m_bFreeSpellsEnabled
end

function public:IsCreepsEnabled()
	return self.m_bCreepsEnabled
end

function public:IsFreeBuildingOrderEnabled()
	return self.m_bFreeBuildingOrderEnabled
end

function public:IsBaseInvulnerabilityEnabled()
	return self.m_bBaseInvulnerabilityEnabled
end

function public:UpdateSettings()
	local settings = {
		has_fog = self.m_bHasFog and 1 or 0,
		lock_camera = self.m_bLockCamera and 1 or 0,
		unlock_mouse = self.m_bUnockMouse and 1 or 0,
		free_spells = self.m_bFreeSpellsEnabled and 1 or 0,
		creeps = self.m_bCreepsEnabled and 1 or 0,
		free_building_order = self.m_bFreeBuildingOrderEnabled and 1 or 0,
		base_invulnerability = self.m_bBaseInvulnerabilityEnabled and 1 or 0,
		game_time_frozen = self.m_bGameTimeFrozen and 1 or 0,
		enemy_controlable = self.m_bEnemyControlable and 1 or 0,
		projectile_debug_mode = self.m_bProjectileDebugMode and 1 or 0,
	}
	CustomNetTables:SetTableValue("common", "demo_settings", settings)
	CustomNetTables:SetTableValue("common", "demo_round_info", self.m_tRoundInfo)
end

function public:init(bReload)
	if not GameRules:IsCheatMode() then
		return
	end

	if not bReload then
		SendToServerConsole("sv_cheats 1")
		SendToServerConsole("dota_ability_debug 0")

		self.m_sHero = {}
		self.m_sAbility = {}
		self.m_sItem = {}
		self.m_iRoundNumber = {}
		self.m_sBuilding = {}
		for iPlayerID = 0, DOTA_MAX_TEAM_PLAYERS - 1, 1 do
			self.m_sHero[iPlayerID] = "npc_dota_hero_axe"
			self.m_sAbility[iPlayerID] = "juggernaut_blade_fury"
			self.m_sItem[iPlayerID] = "item_boots_custom"
			self.m_iRoundNumber[iPlayerID] = 1
			self.m_sBuilding[iPlayerID] = "td_zuus"
		end

		self.m_tRoundInfo = {}

		self.m_tAlliesList = {}

		self.m_tEnemiesList = {}

		self.m_tAbilitiesList = {}

		self.m_bFreeSpellsEnabled = false
		self.m_bInvulnerabilityEnabled = false
		self.m_bHasFog = false
		self.m_bLockCamera = true
		self.m_bUnockMouse = false
		self.m_bCreepsEnabled = true
		self.m_bFreeBuildingOrderEnabled = false
		self.m_bBaseInvulnerabilityEnabled = false
		self.m_bGameTimeFrozen = false
		self.m_bEnemyControlable = false
		self.m_bProjectileDebugMode = false
	end

	-- GameEvent("dota_item_purchased", Dynamic_Wrap(public, "OnItemPurchased"), public)
	CustomUIEvent("DemoEvent", function(public, iEventSourceIndex, tData)
		local sEventName = tData.event_name
		local iPlayerID = tData.player_id or -1
		local hUnit = EntIndexToHScript(tData.unit or -1)
		local vPosition = tData.position and Vector(tData.position["0"], tData.position["1"], tData.position["2"]) or vec3_invalid
		local sStr = tData.str
		if type(sEventName) == "string" and type(public["On" .. sEventName]) == "function" then
			public["On" .. sEventName](public, iEventSourceIndex, {
				PlayerID = iPlayerID,
				Unit = hUnit,
				Position = vPosition,
				str = sStr,
			})
		end
	end, public)

	self:UpdateSettings()
end

return public