if Quest == nil then
  	Quest = {}
  	Quest.__index = Quest
end
-- 初始化
--
function Quest:Init()
	ListenToGameEvent('entity_killed', Dynamic_Wrap(Quest, 'OnUnitKilled'), self)
	self.questInfo = LoadKeyValues("scripts/kv/quest_info.kv")
end
-- 触发任务
-- npc,物品,区域,时间,随机
function QuestTriggerNpc( t )
	local npc = t.caster
	local caster = t.target
	for questName,questInfo in pairs(Quest.questInfo) do
		-- 判断npc名字得到任务
		if questInfo.triggerName == npc:GetUnitName() then
			-- 是否已接受或完成任务
			if caster[questName] == nil then
				-- 判断前置条件
				if Quest:FrontRequireCheck(questName, questInfo, caster) then
					Quest:AddQuest(caster, questName, questInfo)
				end
			else
				local currentQuest = caster[questName]
				if currentQuest.reamainCount < currentQuest.demandCount then
					self:ShowQuestDialog(false)
				else
					self:Finish()
					self:ShowQuestDialog(true)
				end
			end
		end
	end
end
-- 前置条件检测
-- 等级,任务,其他
function Quest:FrontRequireCheck(questName, questInfo, caster)
	if questInfo.frontRequireType == "nil" then
		return true
	elseif questInfo.frontRequireType == "quest" then
		-- 是否满足前置条件
		if caster[questInfo.frontRequire] then
			return true
		end
	elseif questInfo.frontRequireType == "level" then
		if caster:GetLevel() >= questInfo.frontRequire then
			return true
		end
	end
	return false
end
-- 接受任务
-- 将任务信息绑定在单位身上，并标记为未完成
function Quest:AddQuest(caster, questName, questInfo)
	questInfo["reamainCount"] = 0
	questInfo["demandCount"] = questInfo.demandCount
	questInfo["completed"] = false
	caster[questName] = questInfo
end
-- 任务完成过程检测
-- 击杀，收集
function Quest:OnUnitKilled(t)
    local victim = EntIndexToHScript(t.entindex_killed)
	local killer = EntIndexToHScript(t.entindex_attacker)
    if killer:isIllusion() then
        if killer.caster_hero then
            killer = killer.caster_hero
        end
    end
	if victim then
		for questName,questInfo in pairs(self.questInfo) do
			-- 判断是否是任务需求单位
			if questInfo.triggerName == victim:GetUnitName() then
				-- 判断已接受任务且未完成
				if killer[questName] then)
					if killer[questName].completed == false then
						self:DeCount(killer, questName)
					end
				end
			end
		end
	end
end
function Quest:Finish()
	self["Count"] = -1
	--这里写给玩家啥东西啥东西的
end

function Quest:DeCount(killer, questName)
	killer[questName].reamainCount = killer[questName].reamainCount + 1
	if killer[questName].reamainCount >= killer[questName].demandCount then
		killer[questName].reamainCount = killer[questName].demandCount
	end
end

function Quest:delete()
	for k,v in pairs(self) do
		self[k] = nil;
	end
end

function QuestEasy( trigger )
	local caster = trigger.activator;
	local playerID = caster:GetPlayerID()
	local npc = Entities:FindByName( nil, "quest_easy" )
	local quest1 = {
		["Type"] = "Kill",
		["Name"] = "杀死恶魔",
		["Monster"] = "Devil",
		["Count"] = 1,
		["RewardItem"] = nil,
		["RewardMoney"] = 1000,
		["RewardScore"] = 0
	}
	QuestManager:addQuest(playerID,quest1)
end