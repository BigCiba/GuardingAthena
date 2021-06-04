---@class Global
---为某个队伍添加临时视野
---@param nTeamID int
---@param vLocation Vector
---@param flRadius float
---@param flDuration float
---@param bObstructedVision bool
---@return int
function AddFOWViewer(nTeamID, vLocation, flRadius, flDuration, bObstructedVision) end

---Returns the number of degrees difference between two yaw angles返回两个偏航角之间的度差数
---@param float_1 float
---@param float_2 float
---@return float
function AngleDiff(float_1, float_2) end

---Generate a vector given a QAngles
---@param QAngle_1 QAngle
---@return Vector
function AnglesToVector(QAngle_1) end

---AppendToLogFile is deprecated. Print to the console for logging instead.
---@param string_1 string
---@param string_2 string
---@return void
function AppendToLogFile(string_1, string_2) end

---对一个单位造成伤害，输入tDamageTable: victim, attacker, damage, damage_type, damage_flags, ability
---@param tDamageTable handle
---@return float
function ApplyDamage(tDamageTable) end

---(vector,float) constructs a quaternion representing a rotation by angle around the specified vector axis
---@param Vector_1 Vector
---@param float_2 float
---@return Quaternion
function AxisAngleToQuaternion(Vector_1, float_2) end

---Compute the closest point on the OBB of an entity.
---@param handle_1 handle
---@param Vector_2 Vector
---@return Vector
function CalcClosestPointOnEntityOBB(handle_1, Vector_2) end

---计算两个实体间的OBB包围盒距离
---@param handle_1 handle
---@param handle_2 handle
---@return float
function CalcDistanceBetweenEntityOBB(handle_1, handle_2) end

---
---@param Vector_1 Vector
---@param Vector_2 Vector
---@param Vector_3 Vector
---@return float
function CalcDistanceToLineSegment2D(Vector_1, Vector_2, Vector_3) end

---Create all I/O events for a particular entity
---@param ehandle_1 ehandle
---@return void
function CancelEntityIOEvents(ehandle_1) end

---CenterCameraOnUnit( nPlayerId, hUnit ): Centers each players` camera on a unit.
---@param int_1 int
---@param handle_2 handle
---@return void
function CenterCameraOnUnit(int_1, handle_2) end

---( teamNumber )
---@param int_1 int
---@return void
function ClearTeamCustomHealthbarColor(int_1) end

---(hInflictor, hAttacker, flDamage) - Allocate a damageinfo object, used as an argument to TakeDamage(). Call DestroyDamageInfo( hInfo ) to free the object.
---@param handle_1 handle
---@param handle_2 handle
---@param Vector_3 Vector
---@param Vector_4 Vector
---@param float_5 float
---@param int_6 int
---@return handle
function CreateDamageInfo(handle_1, handle_2, Vector_3, Vector_4, float_5, int_6) end

---Pass table - Inputs: entity, effect
---@param handle_1 handle
---@return bool
function CreateEffect(handle_1) end

---Create an HTTP request.
---@param string_1 string
---@param string_2 string
---@return handle
function CreateHTTPRequest(string_1, string_2) end

---Create an HTTP request.
---@param string_1 string
---@param string_2 string
---@return handle
function CreateHTTPRequestScriptVM(string_1, string_2) end

---Creates a DOTA hero by its dota_npc_units.txt name and sets it as the given player`s controlled hero
---@param string_1 string
---@param handle_2 handle
---@return handle
function CreateHeroForPlayer(string_1, handle_2) end

---使用传入的数据创建属于传入单位的英雄幻象。 ( hOwner, hHeroToCopy, hModiiferKeys, nNumIllusions, nPadding, bScramblePosition, bFindClearSpace ) 可选参数：outgoing_damage, incoming_damage, bounty_base, bounty_growth, outgoing_damage_structure, outgoing_damage_roshan
---@param hOwner handle
---@param hHeroToCopy handle
---@param hModiiferKeys handle
---@param nNumIllusions int
---@param nPadding int
---@param bScramblePosition bool
---@param bFindClearSpace bool
---@return table
function CreateIllusions(hOwner, hHeroToCopy, hModiiferKeys, nNumIllusions, nPadding, bScramblePosition, bFindClearSpace) end

---创建一个物品
---@param sItemName string
---@param hOwner handle
---@param hOwner handle
---@return handle
function CreateItem(sItemName, hOwner, hOwner) end

