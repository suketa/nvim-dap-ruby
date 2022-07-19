local M = {}

local function load_module(module_name)
  local ok, module = pcall(require, module_name)
  assert(ok, string.format('dap-ruby dependency error: %s not installed', module_name))
  return module
end

--[[ HOW TO DEBUG
create script a.rb to debug

```
  foo = 1
  binding.break
  bar = 2
  baz = 3
  puts "finish"
```

run the following command
```
rdbg --open --port 38698 -n -- a.rb
```

run
```
nvim a.rb
:lua require'dap'.continue()
:lua require'dap'.repl.open()
```

nvim-dap log files is .cache/nvim/dap.log
nvim-dap log files is .cache/nvim/dap.log
]]

-- To DEBUG, change '--[[ DEBUG SETTING' => '-- [[ DEBUG SETTING'
--[[ DEBUG SETTING
local function setup_ruby_adapter(dap)
  dap.adapters.ruby = function(callback, config)
    callback({type = "server", host = config.server, port = config.port})
  end
end

local function setup_ruby_configuration(dap)
  dap.set_log_level('TRACE')
  dap.configurations.ruby = {
    {
       type = 'ruby';
       name = 'debug current file';
       port = 38698;
       server = '127.0.0.1';
       request = 'attach';
    }
  }
end
-- ]] -- END OF DEBUG SETTING
-- END for nvim-dap-ruby debug

-- TO DEBUG, CHANGE '-- [[ => '--[['
-- [[
local function setup_ruby_adapter(dap)
  dap.adapters.ruby = function(callback, config)
    local handle
    local stdout = vim.loop.new_pipe(false)
    local pid_or_err
    local waiting = config.waiting or 500
    local args
    local script

    if config.current_line then
      script = config.script .. ':' .. vim.fn.line(".")
    else
      script = config.script
    end

    if config.bundle == 'bundle' then
      args = {"-n", "--open", "--port", config.port, "-c", "--", "bundle", "exec", config.command, script}
    else
      args = {"--open", "--port", config.port, "-c", "--", config.command, script}
    end

    local opts = {
      stdio = {nil, stdout},
      args = args,
      detached = false
    }

    handle, pid_or_err = vim.loop.spawn("rdbg", opts, function(code)
      handle:close()
      if code ~= 0 then
        assert(handle, 'rdbg exited with code: ' .. tostring(code))
        print('rdbg exited with code', code)
      end
    end)

    assert(handle, 'Error running rgdb: ' .. tostring(pid_or_err))

    stdout:read_start(function(err, chunk)
      assert(not err, err)
      if chunk then
        vim.schedule(function()
          require('dap.repl').append(chunk)
        end)
      end
    end)

    -- Wait for rdbg to start
    vim.defer_fn(
      function()
        callback({type = "server", host = config.server, port = config.port})
      end,
    waiting)
  end
end

local function setup_ruby_configuration(dap)
  dap.configurations.ruby = {
    {
       type = 'ruby';
       name = 'debug current file';
       bundle = '';
       request = 'attach';
       command = "ruby";
       script = "${file}";
       port = 38698;
       server = '127.0.0.1';
       options = {
         source_filetype = 'ruby';
       };
       localfs = true;
       waiting = 1000;
    },
    {
       type = 'ruby';
       name = 'run rspec current_file';
       bundle = 'bundle';
       request = 'attach';
       command = "rspec";
       script = "${file}";
       port = 38698;
       server = '127.0.0.1';
       options = {
         source_filetype = 'ruby';
       };
       localfs = true;
       waiting = 1000;
    },
    {
       type = 'ruby';
       name = 'run rspec current_file:current_line';
       bundle = 'bundle';
       request = 'attach';
       command = "rspec";
       script = "${file}";
       port = 38698;
       server = '127.0.0.1';
       options = {
         source_filetype = 'ruby';
       };
       localfs = true;
       waiting = 1000;
       current_line = true;
    },
    {
       type = 'ruby';
       name = 'run rspec';
       bundle = 'bundle';
       request = 'attach';
       command = "rspec";
       script = "./spec";
       port = 38698;
       server = '127.0.0.1';
       options = {
         source_filetype = 'ruby';
       };
       localfs = true;
       waiting = 1000;
    }
  }
end
-- ]] -- DONT REMOVE THIS LINE

function M.setup()
  local dap = load_module("dap")
  setup_ruby_adapter(dap)
  setup_ruby_configuration(dap)
end

return M
