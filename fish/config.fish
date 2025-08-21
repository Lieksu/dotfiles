alias nv="nvim"
alias cat="bat"
alias ls="eza -lh --group-directories-first --icons --hyperlink"
alias lsa="ls -a"
alias lt="eza --tree --level=2 --long --icons --git"
alias lta="lt -a"

function nvf
    set search_path "."
    if test (count $argv) -gt 0
        set search_path $argv[1]
    end

    fd --hidden --no-ignore --follow --exclude='**/.git/' . $search_path \
        | fzf --preview 'bat --color=always {}' --print0 \
        | xargs -0 -o nvim
end

function nvwork --description "Open Neovim with workspace layout"
    nvim -c 'lua require("workspace").open()'
end
