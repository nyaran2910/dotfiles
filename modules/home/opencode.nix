{ ... }:

{
  xdg.configFile."opencode/tui.json".text = ''
    {
      "$schema": "https://opencode.ai/tui.json",
      "keybinds": {
        "input_backspace": "ctrl+h",
        "model_list": "ctrl+l",
        "app_exit": "ctrl+q"
      }
    }
  '';
}
