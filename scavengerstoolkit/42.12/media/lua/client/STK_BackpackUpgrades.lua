-- STK Backpack Upgrades
-- Sistema de upgrade de mochilas usando materiais do mod STK
-- Baseado no mod Dynamic Backpacks (Lazolo)

require("TimedActions/ISSTKBackpackUpgradeAction")

local BannedItemTypes = { "KeyRing" } -- lista de containers banidos

local SandboxInit = false
local BaseUpgrades = 1 -- slots base de upgrade
local BackModifier = 1 -- modificador para mochilas de costas
local FannyModifier = 0 -- modificador para pochetes
local OtherModifier = 0 -- modificador para outros tipos

-- Valores de upgrade dos materiais STK
-- Formato: [ItemType] = valor
-- Valores >= 1 = aumenta capacidade
-- Valores < 1 = reduz peso (weight reduction)
local UpgradeItemValues = {
	-- BASIC TIER
	["BackpackStrapsBasic"] = 0.85, -- Reduz 15% do peso
	["BackpackFabricBasic"] = 1.10, -- Aumenta 10% da capacidade

	-- REINFORCED TIER
	["BackpackStrapsReinforced"] = 0.75, -- Reduz 25% do peso
	["BackpackFabricReinforced"] = 1.20, -- Aumenta 20% da capacidade

	-- TACTICAL TIER
	["BackpackStrapsTactical"] = 0.65, -- Reduz 35% do peso
	["BackpackFabricTactical"] = 1.30, -- Aumenta 30% da capacidade
}

-- Função pública para outros scripts acessarem valores
function getUpgradeItemValue(ItemType)
	return UpgradeItemValues[ItemType]
end

-- Verifica se item está na lista de banidos
function ItemBanCheck(Item)
	local Type = Item:getType()
	for i, v in pairs(BannedItemTypes) do
		if Type == v then
			return true
		end
	end
	return false
end

-- Verifica se item é um container válido
function ItemValid(Item)
	if Item and Item:IsInventoryContainer() and not ItemBanCheck(Item) then
		return true
	else
		return false
	end
end

-- Funções utilitárias
function TableCheck(Table, For, UseIndex)
	for i, v in pairs(Table) do
		if UseIndex then
			if i == For then
				return true
			end
		else
			if v == For then
				return true
			end
		end
	end
	return false
end

function TableShallowCopy(Table)
	local Copy = {}
	for i, v in pairs(Table) do
		Copy[i] = v
	end
	return Copy
end

function Round(Num, DecimalPlaces)
	return math.floor((Num * 10 ^ DecimalPlaces) + 0.5) / 10 ^ DecimalPlaces
end

-- Busca materiais de upgrade no inventário do player
function GetUpgradeItems(Container, ReturnTable)
	local Inventory = Container:getInventory()
	for i = 0, Inventory:getItems():size() - 1 do
		local Item = Inventory:getItems():get(i)
		if Item and Item:getType() then
			if Item:IsInventoryContainer() and Item:isEquipped() then
				ReturnTable = GetUpgradeItems(Item, ReturnTable)
			elseif UpgradeItemValues[Item:getType()] then
				table.insert(ReturnTable, Item)
			end
		end
	end
	return ReturnTable
end

-- Calcula stats teóricos baseado numa lista de upgrades
function GetTheoreticalStats(BaseCapacity, BaseWR, UpgradesTable)
	local CapacityBonus = 0
	local WeightMod = 1

	for i, v in pairs(UpgradesTable) do
		if UpgradeItemValues[v] >= 1 then
			-- Upgrade de capacidade
			CapacityBonus = CapacityBonus + math.floor(BaseCapacity * (UpgradeItemValues[v] - 1))
		end
		if UpgradeItemValues[v] < 1 then
			-- Upgrade de weight reduction
			WeightMod = WeightMod * UpgradeItemValues[v]
		end
	end

	return math.floor(BaseCapacity + CapacityBonus + 0.5), math.floor(100.5 - (100 - BaseWR) * WeightMod)
end

