{
  config,
  namespace,
  lib,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;
  inherit (config.${namespace}.dev.editor) nixvim;
  inherit (config.${namespace}.dev.lang) nodejs;
in
{
  options.${namespace}.dev.editor.nixvim = {
    enable = mkEnableOption "Enable nixvim editor";
    wsl = mkEnableOption "Enable nixvim editor for WSL";
  };
  config = mkIf nixvim.enable {
    ${namespace} = {
      dev.cli.fish = {
        interactiveEnvs = {
          "EDITOR" = "nvim";
        };
      };
    };
    programs.nixvim = {
      enable = true;
      withNodeJs = nodejs.enable;
      globals = {
        mapleader = " ";
        maplocalleader = "\\";
        loaded_netrw = 1;
        loaded_netrwPlugin = 1;
      };
      plugins = { };
      colorscheme = "habamax";
      colorschemes = {
      };
      extraConfigLuaPre = ''
        _M = {};
        _G.FUNCS = {}
        if vim.fn.has('wsl') == 1 then
          vim.g.clipboard = {
            name = 'WslClipboard',
            copy = {
              ["+"] = 'clip.exe',
              ["*"] = 'clip.exe',
            },
            paste = {
              ["+"] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
              ["*"] = 'powershell.exe -NoLogo -NoProfile -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))'
            },
            cache_enabled = 0,
          }
        end
      '';
      keymaps = [
        {
          action = "<cmd>xa<cr>";
          key = "<leader>q";
          mode = "n";
          options = {
            silent = true;
            nowait = true;
            desc = "󰸧 Save and close";
          };
        }
        {
          action = "<cmd>nohlsearch<cr>";
          key = "<esc>";
          mode = "n";
          options = {
            silent = true;
            nowait = true;
          };
        }
        {
          mode = "i";
          key = "jk";
          action = "<esc>";
          options = {
            silent = true;
            nowait = true;
            desc = "Escape";
          };
        }
        {
          mode = "i";
          key = "jj";
          action = "<esc>";
          options = {
            silent = true;
            nowait = true;
            desc = "Escape";
          };
        }
        {
          action = "<cmd>wincmd h<cr>";
          key = "<leader>wh";
          mode = "n";
          options = {
            silent = true;
            desc = " Move To Left";
          };
        }
        {
          action = "<cmd>wincmd j<cr>";
          key = "<leader>wj";
          mode = "n";
          options = {
            silent = true;
            desc = " Move To Down";
          };
        }
        {
          action = "<cmd>wincmd k<cr>";
          key = "<leader>wk";
          mode = "n";
          options = {
            silent = true;
            desc = " Move to Up";
          };
        }
        {
          action = "<cmd>wincmd l<cr>";
          key = "<leader>wl";
          mode = "n";
          options = {
            silent = true;
            desc = " Move To Right";
          };
        }
      ];
      opts = {
        completeopt = "menu,noinsert,noselect,popup,fuzzy";
        clipboard = "unnamedplus";
        timeout = true;
        autowrite = true;
        conceallevel = 3;
        confirm = true;
        cursorline = true;
        expandtab = true;
        formatoptions = "jcroqlnt";
        grepformat = "%f:%l:%c:%m";
        grepprg = "rg --vimgrep";
        ignorecase = true;
        inccommand = "nosplit";
        laststatus = 3;
        list = true;
        mouse = "a";
        number = true;
        pumblend = 10;
        pumheight = 10;
        relativenumber = false;
        scrolloff = 4;
        shiftround = true;
        shiftwidth = 2;
        showmode = false;
        sidescrolloff = 8;
        signcolumn = "yes";
        smartcase = true;
        smartindent = true;
        splitbelow = true;
        splitkeep = "screen";
        splitright = true;
        tabstop = 2;
        termguicolors = true;
        timeoutlen = 500;
        undofile = true;
        undolevels = 10000;
        updatetime = 200;
        virtualedit = "block";
        wildmode = "longest:full,full";
        winminwidth = 5;
        wrap = true;
        winborder = "rounded";
        modeline = false;
      };
    };
  };
}
