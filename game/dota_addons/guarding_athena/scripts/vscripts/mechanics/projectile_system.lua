--[[弹道系统
	-- 基本遵循官方弹道系统的规则
	-- 填写iBounce参数使得弹道遇到障碍物时会弹射，弹射后会清空伤害单位组
	-- 没有弹射次数后会直接销毁
	-- 弹道结束时会调用技能的OnProjectileDestroy而不是OnProjectileHit
	-- 弹道反弹前会调用技能的OnProjectileBounceStart，反弹后调用OnProjectileBounceEnd
	-- 默认调用技能的OnProjectileHit，OnProjectileThink，OnProjectileDestroy
	-- 也可以使用参数OnProjectileThink, OnProjectileHit, OnProjectileDestroy, funcBounce覆盖
	-- ExtraData里现在支持填任意值

	-- Example1: 线性投射物
	local info = {
		hAbility = self,
		hCaster = hCaster,
		sEffectName = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_suriken_toss_linear.vpcf",
		vSpawnOrigin = vStart,
		vDirection = vDirection:Normalized(),
		iMoveSpeed = speed,
		flDistance = distance,
		flStartRadius = width,
		flEndRadius = width,
		iBounce = 4,
		iHitCount = 1,	-- 可选的打击次数，不填则不计算
		bIgnoreBlock = false,
		bCounter = false,	-- 默认false
		bDestroy = true,	-- 默认true
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		ExtraData = {
			bReturn = 0,
			iIndex = i,
			delay = flDelay
		}
	}
	ProjectileSystem:CreateLinearProjectile(info)

	-- Example2: 跟踪投射物
	local info = {
		hCaster = EntIndexToHScript(params.entindex_source_const),
		hTarget = hTarget,
		sEffectName = hAttacker:GetRangedProjectileName(),
		hAbility = self,
		iMoveSpeed = params.move_speed,
		vSpawnOrigin = hAttacker:GetAttachmentPosition("attach_attack1") or hAttacker:GetAbsOrigin(),
		flRadius = PROJECTILE_WIDTH,
		iBounce = 4,
		bCounter = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		OnProjectileHit = function(hTarget, vLocation, tInfo)
			hAttacker:PerformAttack(hTarget, true, false, true, true, false, false, false)
		end
	}
	ProjectileSystem:CreateTrackingProjectile(info)

	-- 已知BUG
	反弹采取重新创建特效的方式，会导致弹道特效消失一帧并且拖尾重置。
	采用单位马甲的方式附着特效，结果就是特效位置与实际位置不符。
	TODO:
	可以尝试采用js端创建特效的方式解决该问题
	弹道增加加速度参数
	弹道增加独立函数轨迹
]]
PROJECTILE_TYPE_LINEAR = 0		---线性弹道
PROJECTILE_TYPE_TRACKING = 1	---跟踪弹道
PROJECTILE_TYPE_GUIDANCE = 2	---制导弹道（有一定角速度）

PROJECTILE_WIDTH = 100						---普通攻击弹道宽度
PROJECTILE_GUIDANCE_ANGULAR_VELOCITY = 30	---普通攻击弹道角速度（可以通过传入flAngularVelocity覆盖）
PROJECTILE_COUNTER_MOVESPEED_MULTIPLE = 1.5	---弹反弹道速度倍数
PROJECTILE_GUIDANCE_MAX_LIFETIME = 10		---制导弹道最大生命周期

-- 圆心检测精度
PROJECTILE_COLLISION_DETECTION_ACCURACY_LOWEST = 8
PROJECTILE_COLLISION_DETECTION_ACCURACY_LOW = 12
PROJECTILE_COLLISION_DETECTION_ACCURACY_MEDIUM = 16
PROJECTILE_COLLISION_DETECTION_ACCURACY_HIGH = 20
PROJECTILE_COLLISION_DETECTION_ACCURACY_HIGHEST = 24

---是否打印debug用的点
PROJECTILE_DEBUG_MODE = false

if ProjectileSystem == nil then
	---@module ProjectileSystem
	ProjectileSystem = class({})
end
local public = ProjectileSystem

function public:init(bReload)
	if not bReload then
		---存所有弹道的信息
		self.tProjectile = {}
		---弹道索引
		self.iProjectileIndex = 1
		---马甲
		self.hProjectileSystemDummy = CreateModifierThinker(GameRules:GetGameModeEntity(), nil, "modifier_dummy", nil, Vector(0, 0, 0), DOTA_TEAM_NOTEAM, false)
	end
	---圆心检测半径
	self.iCircleRadius = 32
	---圆心检测精度
	self.iCircleAccuracy = PROJECTILE_COLLISION_DETECTION_ACCURACY_MEDIUM

	---弹道碰撞后检索精度
	self.iBlockTickDistance = 10
	---弹道正常检索精度
	self.iTickDistance = 32

	---弹道速度倍率（根据队伍）
	self.iProjectileMoveSpeedMultipleWithTeam = {}
	for i = DOTA_TEAM_FIRST, DOTA_TEAM_CUSTOM_MAX do
		self.iProjectileMoveSpeedMultipleWithTeam[i] = 1
	end

	if self.hTimer then
		StopTimer(self.hTimer)
		self.hTimer = nil
	end
	---计时器
	self.hTimer = GameTimer(FrameTime(), function()
		for index, tInfo in pairs(self.tProjectile) do
			if tInfo.iType == PROJECTILE_TYPE_LINEAR then
				self:_OnLinearProjectileThink(index)
			elseif tInfo.iType == PROJECTILE_TYPE_TRACKING then
				self:_OnTrackingProjectileThink(index)
			elseif tInfo.iType == PROJECTILE_TYPE_GUIDANCE then
				self:_OnGuidanceProjectileThink(index)
			end
		end
		return FrameTime()
	end)