-- Calcula stats atuais da mochila baseado nos upgrades aplicados
function GetUpgradedStats(Bag)
	local imd = Bag:getModData()
	local CapacityBonus = 0
	local WeightMod = 1

	for i, v in pairs(imd.STK_Upgrades) do
		if UpgradeItemValues[v] >= 1 then
			CapacityBonus = CapacityBonus + math.floor(imd.STK_BaseCapacity * (UpgradeItemValues[v] - 1))
		end
		if UpgradeItemValues[v] < 1 then
			WeightMod = WeightMod * UpgradeItemValues[v]
		end
	end

	return Round(imd.STK_BaseCapacity + CapacityBonus, 0),
		Round(100 - (100 - imd.STK_BaseWeightReduction) * WeightMod, 0)
end

-- Determina número máximo de upgrades baseado no tipo de mochila
function GetMaxUpgrades(Item)
	if Item["canBeEquipped"](Item) == ItemBodyLocation.BACK then
		return BaseUpgrades + BackModifier
	elseif
		Item["canBeEquipped"](Item) == ItemBodyLocation.FANNY_PACK_BACK
		or Item["canBeEquipped"](Item) == ItemBodyLocation.FANNY_PACK_FRONT
	then
		return BaseUpgrades + FannyModifier
	else
		return BaseUpgrades + OtherModifier
	end
end

-- INICIALIZAÇÃO DA MOCHILA - SALVA STATS ORIGINAIS NO MODDATA
function InitBackpack(Item)
	local imd = Item:getModData()
	imd.STK_Upgrades = imd.STK_Upgrades or {}
	imd.STK_BaseCapacity = imd.STK_BaseCapacity or Item:getCapacity()
	imd.STK_BaseWeightReduction = imd.STK_BaseWeightReduction or Item:getWeightReduction()
	imd.STK_Initialized = true
	imd.STK_MaxUpgrades = GetMaxUpgrades(Item)
end

-- Atualiza stats da mochila baseado nos upgrades
function UpdateBag(Bag)
	local imd = Bag:getModData()
	imd.STK_MaxUpgrades = GetMaxUpgrades(Bag)

	local UpgradedCapacity, UpgradedWeightReduction = GetUpgradedStats(Bag)

	Bag:setCapacity(UpgradedCapacity)
	Bag:setWeightReduction(UpgradedWeightReduction)
end

-- ADICIONA UPGRADE À MOCHILA
function AddUpgrade(Bag, Item, Player)
	if not Bag or not Bag:IsInventoryContainer() or not Item or not Item:getContainer() then
		return
	end
	local imd = Bag:getModData()
	if imd.STK_MaxUpgrades > 0 and #imd.STK_Upgrades >= imd.STK_MaxUpgrades then
		return
	end

	if UpgradeItemValues[Item:getType()] then
		table.insert(imd.STK_Upgrades, Item:getType())
		Item:getContainer():Remove(Item)
		UpdateBag(Bag)
	end
end

-- REMOVE UPGRADE DA MOCHILA
function RemoveUpgrade(Bag, ItemType, Player)
	if not Bag or not Bag:IsInventoryContainer() or not ItemType then
		return
	end
	local imd = Bag:getModData()

	for i, v in pairs(imd.STK_Upgrades) do
		if v == ItemType then
			local Inventory = Bag:getContainer()
			local Item = Inventory:AddItem("STK." .. ItemType)
			Inventory:addItemOnServer(Item)
			table.remove(imd.STK_Upgrades, i)
			UpdateBag(Bag)
			break
		end
	end
end

-- Verifica se item tem durabilidade
function HasDurability(Item)
	if not Item:getCondition() or Item:getCondition() > 0 then
		return true
	end
	return false
end

-- Checa e busca ferramentas necessárias para upgrade (agulha e linha)
function CheckForAndGetUpgradeItems(Player, Fetch)
	local inv = Player:getInventory()
	local Needle = inv:getFirstTypeRecurse("Needle")
	local Thread = inv:getFirstTypeRecurse("Thread")

	if not Needle or not Thread then
		return false
	end

	if Fetch and not inv:contains(Needle) then
		ISTimedActionQueue.add(
			ISInventoryTransferAction:new(Player, Needle, Needle:getContainer(), inv, Needle:getWeight() * 60)
		)
	end
	if Fetch and not inv:contains(Thread) then
		ISTimedActionQueue.add(
			ISInventoryTransferAction:new(Player, Thread, Thread:getContainer(), inv, Thread:getWeight() * 60)
		)
	end

	return Needle, Thread
end

