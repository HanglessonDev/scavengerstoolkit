--- @file scavengerstoolkit\42.12\media\lua\client\ToolTipInvOverride_STK.lua
--- @brief Tooltip extension for displaying STK upgrade information
---
--- This script extends the game's tooltip functionality to display
--- information about Scavenger's Toolkit backpack upgrades.
--- It shows available/used slots, capacity and weight reduction bonuses
--- for backpacks, and upgrade values for improvement items.
---
--- @author Scavenger's Toolkit Development Team
--- @version 1.0.0
--- @license MIT
--- @copyright 2026 Scavenger's Toolkit

require("ISUI/ISToolTipInv")

local STKBagUpgrade = require("STKBagUpgrade")
local Old_Render = ISToolTipInv.render

--- Override do método render para adicionar informações STK
---@diagnostic disable-next-line: duplicate-set-field
function ISToolTipInv:render()
	local item = self.item
	if not item then
		return Old_Render(self)
	end

	local numRows = 0
	local isBag = item:IsInventoryContainer() and STKBagUpgrade.isBagValid(item)
	local isUpgrade = STKBagUpgrade.getUpgradeValue(item:getType():gsub("^STK%.", "")) ~= nil

	-- Conta linhas extras que serão adicionadas ao tooltip
	if isBag then
		STKBagUpgrade.initBag(item)
		local imd = item:getModData()

		-- Linha de slots
		if imd.LMaxUpgrades > 0 then
			numRows = numRows + 1
		end

		-- Linhas de bônus (verifica quais realmente existem)
		if #imd.LUpgrades > 0 then
			---@diagnostic disable-next-line: undefined-field
			local bonusCap = item:getCapacity() - imd.LCapacity
			---@diagnostic disable-next-line: undefined-field
			local bonusWR = item:getWeightReduction() - imd.LWeightReduction

			if bonusCap > 0 then
				numRows = numRows + 1
			end
			if bonusWR > 0 then
				numRows = numRows + 1
			end
		end
	elseif isUpgrade then
		numRows = 1
	end

	if numRows == 0 then
		return Old_Render(self)
	end

	-- Ajusta altura do tooltip para acomodar as informações adicionais
	local stage = 1
	local old_y = 0
	local lineSpacing = self.tooltip:getLineSpacing()
	local old_setHeight = self.setHeight

	self.setHeight = function(self, num, ...)
		if stage == 1 then
			stage = 2
			old_y = num
			num = num + (0.5 + numRows) * lineSpacing
		end
		return old_setHeight(self, num, ...)
	end

	-- Desenha informações adicionais no tooltip
	local old_drawRectBorder = self.drawRectBorder
	self.drawRectBorder = function(self, ...)
		if stage == 2 then
			local font = UIFont[getCore():getOptionTooltipFont()]
			local i = 0

			if isBag then
				local bagColor = { 0.68, 0.64, 0.96 }
				local imd = item:getModData()
				local maxSlots = imd.LMaxUpgrades
				local usedSlots = #imd.LUpgrades

				-- Mostra slots disponíveis/utilizados
				self.tooltip:DrawText(
					font,
					getText("UI_STK_Slots") .. ": " .. (maxSlots - usedSlots) .. "/" .. maxSlots,
					5,
					old_y + lineSpacing * i,
					bagColor[1],
					bagColor[2],
					bagColor[3],
					1
				)
				i = i + 1

				-- Mostra bônus de capacidade
				if usedSlots > 0 then
					---@diagnostic disable-next-line: undefined-field
					local bonusCap = item:getCapacity() - imd.LCapacity
					if bonusCap > 0 then
						self.tooltip:DrawText(
							font,
							"+" .. bonusCap .. " " .. getText("UI_STK_Capacity"),
							5,
							old_y + lineSpacing * i,
							bagColor[1],
							bagColor[2],
							bagColor[3],
							1
						)
						i = i + 1
					end

					-- Mostra bônus de redução de peso
					---@diagnostic disable-next-line: undefined-field
					local bonusWR = item:getWeightReduction() - imd.LWeightReduction
					if bonusWR > 0 then
						self.tooltip:DrawText(
							font,
							"+" .. bonusWR .. "% " .. getText("UI_STK_WeightReduction"),
							5,
							old_y + lineSpacing * i,
							bagColor[1],
							bagColor[2],
							bagColor[3],
							1
						)
					end
				end
			elseif isUpgrade then
				local upgradeColor = { 0.95, 0.95, 0.2 }
				local value = STKBagUpgrade.getUpgradeValue(item:getType():gsub("^STK%.", ""))
				local text = ""

				if value and value > 0 then
					-- Capacidade (lê do Sandbox!)
					text = "+" .. value .. " " .. getText("UI_STK_Capacity")
				elseif value then
					-- Weight Reduction (lê do Sandbox!)
					-- Valor já vem como percentual após conversão (ex: 0.05 * 100 = 5)
					local percent = math.abs(value) * 100
					text = "+" .. percent .. "% " .. getText("UI_STK_WeightReduction")
				end

				self.tooltip:DrawText(font, text, 5, old_y, upgradeColor[1], upgradeColor[2], upgradeColor[3], 1)
			end

			stage = 3
		end
		return old_drawRectBorder(self, ...)
	end

	Old_Render(self)
	self.setHeight = old_setHeight
	self.drawRectBorder = old_drawRectBorder
end
