--- @file scavengerstoolkit\42.12\media\lua\client\OnInventoryContextMenu_STK.lua
--- @brief Context menu integration for STK backpack upgrades
---
--- This module adds context menu options for adding and removing upgrades
--- from containers. Features progressive validation (tools → materials → skill),
--- alphabetical sorting, and informative tooltips for unavailable options.
---
--- @author Scavenger's Toolkit Development Team
--- @version 1.0.0
--- @license MIT
--- @copyright 2026 Scavenger's Toolkit

--- @class STKContextMenu
--- Context menu for STK backpack upgrades
local STKContextMenu = {}

local STKBagUpgrade = require("STKBagUpgrade")
require("TimedActions/ISSTKBagUpgradeAction")

-- ============================================================================
-- LOGGING
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
		print("[STKBagUpgrade-Menu] " .. tostring(message))
	end,
}

Logger.log("Context Menu carregado.")

-- ============================================================================
-- HELPER FUNCTIONS
-- ============================================================================

--- Set tooltip for a context menu option
--- @param option any The menu option
--- @param textKey string Translation key for the tooltip text
local function setTooltip(option, textKey)
	local tooltip = ISInventoryPaneContextMenu.addToolTip()
	option.toolTip = tooltip
	tooltip.description = getText(textKey)
end

--- Handler for filling inventory context menu
--- @param playerNum number Player number
--- @param context any Context object
--- @param items any[] Array of items
local function onFillInventoryContextMenu(playerNum, context, items)
	local player = getSpecificPlayer(playerNum)
	local selectedItem = items[1]

	if not instanceof(selectedItem, "InventoryItem") then
		selectedItem = selectedItem.items[1]
	end

	-- ========================================================================
	-- CENARIO 1: Jogador clicou em uma MOCHILA
	-- ========================================================================
	if STKBagUpgrade.isBagValid(selectedItem) then
		Logger.log("Mochila valida detectada: " .. selectedItem:getType())
		local bag = selectedItem
		STKBagUpgrade.initBag(bag)

		-- Bloco para ADICIONAR upgrades (executado de forma independente)
		do
			local addUpgradeSubMenu = ISContextMenu:getNew(context)
			local addUpgradeOption = context:addOption(getText("ContextMenu_STK_AddUpgrade"))
			context:addSubMenu(addUpgradeOption, addUpgradeSubMenu)

			-- Validacao 1: Mochila esta cheia de upgrades?
			if not STKBagUpgrade.canAddUpgrade(bag) then
				Logger.log("Validacao ADICAO FALHOU: Mochila ja tem maximo de upgrades")
				addUpgradeOption.notAvailable = true
				setTooltip(addUpgradeOption, "ContextMenu_STK_MaxUpgrades")
			-- Validacao 2: Jogador tem as ferramentas (agulha + linha)?
			elseif not STKBagUpgrade.hasRequiredTools(player, "add") then
				Logger.log("Validacao ADICAO FALHOU: Falta Agulha ou Linha")
				addUpgradeOption.notAvailable = true
				setTooltip(addUpgradeOption, "ContextMenu_STK_NeedTools")
			else
				-- Validacao 3: Jogador tem itens de upgrade STK?
				local availableUpgrades = STKBagUpgrade.getUpgradeItems(player:getInventory())
				Logger.log("Upgrades disponiveis para adicao: " .. #availableUpgrades)

				if #availableUpgrades == 0 then
					Logger.log("Validacao ADICAO FALHOU: Nenhum item de upgrade no inventario")
					addUpgradeOption.notAvailable = true
					setTooltip(addUpgradeOption, "ContextMenu_STK_NoItems")
				else
					-- Ordena alfabeticamente por nome de exibição
					table.sort(availableUpgrades, function(a, b)
						return a:getDisplayName() < b:getDisplayName()
					end)

					-- Tudo OK! Mostrar opcoes de upgrade
					-- MUDANCA: Agora mostra APENAS o nome do item, sem stats
					-- Os stats estao nos tooltips dos itens quando passa o mouse
					Logger.log("Validacoes de ADICAO passaram! Mostrando menu de upgrades")
					for _, upgradeItem in ipairs(availableUpgrades) do
						local displayName = upgradeItem:getDisplayName()
						Logger.log("  - " .. upgradeItem:getType())

						addUpgradeSubMenu:addOption(displayName, nil, function()
							ISTimedActionQueue.add(ISSTKBagAddUpgradeAction:new(player, bag, upgradeItem))
						end)
					end
				end
			end
		end

		-- Bloco para REMOVER upgrades (executado de forma independente)
		do
			local imd = bag:getModData()
			if imd.LUpgrades and #imd.LUpgrades > 0 then
				Logger.log("Mochila tem " .. #imd.LUpgrades .. " upgrade(s), criando menu de remocao")
				local removeUpgradeSubMenu = ISContextMenu:getNew(context)
				local removeUpgradeOption = context:addOption(getText("ContextMenu_STK_RemoveUpgrade"))
				context:addSubMenu(removeUpgradeOption, removeUpgradeSubMenu)

				-- Validacao: Jogador tem tesoura ou faca?
				if not STKBagUpgrade.hasRequiredTools(player, "remove") then
					Logger.log("Validacao REMOCAO FALHOU: Falta tesoura/faca para remover")
					removeUpgradeOption.notAvailable = true
					setTooltip(removeUpgradeOption, "ContextMenu_STK_NeedScissors")
				else
					-- Cria lista ordenada de upgrades para exibição
					local upgradeList = {}
					for _, upgradeType in ipairs(imd.LUpgrades) do
						local itemScript = getScriptManager():getItem("STK." .. upgradeType)
						local displayName
						if itemScript then
							displayName = itemScript:getDisplayName()
						else
							displayName = upgradeType -- Fallback
						end
						table.insert(upgradeList, { type = upgradeType, name = displayName })
					end

					-- Ordena alfabeticamente
					table.sort(upgradeList, function(a, b)
						return a.name < b.name
					end)

					-- Listar todos os upgrades aplicados em ordem alfabética
					for _, upgrade in ipairs(upgradeList) do
						removeUpgradeSubMenu:addOption(upgrade.name, nil, function()
							ISTimedActionQueue.add(ISSTKBagRemoveUpgradeAction:new(player, bag, upgrade.type))
						end)
					end
				end
			end
		end
	end
end

Events.OnFillInventoryObjectContextMenu.Add(onFillInventoryContextMenu)

return STKContextMenu
