local dap = require("dap")
local find = require("nvim-dap-exception-breakpoints.util").find
local map = require("nvim-dap-exception-breakpoints.util").map
local all = require("nvim-dap-exception-breakpoints.util").all
local options_equal = require("nvim-dap-exception-breakpoints.util").options_equal
local multiselect = require("nvim-dap-exception-breakpoints.multiselect")

---@class dap.ExceptionBreakpointsFilter
---@field filter string
---@field label string
---@field description string|nil
---@field default boolean|nil
---@field supportsCondition boolean|nil
---@field conditionDescription string|nil

---@type dap.ExceptionBreakpointsFilter[] | nil
local available_options = nil

---@type dap.ExceptionBreakpointsFilter[] | nil
local selected_options = nil

-- send the request to the dap to enable/disable exception breakpoints based on user selection
local function set_exception_breakpoints()
    if selected_options == nil then return end
    local filters = map(function (x) return x.filter end, selected_options)
    dap.set_exception_breakpoints(filters)
end

-- send request every time the debugger is launched
dap.listeners.after['launch']['exception_breakpoints'] = function(_, _)
    set_exception_breakpoints()
end


-- the list of supported exception breakpoints become available when the dap is initialized
-- therefore i read it and i set my global variables
dap.listeners.after["initialize"]["exception_breakpoints"] = function(session, _)
	local breakpoints_options = session.capabilities.exceptionBreakpointFilters

	-- the options hasn't change since last initialization, therefore there is no need to update them
	if options_equal(breakpoints_options, available_options) then
		return
	end

	available_options = breakpoints_options

    selected_options = {}
    for _, v in ipairs(available_options) do
        if v.default == true then
            table.insert(selected_options,v)
        end
    end

end

local function edit_exception_breakpoints()

    if available_options == nil then
        vim.print("You need to connect the debugger at least once before been able to visualize the available exception breakpoints options")
        return
    end

    -- when the pop-up is closed i need to update the 
    local callback = function (options)
        selected_options = options

        -- if the dap is already connected i need to set the breakpoints right away, as the 'launch' event has already happened and won't trigger an update
        local is_dap_connected = dap.session() ~= nil
        if is_dap_connected then
            set_exception_breakpoints()
        end
    end

    multiselect(available_options,selected_options, callback)
end

return edit_exception_breakpoints()
