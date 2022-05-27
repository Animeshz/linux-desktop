local M = {}

local uv = vim.loop
local fn = vim.fn
local api = vim.api

function password()
   fn.inputsave()
   local user = fn.expand("$USER")
   local pw = fn.inputsecret(string.format("password for %s: ", user))
   fn.inputrestore()
   return pw
end

function test(pw, k)
   local stdin = uv.new_pipe()
   uv.spawn("sudo", {
      args = {"-S", "-k", "true"},
      stdio = {stdin, nil, nil}
   }, k)

   stdin:write(pw)
   stdin:write("\n")
   stdin:shutdown()
end

function dir(str,sep) -- https://stackoverflow.com/a/9102300/11377112
   sep=sep or'/'
   return str:match("(.*"..sep..")")
end

function write(pw, buf, lines, k)
   local stdin = uv.new_pipe()
   uv.spawn("sudo", {
      -- args = {"-S", "-k", "tee", buf},
      args = {"-S", "-k", "sh", "-c", "mkdir -p " .. dir(buf) .. " && tee " .. buf},
      stdio = {stdin, nil, nil}
   }, k)

   local ok, posix = pcall(require, 'posix.unistd')
   if not ok then
      error("Error loading lua-posix\n\n" .. posix)
   end

   if posix.geteuid() ~= 0 then
      stdin:write(pw)
      stdin:write("\n")
   end
   local last = table.remove(lines)
   for _, line in ipairs(lines) do
      stdin:write(line)
      stdin:write("\n")
   end
   stdin:write(last)
   stdin:shutdown()
end

function M.sudowrite()
   local pw = password()
   local buf = api.nvim_buf_get_name(0)
   local bufnr = api.nvim_get_current_buf()
   local lines = api.nvim_buf_get_lines(bufnr, 0, -1, false)

   local function exitWrite(code, _)
      if code == 0 then
         vim.schedule(function()
            api.nvim_echo({{string.format('"%s" written', buf), "Normal"}}, true, {})
            api.nvim_buf_set_option(0, "modified", false)
         end)
      end
   end
   local function exitTest(code, _)
      if code == 0 then
         write(pw, buf, lines, exitWrite)
      else
         vim.schedule(function()
            api.nvim_echo({{"incorrect password", "ErrorMsg"}}, true, {})
         end)
      end
   end
   test(pw, exitTest)
end

return M
