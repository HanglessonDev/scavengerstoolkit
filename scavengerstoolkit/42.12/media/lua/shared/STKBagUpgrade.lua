--- @file scavengerstoolkit\42.12\media\lua\shared\STKBagUpgrade.lua
--- @class STKBagUpgrade
--- Módulo para gerenciar upgrades de mochilas usando itens STK
local STKBagUpgrade = {}

-- ============================================================================
-- CONFIGURAÇÃO E LOGGING
-- ============================================================================
local DEBUG_MODE = true

--- @class STKLogger
local Logger = {
	--- Log a message if debug mode is enabled
	--- @param message string
	log = function(message)
		if not DEBUG_MODE then
			return
		end
		print("[STKBagUpgrade] " .. tostring(message))
	end,
}

Logger.log("Módulo carregado. DEBUG_MODE está: " .. tostring(DEBUG_MODE))

-- ============================================================================
-- DADOS DO MOD - USANDO ITENS STK! 🎯
-- ============================================================================

--- @type table<string, number>
-- MUDANÇA 1: Tabela com SEUS itens de upgrade STK
local upgradeItemValues = {
	-- Straps (Alças) - Melhoram distribuição de peso (Weight Reduction)
	["BackpackStrapsBasic"] = -0.05, -- +5% Weight Reduction
	["BackpackStrapsReinforced"] = -0.10, -- +10% Weight Reduction
	["BackpackStrapsTactical"] = -0.15, -- +15% Weight Reduction

	-- Fabric (Tecido) - Aumentam capacidade (mais bolsos/espaço)
	["BackpackFabricBasic"] = 3, -- +3 capacidade
	["BackpackFabricReinforced"] = 5, -- +5 capacidade
	["BackpackFabricTactical"] = 8, -- +8 capacidade

	-- Belt Buckle (Fivela) - Reforça estrutura (Weight Reduction também)
	["BeltBuckleReinforced"] = -0.10, -- +10% Weight Reduction
}

--- @type table<string, string[]>
-- Ferramentas necessárias
local requiredTools = {
	add = { "Base.Needle", "Base.Thread" }, -- MUDANÇA 2: Ferramentas realistas para costura
	remove = { "Base.Scissors" }, -- Tesoura para remover
}

-- ============================================================================
-- FUNÇÕES PÚBLICAS DO MÓDULO
-- ============================================================================

--- Get the upgrade value for a given item type
--- @param itemType string The type of the item
--- @return number|nil value The upgrade value or nil if not found
function STKBagUpgrade.getUpgradeValue(itemType)
	if not itemType then
		return nil
	end

	-- Remove o prefixo "STK." se existir
	local cleanType = itemType:gsub("^STK%.", "")
	return upgradeItemValues[cleanType]
end

--- Initialize bag mod data
--- @param item any The bag item to initialize
function STKBagUpgrade.initBag(item)
	if not item then
		return
	end

	local imd = item:getModData()
	if not imd.STKUpgradeInit then
		Logger.log("Inicializando ModData para: " .. item:getType())
		imd.LUpgrades = imd.LUpgrades or {}
		imd.LCapacity = imd.LCapacity or item:getCapacity()
		imd.LWeightReduction = imd.LWeightReduction or item:getWeightReduction()
		imd.STKUpgradeInit = true
		imd.LMaxUpgrades = 3 -- Limite padrão
	end
end

--- Update bag stats based on applied upgrades
--- @param bag any The bag to update
function STKBagUpgrade.updateBag(bag)
	if not bag then
		Logger.log("Erro: Tentativa de atualizar mochila inválida.")
		return
	end

	local imd = bag:getModData()
	local originalCapacity = imd.LCapacity or bag:getCapacity()
	local originalWeightReduction = imd.LWeightReduction or bag:getWeightReduction()

	local capacityBonus = 0
	local weightReductionBonus = 0

	for _, upgradeType in pairs(imd.LUpgrades) do
		local value = STKBagUpgrade.getUpgradeValue(upgradeType)
		if value then
			if value > 0 then
				-- Valor positivo = aumenta capacidade (Fabrics)
				capacityBonus = capacityBonus + value
			else
				-- Valor negativo = melhora weight reduction (Straps e Buckles)
				-- Exemplo: -0.10 vira +10% de weight reduction
				weightReductionBonus = weightReductionBonus + (math.abs(value) * 100)
			end
		end
	end

	Logger.log("Capacidade: " .. originalCapacity .. " + " .. capacityBonus)
	Logger.log("Weight Reduction: " .. originalWeightReduction .. "% + " .. weightReductionBonus .. "%")

	bag:setCapacity(originalCapacity + capacityBonus)
	bag:setWeightReduction(math.min(100, originalWeightReduction + weightReductionBonus))
end

