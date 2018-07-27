-- 任务对话状态常数
local ACCEPT = 0
local INPROGRESS = 1
local FINISH = 2
local NOQUEST =3
local FAIL = 4
if Quest == nil then
  	Quest = {}
  	Quest.__index = Quest
end
-- 初始化
function Quest:Init()
	ListenToGameEvent('entity_killed', Dynamic_Wrap(Quest, 'OnUnitKilled'), self)
	self.questInfo = LoadKeyValues("scripts/kv/quest_info.kv")
end
-- 触发任务
-- npc,物品,区域,时间,随机
function QuestTriggerNpc( t )
	local npc = t.caster
	local caster = t.target
	local questCount = 0
	local questFinish = 0
	for questName,questInfo in pairs(Quest.questInfo) do
		-- 判断npc名字得到任务
		if questInfo.triggerName == npc:GetUnitName() then
			questCount = questCount + 1
			if questInfo.dialog then
				CustomUI:DynamicHud_Create(caster:GetPlayerID(),"Dialog","file://{resources}/layout/custom_game/custom_hud/dialog.xml",nil)					
			end
			-- 是否已接受或完成任务
			if caster[questName] == nil then
				-- 判断前置条件
				local checkResult,showDialog = Quest:FrontRequireCheck(caster, questName, questInfo)
				if checkResult then
					Quest:AddQuest(caster, npc, questName, questInfo)
					Quest:ShowDialog(caster, npc, questName, ACCEPT)
					break
				elseif showDialog then
					Quest:ShowDialog(caster, npc, questName, FAIL)
				end
			else
				local currentQuest = caster[questName]
				if caster[questName].completed == false then
					Quest:ShowDialog(caster, npc, questName, INPROGRESS)
					break
				elseif caster[questName].getReward == false then
					Quest:Finish(caster, questName)
					Quest:ShowDialog(caster, npc, questName, FINISH)
					break
				elseif caster[questName].getReward == true then
					questFinish = questFinish + 1
				end
			end
		end
	end
	if questCount == questFinish then
		Quest:ShowDialog(caster, npc, "", NOQUEST)
	end
end
function OnDestroy( t )
	local caster = t.target
	CustomUI:DynamicHud_Destroy(caster:GetPlayerID(), "Dialog")
end
-- 前置条件检测
-- 等级,任务,其他
function Quest:FrontRequireCheck(caster, questName, questInfo)
	local checkResult,showDialog
	if questInfo.frontRequireType == "" then
		return true
	elseif questInfo.frontRequireType == "quest" then
		-- 是否已经完成前置任务并获得奖励
		if caster[questInfo.frontRequire] then
			if caster[questInfo.frontRequire].getReward then
				return true
			end
		end
	elseif questInfo.frontRequireType == "level" then
		if caster:GetLevel() >= questInfo.frontRequire then
			return true
		else
			return false,true
		end
	end
	return false
end
-- 接受任务
-- 将任务信息绑定在单位身上，并标记为未完成
function Quest:AddQuest(caster, npc, questName, questInfo)
	local casterQuestInfo = DeepCopy(questInfo)
	casterQuestInfo["reamainCount"] = 0
	casterQuestInfo["getReward"] = false
	casterQuestInfo["completed"] = false
	casterQuestInfo["npc"] = npc
	caster[questName] = casterQuestInfo
	self:CreateUI(caster,questName)
end
-- 任务完成过程检测
-- 击杀，收集
function Quest:OnUnitKilled(t)
    local victim = EntIndexToHScript(t.entindex_killed)
	local killer = EntIndexToHScript(t.entindex_attacker)
    if killer:IsIllusion() then
        if killer.caster_hero then
            killer = killer.caster_hero
        end
    end
	if victim then
		for questName,questInfo in pairs(self.questInfo) do
			-- 判断是否是任务需求单位
			if type(questInfo.targetName) == "table" then
				for _,v in pairs(questInfo.targetName) do
					if v == victim:GetUnitName() then
						-- 判断已接受任务且未完成
						if killer[questName] then
							if killer[questName].completed == false then
								self:DeCount(killer, questName)
							end
						end
					end
				end
			else
				if questInfo.targetName == victim:GetUnitName() then
					-- 判断已接受任务且未完成
					if killer[questName] then
						if killer[questName].completed == false then
							self:DeCount(killer, questName)
						end
					end
				end
			end
		end
	end
end
function Quest:Finish(caster, questName)
	if caster[questName].rewardType == "item" then
		local newItem = CreateItem(caster[questName].rewardContent, caster, caster)
		caster:AddItem(newItem)
		self:DestoryUI(caster, questName)
		caster[questName].getReward = true
	end
end

function Quest:DeCount(killer, questName)
	killer[questName].reamainCount = killer[questName].reamainCount + 1
	if killer[questName].reamainCount >= killer[questName].demandCount then
		killer[questName].reamainCount = killer[questName].demandCount
		killer[questName].completed = true
	end
	self:UpdataUI(killer, questName)
end
function Quest:ShowDialog( caster, npc, questName, showType )
	local player = caster:GetPlayerOwner()
	local showerIndex = npc:GetEntityIndex()
	local showContent = questName
	if showType == ACCEPT then
		showContent = questName.."Accept"
	elseif showType == INPROGRESS then
		showContent = questName.."Inprogress"
	elseif showType == FINISH then
		showContent = questName.."Finish"
	elseif showType == NOQUEST then
		showContent = questName.."Noquest"
	elseif showType == FAIL then
		showContent = questName.."Fail"
	end
	CustomGameEventManager:Send_ServerToPlayer(player,"avalon_display_bubble", {unit=showerIndex,text=showContent,duration=5})
end
function Quest:CreateUI( caster, questName )
	local player = caster:GetPlayerOwner()
	local demandCount = caster[questName].demandCount
	local rewardContent = caster[questName].rewardContent
	CustomGameEventManager:Send_ServerToPlayer(player,"create_quest", {quest_name=questName,demand_count=demandCount,reward_content=rewardContent})
end
function Quest:DestoryUI( caster, questName )
	local player = caster:GetPlayerOwner()
	CustomGameEventManager:Send_ServerToPlayer(player,"destory_quest", {quest_name=questName})
end
function Quest:UpdataUI( caster, questName )
	local player = caster:GetPlayerOwner()
	local reamainCount = caster[questName].reamainCount
	CustomGameEventManager:Send_ServerToPlayer(player,"updata_quest", {quest_name=questName,reamain_count=reamainCount})
end