---Create a physical item at a given location, can start in air (but doesn`t clear a space)
---@param Vector_1 Vector
---@param handle_2 handle
---@return handle
function CreateItemOnPositionForLaunch(Vector_1, handle_2) end

---Create a physical item at a given location
---@param Vector_1 Vector
---@param handle_2 handle
---@return handle
function CreateItemOnPositionSync(Vector_1, handle_2) end

---Create a modifier not associated with an NPC. ( hCaster, hAbility, modifierName, paramTable, vOrigin, nTeamNumber, bPhantomBlocker )
---@param hCaster handle
---@param hAbility handle
---@param sModifierName string
---@param tParamTable handle
---@param vPosition Vector
---@param iTeamNumber int
---@param bPhantomBlocker bool
---@return handle
function CreateModifierThinker(hCaster, hAbility, sModifierName, tParamTable, vPosition, iTeamNumber, bPhantomBlocker) end

---Create a rune of the specified type (vLocation, iRuneType).
---@param Vector_1 Vector
---@param int_2 int
---@return handle
function CreateRune(Vector_1, int_2) end

---Create a scene entity to play the specified scene.
---@param string_1 string
---@return handle
function CreateSceneEntity(string_1) end

---Create a temporary tree, uses a default tree model. (vLocation, flDuration).
---@param Vector_1 Vector
---@param float_2 float
---@return handle
function CreateTempTree(Vector_1, float_2) end

---Create a temporary tree, specifying the tree model name. (vLocation, flDuration, szModelName).
---@param Vector_1 Vector
---@param float_2 float
---@param string_3 string
---@return handle
function CreateTempTreeWithModel(Vector_1, float_2, string_3) end

---CreateTrigger( vecMin, vecMax ) : Creates and returns an AABB trigger
---@param Vector_1 Vector
---@param Vector_2 Vector
---@param Vector_3 Vector
---@return handle
function CreateTrigger(Vector_1, Vector_2, Vector_3) end

---CreateTriggerRadiusApproximate( vecOrigin, flRadius ) : Creates and returns an AABB trigger thats bigger than the radius provided
---@param Vector_1 Vector
---@param float_2 float
---@return handle
function CreateTriggerRadiusApproximate(Vector_1, float_2) end

---( iSeed ) - Creates a separate random number stream.
---@param int_1 int
---@return handle
function CreateUniformRandomStream(int_1) end

---创建一个单位
---@param sUnitName string
---@param vLocation Vector
---@param bFindClearSpace bool
---@param hNpcOwner handle
---@param hUnitOwner handle
---@param iTeamNumber int
---@return handle
function CreateUnitByName(sUnitName, vLocation, bFindClearSpace, hNpcOwner, hUnitOwner, iTeamNumber) end

---Creates a DOTA unit by its dota_npc_units.txt name
---@param string_1 string
---@param Vector_2 Vector
---@param bool_3 bool
---@param handle_4 handle
---@param handle_5 handle
---@param int_6 int
---@param handle_7 handle
---@return int
function CreateUnitByNameAsync(string_1, Vector_2, bool_3, handle_4, handle_5, int_6, handle_7) end

---Creates a DOTA unit by its dota_npc_units.txt name from a table of entity key values and a position to spawn at.
---@param handle_1 handle
---@param Vector_2 Vector
---@return handle
function CreateUnitFromTable(handle_1, Vector_2) end

---(vector,vector) cross product between two vectors
---@param Vector_1 Vector
---@param Vector_2 Vector
---@return Vector
function CrossVectors(Vector_1, Vector_2) end

---在指定位置生成一个加载一个地形(.vmap)。bTriggerCompletion为true时，需要手动ManuallyTriggerSpawnGroupCompletion来完成地形加载。vPosition必须是64的倍数，否则创建失败。函数返回一个SpawnGroup。可以通过UnloadSpawnGroupByHandle(hSpawnGroup)卸载地图。
---@param sMapName string
---@param vPosition Vector
---@param bTriggerCompletion bool
---@param hReady handle
---@param hComplete handle
---@param handle_6 handle
---@return int
function DOTA_SpawnMapAtPosition(sMapName, vPosition, bTriggerCompletion, hReady, hComplete, handle_6) end

---Breaks in the debugger
---@return void
function DebugBreak() end

---Creates a test unit controllable by the specified player.
---@param handle_1 handle
---@param string_2 string
---@param int_3 int
---@param bool_4 bool
---@param handle_5 handle
---@return int
function DebugCreateUnit(handle_1, string_2, int_3, bool_4, handle_5) end

---Draw a debug overlay box (origin, mins, maxs, forward, r, g, b, a, duration )
---@param Vector_1 Vector
---@param Vector_2 Vector
---@param Vector_3 Vector
---@param int_4 int
---@param int_5 int
---@param int_6 int
---@param int_7 int
---@param float_8 float
---@return void
function DebugDrawBox(Vector_1, Vector_2, Vector_3, int_4, int_5, int_6, int_7, float_8) end

---Draw a debug forward box (cent, min, max, forward, vRgb, a, duration)
---@param Vector_1 Vector
---@param Vector_2 Vector
---@param Vector_3 Vector
---@param Vector_4 Vector
---@param Vector_5 Vector
---@param float_6 float
---@param float_7 float
---@return void
function DebugDrawBoxDirection(Vector_1, Vector_2, Vector_3, Vector_4, Vector_5, float_6, float_7) end

---Draw a debug circle (center, vRgb, a, rad, ztest, duration)
---@param vCenter Vector
---@param vRGB Vector
---@param iAlpha float
---@param flRadius float
---@param bZtest bool
---@param flDuration float
---@return void
function DebugDrawCircle(vCenter, vRGB, iAlpha, flRadius, bZtest, flDuration) end

---Try to clear all the debug overlay info
---@return void
function DebugDrawClear() end

---Draw a debug overlay line (origin, target, r, g, b, ztest, duration)
---@param Vector_1 Vector
---@param Vector_2 Vector
---@param int_3 int
---@param int_4 int
---@param int_5 int
---@param bool_6 bool
---@param float_7 float
---@return void
function DebugDrawLine(Vector_1, Vector_2, int_3, int_4, int_5, bool_6, float_7) end

---Draw a debug line using color vec (start, end, vRgb, a, ztest, duration)
---@param Vector_1 Vector
---@param Vector_2 Vector
---@param Vector_3 Vector
---@param bool_4 bool
---@param float_5 float
---@return void
function DebugDrawLine_vCol(Vector_1, Vector_2, Vector_3, bool_4, float_5) end

---Draw text with a line offset (x, y, lineOffset, text, r, g, b, a, duration)
---@param float_1 float
---@param float_2 float
---@param int_3 int
---@param string_4 string
---@param int_5 int
---@param int_6 int
---@param int_7 int
---@param int_8 int
---@param float_9 float
---@return void
function DebugDrawScreenTextLine(float_1, float_2, int_3, string_4, int_5, int_6, int_7, int_8, float_9) end

---Draw a debug sphere (center, vRgb, a, rad, ztest, duration)
---@param Vector_1 Vector
---@param Vector_2 Vector
---@param float_3 float
---@param float_4 float
---@param bool_5 bool
---@param float_6 float
---@return void
function DebugDrawSphere(Vector_1, Vector_2, float_3, float_4, bool_5, float_6) end

---Draw text in 3d (origin, text, bViewCheck, duration)
---@param Vector_1 Vector
---@param string_2 string
---@param bool_3 bool
---@param float_4 float
---@return void
function DebugDrawText(Vector_1, string_2, bool_3, float_4) end

---Draw pretty debug text (x, y, lineOffset, text, r, g, b, a, duration, font, size, bBold)
---@param float_1 float
---@param float_2 float
---@param int_3 int
---@param string_4 string
---@param int_5 int
---@param int_6 int
---@param int_7 int
---@param int_8 int
---@param float_9 float
---@param string_10 string
---@param int_11 int
---@param bool_12 bool
---@return void
function DebugScreenTextPretty(float_1, float_2, int_3, string_4, int_5, int_6, int_7, int_8, float_9, string_10, int_11, bool_12) end

---Print out a class/array/instance/table to the console
---@param table undefined
---@param prefix undefined
---@return void
function DeepPrint(table, prefix) end

---打印表
---@param table undefined
---@param prefix undefined
---@param chaseMetaTables undefined
---@return void
function DeepPrintTable(table, prefix, chaseMetaTables) end

---Convert a class/array/instance/table to a string
---@param table undefined
---@param prefix undefined
---@return void
function DeepToString(table, prefix) end

---Free a damageinfo object that was created with CreateDamageInfo().
---@param handle_1 handle
---@return void
function DestroyDamageInfo(handle_1) end

---(hAttacker, hTarget, hAbility, fDamage, fRadius, effectName)
---@param handle_1 handle
---@param handle_2 handle
---@param handle_3 handle
---@param float_4 float
---@param float_5 float
---@param float_6 float
---@param float_7 float
---@param string_8 string
---@return int
function DoCleaveAttack(handle_1, handle_2, handle_3, float_4, float_5, float_6, float_7, string_8) end

---#EntFire:Generate and entity i/o event
---@param string_1 string
---@param string_2 string
---@param string_3 string
---@param float_4 float
---@param handle_5 handle
---@param handle_6 handle
---@return void
function DoEntFire(string_1, string_2, string_3, float_4, handle_5, handle_6) end

---#EntFireByHandle:Generate and entity i/o event
---@param handle_1 handle
---@param string_2 string
---@param string_3 string
---@param float_4 float
---@param handle_5 handle
---@param handle_6 handle
---@return void
function DoEntFireByInstanceHandle(handle_1, string_2, string_3, float_4, handle_5, handle_6) end

---Execute a script (internal)
---@param string_1 string
---@param handle_2 handle
---@return bool
function DoIncludeScript(string_1, handle_2) end

---#ScriptAssert:Asserts the passed in value. Prints out a message and brings up the assert dialog.
---@param bool_1 bool
---@param string_2 string
---@return void
function DoScriptAssert(bool_1, string_2) end

---#UniqueString:Generate a string guaranteed to be unique across the life of the script VM, with an optional root string. Useful for adding data to tables when not sure what keys are already in use in that table.
---@param string_1 string
---@return string
function DoUniqueString(string_1) end

---
---@param Vector_1 Vector
---@param Vector_2 Vector
---@return float
function DotProduct(Vector_1, Vector_2) end

---Drop a neutral item for the team of the hero at the given tier.
---@param string_1 string
---@param Vector_2 Vector
---@param handle_3 handle
---@param int_4 int
---@param bool_5 bool
---@return handle
function DropNeutralItemAtPositionForHero(string_1, Vector_2, handle_3, int_4, bool_5) end

---A function to re-lookup a function by name every time.
---@param table undefined
---@param sFuncName undefined
---@return void
function Dynamic_Wrap(table, sFuncName) end

---Emit an announcer sound for all players.
---@param string_1 string
---@return void
function EmitAnnouncerSound(string_1) end

---Emit an announcer sound for a player.
---@param string_1 string
---@param int_2 int
---@return void
function EmitAnnouncerSoundForPlayer(string_1, int_2) end

---Emit an announcer sound for a team.
---@param string_1 string
---@param int_2 int
---@return void
function EmitAnnouncerSoundForTeam(string_1, int_2) end

---Emit an announcer sound for a team at a specific location.
---@param string_1 string
---@param int_2 int
---@param Vector_3 Vector
---@return void
function EmitAnnouncerSoundForTeamOnLocation(string_1, int_2, Vector_3) end

---Play named sound for all players
---@param string_1 string
---@return void
function EmitGlobalSound(string_1) end

---Play named sound on Entity
---@param string_1 string
---@param handle_2 handle
---@return void
function EmitSoundOn(string_1, handle_2) end

---Play named sound only on the client for the passed in player
---@param string_1 string
---@param handle_2 handle
---@return void
function EmitSoundOnClient(string_1, handle_2) end

---Emit a sound on an entity for only a specific player
---@param string_1 string
---@param handle_2 handle
---@param int_3 int
---@return void
function EmitSoundOnEntityForPlayer(string_1, handle_2, int_3) end

---Emit a sound on a location from a unit, only for players allied with that unit (vLocation, soundName, hCaster
---@param Vector_1 Vector
---@param string_2 string
---@param handle_3 handle
---@return void
function EmitSoundOnLocationForAllies(Vector_1, string_2, handle_3) end

---Emit a sound on a location for only a specific player
---@param string_1 string
---@param Vector_2 Vector
---@param int_3 int
---@return void
function EmitSoundOnLocationForPlayer(string_1, Vector_2, int_3) end

---单位在指定位置播放音效。(vLocation, soundName, hCaster).
---@param vLocation Vector
---@param sSoundName string
---@param hUnit handle
---@return void
function EmitSoundOnLocationWithCaster(vLocation, sSoundName, hUnit) end

---Turn an entity index integer to an HScript representing that entity`s script instance.
---@param int_1 int
---@return handle
function EntIndexToHScript(int_1) end

---Issue an order from a script table
---@param handle_1 handle
---@return void
function ExecuteOrderFromTable(handle_1) end

---Smooth curve decreasing slower as it approaches zero
---@param float_1 float
---@param float_2 float
---@param float_3 float
---@return float
function ExponentialDecay(float_1, float_2, float_3) end

---Finds a clear random position around a given target unit, using the target unit`s padded collision radius.
---@param handle_1 handle
---@param handle_2 handle
---@param int_3 int
---@return bool
function FindClearRandomPositionAroundUnit(handle_1, handle_2, int_3) end

---把一个单位放在没有占用的位置。
---@param hUnit handle
---@param vLocation Vector
---@param bInterruptMotion bool
---@return bool
function FindClearSpaceForUnit(hUnit, vLocation, bInterruptMotion) end

---为给定的团队找到一个刷出点。
---@param int_1 int
---@return handle
function FindSpawnEntityForTeam(int_1) end

---找出与给定标记相交的单位。
---@param int_1 int
---@param Vector_2 Vector
---@param Vector_3 Vector
---@param handle_4 handle
---@param float_5 float
---@param int_6 int
---@param int_7 int
---@param int_8 int
---@return table
function FindUnitsInLine(int_1, Vector_2, Vector_3, handle_4, float_5, int_6, int_7, int_8) end

---查找给定半径内带有给定标志的单位。
---@param int_1 int
---@param Vector_2 Vector
---@param handle_3 handle
---@param float_4 float
---@param int_5 int
---@param int_6 int
---@param int_7 int
---@param int_8 int
---@param bool_9 bool
---@return table
function FindUnitsInRadius(int_1, Vector_2, handle_3, float_4, int_5, int_6, int_7, int_8, bool_9) end

---Fire Entity`s Action Input w/no data
---@param ehandle_1 ehandle
---@param string_2 string
---@return void
function FireEntityIOInputNameOnly(ehandle_1, string_2) end

---Fire Entity`s Action Input with passed String - you own the memory
---@param ehandle_1 ehandle
---@param string_2 string
---@param string_3 string
---@return void
function FireEntityIOInputString(ehandle_1, string_2, string_3) end

---Fire Entity`s Action Input with passed Vector - you own the memory
---@param ehandle_1 ehandle
---@param string_2 string
---@param Vector_3 Vector
---@return void
function FireEntityIOInputVec(ehandle_1, string_2, Vector_3) end

---Fire a game event.
---@param string_1 string
---@param handle_2 handle
---@return void
function FireGameEvent(string_1, handle_2) end

---Fire a game event without broadcasting to the client.
---@param string_1 string
---@param handle_2 handle
---@return void
function FireGameEventLocal(string_1, handle_2) end

---Get the time spent on the server in the last frame
---@return float
function FrameTime() end

---Get ability data by ability name.
---@param string_1 string
---@return table
function GetAbilityKeyValuesByName(string_1) end

---Gets the ability texture name for an ability
---@param string_1 string
---@return string
function GetAbilityTextureNameForAbility(string_1) end

---Returns the currently active spawn group handle
---@return int
function GetActiveSpawnGroupHandle() end

---( version )
---@param string_1 string
---@return string
function GetDedicatedServerKey(string_1) end

---( version )
---@param string_1 string
---@return string
function GetDedicatedServerKeyV2(string_1) end

---Get the enity index for a tree id specified as the entindex_target of a DOTA_UNIT_ORDER_CAST_TARGET_TREE.
---@param unsigned_1 unsigned
---@return unknown
function GetEntityIndexForTreeId(unsigned_1) end

---Returns the engines current frame count
---@return int
function GetFrameCount() end

---
---@param Vector_1 Vector
---@param handle_2 handle
---@return float
function GetGroundHeight(Vector_1, handle_2) end

---Returns the supplied position moved to the ground. Second parameter is an NPC for measuring movement collision hull offset.
---@param Vector_1 Vector
---@param handle_2 handle
---@return Vector
function GetGroundPosition(Vector_1, handle_2) end

---Get the cost of an item by name.
---@param string_1 string
---@return int
function GetItemCost(string_1) end

---
---@param int_1 int
---@param int_2 int
---@return int
function GetItemDefOwnedCount(int_1, int_2) end

---
---@param int_1 int
---@param int_2 int
---@return int
function GetItemDefQuantity(int_1, int_2) end

---Get the local player on a listen server.
---@return handle
function GetListenServerHost() end

---( )
---@return table
function GetLobbyEventGameDetails() end

---Get the local player ID.
---@return int
function undefined:GetLocalPlayerID() end

---Get the local player team.
---@return int
function undefined:GetLocalPlayerTeam() end

---Get the name of the map.
---@return string
function GetMapName() end

---Get the longest delay for all events attached to an output
---@param ehandle_1 ehandle
---@param string_2 string
---@return float
function GetMaxOutputDelay(ehandle_1, string_2) end

---Get Angular Velocity for VPHYS or normal object. Returns a vector of the axis of rotation, multiplied by the degrees of rotation per second.
---@param handle_1 handle
---@return Vector
function GetPhysAngularVelocity(handle_1) end

---Get Velocity for VPHYS or normal object
---@param handle_1 handle
---@return Vector
function GetPhysVelocity(handle_1) end

---Given the item tier and the team, roll for the name of a valid neutral item drop, considering previous drops and consumables.
---@param int_1 int
---@param int_2 int
---@return string
function GetPotentialNeutralItemDrop(int_1, int_2) end

---Get the current real world date
---@return string
function GetSystemDate() end

---Get the current real world time
---@return string
function GetSystemTime() end

---Get system time in milliseconds
---@return double
function GetSystemTimeMS() end

---
---@param int_1 int
---@param int_2 int
---@param int_3 int
---@param Vector_4 Vector
---@param int_5 int
---@param int_6 int
---@param int_7 int
---@return Vector
function GetTargetAOELocation(int_1, int_2, int_3, Vector_4, int_5, int_6, int_7) end

---
---@param int_1 int
---@param int_2 int
---@param int_3 int
---@param Vector_4 Vector
---@param int_5 int
---@param int_6 int
---@param int_7 int
---@return Vector
function GetTargetLinearLocation(int_1, int_2, int_3, Vector_4, int_5, int_6, int_7) end

---( int teamID )
---@param int_1 int
---@return int
function GetTeamHeroKills(int_1) end

---( int teamID )
---@param int_1 int
---@return string
function GetTeamName(int_1) end

---Given and entity index of a tree, get the tree id for use for use with with unit orders.
---@param int_1 int
---@return int
function GetTreeIdForEntityIndex(int_1) end

---Gets the world`s maximum X position.
---@return float
function GetWorldMaxX() end

---Gets the world`s maximum Y position.
---@return float
function GetWorldMaxY() end

---Gets the world`s minimum X position.
---@return float
function GetWorldMinX() end

---Gets the world`s minimum Y position.
---@return float
function GetWorldMinY() end

---Get amount of XP required to reach the next level.
---@param int_1 int
---@return int
function GetXPNeededToReachNextLevel(int_1) end

---InitLogFile is deprecated. Print to the console for logging instead.
---@param string_1 string
---@param string_2 string
---@return void
function InitLogFile(string_1, string_2) end

---Returns true if this is lua running from the client.dll.
---@return bool
function IsClient() end

---Returns true if this server is a dedicated server.
---@return bool
function IsDedicatedServer() end

---Returns true if this is lua running within tools mode.
---@return bool
function IsInToolsMode() end

---判断某个位置对某个队伍是否在战争迷雾中
---@param iTeamNumber int
---@param vLocation Vector
---@return bool
function IsLocationVisible(iTeamNumber, vLocation) end

---Is this entity a mango tree? (hEntity).
---@param handle_1 handle
---@return bool
function IsMangoTree(handle_1) end

---Returns true if the entity is valid and marked for deletion.
---@param handle_1 handle
---@return bool
function IsMarkedForDeletion(handle_1) end

---Returns true if this is lua running from the server.dll.
---@return bool
function IsServer() end

---Returns true if the unit is in a valid position in the gridnav.
---@param handle_1 handle
---@return bool
function IsUnitInValidPosition(handle_1) end

---Checks to see if the given hScript is a valid entity
---@param handle_1 handle
---@return bool
function IsValidEntity(handle_1) end

---(vector,vector,float) lerp between two vectors by a float factor returning new vector
---@param Vector_1 Vector
---@param Vector_2 Vector
---@param float_3 float
---@return Vector
function LerpVectors(Vector_1, Vector_2, float_3) end

---Set the limit on the pathfinding search space.
---@param float_1 float
---@return void
function LimitPathingSearchDepth(float_1) end

---Link a lua-defined modifier with the associated class ( className, fileName, LuaModifierType).
---@param string_1 string
---@param string_2 string
---@param int_3 int
---@return void
function LinkLuaModifier(string_1, string_2, int_3) end

---Register as a listener for a game event from script.
---@param string_1 string
---@param handle_2 handle
---@param handle_3 handle
---@return int
function ListenToGameEvent(string_1, handle_2, handle_3) end

---Creates a table from the specified keyvalues text file
---@param string_1 string
---@return table
function LoadKeyValues(string_1) end

---Creates a table from the specified keyvalues string
---@param string_1 string
---@return table
function LoadKeyValuesFromString(string_1) end

---Get the current local time
---@return table
function LocalTime() end

---Checks to see if the given hScript is a valid entity
---@param string_1 string
---@return int
function MakeStringToken(string_1) end

---Triggers the creation of entities in a manually-completed spawn group
---@param int_1 int
---@return void
function ManuallyTriggerSpawnGroupCompletion(int_1) end

---Start a minimap event. (nTeamID, hEntity, nXCoord, nYCoord, nEventType, nEventDuration).
---@param int_1 int
---@param handle_2 handle
---@param int_3 int
---@param int_4 int
---@param int_5 int
---@param int_6 int
---@return void
function MinimapEvent(int_1, handle_2, int_3, int_4, int_5, int_6) end

---Print a message
---@param string_1 string
---@return void
function Msg(string_1) end

---Pause or unpause the game.
---@param bool_1 bool
---@return void
function PauseGame(bool_1) end

---Get a script instance of a player by index.
---@param int_1 int
---@return handle
function PlayerInstanceFromIndex(int_1) end

---Precache an entity from KeyValues in table
---@param string_1 string
---@param handle_2 handle
---@param handle_3 handle
---@return void
function PrecacheEntityFromTable(string_1, handle_2, handle_3) end

---Precache a list of entity KeyValues tables
---@param handle_1 handle
---@param handle_2 handle
---@return void
function PrecacheEntityListFromTable(handle_1, handle_2) end

---Asynchronously precaches a DOTA item by its dota_npc_items.txt name, provides a callback when it`s finished.
---@param string_1 string
---@param handle_2 handle
---@return void
function PrecacheItemByNameAsync(string_1, handle_2) end

---Precaches a DOTA item by its dota_npc_items.txt name
---@param string_1 string
---@param handle_2 handle
---@return void
function PrecacheItemByNameSync(string_1, handle_2) end

---( modelName, context ) - Manually precache a single model
---@param string_1 string
---@param handle_2 handle
---@return void
function PrecacheModel(string_1, handle_2) end

---手动预载某个资源，model_folder|sound|soundfile|particle|particle_folder
---@param sType string
---@param sPath string
---@param context handle
---@return void
function PrecacheResource(sType, sPath, context) end

---Asynchronously precaches a DOTA unit by its dota_npc_units.txt name, provides a callback when it`s finished.
---@param string_1 string
---@param handle_2 handle
---@param int_3 int
---@return void
function PrecacheUnitByNameAsync(string_1, handle_2, int_3) end

---Precaches a DOTA unit by its dota_npc_units.txt name
---@param string_1 string
---@param handle_2 handle
---@param int_3 int
---@return void
function PrecacheUnitByNameSync(string_1, handle_2, int_3) end

---Precaches a DOTA unit from a table of entity key values.
---@param handle_1 handle
---@param handle_2 handle
---@return void
function PrecacheUnitFromTableAsync(handle_1, handle_2) end

---Precaches a DOTA unit from a table of entity key values.
---@param handle_1 handle
---@param handle_2 handle
---@return void
function PrecacheUnitFromTableSync(handle_1, handle_2) end

---Print a console message with a linked console command
---@param string_1 string
---@param string_2 string
---@return void
function PrintLinkedConsoleMessage(string_1, string_2) end

---Get a random float within a range
---@param float_1 float
---@param float_2 float
---@return float
function RandomFloat(float_1, float_2) end

---Get a random int within a range
---@param int_1 int
---@param int_2 int
---@return int
function RandomInt(int_1, int_2) end

---Get a random 2D vector of the given length.
---@param float_1 float
---@return Vector
function RandomVector(float_1) end

---Register a custom animation script to run when a model loads
---@param string_1 string
---@param string_2 string
---@return void
function RegisterCustomAnimationScriptForModel(string_1, string_2) end

---Create a C proxy for a script-based spawn group filter
---@param string_1 string
---@return void
function RegisterSpawnGroupFilterProxy(string_1) end

---Reloads the MotD file
---@return void
function ReloadMOTD() end

---将传入值从范围[a, b]映射到范围[c, d]。并且将返回值限制在范围[c, d]。
---@param input float
---@param a float
---@param b float
---@param c float
---@param d float
---@return float
function RemapValClamped(input, a, b, c, d) end

---Remove temporary vision for a given team ( nTeamID, nViewerID )
---@param int_1 int
---@param int_2 int
---@return void
function RemoveFOWViewer(int_1, int_2) end

---Remove the C proxy for a script-based spawn group filter
---@param string_1 string
---@return void
function RemoveSpawnGroupFilterProxy(string_1) end

---Check and fix units that have been assigned a position inside collision radius of other NPCs.
---@param Vector_1 Vector
---@param float_2 float
---@return void
function ResolveNPCPositions(Vector_1, float_2) end

---(int nPct)
---@param int_1 int
---@return bool
function RollPercentage(int_1) end

---使用伪随机算法进行随机
---@param flChance unsigned
---@param iPseudoRandomID int
---@param hUnit handle
---@return bool
function RollPseudoRandomPercentage(flChance, iPseudoRandomID, hUnit) end

---Rotate a QAngle by another QAngle.
---@param QAngle_1 QAngle
---@param QAngle_2 QAngle
---@return QAngle
function RotateOrientation(QAngle_1, QAngle_2) end

---向量绕着中心点旋转
---@param vCenter Vector
---@param QAngle QAngle
---@param vPosition Vector
---@return Vector
function RotatePosition(vCenter, QAngle, vPosition) end

---(quaternion,vector,float) rotates a quaternion by the specified angle around the specified vector axis
---@param Quaternion_1 Quaternion
---@param Vector_2 Vector
---@param float_3 float
---@return Quaternion
function RotateQuaternionByAxisAngle(Quaternion_1, Vector_2, float_3) end

---Find the delta between two QAngles.
---@param QAngle_1 QAngle
---@param QAngle_2 QAngle
---@return QAngle
function RotationDelta(QAngle_1, QAngle_2) end

---converts delta QAngle to an angular velocity Vector
---@param QAngle_1 QAngle
---@param QAngle_2 QAngle
---@return Vector
function RotationDeltaAsAngularVelocity(QAngle_1, QAngle_2) end

---Have Entity say string, and teamOnly or not
---@param handle_1 handle
---@param string_2 string
---@param bool_3 bool
---@return void
function Say(handle_1, string_2, bool_3) end

---Start a screenshake with the following parameters. vecCenter, flAmplitude, flFrequency, flDuration, flRadius, eCommand( SHAKE_START = 0, SHAKE_STOP = 1 ), bAirShake
---@param Vector_1 Vector
---@param float_2 float
---@param float_3 float
---@param float_4 float
---@param float_5 float
---@param int_6 int
---@param bool_7 bool
---@return void
function ScreenShake(Vector_1, float_2, float_3, float_4, float_5, int_6, bool_7) end

---( DOTAPlayer sendToPlayer, int iMessageType, Entity targetEntity, int iValue, DOTAPlayer sourcePlayer ) - sendToPlayer and sourcePlayer can be nil - iMessageType is one of OVERHEAD_ALERT_*
---@param handle_1 handle
---@param int_2 int
---@param handle_3 handle
---@param int_4 int
---@param handle_5 handle
---@return void
function SendOverheadEventMessage(handle_1, int_2, handle_3, int_4, handle_5) end

---Send a string to the console as a client command
---@param string_1 string
---@return void
function SendToConsole(string_1) end

---Send a string to the console as a server command
---@param string_1 string
---@return void
function SendToServerConsole(string_1) end

---Sets an opvar value for all players
---@param string_1 string
---@param string_2 string
---@param string_3 string
---@param float_4 float
---@return void
function SetOpvarFloatAll(string_1, string_2, string_3, float_4) end

---Sets an opvar value for a single player
---@param string_1 string
---@param string_2 string
---@param string_3 string
---@param float_4 float
---@param handle_5 handle
---@return void
function SetOpvarFloatPlayer(string_1, string_2, string_3, float_4, handle_5) end

---Set Angular Velocity for VPHYS or normal object, from a vector of the axis of rotation, multiplied by the degrees of rotation per second.
---@param handle_1 handle
---@param Vector_2 Vector
---@return void
function SetPhysAngularVelocity(handle_1, Vector_2) end

---Set the current quest name.
---@param string_1 string
---@return void
function SetQuestName(string_1) end

---Set the current quest phase.
---@param int_1 int
---@return void
function SetQuestPhase(int_1) end

---Set rendering on/off for an ehandle
---@param ehandle_1 ehandle
---@param bool_2 bool
---@return void
function SetRenderingEnabled(ehandle_1, bool_2) end

---( teamNumber, r, g, b )
---@param int_1 int
---@param int_2 int
---@param int_3 int
---@param int_4 int
---@return void
function SetTeamCustomHealthbarColor(int_1, int_2, int_3, int_4) end

---( const char *pszMessage, int nPlayerID, int nValue, float flTime ) - Supports localized strings - %s1 = PlayerName, %s2 = Value, %s3 = TeamName
---@param string_1 string
---@param int_2 int
---@param int_3 int
---@param float_4 float
---@return void
function ShowCustomHeaderMessage(string_1, int_2, int_3, float_4) end

---Show a generic popup dialog for all players.
---@param string_1 string
---@param string_2 string
---@param string_3 string
---@param string_4 string
---@param int_5 int
---@return void
function ShowGenericPopup(string_1, string_2, string_3, string_4, int_5) end

---Show a generic popup dialog to a specific player.
---@param handle_1 handle
---@param string_2 string
---@param string_3 string
---@param string_4 string
---@param string_5 string
---@param int_6 int
---@return void
function ShowGenericPopupToPlayer(handle_1, string_2, string_3, string_4, string_5, int_6) end

---Print a hud message on all clients
---@param string_1 string
---@return void
function ShowMessage(string_1) end

---(Vector vOrigin, float flRadius )
---@param Vector_1 Vector
---@param float_2 float
---@return handle
function SpawnDOTAShopTriggerRadiusApproximate(Vector_1, float_2) end

---Asynchronously spawns a single entity from a table
---@param string_1 string
---@param handle_2 handle
---@param handle_3 handle
---@param handle_4 handle
---@return void
function SpawnEntityFromTableAsynchronous(string_1, handle_2, handle_3, handle_4) end

---Synchronously spawns a single entity from a table
---@param string_1 string
---@param handle_2 handle
---@return handle
function SpawnEntityFromTableSynchronous(string_1, handle_2) end

---Hierarchically spawn an entity group from a set of spawn tables.
---@param handle_1 handle
---@param bool_2 bool
---@param handle_3 handle
---@return bool
function SpawnEntityGroupFromTable(handle_1, bool_2, handle_3) end

---Asynchronously spawn an entity group from a list of spawn tables. A callback will be triggered when the spawning is complete
---@param handle_1 handle
---@param handle_2 handle
---@return int
function SpawnEntityListFromTableAsynchronous(handle_1, handle_2) end

---Synchronously spawn an entity group from a list of spawn tables.
---@param handle_1 handle
---@return handle
function SpawnEntityListFromTableSynchronous(handle_1) end

---(quaternion,quaternion,float) very basic interpolation of v0 to v1 over t on [0,1]
---@param Quaternion_1 Quaternion
---@param Quaternion_2 Quaternion
---@param float_3 float
---@return Quaternion
function SplineQuaternions(Quaternion_1, Quaternion_2, float_3) end

---(vector,vector,float) very basic interpolation of v0 to v1 over t on [0,1]
---@param Vector_1 Vector
---@param Vector_2 Vector
---@param float_3 float
---@return Vector
function SplineVectors(Vector_1, Vector_2, float_3) end

---Start a sound event
---@param string_1 string
---@param handle_2 handle
---@return void
function StartSoundEvent(string_1, handle_2) end

---Start a sound event from position
---@param string_1 string
---@param Vector_2 Vector
---@return void
function StartSoundEventFromPosition(string_1, Vector_2) end

---Start a sound event from position with reliable delivery
---@param string_1 string
---@param Vector_2 Vector
---@return void
function StartSoundEventFromPositionReliable(string_1, Vector_2) end

---Start a sound event from position with optional delivery
---@param string_1 string
---@param Vector_2 Vector
---@return void
function StartSoundEventFromPositionUnreliable(string_1, Vector_2) end

---Start a sound event with reliable delivery
---@param string_1 string
---@param handle_2 handle
---@return void
function StartSoundEventReliable(string_1, handle_2) end

---Start a sound event with optional delivery
---@param string_1 string
---@param handle_2 handle
---@return void
function StartSoundEventUnreliable(string_1, handle_2) end

---Pass entity and effect name
---@param handle_1 handle
---@param string_2 string
---@return void
function StopEffect(handle_1, string_2) end

---Stop named sound for all players
---@param string_1 string
---@return void
function StopGlobalSound(string_1) end

---Stop listening to all game events within a specific context.
---@param handle_1 handle
---@return void
function StopListeningToAllGameEvents(handle_1) end

---Stop listening to a particular game event.
---@param int_1 int
---@return bool
function StopListeningToGameEvent(int_1) end

---Stops a sound event with optional delivery
---@param string_1 string
---@param handle_2 handle
---@return void
function StopSoundEvent(string_1, handle_2) end

---Stop named sound on Entity
---@param string_1 string
---@param handle_2 handle
---@return void
function StopSoundOn(string_1, handle_2) end

---Get the current server time
---@return float
function Time() end

---Pass table - Inputs: start, end, ent, (optional mins, maxs) -- outputs: pos, fraction, hit, startsolid, normal
---@param handle_1 handle
---@return bool
function TraceCollideable(handle_1) end

---Pass table - Inputs: start, end, min, max, mask, ignore  -- outputs: pos, fraction, hit, enthit, startsolid
---@param handle_1 handle
---@return bool
function TraceHull(handle_1) end

---Pass table - Inputs: startpos, endpos, mask, ignore  -- outputs: pos, fraction, hit, enthit, startsolid
---@param handle_1 handle
---@return bool
function TraceLine(handle_1) end

---Sends colored text to one client.
---@param int_1 int
---@param string_2 string
---@param int_3 int
---@param int_4 int
---@param int_5 int
---@param int_6 int
---@return void
function UTIL_MessageText(int_1, string_2, int_3, int_4, int_5, int_6) end

---Sends colored text to all clients.
---@param string_1 string
---@param int_2 int
---@param int_3 int
---@param int_4 int
---@param int_5 int
---@return void
function UTIL_MessageTextAll(string_1, int_2, int_3, int_4, int_5) end

---Sends colored text to all clients. (Valid context keys: player_id, value, team_id)
---@param string_1 string
---@param int_2 int
---@param int_3 int
---@param int_4 int
---@param int_5 int
---@param handle_6 handle
---@return void
function UTIL_MessageTextAll_WithContext(string_1, int_2, int_3, int_4, int_5, handle_6) end

---Sends colored text to one client. (Valid context keys: player_id, value, team_id)
---@param int_1 int
---@param string_2 string
---@param int_3 int
---@param int_4 int
---@param int_5 int
---@param int_6 int
---@param handle_7 handle
---@return void
function UTIL_MessageText_WithContext(int_1, string_2, int_3, int_4, int_5, int_6, handle_7) end

---Removes the specified entity
---@param handle_1 handle
---@return void
function UTIL_Remove(handle_1) end

---Immediately removes the specified entity
---@param handle_1 handle
---@return void
function UTIL_RemoveImmediate(handle_1) end

---Clear all message text on one client.
---@param int_1 int
---@return void
function UTIL_ResetMessageText(int_1) end

---Clear all message text from all clients.
---@return void
function UTIL_ResetMessageTextAll() end

---Check if a unit passes a set of filters. (hNPC, nTargetTeam, nTargetType, nTargetFlags, nTeam
---@param handle_1 handle
---@param int_2 int
---@param int_3 int
---@param int_4 int
---@param int_5 int
---@return int
function UnitFilter(handle_1, int_2, int_3, int_4, int_5) end

---Unload a spawn group by name
---@param string_1 string
---@return void
function UnloadSpawnGroup(string_1) end

---Unload a spawn group by handle
---@param int_1 int
---@return void
function UnloadSpawnGroupByHandle(int_1) end

---( hEventPointData )
---@param handle_1 handle
---@return void
function UpdateEventPoints(handle_1) end

---
---@param Vector_1 Vector
---@return QAngle
function VectorAngles(Vector_1) end

---Get Qangles (with no roll) for a Vector.
---@param Vector_1 Vector
---@return QAngle
function VectorToAngles(Vector_1) end

---Print a warning
---@param string_1 string
---@return void
function Warning(string_1) end

---Gets the value of the given cvar, as a float.
---@param string_1 string
---@return float
function cvar_getf(string_1) end

---Sets the value of the given cvar, as a float.
---@param string_1 string
---@param float_2 float
---@return bool
function cvar_setf(string_1, float_2) end

---Add a rule to the decision database.
---@param handle_1 handle
---@return bool
function rr_AddDecisionRule(handle_1) end

---Commit the result of QueryBestResponse back to the given entity to play. Call with params (entity, airesponse)
---@param handle_1 handle
---@param handle_2 handle
---@return bool
function rr_CommitAIResponse(handle_1, handle_2) end

---Retrieve a table of all available expresser targets, in the form { name : handle, name: handle }.
---@return handle
function rr_GetResponseTargets() end

---Params: (entity, query) : tests `query` against entity`s response system and returns the best response found (or null if none found).
---@param handle_1 handle
---@param handle_2 handle
---@param handle_3 handle
---@return bool
function rr_QueryBestResponse(handle_1, handle_2, handle_3) end

---@class CBaseAnimating : CBaseModelEntity
---Returns the duration in seconds of the active sequence.
---@return float
function CBaseAnimating:ActiveSequenceDuration() end

---Get the cycle of the animation.
---@return float
function CBaseAnimating:GetCycle() end

---Get the value of the given animGraph parameter
---@param pszParam string
---@return table
function CBaseAnimating:GetGraphParameter(pszParam) end

---Returns the name of the active sequence.
---@return string
function CBaseAnimating:GetSequence() end

---Ask whether the main sequence is done playing.
---@return bool
function CBaseAnimating:IsSequenceFinished() end

---Sets the active sequence by name, resetting the current cycle.
---@param pSequenceName string
---@return void
function CBaseAnimating:ResetSequence(pSequenceName) end

---Returns the duration in seconds of the given sequence name.
---@param pSequenceName string
---@return float
function CBaseAnimating:SequenceDuration(pSequenceName) end

---Set the cycle of the animation.
---@param flCycle float
---@return void
function CBaseAnimating:SetCycle(flCycle) end

---Pass the desired look target in world space to the graph
---@param vValue Vector
---@return void
function CBaseAnimating:SetGraphLookTarget(vValue) end

---Set the specific param value, type is inferred from the type in script
---@param pszParam string
---@param svArg table
---@return void
function CBaseAnimating:SetGraphParameter(pszParam, svArg) end

---Set the specific param on or off
---@param szName string
---@param bValue bool
---@return void
function CBaseAnimating:SetGraphParameterBool(szName, bValue) end

---Pass the enum (int) value to the specified param
---@param szName string
---@param nValue int
---@return void
function CBaseAnimating:SetGraphParameterEnum(szName, nValue) end

---Pass the float value to the specified param
---@param szName string
---@param flValue float
---@return void
function CBaseAnimating:SetGraphParameterFloat(szName, flValue) end

---Pass the int value to the specified param
---@param szName string
---@param nValue int
---@return void
function CBaseAnimating:SetGraphParameterInt(szName, nValue) end

---Pass the vector value to the specified param in the graph
---@param szName string
---@param vValue Vector
---@return void
function CBaseAnimating:SetGraphParameterVector(szName, vValue) end

---Set the specified pose parameter to the specified value.
---@param szName string
---@param fValue float
---@return float
function CBaseAnimating:SetPoseParameter(szName, fValue) end

---Sets the active sequence by name, keeping the current cycle.
---@param pSequenceName string
---@return void
function CBaseAnimating:SetSequence(pSequenceName) end

---Stop the current animation by setting playback rate to 0.0.
---@return void
function CBaseAnimating:StopAnimation() end

---@class CBaseEntity : CEntityInstance
---AddEffects( int ): Adds the render effect flag.
---@param nFlags int
---@return void
function CBaseEntity:AddEffects(nFlags) end

---Apply a Velocity Impulse
---@param vecImpulse Vector
---@return void
function CBaseEntity:ApplyAbsVelocityImpulse(vecImpulse) end

---Apply an Ang Velocity Impulse
---@param angImpulse Vector
---@return void
function CBaseEntity:ApplyLocalAngularVelocityImpulse(angImpulse) end

---Get float value for an entity attribute.
---@param pName string
---@param flDefault float
---@return float
function CBaseEntity:Attribute_GetFloatValue(pName, flDefault) end

---Get int value for an entity attribute.
---@param pName string
---@param nDefault int
---@return int
function CBaseEntity:Attribute_GetIntValue(pName, nDefault) end

---Set float value for an entity attribute.
---@param pName string
---@param flValue float
---@return void
function CBaseEntity:Attribute_SetFloatValue(pName, flValue) end

---Set int value for an entity attribute.
---@param pName string
---@param nValue int
---@return void
function CBaseEntity:Attribute_SetIntValue(pName, nValue) end

---Delete an entity attribute.
---@param pName string
---@return void
function CBaseEntity:DeleteAttribute(pName) end

---Plays a sound from this entity.
---@param soundname string
---@return void
function CBaseEntity:EmitSound(soundname) end

---Plays/modifies a sound from this entity. changes sound if nPitch and/or flVol or flSoundTime is > 0.
---@param soundname string
---@param nPitch int
---@param flVolume float
---@param flDelay float
---@return void
function CBaseEntity:EmitSoundParams(soundname, nPitch, flVolume, flDelay) end

---Get the qangles that this entity is looking at.
---@return QAngle
function CBaseEntity:EyeAngles() end

---Get vector to eye position - absolute coords.
---@return Vector
function CBaseEntity:EyePosition() end

---
---@return handle
function CBaseEntity:FirstMoveChild() end

---hEntity to follow, bool bBoneMerge
---@param hEnt handle
---@param bBoneMerge bool
---@return void
function CBaseEntity:FollowEntity(hEnt, bBoneMerge) end

---Returns a table containing the criteria that would be used for response queries on this entity. This is the same as the table that is passed to response rule script function callbacks.
---@param hResult handle
---@return void
function CBaseEntity:GatherCriteria(hResult) end

---获取单位绝对位置坐标
---@return Vector
function CBaseEntity:GetAbsOrigin() end

---
---@return float
function CBaseEntity:GetAbsScale() end

---
---@return QAngle
function CBaseEntity:GetAngles() end

---Get entity pitch, yaw, roll as a vector.
---@return Vector
function CBaseEntity:GetAnglesAsVector() end

---Get the local angular velocity - returns a vector of pitch,yaw,roll
---@return Vector
function CBaseEntity:GetAngularVelocity() end

---Get Base? velocity.
---@return Vector
function CBaseEntity:GetBaseVelocity() end

---Get a vector containing max bounds, centered on object.
---@return Vector
function CBaseEntity:GetBoundingMaxs() end

---Get a vector containing min bounds, centered on object.
---@return Vector
function CBaseEntity:GetBoundingMins() end

---Get a table containing the `Mins` & `Maxs` vector bounds, centered on object.
---@return table
function CBaseEntity:GetBounds() end

---Get vector to center of object - absolute coords
---@return Vector
function CBaseEntity:GetCenter() end

---Get the entities parented to this entity.
---@return handle
function CBaseEntity:GetChildren() end

---GetContext( name ): looks up a context and returns it if available. May return string, float, or null (if the context isn`t found).
---@param name string
---@return table
function CBaseEntity:GetContext(name) end

---得到实体的前向向量。
---@return Vector
function CBaseEntity:GetForwardVector() end

---Get the health of this entity.
---@return int
function CBaseEntity:GetHealth() end

---Get entity local pitch, yaw, roll as a QAngle
---@return QAngle
function CBaseEntity:GetLocalAngles() end

---Maybe local angvel
---@return QAngle
function CBaseEntity:GetLocalAngularVelocity() end

---Get entity local origin as a Vector
---@return Vector
function CBaseEntity:GetLocalOrigin() end

---
---@return float
function CBaseEntity:GetLocalScale() end

---Get Entity relative velocity.
---@return Vector
function CBaseEntity:GetLocalVelocity() end

---Get the mass of an entity. (returns 0 if it doesn`t have a physics object)
---@return float
function CBaseEntity:GetMass() end

---Get the maximum health of this entity.
---@return int
function CBaseEntity:GetMaxHealth() end

---Returns the name of the model.
---@return string
function CBaseEntity:GetModelName() end

---If in hierarchy, retrieves the entity`s parent.
---@return handle
function CBaseEntity:GetMoveParent() end

---
---@return Vector
function CBaseEntity:GetOrigin() end

---Gets this entity`s owner
---@return handle
function CBaseEntity:GetOwner() end

---Get the owner entity, if there is one
---@return handle
function CBaseEntity:GetOwnerEntity() end

---Get the right vector of the entity.
---@return Vector
function CBaseEntity:GetRightVector() end

---If in hierarchy, walks up the hierarchy to find the root parent.
---@return handle
function CBaseEntity:GetRootMoveParent() end

---Returns float duration of the sound. Takes soundname and optional actormodelname.
---@param soundname string
---@param actormodel string
---@return float
function CBaseEntity:GetSoundDuration(soundname, actormodel) end

---Returns the spawn group handle of this entity
---@return int
function CBaseEntity:GetSpawnGroupHandle() end

---Get the team number of this entity.
---@return int
function CBaseEntity:GetTeam() end

---Get the team number of this entity.
---@return int
function CBaseEntity:GetTeamNumber() end

---Get the up vector of the entity.
---@return Vector
function CBaseEntity:GetUpVector() end

---
---@return Vector
function CBaseEntity:GetVelocity() end

---See if an entity has a particular attribute.
---@param pName string
---@return bool
function CBaseEntity:HasAttribute(pName) end

---Is this entity alive?
---@return bool
function CBaseEntity:IsAlive() end

---Is this entity an CAI_BaseNPC?
---@return bool
function CBaseEntity:IsNPC() end

---Is this entity a player?
---@return bool
function CBaseEntity:IsPlayer() end

---
---@return void
function CBaseEntity:Kill() end

---
---@return handle
function CBaseEntity:NextMovePeer() end

---Takes duration, value for a temporary override.
---@param duration float
---@param friction float
---@return void
function CBaseEntity:OverrideFriction(duration, friction) end

---Precache a sound for later playing.
---@param soundname string
---@return void
function CBaseEntity:PrecacheScriptSound(soundname) end

---RemoveEffects( int ): Removes the render effect flag.
---@param nFlags int
---@return void
function CBaseEntity:RemoveEffects(nFlags) end

---Set entity pitch, yaw, roll by component.
---@param fPitch float
---@param fYaw float
---@param fRoll float
---@return void
function CBaseEntity:SetAbsAngles(fPitch, fYaw, fRoll) end

---
---@param origin Vector
---@return void
function CBaseEntity:SetAbsOrigin(origin) end

---
---@param flScale float
---@return void
function CBaseEntity:SetAbsScale(flScale) end

---Set entity pitch, yaw, roll by component.
---@param fPitch float
---@param fYaw float
---@param fRoll float
---@return void
function CBaseEntity:SetAngles(fPitch, fYaw, fRoll) end

---Set the local angular velocity - takes float pitch,yaw,roll velocities
---@param pitchVel float
---@param yawVel float
---@param rollVel float
---@return void
function CBaseEntity:SetAngularVelocity(pitchVel, yawVel, rollVel) end

---Set the position of the constraint.
---@param vPos Vector
---@return void
function CBaseEntity:SetConstraint(vPos) end

---SetContext( name , value, duration ): store any key/value pair in this entity`s dialog contexts. Value must be a string. Will last for duration (set 0 to mean `forever`).
---@param pName string
---@param pValue string
---@param duration float
---@return void
function CBaseEntity:SetContext(pName, pValue, duration) end

---SetContextNum( name , value, duration ): store any key/value pair in this entity`s dialog contexts. Value must be a number (int or float). Will last for duration (set 0 to mean `forever`).
---@param pName string
---@param fValue float
---@param duration float
---@return void
function CBaseEntity:SetContextNum(pName, fValue, duration) end

---Set a think function on this entity.
---@param pszContextName string
---@param hThinkFunc handle
---@param flInterval float
---@return void
function CBaseEntity:SetContextThink(pszContextName, hThinkFunc, flInterval) end

---Set the name of an entity.
---@param pName string
---@return void
function CBaseEntity:SetEntityName(pName) end

---Set the orientation of the entity to have this forward vector.
---@param v Vector
---@return void
function CBaseEntity:SetForwardVector(v) end

---Set PLAYER friction, ignored for objects.
---@param flFriction float
---@return void
function CBaseEntity:SetFriction(flFriction) end

---Set PLAYER gravity, ignored for objects.
---@param flGravity float
---@return void
function CBaseEntity:SetGravity(flGravity) end

---Set the health of this entity.
---@param nHealth int
---@return void
function CBaseEntity:SetHealth(nHealth) end

---Set entity local pitch, yaw, roll by component
---@param fPitch float
---@param fYaw float
---@param fRoll float
---@return void
function CBaseEntity:SetLocalAngles(fPitch, fYaw, fRoll) end

---Set entity local origin from a Vector
---@param origin Vector
---@return void
function CBaseEntity:SetLocalOrigin(origin) end

---
---@param flScale float
---@return void
function CBaseEntity:SetLocalScale(flScale) end

---Set the mass of an entity. (does nothing if it doesn`t have a physics object)
---@param flMass float
---@return void
function CBaseEntity:SetMass(flMass) end

---Set the maximum health of this entity.
---@param amt int
---@return void
function CBaseEntity:SetMaxHealth(amt) end

---
---@param v Vector
---@return void
function CBaseEntity:SetOrigin(v) end

---Sets this entity`s owner
---@param pOwner handle
---@return void
function CBaseEntity:SetOwner(pOwner) end

---Set the parent for this entity.
---@param hParent handle
---@param pAttachmentname string
---@return void
function CBaseEntity:SetParent(hParent, pAttachmentname) end

---
---@param iTeamNum int
---@return void
function CBaseEntity:SetTeam(iTeamNum) end

---
---@param vecVelocity Vector
---@return void
function CBaseEntity:SetVelocity(vecVelocity) end

---Stops a named sound playing from this entity.
---@param soundname string
---@return void
function CBaseEntity:StopSound(soundname) end

---Apply damage to this entity. Use CreateDamageInfo() to create a damageinfo object.
---@param hInfo handle
---@return int
function CBaseEntity:TakeDamage(hInfo) end

---Returns the input Vector transformed from entity to world space
---@param vPoint Vector
---@return Vector
function CBaseEntity:TransformPointEntityToWorld(vPoint) end

---Returns the input Vector transformed from world to entity space
---@param vPoint Vector
---@return Vector
function CBaseEntity:TransformPointWorldToEntity(vPoint) end

---Fires off this entity`s OnTrigger responses.
---@return void
function CBaseEntity:Trigger() end

---Validates the private script scope and creates it if one doesn`t exist.
---@return void
function CBaseEntity:ValidatePrivateScriptScope() end

---@class CBaseFlex : CBaseAnimating
---Returns the instance of the oldest active scene entity (if any).
---@return handle
function CBaseFlex:GetCurrentScene() end

---Returns the instance of the scene entity at the specified index.
---@param index int
---@return handle
function CBaseFlex:GetSceneByIndex(index) end

---( vcd file, delay ) - play specified vcd file
---@param pszScene string
---@param flDelay float
---@return float
function CBaseFlex:ScriptPlayScene(pszScene, flDelay) end

---@class CBaseModelEntity : CBaseEntity
---Get the attachment id`s angles as a p,y,r vector.
---@param iAttachment int
---@return Vector
function CBaseModelEntity:GetAttachmentAngles(iAttachment) end

---Get the attachment id`s forward vector.
---@param iAttachment int
---@return Vector
function CBaseModelEntity:GetAttachmentForward(iAttachment) end

---Get the attachment id`s origin vector.
---@param iAttachment int
---@return Vector
function CBaseModelEntity:GetAttachmentOrigin(iAttachment) end

---GetMaterialGroupHash(): Get the material group hash of this entity.
---@return unsigned
function CBaseModelEntity:GetMaterialGroupHash() end

---GetMaterialGroupMask(): Get the mesh group mask of this entity.
---@return uint64
function CBaseModelEntity:GetMaterialGroupMask() end

---Get scale of entity`s model.
---@return float
function CBaseModelEntity:GetModelScale() end

---GetRenderAlpha(): Get the alpha modulation of this entity.
---@return int
function CBaseModelEntity:GetRenderAlpha() end

---GetRenderColor(): Get the render color of the entity.
---@return Vector
function CBaseModelEntity:GetRenderColor() end

---Get the named attachment id.
---@param pAttachmentName string
---@return int
function CBaseModelEntity:ScriptLookupAttachment(pAttachmentName) end

---Sets a bodygroup.
---@param iGroup int
---@param iValue int
---@return void
function CBaseModelEntity:SetBodygroup(iGroup, iValue) end

---Sets a bodygroup by name.
---@param pName string
---@param iValue int
---@return void
function CBaseModelEntity:SetBodygroupByName(pName, iValue) end

---SetLightGroup( string ): Sets the light group of the entity.
---@param pLightGroup string
---@return void
function CBaseModelEntity:SetLightGroup(pLightGroup) end

---SetMaterialGroup( string ): Set the material group of this entity.
---@param pMaterialGroup string
---@return void
function CBaseModelEntity:SetMaterialGroup(pMaterialGroup) end

---SetMaterialGroupHash( uint32 ): Set the material group hash of this entity.
---@param nHash unsigned
---@return void
function CBaseModelEntity:SetMaterialGroupHash(nHash) end

---SetMaterialGroupMask( uint64 ): Set the mesh group mask of this entity.
---@param nMeshGroupMask uint64
---@return void
function CBaseModelEntity:SetMaterialGroupMask(nMeshGroupMask) end

---
---@param pModelName string
---@return void
function CBaseModelEntity:SetModel(pModelName) end

---Set scale of entity`s model.
---@param flScale float
---@return void
function CBaseModelEntity:SetModelScale(flScale) end

---SetRenderAlpha( int ): Set the alpha modulation of this entity.
---@param nAlpha int
---@return void
function CBaseModelEntity:SetRenderAlpha(nAlpha) end

---SetRenderColor( r, g, b ): Sets the render color of the entity.
---@param r int
---@param g int
---@param b int
---@return void
function CBaseModelEntity:SetRenderColor(r, g, b) end

---SetRenderMode( int ): Sets the render mode of the entity.
---@param nMode int
---@return void
function CBaseModelEntity:SetRenderMode(nMode) end

---SetSingleMeshGroup( string ): Set a single mesh group for this entity.
---@param pMeshGroupName string
---@return void
function CBaseModelEntity:SetSingleMeshGroup(pMeshGroupName) end

---
---@param mins Vector
---@param maxs Vector
---@return void
function CBaseModelEntity:SetSize(mins, maxs) end

---Set skin (int).
---@param iSkin int
---@return void
function CBaseModelEntity:SetSkin(iSkin) end

---@class CBasePlayer : CBaseCombatCharacter
---GetEquippedWeapons() : Returns an array of all the equipped weapons
---@return table
function CBasePlayer:GetEquippedWeapons() end

---Returns the player`s user id.
---@return int
function CBasePlayer:GetUserID() end

---GetWeaponCount() : Gets the number of weapons currently equipped
---@return int
function CBasePlayer:GetWeaponCount() end

---Returns true if the player is in noclip mode.
---@return bool
function CBasePlayer:IsNoclipping() end

---@class CBaseTrigger : CBaseEntity
---Disable`s the trigger
---@return void
function CBaseTrigger:Disable() end

---Enable the trigger
---@return void
function CBaseTrigger:Enable() end

---Checks whether the passed entity is touching the trigger.
---@param hEnt handle
---@return bool
function CBaseTrigger:IsTouching(hEnt) end

---@class CBodyComponent
---Apply an impulse at a worldspace position to the physics
---@param Vector_1 Vector
---@param Vector_2 Vector
---@return void
function CBodyComponent:AddImpulseAtPosition(Vector_1, Vector_2) end

---Add linear and angular velocity to the physics object
---@param Vector_1 Vector
---@param Vector_2 Vector
---@return void
function CBodyComponent:AddVelocity(Vector_1, Vector_2) end

---Detach from its parent
---@return void
function CBodyComponent:DetachFromParent() end

---Returns the active sequence
---@return unknown
function CBodyComponent:GetSequence() end

---Is attached to parent
---@return bool
function CBodyComponent:IsAttachedToParent() end

---Returns a sequence id given a name
---@param string_1 string
---@return unknown
function CBodyComponent:LookupSequence(string_1) end

---Returns the duration in seconds of the specified sequence
---@param string_1 string
---@return float
function CBodyComponent:SequenceDuration(string_1) end

---
---@param Vector_1 Vector
---@return void
function CBodyComponent:SetAngularVelocity(Vector_1) end

---Pass string for the animation to play on this model
---@param string_1 string
---@return void
function CBodyComponent:SetAnimation(string_1) end

---
---@param utlstringtoken_1 utlstringtoken
---@return void
function CBodyComponent:SetMaterialGroup(utlstringtoken_1) end

---
---@param Vector_1 Vector
---@return void
function CBodyComponent:SetVelocity(Vector_1) end

---@class CCustomGameEventManager
---( string EventName, func CallbackFunction ) - Register a callback to be called when a particular custom event arrives. Returns a listener ID that can be used to unregister later.
---@param string_1 string
---@param handle_2 handle
---@return int
function CCustomGameEventManager:RegisterListener(string_1, handle_2) end

---( string EventName, table EventData )
---@param string_1 string
---@param handle_2 handle
---@return void
function CCustomGameEventManager:Send_ServerToAllClients(string_1, handle_2) end

---( Entity Player, string EventName, table EventData )
---@param handle_1 handle
---@param string_2 string
---@param handle_3 handle
---@return void
function CCustomGameEventManager:Send_ServerToPlayer(handle_1, string_2, handle_3) end

---( int TeamNumber, string EventName, table EventData )
---@param int_1 int
---@param string_2 string
---@param handle_3 handle
---@return void
function CCustomGameEventManager:Send_ServerToTeam(int_1, string_2, handle_3) end

---( int ListnerID ) - Unregister a specific listener
---@param int_1 int
---@return void
function CCustomGameEventManager:UnregisterListener(int_1) end

---@class CCustomNetTableManager
---( string TableName, string KeyName )
---@param string_1 string
---@param string_2 string
---@return table
function CCustomNetTableManager:GetTableValue(string_1, string_2) end

---( string TableName, string KeyName, script_table Value )
---@param string_1 string
---@param string_2 string
---@param handle_3 handle
---@return bool
function CCustomNetTableManager:SetTableValue(string_1, string_2, handle_3) end

---@class CDOTABaseAbility : CBaseEntity
---
---@return unknown
function CDOTABaseAbility:CanAbilityBeUpgraded() end

---
---@return bool
function CDOTABaseAbility:CastAbility() end

---
---@return bool
function CDOTABaseAbility:ContinueCasting() end

---
---@param vLocation Vector
---@param fRadius float
---@param fDuration float
---@return void
function CDOTABaseAbility:CreateVisibilityNode(vLocation, fRadius, fDuration) end

---
---@return void
function CDOTABaseAbility:DecrementModifierRefCount() end

---
---@param bInterrupted bool
---@return void
function CDOTABaseAbility:EndChannel(bInterrupted) end

---Clear the cooldown remaining on this ability.
---@return void
function CDOTABaseAbility:EndCooldown() end

---
---@return int
function CDOTABaseAbility:GetAOERadius() end

---
---@return int
function CDOTABaseAbility:GetAbilityDamage() end

---
---@return int
function CDOTABaseAbility:GetAbilityDamageType() end

---
---@return int
function CDOTABaseAbility:GetAbilityIndex() end

---Gets the key values definition for this ability.
---@return table
function CDOTABaseAbility:GetAbilityKeyValues() end

---Returns the name of this ability.
---@return string
function CDOTABaseAbility:GetAbilityName() end

---
---@return int
function CDOTABaseAbility:GetAbilityTargetFlags() end

---
---@return int
function CDOTABaseAbility:GetAbilityTargetTeam() end

---
---@return int
function CDOTABaseAbility:GetAbilityTargetType() end

---
---@return int
function CDOTABaseAbility:GetAbilityType() end

---
---@return bool
function CDOTABaseAbility:GetAnimationIgnoresModelScale() end

---
---@return string
function CDOTABaseAbility:GetAssociatedPrimaryAbilities() end

---
---@return string
function CDOTABaseAbility:GetAssociatedSecondaryAbilities() end

---
---@return bool
function CDOTABaseAbility:GetAutoCastState() end

---
---@return float
function CDOTABaseAbility:GetBackswingTime() end

---
---@return int
function CDOTABaseAbility:GetBehavior() end

---Get ability behavior flags as an int for compatability.
---@return int
function CDOTABaseAbility:GetBehaviorInt() end

---
---@return float
function CDOTABaseAbility:GetCastPoint() end

---Gets the cast range of the ability.
---@param vLocation Vector
---@param hTarget handle
---@return int
function CDOTABaseAbility:GetCastRange(vLocation, hTarget) end

---
---@return CDOTA_BaseNPC | nil
function CDOTABaseAbility:GetCaster() end

---
---@return float
function CDOTABaseAbility:GetChannelStartTime() end

---
---@return float
function CDOTABaseAbility:GetChannelTime() end

---
---@param iLevel int
---@return int
function CDOTABaseAbility:GetChannelledManaCostPerSecond(iLevel) end

---
---@return handle
function CDOTABaseAbility:GetCloneSource() end

---
---@return int
function CDOTABaseAbility:GetConceptRecipientType() end

---Get the cooldown duration for this ability at a given level, not the amount of cooldown actually left.
---@param iLevel int
---@return float
function CDOTABaseAbility:GetCooldown(iLevel) end

---
---@return float
function CDOTABaseAbility:GetCooldownTime() end

---
---@return float
function CDOTABaseAbility:GetCooldownTimeRemaining() end

---
---@return int
function CDOTABaseAbility:GetCurrentAbilityCharges() end

---
---@return Vector
function CDOTABaseAbility:GetCursorPosition() end

---
---@return handle
function CDOTABaseAbility:GetCursorTarget() end

---
---@return bool
function CDOTABaseAbility:GetCursorTargetingNothing() end

---
---@return float
function CDOTABaseAbility:GetDuration() end

---
---@param iLevel int
---@return float
function CDOTABaseAbility:GetEffectiveCooldown(iLevel) end

---
---@param iLevel int
---@return int
function CDOTABaseAbility:GetGoldCost(iLevel) end

---
---@param iLevel int
---@return int
function CDOTABaseAbility:GetGoldCostForUpgrade(iLevel) end

---
---@return int
function CDOTABaseAbility:GetHeroLevelRequiredToUpgrade() end

---返回此技能被动给予的修饰器的名称
---@return string
function CDOTABaseAbility:GetIntrinsicModifierName() end

---Get the current level of the ability.
---@return int
function CDOTABaseAbility:GetLevel() end

---
---@param szName string
---@param nLevel int
---@return table
function CDOTABaseAbility:GetLevelSpecialValueFor(szName, nLevel) end

---
---@param szName string
---@param nLevel int
---@return table
function CDOTABaseAbility:GetLevelSpecialValueNoOverride(szName, nLevel) end

---
---@param iLevel int
---@return int
function CDOTABaseAbility:GetManaCost(iLevel) end

---
---@param iLevel int
---@return int
function CDOTABaseAbility:GetMaxAbilityCharges(iLevel) end

---
---@return int
function CDOTABaseAbility:GetMaxLevel() end

---
---@return float
function CDOTABaseAbility:GetModifierValue() end

---
---@return float
function CDOTABaseAbility:GetModifierValueBonus() end

---
---@return float
function CDOTABaseAbility:GetPlaybackRateOverride() end

---
---@return string
function CDOTABaseAbility:GetSharedCooldownName() end

---从该技能的当前等级的特殊值获取值。
---@param szName string
---@return table
function CDOTABaseAbility:GetSpecialValueFor(szName) end

---
---@return string
function CDOTABaseAbility:GetStolenActivityModifier() end

---
---@return bool
function CDOTABaseAbility:GetToggleState() end

---
---@return bool
function CDOTABaseAbility:GetUpgradeRecommended() end

---
---@param flXP float
---@return bool
function CDOTABaseAbility:HeroXPChange(flXP) end

---
---@return void
function CDOTABaseAbility:IncrementModifierRefCount() end

---
---@return bool
function CDOTABaseAbility:IsActivated() end

---
---@return bool
function CDOTABaseAbility:IsAttributeBonus() end

---Returns whether the ability is currently channeling.
---@return bool
function CDOTABaseAbility:IsChanneling() end

---
---@return bool
function CDOTABaseAbility:IsCooldownReady() end

---
---@param hEntity handle
---@return bool
function CDOTABaseAbility:IsCosmetic(hEntity) end

---Returns whether the ability can be cast.
---@return bool
function CDOTABaseAbility:IsFullyCastable() end

---
---@return bool
function CDOTABaseAbility:IsHidden() end

---
---@return bool
function CDOTABaseAbility:IsHiddenAsSecondaryAbility() end

---
---@return bool
function CDOTABaseAbility:IsHiddenWhenStolen() end

---Returns whether the ability is currently casting.
---@return bool
function CDOTABaseAbility:IsInAbilityPhase() end

---
---@return bool
function CDOTABaseAbility:IsItem() end

---
---@param nIssuerPlayerID int
---@return bool
function CDOTABaseAbility:IsOwnersGoldEnough(nIssuerPlayerID) end

---
---@return bool
function CDOTABaseAbility:IsOwnersGoldEnoughForUpgrade() end

---
---@return bool
function CDOTABaseAbility:IsOwnersManaEnough() end

---
---@return bool
function CDOTABaseAbility:IsPassive() end

---
---@return bool
function CDOTABaseAbility:IsRefreshable() end

---
---@return bool
function CDOTABaseAbility:IsSharedWithTeammates() end

---
---@return bool
function CDOTABaseAbility:IsStealable() end

---
---@return bool
function CDOTABaseAbility:IsStolen() end

---
---@return bool
function CDOTABaseAbility:IsToggle() end

---
---@return bool
function CDOTABaseAbility:IsTrained() end

---Mark the ability button for this ability as needing a refresh.
---@return void
function CDOTABaseAbility:MarkAbilityButtonDirty() end

---
---@return int
function CDOTABaseAbility:NumModifiersUsingAbility() end

---
---@return void
function CDOTABaseAbility:OnAbilityPhaseInterrupted() end

---
---@return bool
function CDOTABaseAbility:OnAbilityPhaseStart() end

---
---@param nPlayerID int
---@param bCtrlHeld bool
---@return void
function CDOTABaseAbility:OnAbilityPinged(nPlayerID, bCtrlHeld) end

---
---@param bInterrupted bool
---@return void
function CDOTABaseAbility:OnChannelFinish(bInterrupted) end

---
---@param flInterval float
---@return void
function CDOTABaseAbility:OnChannelThink(flInterval) end

---
---@return void
function CDOTABaseAbility:OnHeroCalculateStatBonus() end

---
---@return void
function CDOTABaseAbility:OnHeroLevelUp() end

---
---@return void
function CDOTABaseAbility:OnOwnerDied() end

---
---@return void
function CDOTABaseAbility:OnOwnerSpawned() end

---
---@return void
function CDOTABaseAbility:OnSpellStart() end

---
---@return void
function CDOTABaseAbility:OnToggle() end

---
---@return void
function CDOTABaseAbility:OnUpgrade() end

---
---@return void
function CDOTABaseAbility:PayGoldCost() end

---
---@return void
function CDOTABaseAbility:PayGoldCostForUpgrade() end

---
---@return void
function CDOTABaseAbility:PayManaCost() end

---
---@return bool
function CDOTABaseAbility:PlaysDefaultAnimWhenStolen() end

---
---@return bool
function CDOTABaseAbility:ProcsMagicStick() end

---
---@return bool
function CDOTABaseAbility:RefCountsModifiers() end

---
---@return void
function CDOTABaseAbility:RefreshCharges() end

---
---@return unknown
function CDOTABaseAbility:RefreshIntrinsicModifier() end

---
---@return void
function CDOTABaseAbility:RefundManaCost() end

---
---@return bool
function CDOTABaseAbility:RequiresFacing() end

---
---@return bool
function CDOTABaseAbility:ResetToggleOnRespawn() end

---
---@param iIndex int
---@return void
function CDOTABaseAbility:SetAbilityIndex(iIndex) end

---
---@param bActivated bool
---@return void
function CDOTABaseAbility:SetActivated(bActivated) end

---
---@param bChanneling bool
---@return void
function CDOTABaseAbility:SetChanneling(bChanneling) end

---
---@param nCharges int
---@return void
function CDOTABaseAbility:SetCurrentAbilityCharges(nCharges) end

---
---@param bFrozenCooldown bool
---@return void
function CDOTABaseAbility:SetFrozenCooldown(bFrozenCooldown) end

---
---@param bHidden bool
---@return void
function CDOTABaseAbility:SetHidden(bHidden) end

---
---@param bInAbilityPhase bool
---@return void
function CDOTABaseAbility:SetInAbilityPhase(bInAbilityPhase) end

---Sets the level of this ability.
---@param iLevel int
---@return void
function CDOTABaseAbility:SetLevel(iLevel) end

---
---@param flCastPoint float
---@return void
function CDOTABaseAbility:SetOverrideCastPoint(flCastPoint) end

---
---@param bRefCounts bool
---@return void
function CDOTABaseAbility:SetRefCountsModifiers(bRefCounts) end

---
---@param bStealable bool
---@return void
function CDOTABaseAbility:SetStealable(bStealable) end

---
---@param bStolen bool
---@return void
function CDOTABaseAbility:SetStolen(bStolen) end

---
---@param bUpgradeRecommended bool
---@return void
function CDOTABaseAbility:SetUpgradeRecommended(bUpgradeRecommended) end

---
---@return bool
function CDOTABaseAbility:ShouldUseResources() end

---
---@param iConcept int
---@return void
function CDOTABaseAbility:SpeakAbilityConcept(iConcept) end

---
---@return unknown
function CDOTABaseAbility:SpeakTrigger() end

---
---@param flCooldown float
---@return void
function CDOTABaseAbility:StartCooldown(flCooldown) end

---
---@return void
function CDOTABaseAbility:ToggleAbility() end

---
---@return void
function CDOTABaseAbility:ToggleAutoCast() end

---升级该技能，一般不用CDOTA_BaseNPC_Hero的那个UpgradeAbility，那个API会导致被动modifier不刷新。
---@param bSupressSpeech bool
---@return void
function CDOTABaseAbility:UpgradeAbility(bSupressSpeech) end

---调用该技能的各种效果，包括魔法，金钱，冷却时间。
---@param bMana bool
---@param bGold bool
---@param bCooldown bool
---@return void
function CDOTABaseAbility:UseResources(bMana, bGold, bCooldown) end

---@class CDOTABaseGameMode : CBaseEntity
---
---@param pszAbilityName string
---@return void
function CDOTABaseGameMode:AddAbilityUpgradeToWhitelist(pszAbilityName) end

---( pszItem, pszShop, pszCategory ) Add an item to purchase at a custom shop.
---@param pszItemName string
---@param pszShopName string
---@param pszCategory string
---@return void
function CDOTABaseGameMode:AddItemToCustomShop(pszItemName, pszShopName, pszCategory) end

---Begin tracking a sequence of events using the real time combat analyzer.
---@param hQueryTable handle
---@param hPlayer handle
---@param pszQueryName string
---@return int
function CDOTABaseGameMode:AddRealTimeCombatAnalyzerQuery(hQueryTable, hPlayer, pszQueryName) end

---一个锁定战争迷雾的实体。返回类为CFoWBlockerRegion
---@param flMinX float
---@param flMinY float
---@param flMaxX float
---@param flMaxY float
---@param flGridSize float
---@return handle
function CDOTABaseGameMode:AllocateFowBlockerRegion(flMinX, flMinY, flMaxX, flMaxY, flGridSize) end

---Get if weather effects are disabled on the client.
---@return bool
function CDOTABaseGameMode:AreWeatherEffectsDisabled() end

---Clear the script filter that controls bounty rune pickup behavior.
---@return void
function CDOTABaseGameMode:ClearBountyRunePickupFilter() end

---Clear the script filter that controls how a unit takes damage.
---@return void
function CDOTABaseGameMode:ClearDamageFilter() end

---Clear the script filter that controls when a unit picks up an item.
---@return void
function CDOTABaseGameMode:ClearExecuteOrderFilter() end

---Clear the script filter that controls how a unit heals.
---@return void
function CDOTABaseGameMode:ClearHealingFilter() end

---Clear the script filter that controls the item added to inventory filter.
---@return void
function CDOTABaseGameMode:ClearItemAddedToInventoryFilter() end

---Clear the script filter that controls the modifier filter.
---@return void
function CDOTABaseGameMode:ClearModifierGainedFilter() end

---Clear the script filter that controls how hero experience is modified.
---@return void
function CDOTABaseGameMode:ClearModifyExperienceFilter() end

---Clear the script filter that controls how hero gold is modified.
---@return void
function CDOTABaseGameMode:ClearModifyGoldFilter() end

---Clear the script filter that controls what rune spawns.
---@return void
function CDOTABaseGameMode:ClearRuneSpawnFilter() end

---Clear the script filter that controls when tracking projectiles are launched.
---@return void
function CDOTABaseGameMode:ClearTrackingProjectileFilter() end

---Disable npc_dota_creature clumping behavior by default.
---@param bDisabled bool
---@return void
function CDOTABaseGameMode:DisableClumpingBehaviorByDefault(bDisabled) end

---Use to disable hud flip for this mod
---@param bDisable bool
---@return void
function CDOTABaseGameMode:DisableHudFlip(bDisable) end

---
---@param bEnabled bool
---@return void
function CDOTABaseGameMode:EnableAbilityUpgradeWhitelist(bEnabled) end

---Show the player hero`s inventory in the HUD, regardless of what unit is selected.
---@return bool
function CDOTABaseGameMode:GetAlwaysShowPlayerInventory() end

---Get whether player names are always shown, regardless of client setting.
---@return bool
function CDOTABaseGameMode:GetAlwaysShowPlayerNames() end

---Are in-game announcers disabled?
---@return bool
function CDOTABaseGameMode:GetAnnouncerDisabled() end

---Set a different camera distance; dota default is 1134.
---@return float
function CDOTABaseGameMode:GetCameraDistanceOverride() end

---Get current derived stat value constant.
---@param nDerivedStatType int
---@param hHero handle
---@return float
function CDOTABaseGameMode:GetCustomAttributeDerivedStatValue(nDerivedStatType, hHero) end

---Get the current rate cooldown ticks down for items in the backpack.
---@return float
function CDOTABaseGameMode:GetCustomBackpackCooldownPercent() end

---Get the current custom backpack swap cooldown.
---@return float
function CDOTABaseGameMode:GetCustomBackpackSwapCooldown() end

---Turns on capability to define custom buyback cooldowns.
---@return bool
function CDOTABaseGameMode:GetCustomBuybackCooldownEnabled() end

---Turns on capability to define custom buyback costs.
---@return bool
function CDOTABaseGameMode:GetCustomBuybackCostEnabled() end

---Get the topbar score display value for dire.
---@return int
function CDOTABaseGameMode:GetCustomDireScore() end

---Get the current custom glyph cooldown.
---@return float
function CDOTABaseGameMode:GetCustomGlyphCooldown() end

---Allows definition of the max level heroes can achieve (default is 25).
---@return int
function CDOTABaseGameMode:GetCustomHeroMaxLevel() end

---Get the topbar score display value for radiant.
---@return int
function CDOTABaseGameMode:GetCustomRadiantScore() end

---Get the current custom scan cooldown.
---@return float
function CDOTABaseGameMode:GetCustomScanCooldown() end

---Get the Game Seed passed from the GC.
---@return int
function CDOTABaseGameMode:GetEventGameSeed() end

---Get the Event Window Start Time passed from the GC.
---@return unsigned
function CDOTABaseGameMode:GetEventWindowStartTime() end

---Gets the fixed respawn time.
---@return float
function CDOTABaseGameMode:GetFixedRespawnTime() end

---Turn the fog of war on or off.
---@return bool
function CDOTABaseGameMode:GetFogOfWarDisabled() end

---Turn the sound when gold is acquired off/on.
---@return bool
function CDOTABaseGameMode:GetGoldSoundDisabled() end

---Returns the HUD element visibility.
---@param iElement int
---@return bool
function CDOTABaseGameMode:GetHUDVisible(iElement) end

---Get the maximum attack speed for units.
---@return int
function CDOTABaseGameMode:GetMaximumAttackSpeed() end

---Get the minimum attack speed for units.
---@return int
function CDOTABaseGameMode:GetMinimumAttackSpeed() end

---Turn the panel for showing recommended items at the shop off/on.
---@return bool
function CDOTABaseGameMode:GetRecommendedItemsDisabled() end

---Returns the scale applied to non-fixed respawn times.
---@return float
function CDOTABaseGameMode:GetRespawnTimeScale() end

---Turn purchasing items to the stash off/on. If purchasing to the stash is off the player must be at a shop to purchase items.
---@return bool
function CDOTABaseGameMode:GetStashPurchasingDisabled() end

---Hide the sticky item in the quickbuy.
---@return bool
function CDOTABaseGameMode:GetStickyItemDisabled() end

---Override the values of the team values on the top game bar.
---@return bool
function CDOTABaseGameMode:GetTopBarTeamValuesOverride() end

---Turning on/off the team values on the top game bar.
---@return bool
function CDOTABaseGameMode:GetTopBarTeamValuesVisible() end

---Gets whether tower backdoor protection is enabled or not.
---@return bool
function CDOTABaseGameMode:GetTowerBackdoorProtectionEnabled() end

---Are custom-defined XP values for hero level ups in use?
---@return bool
function CDOTABaseGameMode:GetUseCustomHeroLevels() end

---
---@param pszAbilityName string
---@return bool
function CDOTABaseGameMode:IsAbilityUpgradeWhitelisted(pszAbilityName) end

---Enables or disables buyback completely.
---@return bool
function CDOTABaseGameMode:IsBuybackEnabled() end

---Is the day/night cycle disabled?
---@return bool
function CDOTABaseGameMode:IsDaynightCycleDisabled() end

---Set function and context for real time combat analyzer query failed.
---@param hFunction handle
---@param hContext handle
---@return void
function CDOTABaseGameMode:ListenForQueryFailed(hFunction, hContext) end

---Set function and context for real time combat analyzer query progress changed.
---@param hFunction handle
---@param hContext handle
---@return void
function CDOTABaseGameMode:ListenForQueryProgressChanged(hFunction, hContext) end

---Set function and context for real time combat analyzer query succeeded.
---@param hFunction handle
---@param hContext handle
---@return void
function CDOTABaseGameMode:ListenForQuerySucceeded(hFunction, hContext) end

---
---@param pszAbilityName string
---@return void
function CDOTABaseGameMode:RemoveAbilityUpgradeFromWhitelist(pszAbilityName) end

---( pszItem, pszShop ) Remove an item to purchase at a custom shop.
---@param pszItemName string
---@param pszShopName string
---@return void
function CDOTABaseGameMode:RemoveItemFromCustomShop(pszItemName, pszShopName) end

---Stop tracking a combat analyzer query.
---@param nQueryID int
---@return void
function CDOTABaseGameMode:RemoveRealTimeCombatAnalyzerQuery(nQueryID) end

---Set a filter function to control the tuning values that abilities use. (Modify the table and Return true to use new values, return false to use the old values)
---@param hFunction handle
---@param hContext handle
---@return void
function CDOTABaseGameMode:SetAbilityTuningValueFilter(hFunction, hContext) end

---If set to true, neutral items will be dropped on killing neutral monsters.  Otherwise nothing will be dropped.
---@param bEnabled bool
---@return void
function CDOTABaseGameMode:SetAllowNeutralItemDrops(bEnabled) end

---Show the player hero`s inventory in the HUD, regardless of what unit is selected.
---@param bAlwaysShow bool
---@return void
function CDOTABaseGameMode:SetAlwaysShowPlayerInventory(bAlwaysShow) end

---Set whether player names are always shown, regardless of client setting.
---@param bEnabled bool
---@return void
function CDOTABaseGameMode:SetAlwaysShowPlayerNames(bEnabled) end

---Mutes the in-game announcer.
---@param bDisabled bool
---@return void
function CDOTABaseGameMode:SetAnnouncerDisabled(bDisabled) end

---Enables/Disables bots in custom games. Note: this will only work with default heroes in the dota map.
---@param bEnabled bool
---@return void
function CDOTABaseGameMode:SetBotThinkingEnabled(bEnabled) end

---Set if the bots should try their best to push with a human player.
---@param bAlwaysPush bool
---@return void
function CDOTABaseGameMode:SetBotsAlwaysPushWithHuman(bAlwaysPush) end

---Set if bots should enable their late game behavior.
---@param bLateGame bool
---@return void
function CDOTABaseGameMode:SetBotsInLateGame(bLateGame) end

---Set the max tier of tower that bots want to push. (-1 to disable)
---@param nMaxTier int
---@return void
function CDOTABaseGameMode:SetBotsMaxPushTier(nMaxTier) end

---Set a filter function to control the behavior when a bounty rune is picked up. (Modify the table and Return true to use new values, return false to cancel the event)
---@param hFunction handle
---@param hContext handle
---@return void
function CDOTABaseGameMode:SetBountyRunePickupFilter(hFunction, hContext) end

---Set bounty rune spawn rate
---@param flInterval float
---@return void
function CDOTABaseGameMode:SetBountyRuneSpawnInterval(flInterval) end

---Enables or disables buyback completely.
---@param bEnabled bool
---@return void
function CDOTABaseGameMode:SetBuybackEnabled(bEnabled) end

---Set a different camera distance; dota default is 1134.
---@param flCameraDistanceOverride float
---@return void
function CDOTABaseGameMode:SetCameraDistanceOverride(flCameraDistanceOverride) end

---Set a different camera smooth count; dota default is 8.
---@param nSmoothCount int
---@return void
function CDOTABaseGameMode:SetCameraSmoothCountOverride(nSmoothCount) end

---Sets the camera Z range
---@param flMinZ float
---@param flMaxZ float
---@return void
function CDOTABaseGameMode:SetCameraZRange(flMinZ, flMaxZ) end

---Modify derived stat value constants. ( AttributeDerivedStat eStatType, float flNewValue.
---@param nStatType int
---@param flNewValue float
---@return void
function CDOTABaseGameMode:SetCustomAttributeDerivedStatValue(nStatType, flNewValue) end

---Set the rate cooldown ticks down for items in the backpack.
---@param flPercent float
---@return void
function CDOTABaseGameMode:SetCustomBackpackCooldownPercent(flPercent) end

---Set a custom cooldown for swapping items into the backpack.
---@param flCooldown float
---@return void
function CDOTABaseGameMode:SetCustomBackpackSwapCooldown(flCooldown) end

---Turns on capability to define custom buyback cooldowns.
---@param bEnabled bool
---@return void
function CDOTABaseGameMode:SetCustomBuybackCooldownEnabled(bEnabled) end

---Turns on capability to define custom buyback costs.
---@param bEnabled bool
---@return void
function CDOTABaseGameMode:SetCustomBuybackCostEnabled(bEnabled) end

---Sets the topbar score display value for dire.
---@param nScore int
---@return void
function CDOTABaseGameMode:SetCustomDireScore(nScore) end

---Force all players to use the specified hero and disable the normal hero selection process. Must be used before hero selection.
---@param pHeroName string
---@return void
function CDOTABaseGameMode:SetCustomGameForceHero(pHeroName) end

---Set a custom cooldown for team Glyph ability.
---@param flCooldown float
---@return void
function CDOTABaseGameMode:SetCustomGlyphCooldown(flCooldown) end

---Allows definition of the max level heroes can achieve (default is 25).
---@param int_1 int
---@return void
function CDOTABaseGameMode:SetCustomHeroMaxLevel(int_1) end

---Sets the topbar score display value for radiant.
---@param nScore int
---@return void
function CDOTABaseGameMode:SetCustomRadiantScore(nScore) end

---Set a custom cooldown for team Scan ability.
---@param flCooldown float
---@return void
function CDOTABaseGameMode:SetCustomScanCooldown(flCooldown) end

---Set the effect used as a custom weather effect, when units are on non-default terrain, in this mode.
---@param pszEffectName string
---@return void
function CDOTABaseGameMode:SetCustomTerrainWeatherEffect(pszEffectName) end

---Allows definition of a table of hero XP values.
---@param hTable handle
---@return void
function CDOTABaseGameMode:SetCustomXPRequiredToReachNextLevel(hTable) end

---Set a filter function to control the behavior when a unit takes damage. (Modify the table and Return true to use new values, return false to cancel the event)
---@param hFunction handle
---@param hContext handle
---@return void
function CDOTABaseGameMode:SetDamageFilter(hFunction, hContext) end

---Enable or disable the day/night cycle.
---@param bDisable bool
---@return void
function CDOTABaseGameMode:SetDaynightCycleDisabled(bDisable) end

---Specify whether the full screen death overlay effect plays when the selected hero dies.
---@param bDisabled bool
---@return void
function CDOTABaseGameMode:SetDeathOverlayDisabled(bDisabled) end

---Sets the default sticky item in the quickbuy
---@param pItem string
---@return void
function CDOTABaseGameMode:SetDefaultStickyItem(pItem) end

---Set drafting hero banning time
---@param flValue float
---@return void
function CDOTABaseGameMode:SetDraftingBanningTimeOverride(flValue) end

---Set drafting hero pick time
---@param flValue float
---@return void
function CDOTABaseGameMode:SetDraftingHeroPickSelectTimeOverride(flValue) end

---Set a filter function to control the behavior when a unit picks up an item. (Modify the table and Return true to use new values, return false to cancel the event)
---@param hFunction handle
---@param hContext handle
---@return void
function CDOTABaseGameMode:SetExecuteOrderFilter(hFunction, hContext) end

---Set a fixed delay for all players to respawn after.
---@param flFixedRespawnTime float
---@return void
function CDOTABaseGameMode:SetFixedRespawnTime(flFixedRespawnTime) end

---Turn the fog of war on or off.
---@param bDisabled bool
---@return void
function CDOTABaseGameMode:SetFogOfWarDisabled(bDisabled) end

---Prevent users from using the right click deny setting.
---@param bDisabled bool
---@return void
function CDOTABaseGameMode:SetForceRightClickAttackDisabled(bDisabled) end

---Set the constant rate that the fountain will regen mana. (-1 for default)
---@param flConstantManaRegen float
---@return void
function CDOTABaseGameMode:SetFountainConstantManaRegen(flConstantManaRegen) end

---Set the percentage rate that the fountain will regen health. (-1 for default)
---@param flPercentageHealthRegen float
---@return void
function CDOTABaseGameMode:SetFountainPercentageHealthRegen(flPercentageHealthRegen) end

---Set the percentage rate that the fountain will regen mana. (-1 for default)
---@param flPercentageManaRegen float
---@return void
function CDOTABaseGameMode:SetFountainPercentageManaRegen(flPercentageManaRegen) end

---If set to true, enable 7.23 free courier mode.
---@param bEnabled bool
---@return void
function CDOTABaseGameMode:SetFreeCourierModeEnabled(bEnabled) end

---Allows clicks on friendly buildings to be handled normally.
---@param bEnabled bool
---@return void
function CDOTABaseGameMode:SetFriendlyBuildingMoveToEnabled(bEnabled) end

---Turn the sound when gold is acquired off/on.
---@param bDisabled bool
---@return void
function CDOTABaseGameMode:SetGoldSoundDisabled(bDisabled) end

---Set the HUD element visibility.
---@param iHUDElement int
---@param bVisible bool
---@return void
function CDOTABaseGameMode:SetHUDVisible(iHUDElement, bVisible) end

---Set a filter function to control the behavior when a unit heals. (Modify the table and Return true to use new values, return false to cancel the event)
---@param hFunction handle
---@param hContext handle
---@return void
function CDOTABaseGameMode:SetHealingFilter(hFunction, hContext) end

---Specify whether the default combat events will show in the HUD.
---@param bDisabled bool
---@return void
function CDOTABaseGameMode:SetHudCombatEventsDisabled(bDisabled) end

---Set a filter function to control what happens to items that are added to an inventory, return false to cancel the event
---@param hFunction handle
---@param hContext handle
---@return void
function CDOTABaseGameMode:SetItemAddedToInventoryFilter(hFunction, hContext) end

---Set whether tombstones can be channeled to be removed by enemy heroes.
---@param bEnabled bool
---@return void
function CDOTABaseGameMode:SetKillableTombstones(bEnabled) end

---Mutes the in-game killing spree announcer.
---@param bDisabled bool
---@return void
function CDOTABaseGameMode:SetKillingSpreeAnnouncerDisabled(bDisabled) end

---Use to disable gold loss on death.
---@param bEnabled bool
---@return void
function CDOTABaseGameMode:SetLoseGoldOnDeath(bEnabled) end

---Set the maximum attack speed for units.
---@param nMaxSpeed int
---@return void
function CDOTABaseGameMode:SetMaximumAttackSpeed(nMaxSpeed) end

---Set the minimum attack speed for units.
---@param nMinSpeed int
---@return void
function CDOTABaseGameMode:SetMinimumAttackSpeed(nMinSpeed) end

---Set a filter function to control modifiers that are gained, return false to destroy modifier.
---@param hFunction handle
---@param hContext handle
---@return void
function CDOTABaseGameMode:SetModifierGainedFilter(hFunction, hContext) end

---Set a filter function to control the behavior when a hero`s experience is modified. (Modify the table and Return true to use new values, return false to cancel the event)
---@param hFunction handle
---@param hContext handle
---@return void
function CDOTABaseGameMode:SetModifyExperienceFilter(hFunction, hContext) end

---Set a filter function to control the behavior when a hero`s gold is modified. (Modify the table and Return true to use new values, return false to cancel the event)
---@param hFunction handle
---@param hContext handle
---@return void
function CDOTABaseGameMode:SetModifyGoldFilter(hFunction, hContext) end

---When enabled, undiscovered items in the neutral item stash are hidden.
---@param bEnable bool
---@return void
function CDOTABaseGameMode:SetNeutralItemHideUndiscoveredEnabled(bEnable) end

---Allow items to be sent to the neutral stash.
---@param bEnable bool
---@return void
function CDOTABaseGameMode:SetNeutralStashEnabled(bEnable) end

---When enabled, the all neutral items tab cannot be viewed.
---@param bEnable bool
---@return void
function CDOTABaseGameMode:SetNeutralStashTeamViewOnlyEnabled(bEnable) end

---Set an override for the default selection entity, instead of each player`s hero.
---@param hOverrideEntity handle
---@return void
function CDOTABaseGameMode:SetOverrideSelectionEntity(hOverrideEntity) end

---Set pausing enabled/disabled
---@param bEnabled bool
---@return void
function CDOTABaseGameMode:SetPauseEnabled(bEnabled) end

---Set power rune spawn rate
---@param flInterval float
---@return void
function CDOTABaseGameMode:SetPowerRuneSpawnInterval(flInterval) end

---Disables bonus items for randoming a hero.
---@param bDisabled bool
---@return void
function CDOTABaseGameMode:SetRandomHeroBonusItemGrantDisabled(bDisabled) end

---Turn the panel for showing recommended items at the shop off/on.
---@param bDisabled bool
---@return void
function CDOTABaseGameMode:SetRecommendedItemsDisabled(bDisabled) end

---Make it so illusions are immediately removed upon death, rather than sticking around for a few seconds.
---@param bRemove bool
---@return void
function CDOTABaseGameMode:SetRemoveIllusionsOnDeath(bRemove) end

---Sets the scale applied to non-fixed respawn times. 1 = default DOTA respawn calculations.
---@param flValue float
---@return void
function CDOTABaseGameMode:SetRespawnTimeScale(flValue) end

---Set if a given type of rune is enabled.
---@param nRune int
---@param bEnabled bool
---@return void
function CDOTABaseGameMode:SetRuneEnabled(nRune, bEnabled) end

---Set a filter function to control what rune spawns. (Modify the table and Return true to use new values, return false to cancel the event)
---@param hFunction handle
---@param hContext handle
---@return void
function CDOTABaseGameMode:SetRuneSpawnFilter(hFunction, hContext) end

---Enable/disable gold penalty for late picking.
---@param bEnabled bool
---@return void
function CDOTABaseGameMode:SetSelectionGoldPenaltyEnabled(bEnabled) end

---Allow items to be sent to the stash.
---@param bEnable bool
---@return void
function CDOTABaseGameMode:SetSendToStashEnabled(bEnable) end

---Turn purchasing items to the stash off/on. If purchasing to the stash is off the player must be at a shop to purchase items.
---@param bDisabled bool
---@return void
function CDOTABaseGameMode:SetStashPurchasingDisabled(bDisabled) end

---Hide the sticky item in the quickbuy.
---@param bDisabled bool
---@return void
function CDOTABaseGameMode:SetStickyItemDisabled(bDisabled) end

---Sets the item which goes in the TP scroll slot
---@param pItemName string
---@return void
function CDOTABaseGameMode:SetTPScrollSlotItemOverride(pItemName) end

---Set the team values on the top game bar.
---@param iTeam int
---@param nValue int
---@return void
function CDOTABaseGameMode:SetTopBarTeamValue(iTeam, nValue) end

---Override the values of the team values on the top game bar.
---@param bOverride bool
---@return void
function CDOTABaseGameMode:SetTopBarTeamValuesOverride(bOverride) end

---Turning on/off the team values on the top game bar.
---@param bVisible bool
---@return void
function CDOTABaseGameMode:SetTopBarTeamValuesVisible(bVisible) end

---Enables/Disables tower backdoor protection.
---@param bEnabled bool
---@return void
function CDOTABaseGameMode:SetTowerBackdoorProtectionEnabled(bEnabled) end

---Set a filter function to control when tracking projectiles are launched. (Modify the table and Return true to use new values, return false to cancel the event)
---@param hFunction handle
---@param hContext handle
---@return void
function CDOTABaseGameMode:SetTrackingProjectileFilter(hFunction, hContext) end

---Enable or disable unseen fog of war. When enabled parts of the map the player has never seen will be completely hidden by fog of war.
---@param bEnabled bool
---@return void
function CDOTABaseGameMode:SetUnseenFogOfWarEnabled(bEnabled) end

---Turn on custom-defined XP values for hero level ups.  The table should be defined before switching this on.
---@param bEnabled bool
---@return void
function CDOTABaseGameMode:SetUseCustomHeroLevels(bEnabled) end

---If set to true, use current rune spawn rules.  Either setting respects custom spawn intervals.
---@param bEnabled bool
---@return void
function CDOTABaseGameMode:SetUseDefaultDOTARuneSpawnLogic(bEnabled) end

---Set if weather effects are disabled.
---@param bDisable bool
---@return void
function CDOTABaseGameMode:SetWeatherEffectsDisabled(bDisable) end

---@class CDOTAGameManager
---Get the hero unit 
---@param string_1 string
---@return table
function CDOTAGameManager:GetHeroDataByName_Script(string_1) end

---Get the hero ID given the hero name.
---@param string_1 string
---@return int
function CDOTAGameManager:GetHeroIDByName(string_1) end

---Get the hero name given a hero ID.
---@param int_1 int
---@return string
function CDOTAGameManager:GetHeroNameByID(int_1) end

---Get the hero name given a unit name.
---@param string_1 string
---@return string
function CDOTAGameManager:GetHeroNameForUnitName(string_1) end

---Get the hero unit name given the hero ID.
---@param int_1 int
---@return string
function CDOTAGameManager:GetHeroUnitNameByID(int_1) end

---@class CDOTAGamerules
---Spawn a bot player of the passed hero name, player name, and team.
---@param sHeroName string
---@param sBotName string
---@param iTeamNumber int
---@param sScriptPath string
---@param bool_5 bool
---@return handle
function CDOTAGamerules:AddBotPlayerWithEntityScript(sHeroName, sBotName, iTeamNumber, sScriptPath, bool_5) end

---Event-only ( string szNameSuffix, int nStars, int nMaxStars, int nExtraData1, int nExtraData2 )
---@param string_1 string
---@param unsigned_2 unsigned
---@param unsigned_3 unsigned
---@param unsigned_4 unsigned
---@param unsigned_5 unsigned
---@param unsigned_6 unsigned
---@param unsigned_7 unsigned
---@param unsigned_8 unsigned
---@param unsigned_9 unsigned
---@return bool
function CDOTAGamerules:AddEventMetadataLeaderboardEntry(string_1, unsigned_2, unsigned_3, unsigned_4, unsigned_5, unsigned_6, unsigned_7, unsigned_8, unsigned_9) end

---Event-only ( string szNameSuffix, int nScore, int nExtraData1, int nExtraData2 )
---@param string_1 string
---@param unsigned_2 unsigned
---@param unsigned_3 unsigned
---@param unsigned_4 unsigned
---@param unsigned_5 unsigned
---@param unsigned_6 unsigned
---@param unsigned_7 unsigned
---@param unsigned_8 unsigned
---@return bool
function CDOTAGamerules:AddEventMetadataLeaderboardEntryRawScore(string_1, unsigned_2, unsigned_3, unsigned_4, unsigned_5, unsigned_6, unsigned_7, unsigned_8) end

---Add an item to the whitelist
---@param string_1 string
---@return void
function CDOTAGamerules:AddItemToWhiteList(string_1) end

---Add a point on the minimap.
---@param int_1 int
---@param Vector_2 Vector
---@param int_3 int
---@param int_4 int
---@param int_5 int
---@param int_6 int
---@param float_7 float
---@return void
function CDOTAGamerules:AddMinimapDebugPoint(int_1, Vector_2, int_3, int_4, int_5, int_6, float_7) end

---Add a point on the minimap for a specific team.
---@param int_1 int
---@param Vector_2 Vector
---@param int_3 int
---@param int_4 int
---@param int_5 int
---@param int_6 int
---@param float_7 float
---@param int_8 int
---@return void
function CDOTAGamerules:AddMinimapDebugPointForTeam(int_1, Vector_2, int_3, int_4, int_5, int_6, float_7, int_8) end

---Begin night stalker night.
---@param float_1 float
---@return void
function CDOTAGamerules:BeginNightstalkerNight(float_1) end

---Begin temporary night.
---@param float_1 float
---@return void
function CDOTAGamerules:BeginTemporaryNight(float_1) end

---Fills all the teams with bots if cheat mode is enabled.
---@return void
function CDOTAGamerules:BotPopulate() end

---Kills the ancient, etc.
---@return void
function CDOTAGamerules:Defeated() end

---true when we have waited some time after end of the game and not received signout
---@return bool
function CDOTAGamerules:DidMatchSignoutTimeOut() end

---Enabled (true) or disable (false) auto launch for custom game setup.
---@param bool_1 bool
---@return void
function CDOTAGamerules:EnableCustomGameSetupAutoLaunch(bool_1) end

---Sends a minimap ping to all players on the team
---@param int_1 int
---@param float_2 float
---@param float_3 float
---@param handle_4 handle
---@param int_5 int
---@return void
function CDOTAGamerules:ExecuteTeamPing(int_1, float_2, float_3, handle_4, int_5) end

---Indicate that the custom game setup phase is complete, and advance to the game.
---@return void
function CDOTAGamerules:FinishCustomGameSetup() end

---Spawn the next wave of creeps.
---@return void
function CDOTAGamerules:ForceCreepSpawn() end

---Transition game state to DOTA_GAMERULES_STATE_GAME_IN_PROGRESS
---@return void
function CDOTAGamerules:ForceGameStart() end

---Get the announcer for a team
---@param int_1 int
---@return handle
function CDOTAGamerules:GetAnnouncer(int_1) end

---Returns the hero unit names banned in this game, if any
---@return table
function CDOTAGamerules:GetBannedHeroes() end

---Returns the difficulty level of the custom game mode
---@return int
function CDOTAGamerules:GetCustomGameDifficulty() end

---Get whether a team is selectable during game setup
---@param int_1 int
---@return int
function CDOTAGamerules:GetCustomGameTeamMaxPlayers(int_1) end

---(b IncludePregameTime b IncludeNegativeTime) Returns the actual DOTA in-game clock time.返回Dota游戏内的时间。（是否包含赛前时间或负时间）
---@param IncludePregameTime  bool
---@param IncludeNegativeTime bool
---@return float
function CDOTAGamerules:GetDOTATime(IncludePregameTime , IncludeNegativeTime) end

---Returns difficulty level of the custom game mode
---@return int
function CDOTAGamerules:GetDifficulty() end

---Gets the Xth dropped item
---@param int_1 int
---@return handle
function CDOTAGamerules:GetDroppedItem(int_1) end

---Returns the number of seconds elapsed since the last frame was renderered. This time doesn`t count up when the game is paused
---@return float
function CDOTAGamerules:GetGameFrameTime() end

---Get the game mode entity
---@return handle
function CDOTAGamerules:GetGameModeEntity() end

---Get a string value from the game session config (map options)
---@param string_1 string
---@param string_2 string
---@return string
function CDOTAGamerules:GetGameSessionConfigValue(string_1, string_2) end

---Returns the number of seconds elapsed since map start. This time doesn`t count up when the game is paused
---@return float
function CDOTAGamerules:GetGameTime() end

---Get the stock count of the item
---@param int_1 int
---@param string_2 string
---@param int_3 int
---@return int
function CDOTAGamerules:GetItemStockCount(int_1, string_2, int_3) end

---Get the time it takes to add a new item to stock
---@param int_1 int
---@param string_2 string
---@param int_3 int
---@return float
function CDOTAGamerules:GetItemStockDuration(int_1, string_2, int_3) end

---Get the time an item will be added to stock
---@param int_1 int
---@param string_2 string
---@param int_3 int
---@return float
function CDOTAGamerules:GetItemStockTime(int_1, string_2, int_3) end

---Have we received the post match signout message that includes reward information
---@return bool
function CDOTAGamerules:GetMatchSignoutComplete() end

---Gets next bounty rune spawn time
---@return float
function CDOTAGamerules:GetNextBountyRuneSpawnTime() end

---Gets next rune spawn time
---@return float
function CDOTAGamerules:GetNextRuneSpawnTime() end

---For New Bloom, get total damage taken by the Nian / Year Beast
---@return int
function CDOTAGamerules:GetNianTotalDamageTaken() end

---(Preview/Unreleased) Gets the player`s custom game account record, as it looked at the start of this session
---@param int_1 int
---@return table
function CDOTAGamerules:GetPlayerCustomGameAccountRecord(int_1) end

---Get time remaining between state changes.
---@return float
function CDOTAGamerules:GetStateTransitionTime() end

---Get the time of day
---@return float
function CDOTAGamerules:GetTimeOfDay() end

---Get Weather Wind Direction Vector
---@return Vector
function CDOTAGamerules:GetWeatherWindDirection() end

---Increase an item`s stock count, clamped to item max (nTeamNumber, szItemName, nCount, nPlayerID .
---@param int_1 int
---@param string_2 string
---@param int_3 int
---@param int_4 int
---@return void
function CDOTAGamerules:IncreaseItemStock(int_1, string_2, int_3, int_4) end

---Are cheats enabled on the server
---@return bool
function CDOTAGamerules:IsCheatMode() end

---Is it day time?
---@return bool
function CDOTAGamerules:IsDaytime() end

---Returns whether the game is paused.
---@return bool
function CDOTAGamerules:IsGamePaused() end

---Returns whether hero respawn is enabled.
---@return bool
function CDOTAGamerules:IsHeroRespawnEnabled() end

---Are we in the ban phase of hero pick?
---@return bool
function CDOTAGamerules:IsInBanPhase() end

---Query an item in the whitelist
---@param string_1 string
---@return bool
function CDOTAGamerules:IsItemInWhiteList(string_1) end

---Is it night stalker night-time?
---@return bool
function CDOTAGamerules:IsNightstalkerNight() end

---Is it temporarily night-time?
---@return bool
function CDOTAGamerules:IsTemporaryNight() end

---Lock (true) or unlock (false) team assignemnt. If team assignment is locked players cannot change teams.
---@param bool_1 bool
---@return void
function CDOTAGamerules:LockCustomGameSetupTeamAssignment(bool_1) end

---Makes the specified team lose
---@param int_1 int
---@return void
function CDOTAGamerules:MakeTeamLose(int_1) end

---Like ModifyGold, but will use the gold filter if SetFilterMoreGold has been set true
---@param int_1 int
---@param int_2 int
---@param bool_3 bool
---@param int_4 int
---@return int
function CDOTAGamerules:ModifyGoldFiltered(int_1, int_2, bool_3, int_4) end

---Returns the number of items currently dropped on the ground
---@return int
function CDOTAGamerules:NumDroppedItems() end

---Whether a player has custom game host privileges (shuffle teams, etc.)
---@param handle_1 handle
---@return bool
function CDOTAGamerules:PlayerHasCustomGameHostPrivileges(handle_1) end

---Updates custom hero, unit and ability KeyValues in memory with the latest values from disk
---@return void
function CDOTAGamerules:Playtesting_UpdateAddOnKeyValues() end

---Prepare Dota lane style spawners with a given interval
---@param float_1 float
---@return void
function CDOTAGamerules:PrepareSpawners(float_1) end

---Removes a fake client
---@param int_1 int
---@return void
function CDOTAGamerules:RemoveFakeClient(int_1) end

---Remove an item from the whitelist
---@param string_1 string
---@return void
function CDOTAGamerules:RemoveItemFromWhiteList(string_1) end

---Restart after killing the ancient, etc.
---@return void
function CDOTAGamerules:ResetDefeated() end

---Restart gametime from 0
---@return void
function CDOTAGamerules:ResetGameTime() end

---Restart at custom game setup.
---@return void
function CDOTAGamerules:ResetToCustomGameSetup() end

---Restart the game at hero selection
---@return void
function CDOTAGamerules:ResetToHeroSelection() end

---Get the MatchID for this game.
---@return uint64
function CDOTAGamerules:Script_GetMatchID() end

---Sends a message on behalf of a player.
---@param string_1 string
---@param int_2 int
---@param int_3 int
---@return void
function CDOTAGamerules:SendCustomMessage(string_1, int_2, int_3) end

---Sends a message on behalf of a player to the specified team.
---@param string_1 string
---@param int_2 int
---@param int_3 int
---@param int_4 int
---@return void
function CDOTAGamerules:SendCustomMessageToTeam(string_1, int_2, int_3, int_4) end

---Allow Outposts granting XP
---@param bool_1 bool
---@return void
function CDOTAGamerules:SetAllowOutpostBonuses(bool_1) end

---(flMinimapCreepIconScale) - Scale the creep icons on the minimap.
---@param float_1 float
---@return void
function CDOTAGamerules:SetCreepMinimapIconScale(float_1) end

---Sets whether the regular Dota creeps spawn.
---@param bool_1 bool
---@return void
function CDOTAGamerules:SetCreepSpawningEnabled(bool_1) end

---(Preview/Unreleased) Sets a callback to handle saving custom game account records (callback is passed a Player ID and should return a flat simple table)
---@param handle_1 handle
---@param handle_2 handle
---@return void
function CDOTAGamerules:SetCustomGameAccountRecordSaveFunction(handle_1, handle_2) end

---Sets a flag to enable/disable the default music handling code for custom games
---@param bool_1 bool
---@return void
function CDOTAGamerules:SetCustomGameAllowBattleMusic(bool_1) end

---Sets a flag to enable/disable the default music handling code for custom games
---@param bool_1 bool
---@return void
function CDOTAGamerules:SetCustomGameAllowHeroPickMusic(bool_1) end

---Sets a flag to enable/disable the default music handling code for custom games
---@param bool_1 bool
---@return void
function CDOTAGamerules:SetCustomGameAllowMusicAtGameStart(bool_1) end

---Sets a flag to enable/disable the casting secondary abilities from units other than the player`s own hero.
---@param bool_1 bool
---@return void
function CDOTAGamerules:SetCustomGameAllowSecondaryAbilitiesOnOtherUnits(bool_1) end

---Set number of hero bans each team gets
---@param int_1 int
---@return void
function CDOTAGamerules:SetCustomGameBansPerTeam(int_1) end

---Set the difficulty level of the custom game mode
---@param int_1 int
---@return void
function CDOTAGamerules:SetCustomGameDifficulty(int_1) end

---Sets the game end delay.
---@param float_1 float
---@return void
function CDOTAGamerules:SetCustomGameEndDelay(float_1) end

---Set the amount of time to wait for auto launch.
---@param float_1 float
---@return void
function CDOTAGamerules:SetCustomGameSetupAutoLaunchDelay(float_1) end

---Set the amount of remaining time, in seconds, for custom game setup. 0 = finish immediately, -1 = wait forever
---@param float_1 float
---@return void
function CDOTAGamerules:SetCustomGameSetupRemainingTime(float_1) end

---Setup (pre-gameplay) phase timeout. 0 = instant, -1 = forever (until FinishCustomGameSetup is called)
---@param float_1 float
---@return void
function CDOTAGamerules:SetCustomGameSetupTimeout(float_1) end

---Set whether a team is selectable during game setup
---@param int_1 int
---@param int_2 int
---@return void
function CDOTAGamerules:SetCustomGameTeamMaxPlayers(int_1, int_2) end

---Sets the victory message.
---@param string_1 string
---@return void
function CDOTAGamerules:SetCustomVictoryMessage(string_1) end

---Sets the victory message duration.
---@param float_1 float
---@return void
function CDOTAGamerules:SetCustomVictoryMessageDuration(float_1) end

---Event-only ( table hMetadataTable )
---@param handle_1 handle
---@return bool
function CDOTAGamerules:SetEventMetadataCustomTable(handle_1) end

---Event-only ( table hMetadataTable )
---@param handle_1 handle
---@return bool
function CDOTAGamerules:SetEventSignoutCustomTable(handle_1) end

---Sets whether to filter more gold events than normal
---@param bool_1 bool
---@return void
function CDOTAGamerules:SetFilterMoreGold(bool_1) end

---Sets whether First Blood has been triggered.
---@param bool_1 bool
---@return void
function CDOTAGamerules:SetFirstBloodActive(bool_1) end

---Freeze the game time.
---@param bool_1 bool
---@return void
function CDOTAGamerules:SetGameTimeFrozen(bool_1) end

---Makes the specified team win
---@param int_1 int
---@return void
function CDOTAGamerules:SetGameWinner(int_1) end

---Set Glyph cooldown for team
---@param int_1 int
---@param float_2 float
---@return void
function CDOTAGamerules:SetGlyphCooldown(int_1, float_2) end

---Set the auto gold increase per timed interval.
---@param int_1 int
---@return void
function CDOTAGamerules:SetGoldPerTick(int_1) end

---Set the time interval between auto gold increases.
---@param float_1 float
---@return void
function CDOTAGamerules:SetGoldTickTime(float_1) end

---(flMinimapHeroIconScale) - Scale the hero minimap icons on the minimap.
---@param float_1 float
---@return void
function CDOTAGamerules:SetHeroMinimapIconScale(float_1) end

---Control if the normal DOTA hero respawn rules apply.
---@param bool_1 bool
---@return void
function CDOTAGamerules:SetHeroRespawnEnabled(bool_1) end

---Sets amount of penalty time before randoming a hero
---@param float_1 float
---@return void
function CDOTAGamerules:SetHeroSelectPenaltyTime(float_1) end

---Sets the amount of time players have to pick their hero.
---@param float_1 float
---@return void
function CDOTAGamerules:SetHeroSelectionTime(float_1) end

---Sets whether the multikill, streak, and first-blood banners appear at the top of the screen.
---@param bool_1 bool
---@return void
function CDOTAGamerules:SetHideKillMessageHeaders(bool_1) end

---Set whether custom and event games should ignore Lobby teams when assigning players to teams. Defaults to true.
---@param bool_1 bool
---@return void
function CDOTAGamerules:SetIgnoreLobbyTeamsInCustomGame(bool_1) end

---Set the stock count of the item
---@param int_1 int
---@param int_2 int
---@param string_3 string
---@param int_4 int
---@return void
function CDOTAGamerules:SetItemStockCount(int_1, int_2, string_3, int_4) end

---Sets next bounty rune spawn time
---@param float_1 float
---@return void
function CDOTAGamerules:SetNextBountyRuneSpawnTime(float_1) end

---Sets next rune spawn time
---@param float_1 float
---@return void
function CDOTAGamerules:SetNextRuneSpawnTime(float_1) end

---Show this unit`s health on the overlay health bar
---@param handle_1 handle
---@param int_2 int
---@return void
function CDOTAGamerules:SetOverlayHealthBarUnit(handle_1, int_2) end

---Sets the amount of time players have between the game ending and the server disconnecting them.
---@param float_1 float
---@return void
function CDOTAGamerules:SetPostGameTime(float_1) end

---Sets the amount of time players have between picking their hero and game start.
---@param float_1 float
---@return void
function CDOTAGamerules:SetPreGameTime(float_1) end

---(flMinimapRuneIconScale) - Scale the rune icons on the minimap.
---@param float_1 float
---@return void
function CDOTAGamerules:SetRuneMinimapIconScale(float_1) end

---Sets the amount of time between rune spawns.
---@param float_1 float
---@return void
function CDOTAGamerules:SetRuneSpawnTime(float_1) end

---(bSafeToLeave) - Mark this game as safe to leave.
---@param bool_1 bool
---@return void
function CDOTAGamerules:SetSafeToLeave(bool_1) end

---When true, players can repeatedly pick the same hero.
---@param bool_1 bool
---@return void
function CDOTAGamerules:SetSameHeroSelectionEnabled(bool_1) end

---Sets the amount of time players have between the strategy phase and entering the pre-game phase.
---@param float_1 float
---@return void
function CDOTAGamerules:SetShowcaseTime(float_1) end

---Set whether to speak a Spawn concept instead of a Respawn concept on respawn.
---@param bool_1 bool
---@return void
function CDOTAGamerules:SetSpeechUseSpawnInsteadOfRespawnConcept(bool_1) end

---Set the starting gold amount.
---@param int_1 int
---@return void
function CDOTAGamerules:SetStartingGold(int_1) end

---Sets the amount of time players have between the hero selection and entering the showcase phase.
---@param float_1 float
---@return void
function CDOTAGamerules:SetStrategyTime(float_1) end

---设置一天的时间(0到1)，当值小于0.25和大于0.75时为晚上，反之为白天。
---@param float_1 float
---@return void
function CDOTAGamerules:SetTimeOfDay(float_1) end

---Sets the tree regrow time in seconds.
---@param float_1 float
---@return void
function CDOTAGamerules:SetTreeRegrowTime(float_1) end

---Heroes will use the basic NPC functionality for determining their bounty, rather than DOTA specific formulas.
---@param bool_1 bool
---@return void
function CDOTAGamerules:SetUseBaseGoldBountyOnHeroes(bool_1) end

---Allows heroes in the map to give a specific amount of XP (this value must be set).
---@param bool_1 bool
---@return void
function CDOTAGamerules:SetUseCustomHeroXPValues(bool_1) end

---When true, all items are available at as long as any shop is in range.
---@param bool_1 bool
---@return void
function CDOTAGamerules:SetUseUniversalShopMode(bool_1) end

---Set Weather Wind Direction Vector
---@param Vector_1 Vector
---@return void
function CDOTAGamerules:SetWeatherWindDirection(Vector_1) end

---Item whitelist functionality enable/disable
---@param bool_1 bool
---@return void
function CDOTAGamerules:SetWhiteListEnabled(bool_1) end

---Spawn and release the next creep wave from Dota lane style spawners.
---@return void
function CDOTAGamerules:SpawnAndReleaseCreeps() end

---Spawn and release the next set of neutral camps.
---@return void
function CDOTAGamerules:SpawnNeutralCreeps() end

---Get the current Gamerules state
---@return int
function CDOTAGamerules:State_Get() end

---@class CDOTAPlayer : CBaseAnimating
---Attempt to spawn the appropriate couriers for this mode.
---@param hHero handle
---@return void
function CDOTAPlayer:CheckForCourierSpawning(hHero) end

---Get the player`s hero.
---@return handle
function CDOTAPlayer:GetAssignedHero() end

---Get the player`s official PlayerID; notably is -1 when the player isn`t yet on a team.
---@return int
function CDOTAPlayer:GetPlayerID() end

---Randoms this player`s hero.
---@return void
function CDOTAPlayer:MakeRandomHeroSelection() end

---Sets this player`s hero .
---@param hHero handle
---@return void
function CDOTAPlayer:SetAssignedHeroEntity(hHero) end

---Set the kill cam unit for this hero.
---@param hEntity handle
---@return void
function CDOTAPlayer:SetKillCamUnit(hEntity) end

---(nMusicStatus, flIntensity) - Set the music status for this player, note this will only really apply if dota_music_battle_enable is off.
---@param nMusicStatus int
---@param flIntensity float
---@return void
function CDOTAPlayer:SetMusicStatus(nMusicStatus, flIntensity) end

---Sets this player`s hero selection.
---@param pszHeroName string
---@return void
function CDOTAPlayer:SetSelectedHero(pszHeroName) end

---Spawn a courier for this player at the given position.
---@param vLocation Vector
---@return handle
function CDOTAPlayer:SpawnCourierAtPosition(vLocation) end

---@class CDOTATutorial
---Add a computer controlled bot.
---@param string_1 string
---@param string_2 string
---@param string_3 string
---@param bool_4 bool
---@return bool
function CDOTATutorial:AddBot(string_1, string_2, string_3, bool_4) end

---Add a quest to the quest log
---@param string_1 string
---@param int_2 int
---@param string_3 string
---@param string_4 string
---@return void
function CDOTATutorial:AddQuest(string_1, int_2, string_3, string_4) end

---Add an item to the shop whitelist.
---@param string_1 string
---@return void
function CDOTATutorial:AddShopWhitelistItem(string_1) end

---Complete a quest,
---@param string_1 string
---@return void
function CDOTATutorial:CompleteQuest(string_1) end

---Add a task to move to a specific location
---@param Vector_1 Vector
---@return void
function CDOTATutorial:CreateLocationTask(Vector_1) end

---Alert the player when a creep becomes agro to their hero.
---@param bool_1 bool
---@return void
function CDOTATutorial:EnableCreepAggroViz(bool_1) end

---Enable the tip to alert players how to find their hero.
---@param bool_1 bool
---@return void
function CDOTATutorial:EnablePlayerOffscreenTip(bool_1) end

---Alert the player when a tower becomes agro to their hero.
---@param bool_1 bool
---@return void
function CDOTATutorial:EnableTowerAggroViz(bool_1) end

---End the tutorial.
---@return void
function CDOTATutorial:FinishTutorial() end

---Force the start of the game.
---@return void
function CDOTATutorial:ForceGameStart() end

---Is our time frozen?
---@return bool
function CDOTATutorial:GetTimeFrozen() end

---Is this item currently in the white list.
---@param string_1 string
---@return bool
function CDOTATutorial:IsItemInWhiteList(string_1) end

---Remove an item from the shop whitelist.
---@param string_1 string
---@return void
function CDOTATutorial:RemoveShopWhitelistItem(string_1) end

---Select a hero for the local player
---@param string_1 string
---@return void
function CDOTATutorial:SelectHero(string_1) end

---Select the team for the local player
---@param string_1 string
---@return void
function CDOTATutorial:SelectPlayerTeam(string_1) end

---Set the current item guide.
---@param string_1 string
---@return void
function CDOTATutorial:SetItemGuide(string_1) end

---Set gold amount for the tutorial player. (int) GoldAmount, (bool) true=Set, false=Modify
---@param int_1 int
---@param bool_2 bool
---@return void
function CDOTATutorial:SetOrModifyPlayerGold(int_1, bool_2) end

---Set players quick buy item.
---@param string_1 string
---@return void
function CDOTATutorial:SetQuickBuy(string_1) end

---Set the shop open or closed.
---@param bool_1 bool
---@return void
function CDOTATutorial:SetShopOpen(bool_1) end

---Set if we should freeze time or not.
---@param bool_1 bool
---@return void
function CDOTATutorial:SetTimeFrozen(bool_1) end

---Set a tutorial convar
---@param string_1 string
---@param string_2 string
---@return void
function CDOTATutorial:SetTutorialConvar(string_1, string_2) end

---Set the UI to use a reduced version to focus attention to specific elements.
---@param int_1 int
---@return void
function CDOTATutorial:SetTutorialUI(int_1) end

---Set if we should whitelist shop items.
---@param bool_1 bool
---@return void
function CDOTATutorial:SetWhiteListEnabled(bool_1) end

---Initialize Tutorial Mode
---@return void
function CDOTATutorial:StartTutorialMode() end

---Upgrade a specific ability for the local hero
---@param string_1 string
---@return void
function CDOTATutorial:UpgradePlayerAbility(string_1) end

---@class CDOTAVoteSystem
---Starts a vote, based upon a table of parameters
---@param handle_1 handle
---@return void
function CDOTAVoteSystem:StartVote(handle_1) end

---@class CDOTA_Ability_Aghanim_Spear
---Launch Spear to a target position from a source position
---@param vTarget Vector
---@param vStart Vector
---@return void
function CDOTA_Ability_Aghanim_Spear:LaunchSpear(vTarget, vStart) end

---@class CDOTA_Ability_Animation_Attack : CDOTABaseAbility
---Override playbackrate
---@param flRate float
---@return void
function CDOTA_Ability_Animation_Attack:SetPlaybackRate(flRate) end

---@class CDOTA_Ability_Animation_TailSpin : CDOTABaseAbility
---Override playbackrate
---@param flRate float
---@return void
function CDOTA_Ability_Animation_TailSpin:SetPlaybackRate(flRate) end

---@class CDOTA_Ability_DataDriven : CDOTABaseAbility
---Applies a data driven modifier to the target
---@param hCaster handle
---@param hTarget handle
---@param pszModifierName string
---@param hModifierTable handle
---@return handle
function CDOTA_Ability_DataDriven:ApplyDataDrivenModifier(hCaster, hTarget, pszModifierName, hModifierTable) end

---Applies a data driven thinker at the location
---@param hCaster handle
---@param vLocation Vector
---@param pszModifierName string
---@param hModifierTable handle
---@return handle
function CDOTA_Ability_DataDriven:ApplyDataDrivenThinker(hCaster, vLocation, pszModifierName, hModifierTable) end

---@class CDOTA_Ability_Lua : CDOTABaseAbility
---Determine whether an issued command with no target is valid.
---@return int
function CDOTA_Ability_Lua:CastFilterResult() end

---(Vector vLocation) Determine whether an issued command on a location is valid.
---@param vLocation Vector
---@return int
function CDOTA_Ability_Lua:CastFilterResultLocation(vLocation) end

---(HSCRIPT hTarget) Determine whether an issued command on a target is valid.
---@param hTarget handle
---@return int
function CDOTA_Ability_Lua:CastFilterResultTarget(hTarget) end

---Controls the size of the AOE casting cursor.
---@return float
function CDOTA_Ability_Lua:GetAOERadius() end

---Allows code overriding of the ability texture shown in the HUD.
---@return string
function undefined:GetAbilityTextureName() end

---Returns abilities that are stolen simultaneously, or otherwise related in functionality.
---@return string
function CDOTA_Ability_Lua:GetAssociatedPrimaryAbilities() end

---Returns other abilities that are stolen simultaneously, or otherwise related in functionality.  Generally hidden abilities.
---@return string
function CDOTA_Ability_Lua:GetAssociatedSecondaryAbilities() end

---Return cast behavior type of this ability.
---@return uint64
function CDOTA_Ability_Lua:GetBehavior() end

---Return casting animation of this ability.
---@return int
function CDOTA_Ability_Lua:GetCastAnimation() end

---Return cast point of this ability.
---@return float
function CDOTA_Ability_Lua:GetCastPoint() end

---Return cast range of this ability.
---@param vLocation Vector
---@param hTarget handle
---@return int
function CDOTA_Ability_Lua:GetCastRange(vLocation, hTarget) end

---Return channel animation of this ability.
---@return int
function CDOTA_Ability_Lua:GetChannelAnimation() end

---Return the channel time of this ability.
---@return float
function CDOTA_Ability_Lua:GetChannelTime() end

---Return mana cost at the given level per second while channeling (-1 is current).
---@param iLevel int
---@return int
function CDOTA_Ability_Lua:GetChannelledManaCostPerSecond(iLevel) end

---Return who hears speech when this spell is cast.
---@return int
function CDOTA_Ability_Lua:GetConceptRecipientType() end

---Return cooldown of this ability.
---@param iLevel int
---@return float
function CDOTA_Ability_Lua:GetCooldown(iLevel) end

---Return the error string of a failed command with no target.
---@return string
function CDOTA_Ability_Lua:GetCustomCastError() end

---(Vector vLocation) Return the error string of a failed command on a location.
---@param vLocation Vector
---@return string
function CDOTA_Ability_Lua:GetCustomCastErrorLocation(vLocation) end

---(HSCRIPT hTarget) Return the error string of a failed command on a target.
---@param hTarget handle
---@return string
function CDOTA_Ability_Lua:GetCustomCastErrorTarget(hTarget) end

---Return gold cost at the given level (-1 is current).
---@param iLevel int
---@return int
function CDOTA_Ability_Lua:GetGoldCost(iLevel) end

---返回此技能被动给予的修饰器的名称
---@return string
function CDOTA_Ability_Lua:GetIntrinsicModifierName() end

---Return mana cost at the given level (-1 is current).
---@param iLevel int
---@return int
function CDOTA_Ability_Lua:GetManaCost(iLevel) end

---Return the animation rate of the cast animation.
---@return float
function CDOTA_Ability_Lua:GetPlaybackRateOverride() end

---Is this a cosmetic only ability?
---@param hEntity handle
---@return bool
function CDOTA_Ability_Lua:IsCosmetic(hEntity) end

---Returns true if this ability can be used when not on the action panel.
---@return bool
function CDOTA_Ability_Lua:IsHiddenAbilityCastable() end

---Returns true if this ability is hidden when stolen by Spell Steal.
---@return bool
function CDOTA_Ability_Lua:IsHiddenWhenStolen() end

---Returns true if this ability is refreshed by Refresher Orb.
---@return bool
function CDOTA_Ability_Lua:IsRefreshable() end

---Returns true if this ability can be stolen by Spell Steal.
---@return bool
function CDOTA_Ability_Lua:IsStealable() end

---Cast time did not complete successfully.
---@return void
function CDOTA_Ability_Lua:OnAbilityPhaseInterrupted() end

---Cast time begins (return true for successful cast).
---@return bool
function CDOTA_Ability_Lua:OnAbilityPhaseStart() end

---The ability was pinged (nPlayerID, bCtrlHeld).
---@param nPlayerID int
---@param bCtrlHeld bool
---@return void
function CDOTA_Ability_Lua:OnAbilityPinged(nPlayerID, bCtrlHeld) end

---(bool bInterrupted) Channel finished.
---@param bInterrupted bool
---@return void
function CDOTA_Ability_Lua:OnChannelFinish(bInterrupted) end

---(float flInterval) Channeling is taking place.
---@param flInterval float
---@return void
function CDOTA_Ability_Lua:OnChannelThink(flInterval) end

---Caster (hero only) gained a level, skilled an ability, or received a new stat bonus.
---@return void
function CDOTA_Ability_Lua:OnHeroCalculateStatBonus() end

---A hero has died in the vicinity (ie Urn), takes table of params.
---@param unit handle
---@param attacker handle
---@param table handle
---@return void
function CDOTA_Ability_Lua:OnHeroDiedNearby(unit, attacker, table) end

---Caster gained a level.
---@return void
function CDOTA_Ability_Lua:OnHeroLevelUp() end

---当技能拥有者物品栏中的物品发生变化时触发。物品移动物品栏位置或移动到储藏处时会触发一次，丢下和拾取物品时会额外触发一次。
---@return void
function CDOTA_Ability_Lua:OnInventoryContentsChanged() end

---当技能拥有者装备一件物品时触发
---@param hItem handle
---@return void
function CDOTA_Ability_Lua:OnItemEquipped(hItem) end

---Caster died.
---@return void
function CDOTA_Ability_Lua:OnOwnerDied() end

---Caster respawned or spawned for the first time.
---@return void
function CDOTA_Ability_Lua:OnOwnerSpawned() end

---(HSCRIPT hTarget, Vector vLocation) Projectile has collided with a given target or reached its destination (target is invalid).
---@param hTarget CDOTA_BaseNPC
---@param vLocation Vector
---@return bool
function CDOTA_Ability_Lua:OnProjectileHit(hTarget, vLocation) end

---(HSCRIPT hTarget, Vector vLocation, int nHandle) Projectile has collided with a given target or reached its destination (target is invalid).
---@param hTarget handle
---@param vLocation Vector
---@param iProjectileHandle int
---@return bool
function CDOTA_Ability_Lua:OnProjectileHitHandle(hTarget, vLocation, iProjectileHandle) end

---当投射物命中目标或者到达最远距离（此时hTarget为无效值）
---@param hTarget handle
---@param vLocation Vector
---@param ExtraData handle
---@return bool
function CDOTA_Ability_Lua:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData) end

---(Vector vLocation) Projectile is actively moving.
---@param vLocation Vector
---@return void
function CDOTA_Ability_Lua:OnProjectileThink(vLocation) end

---(int nProjectileHandle) Projectile is actively moving.
---@param iProjectileHandle int
---@return void
function CDOTA_Ability_Lua:OnProjectileThinkHandle(iProjectileHandle) end

---(Vector vLocation, table kv ) Projectile is actively moving.
---@param vLocation Vector
---@param table handle
---@return void
function CDOTA_Ability_Lua:OnProjectileThink_ExtraData(vLocation, table) end

---Cast time finished, spell effects begin.
---@return void
function CDOTA_Ability_Lua:OnSpellStart() end

---( HSCRIPT hAbility ) Special behavior when stolen by Spell Steal.
---@param hSourceAbility handle
---@return void
function CDOTA_Ability_Lua:OnStolen(hSourceAbility) end

---Ability is toggled on/off.
---@return void
function CDOTA_Ability_Lua:OnToggle() end

---Special behavior when lost by Spell Steal.
---@return void
function CDOTA_Ability_Lua:OnUnStolen() end

---Ability gained a level.
---@return void
function CDOTA_Ability_Lua:OnUpgrade() end

---
---@return bool
function CDOTA_Ability_Lua:OtherAbilitiesAlwaysInterruptChanneling() end

---Returns true if this ability will generate magic stick charges for nearby enemies.
---@return bool
function CDOTA_Ability_Lua:ProcsMagicStick() end

---Does this ability need the caster to face the target before executing?
---@return bool
function CDOTA_Ability_Lua:RequiresFacing() end

---Returns true if this ability should return to the default toggle state when its parent respawns.
---@return bool
function CDOTA_Ability_Lua:ResetToggleOnRespawn() end

---Return the type of speech used.
---@return int
function CDOTA_Ability_Lua:SpeakTrigger() end

---@class CDOTA_Ability_Nian_Dive : CDOTABaseAbility
---Override playbackrate
---@param flRate float
---@return void
function CDOTA_Ability_Nian_Dive:SetPlaybackRate(flRate) end

---@class CDOTA_Ability_Nian_Leap : CDOTABaseAbility
---Override playbackrate
---@param flRate float
---@return void
function CDOTA_Ability_Nian_Leap:SetPlaybackRate(flRate) end

---@class CDOTA_Ability_Nian_Roar : CDOTABaseAbility
---Number of times Nian has used the roar
---@return int
function CDOTA_Ability_Nian_Roar:GetCastCount() end

---@class CDOTA_BaseNPC : CBaseFlex
---给单位添加技能
---@param sAbilityName string
---@return handle
function CDOTA_BaseNPC:AddAbility(sAbilityName) end

---添加一个activity modifier，该activity modifier会影响以后的StartGesture的调用。该值可以在模型编辑器中模型动作的Activities查看。
---@param sName string
---@return void
function CDOTA_BaseNPC:AddActivityModifier(sName) end

---给单位添加一个物品
---@param hItem handle
---@return handle
function CDOTA_BaseNPC:AddItem(hItem) end

---给单位添加一个物品，直接传入物品名字即可，返回创建的物品实体。
---@param sItemName string
---@return handle
function CDOTA_BaseNPC:AddItemByName(sItemName) end

---给一个单位添加modifier，hModifierTable可以传入持续时间和其他自定义参数，自定义参数可以在modifier的server端获得。
---@param hCaster handle
---@param hAbility handle
---@param pszScriptName string
---@param hModifierTable handle
---@return handle
function CDOTA_BaseNPC:AddNewModifier(hCaster, hAbility, pszScriptName, hModifierTable) end

---添加不渲染的标记，使该单位不显示。比如黑鸟的关。
---@return void
function CDOTA_BaseNPC:AddNoDraw() end

---Add a speech bubble(1-4 live at a time) to this NPC.
---@param iBubble int
---@param pszSpeech string
---@param flDuration float
---@param unOffsetX unsigned
---@param unOffsetY unsigned
---@return void
function CDOTA_BaseNPC:AddSpeechBubble(iBubble, pszSpeech, flDuration, unOffsetX, unOffsetY) end

---
---@param hAttacker handle
---@param hAbility handle
---@return void
function CDOTA_BaseNPC:AlertNearbyUnits(hAttacker, hAbility) end

---
---@return void
function CDOTA_BaseNPC:AngerNearbyUnits() end

---
---@param flTime float
---@return void
function CDOTA_BaseNPC:AttackNoEarlierThan(flTime) end

---
---@return bool
function CDOTA_BaseNPC:AttackReady() end

---
---@return float
function CDOTA_BaseNPC:BoundingRadius2D() end

---
---@return void
function CDOTA_BaseNPC:CalculateGenericBonuses() end

---Check FoW to see if an entity is visible.
---@param hEntity handle
---@return bool
function CDOTA_BaseNPC:CanEntityBeSeenByMyTeam(hEntity) end

---Query if this unit can sell items.
---@return bool
function CDOTA_BaseNPC:CanSellItems() end

---Cast an ability immediately.
---@param hAbility handle
---@param iPlayerIndex int
---@return void
function CDOTA_BaseNPC:CastAbilityImmediately(hAbility, iPlayerIndex) end

---Cast an ability with no target.
---@param hAbility handle
---@param iPlayerIndex int
---@return void
function CDOTA_BaseNPC:CastAbilityNoTarget(hAbility, iPlayerIndex) end

---Cast an ability on a position.
---@param vPosition Vector
---@param hAbility handle
---@param iPlayerIndex int
---@return void
function CDOTA_BaseNPC:CastAbilityOnPosition(vPosition, hAbility, iPlayerIndex) end

---Cast an ability on a target entity.
---@param hTarget handle
---@param hAbility handle
---@param iPlayerIndex int
---@return void
function CDOTA_BaseNPC:CastAbilityOnTarget(hTarget, hAbility, iPlayerIndex) end

---Toggle an ability.
---@param hAbility handle
---@param iPlayerIndex int
---@return void
function CDOTA_BaseNPC:CastAbilityToggle(hAbility, iPlayerIndex) end

---
---@param iTeamNum int
---@return void
function CDOTA_BaseNPC:ChangeTeam(iTeamNum) end

---Clear Activity modifiers
---@return void
function CDOTA_BaseNPC:ClearActivityModifiers() end

---
---@return void
function CDOTA_BaseNPC:DestroyAllSpeechBubbles() end

---Disassemble the passed item in this unit`s inventory.
---@param hItem handle
---@return void
function CDOTA_BaseNPC:DisassembleItem(hItem) end

---Drop an item at a given point.
---@param vDest Vector
---@param hItem handle
---@return void
function CDOTA_BaseNPC:DropItemAtPosition(vDest, hItem) end

---Immediately drop a carried item at a given position.
---@param hItem handle
---@param vPosition Vector
---@return void
function CDOTA_BaseNPC:DropItemAtPositionImmediate(hItem, vPosition) end

---Drops the selected item out of this unit`s stash.
---@param hItem handle
---@return void
function CDOTA_BaseNPC:EjectItemFromStash(hItem) end

---This unit will be set to face the target point.
---@param vTarget Vector
---@return void
function CDOTA_BaseNPC:FaceTowards(vTarget) end

---Fade and remove the given gesture activity.
---@param nActivity int
---@return void
function CDOTA_BaseNPC:FadeGesture(nActivity) end

---从单位身上寻找技能
---@param sAbilityName string
---@return handle
function CDOTA_BaseNPC:FindAbilityByName(sAbilityName) end

---Returns a table of all of the modifiers on the NPC.
---@return table
function CDOTA_BaseNPC:FindAllModifiers() end

---Returns a table of all of the modifiers on the NPC with the passed name (modifierName)
---@param pszScriptName string
---@return table
function CDOTA_BaseNPC:FindAllModifiersByName(pszScriptName) end

---Get handle to first item in inventory, else nil.
---@param pszItemName string
---@return handle
function CDOTA_BaseNPC:FindItemInInventory(pszItemName) end

---Return a handle to the modifier of the given name if found, else nil (string Name )
---@param pszScriptName string
---@return handle
function CDOTA_BaseNPC:FindModifierByName(pszScriptName) end

---Return a handle to the modifier of the given name from the passed caster if found, else nil ( string Name, hCaster )
---@param pszScriptName string
---@param hCaster handle
---@return handle
function CDOTA_BaseNPC:FindModifierByNameAndCaster(pszScriptName, hCaster) end

---Kill this unit immediately.
---@param bReincarnate bool
---@return void
function CDOTA_BaseNPC:ForceKill(bReincarnate) end

---Play an activity once, and then go back to idle.
---@param nActivity int
---@return void
function CDOTA_BaseNPC:ForcePlayActivityOnce(nActivity) end

---通过技能索引值获取该单位身上的技能。
---@param iIndex int
---@return handle
function CDOTA_BaseNPC:GetAbilityByIndex(iIndex) end

---
---@return int
function CDOTA_BaseNPC:GetAbilityCount() end

---Gets the range at which this unit will auto-acquire.
---@return float
function CDOTA_BaseNPC:GetAcquisitionRange() end

---Combat involving this creature will have this weight added to the music calcuations.
---@return float
function CDOTA_BaseNPC:GetAdditionalBattleMusicWeight() end

---Returns this unit`s aggro target.
---@return handle
function CDOTA_BaseNPC:GetAggroTarget() end

---
---@return float
function CDOTA_BaseNPC:GetAttackAnimationPoint() end

---
---@return int
function CDOTA_BaseNPC:GetAttackCapability() end

---返回介于单位的最小和最大基础伤害之间的随机整数。
---@return int
function CDOTA_BaseNPC:GetAttackDamage() end

---Gets the attack range buffer.
---@return float
function CDOTA_BaseNPC:GetAttackRangeBuffer() end

---
---@return float
function CDOTA_BaseNPC:GetAttackSpeed() end

---
---@return handle
function CDOTA_BaseNPC:GetAttackTarget() end

---获取每秒攻击次数
---@return float
function CDOTA_BaseNPC:GetAttacksPerSecond() end

---返回攻击力的平均值（包括绿字）。
---@param hTarget handle
---@return int
function CDOTA_BaseNPC:GetAverageTrueAttackDamage(hTarget) end

---
---@return int
function CDOTA_BaseNPC:GetBaseAttackRange() end

---
---@return float
function CDOTA_BaseNPC:GetBaseAttackTime() end

---获取基础最大攻击力。
---@return int
function CDOTA_BaseNPC:GetBaseDamageMax() end

---获取基础最小攻击力。
---@return int
function CDOTA_BaseNPC:GetBaseDamageMin() end

---Returns the vision range before modifiers.
---@return int
function CDOTA_BaseNPC:GetBaseDayTimeVisionRange() end

---获取基础生命回复。
---@return float
function CDOTA_BaseNPC:GetBaseHealthRegen() end

---获取基础魔抗。
---@return float
function CDOTA_BaseNPC:GetBaseMagicalResistanceValue() end

---Gets the base max health value.
---@return float
function CDOTA_BaseNPC:GetBaseMaxHealth() end

---获取基础移动速度。
---@return float
function CDOTA_BaseNPC:GetBaseMoveSpeed() end

---Returns the vision range after modifiers.
---@return int
function CDOTA_BaseNPC:GetBaseNightTimeVisionRange() end

---This Mana regen is derived from constant bonuses like Basilius.
---@return float
function CDOTA_BaseNPC:GetBonusManaRegen() end

---
---@param bAttack bool
---@return float
function CDOTA_BaseNPC:GetCastPoint(bAttack) end

---
---@return float
function CDOTA_BaseNPC:GetCastRangeBonus() end

---Get clone source (Meepo Prime, if this is a Meepo)
---@return handle
function CDOTA_BaseNPC:GetCloneSource() end

---Returns the size of the collision padding around the hull.
---@return float
function CDOTA_BaseNPC:GetCollisionPadding() end

---
---@return float
function CDOTA_BaseNPC:GetCooldownReduction() end

---
---@return float
function CDOTA_BaseNPC:GetCreationTime() end

---Get the ability this unit is currently casting.
---@return handle
function CDOTA_BaseNPC:GetCurrentActiveAbility() end

---Gets the current vision range.
---@return int
function CDOTA_BaseNPC:GetCurrentVisionRange() end

---
---@return handle
function CDOTA_BaseNPC:GetCursorCastTarget() end

---
---@return Vector
function CDOTA_BaseNPC:GetCursorPosition() end

---
---@return bool
function CDOTA_BaseNPC:GetCursorTargetingNothing() end

---Get the maximum attack damage of this unit.
---@return int
function CDOTA_BaseNPC:GetDamageMax() end

---Get the minimum attack damage of this unit.
---@return int
function CDOTA_BaseNPC:GetDamageMin() end

---Returns the vision range after modifiers.
---@return int
function CDOTA_BaseNPC:GetDayTimeVisionRange() end

---Get the XP bounty on this unit.
---@return int
function CDOTA_BaseNPC:GetDeathXP() end

---Attack speed expressed as constant value
---@return float
function CDOTA_BaseNPC:GetDisplayAttackSpeed() end

---
---@return float
function CDOTA_BaseNPC:GetEvasion() end

---
---@return handle
function CDOTA_BaseNPC:GetForceAttackTarget() end

---Get the gold bounty on this unit.
---@return int
function CDOTA_BaseNPC:GetGoldBounty() end

---
---@return float
function CDOTA_BaseNPC:GetHasteFactor() end

---返回单位已损失生命值。
---@return int
function CDOTA_BaseNPC:GetHealthDeficit() end

---Get the current health percent of the unit.
---@return int
function CDOTA_BaseNPC:GetHealthPercent() end

---
---@return float
function CDOTA_BaseNPC:GetHealthRegen() end

---Get the collision hull radius of this NPC.
---@return float
function CDOTA_BaseNPC:GetHullRadius() end

---Returns speed after all modifiers.
---@return float
function CDOTA_BaseNPC:GetIdealSpeed() end

---Returns speed after all modifiers, but excluding those that reduce speed.
---@return float
function CDOTA_BaseNPC:GetIdealSpeedNoSlows() end

---
---@return float
function CDOTA_BaseNPC:GetIncreasedAttackSpeed() end

---Returns the initial waypoint goal for this NPC.
---@return handle
function CDOTA_BaseNPC:GetInitialGoalEntity() end

---Get waypoint position for this NPC.
---@return Vector
function CDOTA_BaseNPC:GetInitialGoalPosition() end

---Returns nth item in inventory slot (index is zero based).
---@param i int
---@return handle
function CDOTA_BaseNPC:GetItemInSlot(i) end

---
---@return float
function CDOTA_BaseNPC:GetLastAttackTime() end

---Get the last time this NPC took damage
---@return float
function CDOTA_BaseNPC:GetLastDamageTime() end

---Get the last game time that this unit switched to/from idle state.
---@return float
function CDOTA_BaseNPC:GetLastIdleChangeTime() end

---Returns the level of this unit.
---@return int
function CDOTA_BaseNPC:GetLevel() end

---Returns current magical armor value.
---@return float
function CDOTA_BaseNPC:GetMagicalArmorValue() end

---Returns the player ID of the controlling player.
---@return int
function CDOTA_BaseNPC:GetMainControllingPlayer() end

---Get the mana on this unit.
---@return float
function CDOTA_BaseNPC:GetMana() end

---Get the percent of mana remaining.
---@return int
function CDOTA_BaseNPC:GetManaPercent() end

---
---@return float
function CDOTA_BaseNPC:GetManaRegen() end

---Get the maximum mana of this unit.
---@return float
function CDOTA_BaseNPC:GetMaxMana() end

---Get the maximum gold bounty for this unit.
---@return int
function CDOTA_BaseNPC:GetMaximumGoldBounty() end

---Get the minimum gold bounty for this unit.
---@return int
function CDOTA_BaseNPC:GetMinimumGoldBounty() end

---
---@return float
function CDOTA_BaseNPC:GetModelRadius() end

---How many modifiers does this unit have?
---@return int
function CDOTA_BaseNPC:GetModifierCount() end

---Get a modifier name by index.
---@param nIndex int
---@return string
function CDOTA_BaseNPC:GetModifierNameByIndex(nIndex) end

---Gets the stack count of a given modifier.
---@param pszScriptName string
---@param hCaster handle
---@return int
function CDOTA_BaseNPC:GetModifierStackCount(pszScriptName, hCaster) end

---
---@param flBaseSpeed float
---@param bReturnUnslowed bool
---@return float
function CDOTA_BaseNPC:GetMoveSpeedModifier(flBaseSpeed, bReturnUnslowed) end

---Set whether this NPC is required to reach each goal entity, rather than being allowed to unkink their path.
---@return bool
function CDOTA_BaseNPC:GetMustReachEachGoalEntity() end

---Get the name of this camp`s neutral spawner.
---@return string
function CDOTA_BaseNPC:GetNeutralSpawnerName() end

---If set to true, we will never attempt to move this unit to clear space, even when it unphases.
---@return bool
function CDOTA_BaseNPC:GetNeverMoveToClearSpace() end

---Returns the vision range after modifiers.
---@return int
function CDOTA_BaseNPC:GetNightTimeVisionRange() end

---获取敌方的队伍编号
---@return int
function CDOTA_BaseNPC:GetOpposingTeamNumber() end

---Get the collision hull radius (including padding) of this NPC.
---@return float
function CDOTA_BaseNPC:GetPaddedCollisionRadius() end

---Returns base physical armor value.
---@return float
function CDOTA_BaseNPC:GetPhysicalArmorBaseValue() end

---Returns current physical armor value.
---@param bIgnoreBase bool
---@return float
function CDOTA_BaseNPC:GetPhysicalArmorValue(bIgnoreBase) end

---Returns the player that owns this unit.
---@return handle
function CDOTA_BaseNPC:GetPlayerOwner() end

---Get the owner player ID for this unit.
---@return int
function CDOTA_BaseNPC:GetPlayerOwnerID() end

---
---@return int
function CDOTA_BaseNPC:GetProjectileSpeed() end

---
---@param hNPC handle
---@return float
function CDOTA_BaseNPC:GetRangeToUnit(hNPC) end

---
---@return string
function CDOTA_BaseNPC:GetRangedProjectileName() end

---
---@return float
function CDOTA_BaseNPC:GetSecondsPerAttack() end

---
---@param bBaseOnly bool
---@return float
function CDOTA_BaseNPC:GetSpellAmplification(bBaseOnly) end

---
---@return float
function CDOTA_BaseNPC:GetStatusResistance() end

---Get how much gold has been spent on ability upgrades.
---@return int
function CDOTA_BaseNPC:GetTotalPurchasedUpgradeGoldCost() end

---
---@return string
function CDOTA_BaseNPC:GetUnitLabel() end

---Get the name of this unit.
---@return string
function CDOTA_BaseNPC:GetUnitName() end

---Give mana to this unit, this can be used for mana gained by abilities or item usage.
---@param flMana float
---@return void
function CDOTA_BaseNPC:GiveMana(flMana) end

---See whether this unit has an ability by name.
---@param pszAbilityName string
---@return bool
function CDOTA_BaseNPC:HasAbility(pszAbilityName) end

---
---@return bool
function CDOTA_BaseNPC:HasAnyActiveAbilities() end

---
---@return bool
function CDOTA_BaseNPC:HasAttackCapability() end

---
---@return bool
function CDOTA_BaseNPC:HasFlyMovementCapability() end

---
---@return bool
function CDOTA_BaseNPC:HasFlyingVision() end

---
---@return bool
function CDOTA_BaseNPC:HasGroundMovementCapability() end

---Does this unit have an inventory.
---@return bool
function CDOTA_BaseNPC:HasInventory() end

---See whether this unit has an item by name.
---@param pItemName string
---@return bool
function CDOTA_BaseNPC:HasItemInInventory(pItemName) end

---Sees if this unit has a given modifier.
---@param pszScriptName string
---@return bool
function CDOTA_BaseNPC:HasModifier(pszScriptName) end

---
---@return bool
function CDOTA_BaseNPC:HasMovementCapability() end

---判断单位是否拥有阿哈利姆神杖升级效果
---@return bool
function CDOTA_BaseNPC:HasScepter() end

---Heal this unit.
---@param flAmount float
---@param hInflictor handle
---@return void
function CDOTA_BaseNPC:Heal(flAmount, hInflictor) end

---Hold position.
---@return void
function CDOTA_BaseNPC:Hold() end

---
---@return void
function CDOTA_BaseNPC:Interrupt() end

---
---@return void
function CDOTA_BaseNPC:InterruptChannel() end

---
---@param bFindClearSpace bool
---@return void
function CDOTA_BaseNPC:InterruptMotionControllers(bFindClearSpace) end

---Is this unit alive?
---@return bool
function CDOTA_BaseNPC:IsAlive() end

---Is this unit an Ancient?
---@return bool
function CDOTA_BaseNPC:IsAncient() end

---
---@return bool
function CDOTA_BaseNPC:IsAttackImmune() end

---
---@return bool
function CDOTA_BaseNPC:IsAttacking() end

---
---@param hEntity handle
---@return bool
function CDOTA_BaseNPC:IsAttackingEntity(hEntity) end

---Is this unit a Barracks?
---@return bool
function CDOTA_BaseNPC:IsBarracks() end

---
---@return bool
function CDOTA_BaseNPC:IsBlind() end

---
---@return bool
function CDOTA_BaseNPC:IsBlockDisabled() end

---Is this unit a boss?
---@return bool
function CDOTA_BaseNPC:IsBoss() end

---Is this unit a building?
---@return bool
function CDOTA_BaseNPC:IsBuilding() end

---Is this unit currently channeling a spell?
---@return bool
function CDOTA_BaseNPC:IsChanneling() end

---Is this unit a clone? (Meepo)
---@return bool
function CDOTA_BaseNPC:IsClone() end

---
---@return bool
function CDOTA_BaseNPC:IsCommandRestricted() end

---Is this unit a considered a hero for targeting purposes?
---@return bool
function CDOTA_BaseNPC:IsConsideredHero() end

---Is this unit controlled by any non-bot player?
---@return bool
function CDOTA_BaseNPC:IsControllableByAnyPlayer() end

---Is this unit a courier?
---@return bool
function CDOTA_BaseNPC:IsCourier() end

---Is this a Creature type NPC?
---@return bool
function CDOTA_BaseNPC:IsCreature() end

---Is this unit a creep?
---@return bool
function CDOTA_BaseNPC:IsCreep() end

---Is this unit a creep hero?
---@return bool
function CDOTA_BaseNPC:IsCreepHero() end

---
---@return bool
function CDOTA_BaseNPC:IsCurrentlyHorizontalMotionControlled() end

---
---@return bool
function CDOTA_BaseNPC:IsCurrentlyVerticalMotionControlled() end

---
---@return bool
function CDOTA_BaseNPC:IsDisarmed() end

---
---@return bool
function CDOTA_BaseNPC:IsDominated() end

---
---@return bool
function CDOTA_BaseNPC:IsEvadeDisabled() end

---Is this unit an Ancient?
---@return bool
function CDOTA_BaseNPC:IsFort() end

---
---@return bool
function CDOTA_BaseNPC:IsFrozen() end

---Is this a hero or hero illusion?
---@return bool
function CDOTA_BaseNPC:IsHero() end

---
---@return bool
function CDOTA_BaseNPC:IsHexed() end

---Is this creature currently idle?
---@return bool
function CDOTA_BaseNPC:IsIdle() end

---
---@return bool
function CDOTA_BaseNPC:IsIllusion() end

---Ask whether this unit is in range of the specified shop ( DOTA_SHOP_TYPE shop, bool bMustBePhysicallyNear
---@param nShopType int
---@param bPhysical bool
---@return bool
function CDOTA_BaseNPC:IsInRangeOfShop(nShopType, bPhysical) end

---Does this unit have an inventory.
---@return bool
function undefined:IsInventoryEnabled() end

---
---@return bool
function CDOTA_BaseNPC:IsInvisible() end

---
---@return bool
function CDOTA_BaseNPC:IsInvulnerable() end

---
---@return bool
function CDOTA_BaseNPC:IsLowAttackPriority() end

---
---@return bool
function CDOTA_BaseNPC:IsMagicImmune() end

---
---@return bool
function CDOTA_BaseNPC:IsMovementImpaired() end

---Is this unit moving?
---@return bool
function CDOTA_BaseNPC:IsMoving() end

---
---@return bool
function CDOTA_BaseNPC:IsMuted() end

---Is this a neutral?
---@return bool
function CDOTA_BaseNPC:IsNeutralUnitType() end

---
---@return bool
function CDOTA_BaseNPC:IsNightmared() end

---
---@param nTeam int
---@return bool
function CDOTA_BaseNPC:IsOpposingTeam(nTeam) end

---Is this unit a ward-type unit?
---@return bool
function CDOTA_BaseNPC:IsOther() end

---
---@return bool
function CDOTA_BaseNPC:IsOutOfGame() end

---Is this unit owned by any non-bot player?
---@return bool
function CDOTA_BaseNPC:IsOwnedByAnyPlayer() end

---Is this a phantom unit?
---@return bool
function CDOTA_BaseNPC:IsPhantom() end

---
---@return bool
function CDOTA_BaseNPC:IsPhantomBlocker() end

---
---@return bool
function CDOTA_BaseNPC:IsPhased() end

---
---@param vPosition Vector
---@param flRange float
---@return bool
function CDOTA_BaseNPC:IsPositionInRange(vPosition, flRange) end

---Is this unit a ranged attacker?
---@return bool
function CDOTA_BaseNPC:IsRangedAttacker() end

---Is this a real hero?
---@return bool
function CDOTA_BaseNPC:IsRealHero() end

---
---@return bool
function CDOTA_BaseNPC:IsReincarnating() end

---
---@return bool
function CDOTA_BaseNPC:IsRooted() end

---Is this a shrine?
---@return bool
function CDOTA_BaseNPC:IsShrine() end

---
---@return bool
function CDOTA_BaseNPC:IsSilenced() end

---
---@return bool
function CDOTA_BaseNPC:IsSpeciallyDeniable() end

---
---@return bool
function CDOTA_BaseNPC:IsSpeciallyUndeniable() end

---
---@return bool
function CDOTA_BaseNPC:IsStunned() end

---Is this unit summoned?
---@return bool
function CDOTA_BaseNPC:IsSummoned() end

---
---@return bool
function CDOTA_BaseNPC:IsTempestDouble() end

---Is this a tower?
---@return bool
function CDOTA_BaseNPC:IsTower() end

---
---@return bool
function CDOTA_BaseNPC:IsUnableToMiss() end

---
---@return bool
function CDOTA_BaseNPC:IsUnselectable() end

---
---@return bool
function CDOTA_BaseNPC:IsUntargetable() end

---Kills this NPC, with the params Ability and Attacker.
---@param hAbility handle
---@param hAttacker handle
---@return void
function CDOTA_BaseNPC:Kill(hAbility, hAttacker) end

---
---@return void
function CDOTA_BaseNPC:MakeIllusion() end

---
---@return void
function CDOTA_BaseNPC:MakePhantomBlocker() end

---
---@param iTeam int
---@param flRadius float
---@return void
function CDOTA_BaseNPC:MakeVisibleDueToAttack(iTeam, flRadius) end

---
---@param iTeam int
---@param flDuration float
---@return void
function CDOTA_BaseNPC:MakeVisibleToTeam(iTeam, flDuration) end

---
---@return void
function CDOTA_BaseNPC:ManageModelChanges() end

---Sets the health to a specific value, with optional flags or inflictors.
---@param iDesiredHealthValue int
---@param hAbility handle
---@param bLethal bool
---@param iAdditionalFlags int
---@return void
function CDOTA_BaseNPC:ModifyHealth(iDesiredHealthValue, hAbility, bLethal, iAdditionalFlags) end

---Move to follow a unit.
---@param hNPC handle
---@return void
function CDOTA_BaseNPC:MoveToNPC(hNPC) end

---Give an item to another unit.
---@param hNPC handle
---@param hItem handle
---@return void
function CDOTA_BaseNPC:MoveToNPCToGiveItem(hNPC, hItem) end

---Issue a Move-To command.
---@param vDest Vector
---@return void
function CDOTA_BaseNPC:MoveToPosition(vDest) end

---Issue an Attack-Move-To command.
---@param vDest Vector
---@return void
function CDOTA_BaseNPC:MoveToPositionAggressive(vDest) end

---Move to a target to attack.
---@param hTarget handle
---@return void
function CDOTA_BaseNPC:MoveToTargetToAttack(hTarget) end

---
---@return bool
function CDOTA_BaseNPC:NoHealthBar() end

---
---@return bool
function CDOTA_BaseNPC:NoTeamMoveTo() end

---
---@return bool
function CDOTA_BaseNPC:NoTeamSelect() end

---
---@return bool
function CDOTA_BaseNPC:NoUnitCollision() end

---
---@return bool
function CDOTA_BaseNPC:NotOnMinimap() end

---
---@return bool
function CDOTA_BaseNPC:NotOnMinimapForEnemies() end

---
---@param bOriginalModel bool
---@return void
function CDOTA_BaseNPC:NotifyWearablesOfModelChange(bOriginalModel) end

---判断单位是否被禁用被动
---@return bool
function CDOTA_BaseNPC:PassivesDisabled() end

---Issue a Patrol-To command.
---@param vDest Vector
---@return void
function CDOTA_BaseNPC:PatrolToPosition(vDest) end

---Performs an attack on a target.
---@param hTarget handle
---@param bUseCastAttackOrb bool
---@param bProcessProcs bool
---@param bSkipCooldown bool
---@param bIgnoreInvis bool
---@param bUseProjectile bool
---@param bFakeAttack bool
---@param bNeverMiss bool
---@return void
function CDOTA_BaseNPC:PerformAttack(hTarget, bUseCastAttackOrb, bProcessProcs, bSkipCooldown, bIgnoreInvis, bUseProjectile, bFakeAttack, bNeverMiss) end

---Pick up a dropped item.
---@param hItem handle
---@return void
function CDOTA_BaseNPC:PickupDroppedItem(hItem) end

---Pick up a rune.
---@param hItem handle
---@return void
function CDOTA_BaseNPC:PickupRune(hItem) end

---Play a VCD on the NPC.
---@param pVCD string
---@return void
function CDOTA_BaseNPC:PlayVCD(pVCD) end

---
---@return bool
function CDOTA_BaseNPC:ProvidesVision() end

---(bool RemovePositiveBuffs, bool RemoveDebuffs, bool BuffsCreatedThisFrameOnly, bool RemoveStuns, bool RemoveExceptions)
---@param bRemovePositiveBuffs bool
---@param bRemoveDebuffs bool
---@param bFrameOnly bool
---@param bRemoveStuns bool
---@param bRemoveExceptions bool
---@return void
function CDOTA_BaseNPC:Purge(bRemovePositiveBuffs, bRemoveDebuffs, bFrameOnly, bRemoveStuns, bRemoveExceptions) end

---Queue a response system concept with the TLK_DOTA_CUSTOM concept, after a delay.
---@param flDelay float
---@param hCriteriaTable handle
---@param hCompletionCallbackFn handle
---@param hContext handle
---@param hCallbackInfo handle
---@return void
function CDOTA_BaseNPC:QueueConcept(flDelay, hCriteriaTable, hCompletionCallbackFn, hContext, hCallbackInfo) end

---Queue a response system concept with the TLK_DOTA_CUSTOM concept, after a delay, for the same team this speaker is on.
---@param flDelay float
---@param hCriteriaTable handle
---@param hCompletionCallbackFn handle
---@param hContext handle
---@param hCallbackInfo handle
---@return void
function CDOTA_BaseNPC:QueueTeamConcept(flDelay, hCriteriaTable, hCompletionCallbackFn, hContext, hCallbackInfo) end

---Queue a response system concept with the TLK_DOTA_CUSTOM concept, after a delay, for the same team this speaker is on. Is not played for spectators.
---@param flDelay float
---@param hCriteriaTable handle
---@param hCompletionCallbackFn handle
---@param hContext handle
---@param hCallbackInfo handle
---@return void
function CDOTA_BaseNPC:QueueTeamConceptNoSpectators(flDelay, hCriteriaTable, hCompletionCallbackFn, hContext, hCallbackInfo) end

---Remove mana from this unit, this can be used for involuntary mana loss, not for mana that is spent.
---@param flAmount float
---@return void
function CDOTA_BaseNPC:ReduceMana(flAmount) end

---Remove an ability from this unit by name.
---@param pszAbilityName string
---@return void
function CDOTA_BaseNPC:RemoveAbility(pszAbilityName) end

---通过指定技能实体删除单位身上的技能。需要注意技能的被动modifier不会自动销毁，需要手动删除。
---@param hAbility handle
---@return void
function CDOTA_BaseNPC:RemoveAbilityByHandle(hAbility) end

---
---@param pszAbilityName string
---@return void
function CDOTA_BaseNPC:RemoveAbilityFromIndexByName(pszAbilityName) end

---(int targets [0=all, 1=enemy, 2=ally], bool bNow, bool bPermanent, bool bDeath)
---@param targets int
---@param bNow bool
---@param bPermanent bool
---@param bDeath bool
---@return void
function CDOTA_BaseNPC:RemoveAllModifiers(targets, bNow, bPermanent, bDeath) end

---Remove the given gesture activity.
---@param nActivity int
---@return void
function CDOTA_BaseNPC:RemoveGesture(nActivity) end

---
---@param hBuff handle
---@return void
function CDOTA_BaseNPC:RemoveHorizontalMotionController(hBuff) end

---Removes the passed item from this unit`s inventory and deletes it.
---@param hItem handle
---@return void
function CDOTA_BaseNPC:RemoveItem(hItem) end

---Removes a modifier.
---@param pszScriptName string
---@return void
function CDOTA_BaseNPC:RemoveModifierByName(pszScriptName) end

---Removes a modifier that was cast by the given caster.
---@param pszScriptName string
---@param hCaster handle
---@return void
function CDOTA_BaseNPC:RemoveModifierByNameAndCaster(pszScriptName, hCaster) end

---Remove the no draw flag.
---@return void
function CDOTA_BaseNPC:RemoveNoDraw() end

---
---@param hBuff handle
---@return void
function CDOTA_BaseNPC:RemoveVerticalMotionController(hBuff) end

---Respawns the target unit if it can be respawned.
---@return void
function CDOTA_BaseNPC:RespawnUnit() end

---Gets this unit`s attack range after all modifiers.
---@return float
function CDOTA_BaseNPC:Script_GetAttackRange() end

---
---@return bool
function CDOTA_BaseNPC:Script_IsDeniable() end

---Sells the passed item in this unit`s inventory.
---@param hItem handle
---@return void
function CDOTA_BaseNPC:SellItem(hItem) end

---Set the ability by index.
---@param hAbility handle
---@param iIndex int
---@return void
function CDOTA_BaseNPC:SetAbilityByIndex(hAbility, iIndex) end

---
---@param nRange int
---@return void
function CDOTA_BaseNPC:SetAcquisitionRange(nRange) end

---Combat involving this creature will have this weight added to the music calcuations.
---@param flWeight float
---@return void
function CDOTA_BaseNPC:SetAdditionalBattleMusicWeight(flWeight) end

---Set this unit`s aggro target to a specified unit.
---@param hAggroTarget handle
---@return void
function CDOTA_BaseNPC:SetAggroTarget(hAggroTarget) end

---设置攻击类型0无攻击1近战2远程
---@param iAttackCapabilities int
---@return void
function CDOTA_BaseNPC:SetAttackCapability(iAttackCapabilities) end

---
---@param hAttackTarget handle
---@return void
function CDOTA_BaseNPC:SetAttacking(hAttackTarget) end

---
---@param flBaseAttackTime float
---@return void
function CDOTA_BaseNPC:SetBaseAttackTime(flBaseAttackTime) end

---Sets the maximum base damage.
---@param nMax int
---@return void
function CDOTA_BaseNPC:SetBaseDamageMax(nMax) end

---Sets the minimum base damage.
---@param nMin int
---@return void
function CDOTA_BaseNPC:SetBaseDamageMin(nMin) end

---
---@param flHealthRegen float
---@return void
function CDOTA_BaseNPC:SetBaseHealthRegen(flHealthRegen) end

---Sets base magical armor value.
---@param flMagicalResistanceValue float
---@return void
function CDOTA_BaseNPC:SetBaseMagicalResistanceValue(flMagicalResistanceValue) end

---
---@param flManaRegen float
---@return void
function CDOTA_BaseNPC:SetBaseManaRegen(flManaRegen) end

---Set a new base max health value.
---@param flBaseMaxHealth float
---@return void
function CDOTA_BaseNPC:SetBaseMaxHealth(flBaseMaxHealth) end

---
---@param iMoveSpeed int
---@return void
function CDOTA_BaseNPC:SetBaseMoveSpeed(iMoveSpeed) end

---Set whether or not this unit is allowed to sell items (bCanSellItems)
---@param bCanSell bool
---@return void
function CDOTA_BaseNPC:SetCanSellItems(bCanSell) end

---设置玩家可以控制该单位，由于同队伍的碰撞检测较近，bSkipAdjustingPosition为true时，单位可能会被卡住。
---@param iPlayerID int
---@param bSkipAdjustingPosition bool
---@return void
function CDOTA_BaseNPC:SetControllableByPlayer(iPlayerID, bSkipAdjustingPosition) end

---
---@param hEntity handle
---@return void
function CDOTA_BaseNPC:SetCursorCastTarget(hEntity) end

---
---@param vLocation Vector
---@return void
function CDOTA_BaseNPC:SetCursorPosition(vLocation) end

---
---@param bTargetingNothing bool
---@return void
function CDOTA_BaseNPC:SetCursorTargetingNothing(bTargetingNothing) end

---在单位血条上显示指定的文字（支持本地化），可设置文字颜色。
---@param pLabel string
---@param r int
---@param g int
---@param b int
---@return void
function CDOTA_BaseNPC:SetCustomHealthLabel(pLabel, r, g, b) end

---Set the base vision range.
---@param iRange int
---@return void
function CDOTA_BaseNPC:SetDayTimeVisionRange(iRange) end

---Set the XP bounty on this unit.
---@param iXPBounty int
---@return void
function CDOTA_BaseNPC:SetDeathXP(iXPBounty) end

---
---@param hNPC handle
---@return void
function CDOTA_BaseNPC:SetForceAttackTarget(hNPC) end

---
---@param hNPC handle
---@return void
function CDOTA_BaseNPC:SetForceAttackTargetAlly(hNPC) end

---Set if this unit has an inventory.
---@param bHasInventory bool
---@return void
function CDOTA_BaseNPC:SetHasInventory(bHasInventory) end

---Set the collision hull radius of this NPC.
---@param flHullRadius float
---@return void
function CDOTA_BaseNPC:SetHullRadius(flHullRadius) end

---
---@param bIdleAcquire bool
---@return void
function CDOTA_BaseNPC:SetIdleAcquire(bIdleAcquire) end

---Sets the initial waypoint goal for this NPC.
---@param hGoal handle
---@return void
function CDOTA_BaseNPC:SetInitialGoalEntity(hGoal) end

---Set waypoint position for this NPC.
---@param vPosition Vector
---@return void
function CDOTA_BaseNPC:SetInitialGoalPosition(vPosition) end

---Set the mana on this unit.
---@param flMana float
---@return void
function CDOTA_BaseNPC:SetMana(flMana) end

---Set the maximum mana of this unit.
---@param flMaxMana float
---@return void
function CDOTA_BaseNPC:SetMaxMana(flMaxMana) end

---Set the maximum gold bounty for this unit.
---@param iGoldBountyMax int
---@return void
function CDOTA_BaseNPC:SetMaximumGoldBounty(iGoldBountyMax) end

---Set the minimum gold bounty for this unit.
---@param iGoldBountyMin int
---@return void
function CDOTA_BaseNPC:SetMinimumGoldBounty(iGoldBountyMin) end

---Sets the stack count of a given modifier.
---@param pszScriptName string
---@param hCaster handle
---@param nStackCount int
---@return void
function CDOTA_BaseNPC:SetModifierStackCount(pszScriptName, hCaster, nStackCount) end

---
---@param iMoveCapabilities int
---@return void
function CDOTA_BaseNPC:SetMoveCapability(iMoveCapabilities) end

---Set whether this NPC is required to reach each goal entity, rather than being allowed to unkink their path.
---@param must bool
---@return void
function CDOTA_BaseNPC:SetMustReachEachGoalEntity(must) end

---If set to true, we will never attempt to move this unit to clear space, even when it unphases.
---@param neverMoveToClearSpace bool
---@return void
function CDOTA_BaseNPC:SetNeverMoveToClearSpace(neverMoveToClearSpace) end

---Returns the vision range after modifiers.
---@param iRange int
---@return void
function CDOTA_BaseNPC:SetNightTimeVisionRange(iRange) end

---Set the unit`s origin.
---@param vLocation Vector
---@return void
function CDOTA_BaseNPC:SetOrigin(vLocation) end

---Sets the original model of this entity, which it will tend to fall back to anytime its state changes.
---@param pszModelName string
---@return void
function CDOTA_BaseNPC:SetOriginalModel(pszModelName) end

---Sets base physical armor value.
---@param flPhysicalArmorValue float
---@return void
function CDOTA_BaseNPC:SetPhysicalArmorBaseValue(flPhysicalArmorValue) end

---
---@param pProjectileName string
---@return void
function CDOTA_BaseNPC:SetRangedProjectileName(pProjectileName) end

---sets the client side map reveal radius for this unit
---@param revealRadius float
---@return void
function CDOTA_BaseNPC:SetRevealRadius(revealRadius) end

---
---@param bShouldVisuallyFly bool
---@return void
function CDOTA_BaseNPC:SetShouldDoFlyHeightVisual(bShouldVisuallyFly) end

---
---@param bStolenScepter bool
---@return void
function CDOTA_BaseNPC:SetStolenScepter(bStolenScepter) end

---
---@param bCanRespawn bool
---@return void
function CDOTA_BaseNPC:SetUnitCanRespawn(bCanRespawn) end

---
---@param pName string
---@return void
function CDOTA_BaseNPC:SetUnitName(pName) end

---
---@return bool
function CDOTA_BaseNPC:ShouldIdleAcquire() end

---Speak a response system concept with the TLK_DOTA_CUSTOM concept.
---@param hCriteriaTable handle
---@return void
function CDOTA_BaseNPC:SpeakConcept(hCriteriaTable) end

---Spend mana from this unit, this can be used for spending mana from abilities or item usage.
---@param flManaSpent float
---@param hAbility handle
---@return void
function CDOTA_BaseNPC:SpendMana(flManaSpent, hAbility) end

---Add the given gesture activity.
---@param nActivity int
---@return void
function CDOTA_BaseNPC:StartGesture(nActivity) end

---Add the given gesture activity faded according to its sequence settings.
---@param nActivity int
---@return void
function CDOTA_BaseNPC:StartGestureFadeWithSequenceSettings(nActivity) end

---Add the given gesture activity faded according to to the parameters.
---@param nActivity int
---@param fFadeIn float
---@param fFadeOut float
---@return void
function CDOTA_BaseNPC:StartGestureWithFade(nActivity, fFadeIn, fFadeOut) end

---Add the given gesture activity with a playback rate override.
---@param nActivity int
---@param flRate float
---@return void
function CDOTA_BaseNPC:StartGestureWithPlaybackRate(nActivity, flRate) end

---Stop the current order.
---@return void
function CDOTA_BaseNPC:Stop() end

---
---@return void
function CDOTA_BaseNPC:StopFacing() end

---Swaps the slots of the two passed abilities and sets them enabled/disabled.
---@param pAbilityName1 string
---@param pAbilityName2 string
---@param bEnable1 bool
---@param bEnable2 bool
---@return void
function CDOTA_BaseNPC:SwapAbilities(pAbilityName1, pAbilityName2, bEnable1, bEnable2) end

---Swap the contents of two item slots (slot1, slot2)
---@param nSlot1 int
---@param nSlot2 int
---@return void
function CDOTA_BaseNPC:SwapItems(nSlot1, nSlot2) end

---Removed the passed item from this unit`s inventory.
---@param hItem handle
---@return handle
function CDOTA_BaseNPC:TakeItem(hItem) end

---
---@return float
function CDOTA_BaseNPC:TimeUntilNextAttack() end

---
---@return bool
function CDOTA_BaseNPC:TriggerModifierDodge() end

---
---@param hAbility handle
---@return bool
function CDOTA_BaseNPC:TriggerSpellAbsorb(hAbility) end

---Trigger the Lotus Orb-like effect.(hAbility)
---@param hAbility handle
---@return void
function CDOTA_BaseNPC:TriggerSpellReflect(hAbility) end

---Makes the first ability unhidden, and puts it where second ability currently is. Will do nothing if the first ability is already unhidden and in a valid slot.
---@param pszAbilityName string
---@param pszReplacedAbilityName string
---@return void
function CDOTA_BaseNPC:UnHideAbilityToSlot(pszAbilityName, pszReplacedAbilityName) end

---
---@return bool
function CDOTA_BaseNPC:UnitCanRespawn() end

---
---@return bool
function CDOTA_BaseNPC:WasKilledPassively() end

---@class CDOTA_BaseNPC_Building : CDOTA_BaseNPC
---Get the invulnerability count for a building.
---@return int
function CDOTA_BaseNPC_Building:GetInvulnCount() end

---Set the invulnerability counter of this building.
---@param nInvulnCount int
---@return void
function CDOTA_BaseNPC_Building:SetInvulnCount(nInvulnCount) end

---@class CDOTA_BaseNPC_Creature : CDOTA_BaseNPC
---Add the specified item drop to this creature.
---@param hDropData handle
---@return void
function CDOTA_BaseNPC_Creature:AddItemDrop(hDropData) end

---Level the creature up by the specified number of levels
---@param iLevels int
---@return void
function CDOTA_BaseNPC_Creature:CreatureLevelUp(iLevels) end

---Set creature`s current disable resistance
---@return float
function CDOTA_BaseNPC_Creature:GetDisableResistance() end

---Set creature`s current disable resistance from ultimates
---@return float
function CDOTA_BaseNPC_Creature:GetUltimateDisableResistance() end

---Is this unit a champion?
---@return bool
function CDOTA_BaseNPC_Creature:IsChampion() end

---Is this creature respawning?
---@return bool
function CDOTA_BaseNPC_Creature:IsReincarnating() end

---Remove all item drops from this creature.
---@return void
function CDOTA_BaseNPC_Creature:RemoveAllItemDrops() end

---Set the armor gained per level on this creature.
---@param flArmorGain float
---@return void
function CDOTA_BaseNPC_Creature:SetArmorGain(flArmorGain) end

---Set the attack time gained per level on this creature.
---@param flAttackTimeGain float
---@return void
function CDOTA_BaseNPC_Creature:SetAttackTimeGain(flAttackTimeGain) end

---Set the bounty gold gained per level on this creature.
---@param nBountyGain int
---@return void
function CDOTA_BaseNPC_Creature:SetBountyGain(nBountyGain) end

---Flag this unit as a champion creature.
---@param bIsChampion bool
---@return void
function CDOTA_BaseNPC_Creature:SetChampion(bIsChampion) end

---Set the damage gained per level on this creature.
---@param nDamageGain int
---@return void
function CDOTA_BaseNPC_Creature:SetDamageGain(nDamageGain) end

---Set creature`s current disable resistance
---@param flDisableResistance float
---@return void
function CDOTA_BaseNPC_Creature:SetDisableResistance(flDisableResistance) end

---Set the disable resistance gained per level on this creature.
---@param flDisableResistanceGain float
---@return void
function CDOTA_BaseNPC_Creature:SetDisableResistanceGain(flDisableResistanceGain) end

---Set the hit points gained per level on this creature.
---@param nHPGain int
---@return void
function CDOTA_BaseNPC_Creature:SetHPGain(nHPGain) end

---Set the hit points regen gained per level on this creature.
---@param flHPRegenGain float
---@return void
function CDOTA_BaseNPC_Creature:SetHPRegenGain(flHPRegenGain) end

---Set the magic resistance gained per level on this creature.
---@param flMagicResistanceGain float
---@return void
function CDOTA_BaseNPC_Creature:SetMagicResistanceGain(flMagicResistanceGain) end

---Set the mana points gained per level on this creature.
---@param nManaGain int
---@return void
function CDOTA_BaseNPC_Creature:SetManaGain(nManaGain) end

---Set the mana points regen gained per level on this creature.
---@param flManaRegenGain float
---@return void
function CDOTA_BaseNPC_Creature:SetManaRegenGain(flManaRegenGain) end

---Set the move speed gained per level on this creature.
---@param nMoveSpeedGain int
---@return void
function CDOTA_BaseNPC_Creature:SetMoveSpeedGain(nMoveSpeedGain) end

---Set whether creatures require reaching their end path before becoming idle
---@param bRequiresReachingEndPath bool
---@return void
function CDOTA_BaseNPC_Creature:SetRequiresReachingEndPath(bRequiresReachingEndPath) end

---Set creature`s current disable resistance from ultimates
---@param flUltDisableResistance float
---@return void
function CDOTA_BaseNPC_Creature:SetUltimateDisableResistance(flUltDisableResistance) end

---Set the XP gained per level on this creature.
---@param nXPGain int
---@return void
function CDOTA_BaseNPC_Creature:SetXPGain(nXPGain) end

---@class CDOTA_BaseNPC_Hero : CDOTA_BaseNPC
---Params: Float XP, Bool applyBotDifficultyScaling
---@param flXP float
---@param nReason int
---@param bApplyBotDifficultyScaling bool
---@param bIncrementTotal bool
---@return bool
function CDOTA_BaseNPC_Hero:AddExperience(flXP, nReason, bApplyBotDifficultyScaling, bIncrementTotal) end

---Spend the gold and buyback with this hero.
---@return void
function CDOTA_BaseNPC_Hero:Buyback() end

---Recalculate all stats after the hero gains stats.
---@param bForce bool
---@return void
function CDOTA_BaseNPC_Hero:CalculateStatBonus(bForce) end

---Returns boolean value result of buyback gold limit time less than game time.
---@return bool
function CDOTA_BaseNPC_Hero:CanEarnGold() end

---Value is stored in PlayerResource.
---@return void
function CDOTA_BaseNPC_Hero:ClearLastHitMultikill() end

---Value is stored in PlayerResource.
---@return void
function CDOTA_BaseNPC_Hero:ClearLastHitStreak() end

---Value is stored in PlayerResource.
---@return void
function CDOTA_BaseNPC_Hero:ClearStreak() end

---Gets the current unspent ability points.
---@return int
function CDOTA_BaseNPC_Hero:GetAbilityPoints() end

---
---@return table
function CDOTA_BaseNPC_Hero:GetAdditionalOwnedUnits() end

---
---@return float
function CDOTA_BaseNPC_Hero:GetAgility() end

---
---@return float
function CDOTA_BaseNPC_Hero:GetAgilityGain() end

---Value is stored in PlayerResource.
---@return int
function CDOTA_BaseNPC_Hero:GetAssists() end

---
---@param nIndex int
---@return int
function CDOTA_BaseNPC_Hero:GetAttacker(nIndex) end

---
---@return float
function CDOTA_BaseNPC_Hero:GetBaseAgility() end

---Hero damage is also affected by attributes.
---@return int
function CDOTA_BaseNPC_Hero:GetBaseDamageMax() end

---Hero damage is also affected by attributes.
---@return int
function CDOTA_BaseNPC_Hero:GetBaseDamageMin() end

---
---@return float
function CDOTA_BaseNPC_Hero:GetBaseIntellect() end

---Returns the base mana regen.
---@return float
function CDOTA_BaseNPC_Hero:GetBaseManaRegen() end

---
---@return float
function CDOTA_BaseNPC_Hero:GetBaseStrength() end

---
---@return int
function CDOTA_BaseNPC_Hero:GetBonusDamageFromPrimaryStat() end

---Return float value for the amount of time left on cooldown for this hero`s buyback.
---@return float
function CDOTA_BaseNPC_Hero:GetBuybackCooldownTime() end

---Return integer value for the gold cost of a buyback.
---@param bReturnOldValues bool
---@return int
function CDOTA_BaseNPC_Hero:GetBuybackCost(bReturnOldValues) end

---Returns the amount of time gold gain is limited after buying back.
---@return float
function CDOTA_BaseNPC_Hero:GetBuybackGoldLimitTime() end

---Returns the amount of XP 
---@return int
function CDOTA_BaseNPC_Hero:GetCurrentXP() end

---
---@return int
function CDOTA_BaseNPC_Hero:GetDeathGoldCost() end

---Value is stored in PlayerResource.
---@return int
function CDOTA_BaseNPC_Hero:GetDeaths() end

---Value is stored in PlayerResource.
---@return int
function CDOTA_BaseNPC_Hero:GetDenies() end

---Returns gold amount for the player owning this hero
---@return int
function CDOTA_BaseNPC_Hero:GetGold() end

---
---@return int
function CDOTA_BaseNPC_Hero:GetGoldBounty() end

---
---@return int
function CDOTA_BaseNPC_Hero:GetHeroID() end

---Hero attack speed is also affected by agility.
---@return float
function CDOTA_BaseNPC_Hero:GetIncreasedAttackSpeed() end

---
---@return float
function CDOTA_BaseNPC_Hero:GetIntellect() end

---
---@return float
function CDOTA_BaseNPC_Hero:GetIntellectGain() end

---Value is stored in PlayerResource.
---@return int
function CDOTA_BaseNPC_Hero:GetKills() end

---Value is stored in PlayerResource.
---@return int
function CDOTA_BaseNPC_Hero:GetLastHits() end

---
---@return float
function CDOTA_BaseNPC_Hero:GetMostRecentDamageTime() end

---
---@return int
function CDOTA_BaseNPC_Hero:GetMultipleKillCount() end

---
---@return int
function CDOTA_BaseNPC_Hero:GetNumAttackers() end

---
---@return int
function CDOTA_BaseNPC_Hero:GetNumItemsInInventory() end

---
---@return int
function CDOTA_BaseNPC_Hero:GetNumItemsInStash() end

---Hero armor is affected by attributes.
---@return float
function CDOTA_BaseNPC_Hero:GetPhysicalArmorBaseValue() end

---Returns player ID of the player owning this hero
---@return int
function CDOTA_BaseNPC_Hero:GetPlayerID() end

---0 = strength, 1 = agility, 2 = intelligence.
---@return int
function CDOTA_BaseNPC_Hero:GetPrimaryAttribute() end

---
---@return float
function CDOTA_BaseNPC_Hero:GetPrimaryStatValue() end

---
---@return handle
function CDOTA_BaseNPC_Hero:GetReplicatingOtherHero() end

---
---@return float
function CDOTA_BaseNPC_Hero:GetRespawnTime() end

---Is this hero prevented from respawning?
---@return bool
function CDOTA_BaseNPC_Hero:GetRespawnsDisabled() end

---Value is stored in PlayerResource.
---@return int
function CDOTA_BaseNPC_Hero:GetStreak() end

---
---@return float
function CDOTA_BaseNPC_Hero:GetStrength() end

---
---@return float
function CDOTA_BaseNPC_Hero:GetStrengthGain() end

---
---@return float
function CDOTA_BaseNPC_Hero:GetTimeUntilRespawn() end

---Get wearable entity in slot (slot)
---@param nSlotType int
---@return handle
function CDOTA_BaseNPC_Hero:GetTogglableWearable(nSlotType) end

---
---@return bool
function CDOTA_BaseNPC_Hero:HasAnyAvailableInventorySpace() end

---
---@return bool
function CDOTA_BaseNPC_Hero:HasFlyingVision() end

---
---@return bool
function CDOTA_BaseNPC_Hero:HasOwnerAbandoned() end

---Args: const char* pItemName, bool bIncludeStashCombines, bool bAllowSelling
---@param pItemName string
---@param bIncludeStashCombines bool
---@param bAllowSelling bool
---@return int
function CDOTA_BaseNPC_Hero:HasRoomForItem(pItemName, bIncludeStashCombines, bAllowSelling) end

---Levels up the hero, true or false to play effects.
---@param bPlayEffects bool
---@return void
function CDOTA_BaseNPC_Hero:HeroLevelUp(bPlayEffects) end

---Value is stored in PlayerResource.
---@param iKillerID int
---@return void
function CDOTA_BaseNPC_Hero:IncrementAssists(iKillerID) end

---Value is stored in PlayerResource.
---@param iKillerID int
---@return void
function CDOTA_BaseNPC_Hero:IncrementDeaths(iKillerID) end

---Value is stored in PlayerResource.
---@return void
function CDOTA_BaseNPC_Hero:IncrementDenies() end

---Passed ID is for the victim, killer ID is ID of the current hero.  Value is stored in PlayerResource.
---@param iVictimID int
---@return void
function CDOTA_BaseNPC_Hero:IncrementKills(iVictimID) end

---Value is stored in PlayerResource.
---@return void
function CDOTA_BaseNPC_Hero:IncrementLastHitMultikill() end

---Value is stored in PlayerResource.
---@return void
function CDOTA_BaseNPC_Hero:IncrementLastHitStreak() end

---Value is stored in PlayerResource.
---@return void
function CDOTA_BaseNPC_Hero:IncrementLastHits() end

---Value is stored in PlayerResource.
---@return void
function CDOTA_BaseNPC_Hero:IncrementNearbyCreepDeaths() end

---Value is stored in PlayerResource.
---@return void
function CDOTA_BaseNPC_Hero:IncrementStreak() end

---
---@return bool
function CDOTA_BaseNPC_Hero:IsBuybackDisabledByReapersScythe() end

---
---@return bool
function CDOTA_BaseNPC_Hero:IsReincarnating() end

---
---@return bool
function CDOTA_BaseNPC_Hero:IsStashEnabled() end

---Args: Hero, Inflictor
---@param hHero handle
---@param hInflictor handle
---@return void
function CDOTA_BaseNPC_Hero:KilledHero(hHero, hInflictor) end

---Adds passed value to base attribute value, then calls CalculateStatBonus.
---@param flNewAgility float
---@return void
function CDOTA_BaseNPC_Hero:ModifyAgility(flNewAgility) end

---Gives this hero some gold.  Args: int nGoldChange, bool bReliable, int reason
---@param iGoldChange int
---@param bReliable bool
---@param iReason int
---@return int
function CDOTA_BaseNPC_Hero:ModifyGold(iGoldChange, bReliable, iReason) end

---Gives this hero some gold, using the gold filter if extra filtering is on.  Args: int nGoldChange, bool bReliable, int reason
---@param iGoldChange int
---@param bReliabe bool
---@param iReason int
---@return int
function CDOTA_BaseNPC_Hero:ModifyGoldFiltered(iGoldChange, bReliabe, iReason) end

---Adds passed value to base attribute value, then calls CalculateStatBonus.
---@param flNewIntellect float
---@return void
function CDOTA_BaseNPC_Hero:ModifyIntellect(flNewIntellect) end

---Adds passed value to base attribute value, then calls CalculateStatBonus.
---@param flNewStrength float
---@return void
function CDOTA_BaseNPC_Hero:ModifyStrength(flNewStrength) end

---
---@return void
function CDOTA_BaseNPC_Hero:PerformTaunt() end

---
---@return void
function CDOTA_BaseNPC_Hero:RecordLastHit() end

---Respawn this hero.
---@param bBuyBack bool
---@param bRespawnPenalty bool
---@return void
function CDOTA_BaseNPC_Hero:RespawnHero(bBuyBack, bRespawnPenalty) end

---Sets the current unspent ability points.
---@param iPoints int
---@return void
function CDOTA_BaseNPC_Hero:SetAbilityPoints(iPoints) end

---
---@param flAgility float
---@return void
function CDOTA_BaseNPC_Hero:SetBaseAgility(flAgility) end

---
---@param flIntellect float
---@return void
function CDOTA_BaseNPC_Hero:SetBaseIntellect(flIntellect) end

---
---@param flStrength float
---@return void
function CDOTA_BaseNPC_Hero:SetBaseStrength(flStrength) end

---
---@param nDifficulty int
---@return void
function CDOTA_BaseNPC_Hero:SetBotDifficulty(nDifficulty) end

---
---@param bBuybackDisabled bool
---@return void
function CDOTA_BaseNPC_Hero:SetBuyBackDisabledByReapersScythe(bBuybackDisabled) end

---Sets the buyback cooldown time.
---@param flTime float
---@return void
function CDOTA_BaseNPC_Hero:SetBuybackCooldownTime(flTime) end

---Set the amount of time gold gain is limited after buying back.
---@param flTime float
---@return void
function CDOTA_BaseNPC_Hero:SetBuybackGoldLimitTime(flTime) end

---Sets a custom experience value for this hero.  Note, GameRules boolean must be set for this to work!
---@param iValue int
---@return void
function CDOTA_BaseNPC_Hero:SetCustomDeathXP(iValue) end

---Sets the gold amount for the player owning this hero
---@param iGold int
---@param bReliable bool
---@return void
function CDOTA_BaseNPC_Hero:SetGold(iGold, bReliable) end

---
---@param iPlayerID int
---@return void
function CDOTA_BaseNPC_Hero:SetPlayerID(iPlayerID) end

---Set this hero`s primary attribute value.
---@param nPrimaryAttribute int
---@return void
function CDOTA_BaseNPC_Hero:SetPrimaryAttribute(nPrimaryAttribute) end

---
---@param vOrigin Vector
---@return void
function CDOTA_BaseNPC_Hero:SetRespawnPosition(vOrigin) end

---Prevent this hero from respawning.
---@param bDisableRespawns bool
---@return void
function CDOTA_BaseNPC_Hero:SetRespawnsDisabled(bDisableRespawns) end

---
---@param bEnabled bool
---@return void
function CDOTA_BaseNPC_Hero:SetStashEnabled(bEnabled) end

---
---@param time float
---@return void
function CDOTA_BaseNPC_Hero:SetTimeUntilRespawn(time) end

---
---@return bool
function CDOTA_BaseNPC_Hero:ShouldDoFlyHeightVisual() end

---Args: int nGold, int nReason
---@param iCost int
---@param iReason int
---@return void
function CDOTA_BaseNPC_Hero:SpendGold(iCost, iReason) end

---如果存在该技能并且英雄拥有足够的技能点，将会升级该技能。测试中发现似乎不会刷新被动modifier[2021/4/16]
---@param hAbility handle
---@return void
function CDOTA_BaseNPC_Hero:UpgradeAbility(hAbility) end

---
---@return bool
function CDOTA_BaseNPC_Hero:WillReincarnate() end

---@class CDOTA_BaseNPC_Shop : CDOTA_BaseNPC_Building
---Get the DOTA_SHOP_TYPE
---@return int
function CDOTA_BaseNPC_Shop:GetShopType() end

---Set the DOTA_SHOP_TYPE.
---@param eShopType int
---@return void
function CDOTA_BaseNPC_Shop:SetShopType(eShopType) end

---@class CDOTA_BaseNPC_Trap_Ward : CDOTA_BaseNPC_Creature
---Get the trap target for this entity.
---@return Vector
function CDOTA_BaseNPC_Trap_Ward:GetTrapTarget() end

---Set the animation sequence for this entity.
---@param pAnimation string
---@return void
function CDOTA_BaseNPC_Trap_Ward:SetAnimation(pAnimation) end

---@class CDOTA_BaseNPC_Watch_Tower
---The name of the ability used when triggering interaction on the outpost.
---@return string
function CDOTA_BaseNPC_Watch_Tower:GetInteractAbilityName() end

---The name of the ability used when triggering interaction on the outpost.
---@param pszInteractAbilityName string
---@return void
function CDOTA_BaseNPC_Watch_Tower:SetInteractAbilityName(pszInteractAbilityName) end

---@class CDOTA_Buff
---将一个特效绑定在modifier上，该特效会在modifier销毁时一起删除。
---@param iParticleID int
---@param bDestroyImmediately bool
---@param bStatusEffect bool
---@param iPriority int
---@param bHeroEffect bool
---@param bOverheadEffect bool
---@return void
function CDOTA_Buff:AddParticle(iParticleID, bDestroyImmediately, bStatusEffect, iPriority, bHeroEffect, bOverheadEffect) end

---减少一层叠加层数。
---@return void
function CDOTA_Buff:DecrementStackCount() end

---运行所有关联的destroy函数，然后删除modifier。
---@return void
function CDOTA_Buff:Destroy() end

---modifier到期后是否销毁
---@return bool
function CDOTA_Buff:DestroyOnExpire() end

---在此modifier上运行所有关联的刷新功能，就像重新添加它一样。
---@return void
function CDOTA_Buff:ForceRefresh() end

---获取该modifier的来源技能。
---@return handle
function CDOTA_Buff:GetAbility() end

---返回光环粘滞时间（默认0.5秒）
---@return float
function CDOTA_Buff:GetAuraDuration() end

---获取光环来源单位
---@return handle
function CDOTA_Buff:GetAuraOwner() end

---获取该modifier的来源单位。
---@return CDOTA_BaseNPC
function CDOTA_Buff:GetCaster() end

---
---@return string
function CDOTA_Buff:GetClass() end

---获取创建时间。
---@return float
function CDOTA_Buff:GetCreationTime() end

---返回修改器的过期时间。
---@return float
function CDOTA_Buff:GetDieTime() end

---获取该modifier的持续时间。
---@return float
function CDOTA_Buff:GetDuration() end

---返回自创建修改器后经过的时间。
---@return float
function CDOTA_Buff:GetElapsedTime() end

---获取上次应用时间。
---@return float
function CDOTA_Buff:GetLastAppliedTime() end

---获取该modifier的名字。
---@return string
function CDOTA_Buff:GetName() end

---获取modifier的作用单位。
---@return handle
function CDOTA_Buff:GetParent() end

---获取剩余时间。
---@return float
function CDOTA_Buff:GetRemainingTime() end

---获取序列号
---@return int
function CDOTA_Buff:GetSerialNumber() end

---获取modifier层数
---@return int
function CDOTA_Buff:GetStackCount() end

---判断是否拥有某个modifierfunction
---@param iFunction int
---@return bool
function CDOTA_Buff:HasFunction(iFunction) end

---增加一层叠加层数。
---@return void
function CDOTA_Buff:IncrementStackCount() end

---是否是负面buff
---@return bool
function CDOTA_Buff:IsDebuff() end

---是否是妖术负面buff
---@return bool
function CDOTA_Buff:IsHexDebuff() end

---是否是晕眩负面buff
---@return bool
function CDOTA_Buff:IsStunDebuff() end

---通知客户端刷新modifier
---@return void
function CDOTA_Buff:SendBuffRefreshToClients() end

---设置持续时间
---@param flDuration float
---@param bInformClient bool
---@return void
function CDOTA_Buff:SetDuration(flDuration, bInformClient) end

---设置叠加层数
---@param iCount int
---@return void
function CDOTA_Buff:SetStackCount(iCount) end

---以给定的间隔启动此修改器的计时器功能（OnIntervalThink）。 传入-1停止该计时器。
---@param flInterval float
---@return void
function CDOTA_Buff:StartIntervalThink(flInterval) end

---@class CDOTA_CustomUIManager
---Create a new custom UI HUD element for the specified player(s). ( int PlayerID /*-1 means everyone*/, string ElementID /* should be unique */, string LayoutFileName, table DialogVariables /* can be nil */ )
---@param int_1 int
---@param string_2 string
---@param string_3 string
---@param handle_4 handle
---@return void
function CDOTA_CustomUIManager:DynamicHud_Create(int_1, string_2, string_3, handle_4) end

---Destroy a custom hud element ( int PlayerID /*-1 means everyone*/, string ElementID )
---@param int_1 int
---@param string_2 string
---@return void
function CDOTA_CustomUIManager:DynamicHud_Destroy(int_1, string_2) end

---Add or modify dialog variables for an existing custom hud element ( int PlayerID /*-1 means everyone*/, string ElementID, table DialogVariables )
---@param int_1 int
---@param string_2 string
---@param handle_3 handle
---@return void
function CDOTA_CustomUIManager:DynamicHud_SetDialogVariables(int_1, string_2, handle_3) end

---Toggle the visibility of an existing custom hud element ( int PlayerID /*-1 means everyone*/, string ElementID, bool Visible )
---@param int_1 int
---@param string_2 string
---@param bool_3 bool
---@return void
function CDOTA_CustomUIManager:DynamicHud_SetVisible(int_1, string_2, bool_3) end

---@class CDOTA_Item : CDOTABaseAbility
---
---@return bool
function CDOTA_Item:CanBeUsedOutOfInventory() end

---
---@return bool
function undefined:CanOnlyPlayerHeroPickup() end

---Get the container for this item.
---@return handle
function CDOTA_Item:GetContainer() end

---
---@return int
function CDOTA_Item:GetCost() end

---Get the number of charges this item currently has.
---@return int
function CDOTA_Item:GetCurrentCharges() end

---Get the initial number of charges this item has.
---@return int
function CDOTA_Item:GetInitialCharges() end

---
---@return int
function CDOTA_Item:GetItemSlot() end

---Gets whether item is unequipped or ready.
---@return int
function CDOTA_Item:GetItemState() end

---Get the parent for this item.
---@return handle
function CDOTA_Item:GetParent() end

---Get the purchase time of this item
---@return float
function CDOTA_Item:GetPurchaseTime() end

---Get the purchaser for this item.
---@return handle
function CDOTA_Item:GetPurchaser() end

---Get the number of secondary charges this item currently has.
---@return int
function CDOTA_Item:GetSecondaryCharges() end

---
---@return int
function CDOTA_Item:GetShareability() end

---Get the number of valueless charges this item currently has.
---@return int
function CDOTA_Item:GetValuelessCharges() end

---
---@return bool
function CDOTA_Item:IsAlertableItem() end

---
---@return bool
function CDOTA_Item:IsCastOnPickup() end

---
---@return bool
function CDOTA_Item:IsCombinable() end

---
---@return bool
function CDOTA_Item:IsCombineLocked() end

---
---@return bool
function CDOTA_Item:IsDisassemblable() end

---
---@return bool
function CDOTA_Item:IsDroppable() end

---
---@return bool
function CDOTA_Item:IsInBackpack() end

---
---@return bool
function CDOTA_Item:IsItem() end

---
---@return bool
function CDOTA_Item:IsKillable() end

---
---@return bool
function CDOTA_Item:IsMuted() end

---
---@return bool
function CDOTA_Item:IsNeutralDrop() end

---
---@return bool
function CDOTA_Item:IsPermanent() end

---
---@return bool
function CDOTA_Item:IsPurchasable() end

---
---@return bool
function CDOTA_Item:IsRecipe() end

---
---@return bool
function CDOTA_Item:IsRecipeGenerated() end

---
---@return bool
function CDOTA_Item:IsSellable() end

---
---@return bool
function CDOTA_Item:IsStackable() end

---
---@param bAutoUse bool
---@param flHeight float
---@param flDuration float
---@param vEndPoint Vector
---@return void
function CDOTA_Item:LaunchLoot(bAutoUse, flHeight, flDuration, vEndPoint) end

---
---@param bAutoUse bool
---@param flInitialHeight float
---@param flLaunchHeight float
---@param flDuration float
---@param vEndPoint Vector
---@return void
function CDOTA_Item:LaunchLootInitialHeight(bAutoUse, flInitialHeight, flLaunchHeight, flDuration, vEndPoint) end

---
---@param bAutoUse bool
---@param flRequiredHeight float
---@param flHeight float
---@param flDuration float
---@param vEndPoint Vector
---@return void
function CDOTA_Item:LaunchLootRequiredHeight(bAutoUse, flRequiredHeight, flHeight, flDuration, vEndPoint) end

---Modifies the number of valueless charges on this item
---@param iCharges int
---@return void
function CDOTA_Item:ModifyNumValuelessCharges(iCharges) end

---
---@return void
function CDOTA_Item:OnEquip() end

---
---@return void
function CDOTA_Item:OnUnequip() end

---
---@return bool
function CDOTA_Item:RequiresCharges() end

---
---@param bValue bool
---@return void
function CDOTA_Item:SetCanBeUsedOutOfInventory(bValue) end

---
---@param bCastOnPickUp bool
---@return void
function CDOTA_Item:SetCastOnPickup(bCastOnPickUp) end

---
---@param bCombineLocked bool
---@return void
function CDOTA_Item:SetCombineLocked(bCombineLocked) end

---Set the number of charges on this item
---@param iCharges int
---@return void
function CDOTA_Item:SetCurrentCharges(iCharges) end

---
---@param bDroppable bool
---@return void
function CDOTA_Item:SetDroppable(bDroppable) end

---Sets whether item is unequipped or ready.
---@param iState int
---@return void
function CDOTA_Item:SetItemState(iState) end

---
---@param bOnlyPlayerHero bool
---@return void
function CDOTA_Item:SetOnlyPlayerHeroPickup(bOnlyPlayerHero) end

---Set the purchase time of this item
---@param flTime float
---@return void
function CDOTA_Item:SetPurchaseTime(flTime) end

---Set the purchaser of record for this item.
---@param hPurchaser handle
---@return void
function CDOTA_Item:SetPurchaser(hPurchaser) end

---Set the number of secondary charges on this item
---@param iCharges int
---@return void
function CDOTA_Item:SetSecondaryCharges(iCharges) end

---
---@param bSellable bool
---@return void
function CDOTA_Item:SetSellable(bSellable) end

---
---@param iShareability int
---@return void
function CDOTA_Item:SetShareability(iShareability) end

---
---@param bStacksWithOtherOwners bool
---@return void
function CDOTA_Item:SetStacksWithOtherOwners(bStacksWithOtherOwners) end

---
---@return void
function CDOTA_Item:SpendCharge() end

---
---@return bool
function CDOTA_Item:StacksWithOtherOwners() end

---Think this item
---@return void
function CDOTA_Item:Think() end

---@class CDOTA_ItemSpawner : CBaseEntity
---Returns the item name
---@return string
function CDOTA_ItemSpawner:GetItemName() end

---@class CDOTA_Item_BagOfGold
---Set the life time of this item
---@param flTime float
---@return void
function CDOTA_Item_BagOfGold:SetLifeTime(flTime) end

---@class CDOTA_Item_DataDriven : CDOTA_Item
---Applies a data driven modifier to the target
---@param hCaster handle
---@param hTarget handle
---@param pszModifierName string
---@param hModifierTable handle
---@return void
function CDOTA_Item_DataDriven:ApplyDataDrivenModifier(hCaster, hTarget, pszModifierName, hModifierTable) end

---Applies a data driven thinker at the location
---@param hCaster handle
---@param vLocation Vector
---@param pszModifierName string
---@param hModifierTable handle
---@return handle
function CDOTA_Item_DataDriven:ApplyDataDrivenThinker(hCaster, vLocation, pszModifierName, hModifierTable) end

---@class CDOTA_Item_Lua : CDOTA_Item
---Returns true if this item can be picked up by the target unit.
---@param hUnit handle
---@return bool
function CDOTA_Item_Lua:CanUnitPickUp(hUnit) end

---Determine whether an issued command with no target is valid.
---@return int
function CDOTA_Item_Lua:CastFilterResult() end

---(Vector vLocation) Determine whether an issued command on a location is valid.
---@param vLocation Vector
---@return int
function CDOTA_Item_Lua:CastFilterResultLocation(vLocation) end

---(HSCRIPT hTarget) Determine whether an issued command on a target is valid.
---@param hTarget handle
---@return int
function CDOTA_Item_Lua:CastFilterResultTarget(hTarget) end

---Controls the size of the AOE casting cursor.
---@return float
function undefined:GetAOERadius() end

---Allows code overriding of the item texture shown in the HUD.
---@return string
function undefined:GetAbilityTextureName() end

---Returns abilities that are stolen simultaneously, or otherwise related in functionality.
---@return string
function CDOTA_Item_Lua:GetAssociatedPrimaryAbilities() end

---Returns other abilities that are stolen simultaneously, or otherwise related in functionality.  Generally hidden abilities.
---@return string
function CDOTA_Item_Lua:GetAssociatedSecondaryAbilities() end

---Return cast behavior type of this ability.
---@return int
function CDOTA_Item_Lua:GetBehavior() end

---Return cast range of this ability.
---@param vLocation Vector
---@param hTarget handle
---@return int
function CDOTA_Item_Lua:GetCastRange(vLocation, hTarget) end

---Return the channel time of this ability.
---@return float
function CDOTA_Item_Lua:GetChannelTime() end

---Return mana cost at the given level per second while channeling (-1 is current).
---@param iLevel int
---@return int
function CDOTA_Item_Lua:GetChannelledManaCostPerSecond(iLevel) end

---Return who hears speech when this spell is cast.
---@return int
function CDOTA_Item_Lua:GetConceptRecipientType() end

---Return cooldown of this ability.
---@param iLevel int
---@return float
function CDOTA_Item_Lua:GetCooldown(iLevel) end

---Return the error string of a failed command with no target.
---@return string
function CDOTA_Item_Lua:GetCustomCastError() end

---(Vector vLocation) Return the error string of a failed command on a location.
---@param vLocation Vector
---@return string
function CDOTA_Item_Lua:GetCustomCastErrorLocation(vLocation) end

---(HSCRIPT hTarget) Return the error string of a failed command on a target.
---@param hTarget handle
---@return string
function CDOTA_Item_Lua:GetCustomCastErrorTarget(hTarget) end

---Return gold cost at the given level (-1 is current).
---@param iLevel int
---@return int
function CDOTA_Item_Lua:GetGoldCost(iLevel) end

---返回此技能被动给予的修饰器的名称
---@return string
function CDOTA_Item_Lua:GetIntrinsicModifierName() end

---Return mana cost at the given level (-1 is current).
---@param iLevel int
---@return int
function CDOTA_Item_Lua:GetManaCost(iLevel) end

---Return the animation rate of the cast animation.
---@return float
function CDOTA_Item_Lua:GetPlaybackRateOverride() end

---Returns true if this ability can be used when not on the action panel.
---@return bool
function CDOTA_Item_Lua:IsHiddenAbilityCastable() end

---Returns true if this ability is hidden when stolen by Spell Steal.
---@return bool
function CDOTA_Item_Lua:IsHiddenWhenStolen() end

---Returns whether this item is muted or not.
---@return bool
function CDOTA_Item_Lua:IsMuted() end

---Returns true if this ability is refreshed by Refresher Orb.
---@return bool
function CDOTA_Item_Lua:IsRefreshable() end

---Returns true if this ability can be stolen by Spell Steal.
---@return bool
function CDOTA_Item_Lua:IsStealable() end

---Cast time did not complete successfully.
---@return void
function CDOTA_Item_Lua:OnAbilityPhaseInterrupted() end

---Cast time begins (return true for successful cast).
---@return bool
function CDOTA_Item_Lua:OnAbilityPhaseStart() end

---(bool bInterrupted) Channel finished.
---@param bInterrupted bool
---@return void
function CDOTA_Item_Lua:OnChannelFinish(bInterrupted) end

---(float flInterval) Channeling is taking place.
---@param flInterval float
---@return void
function CDOTA_Item_Lua:OnChannelThink(flInterval) end

---Runs when item`s charge count changes.
---@return void
function CDOTA_Item_Lua:OnChargeCountChanged() end

---Caster (hero only) gained a level, skilled an ability, or received a new stat bonus.
---@return void
function CDOTA_Item_Lua:OnHeroCalculateStatBonus() end

---A hero has died in the vicinity (ie Urn), takes table of params.
---@param unit handle
---@param attacker handle
---@param table handle
---@return void
function CDOTA_Item_Lua:OnHeroDiedNearby(unit, attacker, table) end

---Caster gained a level.
---@return void
function CDOTA_Item_Lua:OnHeroLevelUp() end

---Caster inventory changed.
---@return void
function CDOTA_Item_Lua:OnInventoryContentsChanged() end

---( HSCRIPT hItem ) Caster equipped item.
---@param hItem handle
---@return void
function CDOTA_Item_Lua:OnItemEquipped(hItem) end

---Caster died.
---@return void
function CDOTA_Item_Lua:OnOwnerDied() end

---Caster respawned or spawned for the first time.
---@return void
function CDOTA_Item_Lua:OnOwnerSpawned() end

---(HSCRIPT hTarget, Vector vLocation) Projectile has collided with a given target or reached its destination (target is invalid).
---@param hTarget handle
---@param vLocation Vector
---@return bool
function CDOTA_Item_Lua:OnProjectileHit(hTarget, vLocation) end

---(Vector vLocation) Projectile is actively moving.
---@param vLocation Vector
---@return void
function CDOTA_Item_Lua:OnProjectileThink(vLocation) end

---Cast time finished, spell effects begin.
---@return void
function CDOTA_Item_Lua:OnSpellStart() end

---( HSCRIPT hAbility ) Special behavior when stolen by Spell Steal.
---@param hSourceAbility handle
---@return void
function CDOTA_Item_Lua:OnStolen(hSourceAbility) end

---Ability is toggled on/off.
---@return void
function CDOTA_Item_Lua:OnToggle() end

---Special behavior when lost by Spell Steal.
---@return void
function CDOTA_Item_Lua:OnUnStolen() end

---Ability gained a level.
---@return void
function CDOTA_Item_Lua:OnUpgrade() end

---Returns true if this ability will generate magic stick charges for nearby enemies.
---@return bool
function CDOTA_Item_Lua:ProcsMagicStick() end

---Return the type of speech used.
---@return int
function CDOTA_Item_Lua:SpeakTrigger() end

---@class CDOTA_Item_Physical : CBaseAnimating
---Returned the contained item.
---@return handle
function CDOTA_Item_Physical:GetContainedItem() end

---Returns the game time when this item was created in the world
---@return float
function CDOTA_Item_Physical:GetCreationTime() end

---Set the contained item.
---@param hItem handle
---@return void
function CDOTA_Item_Physical:SetContainedItem(hItem) end

---@class CDOTA_MapTree : CBaseEntity
---Cuts down this tree. Parameters: int nTeamNumberKnownTo (-1 = invalid team)
---@param nTeamNumberKnownTo int
---@return void
function CDOTA_MapTree:CutDown(nTeamNumberKnownTo) end

---Cuts down this tree. Parameters: float flRegrowAfter (-1 = never regrow), int nTeamNumberKnownTo (-1 = invalid team)
---@param flRegrowAfter float
---@param nTeamNumberKnownTo int
---@return void
function CDOTA_MapTree:CutDownRegrowAfter(flRegrowAfter, nTeamNumberKnownTo) end

---Grows back the tree if it was cut down.
---@return void
function CDOTA_MapTree:GrowBack() end

---Returns true if the tree is standing, false if it has been cut down
---@return bool
function CDOTA_MapTree:IsStanding() end

---@class CDOTA_Modifier_Lua : CDOTA_Buff
---在Server端添加自定义数据传送到Client端。HandleCustomTransmitterData在Client端接受传递过来的数据
---@return table
function CDOTA_Modifier_Lua:AddCustomTransmitterData() end

---True/false if this modifier is active on illusions.
---@return bool
function CDOTA_Modifier_Lua:AllowIllusionDuplicate() end

---
---@return bool
function CDOTA_Modifier_Lua:CanParentBeAutoAttacked() end

---该修饰器包含的状态。晕眩、沉默、缴械等等。高优先级的修饰器状态会覆盖低优先级的修饰器状态。
---@return table
function CDOTA_Modifier_Lua:CheckState() end

---申明函数，注册修饰器使用的属性。
---@return table
function CDOTA_Modifier_Lua:DeclareFunctions() end

---True/false if this buff is removed when the duration expires.
---@return bool
function CDOTA_Modifier_Lua:DestroyOnExpire() end

---Return the types of attributes applied to this modifier (enum value from DOTAModifierAttribute_t
---@return int
function CDOTA_Modifier_Lua:GetAttributes() end

---Returns aura stickiness
---@return float
function CDOTA_Modifier_Lua:GetAuraDuration() end

---Return true/false if this entity should receive the aura under specific conditions
---@param hEntity handle
---@return bool
function CDOTA_Modifier_Lua:GetAuraEntityReject(hEntity) end

---Return the range around the parent this aura tries to apply its buff.
---@return int
function CDOTA_Modifier_Lua:GetAuraRadius() end

---Return the unit flags this aura respects when placing buffs.
---@return int
function CDOTA_Modifier_Lua:GetAuraSearchFlags() end

---Return the teams this aura applies its buff to.
---@return int
function CDOTA_Modifier_Lua:GetAuraSearchTeam() end

---Return the unit classifications this aura applies its buff to.
---@return int
function CDOTA_Modifier_Lua:GetAuraSearchType() end

---Return the attach type of the particle system from GetEffectName.
---@return int
function CDOTA_Modifier_Lua:GetEffectAttachType() end

---Return the name of the particle system that is created while this modifier is active.
---@return string
function CDOTA_Modifier_Lua:GetEffectName() end

---Return the name of the hero effect particle system that is created while this modifier is active.
---@return string
function CDOTA_Modifier_Lua:GetHeroEffectName() end

---The name of the secondary modifier that will be applied by this modifier (if it is an aura).
---@return string
function CDOTA_Modifier_Lua:GetModifierAura() end

---Return the priority order this modifier will be applied over others.
---@return int
function CDOTA_Modifier_Lua:GetPriority() end

---Return the name of the status effect particle system that is created while this modifier is active.
---@return string
function CDOTA_Modifier_Lua:GetStatusEffectName() end

---Return the name of the buff icon to be shown for this modifier.
---@return string
function CDOTA_Modifier_Lua:GetTexture() end

---在Server端添加自定义数据传送到Client端。HandleCustomTransmitterData在Client端接受传递过来的数据
---@return table
function CDOTA_Modifier_Lua:HandleCustomTransmitterData() end

---Relationship of this hero effect with those from other buffs (higher is more likely to be shown).
---@return int
function CDOTA_Modifier_Lua:HeroEffectPriority() end

---True/false if this modifier is an aura.
---@return bool
function CDOTA_Modifier_Lua:IsAura() end

---True/false if this aura provides buffs when the parent is dead.
---@return bool
function CDOTA_Modifier_Lua:IsAuraActiveOnDeath() end

---True/false if this modifier should be displayed as a debuff.
---@return bool
function CDOTA_Modifier_Lua:IsDebuff() end

---True/false if this modifier should be displayed on the buff bar.
---@return bool
function CDOTA_Modifier_Lua:IsHidden() end

---
---@return bool
function CDOTA_Modifier_Lua:IsPermanent() end

---True/false ，该修饰器可以/不可以被弱驱散净化。默认false。
---@return bool
function CDOTA_Modifier_Lua:IsPurgable() end

---True/false if this modifier can be purged by strong dispels.
---@return bool
function CDOTA_Modifier_Lua:IsPurgeException() end

---True/false if this modifier is considered a stun for purge reasons.
---@return bool
function CDOTA_Modifier_Lua:IsStunDebuff() end

---Runs when the modifier is created.
---@param table handle
---@return void
function CDOTA_Modifier_Lua:OnCreated(table) end

---Runs when the modifier is destroyed (after unit loses modifier).
---@return void
function CDOTA_Modifier_Lua:OnDestroy() end

---Runs when the think interval occurs.
---@return void
function CDOTA_Modifier_Lua:OnIntervalThink() end

---Runs when the modifier is refreshed.
---@param table handle
---@return void
function CDOTA_Modifier_Lua:OnRefresh(table) end

---Runs when the modifier is destroyed (before unit loses modifier).
---@return void
function CDOTA_Modifier_Lua:OnRemoved() end

---当叠加层数改变时调用，参数为改变前的叠加层数
---@param iStackCount int
---@return void
function CDOTA_Modifier_Lua:OnStackCountChanged(iStackCount) end

---True/false if this modifier is removed when the parent dies.
---@return bool
function CDOTA_Modifier_Lua:RemoveOnDeath() end

---需要配合AddCustomTransmitterData、HandleCustomTransmitterData这两个函数一起使用。AddCustomTransmitterData在Server端返回需要传递的数据。HandleCustomTransmitterData在Client端接受传递过来的数据（会被像nettable一样处理）
---@param bHasCustomData bool
---@return void
function CDOTA_Modifier_Lua:SetHasCustomTransmitterData(bHasCustomData) end

---Apply the overhead offset to the attached effect.
---@return bool
function CDOTA_Modifier_Lua:ShouldUseOverheadOffset() end

---Relationship of this status effect with those from other buffs (higher is more likely to be shown).
---@return int
function CDOTA_Modifier_Lua:StatusEffectPriority() end

---@class CDOTA_Modifier_Lua_Horizontal_Motion : CDOTA_Modifier_Lua
---Starts the horizontal motion controller effects for this buff.  Returns true if successful.
---@return bool
function CDOTA_Modifier_Lua_Horizontal_Motion:ApplyHorizontalMotionController() end

---Get the priority
---@return int
function CDOTA_Modifier_Lua_Horizontal_Motion:GetPriority() end

---Called when the motion gets interrupted.
---@return void
function CDOTA_Modifier_Lua_Horizontal_Motion:OnHorizontalMotionInterrupted() end

---Set the priority
---@param nMotionPriority int
---@return void
function CDOTA_Modifier_Lua_Horizontal_Motion:SetPriority(nMotionPriority) end

---Perform any motion from the given interval on the NPC. UpdateHorizontalMotion先运行，UpdateVerticalMotion后运行。
---@param me handle
---@param dt float
---@return void
function CDOTA_Modifier_Lua_Horizontal_Motion:UpdateHorizontalMotion(me, dt) end

---@class CDOTA_Modifier_Lua_Motion_Both : CDOTA_Modifier_Lua
---Starts the horizontal motion controller effects for this buff.  Returns true if successful.
---@return bool
function CDOTA_Modifier_Lua_Motion_Both:ApplyHorizontalMotionController() end

---Starts the vertical motion controller effects for this buff.  Returns true if successful.
---@return bool
function CDOTA_Modifier_Lua_Motion_Both:ApplyVerticalMotionController() end

---Get the priority
---@return int
function CDOTA_Modifier_Lua_Motion_Both:GetPriority() end

---Called when the motion gets interrupted.
---@return void
function CDOTA_Modifier_Lua_Motion_Both:OnHorizontalMotionInterrupted() end

---Called when the motion gets interrupted.
---@return void
function CDOTA_Modifier_Lua_Motion_Both:OnVerticalMotionInterrupted() end

---Set the priority
---@param nMotionPriority int
---@return void
function CDOTA_Modifier_Lua_Motion_Both:SetPriority(nMotionPriority) end

---Perform any motion from the given interval on the NPC.
---@param me handle
---@param dt float
---@return void
function CDOTA_Modifier_Lua_Motion_Both:UpdateHorizontalMotion(me, dt) end

---Perform any motion from the given interval on the NPC.
---@param me handle
---@param dt float
---@return void
function CDOTA_Modifier_Lua_Motion_Both:UpdateVerticalMotion(me, dt) end

---@class CDOTA_Modifier_Lua_Vertical_Motion : CDOTA_Modifier_Lua
---Starts the vertical motion controller effects for this buff.  Returns true if successful.
---@return bool
function CDOTA_Modifier_Lua_Vertical_Motion:ApplyVerticalMotionController() end

---Get the priority
---@return int
function CDOTA_Modifier_Lua_Vertical_Motion:GetMotionPriority() end

---Called when the motion gets interrupted.
---@return void
function CDOTA_Modifier_Lua_Vertical_Motion:OnVerticalMotionInterrupted() end

---Set the priority
---@param nMotionPriority int
---@return void
function CDOTA_Modifier_Lua_Vertical_Motion:SetMotionPriority(nMotionPriority) end

---Perform any motion from the given interval on the NPC.
---@param me handle
---@param dt float
---@return void
function CDOTA_Modifier_Lua_Vertical_Motion:UpdateVerticalMotion(me, dt) end

---@class CDOTA_NeutralSpawner
---
---@return void
function CDOTA_NeutralSpawner:CreatePendingUnits() end

---
---@return void
function CDOTA_NeutralSpawner:SelectSpawnType() end

---
---@param bIgnoreBlockers bool
---@return void
function CDOTA_NeutralSpawner:SpawnNextBatch(bIgnoreBlockers) end

---@class CDOTA_PlayerResource : CBaseEntity
---
---@param iPlayerID int
---@return void
function CDOTA_PlayerResource:AddAegisPickup(iPlayerID) end

---
---@param iPlayerID int
---@param nReason int
---@return void
function CDOTA_PlayerResource:AddCandyEvent(iPlayerID, nReason) end

---
---@param iPlayerID int
---@param flFarmValue float
---@param bEarnedValue bool
---@return void
function CDOTA_PlayerResource:AddClaimedFarm(iPlayerID, flFarmValue, bEarnedValue) end

---
---@param iPlayerID int
---@param iCost int
---@return void
function CDOTA_PlayerResource:AddGoldSpentOnSupport(iPlayerID, iCost) end

---
---@param iPlayerID int
---@param nTeamNumber int
---@param hItem handle
---@return void
function CDOTA_PlayerResource:AddNeutralItemToStash(iPlayerID, nTeamNumber, hItem) end

---
---@param iPlayerID int
---@return void
function CDOTA_PlayerResource:AddRunePickup(iPlayerID) end

---
---@param nUnitOwnerPlayerID int
---@param nOtherPlayerID int
---@return bool
function CDOTA_PlayerResource:AreUnitsSharedWithPlayerID(nUnitOwnerPlayerID, nOtherPlayerID) end

---
---@param iPlayerID int
---@return bool
function CDOTA_PlayerResource:CanRepick(iPlayerID) end

---
---@param iPlayerID int
---@return void
function CDOTA_PlayerResource:ClearKillsMatrix(iPlayerID) end

---
---@param iPlayerID int
---@return void
function CDOTA_PlayerResource:ClearLastHitMultikill(iPlayerID) end

---
---@param iPlayerID int
---@return void
function CDOTA_PlayerResource:ClearLastHitStreak(iPlayerID) end

---
---@param iPlayerID int
---@return void
function CDOTA_PlayerResource:ClearRawPlayerDamageMatrix(iPlayerID) end

---
---@param iPlayerID int
---@return void
function CDOTA_PlayerResource:ClearStreak(iPlayerID) end

---
---@param iPlayerID int
---@return int
function CDOTA_PlayerResource:GetAegisPickups(iPlayerID) end

---
---@param iPlayerID int
---@return int
function CDOTA_PlayerResource:GetAssists(iPlayerID) end

---
---@param iPlayerID int
---@return unsigned
function CDOTA_PlayerResource:GetBroadcasterChannel(iPlayerID) end

---
---@param iPlayerID int
---@return unsigned
function CDOTA_PlayerResource:GetBroadcasterChannelSlot(iPlayerID) end

---
---@param iPlayerID int
---@return int
function CDOTA_PlayerResource:GetClaimedDenies(iPlayerID) end

---
---@param iPlayerID int
---@param bOnlyEarned bool
---@return float
function CDOTA_PlayerResource:GetClaimedFarm(iPlayerID, bOnlyEarned) end

---
---@param iPlayerID int
---@return int
function CDOTA_PlayerResource:GetClaimedMisses(iPlayerID) end

---
---@param iPlayerID int
---@return unknown
function CDOTA_PlayerResource:GetConnectionState(iPlayerID) end

---
---@param iPlayerID int
---@param bTotal bool
---@return int
function CDOTA_PlayerResource:GetCreepDamageTaken(iPlayerID, bTotal) end

---
---@param iPlayerID int
---@return float
function CDOTA_PlayerResource:GetCustomBuybackCooldown(iPlayerID) end

---
---@param iPlayerID int
---@return int
function CDOTA_PlayerResource:GetCustomBuybackCost(iPlayerID) end

---Get the current custom team assignment for this player.
---@param iPlayerID int
---@return int
function CDOTA_PlayerResource:GetCustomTeamAssignment(iPlayerID) end

---
---@param iPlayerID int
---@param iVictimID int
---@return int
function CDOTA_PlayerResource:GetDamageDoneToHero(iPlayerID, iVictimID) end

---
---@param iPlayerID int
---@return int
function CDOTA_PlayerResource:GetDeaths(iPlayerID) end

---
---@param iPlayerID int
---@return int
function CDOTA_PlayerResource:GetDenies(iPlayerID) end

---(nPlayerID, nActionID)
---@param nPlayerID int
---@param unActionID unsigned
---@return int
function CDOTA_PlayerResource:GetEventGameCustomActionClaimCount(nPlayerID, unActionID) end

---(nPlayerID, pActionName)
---@param nPlayerID int
---@param pActionName string
---@return int
function CDOTA_PlayerResource:GetEventGameCustomActionClaimCountByName(nPlayerID, pActionName) end

---
---@param nPlayerID int
---@return unsigned
function CDOTA_PlayerResource:GetEventPointsForPlayerID(nPlayerID) end

---
---@param nPlayerID int
---@return unsigned
function CDOTA_PlayerResource:GetEventPremiumPoints(nPlayerID) end

---
---@param nPlayerID int
---@return unknown
function CDOTA_PlayerResource:GetEventRanks(nPlayerID) end

---
---@param iPlayerID int
---@return int
function CDOTA_PlayerResource:GetGold(iPlayerID) end

---
---@param iPlayerID int
---@return int
function CDOTA_PlayerResource:GetGoldLostToDeath(iPlayerID) end

---
---@param iPlayerID int
---@return float
function CDOTA_PlayerResource:GetGoldPerMin(iPlayerID) end

---
---@param iPlayerID int
---@return int
function CDOTA_PlayerResource:GetGoldSpentOnBuybacks(iPlayerID) end

---
---@param iPlayerID int
---@return int
function CDOTA_PlayerResource:GetGoldSpentOnConsumables(iPlayerID) end

---
---@param iPlayerID int
---@return int
function CDOTA_PlayerResource:GetGoldSpentOnItems(iPlayerID) end

---
---@param iPlayerID int
---@return int
function CDOTA_PlayerResource:GetGoldSpentOnSupport(iPlayerID) end

---
---@param iPlayerID int
---@return float
function CDOTA_PlayerResource:GetHealing(iPlayerID) end

---
---@param iPlayerID int
---@param bTotal bool
---@return int
function CDOTA_PlayerResource:GetHeroDamageTaken(iPlayerID, bTotal) end

---
---@param iPlayerID int
---@return int
function CDOTA_PlayerResource:GetKills(iPlayerID) end

---
---@param iPlayerID int
---@param iVictimID int
---@return int
function CDOTA_PlayerResource:GetKillsDoneToHero(iPlayerID, iVictimID) end

---
---@param iPlayerID int
---@return int
function CDOTA_PlayerResource:GetLastHitMultikill(iPlayerID) end

---
---@param iPlayerID int
---@return int
function CDOTA_PlayerResource:GetLastHitStreak(iPlayerID) end

---
---@param iPlayerID int
---@return int
function CDOTA_PlayerResource:GetLastHits(iPlayerID) end

---
---@param iPlayerID int
---@return int
function CDOTA_PlayerResource:GetLevel(iPlayerID) end

---
---@param iPlayerID int
---@return unknown
function CDOTA_PlayerResource:GetLiveSpectatorTeam(iPlayerID) end

---
---@param iPlayerID int
---@return int
function CDOTA_PlayerResource:GetMisses(iPlayerID) end

---
---@param iPlayerID int
---@return int
function CDOTA_PlayerResource:GetNearbyCreepDeaths(iPlayerID) end

---
---@param iPlayerID int
---@return int
function CDOTA_PlayerResource:GetNetWorth(iPlayerID) end

---
---@param nCourierIndex int
---@param nTeamNumber int
---@return handle
function CDOTA_PlayerResource:GetNthCourierForTeam(nCourierIndex, nTeamNumber) end

---
---@param iTeamNumber int
---@param iNthPlayer int
---@return int
function CDOTA_PlayerResource:GetNthPlayerIDOnTeam(iTeamNumber, iNthPlayer) end

---Players on a valid team (radiant, dire, or custom*) who haven't abandoned the game
---@return int
function CDOTA_PlayerResource:GetNumConnectedHumanPlayers() end

---
---@param iPlayerID int
---@return int
function CDOTA_PlayerResource:GetNumConsumablesPurchased(iPlayerID) end

---
---@param nTeamNumber int
---@return int
function CDOTA_PlayerResource:GetNumCouriersForTeam(nTeamNumber) end

---
---@param iPlayerID int
---@return int
function CDOTA_PlayerResource:GetNumItemsPurchased(iPlayerID) end

---
---@param iPlayerID int
---@return uint64
function CDOTA_PlayerResource:GetPartyID(iPlayerID) end

---
---@param iPlayerID int
---@return handle
function CDOTA_PlayerResource:GetPlayer(iPlayerID) end

---Includes spectators and players not assigned to a team
---@return int
function CDOTA_PlayerResource:GetPlayerCount() end

---
---@param iTeam int
---@return int
function CDOTA_PlayerResource:GetPlayerCountForTeam(iTeam) end

---
---@param iPlayerID int
---@return bool
function CDOTA_PlayerResource:GetPlayerLoadedCompletely(iPlayerID) end

---
---@param iPlayerID int
---@return string
function CDOTA_PlayerResource:GetPlayerName(iPlayerID) end

---
---@param nPlayerId int
---@return handle
function CDOTA_PlayerResource:GetPreferredCourierForPlayer(nPlayerId) end

---
---@param iPlayerID int
---@return int
function CDOTA_PlayerResource:GetRawPlayerDamage(iPlayerID) end

---
---@param iPlayerID int
---@return int
function CDOTA_PlayerResource:GetReliableGold(iPlayerID) end

---
---@param iPlayerID int
---@return int
function CDOTA_PlayerResource:GetRespawnSeconds(iPlayerID) end

---
---@param iPlayerID int
---@return int
function CDOTA_PlayerResource:GetRoshanKills(iPlayerID) end

---
---@param iPlayerID int
---@return int
function CDOTA_PlayerResource:GetRunePickups(iPlayerID) end

---
---@param iPlayerID int
---@return handle
function CDOTA_PlayerResource:GetSelectedHeroEntity(iPlayerID) end

---
---@param iPlayerID int
---@return int
function CDOTA_PlayerResource:GetSelectedHeroID(iPlayerID) end

---
---@param iPlayerID int
---@return string
function CDOTA_PlayerResource:GetSelectedHeroName(iPlayerID) end

---
---@param iPlayerID int
---@return unsigned
function CDOTA_PlayerResource:GetSteamAccountID(iPlayerID) end

---Get the 64 bit steam ID for a given player.
---@param iPlayerID int
---@return uint64
function CDOTA_PlayerResource:GetSteamID(iPlayerID) end

---
---@param iPlayerID int
---@return int
function CDOTA_PlayerResource:GetStreak(iPlayerID) end

---
---@param iPlayerID int
---@return float
function CDOTA_PlayerResource:GetStuns(iPlayerID) end

---
---@param iPlayerID int
---@return int
function CDOTA_PlayerResource:GetTeam(iPlayerID) end

---
---@param iTeam int
---@return int
function CDOTA_PlayerResource:GetTeamKills(iTeam) end

---Players on a valid team (radiant, dire, or custom*) who haven`t abandoned the game
---@return int
function CDOTA_PlayerResource:GetTeamPlayerCount() end

---
---@param iPlayerID int
---@return float
function CDOTA_PlayerResource:GetTimeOfLastConsumablePurchase(iPlayerID) end

---
---@param iPlayerID int
---@return float
function CDOTA_PlayerResource:GetTimeOfLastDeath(iPlayerID) end

---
---@param iPlayerID int
---@return float
function CDOTA_PlayerResource:GetTimeOfLastItemPurchase(iPlayerID) end

---
---@param iPlayerID int
---@return int
function CDOTA_PlayerResource:GetTotalEarnedGold(iPlayerID) end

---
---@param iPlayerID int
---@return int
function CDOTA_PlayerResource:GetTotalEarnedXP(iPlayerID) end

---
---@param iPlayerID int
---@return int
function CDOTA_PlayerResource:GetTotalGoldSpent(iPlayerID) end

---
---@param iPlayerID int
---@param bTotal bool
---@return int
function CDOTA_PlayerResource:GetTowerDamageTaken(iPlayerID, bTotal) end

---
---@param iPlayerID int
---@return int
function CDOTA_PlayerResource:GetTowerKills(iPlayerID) end

---
---@param nPlayerID int
---@param nOtherPlayerID int
---@return int
function CDOTA_PlayerResource:GetUnitShareMaskForPlayer(nPlayerID, nOtherPlayerID) end

---
---@param iPlayerID int
---@return int
function CDOTA_PlayerResource:GetUnreliableGold(iPlayerID) end

---
---@param iPlayerID int
---@return float
function CDOTA_PlayerResource:GetXPPerMin(iPlayerID) end

---Does this player have a custom game ticket for this game?
---@param iPlayerID int
---@return bool
function CDOTA_PlayerResource:HasCustomGameTicketForPlayerID(iPlayerID) end

---
---@param iPlayerID int
---@return bool
function CDOTA_PlayerResource:HasRandomed(iPlayerID) end

---
---@param iPlayerID int
---@return bool
function CDOTA_PlayerResource:HasSelectedHero(iPlayerID) end

---
---@return bool
function CDOTA_PlayerResource:HasSetEventGameCustomActionClaimCount() end

---
---@return bool
function CDOTA_PlayerResource:HaveAllPlayersJoined() end

---
---@param iPlayerID int
---@param iVictimID int
---@return void
function CDOTA_PlayerResource:IncrementAssists(iPlayerID, iVictimID) end

---
---@param iPlayerID int
---@return void
function CDOTA_PlayerResource:IncrementClaimedDenies(iPlayerID) end

---
---@param iPlayerID int
---@return void
function CDOTA_PlayerResource:IncrementClaimedMisses(iPlayerID) end

---
---@param iPlayerID int
---@param iKillerID int
---@return void
function CDOTA_PlayerResource:IncrementDeaths(iPlayerID, iKillerID) end

---
---@param iPlayerID int
---@return void
function CDOTA_PlayerResource:IncrementDenies(iPlayerID) end

---
---@param iPlayerID int
---@param iVictimID int
---@return void
function CDOTA_PlayerResource:IncrementKills(iPlayerID, iVictimID) end

---
---@param iPlayerID int
---@return void
function CDOTA_PlayerResource:IncrementLastHitMultikill(iPlayerID) end

---
---@param iPlayerID int
---@return void
function CDOTA_PlayerResource:IncrementLastHitStreak(iPlayerID) end

---
---@param iPlayerID int
---@return void
function CDOTA_PlayerResource:IncrementLastHits(iPlayerID) end

---
---@param iPlayerID int
---@return void
function CDOTA_PlayerResource:IncrementMisses(iPlayerID) end

---
---@param iPlayerID int
---@return void
function CDOTA_PlayerResource:IncrementNearbyCreepDeaths(iPlayerID) end

---
---@param iPlayerID int
---@return void
function CDOTA_PlayerResource:IncrementStreak(iPlayerID) end

---
---@param iPlayerID int
---@param iXP int
---@param nReason int
---@return void
function CDOTA_PlayerResource:IncrementTotalEarnedXP(iPlayerID, iXP, nReason) end

---
---@param iPlayerID int
---@return bool
function CDOTA_PlayerResource:IsBroadcaster(iPlayerID) end

---
---@param nPlayerID int
---@param nOtherPlayerID int
---@return bool
function CDOTA_PlayerResource:IsDisableHelpSetForPlayerID(nPlayerID, nOtherPlayerID) end

---
---@param iPlayerID int
---@return bool
function CDOTA_PlayerResource:IsFakeClient(iPlayerID) end

---
---@param pHeroname string
---@param bIgnoreUnrevealedPick bool
---@return bool
function CDOTA_PlayerResource:IsHeroSelected(pHeroname, bIgnoreUnrevealedPick) end

---
---@param nUnitOwnerPlayerID int
---@param nOtherPlayerID int
---@return bool
function CDOTA_PlayerResource:IsHeroSharedWithPlayerID(nUnitOwnerPlayerID, nOtherPlayerID) end

---
---@param iPlayerID int
---@return bool
function CDOTA_PlayerResource:IsValidPlayer(iPlayerID) end

---
---@param iPlayerID int
---@return bool
function CDOTA_PlayerResource:IsValidPlayerID(iPlayerID) end

---
---@param iPlayerID int
---@return bool
function CDOTA_PlayerResource:IsValidTeamPlayer(iPlayerID) end

---
---@param nPlayerID int
---@return bool
function CDOTA_PlayerResource:IsValidTeamPlayerID(nPlayerID) end

---
---@param iPlayerID int
---@param iGoldChange int
---@param bReliable bool
---@param nReason int
---@return int
function CDOTA_PlayerResource:ModifyGold(iPlayerID, iGoldChange, bReliable, nReason) end

---
---@return int
function CDOTA_PlayerResource:NumPlayers() end

---
---@return int
function CDOTA_PlayerResource:NumTeamPlayers() end

---Increment or decrement consumable charges (nPlayerID, item_definition_index, nChargeIncrementOrDecrement)
---@param iPlayerID int
---@param item_definition_index int
---@param nChargeIncrementOrDecrement int
---@return void
function CDOTA_PlayerResource:RecordConsumableAbilityChargeChange(iPlayerID, item_definition_index, nChargeIncrementOrDecrement) end

---(playerID, heroClassName, gold, XP) - replaces the player`s hero with a new one of the specified class, gold and XP
---@param iPlayerID int
---@param pszHeroClass string
---@param nGold int
---@param nXP int
---@return handle
function CDOTA_PlayerResource:ReplaceHeroWith(iPlayerID, pszHeroClass, nGold, nXP) end

---
---@param nPlayerID int
---@return void
function CDOTA_PlayerResource:ResetBuybackCostTime(nPlayerID) end

---
---@param iPlayerID int
---@return void
function CDOTA_PlayerResource:ResetTotalEarnedGold(iPlayerID) end

---
---@param nPlayerID int
---@param flBuybackCooldown float
---@return void
function CDOTA_PlayerResource:SetBuybackCooldownTime(nPlayerID, flBuybackCooldown) end

---
---@param nPlayerID int
---@param flBuybackCooldown float
---@return void
function CDOTA_PlayerResource:SetBuybackGoldLimitTime(nPlayerID, flBuybackCooldown) end

---(playerID, entity) - force the given player`s camera to follow the given entity
---@param nPlayerID int
---@param hTarget handle
---@return void
function CDOTA_PlayerResource:SetCameraTarget(nPlayerID, hTarget) end

---
---@param iPlayerID int
---@param bCanRepick bool
---@return void
function CDOTA_PlayerResource:SetCanRepick(iPlayerID, bCanRepick) end

---Set the buyback cooldown for this player.
---@param iPlayerID int
---@param flCooldownTime float
---@return void
function CDOTA_PlayerResource:SetCustomBuybackCooldown(iPlayerID, flCooldownTime) end

---Set the buyback cost for this player.
---@param iPlayerID int
---@param iGoldCost int
---@return void
function CDOTA_PlayerResource:SetCustomBuybackCost(iPlayerID, iGoldCost) end

---
---@param iPlayerID int
---@param iParam int
---@return void
function CDOTA_PlayerResource:SetCustomIntParam(iPlayerID, iParam) end

---Set custom color for player (minimap, scoreboard, etc)
---@param iPlayerID int
---@param r int
---@param g int
---@param b int
---@return void
function CDOTA_PlayerResource:SetCustomPlayerColor(iPlayerID, r, g, b) end

---Set custom team assignment for this player.
---@param iPlayerID int
---@param iTeamAssignment int
---@return void
function CDOTA_PlayerResource:SetCustomTeamAssignment(iPlayerID, iTeamAssignment) end

---
---@param iPlayerID int
---@param iGold int
---@param bReliable bool
---@return void
function CDOTA_PlayerResource:SetGold(iPlayerID, iGold, bReliable) end

---
---@param iPlayerID int
---@return void
function CDOTA_PlayerResource:SetHasRandomed(iPlayerID) end

---
---@param iPlayerID int
---@param iLastBuybackTime int
---@return void
function CDOTA_PlayerResource:SetLastBuybackTime(iPlayerID, iLastBuybackTime) end

---Set the forced selection entity for a player.
---@param nPlayerID int
---@param hEntity handle
---@return void
function CDOTA_PlayerResource:SetOverrideSelectionEntity(nPlayerID, hEntity) end

---nFlag 1 - 共享英雄 2 - 共享单位 4 - 队友帮助
---@param nPlayerID int
---@param nOtherPlayerID int
---@param nFlag int
---@param bState bool
---@return void
function CDOTA_PlayerResource:SetUnitShareMaskForPlayer(nPlayerID, nOtherPlayerID, nFlag, bState) end

---
---@param iPlayerID int
---@param iCost int
---@param iReason int
---@return void
function CDOTA_PlayerResource:SpendGold(iPlayerID, iCost, iReason) end

---
---@param iPlayerID int
---@param iTeamNumber int
---@param desiredSlot int
---@return void
function CDOTA_PlayerResource:UpdateTeamSlot(iPlayerID, iTeamNumber, desiredSlot) end

---
---@param pHeroFilename string
---@param bIgnoreUnrevealedPick bool
---@return int
function CDOTA_PlayerResource:WhoSelectedHero(pHeroFilename, bIgnoreUnrevealedPick) end

---@class CDOTA_ShopTrigger : CBaseTrigger
---Get the DOTA_SHOP_TYPE
---@return int
function CDOTA_ShopTrigger:GetShopType() end

---Set the DOTA_SHOP_TYPE.
---@param eShopType int
---@return void
function CDOTA_ShopTrigger:SetShopType(eShopType) end

---@class CDOTA_SimpleObstruction : CBaseEntity
---Returns whether the obstruction is currently active
---@return bool
function CDOTA_SimpleObstruction:IsEnabled() end

---Enable or disable the obstruction
---@param bEnabled bool
---@param bForce bool
---@return void
function CDOTA_SimpleObstruction:SetEnabled(bEnabled, bForce) end

---@class CDOTA_Unit_Courier : CDOTA_BaseNPC
---Upgrade the courier ( int param ) times.
---@param iLevel int
---@return void
function CDOTA_Unit_Courier:UpgradeCourier(iLevel) end

---@class CDOTA_Unit_CustomGameAnnouncer
---Determines whether response criteria is matched on server or client
---@param bIsServerAuthoritative bool
---@return void
function CDOTA_Unit_CustomGameAnnouncer:SetServerAuthoritative(bIsServerAuthoritative) end

---@class CDOTA_Unit_Diretide_Portal
---
---@return handle
function CDOTA_Unit_Diretide_Portal:GetPartnerPortal() end

---
---@return void
function CDOTA_Unit_Diretide_Portal:ResetPortal() end

---
---@param nRuneType int
---@return void
function CDOTA_Unit_Diretide_Portal:SetInvasionRuneType(nRuneType) end

---
---@param hPortal handle
---@return void
function CDOTA_Unit_Diretide_Portal:SetPartnerPortal(hPortal) end

---
---@param bActive bool
---@return void
function CDOTA_Unit_Diretide_Portal:SetPortalActive(bActive) end

---@class CDOTA_Unit_Nian : CDOTA_BaseNPC_Creature
---Is the Nian horn?
---@return handle
function CDOTA_Unit_Nian:GetHorn() end

---Is the Nian`s tail broken?
---@return handle
function CDOTA_Unit_Nian:GetTail() end

---Is the Nian`s horn broken?
---@return bool
function CDOTA_Unit_Nian:IsHornAlive() end

---Is the Nian`s tail broken?
---@return bool
function CDOTA_Unit_Nian:IsTailAlive() end

---@class CDebugOverlayScriptHelper
---Draws an axis. Specify origin + orientation in world space.
---@param Vector_1 Vector
---@param Quaternion_2 Quaternion
---@param float_3 float
---@param bool_4 bool
---@param float_5 float
---@return void
function CDebugOverlayScriptHelper:Axis(Vector_1, Quaternion_2, float_3, bool_4, float_5) end

---Draws a world-space axis-aligned box. Specify bounds in world space.
---@param Vector_1 Vector
---@param Vector_2 Vector
---@param int_3 int
---@param int_4 int
---@param int_5 int
---@param int_6 int
---@param bool_7 bool
---@param float_8 float
---@return void
function CDebugOverlayScriptHelper:Box(Vector_1, Vector_2, int_3, int_4, int_5, int_6, bool_7, float_8) end

---Draws an oriented box at the origin. Specify bounds in local space.
---@param Vector_1 Vector
---@param Vector_2 Vector
---@param Vector_3 Vector
---@param Quaternion_4 Quaternion
---@param int_5 int
---@param int_6 int
---@param int_7 int
---@param int_8 int
---@param bool_9 bool
---@param float_10 float
---@return void
function CDebugOverlayScriptHelper:BoxAngles(Vector_1, Vector_2, Vector_3, Quaternion_4, int_5, int_6, int_7, int_8, bool_9, float_10) end

---Draws a capsule. Specify base in world space.
---@param Vector_1 Vector
---@param Quaternion_2 Quaternion
---@param float_3 float
---@param float_4 float
---@param int_5 int
---@param int_6 int
---@param int_7 int
---@param int_8 int
---@param bool_9 bool
---@param float_10 float
---@return void
function CDebugOverlayScriptHelper:Capsule(Vector_1, Quaternion_2, float_3, float_4, int_5, int_6, int_7, int_8, bool_9, float_10) end

---Draws a circle. Specify center in world space.
---@param Vector_1 Vector
---@param Quaternion_2 Quaternion
---@param float_3 float
---@param int_4 int
---@param int_5 int
---@param int_6 int
---@param int_7 int
---@param bool_8 bool
---@param float_9 float
---@return void
function CDebugOverlayScriptHelper:Circle(Vector_1, Quaternion_2, float_3, int_4, int_5, int_6, int_7, bool_8, float_9) end

---Draws a circle oriented to the screen. Specify center in world space.
---@param Vector_1 Vector
---@param float_2 float
---@param int_3 int
---@param int_4 int
---@param int_5 int
---@param int_6 int
---@param bool_7 bool
---@param float_8 float
---@return void
function CDebugOverlayScriptHelper:CircleScreenOriented(Vector_1, float_2, int_3, int_4, int_5, int_6, bool_7, float_8) end

---Draws a wireframe cone. Specify endpoint and direction in world space.
---@param Vector_1 Vector
---@param Vector_2 Vector
---@param float_3 float
---@param float_4 float
---@param int_5 int
---@param int_6 int
---@param int_7 int
---@param int_8 int
---@param bool_9 bool
---@param float_10 float
---@return void
function CDebugOverlayScriptHelper:Cone(Vector_1, Vector_2, float_3, float_4, int_5, int_6, int_7, int_8, bool_9, float_10) end

---Draws a screen-aligned cross. Specify origin in world space.
---@param Vector_1 Vector
---@param float_2 float
---@param int_3 int
---@param int_4 int
---@param int_5 int
---@param int_6 int
---@param bool_7 bool
---@param float_8 float
---@return void
function CDebugOverlayScriptHelper:Cross(Vector_1, float_2, int_3, int_4, int_5, int_6, bool_7, float_8) end

---Draws a world-aligned cross. Specify origin in world space.
---@param Vector_1 Vector
---@param float_2 float
---@param int_3 int
---@param int_4 int
---@param int_5 int
---@param int_6 int
---@param bool_7 bool
---@param float_8 float
---@return void
function CDebugOverlayScriptHelper:Cross3D(Vector_1, float_2, int_3, int_4, int_5, int_6, bool_7, float_8) end

---Draws an oriented cross. Specify origin in world space.
---@param Vector_1 Vector
---@param Quaternion_2 Quaternion
---@param float_3 float
---@param int_4 int
---@param int_5 int
---@param int_6 int
---@param int_7 int
---@param bool_8 bool
---@param float_9 float
---@return void
function CDebugOverlayScriptHelper:Cross3DOriented(Vector_1, Quaternion_2, float_3, int_4, int_5, int_6, int_7, bool_8, float_9) end

---Draws a dashed line. Specify endpoints in world space.
---@param Vector_1 Vector
---@param Vector_2 Vector
---@param float_3 float
---@param int_4 int
---@param int_5 int
---@param int_6 int
---@param int_7 int
---@param int_8 int
---@param bool_9 bool
---@param float_10 float
---@return void
function CDebugOverlayScriptHelper:DrawTickMarkedLine(Vector_1, Vector_2, float_3, int_4, int_5, int_6, int_7, int_8, bool_9, float_10) end

---Draws the attachments of the entity
---@param ehandle_1 ehandle
---@param float_2 float
---@param float_3 float
---@return void
function CDebugOverlayScriptHelper:EntityAttachments(ehandle_1, float_2, float_3) end

---Draws the axis of the entity origin
---@param ehandle_1 ehandle
---@param float_2 float
---@param bool_3 bool
---@param float_4 float
---@return void
function CDebugOverlayScriptHelper:EntityAxis(ehandle_1, float_2, bool_3, float_4) end

---Draws bounds of an entity
---@param ehandle_1 ehandle
---@param int_2 int
---@param int_3 int
---@param int_4 int
---@param int_5 int
---@param bool_6 bool
---@param float_7 float
---@return void
function CDebugOverlayScriptHelper:EntityBounds(ehandle_1, int_2, int_3, int_4, int_5, bool_6, float_7) end

---Draws the skeleton of the entity
---@param ehandle_1 ehandle
---@param float_2 float
---@return void
function CDebugOverlayScriptHelper:EntitySkeleton(ehandle_1, float_2) end

---Draws text on an entity
---@param ehandle_1 ehandle
---@param int_2 int
---@param string_3 string
---@param int_4 int
---@param int_5 int
---@param int_6 int
---@param int_7 int
---@param float_8 float
---@return void
function CDebugOverlayScriptHelper:EntityText(ehandle_1, int_2, string_3, int_4, int_5, int_6, int_7, float_8) end

---Draws a screen-space filled 2D rectangle. Coordinates are in pixels.
---@param Vector2D_1 Vector2D
---@param Vector2D_2 Vector2D
---@param int_3 int
---@param int_4 int
---@param int_5 int
---@param int_6 int
---@param float_7 float
---@return void
function CDebugOverlayScriptHelper:FilledRect2D(Vector2D_1, Vector2D_2, int_3, int_4, int_5, int_6, float_7) end

---Draws a horizontal arrow. Specify endpoints in world space.
---@param Vector_1 Vector
---@param Vector_2 Vector
---@param float_3 float
---@param int_4 int
---@param int_5 int
---@param int_6 int
---@param int_7 int
---@param bool_8 bool
---@param float_9 float
---@return void
function CDebugOverlayScriptHelper:HorzArrow(Vector_1, Vector_2, float_3, int_4, int_5, int_6, int_7, bool_8, float_9) end

---Draws a line between two points
---@param Vector_1 Vector
---@param Vector_2 Vector
---@param int_3 int
---@param int_4 int
---@param int_5 int
---@param int_6 int
---@param bool_7 bool
---@param float_8 float
---@return void
function CDebugOverlayScriptHelper:Line(Vector_1, Vector_2, int_3, int_4, int_5, int_6, bool_7, float_8) end

---Draws a line between two points in screenspace
---@param Vector2D_1 Vector2D
---@param Vector2D_2 Vector2D
---@param int_3 int
---@param int_4 int
---@param int_5 int
---@param int_6 int
---@param float_7 float
---@return void
function CDebugOverlayScriptHelper:Line2D(Vector2D_1, Vector2D_2, int_3, int_4, int_5, int_6, float_7) end

---Pops the identifier used to group overlays. Overlays marked with this identifier can be deleted in a big batch.
---@return void
function CDebugOverlayScriptHelper:PopDebugOverlayScope() end

---Pushes an identifier used to group overlays. Deletes all existing overlays using this overlay id.
---@param utlstringtoken_1 utlstringtoken
---@return void
function CDebugOverlayScriptHelper:PushAndClearDebugOverlayScope(utlstringtoken_1) end

---Pushes an identifier used to group overlays. Overlays marked with this identifier can be deleted in a big batch.
---@param utlstringtoken_1 utlstringtoken
---@return void
function CDebugOverlayScriptHelper:PushDebugOverlayScope(utlstringtoken_1) end

---Removes all overlays marked with a specific identifier, regardless of their lifetime.
---@param utlstringtoken_1 utlstringtoken
---@return void
function CDebugOverlayScriptHelper:RemoveAllInScope(utlstringtoken_1) end

---Draws a solid cone. Specify endpoint and direction in world space.
---@param Vector_1 Vector
---@param Vector_2 Vector
---@param float_3 float
---@param float_4 float
---@param int_5 int
---@param int_6 int
---@param int_7 int
---@param int_8 int
---@param bool_9 bool
---@param float_10 float
---@return void
function CDebugOverlayScriptHelper:SolidCone(Vector_1, Vector_2, float_3, float_4, int_5, int_6, int_7, int_8, bool_9, float_10) end

---Draws a wireframe sphere. Specify center in world space.
---@param Vector_1 Vector
---@param float_2 float
---@param int_3 int
---@param int_4 int
---@param int_5 int
---@param int_6 int
---@param bool_7 bool
---@param float_8 float
---@return void
function CDebugOverlayScriptHelper:Sphere(Vector_1, float_2, int_3, int_4, int_5, int_6, bool_7, float_8) end

---Draws a swept box. Specify endpoints in world space and the bounds in local space.
---@param Vector_1 Vector
---@param Vector_2 Vector
---@param Vector_3 Vector
---@param Vector_4 Vector
---@param Quaternion_5 Quaternion
---@param int_6 int
---@param int_7 int
---@param int_8 int
---@param int_9 int
---@param float_10 float
---@return void
function CDebugOverlayScriptHelper:SweptBox(Vector_1, Vector_2, Vector_3, Vector_4, Quaternion_5, int_6, int_7, int_8, int_9, float_10) end

---Draws 2D text. Specify origin in world space.
---@param Vector_1 Vector
---@param int_2 int
---@param string_3 string
---@param float_4 float
---@param int_5 int
---@param int_6 int
---@param int_7 int
---@param int_8 int
---@param float_9 float
---@return void
function CDebugOverlayScriptHelper:Text(Vector_1, int_2, string_3, float_4, int_5, int_6, int_7, int_8, float_9) end

---Draws a screen-space texture. Coordinates are in pixels.
---@param string_1 string
---@param Vector2D_2 Vector2D
---@param Vector2D_3 Vector2D
---@param int_4 int
---@param int_5 int
---@param int_6 int
---@param int_7 int
---@param Vector2D_8 Vector2D
---@param Vector2D_9 Vector2D
---@param float_10 float
---@return void
function CDebugOverlayScriptHelper:Texture(string_1, Vector2D_2, Vector2D_3, int_4, int_5, int_6, int_7, Vector2D_8, Vector2D_9, float_10) end

---Draws a filled triangle. Specify vertices in world space.
---@param Vector_1 Vector
---@param Vector_2 Vector
---@param Vector_3 Vector
---@param int_4 int
---@param int_5 int
---@param int_6 int
---@param int_7 int
---@param bool_8 bool
---@param float_9 float
---@return void
function CDebugOverlayScriptHelper:Triangle(Vector_1, Vector_2, Vector_3, int_4, int_5, int_6, int_7, bool_8, float_9) end

---Draws 3D text. Specify origin + orientation in world space.
---@param Vector_1 Vector
---@param Quaternion_2 Quaternion
---@param string_3 string
---@param int_4 int
---@param int_5 int
---@param int_6 int
---@param int_7 int
---@param bool_8 bool
---@param float_9 float
---@return void
function CDebugOverlayScriptHelper:VectorText3D(Vector_1, Quaternion_2, string_3, int_4, int_5, int_6, int_7, bool_8, float_9) end

---Draws a vertical arrow. Specify endpoints in world space.
---@param Vector_1 Vector
---@param Vector_2 Vector
---@param float_3 float
---@param int_4 int
---@param int_5 int
---@param int_6 int
---@param int_7 int
---@param bool_8 bool
---@param float_9 float
---@return void
function CDebugOverlayScriptHelper:VertArrow(Vector_1, Vector_2, float_3, int_4, int_5, int_6, int_7, bool_8, float_9) end

---Draws a arrow associated with a specific yaw. Specify endpoints in world space.
---@param Vector_1 Vector
---@param float_2 float
---@param float_3 float
---@param float_4 float
---@param int_5 int
---@param int_6 int
---@param int_7 int
---@param int_8 int
---@param bool_9 bool
---@param float_10 float
---@return void
function CDebugOverlayScriptHelper:YawArrow(Vector_1, float_2, float_3, float_4, int_5, int_6, int_7, int_8, bool_9, float_10) end

---@class CDotaQuest : CBaseEntity
---Add a subquest to this quest
---@param hSubquest handle
---@return void
function CDotaQuest:AddSubquest(hSubquest) end

---Mark this quest complete
---@return void
function CDotaQuest:CompleteQuest() end

---Finds a subquest from this quest by index
---@param nIndex int
---@return handle
function CDotaQuest:GetSubquest(nIndex) end

---Finds a subquest from this quest by name
---@param pszName string
---@return handle
function CDotaQuest:GetSubquestByName(pszName) end

---Remove a subquest from this quest
---@param hSubquest handle
---@return void
function CDotaQuest:RemoveSubquest(hSubquest) end

---Set the text replace string for this quest
---@param pszString string
---@return void
function CDotaQuest:SetTextReplaceString(pszString) end

---Set a quest value
---@param valueSlot int
---@param value int
---@return void
function CDotaQuest:SetTextReplaceValue(valueSlot, value) end

---@class CDotaSubquestBase : CBaseEntity
---Mark this subquest complete
---@return void
function CDotaSubquestBase:CompleteSubquest() end

---Set the text replace string for this subquest
---@param pszString string
---@return void
function CDotaSubquestBase:SetTextReplaceString(pszString) end

---Set a subquest value
---@param valueSlot int
---@param value int
---@return void
function CDotaSubquestBase:SetTextReplaceValue(valueSlot, value) end

---@class CDotaTutorialNPCBlocker
---
---@param bEnabled bool
---@return void
function CDotaTutorialNPCBlocker:SetEnabled(bEnabled) end

---
---@param hBlocker handle
---@return void
function CDotaTutorialNPCBlocker:SetOtherBlocker(hBlocker) end

---@class CEntities
---Creates an entity by classname
---@param string_1 string
---@return handle
function CEntities:CreateByClassname(string_1) end

---Finds all entities by class name. Returns an array containing all the found entities.
---@param string_1 string
---@return table
function CEntities:FindAllByClassname(string_1) end

---Find entities by class name within a radius.
---@param string_1 string
---@param Vector_2 Vector
---@param float_3 float
---@return table
function CEntities:FindAllByClassnameWithin(string_1, Vector_2, float_3) end

---Find entities by model name.
---@param string_1 string
---@return table
function CEntities:FindAllByModel(string_1) end

---Find all entities by name. Returns an array containing all the found entities in it.
---@param string_1 string
---@return table
function CEntities:FindAllByName(string_1) end

---Find entities by name within a radius.
---@param string_1 string
---@param Vector_2 Vector
---@param float_3 float
---@return table
function CEntities:FindAllByNameWithin(string_1, Vector_2, float_3) end

---Find entities by targetname.
---@param string_1 string
---@return table
function CEntities:FindAllByTarget(string_1) end

---Find entities within a radius.
---@param Vector_1 Vector
---@param float_2 float
---@return table
function CEntities:FindAllInSphere(Vector_1, float_2) end

---Find entities by class name. Pass `null` to start an iteration, or reference to a previously found entity to continue a search
---@param handle_1 handle
---@param string_2 string
---@return handle
function CEntities:FindByClassname(handle_1, string_2) end

---Find entities by class name nearest to a point.
---@param string_1 string
---@param Vector_2 Vector
---@param float_3 float
---@return handle
function CEntities:FindByClassnameNearest(string_1, Vector_2, float_3) end

---Find entities by class name within a radius. Pass `null` to start an iteration, or reference to a previously found entity to continue a search
---@param handle_1 handle
---@param string_2 string
---@param Vector_3 Vector
---@param float_4 float
---@return handle
function CEntities:FindByClassnameWithin(handle_1, string_2, Vector_3, float_4) end

---Find entities by model name. Pass `null` to start an iteration, or reference to a previously found entity to continue a search
---@param handle_1 handle
---@param string_2 string
---@return handle
function CEntities:FindByModel(handle_1, string_2) end

---Find entities by model name within a radius. Pass `null` to start an iteration, or reference to a previously found entity to continue a search
---@param handle_1 handle
---@param string_2 string
---@param Vector_3 Vector
---@param float_4 float
---@return handle
function CEntities:FindByModelWithin(handle_1, string_2, Vector_3, float_4) end

---Find entities by name. Pass `null` to start an iteration, or reference to a previously found entity to continue a search
---@param handle_1 handle
---@param string_2 string
---@return handle
function CEntities:FindByName(handle_1, string_2) end

---Find entities by name nearest to a point.
---@param string_1 string
---@param Vector_2 Vector
---@param float_3 float
---@return handle
function CEntities:FindByNameNearest(string_1, Vector_2, float_3) end

---Find entities by name within a radius. Pass `null` to start an iteration, or reference to a previously found entity to continue a search
---@param handle_1 handle
---@param string_2 string
---@param Vector_3 Vector
---@param float_4 float
---@return handle
function CEntities:FindByNameWithin(handle_1, string_2, Vector_3, float_4) end

---Find entities by targetname. Pass `null` to start an iteration, or reference to a previously found entity to continue a search
---@param handle_1 handle
---@param string_2 string
---@return handle
function CEntities:FindByTarget(handle_1, string_2) end

---Find entities within a radius. Pass `null` to start an iteration, or reference to a previously found entity to continue a search
---@param handle_1 handle
---@param Vector_2 Vector
---@param float_3 float
---@return handle
function CEntities:FindInSphere(handle_1, Vector_2, float_3) end

---Begin an iteration over the list of entities
---@return handle
function CEntities:First() end

---Get the local player.
---@return handle
function CEntities:GetLocalPlayer() end

---Continue an iteration over the list of entities, providing reference to a previously found entity
---@param handle_1 handle
---@return handle
function CEntities:Next(handle_1) end

---@class CEntityInstance
---Adds an I/O connection that will call the named function on this entity when the specified output fires.
---@param string_1 string
---@param string_2 string
---@return void
function CEntityInstance:ConnectOutput(string_1, string_2) end

---
---@return void
function CEntityInstance:Destroy() end

---Removes a connected script function from an I/O event on this entity.
---@param string_1 string
---@param string_2 string
---@return void
function CEntityInstance:DisconnectOutput(string_1, string_2) end

---Removes a connected script function from an I/O event on the passed entity.
---@param string_1 string
---@param string_2 string
---@param handle_3 handle
---@return void
function CEntityInstance:DisconnectRedirectedOutput(string_1, string_2, handle_3) end

---触发实体的output，需要在hammer中配置ouptput。
---@param sOutputName string
---@param hActivator handle
---@param hCaller handle
---@param table_4 table
---@param flDelay float
---@return void
function CEntityInstance:FireOutput(sOutputName, hActivator, hCaller, table_4, flDelay) end

---
---@return string
function CEntityInstance:GetClassname() end

---Get the entity name w/help if not defined (i.e. classname/etc)
---@return string
function CEntityInstance:GetDebugName() end

---Get the entity as an EHANDLE
---@return ehandle
function CEntityInstance:GetEntityHandle() end

---
---@return int
function CEntityInstance:GetEntityIndex() end

---Get Integer Attribute
---@param string_1 string
---@return int
function CEntityInstance:GetIntAttr(string_1) end

---
---@return string
function CEntityInstance:GetName() end

---Retrieve, creating if necessary, the private per-instance script-side data associated with an entity
---@return handle
function CEntityInstance:GetOrCreatePrivateScriptScope() end

---Retrieve, creating if necessary, the public script-side data associated with an entity
---@return handle
function CEntityInstance:GetOrCreatePublicScriptScope() end

---Retrieve the private per-instance script-side data associated with an entity
---@return handle
function CEntityInstance:GetPrivateScriptScope() end

---Retrieve the public script-side data associated with an entity
---@return handle
function CEntityInstance:GetPublicScriptScope() end

---Adds an I/O connection that will call the named function on the passed entity when the specified output fires.
---@param string_1 string
---@param string_2 string
---@param handle_3 handle
---@return void
function CEntityInstance:RedirectOutput(string_1, string_2, handle_3) end

---Delete this entity
---@return void
function CEntityInstance:RemoveSelf() end

---Set Integer Attribute
---@param string_1 string
---@param int_2 int
---@return void
function CEntityInstance:SetIntAttr(string_1, int_2) end

---
---@return int
function CEntityInstance:entindex() end

---@class CEnvEntityMaker : CBaseEntity
---Create an entity at the location of the maker
---@return void
function CEnvEntityMaker:SpawnEntity() end

---Create an entity at the location of a specified entity instance
---@param hEntity handle
---@return void
function CEnvEntityMaker:SpawnEntityAtEntityOrigin(hEntity) end

---Create an entity at a specified location and orientaton, orientation is Euler angle in degrees (pitch, yaw, roll)
---@param vecAlternateOrigin Vector
---@param vecAlternateAngles Vector
---@return void
function CEnvEntityMaker:SpawnEntityAtLocation(vecAlternateOrigin, vecAlternateAngles) end

---Create an entity at the location of a named entity
---@param pszName string
---@return void
function CEnvEntityMaker:SpawnEntityAtNamedEntityOrigin(pszName) end

---@class CEnvProjectedTexture : CBaseEntity
---Set light maximum range
---@param flRange float
---@return void
function CEnvProjectedTexture:SetFarRange(flRange) end

---Set light linear attenuation value
---@param flAtten float
---@return void
function CEnvProjectedTexture:SetLinearAttenuation(flAtten) end

---Set light minimum range
---@param flRange float
---@return void
function CEnvProjectedTexture:SetNearRange(flRange) end

---Set light quadratic attenuation value
---@param flAtten float
---@return void
function CEnvProjectedTexture:SetQuadraticAttenuation(flAtten) end

---Turn on/off light volumetrics: bool bOn, float flIntensity, float flNoise, int nPlanes, float flPlaneOffset
---@param bOn bool
---@param flIntensity float
---@param flNoise float
---@param nPlanes int
---@param flPlaneOffset float
---@return void
function CEnvProjectedTexture:SetVolumetrics(bOn, flIntensity, flNoise, nPlanes, flPlaneOffset) end

---@class CFoWBlockerRegion
---AddRectangularBlocker( vMins, vMaxs, bClear ) : Sets or clears a blocker rectangle
---@param vMins Vector
---@param vMaxs Vector
---@param bClearRegion bool
---@return void
function CFoWBlockerRegion:AddRectangularBlocker(vMins, vMaxs, bClearRegion) end

---AddRectangularOutlineBlocker( vMins, vMaxs, bClear ) : Sets or clears a blocker rectangle outline
---@param vMins Vector
---@param vMaxs Vector
---@param bClearRegion bool
---@return void
function CFoWBlockerRegion:AddRectangularOutlineBlocker(vMins, vMaxs, bClearRegion) end

---@class CInfoData : CBaseEntity
---Query color data for this key
---@param tok utlstringtoken
---@param vDefault Vector
---@return Vector
function CInfoData:QueryColor(tok, vDefault) end

---Query float data for this key
---@param tok utlstringtoken
---@param flDefault float
---@return float
function CInfoData:QueryFloat(tok, flDefault) end

---Query int data for this key
---@param tok utlstringtoken
---@param nDefault int
---@return int
function CInfoData:QueryInt(tok, nDefault) end

---Query number data for this key
---@param tok utlstringtoken
---@param flDefault float
---@return float
function CInfoData:QueryNumber(tok, flDefault) end

---Query string data for this key
---@param tok utlstringtoken
---@param pDefault string
---@return string
function CInfoData:QueryString(tok, pDefault) end

---Query vector data for this key
---@param tok utlstringtoken
---@param vDefault Vector
---@return Vector
function CInfoData:QueryVector(tok, vDefault) end

---@class CInfoPlayerStartDota
---Returns whether the object is currently active
---@return bool
function CInfoPlayerStartDota:IsEnabled() end

---Enable or disable the obstruction
---@param bEnabled bool
---@return void
function CInfoPlayerStartDota:SetEnabled(bEnabled) end

---@class CInfoWorldLayer : CBaseEntity
---Hides this layer
---@return void
function CInfoWorldLayer:HideWorldLayer() end

---Shows this layer
---@return void
function CInfoWorldLayer:ShowWorldLayer() end

---@class CLogicRelay
---Trigger( hActivator, hCaller ) : Triggers the logic_relay
---@param hActivator handle
---@param hCaller handle
---@return void
function CLogicRelay:Trigger(hActivator, hCaller) end

---@class CMarkupVolumeTagged : CBaseEntity
---Does this volume have the given tag.
---@param pszTagName string
---@return bool
function CMarkupVolumeTagged:HasTag(pszTagName) end

---@class CNativeOutputs
---Add an output
---@param string_1 string
---@param string_2 string
---@return void
function CNativeOutputs:AddOutput(string_1, string_2) end

---Initialize with number of outputs
---@param int_1 int
---@return void
function CNativeOutputs:Init(int_1) end

---@class CPhysicsProp : CBaseAnimating
---Disable motion for the prop
---@return void
function CPhysicsProp:DisableMotion() end

---Enable motion for the prop
---@return void
function CPhysicsProp:EnableMotion() end

---Enable/disable dynamic vs dynamic continuous collision traces
---@param bIsDynamicVsDynamicContinuousEnabled bool
---@return void
function CPhysicsProp:SetDynamicVsDynamicContinuous(bIsDynamicVsDynamicContinuousEnabled) end

---@class CPointClientUIWorldPanel : CBaseModelEntity
---Tells the panel to accept user input.
---@return void
function CPointClientUIWorldPanel:AcceptUserInput() end

---Adds CSS class(es) to the panel
---@param pszClasses string
---@return void
function CPointClientUIWorldPanel:AddCSSClasses(pszClasses) end

---Tells the panel to ignore user input.
---@return void
function CPointClientUIWorldPanel:IgnoreUserInput() end

---Returns whether this entity is grabbable.
---@return bool
function CPointClientUIWorldPanel:IsGrabbable() end

---Remove CSS class(es) from the panel
---@param pszClasses string
---@return void
function CPointClientUIWorldPanel:RemoveCSSClasses(pszClasses) end

---@class CPointTemplate : CBaseEntity
---DeleteCreatedSpawnGroups() : Deletes any spawn groups that this point_template has spawned. Note: The point_template will not be deleted by this.
---@return void
function CPointTemplate:DeleteCreatedSpawnGroups() end

---ForceSpawn() : Spawns all of the entities the point_template is pointing at.
---@return void
function CPointTemplate:ForceSpawn() end

---GetSpawnedEntities() : Get the list of the most recent spawned entities
---@return handle
function CPointTemplate:GetSpawnedEntities() end

---SetSpawnCallback( hCallbackFunc, hCallbackScope, hCallbackData ) : Set a callback for when the template spawns entities. The spawned entities will be passed in as an array.
---@param hCallbackFunc handle
---@param hCallbackScope handle
---@return void
function CPointTemplate:SetSpawnCallback(hCallbackFunc, hCallbackScope) end

---@class CPointWorldText : CBaseModelEntity
---Set the message on this entity.
---@param pMessage string
---@return void
function CPointWorldText:SetMessage(pMessage) end

---@class CSceneEntity : CBaseEntity
---Adds a team (by index) to the broadcast list
---@param int_1 int
---@return void
function CSceneEntity:AddBroadcastTeamTarget(int_1) end

---Cancel scene playback
---@return void
function CSceneEntity:Cancel() end

---Returns length of this scene in seconds.
---@return float
function CSceneEntity:EstimateLength() end

---Get the camera
---@return handle
function CSceneEntity:FindCamera() end

---given an entity reference, such as !target, get actual entity from scene object
---@param string_1 string
---@return handle
function CSceneEntity:FindNamedEntity(string_1) end

---If this scene is currently paused.
---@return bool
function CSceneEntity:IsPaused() end

---If this scene is currently playing.
---@return bool
function CSceneEntity:IsPlayingBack() end

---given a dummy scene name and a vcd string, load the scene
---@param string_1 string
---@param string_2 string
---@return bool
function CSceneEntity:LoadSceneFromString(string_1, string_2) end

---Removes a team (by index) from the broadcast list
---@param int_1 int
---@return void
function CSceneEntity:RemoveBroadcastTeamTarget(int_1) end

---Start scene playback, takes activatorEntity as param
---@param handle_1 handle
---@return void
function CSceneEntity:Start(handle_1) end

---@class CScriptHeroList
---Returns all the heroes in the world
---@return table
function CScriptHeroList:GetAllHeroes() end

---Get the Nth hero in the Hero List
---@param int_1 int
---@return handle
function CScriptHeroList:GetHero(int_1) end

---Returns the number of heroes in the world
---@return int
function CScriptHeroList:GetHeroCount() end

---@class CScriptKeyValues
---Reads a spawn key
---@param string_1 string
---@return table
function CScriptKeyValues:GetValue(string_1) end

---@class CScriptParticleManager
---创建一个粒子特效，返回特效ID
---@param sParticleName string
---@param iAttachment int
---@param hOwner handle
---@return int
function CScriptParticleManager:CreateParticle(sParticleName, iAttachment, hOwner) end

---Creates a new particle effect that only plays for the specified player
---@param string_1 string
---@param int_2 int
---@param handle_3 handle
---@param handle_4 handle
---@return int
function CScriptParticleManager:CreateParticleForPlayer(string_1, int_2, handle_3, handle_4) end

---Creates a new particle effect that only plays for the specified team
---@param string_1 string
---@param int_2 int
---@param handle_3 handle
---@param int_4 int
---@return int
function CScriptParticleManager:CreateParticleForTeam(string_1, int_2, handle_3, int_4) end

---删除一个粒子特效。如果选择立即删除，将不会播放粒子的结束特效。
---@param iIndex int
---@param bDestroyImmediately bool
---@return void
function CScriptParticleManager:DestroyParticle(iIndex, bDestroyImmediately) end

---获得该粒子特效在该单位身上的替换版本
---@param sParticleName string
---@param hCaster handle
---@return string
function CScriptParticleManager:GetParticleReplacement(sParticleName, hCaster) end

---施放一个特效的索引ID，施放后无法在控制该特效，请保证特效会自己销毁的情况下使用。
---@param iParticleID int
---@return void
function CScriptParticleManager:ReleaseParticleIndex(iParticleID) end

---
---@param int_1 int
---@return void
function CScriptParticleManager:SetParticleAlwaysSimulate(int_1) end

---Set the control point data for a control on a particle effect
---@param int_1 int
---@param int_2 int
---@param Vector_3 Vector
---@return void
function CScriptParticleManager:SetParticleControl(int_1, int_2, Vector_3) end

---将特效（iParticleID）的控制点（iCP）绑定到单位（handle_3）上，该控制点的数据会随着单位的移动而移动
---@param iParticleID int
---@param iCP int
---@param handle_3 handle
---@param int_4 int
---@param string_5 string
---@param Vector_6 Vector
---@param bool_7 bool
---@return void
function CScriptParticleManager:SetParticleControlEnt(iParticleID, iCP, handle_3, int_4, string_5, Vector_6, bool_7) end

---(int iIndex, int iPoint, Vector vecPosition)
---@param int_1 int
---@param int_2 int
---@param Vector_3 Vector
---@return void
function CScriptParticleManager:SetParticleControlFallback(int_1, int_2, Vector_3) end

---(int nFXIndex, int nPoint, vForward)
---@param int_1 int
---@param int_2 int
---@param Vector_3 Vector
---@return void
function CScriptParticleManager:SetParticleControlForward(int_1, int_2, Vector_3) end

---(int nFXIndex, int nPoint, vForward, vRight, vUp) - Set the orientation for a control on a particle effect (NOTE: This is left handed -- bad!!)
---@param int_1 int
---@param int_2 int
---@param Vector_3 Vector
---@param Vector_4 Vector
---@param Vector_5 Vector
---@return void
function CScriptParticleManager:SetParticleControlOrientation(int_1, int_2, Vector_3, Vector_4, Vector_5) end

---(int nFXIndex, int nPoint, Vector vecForward, Vector vecLeft, Vector vecUp) - Set the orientation for a control on a particle effect
---@param int_1 int
---@param int_2 int
---@param Vector_3 Vector
---@param Vector_4 Vector
---@param Vector_5 Vector
---@return void
function CScriptParticleManager:SetParticleControlOrientationFLU(int_1, int_2, Vector_3, Vector_4, Vector_5) end

---设置粒子特效在战争迷雾中的属性。控制点为中心半径为flRadius的圆处于战争迷雾外，该特效即对敌人可见。如果填两个控制点则两点间的宽度为flRadius的矩形范围也计算。不填为-1。
---@param iParticleID int
---@param iControlPoint int
---@param iControlPoint2 int
---@param flRadius float
---@return void
function CScriptParticleManager:SetParticleFoWProperties(iParticleID, iControlPoint, iControlPoint2, flRadius) end

---int nfxindex, bool bCheckFoW
---@param int_1 int
---@param bool_2 bool
---@return bool
function CScriptParticleManager:SetParticleShouldCheckFoW(int_1, bool_2) end

---@class CScriptPrecacheContext
---Precaches a specific resource
---@param string_1 string
---@return void
function CScriptPrecacheContext:AddResource(string_1) end

---Reads a spawn key
---@param string_1 string
---@return table
function CScriptPrecacheContext:GetValue(string_1) end

---@class Convars : Convars
---GetBool(name) : returns the convar as a boolean flag.
---@param string_1 string
---@return table
function Convars:GetBool(string_1) end

---GetCommandClient() : returns the player who issued this console command.
---@return handle
function Convars:GetCommandClient() end

---GetDOTACommandClient() : returns the DOTA player who issued this console command.
---@return handle
function Convars:GetDOTACommandClient() end

---GetFloat(name) : returns the convar as a float. May return null if no such convar.
---@param string_1 string
---@return table
function Convars:GetFloat(string_1) end

---GetInt(name) : returns the convar as an int. May return null if no such convar.
---@param string_1 string
---@return table
function Convars:GetInt(string_1) end

---GetStr(name) : returns the convar as a string. May return null if no such convar.
---@param string_1 string
---@return table
function Convars:GetStr(string_1) end

---RegisterCommand(name, fn, helpString, flags) : register a console command.
---@param string_1 string
---@param handle_2 handle
---@param string_3 string
---@param int_4 int
---@return void
function Convars:RegisterCommand(string_1, handle_2, string_3, int_4) end

---RegisterConvar(name, defaultValue, helpString, flags): register a new console variable.
---@param string_1 string
---@param string_2 string
---@param string_3 string
---@param int_4 int
---@return void
function Convars:RegisterConvar(string_1, string_2, string_3, int_4) end

---SetBool(name, val) : sets the value of the convar to the bool.
---@param string_1 string
---@param bool_2 bool
---@return void
function Convars:SetBool(string_1, bool_2) end

---SetFloat(name, val) : sets the value of the convar to the float.
---@param string_1 string
---@param float_2 float
---@return void
function Convars:SetFloat(string_1, float_2) end

---SetInt(name, val) : sets the value of the convar to the int.
---@param string_1 string
---@param int_2 int
---@return void
function Convars:SetInt(string_1, int_2) end

---SetStr(name, val) : sets the value of the convar to the string.
---@param string_1 string
---@param string_2 string
---@return void
function Convars:SetStr(string_1, string_2) end

---@class GlobalSys : GlobalSys
---CommandLineCheck(name) : returns true if the command line param was used, otherwise false.
---@param string_1 string
---@return table
function GlobalSys:CommandLineCheck(string_1) end

---CommandLineFloat(name) : returns the command line param as a float.
---@param string_1 string
---@param float_2 float
---@return table
function GlobalSys:CommandLineFloat(string_1, float_2) end

---CommandLineInt(name) : returns the command line param as an int.
---@param string_1 string
---@param int_2 int
---@return table
function GlobalSys:CommandLineInt(string_1, int_2) end

---CommandLineStr(name) : returns the command line param as a string.
---@param string_1 string
---@param string_2 string
---@return table
function GlobalSys:CommandLineStr(string_1, string_2) end

---@class GridNav : GridNav
---Determine if it is possible to reach the specified end point from the specified start point. bool (vStart, vEnd)
---@param Vector_1 Vector
---@param Vector_2 Vector
---@return bool
function GridNav:CanFindPath(Vector_1, Vector_2) end

---Destroy all trees in the area(vPosition, flRadius, bFullCollision
---@param Vector_1 Vector
---@param float_2 float
---@param bool_3 bool
---@return void
function GridNav:DestroyTreesAroundPoint(Vector_1, float_2, bool_3) end

---Find a path between the two points an return the length of the path. If there is not a path between the points the returned value will be -1. float (vStart, vEnd )
---@param Vector_1 Vector
---@param Vector_2 Vector
---@return float
function GridNav:FindPathLength(Vector_1, Vector_2) end

---Returns a table full of tree HSCRIPTS (vPosition, flRadius, bFullCollision).
---@param Vector_1 Vector
---@param float_2 float
---@param bool_3 bool
---@return table
function GridNav:GetAllTreesAroundPoint(Vector_1, float_2, bool_3) end

---Get the X position of the center of a given X index
---@param int_1 int
---@return float
function GridNav:GridPosToWorldCenterX(int_1) end

---Get the Y position of the center of a given Y index
---@param int_1 int
---@return float
function GridNav:GridPosToWorldCenterY(int_1) end

---Checks whether the given position is blocked
---@param Vector_1 Vector
---@return bool
function GridNav:IsBlocked(Vector_1) end

---(position, radius, checkFullTreeRadius?) Checks whether there are any trees overlapping the given point
---@param Vector_1 Vector
---@param float_2 float
---@param bool_3 bool
---@return bool
function GridNav:IsNearbyTree(Vector_1, float_2, bool_3) end

---判断目标位置是否可通行
---@param Vector_1 Vector
---@return bool
function GridNav:IsTraversable(Vector_1) end

---Causes all trees in the map to regrow
---@return void
function GridNav:RegrowAllTrees() end

---Get the X index of a given world X position
---@param float_1 float
---@return int
function GridNav:WorldToGridPosX(float_1) end

---Get the Y index of a given world Y position
---@param float_1 float
---@return int
function GridNav:WorldToGridPosY(float_1) end

---@class ProjectileManager : ProjectileManager
---Update speed
---@param handle_1 handle
---@param int_2 int
---@return void
function ProjectileManager:ChangeTrackingProjectileSpeed(handle_1, int_2) end

---创建一个线性投射物，返回投射物ID。参数: Ability, Source, vSpawnOrigin, vVelocity, vAcceleration, fDistance, fStartRadius, fEndRadius, bHasFrontalCone, iUnitTargetTeam, iUnitTargetType, iUnitTargetFlags, bProvidesVision, iVisionTeamNumber, iVisionRadius, bDrawsOnMinimap, bVisibleToEnemies, bIgnoreSource,fExpireTime, fMaxSpeed
---@param tInfo handle
---@return int
function ProjectileManager:CreateLinearProjectile(tInfo) end

---Creates a tracking projectile
---@param handle_1 handle
---@return int
function ProjectileManager:CreateTrackingProjectile(handle_1) end

---Destroys the linear projectile matching the argument ID
---@param int_1 int
---@return void
function ProjectileManager:DestroyLinearProjectile(int_1) end

---Destroy a tracking projectile early
---@param int_1 int
---@return void
function ProjectileManager:DestroyTrackingProjectile(int_1) end

---Returns current location of projectile
---@param int_1 int
---@return Vector
function ProjectileManager:GetLinearProjectileLocation(int_1) end

---Returns current radius of projectile
---@param int_1 int
---@return float
function ProjectileManager:GetLinearProjectileRadius(int_1) end

---Returns a vector representing the current velocity of the projectile.
---@param int_1 int
---@return Vector
function ProjectileManager:GetLinearProjectileVelocity(int_1) end

---Returns current location of projectile
---@param int_1 int
---@return Vector
function ProjectileManager:GetTrackingProjectileLocation(int_1) end

---Is this a valid projectile?
---@param int_1 int
---@return bool
function ProjectileManager:IsValidProjectile(int_1) end

---Makes the specified unit dodge projectiles
---@param handle_1 handle
---@return void
function ProjectileManager:ProjectileDodge(handle_1) end

---Update velocity
---@param int_1 int
---@param Vector_2 Vector
---@param float_3 float
---@return void
function ProjectileManager:UpdateLinearProjectileDirection(int_1, Vector_2, float_3) end

---@class SteamInfo : SteamInfo
---Is the script connected to the public Steam universe
---@return bool
function SteamInfo:IsPublicUniverse() end

---@class Vector
---Cross product of two vectors.
---@param a Vector
---@param b Vector
---@return Vector
function Vector:Cross(a, b) end

---Dot product of two vectors.
---@param a Vector
---@param b Vector
---@return float
function Vector:Dot(a, b) end

---Length of the Vector.
---@return float
function Vector:Length() end

---Length of the Vector in the XY plane.
---@return float
function Vector:Length2D() end

---Linear interpolation between the vector and the passed in target over t = [0,1].
---@param target Vector
---@param t float
---@return Vector
function Vector:Lerp(target, t) end

---Returns the vector normalized.
---@return Vector
function Vector:Normalized() end

---Overloaded +. Adds vectors together.
---@param a Vector
---@param b Vector
---@return Vector
function Vector:__add(a, b) end

---Overloaded /. Divides vectors.
---@param a Vector
---@param b Vector
---@return Vector
function Vector:__div(a, b) end

---Overloaded ==. Tests for Equality.
---@param a Vector
---@param b Vector
---@return bool
function Vector:__eq(a, b) end

---Overloaded # returns the length of the vector.
---@return float
function Vector:__len() end

---Overloaded * returns the vectors multiplied together. can also be used to multiply with scalars.
---@param a Vector
---@param b Vector
---@return Vector
function Vector:__mul(a, b) end

---Overloaded -. Subtracts vectors
---@param a Vector
---@param b Vector
---@return Vector
function Vector:__sub(a, b) end

---Overloaded .. Converts vectors to strings
---@return string
function Vector:__tostring() end

---Overloaded unary - operator. Reverses the vector.
---@return Vector
function Vector:__unm() end

---创建一个新的Vector，使用笛卡尔坐标系。成员变量x,y,z。
---@param x float
---@param y float
---@param z float
---@return Vector
function Vector:constructor(x, y, z) end

---@class QAngle
---Returns the forward vector.
---@return Vector
function QAngle:Forward() end

---Returns the Left vector.
---@return Vector
function QAngle:Left() end

---Returns the Up vector.
---@return Vector
function QAngle:Up() end

---Overloaded +. Adds angles together.<br>Note: Use RotateOrientation() instead to properly rotate angles.
---@param a QAngle
---@param b QAngle
---@return QAngle
function QAngle:__add(a, b) end

---Overloaded ==. Tests for Equality
---@param a QAngle
---@param b QAngle
---@return QAngle
function QAngle:__eq(a, b) end

---Overloaded .. Converts the QAngle to a human readable string.
---@return string
function QAngle:__tostring() end

---创建一个新的QAngle。成员变量x,y,z。
---@param pitch float
---@param yaw float
---@param roll float
---@return QAngle
function QAngle:constructor(pitch, yaw, roll) end

---@class utilsinit.lua
---将传入值限制在最大值与最小值之间。
---@param val float
---@param min float
---@param max float
---@return float
function Clamp(val, min, max) end

---将角度转换为弧度。
---@param deg float
---@return float
function Deg2Rad(deg) end

---线性插值。传入[0, 1]的值，返回[min, max]中的线性插值。
---@param val float
---@param min float
---@param max float
---@return float
function Lerp(val, min, max) end

---将两个表合并为第三个表，覆盖所有匹配键（t1覆盖t2）。
---@param t1 table
---@param t2 table
---@return table
function Merge(t1, t2) end

---将弧度转换为角度。
---@param rad float
---@return float
function Rad2Deg(rad) end

---将传入值从范围[a, b]映射到范围[c, d]。返回值有可能超过范围[c, d]。
---@param input float
---@param a float
---@param b float
---@param c float
---@param d float
---@return float
function RemapVal(input, a, b, c, d) end

---将传入值从范围[a, b]映射到范围[c, d]。并且将返回值限制在范围[c, d]。
---@param input float
---@param a float
---@param b float
---@param c float
---@param d float
---@return float
function RemapValClamped(input, a, b, c, d) end

---两个矢量之间的距离<br>return math.sqrt(VectorDistanceSq(v1, v2))
---@param v1 Vector
---@param v2 Vector
---@return float
function VectorDistance(v1, v2) end

---两个矢量之间的距离平方(比计算平面距离快)<br>return (v1.x - v2.x) * (v1.x - v2.x) + (v1.y - v2.y) * (v1.y - v2.y) + (v1.z - v2.z) * (v1.z - v2.z)
---@param v1 Vector
---@param v2 Vector
---@return float
function VectorDistanceSq(v1, v2) end

---检查向量是否为零向量。<br>return (v.x == 0.0) and (v.y == 0.0) and (v.z == 0.0)
---@param v Vector
---@return bool
function VectorIsZero(v) end

---向量值在[0，1]上的线性插值。跟另一个全局函数LerpVectors功能一样。<br>return Vector(Lerp(t, a.x, b.x), Lerp(t, a.y, b.y), Lerp(t, a.z, b.z))
---@param t Vector
---@param v1 Vector
---@param v2 Vector
---@return Vector
function VectorLerp(t, v1, v2) end

---取绝对值
---@param val float
---@return float
function abs(val) end

---返回其中的较大值。
---@param a float
---@param b float
---@return float
function max(a, b) end

---返回其中的较小值。
---@param a float
---@param b float
---@return float
function min(a, b) end

---@class VLua
---Implements Squirrel clear table method.
---@param t table
---@return table
function vlua.clear(t) end

---Implements Squirrel clone operator.
---@param t table
---@return table
function vlua.clone(t) end

---Implements Squirrel three way compare operator ( <=> ).
---@param a float
---@param b float
---@return int
function vlua.compare(a, b) end

---Implements Squirrel in operator.
---@param t table
---@param key variable
---@return bool
function vlua.contains(t, key) end

---Implements Squirrel slot delete operator.
---@param t table
---@param key variable
---@return table
function vlua.delete(t, key) end

---Implements Squirrel extend method for tables.
---@param o table
---@param array array
---@return table
function vlua.extend(o, array) end

---Implements Squirrel find method for tables and strings. (o, substr, [startidx]) for strings, (o, value) for tables
---@param o [table/string]
---@param value variable
---@param startIndex int
---@return variable
function vlua.find(o, value, startIndex) end

---Implements Squirrel map method for tables.
---@param o table
---@param mapFunc function
---@return table
function vlua.map(o, mapFunc) end

---Implements Squirrel rawdelete library function.
---@param t table
---@param key variable
---@return table
function vlua.rawdelete(t, key) end

---Implements Squirrel rawin library function.
---@param t table
---@param key variable
---@return table
function vlua.rawin(t, key) end

---Implements Squirrel reduce method for tables.
---@param o table
---@param reduceFunc function
---@return table
function vlua.reduce(o, reduceFunc) end

---Implements Squirrel resize method for tables.
---@param o string
---@param size int
---@param fill variable
---@return table
function vlua.resize(o, size, fill) end

---Implements Squirrel reverse method for tables.
---@param o table
---@return table
function vlua.reverse(o) end

---Safe Ternary operator. The Lua version will return the wrong value if the value if true is nil.
---@param conditional bool
---@param valueIfTrue variable
---@param valueIfFalse variable
---@return variable
function vlua.select(conditional, valueIfTrue, valueIfFalse) end

---Implements Squirrel slice method for tables and strings.
---@param o [table/string]
---@param startIndex int
---@param endIndex int
---@return variable
function vlua.slice(o, startIndex, endIndex) end

---Implements Squirrel split function for strings.
---@param input string
---@param separator string
---@return table
function vlua.split(input, separator) end

---Implements tableadd function to support += paradigm used in Squirrel.
---@param t1 table
---@param t2 table
---@return table
function vlua.tableadd(t1, t2) end