-- Checa e busca ferramentas para remover upgrade (tesoura)
function CheckForAndGetRemoveItems(Player, Fetch)
	local inv = Player:getInventory()
	local Scissors = inv:getFirstEvalRecurse(function(item)
		return item:hasTag("Scissors") and HasDurability(item)
	end)

	if not Scissors then
		return false
	end

	if Fetch and not inv:contains(Scissors) then
		ISTimedActionQueue.add(
			ISInventoryTransferAction:new(Player, Scissors, Scissors:getContainer(), inv, Scissors:getWeight() * 60)
		)
	end

	return Scissors
end

-- Verifica se é possível remover um upgrade sem sobrecarregar a mochila
function RemoveValid(Bag, UpgradeItemType)
	if UpgradeItemValues[UpgradeItemType] < 1 then
		return true -- Weight Reduction upgrades sempre podem ser removidos
	else
		local FakeUpgrades = TableShallowCopy(Bag:getModData().STK_Upgrades)
		for i, v in pairs(FakeUpgrades) do
			if v == UpgradeItemType then
				table.remove(FakeUpgrades, i)
			end
		end

		local imd = Bag:getModData()
		local CurrentWeight = Bag:getContentsWeight()
		local BaseCapacity = imd.STK_BaseCapacity
		local BaseWR = imd.STK_BaseWeightReduction
		local NewCapacity, NewReduction = GetTheoreticalStats(BaseCapacity, BaseWR, FakeUpgrades)

		if CurrentWeight <= NewCapacity then
			return true
		else
			local Str = Round(CurrentWeight, 2) .. "/" .. Round(NewCapacity, 2)
			return false, "Mochila muito cheia para remover! Peso: " .. Str
		end
	end
end

-- Callback do menu de contexto
function OnMenuOptionSelected(Player, OnComplete, Bag, ItemInfo, JobType)
	print("[STK DEBUG] OnMenuOptionSelected chamado!")
	print("[STK DEBUG] Bag:", Bag:getType())
	print("[STK DEBUG] ItemInfo:", ItemInfo)
	print("[STK DEBUG] JobType:", JobType)

	local ExtraItems = {}

	if instanceof(ItemInfo, "InventoryItem") then
		print("[STK DEBUG] É InventoryItem - ADICIONANDO upgrade")
		-- Adicionando upgrade
		local Needle, Thread = CheckForAndGetUpgradeItems(Player, true)
		print("[STK DEBUG] Needle:", Needle, "Thread:", Thread)
		if not Needle then
			print("[STK DEBUG] ERRO: Sem agulha!")
			return false
		end
		table.insert(ExtraItems, ItemInfo)
		table.insert(ExtraItems, Needle)
		table.insert(ExtraItems, Thread)

		if not Player:getInventory():contains(ItemInfo) then
			ISTimedActionQueue.add(
				ISInventoryTransferAction:new(
					Player,
					ItemInfo,
					ItemInfo:getContainer(),
					Player:getInventory(),
					ItemInfo:getWeight() * 60
				)
			)
		end
	else
		print("[STK DEBUG] É string - REMOVENDO upgrade")
		-- Removendo upgrade
		local Scissors = CheckForAndGetRemoveItems(Player, true)
		if not Scissors then
			print("[STK DEBUG] ERRO: Sem tesoura!")
			return
		end
		local IsValid = RemoveValid(Bag, ItemInfo)
		if not IsValid then
			print("[STK DEBUG] ERRO: RemoveValid falhou!")
			return
		end
		table.insert(ExtraItems, Scissors)
	end

	if Bag and not Player:getInventory():contains(Bag) then
		ISTimedActionQueue.add(
			ISInventoryTransferAction:new(Player, Bag, Bag:getContainer(), Player:getInventory(), Bag:getWeight() * 50)
		)
	end

	print("[STK DEBUG] Criando ISSTKBackpackUpgradeAction...")
	ISTimedActionQueue.add(ISSTKBackpackUpgradeAction:new(Player, OnComplete, Bag, ItemInfo, JobType, ExtraItems))
	print("[STK DEBUG] Ação adicionada à fila!")
end

