local M = {}

local function load_module(module_name)
  local ok, module = pcall(require, module_name)
  assert(ok, string.format('dap-ruby dependency error: %s not installed', module_name))
  return module
end

local function setup_ruby_adapter(dap)
  dap.adapters.ruby = function(callback, config)
    local handle
    local stdout = vim.loop.new_pipe(false)
    local pid_or_err
    local port = config.port or 38698
    local host = config.host or "127.0.0.1"

    local opts = {
      stdio = {nil, stdout},
      args = {"--open", "--port", config.port, "-c", "--", config.command, config.script},
      detached = false
    }

    handle, pid_or_err = vim.loop.spawn("rdbg", opts, function(code)
      handle:close()
      if code ~= 0 then
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
        callback({type = "server", host = host, port = port})
      end,
    500)
  end
end

local function setup_ruby_configuration(dap)
  dap.configurations.ruby = {
    {
        type = 'ruby';
        name = 'debug current file';
        request = 'launch';
        command = "ruby";
        script = "${file}";
    },
    {
        type = 'ruby';
        name = 'rake test';
        request = 'launch';
        command = "rake test";
        script = "";
    }
  }
end


function M.setup()
  local dap = load_module("dap")
  setup_ruby_adapter(dap)
  setup_ruby_configuration(dap)
end

return M
