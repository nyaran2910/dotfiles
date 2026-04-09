return {
  "NickvanDyke/opencode.nvim",
  dependencies = {
    -- Recommended for `ask()` and `select()`.
    -- Required for `snacks` provider.
    ---@module 'snacks'
    { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
  },

  config = function()
    -- 基本設定
    vim.g.opencode_opts = {
      -- 必要に応じてオプションを設定
    }

    -- グローバル名前空間汚染を防ぐためのローカル関数定義
    local M = {}

    -- Opencodeウィンドウを現在のタブページから探索する関数
    function M.find_opencode_win()
      local wins = vim.api.nvim_tabpage_list_wins(0)
      for _, win in ipairs(wins) do
        local buf = vim.api.nvim_win_get_buf(win)
        local name = vim.api.nvim_buf_get_name(buf)
        if name:match("opencode") then
          return win
        end
      end
      return nil
    end

    -- コンテキスト認識型トグル関数
    function M.smart_toggle()
      local opencode_win = M.find_opencode_win()
      local current_win = vim.api.nvim_get_current_win()

      if not opencode_win then
        -- State A: ウィンドウが存在しない -> 新規オープン
        require("opencode").toggle()

        -- 【ここを修正】オープンした直後に再度ウィンドウを探し、強制的にフォーカスする
        opencode_win = M.find_opencode_win()
        if opencode_win then
          vim.api.nvim_set_current_win(opencode_win)
          vim.cmd("startinsert")
        end
      else
        if current_win == opencode_win then
          -- State C: 既にフォーカスされている -> 閉じる
          require("opencode").toggle()
        else
          -- State B: ウィンドウはあるがフォーカスがない -> フォーカス移動
          vim.api.nvim_set_current_win(opencode_win)
          vim.cmd("startinsert")
        end
      end
    end

    -- オートコマンドグループの作成
    local augroup = vim.api.nvim_create_augroup("OpencodeCustomConfig", { clear = true })

    -- Opencodeバッファに対する設定適用
    vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter", "TermOpen" }, {
      group = augroup,
      pattern = "*",
      callback = function(ev)
        local buf_name = vim.api.nvim_buf_get_name(ev.buf)
        -- Opencodeバッファであることを確認
        if buf_name:match("opencode") then
          local opts = { buffer = ev.buf, remap = false, silent = true }

          -- 1. Ctrl-c の挙動
          vim.keymap.set("t", "<C-c>", "<Del>", opts)
          vim.keymap.set("n", "<C-c>", "x", opts)

          -- 2. Emacsライクなバックスペース
          vim.keymap.set("t", "<C-h>", "<BS>", { buffer = ev.buf, remap = false, desc = "Opencode: Backspace" })

          -- 【追加】Opencode内で Ctrl+. を押したときに閉じる（トグルする）ための設定
          -- ターミナルモード(t)でも smart_toggle が呼ばれるようにする
          vim.keymap.set("t", "<C-.>", function()
            M.smart_toggle()
          end, opts)
          vim.keymap.set("n", "<C-.>", function()
            M.smart_toggle()
          end, opts)

          -- 3. エスケープ処理
          if vim.o.buftype == "terminal" then
            vim.cmd("startinsert")
          end
        end
      end,
    })

    -- グローバルキーマップ設定
    -- "t" (Terminal) モードも対象に追加して、どこにいても反応するようにする
    vim.keymap.set({ "n", "x", "i", "t" }, "<C-.>", function()
      M.smart_toggle()
    end, { desc = "Smart Toggle Opencode" })

    -- その他の推奨キーマップ
    vim.o.autoread = true
    vim.keymap.set({ "n", "x" }, "<C-a>", function()
      require("opencode").ask("@this: ", { submit = true })
    end, { desc = "Ask opencode…" })
    vim.keymap.set({ "n", "x" }, "<C-x>", function()
      require("opencode").select()
    end, { desc = "Execute opencode action…" })
    vim.keymap.set({ "n", "x" }, "go", function()
      return require("opencode").operator("@this ")
    end, { desc = "Add range to opencode", expr = true })
    vim.keymap.set("n", "goo", function()
      return require("opencode").operator("@this ") .. "_"
    end, { desc = "Add line to opencode", expr = true })
    vim.keymap.set("n", "<S-C-u>", function()
      require("opencode").command("session.half.page.up")
    end, { desc = "Scroll opencode up" })
    vim.keymap.set("n", "<S-C-d>", function()
      require("opencode").command("session.half.page.down")
    end, { desc = "Scroll opencode down" })
    vim.keymap.set("n", "+", "<C-a>", { desc = "Increment under cursor", noremap = true })
    vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement under cursor", noremap = true })
  end,
}
