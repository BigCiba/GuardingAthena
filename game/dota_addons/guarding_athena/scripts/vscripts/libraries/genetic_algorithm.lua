-- 模仿基因遗传的方式自动调节数据，使得数据变化平滑
if GeneticAlgorithm == nil then
    GeneticAlgorithm = class({})
end
function GeneticAlgorithm:Init()
    self.ethnicValueTable = {}
    self.heredityTable = {}
    self.learningRate = 0
    self:Setting()
    self:ReadEthnicValue()
    ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(GeneticAlgorithm, 'OnGameRulesStateChange'), self)
end
function GeneticAlgorithm:Setting()
    self.baseLearningRate = GameRules:GetDifficulty() * 0.1 - 0.1
    self.timeLearningRate = 0
end
function GeneticAlgorithm:UpdataLearningRate( t )
    -- body
end
-- 种族值
function GeneticAlgorithm:ReadEthnicValue()
    local kvTable = LoadKeyValues("scripts/npc/npc_units_custom.txt")
    for k,v in pairs(kvTable) do
        if type(v) ~= "number" and string.find(k,"guai_") then
			self.ethnicValueTable[k] = {}
            self.ethnicValueTable[k].StatusHealth = v.StatusHealth
            self.ethnicValueTable[k].ArmorPhysical = v.ArmorPhysical
            self.ethnicValueTable[k].MagicalResistance = v.MagicalResistance
            self.ethnicValueTable[k].AttackDamageMax = v.AttackDamageMax
		end
    end
end
-- 遗传
function GeneticAlgorithm:Heredity()

end
-- 突变
function GeneticAlgorithm:Mutation()

end
-- 学习率
function GeneticAlgorithm:LearningRate()

end
-- 适应函数
function GeneticAlgorithm:Algorithm()

end
function GeneticAlgorithm:OnGameRulesStateChange( t )
    local gameState = GameRules:State_Get()
    if gameState == DOTA_GAMERULES_STATE_PRE_GAME then
        Timers:CreateTimer(20,function ()
            if GameRules:GetDifficulty() > 0 then
                self:Setting()
            else
                return 0.1
            end
        end)
    end
end
GameRules.GeneticAlgorithm = GeneticAlgorithm()
GameRules.GeneticAlgorithm:Init()