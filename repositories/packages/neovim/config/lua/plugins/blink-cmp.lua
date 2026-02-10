-- https://cmp.saghen.dev/installation.html
return {
	"saghen/blink.cmp",
	version = "1.*",
	dependencies = {
		"rafamadriz/friendly-snippets",
		-- https://github.com/Kaiser-Yang/blink-cmp-git
		{
			"Kaiser-Yang/blink-cmp-git",
			dependencies = { "nvim-lua/plenary.nvim" },
		},
	},
	-- https://cmp.saghen.dev/configuration/reference.html
	opts = {
		keymap = {
			preset = "default",
			["<CR>"] = { "accept", "fallback" },
			["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
			["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
		},
		completion = {
			menu = {
				draw = {
					columns = { { "kind_icon" }, { "kind" }, { "label", gap = 1 } },
				},
			},
		},
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
			per_filetype = {
				gitcommit = { "git", "buffer" },
			},
			providers = {
				git = {
					module = "blink-cmp-git",
					name = "Git",
				},
			},
		},
		cmdline = {
			enabled = true,
		},
	},
	config = function(_, opts)
		require("blink.cmp").setup(opts)

		local capabilities = require("blink.cmp").get_lsp_capabilities()

		-- https://github.com/neovim/nvim-lspconfig/tree/master/lua/lspconfig/configs
		local servers = {
			"bashls",
			"cssls",
			"docker_compose_language_service",
			"dockerls",
			"eslint",
			"emmet_ls",
			"gopls",
			"html",
			"intelephense",
			"jsonls",
			"lua_ls",
			"pylsp",
			"tailwindcss",
		}

		for _, server in ipairs(servers) do
			vim.lsp.config(server, {
				capabilities = capabilities,
			})
			vim.lsp.enable(server)
		end

		-- https://github.com/yioneko/vtsls/tree/main/packages/service#neovim
		vim.lsp.config("vtsls", {
			capabilities = capabilities,
			settings = {
				vtsls = {
					tsserver = {
						globalPlugins = {
							{
								name = "@vue/typescript-plugin",
								location = vim.fn.stdpath("data")
									.. "/mason/packages/vue-language-server/node_modules/@vue/language-server/node_modules/@vue/typescript-plugin",
								languages = { "vue" },
							},
						},
					},
				},
			},
		})
		vim.lsp.enable("vtsls")

		vim.lsp.config("vue_ls", {
			capabilities = capabilities,
			settings = {
				vue = {
					inlayHints = {
						destructuredProps = { enabled = true },
						inlineHandlerLoading = { enabled = true },
						missingProps = { enabled = true },
						optionsWrapper = { enabled = true },
						vBindShorthand = { enabled = true },
					},
				},
			},
		})
		vim.lsp.enable("vue_ls")
	end,
}
