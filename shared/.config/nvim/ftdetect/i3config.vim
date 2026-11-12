augroup user_i3_config
    autocmd!
    autocmd BufRead,BufNewFile ~/.config/i3/config,~/.config/i3/*.conf setlocal filetype=i3config
augroup END
