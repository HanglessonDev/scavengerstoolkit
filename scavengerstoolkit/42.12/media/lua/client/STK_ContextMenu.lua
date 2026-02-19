--- @file scavengerstoolkit\42.12\media\lua\client\STK_ContextMenu.lua
--- @brief Context menu integration for STK backpack upgrades
---
--- Adds context menu options for adding and removing upgrades from
--- containers. Features progressive validation (tools → materials →
--- capacity), alphabetical sorting, and informative tooltips for
--- unavailable options.
---
--- @author Scavenger's Toolkit Development Team
--- @version 3.0.0
--- @license MIT
--- @copyright 2026 Scavenger's Toolkit

--- @class STKContextMenu
local STKContextMenu = {}

local STKBagUpgrade = require("STKBagUpgrade")
local log = require("STK_Logger").get("STK-ContextMenu")
require("TimedActions/ISSTKBagUpgradeAction")

-- ============================================================================
-- HELPERS
-- ============================================================================

--- Attaches a tooltip to a context menu option.
--- @param option any The menu option
--- @param textKey string Translation key for the tooltip text
local function setTooltip(option, textKey)
	local tooltip = ISInventoryPaneContextMenu.addToolTip()
	option.toolTip = tooltip
	tooltip.description = getText(textKey)
end

-- ============================================================================
-- CONTEXT MENU HANDLER
-- ============================================================================

--- Fills the inventory context menu with STK upgrade options.
--- @param playerNum number Player number (0-based)
--- @param context any ISContextMenu instance
--- @param items any[] Selected items array
local function onFillInventoryContextMenu(playerNum, context, items)
	local player = getSpecificPlayer(playerNum)
	local selectedItem = items[1]

	if not instanceof(selectedItem, "InventoryItem") then
		selectedItem = selectedItem.items[1]
	end

	if not STKBagUpgrade.isBagValid(selectedItem) then
		return
	end

	log.debug("Mochila valida detectada: " .. selectedItem:getType())
	local bag = selectedItem
	STKBagUpgrade.initBag_Client(bag)

	-- ========================================================================
	-- ADD UPGRADE BLOCK
	-- ========================================================================
	do
		local addSubMenu = ISContextMenu:getNew(context)
		local addOption = context:addOption(getText("ContextMenu_STK_AddUpgrade"))
		context:addSubMenu(addOption, addSubMenu)

		if not STKBagUpgrade.canAddUpgrade(bag) then
			log.debug("Validacao ADD falhou: limite de upgrades atingido")
			addOption.notAvailable = true
			setTooltip(addOption, "ContextMenu_STK_MaxUpgrades")
		elseif not STKBagUpgrade.hasRequiredTools(player, "add") then
			log.debug("Validacao ADD falhou: sem agulha ou linha")
			addOption.notAvailable = true
			setTooltip(addOption, "ContextMenu_STK_NeedTools")
		else
			local availableUpgrades = STKBagUpgrade.getUpgradeItems(player:getInventory())
			log.debug("Upgrades disponiveis: " .. #availableUpgrades)

			if #availableUpgrades == 0 then
				log.debug("Validacao ADD falhou: nenhum item STK no inventario")
				addOption.notAvailable = true
				setTooltip(addOption, "ContextMenu_STK_NoItems")
			else
				table.sort(availableUpgrades, function(a, b)
					return a:getDisplayName() < b:getDisplayName()
				end)

				log.debug("Validacoes ADD passaram, populando submenu")
				for _, upgradeItem in ipairs(availableUpgrades) do
					log.debug("  + " .. upgradeItem:getType())
					addSubMenu:addOption(upgradeItem:getDisplayName(), nil, function()
						ISTimedActionQueue.add(ISSTKBagAddUpgradeAction:new(player, bag, upgradeItem))
					end)
				end
			end
		end
	end

	-- ========================================================================
	-- REMOVE UPGRADE BLOCK
	-- ========================================================================
	do
		local imd = bag:getModData()
		if not imd.LUpgrades or #imd.LUpgrades == 0 then
			return
		end

		log.debug("Mochila tem " .. #imd.LUpgrades .. " upgrade(s), criando submenu de remocao")
		local removeSubMenu = ISContextMenu:getNew(context)
		local removeOption = context:addOption(getText("ContextMenu_STK_RemoveUpgrade"))
		context:addSubMenu(removeOption, removeSubMenu)

		if not STKBagUpgrade.hasRequiredTools(player, "remove") then
			log.debug("Validacao REMOVE falhou: sem tesoura ou faca")
			removeOption.notAvailable = true
			setTooltip(removeOption, "ContextMenu_STK_NeedScissors")
		else
			local upgradeList = {}
			for _, upgradeType in ipairs(imd.LUpgrades) do
				local itemScript = getScriptManager():getItem("STK." .. upgradeType)
				local displayName = itemScript and itemScript:getDisplayName() or upgradeType
				table.insert(upgradeList, { type = upgradeType, name = displayName })
			end

			table.sort(upgradeList, function(a, b)
				return a.name < b.name
			end)

			for _, upgrade in ipairs(upgradeList) do
				removeSubMenu:addOption(upgrade.name, nil, function()
					ISTimedActionQueue.add(ISSTKBagRemoveUpgradeAction:new(player, bag, upgrade.type))
				end)
			end
		end
	end
end

Events.OnFillInventoryObjectContextMenu.Add(log.wrap(onFillInventoryContextMenu, "onFillInventoryContextMenu"))

log.info("Modulo carregado.")

return STKContextMenu
