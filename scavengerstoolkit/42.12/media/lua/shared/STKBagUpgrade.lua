--- @file scavengerstoolkit\42.12\media\lua\shared\STKBagUpgrade.lua
--- @brief Core system for backpack upgrades with extensible hook architecture
---
--- This module provides the main functionality for adding and removing upgrades
--- from containers. It features a priority-based hook system that allows other
--- features to extend functionality without modifying core code.
---
--- @author Scavenger's Toolkit Development Team
--- @version 1.0.0
--- @license MIT
--- @copyright 2026 Scavenger's Toolkit

--- @class STKBagUpgrade
--- Core module for managing backpack upgrades using STK items
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

Logger.log("Modulo carregado v2.0 - Com hooks onAddFailed e onRemoveFailed")

-- ============================================================================
-- HOOK SYSTEM (EXTENSIBILITY)
-- ============================================================================

--- Hook system for features to plug into core functionality
--- Hooks agora suportam prioridades para controlar ordem de execucao
STKBagUpgrade.hooks = {
	beforeInitBag = {}, -- Called before bag initialization
	afterInitBag = {}, -- Called after bag initialization
	beforeAdd = {}, -- Called before adding upgrade
	afterAdd = {}, -- Called after adding upgrade
	onAddFailed = {}, -- Called when add operation fails (NEW!)
	beforeRemove = {}, -- Called before removing upgrade
	afterRemove = {}, -- Called after removing upgrade
	onRemoveFailed = {}, -- Called when remove operation fails (NEW!)
	checkRemoveTools = {},
}

--- Priority levels for hook execution
--- VERY_HIGH (1-25): Base value modifications, must run first
--- HIGH (26-50): Core logic modifications
--- NORMAL (51-75): Standard features (DEFAULT)
--- LOW (76-100): Final adjustments, cosmetic changes
STKBagUpgrade.PRIORITY = {
	VERY_HIGH = 25,
	HIGH = 40,
	NORMAL = 50,
	LOW = 75,
}

--- Register a hook callback with priority
--- @param hookType string The type of hook
--- @param callback function The callback function
--- @param priority number Optional priority (1-100, default 50)
function STKBagUpgrade.registerHook(hookType, callback, priority)
	if not STKBagUpgrade.hooks[hookType] then
		Logger.log("ERRO: Tipo de hook invalido: " .. hookType)
		return false
	end

	priority = priority or STKBagUpgrade.PRIORITY.NORMAL

	-- Store hook with priority
	table.insert(STKBagUpgrade.hooks[hookType], {
		callback = callback,
		priority = priority,
	})

	-- Sort hooks by priority (lower number = higher priority = runs first)
	table.sort(STKBagUpgrade.hooks[hookType], function(a, b)
		return a.priority < b.priority
	end)

	Logger.log("Hook registrado: " .. hookType .. " (prioridade: " .. priority .. ")")
	return true
end

--- Execute all hooks of a given type in priority order
--- @param hookType string The type of hook to execute
--- @param ... any Arguments to pass to hook callbacks
--- @return boolean shouldContinue False if any hook returned false, true otherwise
local function executeHooks(hookType, ...)
	for _, hookData in ipairs(STKBagUpgrade.hooks[hookType]) do
		local result = hookData.callback(...)
		if result == false then
			Logger.log("Hook '" .. hookType .. "' (prioridade: " .. hookData.priority .. ") cancelou operacao")
			return false
		end
	end
	return true
end

-- ============================================================================
-- DADOS DO MOD
-- ============================================================================

