{ ... }:

{
  programs.fzf = {
    enable = true;
    # Flexoki theme
    # see https://github.com/kepano/flexoki/tree/main/fzf
    colors = {
      fg = "#878580";
      bg = "#100F0F";
      hl = "#CECDC3";
      "fg+" = "#878580";
      "bg+" = "#1C1B1A";
      "hl+" = "#CECDC3";
      border = "#AF3029";
      header = "#CECDC3";
      gutter = "#100F0F";
      spinner = "#24837B";
      info = "#24837B";
      separator = "#1C1B1A";
      pointer = "#AD8301";
      marker = "#AF3029";
      prompt = "#AD8301";
    };
    defaultCommand = "rg --files --hidden --glob '!.git/*'";
  };
}
