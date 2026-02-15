# Custom prompt to include hostname
PROMPT="%(?:%{$fg_bold[green]%}%1{➜%} :%{$fg_bold[red]%}%1{➜%} ) %{$fg[yellow]%}%M %{$fg[cyan]%}%c%{$reset_color%} $(git_prompt_info)"