-- ============================================================================
-- Timed Actions para Upgrades de Mochilas STK - VERSÃO 100% FUNCIONAL
-- ============================================================================

require("TimedActions/ISBaseTimedAction")
local STKBagUpgrade = require("STKBagUpgrade")

-- ============================================================================
-- CLASSE BASE PARA AÇÕES STK
-- ============================================================================

ISSTKBagUpgradeAction = ISBaseTimedAction:derive("ISSTKBagUpgradeAction")

function ISSTKBagUpgradeAction:isValid()
	return self.character and self.bag and self.character:getInventory():contains(self.bag)
end

function ISSTKBagUpgradeAction:update()
	self.character:setMetabolicTarget(Metabolics.UsingTools)
	-- FIX: Atualiza barra de progresso no item
	self.bag:setJobDelta(self:getJobDelta())
end

function ISSTKBagUpgradeAction:start()
	self:setActionAnim(CharacterActionAnims.Craft)
	-- FIX: Mostra barra de progresso no item
	self.bag:setJobType(self.jobType)
	self.bag:setJobDelta(0.0)
end

function ISSTKBagUpgradeAction:stop()
	-- FIX: Remove barra de progresso
	self.bag:setJobDelta(0.0)
	ISBaseTimedAction.stop(self)
end

function ISSTKBagUpgradeAction:perform()
	-- FIX: Remove barra de progresso
	self.bag:setJobDelta(0.0)

	if self.onComplete then
		self.onComplete(self.bag, self.itemInfo, self.character)
	end

	ISBaseTimedAction.perform(self)
end

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

ISSTKBagAddUpgradeAction = ISSTKBagUpgradeAction:derive("ISSTKBagAddUpgradeAction")

-- FIX: Validação completa durante a ação
function ISSTKBagAddUpgradeAction:isValid()
	-- Validação da classe pai (personagem e mochila existem)
	if not ISSTKBagUpgradeAction.isValid(self) then
		return false
	end

	-- FIX: Verifica se ainda tem as ferramentas necessárias
	local hasNeedle = self.character:getInventory():contains("Base.Needle")
	local hasThread = self.character:getInventory():contains("Base.Thread")

	if not (hasNeedle and hasThread) then
		return false
	end

	-- FIX: Verifica se o item de upgrade ainda existe
	if not self.itemInfo or not self.character:getInventory():contains(self.itemInfo) then
		return false
	end

	-- FIX: Verifica se ainda tem espaço para upgrades
	local imd = self.bag:getModData()
	return #imd.LUpgrades < imd.LMaxUpgrades
end

function ISSTKBagAddUpgradeAction:perform()
	-- Consumir linha (já estava funcionando)
	local thread = self.character:getInventory():getFirstType("Base.Thread")
	if thread then
		thread:UseAndSync()
	end

	-- Chama a função pai que executa o callback
	ISSTKBagUpgradeAction.perform(self)
end

function ISSTKBagAddUpgradeAction:new(character, bag, upgradeItem)
	local o = ISSTKBagUpgradeAction:new(
		character,
		STKBagUpgrade.applyUpgrade,
		bag,
		upgradeItem,
		"Instalando upgrade STK...",
		100 -- ~3 segundos
	)
	return o
end

-- ============================================================================
-- AÇÃO: REMOVER UPGRADE
-- ============================================================================

ISSTKBagRemoveUpgradeAction = ISSTKBagUpgradeAction:derive("ISSTKBagRemoveUpgradeAction")

-- FIX: Validação completa durante a ação
function ISSTKBagRemoveUpgradeAction:isValid()
	-- Validação da classe pai
	if not ISSTKBagUpgradeAction.isValid(self) then
		return false
	end

	-- FIX: Verifica se ainda tem tesoura
	local hasScissors = self.character:getInventory():contains("Base.Scissors")
	if not hasScissors then
		return false
	end

	-- FIX: Verifica se o upgrade ainda existe na mochila
	local imd = self.bag:getModData()
	for _, upgrade in ipairs(imd.LUpgrades) do
		if upgrade == self.itemInfo then
			return true
		end
	end

	return false
end

-- FIX: Desgastar tesoura ao remover upgrade
function ISSTKBagRemoveUpgradeAction:perform()
	local scissors = self.character:getInventory():getFirstType("Base.Scissors")
	if scissors then
		-- Desgasta 1 ponto de condição da tesoura
		scissors:setCondition(scissors:getCondition() - 1)

		-- Se a tesoura quebrou completamente, remove ela
		if scissors:getCondition() <= 0 then
			scissors:getContainer():Remove(scissors)
		end
	end

	-- Chama a função pai
	ISSTKBagUpgradeAction.perform(self)
end

function ISSTKBagRemoveUpgradeAction:new(character, bag, upgradeTypeToRemove)
	local o = ISSTKBagUpgradeAction:new(
		character,
		STKBagUpgrade.removeUpgrade,
		bag,
		upgradeTypeToRemove,
		"Removendo upgrade STK...",
		80 -- ~2.5 segundos (remover é mais rápido)
	)
	return o
end
