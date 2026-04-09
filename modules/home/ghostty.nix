{ ... }:

{
  xdg.configFile."ghostty/config".text = ''
    # Cmd + I/J/K/L で上下左右のペインに移動
    keybind = cmd+i=goto_split:top
    keybind = cmd+j=goto_split:left
    keybind = cmd+k=goto_split:bottom
    keybind = cmd+l=goto_split:right

    # Cmd + u でターミナルをクリア
    keybind = cmd+u=clear_screen

    # Cmd + Shift + W で分割を無視してタブごと閉じる
    keybind = super+shift+w=close_tab
  '';
}
