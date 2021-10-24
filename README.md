# nvim-dap-ruby

An extension for [nvim-dap](https://github.com/mfussenegger/nvim-dap) providing configurations for launching [debug.rb](https://github.com/ruby/debug).

## Pre-reqs

- Neovim
- [nvim-dap](https://github.com/mfussenegger/nvim-dap)
- [debug.rb](https://github.com/ruby/debug)

## Installation

```
Plug 'nvim-dap'
Plug 'nvim-dap-ruby'
```

## Usage

### Register the plugin

Call the setup function in your init.vim to register the ruby adapter and the configurations to debug ruby:

```lua
lua require('dap-ruby').setup()
```

### Use nvim-dap as usual

Call `:lua require('dap').continue()` to start debugging.

## Features

- [x] start debugger with current opened file.

## Not Supported Yet

- [ ] rake test
- [ ] rspec
- [ ] rails

## Acknowledgement

Thanks to [nvim-dap-go](https://github.com/leoluz/nvim-dap-go) for the inspiration.
