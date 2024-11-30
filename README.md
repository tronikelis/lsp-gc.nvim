# lsp-gc.nvim

A super simple and small plugin to stop lsp in inactive nvim instances

If you're like me and have 20 neovim's opened at the same time, lsp can start to really
take up your computer's resources


## Install

With lazy

```lua
{
    "tronikelis/lsp-gc.nvim"
    dependencies = { "neovim/nvim-lspconfig" },
    opts = {},
}
```

## Config

```lua
{
    -- stop all lsps after nvim lost focus for more than `ms`
    stop_after_ms = 1000 * 60 * 15,
    -- exclude these lsps
    exclude = { "null-ls" },
}
```
