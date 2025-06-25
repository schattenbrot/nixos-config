local k = vim.keymap

-- Do not yank with x
k.set('n', 'x', '"_x')

-- Select all
k.set('n', '<C-a>', 'gg<S-v>G')

-- Move line
k.set('n', '<A-j>', 'ddp')
k.set('n', '<A-k>', 'ddkP')

-- Better tabbing
k.set('v', '<', '<gv')
k.set('v', '>', '>gv')
