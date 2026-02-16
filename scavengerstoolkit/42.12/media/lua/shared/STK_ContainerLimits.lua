--- @file scavengerstoolkit\42.12\media\lua\shared\STK_ContainerLimits.lua
--- Feature: Container-specific upgrade limits
--- Limita número de upgrades baseado no tipo de mochila
--- VERSÃO OTIMIZADA: Sistema de tracking para evitar spam de logs

local STKBagUpgrade = require("STKBagUpgrade")

-- ============================================================================
-- CONFIGURATION
-- ============================================================================

local DEBUG_MODE = true

local Logger = {
	log = function(message)
		if not DEBUG_MODE then
			return
		end
		print("[STK-ContainerLimits] " .. tostring(message))
	end,
}

Logger.log("Feature carregada: Container Limits v2.0 (Optimized)")

-- ============================================================================
-- TRACKING SYSTEM (evita spam)
-- ============================================================================

--[[
	Sistema de tracking para evitar definir limite múltiplas vezes na mesma bag.
	
	Como funciona:
	1. Quando definimos limite em uma bag, marcamos ela como "processed"
	2. Na próxima vez, checamos se já foi processed
	3. Se sim, skipamos (sem log, sem processamento)
	
	Limpeza:
	- Weak table: Lua garbage collector remove bags que foram deletadas
]]

local processedBags = {}
setmetatable(processedBags, { __mode = "k" }) -- Weak keys (permite GC)

-- ============================================================================
-- LIMITES POR TIPO DE BAG
-- ============================================================================

local CONTAINER_LIMITS = {
	-- FannyPack: Muito pequena, só 1 upgrade
	FannyPack = 1,

	-- Satchel: Média, 2 upgrades
	Satchel = 2,

	-- Schoolbag: Média, 2 upgrades
	Schoolbag = 2,

	-- Hiking: Média-Grande, 2 upgrades
	HikingBag = 2,
	BigHikingBag = 2,

	-- Duffel: Grande, 2 upgrades
	DuffelBag = 2,
	Military = 2,
	Police = 2,
	SWAT = 2,
	Sheriff = 2,
	MedicalBag = 2,
}

-- ============================================================================
-- HOOK HANDLER
-- ============================================================================

--- Set container-specific upgrade limit
--- @param bag any The bag being initialized
--- @param isFirstInit boolean Whether this is first initialization
local function setContainerLimit(bag, isFirstInit)
	-- ⚡ OTIMIZAÇÃO: Skip se já processamos esta bag
	if processedBags[bag] then
		return
	end

	local bagType = bag:getFullType()
	local imd = bag:getModData()

	-- Default: 3 upgrades (se não encontrar regra específica)
	local limit = 3

	-- Check each pattern
	for pattern, configuredLimit in pairs(CONTAINER_LIMITS) do
		if bagType:find(pattern) then
			limit = configuredLimit
			break
		end
	end

	-- Apply limit
	imd.LMaxUpgrades = limit

	-- ⚡ MARCA COMO PROCESSADO (evita re-processar)
	processedBags[bag] = true

	-- Log apenas na PRIMEIRA vez que processamos
	Logger.log(
		string.format("Limite definido para %s: %d upgrades (isFirstInit: %s)", bagType, limit, tostring(isFirstInit))
	)
end

-- Register hook with VERY_HIGH priority (must run BEFORE other features)
STKBagUpgrade.registerHook("afterInitBag", setContainerLimit, STKBagUpgrade.PRIORITY.VERY_HIGH)

Logger.log("Hook registrado: afterInitBag (VERY_HIGH priority)")

-- ============================================================================
-- PUBLIC API (optional, for debugging)
-- ============================================================================

local STK_ContainerLimits = {}

--- Get configured limit for a bag type pattern
--- @param pattern string The bag type pattern (e.g., "FannyPack")
--- @return number|nil limit The configured limit or nil if not found
function STK_ContainerLimits.getLimit(pattern)
	return CONTAINER_LIMITS[pattern]
end

--- Get all configured limits
--- @return table limits All configured limits
function STK_ContainerLimits.getAllLimits()
	return CONTAINER_LIMITS
end

--- Clear processed bags cache (útil para debug/testing)
--- @return number count Number of bags cleared from cache
function STK_ContainerLimits.clearCache()
	local count = 0
	for _ in pairs(processedBags) do
		count = count + 1
	end

	processedBags = {}
	setmetatable(processedBags, { __mode = "k" })

	Logger.log(string.format("Cache limpo: %d bags removidas", count))
	return count
end

--- Check if a bag has been processed
--- @param bag any The bag to check
--- @return boolean processed Whether the bag has been processed
function STK_ContainerLimits.isProcessed(bag)
	return processedBags[bag] == true
end

return STK_ContainerLimits
