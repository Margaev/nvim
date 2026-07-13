-- See `:help vim.lsp.start` for an overview of the supported `config` options.
local jdtls = require 'jdtls'

local root_dir = vim.fs.root(0, { 'pom.xml', 'gradlew', '.git', 'mvnw' })

if root_dir == '' or not root_dir then
  return
end

local project_name = root_dir:gsub('/', '_')
local workspace_dir = vim.fn.stdpath 'data' .. '/jdtls-workspace/' .. project_name

local config = {
  name = 'jdtls',

  -- `cmd` defines the executable to launch eclipse.jdt.ls.
  -- `jdtls` must be available in $PATH and you must have Python3.9 for this to work.
  --
  -- $ brew install jdtls
  --
  -- As alternative you could also avoid the `jdtls` wrapper and launch
  -- eclipse.jdt.ls via the `java` executable
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = {
    'jdtls',
    '-data',
    workspace_dir,
  },

  -- `root_dir` must point to the root of your project.
  -- See `:help vim.fs.root`
  root_dir = root_dir,

  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = {},
  },

  -- This sets the `initializationOptions` sent to the language server
  -- If you plan on using additional eclipse.jdt.ls plugins like java-debug
  -- you'll need to set the `bundles`
  --
  -- See https://codeberg.org/mfussenegger/nvim-jdtls#java-debug-installation
  --
  -- If you don't plan on any eclipse.jdt.ls plugins you can remove this
  init_options = {
    bundles = {
      vim.fn.glob('/Users/drewysq/.local/share/nvim/mason/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar', true),
    },
  },
}

vim.schedule(function()
  jdtls.start_or_attach(config)
end)
