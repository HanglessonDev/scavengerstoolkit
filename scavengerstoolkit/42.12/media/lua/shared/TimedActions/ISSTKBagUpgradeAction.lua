--- @file scavengerstoolkit\42.12\media\lua\shared\TimedActions\ISSTKBagUpgradeAction.lua
--- Timed Actions para Upgrades de Mochilas STK - VERSÃO 100% FUNCIONAL
require("TimedActions/ISBaseTimedAction")
local STKBagUpgrade = require("STKBagUpgrade")

-- ============================================================================
-- CLASSE BASE PARA AÇÕES STK
-- ============================================================================

--- @class ISSTKBagUpgradeAction : ISBaseTimedAction
--- @field character any The character performing the action
--- @field onComplete function The function to call when the action is complete
--- @field bag any The bag being upgraded
--- @field itemInfo any The item information
--- @field jobType string The job type description
--- @field maxTime number The time required for the action
--- @field stopOnWalk boolean Whether to stop the action when walking
--- @field stopOnRun boolean Whether to stop the action when running
--- @field forceProgressBar boolean Whether to force the progress bar to show
ISSTKBagUpgradeAction = ISBaseTimedAction:derive("ISSTKBagUpgradeAction")

--- Validate the action
--- @return boolean isValid True if the action is valid, false otherwise
function ISSTKBagUpgradeAction:isValid()
	return self.character and self.bag and self.character:getInventory():contains(self.bag)
end

--- Update the action progress
function ISSTKBagUpgradeAction:update()
	self.character:setMetabolicTarget(Metabolics.UsingTools)
	-- Atualiza barra de progresso no item
	self.bag:setJobDelta(self:getJobDelta())
end

--- Start the action
function ISSTKBagUpgradeAction:start()
	self:setActionAnim(CharacterActionAnims.Craft)
	-- Mostra barra de progresso no item
	self.bag:setJobType(self.jobType)
	self.bag:setJobDelta(0.0)
end

--- Stop the action
function ISSTKBagUpgradeAction:stop()
	-- Remove barra de progresso
	self.bag:setJobDelta(0.0)
	ISBaseTimedAction.stop(self)
end

--- Perform the action
function ISSTKBagUpgradeAction:perform()
	-- Remove barra de progresso
	self.bag:setJobDelta(0.0)

	if self.onComplete then
		self.onComplete(self.bag, self.itemInfo, self.character)
	end

	ISBaseTimedAction.perform(self)
end

--- Constructor for ISSTKBagUpgradeAction
--- @param character any The character performing the action
--- @param onComplete function The function to call when the action is complete
--- @param bag any The bag being upgraded
--- @param itemInfo any The item information
--- @param jobType string The job type description
--- @param time number The time required for the action
--- @return ISSTKBagUpgradeAction The new action instance
function ISSTKBagUpgradeAction:new(character, onComplete, bag, itemInfo, jobType, time)
	local o = {}
	setmetatable(o, self)
	self.__index = self

	o.character = character
	o.onComplete = onComplete
	o.bag = bag
	o.itemInfo = itemInfo
	o.jobType = jobType
	o.maxTime = time or 100
	o.stopOnWalk = true
	o.stopOnRun = true
	o.forceProgressBar = true

	return o
end

-- ============================================================================
-- AÇÃO: ADICIONAR UPGRADE
-- ============================================================================

--- @class ISSTKBagAddUpgradeAction : ISSTKBagUpgradeAction
ISSTKBagAddUpgradeAction = ISSTKBagUpgradeAction:derive("ISSTKBagAddUpgradeAction")

--- Validate the add upgrade action
--- @return boolean isValid True if the action is valid, false otherwise
function ISSTKBagAddUpgradeAction:isValid()
	-- Validação da classe pai (personagem e mochila existem)
	if not ISSTKBagUpgradeAction.isValid(self) then
		return false
	end

	-- Verifica se ainda tem as ferramentas necessárias
	local hasNeedle = self.character:getInventory():contains("Base.Needle")
	local hasThread = self.character:getInventory():contains("Base.Thread")

	if not (hasNeedle and hasThread) then
		return false
	end

	-- Verifica se o item de upgrade ainda existe
	if not self.itemInfo or not self.character:getInventory():contains(self.itemInfo) then
		return false
	end

	-- Verifica se ainda tem espaço para upgrades
	local imd = self.bag:getModData()
	return #imd.LUpgrades < imd.LMaxUpgrades
