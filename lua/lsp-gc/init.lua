local M = {}

M.config = {
    -- stop all lsps after nvim lost focus for more than `ms`
    stop_after_ms = 1000 * 60 * 15,
    -- exclude these lsps
    exclude = { "null-ls" },
}

local stopped_lsps = {}

function M.stop_lsps()
    stopped_lsps = {}

    local clients = vim.iter(vim.lsp.get_clients())
        :filter(function(c)
            return not vim.list_contains(M.config.exclude, c.name)
        end)
        :totable()

    for _, v in ipairs(clients) do
        table.insert(stopped_lsps, v.name)
        vim.cmd.LspStop(v.name)
    end
end

function M.start_stopped_lsps()
    for _, v in ipairs(stopped_lsps) do
        vim.cmd.LspStart(v)
    end
end

function M.setup(opts)
    opts = opts or {}
    M.config = vim.tbl_deep_extend("force", M.config, opts)

    local timer = vim.uv.new_timer()

    vim.api.nvim_create_autocmd("FocusLost", {
        callback = function()
            timer:start(M.config.stop_after_ms, 0, vim.schedule_wrap(M.stop_lsps))
        end,
    })
    vim.api.nvim_create_autocmd("FocusGained", {
        callback = vim.schedule_wrap(function()
            timer:stop()
            M.start_stopped_lsps()
        end),
    })
end

return M
