local M = {}

local function load_module(module_name)
	local ok, module = pcall(require, module_name)
	assert(ok, string.format("dap-ruby dependency error: %s not installed", module_name))
	return module
end

local function pick_port()
	local port
	vim.ui.input(
		{ prompt = "Select port to connect to: " },
		function(input) port = input end
	)
	return port
end

-- Command may not be in path, so travel up the directory tree to find it
local function find_cmd_dir(cmd)
	local filepath = vim.fn.getcwd()
	local og_filepath = filepath
	if vim.fn.executable(cmd) == 1 then
		return filepath
	end
	while filepath ~= "" and filepath ~= "/" do
		if vim.fn.executable(filepath .. "/" .. cmd) == 1 then
			return filepath
		end
		filepath = vim.fn.fnamemodify(filepath, ':h')
	end
	error(cmd .. " not found in " .. og_filepath .. " or any of its ancestors")
end

local function setup_ruby_adapter(dap)
	dap.adapters.ruby = function(callback, config)
		local waiting = config.waiting or 500
		local server = config.server or vim.env.RUBY_DEBUG_HOST or "127.0.0.1"
		-- Take the port from the config if the user has set this
		-- If not, pick a random ephemeral port so we (probably) wont collide with other debuggers or anything else
		-- If not, have the user pick a port
		local port = config.port
		port = port or config.random_port and math.random(49152, 65535)
		port = port or pick_port()

		vim.env.RUBY_DEBUG_OPEN = true
		vim.env.RUBY_DEBUG_HOST = server
		vim.env.RUBY_DEBUG_PORT = port

		if config.command then
			local handle
			local pid_or_err
			local args = config.args or {}
			local working_dir = find_cmd_dir(config.command)
			if config.current_line then
				table.insert(args, vim.fn.expand("%:p") .. ":" .. vim.fn.line("."))
			elseif config.current_file then
				table.insert(args, vim.fn.expand("%:p"))
			end
			local opts = { args = args, cwd = working_dir }
			handle, pid_or_err = vim.loop.spawn(config.command, opts, function(code)
				handle:close()
				if code ~= 0 then
					local full_command = config.command .. " " .. table.concat(args, " ")
					error("Command `" .. full_command .."` ran from `" .. working_dir .. "` exited with code " .. code)
				end
			end)

			assert(handle, "Error running rgdb: " .. tostring(pid_or_err))
		end

		assert(handle, "Error running rgdb: " .. tostring(pid_or_err))

		-- Wait for rdbg to start
		vim.defer_fn(function()
			callback({ type = "server", host = server, port = port })
		end, waiting)
	end
end

local function setup_ruby_configuration(dap)
	dap.configurations.ruby = {
		{
			type = "ruby",
			name = "run rails",
			request = "attach",
			command = "bundle",
			args = { "exec", "rails", "s" },
			random_port = true,
			server = "127.0.0.1",
			options = {
				source_filetype = "ruby",
			},
			localfs = true,
			waiting = 1000,
		},
		{
			type = "ruby",
			name = "debug current file",
			request = "attach",
			command = "ruby",
			current_file = true,
			random_port = true,
			server = "127.0.0.1",
			options = {
				source_filetype = "ruby",
			},
			localfs = true,
			waiting = 1000,
		},
		{
			type = "ruby",
			name = "run rspec current_file",
			request = "attach",
			command = "bundle",
			args = { "exec", "rspec" },
			current_file = true,
			random_port = true,
			server = "127.0.0.1",
			options = {
				source_filetype = "ruby",
			},
			localfs = true,
			waiting = 1000,
		},
		{
			type = "ruby",
			name = "run rspec current_file:current_line",
			request = "attach",
			command = "bundle",
			args = { "exec", "rspec" },
			current_line = true,
			random_port = true,
			server = "127.0.0.1",
			options = {
				source_filetype = "ruby",
			},
			localfs = true,
			waiting = 1000,
			current_line = true,
		},
		{
			type = "ruby",
			name = "run rspec",
			request = "attach",
			command = "bundle",
			args = { "exec", "rspec" },
			random_port = true,
			server = "127.0.0.1",
			options = {
				source_filetype = "ruby",
			},
			localfs = true,
			waiting = 1000,
		},
		{
			type = "ruby",
			name = "attach existing (port 38698)",
			request = "attach",
			port = 38698,
			server = "127.0.0.1",
			options = {
				source_filetype = "ruby",
			},
			localfs = true,
			waiting = 1000,
		},
		{
			type = "ruby",
			name = "attach existing (pick port)",
			request = "attach",
			server = "127.0.0.1",
			options = {
				source_filetype = "ruby",
			},
			localfs = true,
			waiting = 1000,
		},
		{
			type = "ruby",
			name = "run bin/dev",
			request = "attach",
			command = "bin/dev",
			random_port = true,
			server = "127.0.0.1",
			options = {
				source_filetype = "ruby",
			},
			localfs = true,
			waiting = 1000,
		},
	}
end

function M.setup()
	local dap = load_module("dap")
	setup_ruby_adapter(dap)
	setup_ruby_configuration(dap)
end

return M
