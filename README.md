# nvim-dap-ruby

An extension for [nvim-dap](https://github.com/mfussenegger/nvim-dap) providing configurations for launching [debug.rb](https://github.com/ruby/debug).

## Pre-reqs

- Neovim
- [nvim-dap](https://github.com/mfussenegger/nvim-dap)
- [debug.rb](https://github.com/ruby/debug)
- [rspec](https://github.com/rspec/rspec-metagem) (required if you `2: run current spec file` or `3: run rspec`)

## Installation

```
Plug 'mfussenegger/nvim-dap'
Plug 'suketa/nvim-dap-ruby'
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
- [x] rspec
  - [x] start debugger with current opened spec file (`bundle exec rspec /path/to/file_spec.rb`)
  - [x] start debugger with `bundle exec rspec ./spec`
- [x] rails

## Not Supported Yet

- [ ] rake test
- [ ] connect running rdbg

## Acknowledgement

Thanks to [nvim-dap-go](https://github.com/leoluz/nvim-dap-go) for the inspiration.