--- Apply an upgrade to a bag
--- @param bag any The bag to upgrade
--- @param upgradeItem any The upgrade item to apply
--- @param player any The player applying the upgrade
function STKBagUpgrade.applyUpgrade(bag, upgradeItem, player)
	if not bag or not upgradeItem or not player then
		Logger.log("Erro: Parâmetros inválidos para applyUpgrade.")
		return
	end

	local imd = bag:getModData()
	local upgradeType = upgradeItem:getType():gsub("^STK%.", "") -- Remove prefixo se existir

	Logger.log("Aplicando upgrade '" .. upgradeType .. "'")
	table.insert(imd.LUpgrades, upgradeType)

	upgradeItem:getContainer():Remove(upgradeItem)
	STKBagUpgrade.updateBag(bag)
	player:Say("Upgrade instalado com sucesso!")
end

--- Remove an upgrade from a bag
--- @param bag any The bag to remove upgrade from
--- @param upgradeTypeToRemove string The type of upgrade to remove
--- @param player any The player removing the upgrade
function STKBagUpgrade.removeUpgrade(bag, upgradeTypeToRemove, player)
	if not bag or not upgradeTypeToRemove or not player then
		Logger.log("Erro: Parâmetros inválidos para removeUpgrade.")
		return
	end

	local imd = bag:getModData()
	for i, appliedType in ipairs(imd.LUpgrades) do
		if appliedType == upgradeTypeToRemove then
			Logger.log("Removendo upgrade '" .. upgradeTypeToRemove .. "'")
			table.remove(imd.LUpgrades, i)

			-- MUDANÇA 3: Retorna o item STK específico
			local newItem = player:getInventory():AddItem("STK." .. upgradeTypeToRemove)
			if not newItem then
				Logger.log("ERRO: Não foi possível criar STK." .. upgradeTypeToRemove)
				player:Say("Erro ao remover upgrade.")
			else
				player:Say("Upgrade removido!")
			end

			STKBagUpgrade.updateBag(bag)
			return
		end
	end
end

-- ============================================================================
-- FUNÇÕES DE VALIDAÇÃO
-- ============================================================================

--- Check if an item is a valid bag for upgrades
--- @param item any The item to validate
--- @return boolean isValid True if the item is a valid bag, false otherwise
function STKBagUpgrade.isBagValid(item)
	if not item or not item:IsInventoryContainer() then
		return false
	end

	local itemType = item:getFullType()

	-- Lista de mochilas válidas (Base game + suas mochilas STK se tiver)
	local validBags = {
		-- Base game bags
		"Base.Bag_Schoolbag",
		"Base.Bag_Schoolbag_Kids",
		"Base.Bag_Schoolbag_Medical",
		"Base.Bag_Schoolbag_Patches",
		"Base.Bag_Schoolbag_Travel",
		"Base.Bag_Satchel",
		"Base.Bag_SatchelPhoto",
		"Base.Bag_Satchel_Military",
		"Base.Bag_Satchel_Medical",
		"Base.Bag_Satchel_Leather",
		"Base.Bag_Satchel_Mail",
		"Base.Bag_Satchel_Fishing",
		"Base.Bag_FannyPackFront",
		"Base.Bag_FannyPackBack",
		-- Adicione aqui se você criar mochilas STK customizadas:
		-- "STK.Bag_CustomBackpack",
	}

	for _, validType in ipairs(validBags) do
		if itemType == validType then
			return true
		end
	end

	return false
end

--- Get all upgrade items in a container
--- @param container any The container to search
--- @return any[] upgradeItems Array of upgrade items found
function STKBagUpgrade.getUpgradeItems(container)
	local upgradeItems = {}
	if not container then
		return upgradeItems
	end

	for i = 0, container:getItems():size() - 1 do
		local item = container:getItems():get(i)
		if item and item:getType() then
			-- MUDANÇA 5: Procura por itens STK de upgrade
			local itemType = item:getType():gsub("^STK%.", "")
			if STKBagUpgrade.getUpgradeValue(itemType) then
				table.insert(upgradeItems, item)
			end
		end
	end
	return upgradeItems
end

--- Check if a bag can accept more upgrades
--- @param bag any The bag to check
--- @return boolean canAdd True if the bag can accept more upgrades, false otherwise
function STKBagUpgrade.canAddUpgrade(bag)
	local imd = bag:getModData()
	return #imd.LUpgrades < imd.LMaxUpgrades
end

--- Check if a player has required tools for an action
--- @param player any The player to check
--- @param actionType string The type of action ("add" or "remove")
--- @return boolean hasTools True if the player has required tools, false otherwise
function STKBagUpgrade.hasRequiredTools(player, actionType)
	local tools = requiredTools[actionType]
	if not tools then
		return false
	end

	for _, toolType in ipairs(tools) do
		if not player:getInventory():contains(toolType) then
			return false
		end
	end
	return true
end

return STKBagUpgrade
