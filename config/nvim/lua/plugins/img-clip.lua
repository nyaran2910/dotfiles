return {
  "HakonHarnes/img-clip.nvim",
  event = "VeryLazy",
  cmd = { "PasteImage", "ImgClipConfig", "ImgClipDebug" },
  opts = {
    default = {
      dir_path = "assets",
      relative_to_current_file = true,
      prompt_for_file_name = false,
      file_name = "%Y-%m-%d-%H-%M-%S",
      extension = "png",
      use_absolute_path = false,
      relative_template_path = true,
    },
  },
  keys = {
    {
      "<leader>p",
      "<cmd>PasteImage<cr>",
      desc = "Paste image from system clipboard",
    },
  },
}
