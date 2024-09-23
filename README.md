# nvim-dap-exception-breakpoints
A simple UI for ergonomically controlling the "exception breakpoints" feature of the Debug Adapter Protocol (DAP).

## Demo Video
[![Watch the demo video](https://img.youtube.com/vi/IpB_1lBLM68/0.jpg)](https://www.youtube.com/watch?v=IpB_1lBLM68)

## Installation

### Using lazy.nvim
```lua
{
    "lucaSartore/nvim-dap-exception-breakpoints",
    dependencies = { "mfussenegger/nvim-dap" },

    config = function()
        local set_exception_breakpoints = require("nvim-dap-exception-breakpoints")

        vim.api.nvim_set_keymap(
            "n",
            "<leader>dc",
            "",
            { desc = "[D]ebug [C]ondition breakpoints", callback = set_exception_breakpoints }
        )
    end
}
```

## Controls
You can open the exception breakpoints popup with a configurable keybinding (`<leader>dc` in the example above).

Once the popup is open, you can:
 - Press `<space>` to toggle a breakpoint condition.
 - Use `j` and `k` to move up and down the list.
 - Press `<cr>` (Enter) to close the popup and apply the configuration.

The plugin automatically stores your configuration and applies it each time you start a new debug session. If a session is already running, changes are applied immediately.

If the available conditions change (for example, because you're debugging a different language), previous settings are discarded and the default configuration for the new language is applied.

## Future objectives
In the future I would love to implement something similar inside nvim-dap-ui... If the maintainers are interested. But for now this works wite well.
