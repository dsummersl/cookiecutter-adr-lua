" lua << EOF
" require('lazy-loader')()
" EOF

let g:gutentags_ctags_exclude += ['*/lua_modules/*']
let g:projectionist_heuristics = {
      \ 'lua/&spec/': {
      \   'lua/{{ cookiecutter.package_name }}/*.lua': {
      \     'type': 'function',
      \     'alternate': [
      \       'spec/{dirname}{basename}_spec.lua',
      \       'spec/{dirname}/{basename}_spec.lua',
      \     ]
      \   },
      \   'spec/**/*_spec.lua': {
      \     'type': 'test',
      \     'alternate': [
      \       'lua/{{ cookiecutter.package_name }}/{dirname}{basename}.lua',
      \       'lua/{{ cookiecutter.package_name }}/{dirname}/{basename}.lua',
      \     ]
      \   },
      \ },
      \ }
