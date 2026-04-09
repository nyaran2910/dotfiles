{ ... }:

{
  xdg.configFile."pandoc/defaults/default.yaml".text = ''
    pdf-engine: lualatex
    variables:
      documentclass: ltjsarticle
      CJKmainfont: "Hiragino Mincho ProN"
      CJKsansfont: "Hiragino Sans"
      geometry:
        - margin=25mm
  '';
}
