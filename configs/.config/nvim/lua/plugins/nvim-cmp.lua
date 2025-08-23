-- https://github.com/hrsh7th/nvim-cmp?tab=readme-ov-file#recommended-configuration
return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		-- https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#install
		{
			"L3MON4D3/LuaSnip",
			config = function()
				-- https://github.com/rafamadriz/friendly-snippets?tab=readme-ov-file#with-lazynvim
				require("luasnip.loaders.from_vscode").lazy_load()
			end,
			dependencies = { "rafamadriz/friendly-snippets" },
		},
		-- https://github.com/saadparwaiz1/cmp_luasnip?tab=readme-ov-file#cmp_luasnip
		"saadparwaiz1/cmp_luasnip",
		-- https://github.com/petertriho/cmp-git?tab=readme-ov-file#installation
		"petertriho/cmp-git",
		-- https://github.com/onsails/lspkind.nvim?tab=readme-ov-file#option-2-nvim-cmp
		"onsails/lspkind.nvim",
	},
	config = function()
		local cmp = require("cmp")
		local lspkind = require("lspkind")
		local luasnip = require("luasnip")

		cmp.setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-e>"] = cmp.mapping.abort(),
				["<CR>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						if luasnip.expandable() then
							luasnip.expand()
						else
							cmp.confirm({
								select = true,
							})
						end
					else
						fallback()
					end
				end),
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.locally_jumpable(1) then
						luasnip.jump(1)
					else
						fallback()
					end
				end, { "i", "s" }),
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.locally_jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
			}, {
				{ name = "buffer" },
			}),
			-- https://github.com/onsails/lspkind.nvim?tab=readme-ov-file#option-2-nvim-cmp
			formatting = {
				format = lspkind.cmp_format({
					mode = "symbol_text",
					maxwidth = {
						menu = 50,
						abbr = 50,
					},
					ellipsis_char = "...",
				}),
			},
		})

		cmp.setup.filetype("gitcommit", {
			sources = cmp.config.sources({
				{ name = "git" },
			}, {
				{ name = "buffer" },
			}),
		})

		require("cmp_git").setup()

		cmp.setup.cmdline({ "/", "?" }, {
			mapping = cmp.mapping.preset.cmdline(),
			sources = {
				{ name = "buffer" },
			},
		})

		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = "path" },
			}, {
				{ name = "cmdline" },
			}, {
				{ name = "render-markdown" },
			}),
			matching = { disallow_symbol_nonprefix_matching = false },
		})

		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- https://github.com/neovim/nvim-lspconfig/tree/master/lua/lspconfig/configs
		local servers = {
			"bashls",
			"docker_compose_language_service",
			"dockerls",
			"html",
			"intelephense",
			"jsonls",
			"lua_ls",
			"pylsp",
			"tailwindcss",
		}

		local lspconfig = require("lspconfig")

		for _, server in ipairs(servers) do
			lspconfig[server].setup({
				capabilities = capabilities,
			})
		end

		lspconfig.ts_ls.setup({
			capabilities = capabilities,
			filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
			init_options = {
				plugins = {
					{
						name = "@vue/typescript-plugin",
						location = vim.fn.stdpath("data")
							.. "/mason/packages/vue-language-server/node_modules/@vue/language-server/node_modules/@vue/typescript-plugin",
						languages = { "vue" },
					},
				},
			},
		})

		lspconfig.volar.setup({
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
	end,
}
