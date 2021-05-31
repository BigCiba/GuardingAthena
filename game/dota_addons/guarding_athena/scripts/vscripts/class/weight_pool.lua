--[[权重池
类功能使用的是Valve提供的class库
用于处理各种权重随机计算

权重池仅提供2个相关参数：
string:sName
integer:iWeight

constructor的参数tList是以sName为key，iWeight为value的表

例子：local pool = WeightPool({""})
]]
--
if CWeightPool == nil then
	CWeightPool = class({})
end
local public = CWeightPool

function public:constructor(tList)
	self.tList = tList or {}

	self:update()
end

function public:update()
	self.tName = {}
	self.tSection = {}
	local iTotal = 0
	for sName, iWeight in pairs(self.tList) do
		iTotal = iTotal + iWeight
		table.insert(self.tSection, iTotal)

		table.insert(self.tName, sName)
	end
end

function public:Has(sName)
	for name, _ in pairs(self.tList) do
		if name == sName then
			return true
		end
	end
	return false
end

function public:Set(sName, iWeight)
	self.tList[sName] = iWeight > 0 and iWeight or nil

	self:update()
end

function public:Add(sName, iWeight)
	self:Set(sName, (self.tList[sName] or 0) + iWeight)
end

function public:Remove(sName)
	self:Set(sName, 0)
end

function public:Random()
	local iRandom = RandomInt(1, self.tSection[#self.tSection] or 1)
	for i, max in ipairs(self.tSection) do
		if iRandom <= max then
			return self.tName[i]
		end
	end
end

return public