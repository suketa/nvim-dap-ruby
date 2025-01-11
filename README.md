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

### Ruby on Rails

Ensure that the debug gem is included in your project.

```sh
bundle add debug
```

Then run rails with debugging turned on. For example, this can be done with environment variables.

```sh
RUBY_DEBUG_OPEN=true RUBY_DEBUG_HOST=127.0.0.1 RUBY_DEBUG_PORT=38698 bin/rails server
RUBY_DEBUG_OPEN=true RUBY_DEBUG_HOST=127.0.0.1 RUBY_DEBUG_PORT=38698 bin/dev # If using esbuild
```

- You need to see `DEBUGGER: Debugger can attach via TCP/IP (127.0.0.1:38698)` somewhere in the console output.
- Open nvim in your project's directory, and open a ruby file into a buffer.
- Start the debugger e.g. `:DapContinue` and select the option to `attach existing (port 38698)`.
- Now set breakpoints and make the app hit one of those by navigating to the page that you are working on in a web browser.

#### Extra options for Rails

Now that you have confirmed the above works, you can also start your rails server and run the debugger directly from nvim.

Start the debugger with one of the following configurations: `run rails` for `bin/rails s` or `bin/dev` for `bin/dev`.
It will automatically set the debugger environment variables, run the command, and attach to the session.

## :sparkles: Features

### Implemented

- [x] Start debugger with current opened file.
- [x] RSpec
  - [x] Start debugger with current opened spec file (`bundle exec rspec /path/to/file_spec.rb`)
  - [x] Start debugger with `bundle exec rspec ./spec`
- [x] Rails integration
- [x] Connect running rdbg

### Not Supported Yet

- [ ] Rake test

## :clap: Acknowledgement

Thanks to [nvim-dap-go](https://github.com/leoluz/nvim-dap-go) for the inspiration.
