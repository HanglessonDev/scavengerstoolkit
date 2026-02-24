--- @file scavengerstoolkit\42.12\media\lua\client\STK_BagSync.lua
--- @brief Reaplica stats STK em bags equipadas quando divergem do ModData
---
--- Problema primário (fannypack):
---   A mecânica ClothingItemExtra do PZ substitui o objeto inteiro ao trocar
---   o slot de uma fannypack (vestir na frente / vestir atrás). O novo objeto
---   não tem ModData, então os stats voltam ao vanilla.
---
--- Cobertura geral:
---   Outras bags podem perder stats por causas diversas — reset do engine ao
---   carregar save, conflito com outro mod, ou comportamentos não mapeados do
---   PZ 42. O sync genérico atua como rede de segurança para qualquer bag STK
---   equipada, não apenas fanny packs.
---
--- Solução:
---   OnClothingUpdated dispara de forma limpa a cada mudança de clothing.
---   Ao receber o evento, varre os worn items em busca de bags STK cujo
---   capacity ou weightReduction diverge do esperado pelo ModData e reaplica.
---
--- Referência:
---   Abordagem inspirada no DynamicBackpackUpgrades (InvCheck + EveryOneMinute)
---   porém acionada por evento em vez de timer — mais imediata e sem polling.
---
--- @author Scavenger's Toolkit Development Team
--- @version 1.1.0
--- @license MIT
--- @copyright 2026 Scavenger's Toolkit

local STK_Core = require("STK_Core")
local STK_Utils = require("STK_Utils")
local log = require("STK_Logger").get("STK-BagSync")

-- ============================================================================
-- INTERNAL
-- ============================================================================

--- Verifica se uma bag tem stats divergentes do esperado pelo ModData
--- e reaplica caso necessário. No-op se não inicializada ou sem upgrades.
--- @param bag any InventoryItem
local function syncIfDivergent(bag)
	local imd = bag:getModData()

	if not imd.STKInitialised then
		return
	end

	if not imd.LUpgrades or #imd.LUpgrades == 0 then
		return
	end

	local expectedCapacity = STK_Utils.calculateFinalCapacity(imd.LCapacity, imd.LUpgrades)
	local expectedWR = STK_Utils.calculateFinalWeightReduction(imd.LWeightReduction, imd.LUpgrades)

	if bag:getCapacity() == expectedCapacity and bag:getWeightReduction() == expectedWR then
		return
	end

	bag:setCapacity(expectedCapacity)
	bag:setWeightReduction(expectedWR)

	log.debug(
		string.format(
			"Sync: %s → cap=%d, wr=%.0f%% (%d upgrades)",
			bag:getType(),
			expectedCapacity,
			expectedWR,
			#imd.LUpgrades
		)
	)
end

-- ============================================================================
-- EVENT HANDLER
-- ============================================================================

--- OnClothingUpdated — dispara a cada mudança de clothing do personagem.
--- Varre todos os worn items que são bags STK válidas.
--- @param character any IsoPlayer
local function onClothingUpdated(character)
	if not character then
		return
	end

	local wornItems = character:getWornItems()
	for i = 0, wornItems:size() - 1 do
		local item = wornItems:getItemByIndex(i)
		if item and STK_Core.isValidBag(item) then
			syncIfDivergent(item)
		end
	end
end

-- ============================================================================

Events.OnClothingUpdated.Add(log.wrap(onClothingUpdated, "onClothingUpdated"))

log.info("Listener registrado: OnClothingUpdated")
