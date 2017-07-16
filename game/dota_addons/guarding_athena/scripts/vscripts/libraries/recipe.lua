if Recipe == nil then
	Recipe = class({})
end
-- @product 最终成品名
-- @requirements 所需要的物品和物品数量的表{物品名称=数量}
function Recipe:constructor(product, requirements)
	local vRecipe = {product = product, requirements = requirements}
	self.vRecipeItems = self.vRecipeItems or {}
	if not requirements or type(requirements) ~= "table" or TableCount(requirements) <= 0 then
		return
	end
	for item_name, item_count in pairs(requirements) do
		item_count = tonumber(item_count) or 1
		self.vRecipeItems[itemname] = self.vRecipeItems[itemname] or {}
		self.vRecipeItems[itemname][vRecipe] = true
	end
end
--拾取物品/执行指令的回调函数
function Recipe:TryCombine( keys )
	local item = keys.item
	local itemname = item.GetAbilityName()
	local hero = keys.hero
	--局部函数1：判断所有材料是否齐全
	local function all_item_match( hero, _recipe )

	end
	--局部函数2：移除所有的材料，如果是要多个材料的，使用item:SetCurrentCharges(item:GetCurrentCharges() - require_count)
	local function remove_all_requirements( hero, _recipe )
		
	end
	--判断这个物品有没有可以合成的东西
	if self.vRecipeItems[itemname] then
		for recipe, _ in pairs(self.vRecipeItems[itemname]) do
			if all_item_match(hero,recipe) then
				remove_all_requirements(hero,recipe)
				hero:AddItem(CreateItem(recipe.product, hero, hero))
			end
		end
	end
end
function Recipe:Start()
end
GameRules.Recipe = Recipe()
local make_recipe = GameRules.Recipe
-- 写下所有需要用到的卷轴
make_recipe("item_clarity4", {item_clarity1 = 1, item_clarity2 = 2, item_clarity3 = 3})
GameRules.Recipe:Start()