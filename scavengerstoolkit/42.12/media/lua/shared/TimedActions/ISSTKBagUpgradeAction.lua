--- @file scavengerstoolkit\42.12\media\lua\shared\TimedActions\ISSTKBagUpgradeAction.lua
--- @brief Timed actions for STK bag upgrades
---
--- Responsible ONLY for:
---   - Character animation (CharacterActionAnims.Craft)
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
-- BASE CLASS
-- ============================================================================

--- @class ISSTKBagUpgradeAction : ISBaseTimedAction
--- @field character any IsoPlayer
--- @field bag any InventoryItem bag being upgraded
--- @field jobType string Progress bar text
--- @field maxTime number Action duration in ticks
--- @field stopOnWalk boolean
--- @field stopOnRun boolean
--- @field forceProgressBar boolean
ISSTKBagUpgradeAction = ISBaseTimedAction:derive("ISSTKBagUpgradeAction")

--- Returns false if the character or bag are no longer valid.
--- @return boolean
function ISSTKBagUpgradeAction:isValid()
	return self.character ~= nil and self.bag ~= nil and self.character:getInventory():contains(self.bag)
end

--- Updates the metabolic target and progress bar each tick.
function ISSTKBagUpgradeAction:update()
	self.character:setMetabolicTarget(Metabolics.UsingTools)
	self.bag:setJobDelta(self:getJobDelta())
end

--- Starts animation and progress bar.
function ISSTKBagUpgradeAction:start()
	self:setActionAnim(CharacterActionAnims.Craft)
	self.bag:setJobType(self.jobType)
	self.bag:setJobDelta(0.0)
end

--- Clears the progress bar when the action is interrupted.
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

	local inv = self.character:getInventory()
	if not inv:contains("Base.Needle") then
		return false
	end
	if not inv:contains("Base.Thread") then
		return false
	end
	if not self.upgradeItem or not inv:contains(self.upgradeItem) then
		return false
	end

	return STK_Core.canAddUpgrade(self.bag)
end

--- Clears progress bar and fires OnSTKActionAddComplete.
--- Server (STK_Commands) handles the rest.
function ISSTKBagAddUpgradeAction:perform()
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

	-- Check tool: scissors OR knife (if enabled) — read-only via STK_Core
	if not STK_Core.hasRequiredTools(self.character, "remove") then
		return false
	end

	-- Check upgrade still exists in bag
	local imd = self.bag:getModData()
	for _, upgrade in ipairs(imd.LUpgrades) do
		if upgrade == self.upgradeType then
			return true
		end
	end

	return false
end

--- Clears progress bar and fires OnSTKActionRemoveComplete.
--- Server (STK_Commands) handles the rest.
function ISSTKBagRemoveUpgradeAction:perform()
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
	o.jobType = getText("UI_STK_RemovingUpgrade")
	o.maxTime = SandboxVars.STK.RemoveUpgradeTime or 80
	o.stopOnWalk = true
	o.stopOnRun = true
	o.forceProgressBar = true

	return o
end
