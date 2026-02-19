--- @file scavengerstoolkit\42.12\media\lua\shared\TimedActions\ISSTKBagUpgradeAction.lua
--- @brief Timed actions for STK bag upgrades
---
--- Responsible ONLY for:
---   - Character animation and sounds
---   - Progress bar on the bag
---   - isValid() checks (read-only, via STK_Core)
---   - Firing the appropriate Event on perform() completion
---
--- What this file does NOT do:
---   - Apply upgrades (STK_UpgradeLogic, server)
---   - Grant XP (STK_TailoringXP, server)
---   - Degrade tools (STK_UpgradeLogic, server)
---   - Display feedback (STK_FeedbackSystem, client)
---
--- Sounds (confirmed in B42.12 via console):
---   - Add upgrade:    "Sewing"         + animation SewingCloth
---   - Remove upgrade: "ClothesRipping" + animation Craft
---
--- NOTE (Refactor v3.0 — Dia 4): self.onComplete removed. perform() now
--- triggers Events.OnSTKActionAddComplete / OnSTKActionRemoveComplete.
--- The server (STK_Commands) listens and executes the actual logic.
---
--- @author Scavenger's Toolkit Development Team
--- @version 3.0.0
--- @license MIT
--- @copyright 2026 Scavenger's Toolkit

require("TimedActions/ISBaseTimedAction")
local STK_Core = require("STK_Core")

-- ============================================================================
-- HELPERS
-- ============================================================================

--- Returns true if the player has the item type in main inventory or any
--- equipped container. Mirrors STK_Core internal logic for use in isValid()
--- checks during the timed action.
--- @param character any IsoPlayer
--- @param itemType string Full type string e.g. "Base.Needle"
--- @return boolean
local function characterHasItemType(character, itemType)
	if character:getInventory():contains(itemType) then
		return true
	end
	local wornItems = character:getWornItems()
	for i = 0, wornItems:size() - 1 do
		local worn = wornItems:getItemByIndex(i)
		if worn and worn:IsInventoryContainer() then
			if worn:getInventory():contains(itemType) then
				return true
			end
		end
	end
	return false
end

--- Returns true if the item instance exists in main inventory or any
--- equipped container.
--- @param character any IsoPlayer
--- @param item any InventoryItem
--- @return boolean
local function characterHasItemInstance(character, item)
	local items = character:getInventory():getItems()
	for i = 0, items:size() - 1 do
		if items:get(i) == item then
			return true
		end
	end
	local wornItems = character:getWornItems()
	for i = 0, wornItems:size() - 1 do
		local worn = wornItems:getItemByIndex(i)
		if worn and worn:IsInventoryContainer() then
			local contents = worn:getInventory():getItems()
			for j = 0, contents:size() - 1 do
				if contents:get(j) == item then
					return true
				end
			end
		end
	end
	return false
end

--- Stops a sound safely. No-op if sound is nil or already stopped.
--- @param character any IsoPlayer
--- @param sound any Sound handle returned by playSound
local function stopSound(character, sound)
	if sound and character:getEmitter():isPlaying(sound) then
		character:getEmitter():stopSound(sound)
	end
end

-- ============================================================================
-- BASE CLASS
-- ============================================================================

--- @class ISSTKBagUpgradeAction : ISBaseTimedAction
--- @field character any IsoPlayer
--- @field bag any InventoryItem bag being upgraded
--- @field sound any Sound handle (set by subclasses in start())
--- @field jobType string Progress bar text
--- @field maxTime number Action duration in ticks
--- @field stopOnWalk boolean
--- @field stopOnRun boolean
--- @field forceProgressBar boolean
ISSTKBagUpgradeAction = ISBaseTimedAction:derive("ISSTKBagUpgradeAction")

--- Returns false if the character or bag are no longer valid.
--- @return boolean
function ISSTKBagUpgradeAction:isValid()
	return self.character ~= nil and self.bag ~= nil and characterHasItemInstance(self.character, self.bag)
end

--- Updates the metabolic target and progress bar each tick.
function ISSTKBagUpgradeAction:update()
	self.character:setMetabolicTarget(Metabolics.UsingTools)
	self.bag:setJobDelta(self:getJobDelta())
end

--- Clears the progress bar when the action is interrupted.
--- Subclasses override stop() and must call ISBaseTimedAction.stop(self)
--- after stopping their own sound.
function ISSTKBagUpgradeAction:stop()
	self.bag:setJobDelta(0.0)
	ISBaseTimedAction.stop(self)
end

-- ============================================================================
-- ADD UPGRADE ACTION
-- ============================================================================

--- @class ISSTKBagAddUpgradeAction : ISSTKBagUpgradeAction
--- @field upgradeItem any InventoryItem upgrade to add
ISSTKBagAddUpgradeAction = ISSTKBagUpgradeAction:derive("ISSTKBagAddUpgradeAction")

