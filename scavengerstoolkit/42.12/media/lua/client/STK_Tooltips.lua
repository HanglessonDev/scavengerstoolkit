--- @file scavengerstoolkit\42.12\media\lua\client\STK_Tooltips.lua
--- @brief Tooltip extension displaying STK upgrade information on bags and upgrade items
---
--- Overrides ISToolTipInv:render() to append extra lines showing:
---   - Available/used upgrade slots on bags
---   - Capacity bonus currently applied
---   - Weight reduction bonus currently applied
---   - Upgrade value preview on upgrade items
---
--- NOTE (Refactor v3.0): This file was renamed from
--- ToolTipInvOverride_STK.lua. Logic is unchanged.
---
--- @author Scavenger's Toolkit Development Team
--- @version 3.0.0
--- @license MIT
--- @copyright 2026 Scavenger's Toolkit

require("ISUI/ISToolTipInv")

local STKBagUpgrade = require("STKBagUpgrade")
local STK_Core = require("STK_Core")

local Old_Render = ISToolTipInv.render

--- Override of ISToolTipInv:render() to append STK upgrade information.
---@diagnostic disable-next-line: duplicate-set-field
function ISToolTipInv:render()
	local item = self.item
	if not item then
		return Old_Render(self)
	end

	local isBag = item:IsInventoryContainer() and STKBagUpgrade.isBagValid(item)
	local isUpgrade = STKBagUpgrade.getUpgradeValue(item:getType():gsub("^STK%.", "")) ~= nil
	local numRows = 0

	if isBag then
		STKBagUpgrade.initBag_Client(item)
		local imd = item:getModData()
		local maxSlots = STK_Core.getLimitForType(item:getFullType())

		if maxSlots > 0 then
			numRows = numRows + 1
		end

		if imd.LUpgrades and #imd.LUpgrades > 0 then
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

	-- Adjust tooltip height to accommodate extra rows
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

	-- Draw extra information once the border is being drawn
	local old_drawRectBorder = self.drawRectBorder
	self.drawRectBorder = function(self, ...)
		if stage == 2 then
			local font = UIFont[getCore():getOptionTooltipFont()]
			local i = 0

			if isBag then
				local bagColor = { 0.68, 0.64, 0.96 }
				local imd = item:getModData()
				local maxSlots = STK_Core.getLimitForType(item:getFullType())
				local usedSlots = #imd.LUpgrades

				-- Slots line
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

				-- Bonus lines (only when upgrades are present)
				if usedSlots > 0 then
					---@diagnostic disable-next-line: undefined-field
					local bonusCap = item:getCapacity() - imd.LCapacity
					---@diagnostic disable-next-line: undefined-field
					local bonusWR = item:getWeightReduction() - imd.LWeightReduction

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
					text = "+" .. value .. " " .. getText("UI_STK_Capacity")
				elseif value then
					text = "+" .. (math.abs(value) * 100) .. "% " .. getText("UI_STK_WeightReduction")
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