end
--------------------------------------------------------------------------------
-- public
--------------------------------------------------------------------------------
---创建线性弹道
---@param tInfo.hAbility 技能
---@param tInfo.hCaster 来源
---@param tInfo.sEffectName 特效
---@param tInfo.vSpawnOrigin 起始点
---@param tInfo.vDirection 方向
---@param tInfo.iBounce 弹射次数 可选
---@param tInfo.bDestroyOnBounce 没有弹射次数时是否销毁 默认销毁
---@param tInfo.bCounter 是否能反弹
---@param tInfo.bDestroy 是否能销毁
---@param tInfo.iHitCount 命中次数 默认不计算
---@param tInfo.bIgnoreBlock 是否无视障碍物
---@param tInfo.iMoveSpeed 速度
---@param tInfo.flDistance 距离
---@param tInfo.flRadius 半径 会被flStartRadius和flEndRadius覆盖
---@param tInfo.flStartRadius 开始半径 可选
---@param tInfo.flEndRadius 结束半径 可选
---@param tInfo.iUnitTargetTeam 目标队伍
---@param tInfo.iUnitTargetType 目标类型
---@param tInfo.iUnitTargetFlags 目标标记
---@param tInfo.ExtraData 额外数据
---@return number 弹道索引
function public:CreateLinearProjectile(tInfo)
	tInfo.vPosition = tInfo.vSpawnOrigin					---记录当前弹道位置
	tInfo.vDirection.z = 0
	tInfo.flDistance = self:_GetDistance(tInfo)				---弹道距离
	tInfo.iMoveSpeed = self:_GetMoveSpeed(tInfo)			---弹道速度
	tInfo.vVelocity = tInfo.iMoveSpeed * tInfo.vDirection	---弹道速度
	tInfo.flLifeTime = tInfo.flDistance / tInfo.iMoveSpeed	---弹道的生命周期
	tInfo.flLifeTimeRemaining = tInfo.flLifeTime			---弹道的剩余生命
	tInfo.iBounce = self:_GetBounce(tInfo)					---弹射次数
	tInfo.bCounter = default(tInfo.bCounter, false)			---是否可以反弹
	tInfo.bDestroy = default(tInfo.bDestroy, true)			---是否可以销毁

	tInfo.bIgnoreBlock = default(tInfo.bIgnoreBlock, true)			---是否无视障碍物
	tInfo.bDestroyOnBounce = default(tInfo.bDestroyOnBounce, true)	---没有弹射次数时是否销毁
	tInfo.iUnitTargetTeam = default(tInfo.iUnitTargetTeam, DOTA_UNIT_TARGET_TEAM_NONE)
	tInfo.iUnitTargetType = default(tInfo.iUnitTargetType, DOTA_UNIT_TARGET_NONE)
	tInfo.iUnitTargetFlags = default(tInfo.iUnitTargetFlags, DOTA_UNIT_TARGET_FLAG_NONE)

	-- 弹道碰撞半径
	tInfo.flRadius = default(tInfo.flRadius, 0)
	tInfo.flStartRadius = default(tInfo.flStartRadius, tInfo.flRadius)
	tInfo.flEndRadius = default(tInfo.flEndRadius, tInfo.flRadius)
	tInfo._PriviousRadius = tInfo.flStartRadius
	tInfo._NextRadius = tInfo.flStartRadius

	tInfo.iType = PROJECTILE_TYPE_LINEAR
	tInfo.tTargets = {}	---记录击中过的单位
	-- 自己创建特效
	local iParticleID = ParticleManager:CreateParticle(tInfo.sEffectName, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControlForward(iParticleID, 0, tInfo.vVelocity:Normalized())
	ParticleManager:SetParticleControl(iParticleID, 0, tInfo.vSpawnOrigin)
	ParticleManager:SetParticleControl(iParticleID, 1, tInfo.vVelocity)
	tInfo.iParticleID = iParticleID
	self:_DebugDrawCircle(tInfo.vSpawnOrigin, Vector(0, 0, 255), 50, 15, true, 1)	--打印出起始点

	return self:_InitProjectile(tInfo)
end
---创建跟踪弹道
---@param tInfo.hAbility 技能
---@param tInfo.hCaster 来源
---@param tInfo.hTarget 目标
---@param tInfo.sEffectName 特效
---@param tInfo.vSpawnOrigin 起始点
---@param tInfo.iBounce 弹射次数 可选
---@param tInfo.bCounter 是否能反弹
---@param tInfo.iHitCount 命中次数 默认不计算
---@param tInfo.iMoveSpeed 速度
---@param tInfo.flRadius 半径
---@param tInfo.iUnitTargetTeam 目标队伍
---@param tInfo.iUnitTargetType 目标类型
---@param tInfo.iUnitTargetFlags 目标标记
---@param tInfo.ExtraData 额外数据
---@return number 弹道索引
function public:CreateTrackingProjectile(tInfo)
	tInfo.vPosition = tInfo.vSpawnOrigin	---记录当前弹道位置
	tInfo.vDirection = (tInfo.hTarget:GetAbsOrigin() - tInfo.vSpawnOrigin):Normalized()
	tInfo.vDirection.z = 0
	tInfo.iMoveSpeed = self:_GetMoveSpeed(tInfo)
	tInfo.vVelocity = tInfo.iMoveSpeed * tInfo.vDirection	---弹道速度
	tInfo.iBounce = self:_GetBounce(tInfo)					---弹射次数
	tInfo.bCounter = default(tInfo.bCounter, false)			---是否可以反弹
	tInfo.bDestroy = default(tInfo.bDestroy, true)			---是否可以销毁
	tInfo.bIgnoreBlock = default(tInfo.bIgnoreBlock, true)			---是否无视障碍物
	tInfo.bDestroyOnBounce = default(tInfo.bDestroyOnBounce, true)	---没有弹射次数时是否销毁
	tInfo.iUnitTargetTeam = default(tInfo.iUnitTargetTeam, DOTA_UNIT_TARGET_TEAM_NONE)
	tInfo.iUnitTargetType = default(tInfo.iUnitTargetType, DOTA_UNIT_TARGET_NONE)
	tInfo.iUnitTargetFlags = default(tInfo.iUnitTargetFlags, DOTA_UNIT_TARGET_FLAG_NONE)

	-- 弹道碰撞半径
	tInfo.flRadius = default(tInfo.flRadius, 0)
	tInfo.flStartRadius = default(tInfo.flStartRadius, tInfo.flRadius)
	tInfo.flEndRadius = default(tInfo.flEndRadius, tInfo.flRadius)
	tInfo._PriviousRadius = tInfo.flStartRadius
	tInfo._NextRadius = tInfo.flStartRadius

	tInfo.iType = PROJECTILE_TYPE_TRACKING
	tInfo.tTargets = {}	---记录击中过的单位
	-- 自己创建特效
	local iParticleID = ParticleManager:CreateParticle(tInfo.sEffectName, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, tInfo.vSpawnOrigin)
	ParticleManager:SetParticleControlEnt(iParticleID, 1, tInfo.hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", tInfo.hTarget:GetAbsOrigin(), false)
	ParticleManager:SetParticleControl(iParticleID, 2, Vector(tInfo.iMoveSpeed, 0, 0))
	tInfo.iParticleID = iParticleID

	return self:_InitProjectile(tInfo)
end
---创建制导弹道
---@param tInfo.hAbility 技能
---@param tInfo.hCaster 来源
---@param tInfo.hTarget 目标 可选
---@param tInfo.vTarget 目标点 可选
---@param tInfo.sEffectName 特效
---@param tInfo.vSpawnOrigin 起始点
---@param tInfo.iBounce 弹射次数 可选
---@param tInfo.bCounter 是否能反弹 默认false
---@param tInfo.iHitCount 命中次数 默认不计算
---@param tInfo.bAttack 是否是攻击
---@param tInfo.flLifeTime 最大生命周期 默认10秒
---@param tInfo.bAutoTrack 是否自动追踪新目标 默认false
---@param tInfo.flTrackRadius 自动追踪搜寻范围 默认1200
---@param tInfo.flAngularVelocity 角速度
---@param tInfo.iMoveSpeed 速度
---@param tInfo.vDirection 方向 可选
---@param tInfo.flRadius 半径
---@param tInfo.iUnitTargetTeam 目标队伍
---@param tInfo.iUnitTargetType 目标类型
---@param tInfo.iUnitTargetFlags 目标标记
---@param tInfo.ExtraData 额外数据
---@return number 弹道索引
function public:CreateGuidanceProjectile(tInfo)
	tInfo.vPosition = tInfo.vSpawnOrigin	---记录当前弹道位置
	tInfo.vTarget = tInfo.vTarget or tInfo.hTarget:GetAbsOrigin()
	tInfo.vDirection = tInfo.vDirection or (tInfo.vTarget - tInfo.vSpawnOrigin):Normalized()	---初始方向
	tInfo.vDirection.z = 0
	tInfo.iMoveSpeed = self:_GetMoveSpeed(tInfo)
	tInfo.vVelocity = tInfo.iMoveSpeed * tInfo.vDirection	---弹道速度
	tInfo.iBounce = self:_GetBounce(tInfo)					---弹射次数
	tInfo.bCounter = default(tInfo.bCounter, false)			---是否可以反弹
	tInfo.bDestroy = default(tInfo.bDestroy, true)			---是否可以销毁
	tInfo.bIgnoreBlock = default(tInfo.bIgnoreBlock, true)			---是否无视障碍物
	tInfo.bDestroyOnBounce = default(tInfo.bDestroyOnBounce, true)	---没有弹射次数时是否销毁
	tInfo.bAttack = default(tInfo.bAttack, false)			---是否是攻击
	tInfo.bAutoTrack = default(tInfo.bAutoTrack, false)		---是否自动追踪新目标
	tInfo.flTrackRadius = default(tInfo.flTrackRadius, 1200)
	tInfo.flLifeTime = default(tInfo.flLifeTime, PROJECTILE_GUIDANCE_MAX_LIFETIME)		---弹道的生命周期
	tInfo.flLifeTimeRemaining = tInfo.flLifeTime			---弹道的剩余生命
	tInfo.flAngularVelocity = default(tInfo.flAngularVelocity, PROJECTILE_GUIDANCE_ANGULAR_VELOCITY)		---弹道的角速度
	tInfo.iUnitTargetTeam = default(tInfo.iUnitTargetTeam, DOTA_UNIT_TARGET_TEAM_NONE)
	tInfo.iUnitTargetType = default(tInfo.iUnitTargetType, DOTA_UNIT_TARGET_NONE)
	tInfo.iUnitTargetFlags = default(tInfo.iUnitTargetFlags, DOTA_UNIT_TARGET_FLAG_NONE)

	-- 弹道碰撞半径
	tInfo.flRadius = tInfo.flRadius or 0
	tInfo.flStartRadius = tInfo.flRadius
	tInfo.flEndRadius = tInfo.flRadius
	tInfo._PriviousRadius = tInfo.flStartRadius
	tInfo._NextRadius = tInfo.flStartRadius

	tInfo.iType = PROJECTILE_TYPE_GUIDANCE
	tInfo.tTargets = {}	---记录击中过的单位
	-- 马甲单位
	tInfo.hThinker = SpawnEntityFromTableSynchronous("prop_dynamic", { origin = tInfo.vTarget, model = "models/development/invisiblebox.vmdl" })
	local iParticleID = ParticleManager:CreateParticle(tInfo.sEffectName, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, tInfo.vSpawnOrigin)
	ParticleManager:SetParticleControlEnt(iParticleID, 1, tInfo.hThinker, PATTACH_ABSORIGIN_FOLLOW, nil, tInfo.hThinker:GetAbsOrigin(), false)
	ParticleManager:SetParticleControl(iParticleID, 2, Vector(tInfo.iMoveSpeed, 0, 0))
	tInfo.iParticleID = iParticleID

	return self:_InitProjectile(tInfo)
end

---分裂弹道操作（角度总和不会超过360度）
---@param hCaster 来源
---@param vDirection 主方向
---@param iSplitCount 分裂个数
---@param flAngle 角度间隔
function public:SplitAction(hCaster, vDirection, iSplitCount, flAngleInterval, callback)
	iSplitCount = iSplitCount + GetModifierProjectileSplitCount(hCaster)
	local flAngle = (iSplitCount - 1) * flAngleInterval
	if flAngle >= 360 then
		flAngleInterval = 360 / iSplitCount
		flAngle = (iSplitCount - 1) * flAngleInterval
	end
	local tDirection = {}
	for i = 1, iSplitCount do
		table.insert(tDirection, RotatePosition(Vector(0, 0, 0), QAngle(0, -flAngle * 0.5 + (i - 1) * flAngleInterval, 0), vDirection))
	end
	for i, vDirection in ipairs(tDirection) do
		callback(vDirection)
	end
end

---选取一个多边形区域内的所有弹道
---@param tPolygonPoints 多边形顶点集合
function public:GetProjectileInPolygon(iTeamNumber, tPolygonPoints)
	local tProjectiles = {}
	for iProjectileIndex, tInfo in pairs(self.tProjectile) do
		if IsValid(tInfo.hCaster) and tInfo.hCaster:GetTeamNumber() ~= iTeamNumber and IsPointInPolygon(tInfo.vPosition, tPolygonPoints) then
			table.insert(tProjectiles, iProjectileIndex)
		end
	end
	return tProjectiles
end

---选取一个圆范围内的所有弹道
---@param vCenter 中心点
---@param flRadius 半径
function public:GetProjectileInRadius(iTeamNumber, vCenter, flRadius)
	local tProjectiles = {}
	for iProjectileIndex, tInfo in pairs(self.tProjectile) do
		if IsValid(tInfo.hCaster) and tInfo.hCaster:GetTeamNumber() ~= iTeamNumber and (tInfo.vPosition - vCenter):Length2D() <= flRadius then
			table.insert(tProjectiles, iProjectileIndex)
		end
	end
	return tProjectiles
end

---选取直线范围内的所有弹道
---@param vStart 起始点
---@param vEnd 终点
---@param flStartRadius 起始半径
---@param flEndRadius 终点半径 默认为起始半径
function public:GetProjectileInLine(iTeamNumber, vStart, vEnd, flStartRadius, flEndRadius)
	if flEndRadius == nil then
		flEndRadius = flStartRadius
	end
	local tProjectiles = {}
	local vDir = (vStart - vEnd):Normalized()
	local tPoints = {
		vStart + RotatePosition(vec3_zero, QAngle(0, 90, 0), vDir) * flStartRadius,
		vStart - RotatePosition(vec3_zero, QAngle(0, 90, 0), vDir) * flStartRadius,
		vEnd - RotatePosition(vec3_zero, QAngle(0, 90, 0), vDir) * flEndRadius,
		vEnd + RotatePosition(vec3_zero, QAngle(0, 90, 0), vDir) * flEndRadius,
	}
	-- DebugDrawLine(tPoints[1], tPoints[2], 255, 0, 0, true, 5)
	-- DebugDrawLine(tPoints[2], tPoints[3], 255, 0, 0, true, 5)
	-- DebugDrawLine(tPoints[3], tPoints[4], 255, 0, 0, true, 5)
	-- DebugDrawLine(tPoints[4], tPoints[1], 255, 0, 0, true, 5)
	for iProjectileIndex, tInfo in pairs(self.tProjectile) do
		if IsValid(tInfo.hCaster) and tInfo.hCaster:GetTeamNumber() ~= iTeamNumber then
			if (tInfo.vPosition - vStart):Length2D() <= flStartRadius then
				table.insert(tProjectiles, iProjectileIndex)
			elseif (tInfo.vPosition - vEnd):Length2D() <= flEndRadius then
				table.insert(tProjectiles, iProjectileIndex)
			elseif IsPointInPolygon(tInfo.vPosition, tPoints) then
				table.insert(tProjectiles, iProjectileIndex)
			end
		end
	end
	return tProjectiles
end

---销毁弹道
---@param iProjectileIndex 弹道索引
function public:DestroyProjectile(iProjectileIndex, bForce)
	local tInfo = self:_GetProjectileInfo(iProjectileIndex)
	if tInfo == nil or (not self:IsDestroyable(iProjectileIndex) and not bForce) then
		return
	end
	self:_DestroyProjectile(iProjectileIndex)
end

---弹反弹道
---@param hCaster 弹反触发单位
---@param iProjectileIndex 弹道索引
function public:CounterProjectile(iProjectileIndex, hCaster)
	local tInfo = vlua.clone(self.tProjectile[iProjectileIndex])
	if (tInfo.bCounter and tInfo.bCounter == false) or (tInfo.bIgnoreBlock and tInfo.bIgnoreBlock == false) then
		return
	end
	self:_DestroyProjectile(iProjectileIndex)
	if tInfo.iType == PROJECTILE_TYPE_GUIDANCE then
		tInfo.vTarget = IsValid(tInfo.hCaster) and tInfo.hCaster:GetAbsOrigin() or (hCaster:GetAbsOrigin() - tInfo.vDirection * 300)
		tInfo.hTarget = nil
		tInfo.hCaster = hCaster
		tInfo.vSpawnOrigin = tInfo.vPosition
		tInfo.iMoveSpeed = tInfo.iMoveSpeed * PROJECTILE_COUNTER_MOVESPEED_MULTIPLE
		tInfo.vDirection = -tInfo.vDirection
		-- tInfo.flStartRadius = tInfo.flStartRadius or tInfo.flRadius
		-- tInfo.flEndRadius = tInfo.flEndRadius or tInfo.flRadius
		self:CreateGuidanceProjectile(tInfo)
	end
end

---增加弹道弹射次数
---@param iProjectileIndex 弹道索引
---@param iCount 增加的弹射次数 默认为1
function public:IncrementBounce(iProjectileIndex, iCount)
	local tInfo = self.tProjectile[iProjectileIndex]
	if tInfo == nil then
		return
	end
	iCount = iCount or 1
	tInfo.iBounce = tInfo.iBounce + iCount
end

---减少弹道弹射次数
---@param iProjectileIndex 弹道索引
---@param iCount 减少的弹射次数 默认为1
function public:DecrementBounce(iProjectileIndex, iCount)
	local tInfo = self.tProjectile[iProjectileIndex]
	if tInfo == nil then
		return
	end
	iCount = iCount or 1
	tInfo.iBounce = math.max(tInfo.iBounce - iCount, 0)
end

---加速弹道
---@param iProjectileIndex 弹道索引
---@param iMoveSpeed 增加的弹道速度 默认为0
function public:IncrementMoveSpeed(iProjectileIndex, iMoveSpeed)
	local tInfo = self.tProjectile[iProjectileIndex]
	if tInfo == nil then
		return
	end
	iMoveSpeed = iMoveSpeed or 0
	tInfo.iMoveSpeed = tInfo.iMoveSpeed + iMoveSpeed
end

---减速弹道
---@param iProjectileIndex 弹道索引
---@param iMoveSpeed 减少的弹道速度 默认为0
function public:DecrementMoveSpeed(iProjectileIndex, iMoveSpeed)
	local tInfo = self.tProjectile[iProjectileIndex]
	if tInfo == nil then
		return
	end
	iMoveSpeed = iMoveSpeed or 0
	tInfo.iMoveSpeed = math.max(tInfo.iMoveSpeed - iMoveSpeed, 0)
end

---判断某个点是否可通行
function public:IsValidPosition(vPosition)
	return GridNav:IsTraversable(vPosition) and not GridNav:IsBlocked(vPosition)
end

---判断弹道是否有效
---@param iProjectileIndex 弹道索引
---@return boolean
function public:IsValidProjectile(iProjectileIndex)
	return self.tProjectile[iProjectileIndex] ~= nil
end

---获取弹道当前位置
---@param iProjectileIndex 弹道索引
---@return Vector|boolean
function public:GetProjectilePosition(iProjectileIndex)
	if self:IsValidProjectile(iProjectileIndex) then
		return self.tProjectile[iProjectileIndex].vPosition
	else
		return false
	end
end

---设置某个队伍的弹道速度倍率
function public:SetProjectileMoveSpeedMultipleWithTeam(iTeamNumber, iMultiple)
	if self.iProjectileMoveSpeedMultipleWithTeam[iTeamNumber] == nil then
		error("error teamnumber")
		return
	end
	self.iProjectileMoveSpeedMultipleWithTeam[iTeamNumber] = iMultiple
end

---移除额外的自定义属性
function public:RemoveExtraProperty(iProjectileIndex, sKey)
	local tInfo = self:_GetProjectileInfo(iProjectileIndex)
	tInfo[sKey] = nil
end

----------------------------------------Get----------------------------------------
---获取额外自定义的属性
function public:GetExtraProperty(iProjectileIndex, sKey)
	return self:_GetProjectileProperty(iProjectileIndex, sKey)
end
---获取弹道剩余生命周期
function public:GetLifeRemaining(iProjectileIndex)
	return self:_GetProjectileProperty(iProjectileIndex, "flLifeTimeRemaining")
end
---获取弹道速度
function public:GetMovespeed(iProjectileIndex)
	return self:_GetProjectileProperty(iProjectileIndex, "iMoveSpeed")
end
---获取弹道速度
function public:GetDirection(iProjectileIndex)
	return self:_GetProjectileProperty(iProjectileIndex, "vDirection")
end
---获取弹道技能
function public:GetAbility(iProjectileIndex)
	return self:_GetProjectileProperty(iProjectileIndex, "hAbility")
end
---获取弹道施法者
function public:GetCaster(iProjectileIndex)
	return self:_GetProjectileProperty(iProjectileIndex, "hCaster")
end
---获取弹道目标
function public:GetTarget(iProjectileIndex)
	return self:_GetProjectileProperty(iProjectileIndex, "hTarget")
end
---获取弹道距离
function public:GetDistance(iProjectileIndex)
	return self:_GetProjectileProperty(iProjectileIndex, "flDistance")
end
---获取弹道起始半径
function public:GetStartRadius(iProjectileIndex)
	return self:_GetProjectileProperty(iProjectileIndex, "flStartRadius")
end
---获取弹道终点半径
function public:GetEndRadius(iProjectileIndex)
	return self:_GetProjectileProperty(iProjectileIndex, "flEndRadius")
end
---获取弹道半径
function public:GetRadius(iProjectileIndex)
	return self:_GetProjectileProperty(iProjectileIndex, "flRadius")
end
---获取弹道弹射次数
function public:GetBounce(iProjectileIndex)
	return self:_GetProjectileProperty(iProjectileIndex, "_iOriginalBounce")
end
---获取弹道弹射次数
function public:GetBounceRemaining(iProjectileIndex)
	return self:_GetProjectileProperty(iProjectileIndex, "iBounce")
end
---获取弹道打击次数
function public:GetBounceRemaining(iProjectileIndex)
	return self:_GetProjectileProperty(iProjectileIndex, "iHitCount")
end
---获取弹道类型
function public:GetType(iProjectileIndex)
	return self:_GetProjectileProperty(iProjectileIndex, "iType")
end
---弹道是否无视障碍物
function public:IsIgnoreBlock(iProjectileIndex)
	return self:_GetProjectileProperty(iProjectileIndex, "bIgnoreBlock")
end
---弹道是否可以反弹
function public:IsCountable(iProjectileIndex)
	return self:_GetProjectileProperty(iProjectileIndex, "bCounter")
end
---弹道是否可以销毁
function public:IsDestroyable(iProjectileIndex)
	return self:_GetProjectileProperty(iProjectileIndex, "bDestroy")
end

--------------------------------------------------------------------------------
-- private
--------------------------------------------------------------------------------
---寻找一条直线上的单位
---@param iTeamNumber 队伍
---@param vStart 开始点
---@param vEnd 结束点
---@param flStartRadius 开始半径
---@param flEndRadius 结束半径
---@param iTargetTeam 目标队伍
---@param iTargetType 目标类型
---@param iTargetFlags 目标标记
---@return table
---@private
function public:_FindUnitInLine(iTeamNumber, vStart, vEnd, flStartRadius, flEndRadius, iTargetTeam, iTargetType, iTargetFlags)
	local flRadius = (vStart - vEnd):Length2D() + flStartRadius + flEndRadius
	local vDir = (vStart - vEnd):Normalized()
	local vCenter = VectorLerp(0.5, vStart + vDir * flStartRadius, vEnd - vDir * flEndRadius)
	local tPoints = {
		vStart + RotatePosition(vec3_zero, QAngle(0, 90, 0), vDir) * flStartRadius,
		vStart - RotatePosition(vec3_zero, QAngle(0, 90, 0), vDir) * flStartRadius,
		vEnd - RotatePosition(vec3_zero, QAngle(0, 90, 0), vDir) * flEndRadius,
		vEnd + RotatePosition(vec3_zero, QAngle(0, 90, 0), vDir) * flEndRadius,
	}
	self:_DebugDrawCircle(vStart, Vector(255, 0, 0), 0, flStartRadius, true, 0.2)
	self:_DebugDrawCircle(vEnd, Vector(255, 0, 0), 0, flEndRadius, true, 0.2)
	-- DebugDrawLine(tPoints[1], tPoints[2], 255, 0, 0, true, 1)
	-- DebugDrawLine(tPoints[2], tPoints[3], 255, 0, 0, true, 1)
	-- DebugDrawLine(tPoints[3], tPoints[4], 255, 0, 0, true, 1)
	-- DebugDrawLine(tPoints[4], tPoints[1], 255, 0, 0, true, 1)
	local tTargetInLine = {}
	local tTargets = FindUnitsInRadius(iTeamNumber, vCenter, nil, flRadius, iTargetTeam, iTargetType, iTargetFlags, FIND_ANY_ORDER, false)
	for _, hUnit in ipairs(tTargets) do
		local vUnitLoc = hUnit:GetAbsOrigin()
		if (vUnitLoc - vStart):Length2D() < flStartRadius then
			table.insert(tTargetInLine, hUnit)
		elseif (vUnitLoc - vEnd):Length2D() < flEndRadius then
			table.insert(tTargetInLine, hUnit)
		elseif IsPointInPolygon(vUnitLoc, tPoints) then
			table.insert(tTargetInLine, hUnit)
		end
	end
	return tTargetInLine
end
---将坐标转换为grid的中点
---@private
function public:_NormalizedToGrid(vPosition)
	return Vector(GridNav:GridPosToWorldCenterX(GridNav:WorldToGridPosX(vPosition.x)), GridNav:GridPosToWorldCenterY(GridNav:WorldToGridPosY(vPosition.y)), vPosition.z)
end
---计算线性弹道
---@private
function public:_OnLinearProjectileThink(index)
	local tInfo = self.tProjectile[index]
	tInfo.vPrevious = tInfo.vPosition	---上一个位置
	tInfo.vPosition = tInfo.vPosition + tInfo.vVelocity * FrameTime()	---当前位置
	-- tInfo.hThinker:SetAbsOrigin(tInfo.vPosition)
	if tInfo.iParticleID == nil then
		local iParticleID = ParticleManager:CreateParticle(tInfo.sEffectName, PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlForward(iParticleID, 0, tInfo.vVelocity:Normalized())
		ParticleManager:SetParticleControl(iParticleID, 0, tInfo.vPosition)
		ParticleManager:SetParticleControl(iParticleID, 1, tInfo.vVelocity)
		tInfo.iParticleID = iParticleID
	end
	if tInfo.bIgnoreBlock == nil or tInfo.bIgnoreBlock == false then
		-- 计算路径上有没有碰撞物
		local bBlock, vBlock = self:_IsBlockInLine(tInfo)
		-- 遇到障碍物要反弹
		if not self:IsValidPosition(tInfo.vPosition) or bBlock == true then
			self:_DebugDrawCircle(tInfo.vPosition, Vector(255, 0, 0), 0, 10, true, 1)	--打印出错误位置
			-- 计算出最接近障碍物的位置
			if bBlock == false then
				vBlock = self:_GetBlockPosition(tInfo)
			end
			self:_DebugDrawCircle(vBlock, Vector(255, 255, 0), 0, 10, true, 1)	--打印出碰撞位置
			if tInfo.iBounce > 0 then
				self:_OnProjectileBounceStart(index)
				tInfo.iBounce = tInfo.iBounce - 1
				-- 反射向量
				local vRef = self:_GetReflection(vBlock, tInfo.vDirection)
				-- DebugDrawLine(vBlock, vBlock + vRef:Normalized() * 500, 255, 0, 0, true, 5)	--打印反射向量
				tInfo.vDirection = vRef
				tInfo.vVelocity = vRef * tInfo.iMoveSpeed
				tInfo.vPosition = vBlock + (tInfo.iMoveSpeed * FrameTime() - (vBlock - tInfo.vPrevious):Length2D()) * vRef:Normalized()	-- 更新正确的位置
				-- local flFixDistance = tInfo.iMoveSpeed * FrameTime() - (vBlock - tInfo.vPrevious):Length2D()
				-- tInfo.vPosition = self:GetNextPosition(tInfo, vBlock, flFixDistance)
				-- tInfo.vPosition = vBlock + flFixDistance * vRef:Normalized()	-- 更新正确的位置
				self:_DebugDrawCircle(tInfo.vPosition, Vector(0, 255, 255), 50, 10, true, 1)
				-- 重新创建特效
				ParticleManager:DestroyParticle(tInfo.iParticleID, false)
				tInfo.iParticleID = nil
				-- 反弹后清空单位组
				tInfo.tTargets = {}
				self:_OnProjectileBounceEnd(index)
			else
				if tInfo.bDestroyOnBounce then
					self:_DestroyProjectile(index)
					return
				else
					if not VectorIsZero(tInfo.vVelocity) then
						tInfo.vVelocity = vec3_zero
						tInfo.vPosition = vBlock
						-- 重新创建特效
						ParticleManager:DestroyParticle(tInfo.iParticleID, false)
						local iParticleID = ParticleManager:CreateParticle(tInfo.sEffectName, PATTACH_CUSTOMORIGIN, nil)
						ParticleManager:SetParticleControlForward(iParticleID, 0, tInfo.vVelocity:Normalized())
						ParticleManager:SetParticleControl(iParticleID, 0, tInfo.vPosition)
						ParticleManager:SetParticleControl(iParticleID, 1, tInfo.vVelocity)
						tInfo.iParticleID = iParticleID
					end
				end
			end
		else
			self:_DebugDrawCircle(tInfo.vPosition, Vector(0, 255, 0), 0, 10, true, 1)	--打印出有效位置
		end
	end
	-- 命中单位
	tInfo._PriviousRadius = RemapValClamped((tInfo.flLifeTime - tInfo.flLifeTimeRemaining - FrameTime()) / tInfo.flLifeTime, 0, 1, tInfo.flStartRadius, tInfo.flEndRadius)
	tInfo._NextRadius = RemapValClamped((tInfo.flLifeTime - tInfo.flLifeTimeRemaining) / tInfo.flLifeTime, 0, 1, tInfo.flStartRadius, tInfo.flEndRadius)

	-- think
	self:_OnProjectileThink(index)
	-- 命中单位
	if not self:_OnProjectileHit(index) then
		return
	end
	-- 计算生命周期，销毁
	tInfo.flLifeTimeRemaining = tInfo.flLifeTimeRemaining - FrameTime()
	if tInfo.flLifeTimeRemaining <= 0 then
		self:_DestroyProjectile(index)
	end
end
---计算跟踪弹道
---@private
function public:_OnTrackingProjectileThink(index)
	local tInfo = self.tProjectile[index]
	tInfo.vPrevious = tInfo.vPosition	---上一个位置
	-- 无效目标则往目标最后位置飞去
	if not IsValid(tInfo.hTarget) then
		tInfo.vDirection.z = 0
	end
	tInfo.vTarget = tInfo.iType == PROJECTILE_TYPE_TRACKING and tInfo.hTarget:GetAttachmentPosition("attach_hitloc") or tInfo.vTarget
	tInfo.vDirection = (tInfo.vTarget - tInfo.vPrevious):Normalized()	-- 计算新的方向
	tInfo.vPosition = tInfo.vPosition + tInfo.iMoveSpeed * tInfo.vDirection * FrameTime()	---当前位置
	-- 如果这一帧的运动的距离会超过弹道与目标的距离则将位置修正为目标的位置
	if (tInfo.vTarget - tInfo.vPrevious):Length2D() < tInfo.iMoveSpeed * FrameTime() then
		-- 如果这一帧目标的位置超过了这个距离则跳过
		if (tInfo.vTarget - tInfo.vPosition):Length2D() < tInfo.iMoveSpeed * FrameTime() then
			tInfo.vPosition = tInfo.vTarget
		end
	end
	if tInfo.bIgnoreBlock == nil or tInfo.bIgnoreBlock == false then
		-- 计算路径上有没有碰撞物
		local bBlock, vBlock = self:_IsBlockInLine(tInfo)
		-- 遇到障碍物要反弹并且变成线性弹道，没有弹射次数直接销毁
		if not self:IsValidPosition(tInfo.vPosition) or bBlock == true then
			self:_DebugDrawCircle(tInfo.vPosition, Vector(255, 0, 0), 0, 10, true, 1)	--打印出错误位置
			-- 计算出最接近障碍物的位置
			if bBlock == false then
				vBlock = self:_GetBlockPosition(tInfo)
			end
			self:_DebugDrawCircle(vBlock, Vector(255, 255, 0), 0, 10, true, 1)	--打印出碰撞位置
			if tInfo.iBounce > 0 then
				self:_OnProjectileBounceStart(index)
				tInfo.iBounce = tInfo.iBounce - 1
				-- 反射向量
				local vRef = self:_GetReflection(vBlock, tInfo.vDirection)
				-- DebugDrawLine(vBlock, vBlock + vRef:Normalized() * 500, 255, 0, 0, true, 5)	--打印反射向量
				tInfo.vDirection = vRef
				tInfo.vVelocity = vRef * tInfo.iMoveSpeed
				tInfo.vPosition = vBlock + (tInfo.iMoveSpeed * FrameTime() - (vBlock - tInfo.vPrevious):Length2D()) * vRef:Normalized()	-- 更新正确的位置
				self:_DebugDrawCircle(tInfo.vPosition, Vector(0, 255, 0), 50, 5, true, 1)
				-- 更改特效目标点
				tInfo.vTarget = tInfo.vPosition + tInfo.vDirection * (tInfo.vPosition - tInfo.vSpawnOrigin):Length2D()
				ParticleManager:DestroyParticle(tInfo.iParticleID, false)
				local iParticleID = ParticleManager:CreateParticle(tInfo.sEffectName, PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControlForward(iParticleID, 0, tInfo.vVelocity:Normalized())
				ParticleManager:SetParticleControl(iParticleID, 0, tInfo.vPosition)
				ParticleManager:SetParticleControl(iParticleID, 1, tInfo.vTarget)
				ParticleManager:SetParticleControl(iParticleID, 2, Vector(tInfo.iMoveSpeed, 0, 0))
				-- ParticleManager:SetParticleControlEnt(tInfo.iParticleID, 1, nil, PATTACH_INVALID, "", vec3_zero, false)
				tInfo.iParticleID = iParticleID
				-- 反弹后清空单位组
				tInfo.tTargets = {}
				self:_OnProjectileBounceEnd(index)
			else
				self:_DestroyProjectile(index)
			end
		else
			self:_DebugDrawCircle(tInfo.vPosition, Vector(0, 255, 0), 0, 10, true, 1)	--打印出有效位置
		end
	end
	-- think
	self:_OnProjectileThink(index)
	-- 命中单位
	if not self:_OnProjectileHit(index) then
		return
	end
	-- 销毁
	if tInfo.vPosition == tInfo.vTarget then
		-- 命中索敌目标
		if IsValid(tInfo.hTarget) then
			self:_OnProjectileHit(index, { tInfo.hTarget })
		end
		self:_DestroyProjectile(index)
	end
end
---@private
function public:_OnGuidanceProjectileThink(index)
	local tInfo = self.tProjectile[index]
	tInfo.vPrevious = tInfo.vPosition	---上一个位置
	tInfo.vPrevious.z = tInfo.vSpawnOrigin.z

	-- 如果目标存在则更新目标位置，否则弹道直线飞行
	if IsValid(tInfo.hTarget) and tInfo.hTarget:IsAlive() then
		tInfo.vTarget = tInfo.hTarget:GetAbsOrigin()
		self:_DebugDrawCircle(tInfo.hThinker:GetAbsOrigin(), Vector(222, 0, 255), 0, 5, true, 1)	--打印出有效位置
		local vCross = (tInfo.hThinker:GetAbsOrigin() - tInfo.vPrevious):Normalized():Cross((tInfo.vTarget - tInfo.vPrevious):Normalized())
		if vCross.z > 0 then
			tInfo.hThinker:SetAbsOrigin(tInfo.vPrevious + RotatePosition(vec3_zero, QAngle(0, tInfo.flAngularVelocity * FrameTime(), 0), tInfo.vDirection):Normalized() * tInfo.iMoveSpeed * FrameTime() * 2)
		else
			tInfo.hThinker:SetAbsOrigin(tInfo.vPrevious + RotatePosition(vec3_zero, QAngle(0, -tInfo.flAngularVelocity * FrameTime(), 0), tInfo.vDirection):Normalized() * tInfo.iMoveSpeed * FrameTime() * 2)
		end
		tInfo.vDirection = (tInfo.hThinker:GetAbsOrigin() - tInfo.vPrevious):Normalized()	-- 计算新的方向
	elseif tInfo.bAutoTrack then
		-- 自动索敌
		local tTargets = FindUnitsInRadius(tInfo.hCaster:GetTeamNumber(), tInfo.vPrevious, nil, tInfo.flTrackRadius, tInfo.iUnitTargetTeam, tInfo.iUnitTargetType, tInfo.iUnitTargetFlags, FIND_CLOSEST, false)
		if IsValid(tTargets[1]) then
			tInfo.hTarget = tTargets[1]
			-- return
		else
			tInfo.hThinker:SetAbsOrigin(tInfo.vPosition + tInfo.iMoveSpeed * tInfo.vDirection)
		end
	else
		tInfo.hThinker:SetAbsOrigin(tInfo.vPosition + tInfo.iMoveSpeed * tInfo.vDirection)
		-- tInfo.hThinker:SetAbsOrigin(tInfo.vPosition + tInfo.iMoveSpeed * tInfo.vDirection * FrameTime())
	end
	tInfo.vPosition = tInfo.vPosition + tInfo.iMoveSpeed * tInfo.vDirection * FrameTime()	---当前位置
	self:_DebugDrawCircle(tInfo.vPosition, Vector(0, 255, 0), 0, 10, true, 1)	--打印出有效位置

	if tInfo.bIgnoreBlock == nil or tInfo.bIgnoreBlock == false then
		-- 计算路径上有没有碰撞物
		local bBlock, vBlock = self:_IsBlockInLine(tInfo)
		-- 遇到障碍物要反弹并且变成线性弹道，没有弹射次数直接销毁
		if not self:IsValidPosition(tInfo.vPosition) or bBlock == true then
			self:_DebugDrawCircle(tInfo.vPosition, Vector(255, 0, 0), 0, 10, true, 1)	--打印出错误位置
			-- 计算出最接近障碍物的位置
			if bBlock == false then
				vBlock = self:_GetBlockPosition(tInfo)
			end
			self:_DebugDrawCircle(vBlock, Vector(255, 255, 0), 0, 10, true, 1)	--打印出碰撞位置
			if tInfo.iBounce > 0 then
				self:_OnProjectileBounceStart(index)
				tInfo.iBounce = tInfo.iBounce - 1
				-- 反射向量
				local vRef = self:_GetReflection(vBlock, tInfo.vDirection)
				-- DebugDrawLine(vBlock, vBlock + vRef:Normalized() * 500, 255, 0, 0, true, 5)	--打印反射向量
				tInfo.vDirection = vRef
				tInfo.hThinker:SetAbsOrigin(vBlock + (tInfo.hThinker:GetAbsOrigin() - tInfo.vPosition):Length2D() * tInfo.vDirection)
				tInfo.vPosition = vBlock + (tInfo.iMoveSpeed * FrameTime() - (vBlock - tInfo.vPrevious):Length2D()) * vRef:Normalized()	-- 更新正确的位置
				self:_DebugDrawCircle(tInfo.vPosition, Vector(0, 255, 0), 50, 5, true, 1)
				-- 反弹后清空单位组
				tInfo.tTargets = {}
				self:_OnProjectileBounceEnd(index)
			else
				self:_DestroyProjectile(index)
			end
		else
			self:_DebugDrawCircle(tInfo.vPosition, Vector(0, 255, 0), 0, 10, true, 1)	--打印出有效位置
		end
	end

	-- think
	self:_OnProjectileThink(index)
	-- 命中单位
	if not self:_OnProjectileHit(index) then
		return
	end
	-- 计算生命周期，销毁
	tInfo.flLifeTimeRemaining = tInfo.flLifeTimeRemaining - FrameTime()
	if tInfo.flLifeTimeRemaining <= 0 then
		self:_DestroyProjectile(index)
	end
end
---每帧回调
---@private
function public:_OnProjectileThink(iProjectileIndex)
	local tInfo = self.tProjectile[iProjectileIndex]
	if tInfo == nil then return true end
	if not IsValid(tInfo.hCaster) then return true end

	if tInfo.OnProjectileThink then
		xpcall(tInfo.OnProjectileThink, error, tInfo.vPosition, tInfo)
	elseif tInfo.hAbility then
		if tInfo.hAbility.OnProjectileThink and tInfo.hAbility.OnProjectileThink ~= tInfo.hAbility.BaseClass.OnProjectileThink then
			xpcall(tInfo.hAbility.OnProjectileThink, error, tInfo.hAbility, tInfo.vPosition, tInfo)
		end
	end
end
---当弹道即将反弹
---@private
function public:_OnProjectileBounceStart(iProjectileIndex)
	local tInfo = self.tProjectile[iProjectileIndex]
	if tInfo == nil then return true end
	if not IsValid(tInfo.hCaster) then return true end
	if tInfo.OnProjectileBounceStart then
		xpcall(tInfo.OnProjectileBounceStart, error, tInfo.vPosition, tInfo)
	elseif tInfo.hAbility then
		if (type(tInfo.hAbility.OnProjectileBounceStart) == "function") then
			xpcall(tInfo.hAbility.OnProjectileBounceStart, error, tInfo.hAbility, tInfo.vPosition, tInfo)
		end
	end
end
---当弹道反弹结束
---@private
function public:_OnProjectileBounceEnd(iProjectileIndex)
	local tInfo = self.tProjectile[iProjectileIndex]
	if tInfo == nil then return true end
	if not IsValid(tInfo.hCaster) then return true end
	if tInfo.OnProjectileBounceEnd then
		xpcall(tInfo.OnProjectileBounceEnd, error, tInfo.vPosition, tInfo)
	elseif tInfo.hAbility then
		if (type(tInfo.hAbility.OnProjectileBounceEnd) == "function") then
			xpcall(tInfo.hAbility.OnProjectileBounceEnd, error, tInfo.hAbility, tInfo.vPosition, tInfo)
		end
	end
end
---弹道销毁
---@private
function public:_OnProjectileDestroy(iProjectileIndex)
	local tInfo = self.tProjectile[iProjectileIndex]
	if tInfo == nil then return true end
	if not IsValid(tInfo.hCaster) then return true end
	if tInfo.OnProjectileDestroy then
		xpcall(tInfo.OnProjectileDestroy, error, tInfo.vPosition, tInfo)
	elseif tInfo.hAbility then
		if (type(tInfo.hAbility.OnProjectileDestroy) == "function") then
			xpcall(tInfo.hAbility.OnProjectileDestroy, error, tInfo.hAbility, tInfo.vPosition, tInfo)
		end
	end
end
---搜寻单位并命中
---@private
function public:_OnProjectileHit(iProjectileIndex, tDefaultTargets)
	local tInfo = self.tProjectile[iProjectileIndex]
	if tInfo == nil then return true end
	if not IsValid(tInfo.hCaster) then return true end

	local bCounter = false
	local hCounterUnit = nil
	local bDestroy = false
	-- 命中单位
	local tTargets = self:_FindUnitInLine(tInfo.hCaster:GetTeamNumber(), tInfo.vPrevious, tInfo.vPosition, tInfo._PriviousRadius, tInfo._NextRadius, tInfo.iUnitTargetTeam, tInfo.iUnitTargetType, tInfo.iUnitTargetFlags)

	if tDefaultTargets then
		for _, hUnit in ipairs(tDefaultTargets) do
			if TableFindKey(tTargets, hUnit) == nil then
				table.insert(tTargets, hUnit)
			end
		end
	end
	for _, hUnit in ipairs(tTargets) do
		if vlua.find(tInfo.tTargets, hUnit) == nil then
			if tInfo.funcUnitFilter == nil or tInfo.funcUnitFilter(hUnit) == true then
				if tInfo.OnProjectileHit then
					xpcall(tInfo.OnProjectileHit, error, hUnit, tInfo.vPosition, tInfo)
				elseif tInfo.hAbility and tInfo.hAbility.OnProjectileHit then
					if tInfo.hAbility.OnProjectileHit and tInfo.hAbility.OnProjectileHit ~= tInfo.hAbility.BaseClass.OnProjectileHit then
						xpcall(tInfo.hAbility.OnProjectileHit, error, tInfo.hAbility, hUnit, tInfo.vPosition, tInfo)
					end
				end
				if tInfo.iHitCount then
					tInfo.iHitCount = tInfo.iHitCount - 1
				end
				if tInfo.iHitCount and tInfo.iHitCount <= 0 then
					self:_DestroyProjectile(iProjectileIndex)
				end
				table.insert(tInfo.tTargets, hUnit)
			end
		end
	end
	if bCounter then
		self:CounterProjectile(iProjectileIndex, hCounterUnit)
		return false
	elseif bDestroy then
		self:_DestroyProjectile(iProjectileIndex)
		return false
	end
	return true
end
---获取下一帧的正确位置
---@param tInfo 弹道信息
---@private
function public:_GetNextPosition(tInfo, vStart, flDistance)

	---所有碰撞的点
	local tBlockPosition = {}

	local vCurrent = vStart
	local vNext = vStart
	-- 循环到走完所有距离
	while flDistance > 0 do
		vNext = vNext + tInfo.vDirection * self.iBlockTickDistance
		flDistance = flDistance - self.iBlockTickDistance
		-- 如果下一个点不能通行，则计算当前点的碰撞
		if not self:IsValidPosition(vNext) then
			if tInfo.iBounce > 0 then
				tInfo.iBounce = tInfo.iBounce - 1
				-- 计算法向量
				local vNormal = vec3_zero
				for i = 1, self.iCircleAccuracy do
					local vCirclePoint = vCurrent + RotatePosition(vec3_zero, QAngle(0, 360 / self.iCircleAccuracy * i, 0), Vector(0, self.iCircleRadius, 0))
					if not self:IsValidPosition(vCirclePoint) then
						self:_DebugDrawCircle(vCirclePoint, Vector(255, 0, 0), 50, 5, true, 1)
					else
						vNormal = vNormal + RotatePosition(vec3_zero, QAngle(0, 360 / self.iCircleAccuracy * i, 0), Vector(0, self.iCircleRadius, 0))
						self:_DebugDrawCircle(vCirclePoint, Vector(0, 255, 0), 50, 5, true, 1)
					end
				end
				-- 法向量
				vNormal = vNormal:Normalized()
				-- DebugDrawLine(vNext, vNext + vNormal:Normalized() * 500, 255, 0, 0, true, 5)	--打印出法向量
				-- 反射向量
				local vRef = tInfo.vDirection - (2 * (tInfo.vDirection:Dot(-vNormal:Normalized())) * -vNormal:Normalized())
				-- DebugDrawLine(vNext, vNext + vRef:Normalized() * 500, 255, 0, 0, true, 5)	--打印反射向量
				-- 更新当前方向
				tInfo.vDirection = vRef:Normalized()
				-- vVelocity = vRef:Normalized() * iMoveSpeed
				-- 修正下一个点的位置
				vNext = vCurrent + tInfo.vDirection * self.iBlockTickDistance
				self:_DebugDrawCircle(vNext, Vector(255, 0, 0), 0, 5, true, 1)
				table.insert(tBlockPosition, vCurrent)
			else
				DebugDrawCircle(vNext, Vector(255, 0, 0), 0, 5, true, 1)
				vNext = vCurrent
				break
			end
		else
			DebugDrawCircle(vNext, Vector(0, 255, 0), 0, 5, true, 1)
		end
	end
	-- if flDistance <= 0 then
	-- 	vNext = vStart
	-- end
	return vNext, tBlockPosition
end
---记录弹道并返回弹道索引
---@private
function public:_InitProjectile(tInfo)
	local iProjectileIndex = self.iProjectileIndex
	-- 存弹道
	self.tProjectile[iProjectileIndex] = tInfo
	-- 递增index
	self.iProjectileIndex = iProjectileIndex + 1
	return iProjectileIndex
end
---获取反弹次数
---@private
function public:_GetBounce(tInfo)
	tInfo._iOriginalBounce = (tInfo.iBounce or 0) + GetModifierProperty(tInfo.hCaster, EOM_MODIFIER_PROPERTY_BOUNCE_BONUS)
	return tInfo._iOriginalBounce
end
---获取弹道距离
---@private
function public:_GetDistance(tInfo)
	return tInfo.flDistance + GetModifierProjectileDistance(tInfo.hCaster)
end
---获取弹道速度
---@private
function public:_GetMoveSpeed(tInfo)
	local flMultiple = self.iProjectileMoveSpeedMultipleWithTeam[tInfo.hCaster:GetTeamNumber()] or 1
	local flModifierSpeed = GetModifierProjectileSpeed(tInfo.hCaster)
	return tInfo.iMoveSpeed * flMultiple + flModifierSpeed
end
---计算路径上有没有碰撞物
---@private
function public:_IsBlockInLine(tInfo)
	local bBlock = false
	local vBlock = tInfo.vPrevious
	while (vBlock - tInfo.vPosition):Length2D() > self.iTickDistance do
		vBlock = vBlock + tInfo.vDirection * self.iTickDistance
		if not self:IsValidPosition(vBlock) then
			bBlock = true
			break
		end
	end
	return bBlock, vBlock
end
---计算出最接近障碍物的位置
---@private
function public:_GetBlockPosition(tInfo)
	local vBlock = tInfo.vPosition
	while (vBlock - tInfo.vPrevious):Length2D() > self.iBlockTickDistance do
		vBlock = vBlock - tInfo.vDirection * self.iBlockTickDistance
		if self:IsValidPosition(vBlock) then
			break
		end
	end
	return vBlock
end
---计算法向量
---@private
function public:_GetNormal(vBlock)
	local vNormal = vec3_zero
	for i = 1, self.iCircleAccuracy do
		local vCirclePoint = vBlock + RotatePosition(vec3_zero, QAngle(0, 360 / self.iCircleAccuracy * i, 0), Vector(0, self.iCircleRadius, 0))
		if not self:IsValidPosition(vCirclePoint) then
			self:_DebugDrawCircle(vCirclePoint, Vector(255, 0, 0), 50, 5, true, 1)
		else
			vNormal = vNormal + RotatePosition(vec3_zero, QAngle(0, 360 / self.iCircleAccuracy * i, 0), Vector(0, self.iCircleRadius, 0))
			self:_DebugDrawCircle(vCirclePoint, Vector(0, 255, 0), 50, 5, true, 1)
		end
	end
	return vNormal:Normalized()
end
---计算反射向量
---@private
function public:_GetReflection(vBlock, vDirection)
	local vNormal = self:_GetNormal(vBlock)
	return (vDirection - (2 * (vDirection:Dot(-vNormal:Normalized())) * -vNormal:Normalized())):Normalized()
end
---封装一层画点
---@private
function public:_DebugDrawCircle(vPosition, vColor, flAlpha, flRadius, bZTest, flDuration)
	if PROJECTILE_DEBUG_MODE then
		DebugDrawCircle(vPosition, vColor, flAlpha, flRadius, bZTest, flDuration)
	end
end
---获取弹道信息
---@param iProjectileIndex number|table
function public:_GetProjectileInfo(iProjectileIndex)
	if type(iProjectileIndex) == "number" then
		return self.tProjectile[iProjectileIndex]
	elseif type(iProjectileIndex) == "table" then
		return iProjectileIndex
	end
end

function public:_GetProjectileProperty(iProjectileIndex, sKey)
	local tInfo = self:_GetProjectileInfo(iProjectileIndex)
	return tInfo[sKey]
end

---内部用强制销毁弹道
---@param iProjectileIndex 弹道索引
function public:_DestroyProjectile(iProjectileIndex)
	local tInfo = self.tProjectile[iProjectileIndex]
	if tInfo == nil then
		return
	end
	local vPosition = tInfo.vPrevious
	local hThinker = tInfo.hThinker

	self:_OnProjectileDestroy(iProjectileIndex)
	if tInfo.iParticleID then
		ParticleManager:DestroyParticle(tInfo.iParticleID, false)
	end
	if IsValid(hThinker) then
		UTIL_Remove(hThinker)
	end
	self.tProjectile[iProjectileIndex] = nil
end

return public