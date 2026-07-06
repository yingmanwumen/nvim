-- Preload settings before loading the package manager and other plugins
require("opt").setup()

-- load the package manager lazy.nvim
require("lazy_nvim").setup()

local function get_system_theme()
  local platform = vim.loop.os_uname().sysname

  if platform == "Linux" then
    local handle = io.popen("gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null")
    if handle then
      local result = handle:read("*a"):gsub("%s+", ""):gsub("'", "")
      handle:close()
      if result:match("light") then
        return "light"
      end
      if result:match("dark") then
        return "dark"
      end
    end

    handle = io.popen("gsettings get org.gnome.desktop.interface gtk-theme 2>/dev/null")
    if handle then
      local result = handle:read("*a"):lower()
      handle:close()
      if result:match("light") then
        return "light"
      end
    end
  elseif platform == "Darwin" then
    -- macOS
    local handle = io.popen("defaults read -g AppleInterfaceStyle 2>/dev/null")
    if handle then
      local result = handle:read("*a")
      handle:close()
      if result:match("Dark") then
        return "dark"
      end
    end
    return "light"
  elseif platform == "Windows_NT" then
    local handle = io.popen(
      'reg query "HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize" /v AppsUseLightTheme 2>nul'
    )
    if handle then
      local result = handle:read("*a")
      handle:close()
      if result:match("0x0") then
        return "dark"
      end
      if result:match("0x1") then
        return "light"
      end
    end
  end

  return "dark"
end

local function apply_system_theme()
  local theme = get_system_theme()
  if theme == vim.o.background and vim.g.system_theme_applied then
    return
  end
  if theme ~= "dark" and theme ~= "light" then
    theme = "dark"
  end
  vim.o.background = theme

  if vim.uv.os_uname().sysname == "Darwin" then
    if vim.o.background == "dark" then
      vim.cmd("colorscheme nightfox")
    else
      vim.cmd("colorscheme github_light")
    end
  else
    if vim.o.background == "dark" then
      vim.cmd("colorscheme tokyonight")
    else
      vim.cmd("colorscheme github_light")
    end
  end
  vim.g.system_theme_applied = true
end

if vim.loop.os_uname().sysname == "Linux" then
  local timer = vim.loop.new_timer()
  timer:start(
    5000,
    5000,
    vim.schedule_wrap(function()
      apply_system_theme()
    end)
  )
end

apply_system_theme()
