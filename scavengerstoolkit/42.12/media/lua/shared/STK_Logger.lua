--- @file scavengerstoolkit\42.12\media\lua\shared\STK_Logger.lua
--- @brief Centralized logging system for STK
---
--- Control: launch PZ with -debug flag to enable debug-level messages.
--- info, warn and error messages are always printed regardless of -debug.
---
--- Usage:
---   local log = require("STK_Logger").get("STK-Commands")
---   log.debug("rastreamento detalhado")
---   log.info("modulo carregado")
---   log.warn("algo inesperado mas recuperavel")
---   log.error("falha critica")
---   Events.OnSTKFoo.Add(log.wrap(handler, "handler"))
---
--- @author Scavenger's Toolkit Development Team
--- @version 1.0.0
--- @license MIT
--- @copyright 2026 Scavenger's Toolkit

--- @class STKLogger
local STK_Logger = {}

--- Creates a logger instance with a fixed prefix.
--- All methods share the same tag so output is consistently identifiable.
--- @param prefix string Module identifier shown in every log line
--- @return table logger
function STK_Logger.get(prefix)
	local tag = "[" .. prefix .. "] "

	return {
		--- Prints only when PZ is launched with the -debug flag.
		--- Use for detailed flow tracing, intermediate values, loop counts.
		--- @param msg any
		debug = function(msg)
			if isDebugEnabled() then
				print(tag .. tostring(msg))
			end
		end,

		--- Always prints. Use for module load confirmation and key lifecycle events.
		--- @param msg any
		info = function(msg)
			print(tag .. tostring(msg))
		end,

		--- Always prints. Use for unexpected but recoverable situations,
		--- such as validation failures that may indicate anti-cheat attempts.
		--- @param msg any
		warn = function(msg)
			print(tag .. "[WARN] " .. tostring(msg))
		end,

		--- Always prints. Use for failures and invalid states that
		--- indicate a bug or a critical runtime problem.
		--- @param msg any
		error = function(msg)
			print(tag .. "[ERROR] " .. tostring(msg))
		end,

		--- Wraps a function in pcall so exceptions are caught and logged
		--- with the listener name instead of silently killing the event.
		--- Use this whenever registering event listeners.
		--- @param fn function The listener function to protect
		--- @param name string Listener name shown in error output
		--- @return function
		wrap = function(fn, name)
			return function(...)
				local ok, err = pcall(fn, ...)
				if not ok then
					print(tag .. "[ERROR] listener '" .. tostring(name) .. "' falhou: " .. tostring(err))
				end
			end
		end,
	}
end

-- ============================================================================

return STK_Logger
