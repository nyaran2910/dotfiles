return {
  "HakonHarnes/img-clip.nvim",
  event = "VeryLazy",
  opts = {
    dir_path = "assets",
    relative_to_current_file = true,
    prompt_for_file_name = false,
    file_name = "%Y-%m-%d-%H-%M-%S",
    extension = "png",
  },
  keys = {
    -- suggested keymap
    { "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
  },
}
