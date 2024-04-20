local M = {}

local function load_module(module_name)
	local ok, module = pcall(require, module_name)
	assert(ok, string.format("dap-ruby dependency error: %s not installed", module_name))
	return module
end

local function setup_ruby_adapter(dap)
	dap.adapters.ruby = function(callback, config)
		local handle
		local pid_or_err
		local waiting = config.waiting or 500

		vim.env.RUBY_DEBUG_OPEN = true
		vim.env.RUBY_DEBUG_HOST = config.server
		vim.env.RUBY_DEBUG_PORT = config.port

		local opts = { args = config.args }

		handle, pid_or_err = vim.loop.spawn(config.command, opts, function(code)
			handle:close()
			if code ~= 0 then
				assert(handle, "rdbg exited with code: " .. tostring(code))
				print("rdbg exited with code", code)
			end
		end)

		assert(handle, "Error running rgdb: " .. tostring(pid_or_err))

		-- Wait for rdbg to start
		vim.defer_fn(function()
			callback({ type = "server", host = config.server, port = config.port })
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
			port = 38698,
			server = "127.0.0.1",
			options = {
				source_filetype = "ruby",
			},
			localfs = true,
			waiting = 1000,
		},
		-- {
		-- 	type = "ruby",
		-- 	name = "debug current file",
		-- 	bundle = "",
		-- 	request = "attach",
		-- 	command = "ruby",
		-- 	script = "${file}",
		-- 	port = 38698,
		-- 	server = "127.0.0.1",
		-- 	options = {
		-- 		source_filetype = "ruby",
		-- 	},
		-- 	localfs = true,
		-- 	waiting = 1000,
		-- },
		-- {
		-- 	type = "ruby",
		-- 	name = "run rspec current_file",
		-- 	bundle = "bundle",
		-- 	request = "attach",
		-- 	command = "rspec",
		-- 	script = "${file}",
		-- 	port = 38698,
		-- 	server = "127.0.0.1",
		-- 	options = {
		-- 		source_filetype = "ruby",
		-- 	},
		-- 	localfs = true,
		-- 	waiting = 1000,
		-- },
		-- {
		-- 	type = "ruby",
		-- 	name = "run rspec current_file:current_line",
		-- 	bundle = "bundle",
		-- 	request = "attach",
		-- 	command = "rspec",
		-- 	script = "${file}",
		-- 	port = 38698,
		-- 	server = "127.0.0.1",
		-- 	options = {
		-- 		source_filetype = "ruby",
		-- 	},
		-- 	localfs = true,
		-- 	waiting = 1000,
		-- 	current_line = true,
		-- },
		{
			type = "ruby",
			name = "run rspec",
			request = "attach",
			command = "bundle",
			args = { "exec", "rspec" },
			port = 38698,
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
