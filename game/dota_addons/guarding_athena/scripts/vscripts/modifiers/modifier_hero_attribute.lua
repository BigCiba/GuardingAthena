if modifier_hero_attribute == nil then
	modifier_hero_attribute = class({}, nil, ModifierHidden)
end

local public = modifier_hero_attribute

function public:AllowIllusionDuplicate()
	return true
end
function public:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
function public:OnCreated(params)
	local hParent = self:GetParent()
	-- 自定义属性
	self.BonusStrengthGain = 0			-- 力量成长
	self.BonusAgilityGain = 0			-- 敏捷成长
	self.BonusIntellectGain = 0			-- 智力成长
	self.ExperienceGainPercent = 0		-- 经验获取率
	self.GoldGainPercent = 0			-- 金钱获取率
	-- 增加额外属性
	hParent.AddBonusStrengthGain = function(hParent, iCount) self.BonusStrengthGain = self.BonusStrengthGain + iCount end
	hParent.AddBonusAgilityGain = function(hParent, iCount) self.BonusAgilityGain = self.BonusAgilityGain + iCount end
	hParent.AddBonusIntellectGain = function(hParent, iCount) self.BonusIntellectGain = self.BonusIntellectGain + iCount end
	hParent.AddExperienceGainPercent = function(hParent, iCount) self.ExperienceGainPercent = self.ExperienceGainPercent + iCount end
	hParent.AddGoldGainPercent = function(hParent, iCount) self.GoldGainPercent = self.GoldGainPercent + iCount end
	-- 设置额外属性
	hParent.SetBonusStrengthGain = function(hParent, iCount) self.BonusStrengthGain = iCount end
	hParent.SetBonusAgilityGain = function(hParent, iCount) self.BonusAgilityGain = iCount end
	hParent.SetBonusIntellectGain = function(hParent, iCount) self.BonusIntellectGain = iCount end
	hParent.SetExperienceGainPercent = function(hParent, iCount) self.ExperienceGainPercent = iCount end
	hParent.SetGoldGainPercent = function(hParent, iCount) self.GoldGainPercent = iCount end
	-- 获取额外属性
	hParent.GetBonusStrengthGain = function(hParent) return self.BonusStrengthGain end
	hParent.GetBonusAgilityGain = function(hParent) return self.BonusAgilityGain end
	hParent.GetBonusIntellectGain = function(hParent) return self.BonusIntellectGain end
	hParent.GetExperienceGainPercent = function(hParent) return self.ExperienceGainPercent end
	hParent.GetGoldGainPercent = function(hParent) return self.GoldGainPercent end

	if IsServer() then
	end
end
function public:OnDestroy()
	local hParent = self:GetParent()
	-- 增加额外属性
	hParent.AddBonusStrengthGain = nil
	hParent.AddBonusAgilityGain = nil
	hParent.AddBonusIntellectGain = nil
	hParent.AddExperienceGainPercent = nil
	hParent.AddGoldGainPercent = nil
	-- 设置额外属性
	hParent.SetBonusStrengthGain = nil
	hParent.SetBonusAgilityGain = nil
	hParent.SetBonusIntellectGain = nil
	hParent.SetExperienceGainPercent = nil
	hParent.SetGoldGainPercent = nil
	-- 获取额外属性
	hParent.GetBonusStrengthGain = nil
	hParent.GetBonusAgilityGain = nil
	hParent.GetBonusIntellectGain = nil
	hParent.GetExperienceGainPercent = nil
	hParent.GetGoldGainPercent = nil
end