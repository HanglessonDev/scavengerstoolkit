--- @file scavengerstoolkit\42.12\media\lua\server\STK_TailoringXP.lua
--- @brief Server-side Tailoring XP grant on upgrade addition
---
--- Listens to OnSTKUpgradeAdded and grants regressive XP to the player.
--- XP decreases as Tailoring level increases, floored at the configured
--- minimum (SandboxVars.STK.MinimumXP).
---
--- The xpGained value is NOT re-fired here — it was already passed into
--- OnSTKUpgradeAdded by STK_UpgradeLogic.applyUpgrade(). The client
--- FeedbackSystem reads it from the event to display the HaloText popup.
---
--- @author Scavenger's Toolkit Development Team
--- @version 3.0.0
--- @license MIT
--- @copyright 2026 Scavenger's Toolkit

local STK_Utils = require("STK_Utils")
local log = require("STK_Logger").get("STK-TailoringXP")

-- ============================================================================
-- PUBLIC API
-- ============================================================================

--- @class STKTailoringXP
local STK_TailoringXP = {}

--- Grants Tailoring XP to the player and returns the amount granted.
--- Returns 0 if the feature is disabled in SandboxVars.
--- @param player any IsoPlayer
--- @return number xpGained Amount granted (0 if disabled)
function STK_TailoringXP.grant(player)
	if not SandboxVars.STK.TailoringXPEnabled then
		log.debug("Feature desabilitada no Sandbox")
		return 0
	end

	local level = player:getPerkLevel(Perks.Tailoring)
	local xp = STK_Utils.calculateTailoringXP(level)

	player:getXp():AddXP(Perks.Tailoring, xp)

	log.debug(string.format("XP concedido: %.1f (level=%d)", xp, level))

	return xp
end

-- ============================================================================

log.info("Modulo carregado.")

return STK_TailoringXP