end

--- Perform the add upgrade action
function ISSTKBagAddUpgradeAction:perform()
	-- Consumir linha
	local thread = self.character:getInventory():getFirstType("Base.Thread")
	if thread then
		thread:UseAndSync()
	end

	-- Chama a função pai que executa o callback
	ISSTKBagUpgradeAction.perform(self)
end

--- Constructor for ISSTKBagAddUpgradeAction
--- @param character any The character performing the action
--- @param bag any The bag being upgraded
--- @param upgradeItem any The upgrade item to add
--- @return ISSTKBagAddUpgradeAction The new action instance
function ISSTKBagAddUpgradeAction:new(character, bag, upgradeItem)
	local o = {}
	setmetatable(o, self)

	o.character = character
	o.onComplete = STKBagUpgrade.applyUpgrade
	o.bag = bag
	o.itemInfo = upgradeItem
	o.jobType = getText("UI_STK_InstallingUpgrade")
	o.maxTime = SandboxVars.STK.AddUpgradeTime or 100
	o.stopOnWalk = true
	o.stopOnRun = true
	o.forceProgressBar = true

	return o
end

-- ============================================================================
-- AÇÃO: REMOVER UPGRADE
-- ============================================================================

--- @class ISSTKBagRemoveUpgradeAction : ISSTKBagUpgradeAction
--- @field character any The character performing the action
--- @field onComplete function The function to call when the action is complete
--- @field bag any The bag being upgraded
--- @field itemInfo any The item information
--- @field jobType string The job type description
--- @field maxTime number The time required for the action
--- @field stopOnWalk boolean Whether to stop the action when walking
--- @field stopOnRun boolean Whether to stop the action when running
--- @field forceProgressBar boolean Whether to force the progress bar to show
ISSTKBagRemoveUpgradeAction = ISSTKBagUpgradeAction:derive("ISSTKBagRemoveUpgradeAction")

--- Validate the remove upgrade action
--- @return boolean isValid True if the action is valid, false otherwise
function ISSTKBagRemoveUpgradeAction:isValid()
	-- Validação da classe pai
	if not ISSTKBagUpgradeAction.isValid(self) then
		return false
	end

	-- Verifica se ainda tem as ferramentas necessarias (tesoura OU faca)
	local hasTools = STKBagUpgrade.hasRequiredTools(self.character, "remove")
	if not hasTools then
		return false
	end

	-- Verifica se o upgrade ainda existe na mochila
	local imd = self.bag:getModData()
	for _, upgrade in ipairs(imd.LUpgrades) do
		if upgrade == self.itemInfo then
			return true
		end
	end

	return false
end

--- Perform the remove upgrade action
function ISSTKBagRemoveUpgradeAction:perform()
	-- FIX: Só desgasta tesoura se player realmente usou tesoura
	-- Se usou faca, o hook STK_KnifeAlternative já desgastou a faca
	local hasScissors = self.character:getInventory():contains("Base.Scissors")

	if hasScissors then
		-- Player usou tesoura (não faca)
		local scissors = self.character:getInventory():getFirstType("Base.Scissors")
		if scissors then
			-- Desgasta 1 ponto de condição da tesoura
			scissors:setCondition(scissors:getCondition() - 1)

			-- Se a tesoura quebrou completamente, remove ela
			if scissors:getCondition() <= 0 then
				scissors:getContainer():Remove(scissors)
			end
		end
	end
	-- Se não tem tesoura, player usou faca (hook já lidou com isso)

	-- Chama a função pai
	ISSTKBagUpgradeAction.perform(self)
end

--- Constructor for ISSTKBagRemoveUpgradeAction
--- @param character any The character performing the action
--- @param bag any The bag being upgraded
--- @param upgradeTypeToRemove string The type of upgrade to remove
--- @return ISSTKBagRemoveUpgradeAction The new action instance
function ISSTKBagRemoveUpgradeAction:new(character, bag, upgradeTypeToRemove)
	local o = {}
	setmetatable(o, self)

	o.character = character
	o.onComplete = STKBagUpgrade.removeUpgrade
	o.bag = bag
	o.itemInfo = upgradeTypeToRemove
	o.jobType = getText("UI_STK_RemovingUpgrade")
	o.maxTime = SandboxVars.STK.RemoveUpgradeTime or 80
	o.stopOnWalk = true
	o.stopOnRun = true
	o.forceProgressBar = true

	return o
end
