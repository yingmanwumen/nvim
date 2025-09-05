return {
  clear = {
    modes = {
      n = "<C-l>",
    },
  },
  next_chat = {
    modes = {
      n = ")",
    },
  },
  previous_chat = {
    modes = {
      n = "(",
    },
  },
  yolo_mode = {
    modes = { n = "gta" },
    index = 18,
    callback = "keymaps.yolo_mode",
    description = "YOLO mode toggle",
  },
}