--- @type table<string, string[]>
-- Ferramentas necessárias
local requiredTools = {
	add = { "Base.Needle", "Base.Thread" }, -- Ferramentas realistas para costura
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

	-- Read from Sandbox or use defaults
	if cleanType == "BackpackStrapsBasic" then
		return -((SandboxVars.STK.StrapsBasicBonus or 5) / 100)
	elseif cleanType == "BackpackStrapsReinforced" then
		return -((SandboxVars.STK.StrapsReinforcedBonus or 10) / 100)
	elseif cleanType == "BackpackStrapsTactical" then
		return -((SandboxVars.STK.StrapsTacticalBonus or 15) / 100)
	elseif cleanType == "BackpackFabricBasic" then
		return SandboxVars.STK.FabricBasicBonus or 3
	elseif cleanType == "BackpackFabricReinforced" then
		return SandboxVars.STK.FabricReinforcedBonus or 5
	elseif cleanType == "BackpackFabricTactical" then
		return SandboxVars.STK.FabricTacticalBonus or 8
	elseif cleanType == "BeltBuckleReinforced" then
		return -((SandboxVars.STK.BeltBuckleBonus or 10) / 100)
	end

	return nil
end

--- Initialize bag mod data
--- @param item any The bag item to initialize
function STKBagUpgrade.initBag(item)
	if not item then
		return
	end

	-- HOOK: beforeInitBag
	if not executeHooks("beforeInitBag", item) then
		return
	end

	local imd = item:getModData()
	local isFirstInit = not imd.STKUpgradeInit

	if isFirstInit then
		Logger.log("Inicializando ModData para: " .. item:getType())
		imd.LUpgrades = imd.LUpgrades or {}
		imd.LCapacity = imd.LCapacity or item:getCapacity()
		imd.LWeightReduction = imd.LWeightReduction or item:getWeightReduction()
		imd.STKUpgradeInit = true
		imd.LMaxUpgrades = 3 -- Limite padrao (pode ser sobrescrito por hooks)
	end

	-- HOOK: afterInitBag (chamado SEMPRE, nao so na primeira vez)
	-- Permite features aplicarem limites dinamicos em bags ja existentes
	executeHooks("afterInitBag", item, isFirstInit)
end

--- Update bag stats based on applied upgrades
--- @param bag any The bag to update
function STKBagUpgrade.updateBag(bag)
	if not bag then
		Logger.log("Erro: Tentativa de atualizar mochila invalida.")
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
		Logger.log("Erro: Parametros invalidos para applyUpgrade.")
		-- HOOK: onAddFailed
		executeHooks("onAddFailed", bag, upgradeItem, player, "invalid_params")
		return
	end

	-- HOOK: beforeAdd
	if not executeHooks("beforeAdd", bag, upgradeItem, player) then
		-- HOOK: onAddFailed
		executeHooks("onAddFailed", bag, upgradeItem, player, "hook_cancelled")
		return
	end

	local imd = bag:getModData()
	local upgradeType = upgradeItem:getType():gsub("^STK%.", "") -- Remove prefixo se existir

	Logger.log("Aplicando upgrade '" .. upgradeType .. "'")
	table.insert(imd.LUpgrades, upgradeType)

	upgradeItem:getContainer():Remove(upgradeItem)
	STKBagUpgrade.updateBag(bag)

	-- HOOK: afterAdd
	executeHooks("afterAdd", bag, upgradeItem, player)
end

--- Remove an upgrade from a bag
--- @param bag any The bag to remove upgrade from
--- @param upgradeTypeToRemove string The type of upgrade to remove
--- @param player any The player removing the upgrade
function STKBagUpgrade.removeUpgrade(bag, upgradeTypeToRemove, player)
	if not bag or not upgradeTypeToRemove or not player then
		Logger.log("Erro: Parametros invalidos para removeUpgrade.")
		-- HOOK: onRemoveFailed
		executeHooks("onRemoveFailed", bag, upgradeTypeToRemove, player, "invalid_params")
		return
	end

	-- 1. Determina o resultado ANTES de modificar qualquer coisa.
	-- O hook 'beforeRemove' retorna 'false' se a remoção falhar (material destruído).
	local wasSuccessful = executeHooks("beforeRemove", bag, upgradeTypeToRemove, player)

	-- 2. Encontra e remove o upgrade da lista. Esta ação é comum a ambos os cenários.
	local imd = bag:getModData()
	local indexToRemove
	for i, appliedType in ipairs(imd.LUpgrades) do
		if appliedType == upgradeTypeToRemove then
			indexToRemove = i
			break
		end
	end

	-- Se o upgrade não foi encontrado na mochila, nada a fazer.
	if not indexToRemove then
		Logger.log("ERRO: Tentativa de remover um upgrade que nao existe na mochila: " .. upgradeTypeToRemove)
		executeHooks("onRemoveFailed", bag, upgradeTypeToRemove, player, "not_found")
		return
	end

	-- Efetivamente remove o upgrade da lista
	Logger.log("Removendo upgrade '" .. upgradeTypeToRemove .. "' do índice " .. indexToRemove)
	table.remove(imd.LUpgrades, indexToRemove)

	-- 3. Executa as consequências com base no resultado.
	if not wasSuccessful then
		-- CENÁRIO DE FALHA: O material é destruído.
		Logger.log("A remoção falhou. O material foi destruído.")
		-- Apenas chama o hook de falha para o feedback. O item NÃO é devolvido.
		executeHooks("onRemoveFailed", bag, upgradeTypeToRemove, player, "material_destroyed")
	else
		-- CENÁRIO DE SUCESSO: O material é recuperado.
		Logger.log("A remoção foi bem-sucedida. Devolvendo o item.")
		local newItem = player:getInventory():AddItem("STK." .. upgradeTypeToRemove)
		if not newItem then
			Logger.log("ERRO CRÍTICO: Falha ao devolver o item " .. "STK." .. upgradeTypeToRemove)
			-- Mesmo com erro, o hook de sucesso é chamado, pois o upgrade foi removido.
		end
		-- Chama o hook de sucesso.
		executeHooks("afterRemove", bag, upgradeTypeToRemove, player)
	end

	-- 4. Atualiza os status da mochila. Esta ação é comum e acontece no final.
	STKBagUpgrade.updateBag(bag)
end

-- ============================================================================
-- FUNÇÕES DE VALIDAÇÃO
-- ============================================================================

--- OTIMIZAÇÃO: Lookup table O(1) ao invés de loop O(n)
--- Lista de mochilas válidas (Base game)
local validBags = {
	-- Schoolbags (5)
	["Base.Bag_Schoolbag"] = true,
	["Base.Bag_Schoolbag_Kids"] = true,
	["Base.Bag_Schoolbag_Medical"] = true,
	["Base.Bag_Schoolbag_Patches"] = true,
	["Base.Bag_Schoolbag_Travel"] = true,
	
	-- Satchels (7)
	["Base.Bag_Satchel"] = true,
	["Base.Bag_SatchelPhoto"] = true,
	["Base.Bag_Satchel_Military"] = true,
	["Base.Bag_Satchel_Medical"] = true,
	["Base.Bag_Satchel_Leather"] = true,
	["Base.Bag_Satchel_Mail"] = true,
	["Base.Bag_Satchel_Fishing"] = true,
	
	-- FannyPacks (2)
	["Base.Bag_FannyPackFront"] = true,
	["Base.Bag_FannyPackBack"] = true,
	
	-- Hiking Bags (4) - v2.0
	["Base.Bag_NormalHikingBag"] = true,
	["Base.Bag_HikingBag_Travel"] = true,
	["Base.Bag_BigHikingBag"] = true,
	["Base.Bag_BigHikingBag_Travel"] = true,
	
	-- Duffel Bags (7) - v2.0
	["Base.Bag_DuffelBag"] = true,
	["Base.Bag_DuffelBagTINT"] = true,
	["Base.Bag_Military"] = true,
	["Base.Bag_Police"] = true,
	["Base.Bag_SWAT"] = true,
	["Base.Bag_Sheriff"] = true,
	["Base.Bag_MedicalBag"] = true,
}

--- Check if an item is a valid bag for upgrades
--- @param item any The item to validate
--- @return boolean isValid True if the item is a valid bag, false otherwise
function STKBagUpgrade.isBagValid(item)
	if not item or not item:IsInventoryContainer() then
		return false
	end

	return validBags[item:getFullType()] == true
end

--- Get all upgrade items in a container
--- OTIMIZAÇÃO: Cache container:getItems() e size()
--- @param container any The container to search
--- @return any[] upgradeItems Array of upgrade items found
function STKBagUpgrade.getUpgradeItems(container)
	local upgradeItems = {}
	if not container then
		return upgradeItems
	end

	-- OTIMIZAÇÃO: Cache getItems() e size() fora do loop
	local items = container:getItems()
	local size = items:size()

	for i = 0, size - 1 do
		local item = items:get(i)
		if item and item:getType() then
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

	-- Para "add", checa normalmente
	if actionType == "add" then
		for _, toolType in ipairs(tools) do
			if not player:getInventory():contains(toolType) then
				return false
			end
		end
		return true
	end

	-- Para "remove", permite hooks modificarem (Knife Alternative)
	if actionType == "remove" then
		-- Verifica se tem tesoura
		local hasScissors = player:getInventory():contains("Base.Scissors")

		-- Se não tem Sandbox option habilitado, exige tesoura
		if not SandboxVars.STK.KnifeAlternative then
			return hasScissors
		end

		-- Se tem tesoura, ok
		if hasScissors then
			return true
		end

		-- Não tem tesoura, mas Sandbox permite faca
		-- Hook vai verificar se tem faca viável
		local toolCheck = { hasAlternative = false }
		executeHooks("checkRemoveTools", player, toolCheck)

		return toolCheck.hasAlternative
	end

	return false
end

return STKBagUpgrade