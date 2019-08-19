" Vim Only Terminal Tweaks: Colors, cursor shape
"---------------------------------------------------------

" Paste
" Credits: https://github.com/Shougo/shougo-s-github
" ---
let &t_ti .= "\e[?2004h"
let &t_te .= "\e[?2004l"
let &pastetoggle = "\e[201~"

function! s:XTermPasteBegin(ret) abort
	setlocal paste
	return a:ret
endfunction

noremap  <special> <expr> <Esc>[200~ <SID>XTermPasteBegin('0i')
inoremap <special> <expr> <Esc>[200~ <SID>XTermPasteBegin('')
cnoremap <special> <Esc>[200~ <nop>
cnoremap <special> <Esc>[201~ <nop>

" Mouse settings
" ---
if has('mouse')
	if has('mouse_sgr')
		set ttymouse=sgr
	else
		set ttymouse=xterm2
	endif
endif

" Cursor-shape
" Credits: https://github.com/wincent/terminus
" ---
" Detect terminal
let s:iterm = exists('$ITERM_PROFILE') || exists('$ITERM_SESSION_ID')
let s:iterm2 = s:iterm && exists('$TERM_PROGRAM_VERSION') &&
	\ match($TERM_PROGRAM_VERSION, '\v^[2-9]\.') == 0
let s:konsole = exists('$KONSOLE_DBUS_SESSION') ||
	\ exists('$KONSOLE_PROFILE_NAME')

" 1 or 0 -> blinking block
" 2 -> solid block
" 3 -> blinking underscore
" 4 -> solid underscore
" Recent versions of xterm (282 or above) also support
" 5 -> blinking vertical bar
" 6 -> solid vertical bar
let s:normal_shape = 0
let s:insert_shape = 5
let s:replace_shape = 3
if s:iterm2
	let s:start_insert = "\<Esc>]1337;CursorShape=" . s:insert_shape . "\x7"
	let s:start_replace = "\<Esc>]1337;CursorShape=" . s:replace_shape . "\x7"
	let s:end_insert = "\<Esc>]1337;CursorShape=" . s:normal_shape . "\x7"
elseif s:iterm || s:konsole
	let s:start_insert = "\<Esc>]50;CursorShape=" . s:insert_shape . "\x7"
	let s:start_replace = "\<Esc>]50;CursorShape=" . s:replace_shape . "\x7"
	let s:end_insert = "\<Esc>]50;CursorShape=" . s:normal_shape . "\x7"
else
	let s:cursor_shape_to_vte_shape = {1: 6, 2: 4, 0: 2, 5: 6, 3: 4}
	let s:insert_shape = s:cursor_shape_to_vte_shape[s:insert_shape]
	let s:replace_shape = s:cursor_shape_to_vte_shape[s:replace_shape]
	let s:normal_shape = s:cursor_shape_to_vte_shape[s:normal_shape]
	let s:start_insert = "\<Esc>[" . s:insert_shape . ' q'
	let s:start_replace = "\<Esc>[" . s:replace_shape . ' q'
	let s:end_insert = "\<Esc>[" . s:normal_shape . ' q'
endif

let &t_SI = s:start_insert
if v:version > 704 || v:version == 704 && has('patch687')
	let &t_SR = s:start_replace
end
let &t_EI = s:end_insert

" vim: set ts=2 sw=2 tw=80 noet :
