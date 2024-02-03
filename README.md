# nvim-dap-ruby

An extension for [nvim-dap](https://github.com/mfussenegger/nvim-dap) providing configurations for launching [debug.rb](https://github.com/ruby/debug).

## :zap: Requirements

- Neovim
- [nvim-dap](https://github.com/mfussenegger/nvim-dap)
- [debug.rb](https://github.com/ruby/debug)
- [RSpec](https://github.com/rspec/rspec-metagem) (required if you `2: run current spec file` or `3: run rspec`)

## :package: Installation

Lazy.nvim:

```lua
{
  "mfussenegger/nvim-dap",
  dependencies = {
    "suketa/nvim-dap-ruby"
  },
  config = function()
    require("dap-ruby").setup()
  end
}
```

Vim-plug:

```
Plug 'mfussenegger/nvim-dap'
Plug 'suketa/nvim-dap-ruby'
```

## :rocket: Usage

### Registering the plugin

If you're not using Lazy.nvim, you'll need to call the setup function to register and setup the adapter:

```lua
lua require('dap-ruby').setup()
```

### Debugging

Call `:lua require('dap').continue()` to start debugging.

## :sparkles: Features

### Implemented

- [x] Start debugger with current opened file.
- [x] RSpec
  - [x] Start debugger with current opened spec file (`bundle exec rspec /path/to/file_spec.rb`)
  - [x] Start debugger with `bundle exec rspec ./spec`
- [x] Rails integration

### Not Supported Yet

- [ ] Rake test
- [ ] Connect running rdbg

## :clap: Acknowledgement

Thanks to [nvim-dap-go](https://github.com/leoluz/nvim-dap-go) for the inspiration.