-- MENU DE CONTEXTO DO INVENTÁRIO
function OnInventoryContextMenu(playernum, Context, Items)
	local Player = getSpecificPlayer(playernum)

	for i, v in pairs(Items) do
		local Item = v
		if not instanceof(v, "InventoryItem") then
			Item = v.items[1]
		end

		if ItemValid(Item) then
			-- Player clicou numa mochila
			local imd = Item:getModData()

			if not imd.STK_Initialized then
				InitBackpack(Item)
			end

			-- Opção de ADICIONAR upgrade
			if imd.STK_MaxUpgrades > 0 and #imd.STK_Upgrades < imd.STK_MaxUpgrades then
				local UpgradeItems = GetUpgradeItems(Player, {})
				local UpgradeMenu
				local Needle, Thread = CheckForAndGetUpgradeItems(Player, false)

				if #UpgradeItems > 0 then
					if Needle then
						for i2, v2 in pairs(UpgradeItems) do
							if not UpgradeMenu then
								UpgradeMenu = ISContextMenu:getNew(Context)
								local addOption = Context:addOption("Adicionar Upgrade", nil, nil)
								Context:addSubMenu(addOption, UpgradeMenu)
							end
							UpgradeMenu:addOption(
								v2:getDisplayName(),
								Player,
								OnMenuOptionSelected,
								AddUpgrade,
								Item,
								v2,
								"Costurando..."
							)
						end
					else
						local Option = Context:addOption("Adicionar Upgrade")
						local Tooltip = ISInventoryPaneContextMenu.addToolTip()
						Option.toolTip = Tooltip
						Tooltip.description = "Necessita agulha e linha"
						Option.notAvailable = true
					end
				end
			end

			-- Opção de REMOVER upgrade
			if #imd.STK_Upgrades >= 1 then
				local Scissors = CheckForAndGetRemoveItems(Player, false)

				if Scissors then
					local RemoveMenu
					RemoveMenu = ISContextMenu:getNew(Context)
					local removeOption = Context:addOption("Remover Upgrade", nil, nil)
					Context:addSubMenu(removeOption, RemoveMenu)

					for i2, v2 in pairs(imd.STK_Upgrades) do
						local IsValid, Message = RemoveValid(Item, v2)
						if IsValid then
							RemoveMenu:addOption(
								v2,
								Player,
								OnMenuOptionSelected,
								RemoveUpgrade,
								Item,
								v2,
								"Removendo..."
							)
						else
							local Option = RemoveMenu:addOption(v2)
							local Tooltip = ISInventoryPaneContextMenu.addToolTip()
							Option.toolTip = Tooltip
							Tooltip.description = Message or "Não é possível remover"
							Option.notAvailable = true
						end
					end
				else
					local Option = Context:addOption("Remover Upgrade")
					local Tooltip = ISInventoryPaneContextMenu.addToolTip()
					Option.toolTip = Tooltip
					Tooltip.description = "Necessita tesoura"
					Option.notAvailable = true
				end
			end

			break
		elseif UpgradeItemValues[Item:getType()] then
			-- Player clicou num material de upgrade
			local UpgradeMenu
			local Inventory = Player:getInventory()
			local Needle, Thread = CheckForAndGetUpgradeItems(Player)

			if Needle then
				for i = 0, Inventory:getItems():size() - 1 do
					local BagItem = Inventory:getItems():get(i)
					if BagItem and Item:getType() then
						if ItemValid(BagItem) then
							if not BagItem:getModData().STK_Initialized then
								InitBackpack(BagItem)
							end
							if
								BagItem:getModData().STK_MaxUpgrades > 0
								and #BagItem:getModData().STK_Upgrades < BagItem:getModData().STK_MaxUpgrades
							then
								if not UpgradeMenu then
									UpgradeMenu = ISContextMenu:getNew(Context)
									local upgradeOption = Context:addOption("Fazer Upgrade", nil, nil)
									Context:addSubMenu(upgradeOption, UpgradeMenu)
								end
								UpgradeMenu:addOption(
									BagItem:getDisplayName(),
									Player,
									OnMenuOptionSelected,
									AddUpgrade,
									BagItem,
									Item,
									"Costurando..."
								)
							end
						end
					end
				end
			else
				local Option = Context:addOption("Fazer Upgrade")
				local Tooltip = ISInventoryPaneContextMenu.addToolTip()
				Option.toolTip = Tooltip
				Tooltip.description = "Necessita agulha e linha"
				Option.notAvailable = true
			end
		end
	end
end

-- Registra eventos
Events.OnFillInventoryObjectContextMenu.Add(OnInventoryContextMenu)

print("[STK] Backpack Upgrades carregado!")
