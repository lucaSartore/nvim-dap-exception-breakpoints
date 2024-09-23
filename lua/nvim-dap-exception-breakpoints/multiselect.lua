local find = require("nvim-dap-exception-breakpoints.util").find

local function multiselect(options, selected, callback)
    local contents = {}
    local state = {}

    for i, option in ipairs(options) do
        local is_selected = find(option, selected, function (a,b) return a.label == b.label end)
        state[i] = is_selected
        contents[i] = (is_selected and "[x] " or "[ ] ") .. option.label
    end

    local bufnr = vim.api.nvim_create_buf(false, true)
    local width = 30
    local height = #contents
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    local opts = {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded"
    }

    local winnr = vim.api.nvim_open_win(bufnr, true, opts)
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, contents)

    vim.api.nvim_buf_set_keymap(bufnr, "n", "j", "<cmd>normal! j<CR>", {noremap = true, silent = true})
    vim.api.nvim_buf_set_keymap(bufnr, "n", "k", "<cmd>normal! k<CR>", {noremap = true, silent = true})
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>", [[<cmd>lua ToggleOption()<CR>]], {noremap = true, silent = true})
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<cr>", [[<cmd>lua CloseAndReturn()<CR>]], {noremap = true, silent = true})

    _G.ToggleOption = function()
        local line = vim.api.nvim_win_get_cursor(winnr)[1]
        state[line] = not state[line]
        local new_line = (state[line] and "[x] " or "[ ] ") .. options[line].label
        vim.api.nvim_buf_set_lines(bufnr, line - 1, line, false, {new_line})
    end

    _G.CloseAndReturn = function()
        local result = {}
        for i, is_selected in ipairs(state) do
            if is_selected then
                table.insert(result, options[i])
            end
        end
        vim.api.nvim_win_close(winnr, true)
        vim.api.nvim_buf_delete(bufnr, {force = true})
        callback(result)
    end
end

return multiselect
