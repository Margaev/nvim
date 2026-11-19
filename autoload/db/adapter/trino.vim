" OVERRIDE / EXTENSION of tpope/vim-dadbod
"
" Custom Trino adapter. vim-dadbod aliases trino:// to its built-in presto
" adapter, which ignores URL query params, so options like --socks-proxy can't
" be passed. This adapter is activated by the g:db_adapters override in
" lua/plugins/database.lua.
"
" Remove this file (and that override) if upstream vim-dadbod gains proper
" Trino support / passes URL params through as CLI flags.
"
" URL:      trino://[user@]host[:port][/catalog[/schema]][?socks_proxy=host:port&timezone=Zone]
" Password: set $TRINO_PASSWORD (the trino CLI reads it when --password is given).

function! db#adapter#trino#canonicalize(url) abort
  return a:url
endfunction

function! db#adapter#trino#interactive(url) abort
  let url = db#url#parse(a:url)
  let params = get(url, 'params', {})
  let cmd = ['trino',
        \ '--server', 'https://' . url.host . ':' . get(url, 'port', '443'),
        \ '--timezone', get(params, 'timezone', 'UTC')]
  if has_key(url, 'user')
    call extend(cmd, ['--user', url.user])
  endif
  if has_key(params, 'socks_proxy')
    call extend(cmd, ['--socks-proxy', params.socks_proxy])
  endif
  if !empty($TRINO_PASSWORD)
    call add(cmd, '--password')
  endif
  let parts = split(get(url, 'path', ''), '/')
  if len(parts) > 0 | call extend(cmd, ['--catalog', parts[0]]) | endif
  if len(parts) > 1 | call extend(cmd, ['--schema', parts[1]]) | endif
  return cmd
endfunction

function! db#adapter#trino#input(url, in) abort
  return db#adapter#trino#interactive(a:url) + ['--output-format', 'ALIGNED', '--file', a:in]
endfunction

" Auto-append ';' so queries without a terminator still run (same as upstream presto adapter)
function! db#adapter#trino#massage(input) abort
  if a:input =~# ";\s*\n*$"
    return a:input
  endif
  return a:input . "\n;"
endfunction
