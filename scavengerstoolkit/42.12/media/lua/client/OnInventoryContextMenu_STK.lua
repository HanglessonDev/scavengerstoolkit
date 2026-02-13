-- ============================================================================
-- Context Menu para Upgrades de Mochilas STK
-- ============================================================================

local STKBagUpgrade = require("STKBagUpgrade")
require("ISSTKBagUpgradeAction")

-- ============================================================================
-- LOGGING
-- ============================================================================
local DEBUG_MODE = true

local Logger = {
	log = function(message)
		if not DEBUG_MODE then
			return
		end
		print("[STKBagUpgrade-Menu] " .. tostring(message))
	end,
}

Logger.log("Context Menu carregado.")

local function onFillInventoryContextMenu(playerNum, context, items)
	local player = getSpecificPlayer(playerNum)
	local selectedItem = items[1]

	if not instanceof(selectedItem, "InventoryItem") then
		selectedItem = selectedItem.items[1]
	end

	-- ========================================================================
	-- CENÁRIO 1: Jogador clicou em uma MOCHILA
	-- ========================================================================
	if STKBagUpgrade.isBagValid(selectedItem) then
		Logger.log("Mochila válida detectada: " .. selectedItem:getType())
		local bag = selectedItem
		STKBagUpgrade.initBag(bag)

		-- Submenu para ADICIONAR upgrades
		local addUpgradeSubMenu = context:getNew()
		local addUpgradeOption = context:addOption("🎒 Adicionar Upgrade STK", nil, nil)
		context:addSubMenu(addUpgradeOption, addUpgradeSubMenu)

		-- Validação 1: Mochila está cheia de upgrades?
		if not STKBagUpgrade.canAddUpgrade(bag) then
			Logger.log("Validação FALHOU: Mochila já tem máximo de upgrades")
			addUpgradeOption.notAvailable = true
			addUpgradeOption
				:getOrCreateToolTip()
				:setInfo("Esta mochila já atingiu o máximo de upgrades.", 0.8, 0.8, 0.8, 1)
			return
		end

		-- Validação 2: Jogador tem as ferramentas (agulha + linha)?
		if not STKBagUpgrade.hasRequiredTools(player, "add") then
			Logger.log("Validação FALHOU: Falta Agulha ou Linha")
			addUpgradeOption.notAvailable = true
			addUpgradeOption
				:getOrCreateToolTip()
				:setInfo("Você precisa de Agulha e Linha para costurar upgrades.", 1, 0.5, 0.5, 1)
			return
		end

		-- Validação 3: Jogador tem itens de upgrade STK?
		local availableUpgrades = STKBagUpgrade.getUpgradeItems(player:getInventory())
		Logger.log("Upgrades disponíveis encontrados: " .. #availableUpgrades)

		if #availableUpgrades == 0 then
			Logger.log("Validação FALHOU: Nenhum item de upgrade no inventário")
			addUpgradeOption.notAvailable = true
			addUpgradeOption:getOrCreateToolTip():setInfo(
				"Você não tem nenhum item de upgrade STK no inventário.\n"
					.. "Procure por: Straps, Fabric ou Belt Buckle.",
				0.8,
				0.8,
				0.8,
				1
			)
			return
		end

		-- Tudo OK! Mostrar opções de upgrade
		Logger.log("Todas validações passaram! Mostrando menu de upgrades")
		for _, upgradeItem in ipairs(availableUpgrades) do
			local displayName = upgradeItem:getDisplayName()
			local value = STKBagUpgrade.getUpgradeValue(upgradeItem:getType())
			Logger.log("  - " .. upgradeItem:getType() .. " (valor: " .. tostring(value) .. ")")

			-- Adiciona informação visual do que o upgrade faz
			if value > 0 then
				-- Fabrics aumentam capacidade
				displayName = displayName .. " (+" .. value .. " Capacidade)"
			else
				-- Straps e Buckles melhoram weight reduction
				displayName = displayName .. " (+" .. math.floor(math.abs(value) * 100) .. "% Redução de Peso)"
			end

			addUpgradeSubMenu:addOption(displayName, nil, function()
				ISTimedActionQueue.add(ISSTKBagAddUpgradeAction:new(player, bag, upgradeItem))
			end)
		end

		-- ====================================================================
		-- Submenu para REMOVER upgrades
		-- ====================================================================
		local imd = bag:getModData()
		if #imd.LUpgrades > 0 then
			Logger.log("Mochila tem " .. #imd.LUpgrades .. " upgrade(s), criando menu de remoção")
			local removeUpgradeSubMenu = context:getNew()
			local removeUpgradeOption = context:addOption("✂️ Remover Upgrade STK", nil, nil)
			context:addSubMenu(removeUpgradeOption, removeUpgradeSubMenu)

			-- Validação: Jogador tem tesoura?
			if not STKBagUpgrade.hasRequiredTools(player, "remove") then
				Logger.log("Validação FALHOU: Falta tesoura para remover")
				removeUpgradeOption.notAvailable = true
				removeUpgradeOption
					:getOrCreateToolTip()
					:setInfo("Você precisa de uma Tesoura para remover upgrades.", 1, 0.5, 0.5, 1)
			else
				-- Listar todos os upgrades aplicados
				for _, upgradeType in ipairs(imd.LUpgrades) do
					local displayName = upgradeType -- Pode melhorar com getText() depois
					local value = STKBagUpgrade.getUpgradeValue(upgradeType)

					if value > 0 then
						-- Fabrics
						displayName = displayName .. " (+" .. value .. " Capacidade)"
					else
						-- Straps e Buckles
						displayName = displayName .. " (+" .. math.floor(math.abs(value) * 100) .. "% Redução)"
					end

					removeUpgradeSubMenu:addOption(displayName, nil, function()
						ISTimedActionQueue.add(ISSTKBagRemoveUpgradeAction:new(player, bag, upgradeType))
					end)
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
	--         local upgradeToOption = context:addOption("🎒 Instalar em Mochila", nil, nil)
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
