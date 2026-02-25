--- @file scavengerstoolkit\42.12\media\lua\shared\STK_API.lua
--- @author Scavenger's Toolkit Team
--- @version 1.0.0
---
--- Public API for registering bags with the STK upgrade system at runtime.
---
--- This module is the integration point for both internal STK modules
--- (e.g. Hydration Module) and external mods that want their bags to
--- accept STK upgrades without editing STK_Constants directly.
---
--- ## Usage (external mod)
--- Declare `dependencies = scavengerstoolkit` in your mod.info, then:
---
--- ```lua
--- local STK_API = require("STK_API")
--- STK_API.registerBag("MyMod.MyBackpack", { category = "hiking" })
--- ```
---
--- If you cannot guarantee the STK is present, use pcall for graceful
--- degradation:
---
--- ```lua
--- local ok, STK_API = pcall(require, "STK_API")
--- if ok then
---     STK_API.registerBag("MyMod.MyBackpack", { category = "hiking" })
--- end
--- ```
---
--- ## Valid categories
--- | category        | sandboxKey          | default limit |
--- |-----------------|---------------------|---------------|
--- | `fannypack`     | FannyPackLimit      | 1             |
--- | `satchel`       | SatchelLimit        | 2             |
--- | `schoolbag`     | SchoolbagLimit      | 2             |
--- | `hiking`        | HikingBagLimit      | 3             |
--- | `duffel`        | DuffelBagLimit      | 3             |
--- | `military`      | MilitaryBagLimit    | 4             |
--- | `crafted`       | CraftedBagLimit     | 2             |
--- | `crafted_large` | CraftedBagLargeLimit| 3             |
---

local STK_Constants = require("STK_Constants")
local STK_Logger = require("STK_Logger")

local log = STK_Logger.get("STK-API")

--- @class STKAPI
local STK_API = {}

-- ----------------------------------------------------------------------------
-- Internal: category → sandboxKey mapping
-- Isolates callers from internal naming — if a sandboxKey ever changes,
-- only this table needs updating.
-- ----------------------------------------------------------------------------

--- @type table<string, string>
local CATEGORY_MAP = {
	fannypack = "FannyPackLimit",
	satchel = "SatchelLimit",
	schoolbag = "SchoolbagLimit",
	hiking = "HikingBagLimit",
	duffel = "DuffelBagLimit",
	military = "MilitaryBagLimit",
	crafted = "CraftedBagLimit",
	crafted_large = "CraftedBagLargeLimit",
}

-- Pre-built sorted list for error messages — built once, reused forever.
local VALID_CATEGORIES_MSG
do
	local keys = {}
	for k in pairs(CATEGORY_MAP) do
		keys[#keys + 1] = k
	end
	table.sort(keys)
	VALID_CATEGORIES_MSG = table.concat(keys, ", ")
end

-- ----------------------------------------------------------------------------
-- Public API
-- ----------------------------------------------------------------------------

--- Registers a bag full type so STK upgrade recipes accept it.
---
--- The registration is written directly into `STK_Constants.BAGS`, so it
--- is visible to `STK_Core.isValidBag` and `STK_Core.getLimitForType`
--- immediately after this call returns.
---
--- Validation rules (fails fast on first violation):
--- - `fullType` must be a non-empty string.
--- - `options.category` must be one of the valid categories listed above.
--- - If `fullType` is already registered the call is a no-op and returns
---   `false`. Existing entries are never overwritten.
---
--- @param fullType string   Full type of the bag, e.g. `"MyMod.TacticalPack"`
--- @param options  table    Table with field `category: string`
--- @return boolean          `true` if registered, `false` if already existed or invalid
function STK_API.registerBag(fullType, options)
	-- Validate fullType
	if type(fullType) ~= "string" or fullType == "" then
		log.error("registerBag: fullType must be a non-empty string (got " .. tostring(fullType) .. ")")
		return false
	end

	-- Validate options
	if type(options) ~= "table" then
		log.error("registerBag: options must be a table (got " .. type(options) .. ") for '" .. fullType .. "'")
		return false
	end

	-- Validate category
	local category = options.category
	local sandboxKey = CATEGORY_MAP[category]
	if not sandboxKey then
		log.error(
			"registerBag: unknown category '"
				.. tostring(category)
				.. "' for '"
				.. fullType
				.. "'. Valid categories: "
				.. VALID_CATEGORIES_MSG
		)
		return false
	end

	-- No-op if already registered
	if STK_Constants.BAGS[fullType] ~= nil then
		log.warn("registerBag: '" .. fullType .. "' is already registered — skipping")
		return false
	end

	-- Register
	STK_Constants.BAGS[fullType] = sandboxKey
	log.debug("Registered: " .. fullType .. " (category: " .. category .. " → " .. sandboxKey .. ")")
	return true
end

--- Returns true if the given full type is registered for STK upgrades.
---
--- @param fullType string
--- @return boolean
function STK_API.isRegistered(fullType)
	return STK_Constants.BAGS[fullType] ~= nil
end

--- Returns the human-readable category name for a registered bag, or nil
--- if the full type is not registered.
---
--- The returned string matches the `category` accepted by `registerBag`,
--- not the internal sandboxKey.
---
--- @param fullType string
--- @return string|nil
function STK_API.getCategory(fullType)
	local sandboxKey = STK_Constants.BAGS[fullType]
	if not sandboxKey then
		return nil
	end
	-- Reverse lookup — CATEGORY_MAP is small (8 entries), cost is negligible.
	for category, key in pairs(CATEGORY_MAP) do
		if key == sandboxKey then
			return category
		end
	end
	-- sandboxKey exists in BAGS but has no corresponding category entry —
	-- should be impossible in a well-maintained codebase, but log if it happens.
	log.warn(
		"getCategory: sandboxKey '"
			.. sandboxKey
			.. "' for '"
			.. fullType
			.. "' has no matching category in CATEGORY_MAP"
	)
	return nil
end

-- ----------------------------------------------------------------------------

log.info("Modulo carregado.")

return STK_API
