require("ISUI/ISToolTipInv")

local STKBagUpgrade = require("STKBagUpgrade")
local Old_Render = ISToolTipInv.render

---@diagnostic disable-next-line: duplicate-set-field
function ISToolTipInv:render()
	local item = self.item
	if not item then
		return Old_Render(self)
	end

	local numRows = 0
	local isBag = item:IsInventoryContainer() and STKBagUpgrade.isBagValid(item)
	local isUpgrade = STKBagUpgrade.getUpgradeValue(item:getType():gsub("^STK%.", "")) ~= nil

	-- Conta linhas extras
	if isBag then
		STKBagUpgrade.initBag(item)
		local imd = item:getModData()
		if imd.LMaxUpgrades > 0 then
			numRows = numRows + 1
		end
		if #imd.LUpgrades > 0 then
			numRows = numRows + 2
		end -- Cap + WR
	elseif isUpgrade then
		numRows = 1
	end

	if numRows == 0 then
		return Old_Render(self)
	end

	-- Ajusta altura
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

	-- Desenha info extra
	local old_drawRectBorder = self.drawRectBorder
	self.drawRectBorder = function(self, ...)
		if stage == 2 then
			local font = UIFont[getCore():getOptionTooltipFont()]
			local color = { 0.68, 0.64, 0.96 }
			local i = 0

			if isBag then
				local imd = item:getModData()
				local maxSlots = imd.LMaxUpgrades
				local usedSlots = #imd.LUpgrades

				-- Slots disponíveis
				self.tooltip:DrawText(
					font,
					getText("UI_STK_Slots") .. ": " .. (maxSlots - usedSlots) .. "/" .. maxSlots,
					5,
					old_y + lineSpacing * i,
					color[1],
					color[2],
					color[3],
					1
				)
				i = i + 1

				-- Bônus de capacidade
				if usedSlots > 0 then
					local bonusCap = item:getCapacity() - imd.LCapacity
					if bonusCap > 0 then
						self.tooltip:DrawText(
							font,
							"+" .. bonusCap .. " " .. getText("UI_STK_Capacity"),
							5,
							old_y + lineSpacing * i,
							color[1],
							color[2],
							color[3],
							1
						)
						i = i + 1
					end

					-- Bônus de weight reduction
					local bonusWR = item:getWeightReduction() - imd.LWeightReduction
					if bonusWR > 0 then
						self.tooltip:DrawText(
							font,
							"+" .. bonusWR .. "% " .. getText("UI_STK_WeightReduction"),
							5,
							old_y + lineSpacing * i,
							color[1],
							color[2],
							color[3],
							1
						)
					end
				end
			elseif isUpgrade then
				local value = STKBagUpgrade.getUpgradeValue(item:getType():gsub("^STK%.", ""))
				local color = { 0.95, 0.95, 0.2 }
				local text = ""

				if value > 0 then
					-- Capacidade (lê do Sandbox!)
					text = "+" .. value .. " Capacidade"
				else
					-- Weight Reduction (lê do Sandbox!)
					text = "+" .. math.floor(math.abs(value) * 100) .. "% Reducao de Peso"
				end

				self.tooltip:DrawText(font, text, 5, old_y, color[1], color[2], color[3], 1)
			end

			stage = 3
		end
		return old_drawRectBorder(self, ...)
	end

	Old_Render(self)
	self.setHeight = old_setHeight
	self.drawRectBorder = old_drawRectBorder
end
