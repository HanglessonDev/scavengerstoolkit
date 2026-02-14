--- @file scavengerstoolkit\42.12\media\lua\client\OnInventoryContextMenu_STK.lua

--- @class STKContextMenu
--- Context Menu para Upgrades de Mochilas STK
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
				local tooltip = ISInventoryPaneContextMenu.addToolTip()
				addUpgradeOption.toolTip = tooltip
				tooltip.description = getText("ContextMenu_STK_MaxUpgrades")
			-- Validacao 2: Jogador tem as ferramentas (agulha + linha)?
			elseif not STKBagUpgrade.hasRequiredTools(player, "add") then
				Logger.log("Validacao ADICAO FALHOU: Falta Agulha ou Linha")
				addUpgradeOption.notAvailable = true
				local tooltip = ISInventoryPaneContextMenu.addToolTip()
				addUpgradeOption.toolTip = tooltip
				tooltip.description = getText("ContextMenu_STK_NeedTools")
			else
				-- Validacao 3: Jogador tem itens de upgrade STK?
				local availableUpgrades = STKBagUpgrade.getUpgradeItems(player:getInventory())
				Logger.log("Upgrades disponiveis para adicao: " .. #availableUpgrades)

				if #availableUpgrades == 0 then
					Logger.log("Validacao ADICAO FALHOU: Nenhum item de upgrade no inventario")
					addUpgradeOption.notAvailable = true
					local tooltip = ISInventoryPaneContextMenu.addToolTip()
					addUpgradeOption.toolTip = tooltip
					tooltip.description = getText("ContextMenu_STK_NoItems")
				else
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

				-- Validacao: Jogador tem tesoura?
				if not STKBagUpgrade.hasRequiredTools(player, "remove") then
					Logger.log("Validacao REMOCAO FALHOU: Falta tesoura para remover")
					removeUpgradeOption.notAvailable = true
					local tooltip = ISInventoryPaneContextMenu.addToolTip()
					removeUpgradeOption.toolTip = tooltip
					tooltip.description = getText("ContextMenu_STK_NeedScissors")
				else
					-- Listar todos os upgrades aplicados
					-- MUDANCA: Agora mostra APENAS o nome do item, sem stats
					for _, upgradeType in ipairs(imd.LUpgrades) do
						local itemScript = getScriptManager():getItem("STK." .. upgradeType)
						local displayName
						if itemScript then
							displayName = itemScript:getDisplayName()
						else
							displayName = upgradeType -- Fallback
						end

						removeUpgradeSubMenu:addOption(displayName, nil, function()
							ISTimedActionQueue.add(ISSTKBagRemoveUpgradeAction:new(player, bag, upgradeType))
						end)
					end
				end
			end
		end
	end

	-- ========================================================================
	-- CENÁRIO 2: Jogador clicou em um ITEM DE UPGRADE STK
	-- ========================================================================
	-- local itemType = selectedItem:getType():gsub("^STK%.", "")
	-- if STKBagUpgrade.getUpgradeValue(itemType) then
	--     local upgradeItem = selectedItem

	--     -- Procurar mochilas válidas no inventário
	--     local validBags = {}
	--     local inventory = player:getInventory()

	--     for i = 0, inventory:getItems():size() - 1 do
	--         local item = inventory:getItems():get(i)
	--         if STKBagUpgrade.isBagValid(item) then
	--             STKBagUpgrade.initBag(item)
	--             if STKBagUpgrade.canAddUpgrade(item) then
	--                 table.insert(validBags, item)
	--             end
	--         end
	--     end

	--     if #validBags > 0 and STKBagUpgrade.hasRequiredTools(player, "add") then
	--         local upgradeToSubMenu = context:getNew()
	--         local upgradeToOption = context:addOption("Instalar em Mochila", nil, nil)
	--         context:addSubMenu(upgradeToOption, upgradeToSubMenu)

	--         for _, bag in ipairs(validBags) do
	--             upgradeToSubMenu:addOption(bag:getDisplayName(), nil, function()
	--                 ISTimedActionQueue.add(ISSTKBagAddUpgradeAction:new(player, bag, upgradeItem))
	--             end)
	--         end
	--     end
	-- end
end

Events.OnFillInventoryObjectContextMenu.Add(onFillInventoryContextMenu)

return STKContextMenu
