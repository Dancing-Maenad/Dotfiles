# Neovim config

Install:
    mv ~/.config/nvim ~/.config/nvim.nvchad.bak     # back up NvChad
    mv ~/.local/share/nvim ~/.local/share/nvim.bak  # optional clean slate
    cp -r nvim ~/.config/nvim
    nvim

Requirements: Neovim 0.11+, git, a C compiler, tree-sitter CLI, fzf, ripgrep,
a Nerd Font in your terminal. Optional: lazygit.

Keys (leader = Space): <leader>ff files, <leader>fg grep, <leader>e explorer,
<leader>gg lazygit, s flash-jump, <C-\> terminal, <C-s> save. Press <leader> and
wait to see everything via which-key.