--- Returns false if tools or upgrade item are gone mid-action.
--- @return boolean
function ISSTKBagAddUpgradeAction:isValid()
	if not ISSTKBagUpgradeAction.isValid(self) then
		return false
	end
	if not characterHasItemType(self.character, "Base.Needle") then
		return false
	end
	if not characterHasItemType(self.character, "Base.Thread") then
		return false
	end
	if not self.upgradeItem or not characterHasItemInstance(self.character, self.upgradeItem) then
		return false
	end
	return STK_Core.canAddUpgrade(self.bag)
end

--- Starts sewing animation and sound.
function ISSTKBagAddUpgradeAction:start()
	self:setActionAnim("SewingCloth")
	self.sound = self.character:getEmitter():playSound("Sewing")
	self.bag:setJobType(self.jobType)
	self.bag:setJobDelta(0.0)
end

--- Stops sound and clears progress bar when interrupted.
function ISSTKBagAddUpgradeAction:stop()
	stopSound(self.character, self.sound)
	self.bag:setJobDelta(0.0)
	ISBaseTimedAction.stop(self)
end

--- Stops sound, clears progress bar and fires OnSTKActionAddComplete.
--- Server (STK_Commands) handles the rest.
function ISSTKBagAddUpgradeAction:perform()
	stopSound(self.character, self.sound)
	self.bag:setJobDelta(0.0)
	triggerEvent("OnSTKActionAddComplete", self.bag, self.upgradeItem, self.character)
	ISBaseTimedAction.perform(self)
end

--- @param character any IsoPlayer
--- @param bag any InventoryItem bag
--- @param upgradeItem any InventoryItem upgrade to add
--- @return ISSTKBagAddUpgradeAction
function ISSTKBagAddUpgradeAction:new(character, bag, upgradeItem)
	local o = {}
	setmetatable(o, self)
	self.__index = self

	o.character = character
	o.bag = bag
	o.upgradeItem = upgradeItem
	o.sound = nil
	o.jobType = getText("UI_STK_InstallingUpgrade")
	o.maxTime = SandboxVars.STK.AddUpgradeTime or 100
	o.stopOnWalk = true
	o.stopOnRun = true
	o.forceProgressBar = true

	return o
end

-- ============================================================================
-- REMOVE UPGRADE ACTION
-- ============================================================================

--- @class ISSTKBagRemoveUpgradeAction : ISSTKBagUpgradeAction
--- @field upgradeType string Upgrade type without "STK." prefix
ISSTKBagRemoveUpgradeAction = ISSTKBagUpgradeAction:derive("ISSTKBagRemoveUpgradeAction")

--- Returns false if tools or the upgrade are gone mid-action.
--- @return boolean
function ISSTKBagRemoveUpgradeAction:isValid()
	if not ISSTKBagUpgradeAction.isValid(self) then
		return false
	end
	if not STK_Core.hasRequiredTools(self.character, "remove") then
		return false
	end
	local imd = self.bag:getModData()
	for _, upgrade in ipairs(imd.LUpgrades) do
		if upgrade == self.upgradeType then
			return true
		end
	end
	return false
end

--- Starts cutting animation and sound.
function ISSTKBagRemoveUpgradeAction:start()
	self:setActionAnim("SewingCloth")
	self.sound = self.character:getEmitter():playSound("Sewing")
	self.bag:setJobType(self.jobType)
	self.bag:setJobDelta(0.0)
end

--- Stops sound and clears progress bar when interrupted.
function ISSTKBagRemoveUpgradeAction:stop()
	stopSound(self.character, self.sound)
	self.bag:setJobDelta(0.0)
	ISBaseTimedAction.stop(self)
end

--- Stops sound, clears progress bar and fires OnSTKActionRemoveComplete.
--- Server (STK_Commands) handles the rest.
function ISSTKBagRemoveUpgradeAction:perform()
	stopSound(self.character, self.sound)
	self.bag:setJobDelta(0.0)
	triggerEvent("OnSTKActionRemoveComplete", self.bag, self.upgradeType, self.character)
	ISBaseTimedAction.perform(self)
end

--- @param character any IsoPlayer
--- @param bag any InventoryItem bag
--- @param upgradeType string Upgrade type without "STK." prefix
--- @return ISSTKBagRemoveUpgradeAction
function ISSTKBagRemoveUpgradeAction:new(character, bag, upgradeType)
	local o = {}
	setmetatable(o, self)
	self.__index = self

	o.character = character
	o.bag = bag
	o.upgradeType = upgradeType
	o.sound = nil
	o.jobType = getText("UI_STK_RemovingUpgrade")
	o.maxTime = SandboxVars.STK.RemoveUpgradeTime or 80
	o.stopOnWalk = true
	o.stopOnRun = true
	o.forceProgressBar = true

	return o
end
