-- local adapter = "gemini_2_5_flash"
local adapter = "gpt_4_1" -- This is free :)
-- if vim.uv.os_uname().sysname == "Darwin" then
--   -- adapter = "insnap_gemini_2_5_flash"
--   adapter = "gemini_2_5_flash"
-- else
--   adapter = "gemini_2_5_flash"
-- end

return {
  "olimorris/codecompanion.nvim",
  cmd = {
    "CodeCompanionChat",
    "CodeCompanion",
    "CodeCompanionCmd",
    "CodeCompanionActions",
  },
  -- version = "v12.15.0",
  event = "VeryLazy",
  keys = {
    {
      "<leader>cc",
      function()
        require("codecompanion").toggle()
      end,
      desc = "Code Companion",
      silent = true,
    },
    {
      "<leader>cc",
      ":'<,'>CodeCompanionChat Add<cr>",
      desc = "Code Companion Add",
      silent = true,
      mode = "x",
      noremap = true,
    },
    {
      "<C-?>",
      function()
        require("codecompanion").toggle()
      end,
      desc = "Code Companion",
      silent = true,
    },
    {
      "<C-?>",
      ":'<,'>CodeCompanionChat Add<cr>",
      desc = "Code Companion Add",
      silent = true,
      mode = "x",
      noremap = true,
    },
    {
      "<leader>ce",
      ":CodeCompanion<cr>",
      desc = "Code Companion",
      silent = true,
      mode = "n",
      noremap = true,
    },
    {
      "<leader>ce",
      ":'<,'>CodeCompanion<cr>",
      desc = "Code Companion",
      silent = true,
      mode = "x",
      noremap = true,
    },
    {
      "<C-CR>",
      ":CodeCompanion<cr>",
      desc = "Code Companion",
      silent = true,
      mode = "n",
      noremap = true,
    },
    {
      "<C-CR>",
      ":'<,'>CodeCompanion<cr>",
      desc = "Code Companion",
      silent = true,
      mode = "x",
      noremap = true,
    },
    {
      "<leader>ca",
      ":'<,'>CodeCompanionActions<cr>",
      desc = "Code Companion Actions",
      silent = true,
      mode = "x",
      noremap = true,
    },
    {
      "<leader>ca",
      ":CodeCompanionActions<cr>",
      desc = "Code Companion Actions",
      silent = true,
      mode = "n",
      noremap = true,
    },
  },
  dependencies = {
    "ravitemer/codecompanion-history.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "ravitemer/mcphub.nvim",
    "j-hui/fidget.nvim",
    "echasnovski/mini.diff",
  },
  init = function()
    require("plugins.ai.codecompanion.fidget-spinner"):init()
  end,
  config = function()
    local codecompanion = require("codecompanion")
    -- Set up function to sync mini.diff highlights with current colorscheme
    local function sync_diff_highlights()
      -- Link the MiniDiff's custom highlights to the default diff highlights
      -- Set highlight color for added lines to match the default DiffAdd highlight
      vim.api.nvim_set_hl(0, "MiniDiffOverAdd", { link = "DiffAdd" })
      -- Set highlight color for deleted lines to match the default DiffDelete highlight
      vim.api.nvim_set_hl(0, "MiniDiffOverDelete", { link = "DiffDelete" })
      -- Set highlight color for changed lines to match the default DiffChange highlight
      vim.api.nvim_set_hl(0, "MiniDiffOverChange", { link = "DiffChange" })
      -- Set highlight color for context lines to match the default DiffText highlight
      vim.api.nvim_set_hl(0, "MiniDiffOverContext", { link = "DiffText" })
    end

    -- Initial highlight setup
    sync_diff_highlights()

    -- Update highlights when colorscheme changes
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = sync_diff_highlights,
      group = vim.api.nvim_create_augroup("CodeCompanionDiffHighlights", {}),
    })

    require("codecompanion").setup({
      -- rules = {
      memory = {
        claude = {
          parser = "claude",
          description = "Rule files for claude",
          files = {
            "~/.claude/CLAUDE.md",
            "CLAUDE.md",
          },
        },
        opts = {
          chat = {
            enabled = true,
          },
        },
      },
      extensions = {
        mcphub = {
          callback = "mcphub.extensions.codecompanion",
          opts = {
            show_result_in_chat = true, -- Show the mcp tool result in the chat buffer
            make_vars = true, -- make chat #variables from MCP server resources
            make_slash_commands = true, -- make /slash_commands from MCP server prompts
          },
        },
        history = {
          enabled = true,
          opts = {
            -- Keymap to open history from chat buffer (default: gh)
            keymap = "gh",
            -- Keymap to save the current chat manually (when auto_save is disabled)
            save_chat_keymap = "sc",
            -- Save all chats by default (disable to save only manually using 'sc')
            auto_save = true,
            -- Number of days after which chats are automatically deleted (0 to disable)
            expiration_days = 3,
            -- Picker interface (auto resolved to a valid picker)
            picker = "telescope", --- ("telescope", "snacks", "fzf-lua", or "default")
            ---Optional filter function to control which chats are shown when browsing
            chat_filter = nil, -- function(chat_data) return boolean end
            -- Customize picker keymaps (optional)
            picker_keymaps = {
              rename = { n = "r", i = "<M-r>" },
              delete = { n = "d", i = "<M-d>" },
              duplicate = { n = "<C-y>", i = "<C-y>" },
            },
            ---Automatically generate titles for new chats
            auto_generate_title = true,
            title_generation_opts = {
              ---Adapter for generating titles (defaults to current chat adapter)
              adapter = nil, -- "copilot"
              ---Model for generating titles (defaults to current chat model)
              model = nil, -- "gpt-4o"
              ---Number of user prompts after which to refresh the title (0 to disable)
              refresh_every_n_prompts = 0, -- e.g., 3 to refresh after every 3rd user prompt
              ---Maximum number of times to refresh the title (default: 3)
              max_refreshes = 3,
              format_title = function(original_title)
                -- this can be a custom function that applies some custom
                -- formatting to the title.
                return original_title
              end,
            },
            ---On exiting and entering neovim, loads the last chat on opening chat
            continue_last_chat = false,
            ---When chat is cleared with `gx` delete the chat from history
            delete_on_clearing_chat = false,
            ---Directory path to save the chats
            dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
            ---Enable detailed logging for history extension
            enable_logging = false,

            -- Summary system
            summary = {
              -- Keymap to generate summary for current chat (default: "gcs")
              create_summary_keymap = "gcs",
              -- Keymap to browse summaries (default: "gbs")
              browse_summaries_keymap = "gbs",

              generation_opts = {
                adapter = nil, -- defaults to current chat adapter
                model = nil, -- defaults to current chat model
                context_size = 90000, -- max tokens that the model supports
                include_references = true, -- include slash command content
                include_tool_outputs = true, -- include tool execution results
                system_prompt = nil, -- custom system prompt (string or function)
                format_summary = nil, -- custom function to format generated summary e.g to remove <think/> tags from summary
              },
            },
          },
        },
      },
      adapters = {
        http = {
          gemini_2_5_flash = function()
            return require("codecompanion.adapters.http").extend("gemini", {
              schema = {
                model = {
                  default = "gemini-2.5-flash",
                },
                temperature = {
                  default = 0.5,
                },
              },
              handlers = {
                form_messages = function(self, messages)
                  local gemini = require("codecompanion.adapters.http.gemini")
                  local raw_messages = gemini.handlers.form_messages(self, messages)

                  -- Collect and merge system messages
                  local system_content = {}
                  local other_messages = {}

                  for _, msg in ipairs(raw_messages.messages) do
                    if msg.role == "system" then
                      table.insert(system_content, msg.content)
                    else
                      table.insert(other_messages, msg)
                    end
                  end

                  -- If we found system messages, merge them and prepend
                  if #system_content > 0 then
                    local merged_system_message = {
                      role = "system",
                      content = table.concat(system_content, "\n\n"),
                    }
                    table.insert(other_messages, 1, merged_system_message)
                  end

                  raw_messages.messages = other_messages
                  return raw_messages
                end,
              },
            })
          end,
          gemini_2_5_pro = function()
            return require("codecompanion.adapters.http").extend("gemini", {
              schema = {
                model = {
                  default = "gemini-2.5-pro",
                },
                temperature = {
                  default = 0.5,
                },
              },
              handlers = {
                form_messages = function(self, messages)
                  local gemini = require("codecompanion.adapters.http.gemini")
                  local raw_messages = gemini.handlers.form_messages(self, messages)

                  -- Collect and merge system messages
                  local system_content = {}
                  local other_messages = {}

                  for _, msg in ipairs(raw_messages.messages) do
                    if msg.role == "system" then
                      table.insert(system_content, msg.content)
                    else
                      table.insert(other_messages, msg)
                    end
                  end

                  -- If we found system messages, merge them and prepend
                  if #system_content > 0 then
                    local merged_system_message = {
                      role = "system",
                      content = table.concat(system_content, "\n\n"),
                    }
                    table.insert(other_messages, 1, merged_system_message)
                  end

                  raw_messages.messages = other_messages
                  return raw_messages
                end,
              },
            })
          end,
          local_ollama = function()
            return require("codecompanion.adapters.http").extend("ollama", {
              env = {
                url = "http://localhost:11434",
              },
              schema = {
                model = {
                  default = "deepseek-r1:1.5b",
                },
              },
            })
          end,
          deepseek = function()
            return require("codecompanion.adapters.http").extend("deepseek", {
              env = {
                api_key = os.getenv("DEEPSEEK_API_KEY"),
              },
              schema = {
                model = {
                  -- default = "deepseek-chat",
                  default = "deepseek-reasoner",
                },
                temperature = {
                  default = 0.5,
                },
              },
            })
          end,
          insnap_gemini_2_5_flash = function()
            return require("codecompanion.adapters.http").extend("openai_compatible", {
              name = "insnap_gemini_2_5_flash",
              formatted_name = "Gemini 2.5 Flash",
              url = "https://147ai.com/v1/chat/completions",
              env = {
                api_key = os.getenv("INSNAP_API_KEY"),
              },
              schema = {
                temperature = {
                  default = 0.3,
                },
                model = {
                  default = "gemini-2.5-flash",
                  choices = {
                    ["gemini-2.5-flash"] = {
                      opts = {
                        can_reason = false,
                      },
                    },
                  },
                },
                num_ctx = {
                  default = 1000000,
                },
              },
            })
          end,
          openrouter = function()
            return require("codecompanion.adapters.http").extend("openai_compatible", {
              name = "openrouter",
              formatted_name = "OpenRouter",
              url = "https://openrouter.ai/api/v1/chat/completions",
              env = {
                api_key = os.getenv("OPENROUTER_API_KEY"),
              },
              schema = {
                temperature = {
                  default = 0.5,
                },
                model = {
                  default = "deepseek/deepseek-r1:free",
                  choices = {
                    ["deepseek/deepseek-r1:free"] = { opts = { can_reason = true } }, -- context: 164K
                    ["google/gemini-2.0-flash-exp:free"] = { opts = { can_reason = true } }, -- context: 1.05M
                    ["google/gemini-2.0-pro-exp-02-05:free"] = { opts = { can_reason = true } }, -- context: 2M
                    ["google/gemini-2.0-flash-thinking-exp-1219:free"] = {
                      opts = { can_reason = true },
                    }, -- context: 40K
                    -- Notice: the following models are not for free! Use them with caution.
                    ["anthropic/claude-3.7-sonnet"] = { opts = { can_reason = true } }, -- context: 200K
                  },
                },
                num_ctx = {
                  default = 200000,
                },
              },
            })
          end,
          claude_3_5 = function()
            return require("codecompanion.adapters.http").extend("copilot", {
              schema = {
                temperature = {
                  default = 0.5,
                },
                model = {
                  default = "claude-3.5-sonnet",
                },
              },
            })
          end,
          claude_4 = function()
            return require("codecompanion.adapters.http").extend("copilot", {
              schema = {
                temperature = {
                  default = 0.5,
                },
                model = {
                  default = "claude-sonnet-4",
                },
              },
            })
          end,
          gpt_4_1 = function()
            return require("codecompanion.adapters.http").extend("copilot", {
              schema = {
                temperature = {
                  default = 0.5,
                },
                model = {
                  default = "gpt-4.1",
                },
              },
            })
          end,
        },
      },
      opts = {
        system_prompt = require("plugins.ai.codecompanion.system_prompt"),
      },
      strategies = {
        chat = {
          adapter = adapter,
          roles = {
            ---@type string|fun(adapter: CodeCompanion.Adapter): string
            llm = function(llm)
              return llm.formatted_name .. "(" .. llm.schema.model.default .. ")"
            end,
          },
          slash_commands = require("plugins.ai.codecompanion.slash_commands"),
          variables = {},
          keymaps = require("plugins.ai.codecompanion.keymaps"),
          tools = require("plugins.ai.codecompanion.tools"),
        },
        inline = { adapter = adapter },
        agent = { adapter = adapter },
      },
      display = {
        chat = {
          icons = {
            pinned_buffer = "📌 ",
            watched_buffer = "👀 ",
          },
          -- show_settings = true,
          window = {
            position = "right",
          },
        },
        diff = {
          enabled = false,
          close_chat_at = 1,
          provider = "mini_diff",
          opts = { "internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120" },
        },
      },
    })

    local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})

    vim.api.nvim_create_autocmd({ "User" }, {
      pattern = "CodeCompanionChatOpened",
      group = group,
      callback = function()
        vim.wo.number = false
        vim.wo.relativenumber = false
      end,
    })

    local function compact_reference(messages)
      local refs = {}
      local result = {}

      -- First loop to find last occurrence of each reference
      for i, msg in ipairs(messages) do
        if msg.opts and msg.opts.reference then
          refs[msg.opts.reference] = i
        end
      end

      -- Second loop to keep messages with unique references
      for i, msg in ipairs(messages) do
        local ref = msg.opts and msg.opts.reference
        if not ref or refs[ref] == i then
          table.insert(result, msg)
        end
      end

      return result
    end
    vim.api.nvim_create_autocmd({ "User" }, {
      pattern = "CodeCompanionRequestFinished",
      group = group,
      callback = function(request)
        if request.data.strategy ~= "chat" then
          return
        end
        local current_chat = codecompanion.last_chat()
        if not current_chat then
          return
        end
        current_chat.messages = compact_reference(current_chat.messages)
      end,
    })
  end,
}
