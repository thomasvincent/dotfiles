" Vim syntax file
" Language: JSON
" Maintainer: Jeroen Ruigrok van der Werven <asmodai@in-nomine.org>
" Last Change: 2023-12-20 (Updated for best practices)
" Version: 0.5

if exists('b:current_syntax')
    finish
endif
let b:current_syntax = 'json'

" Syntax Highlighting Groups
" (Define these first for clarity)
hi def link jsonString String
hi def link jsonEscape Special
hi def link jsonNumber Number
hi def link jsonBoolean Boolean
hi def link jsonNull Function
hi def link jsonBraces Delimiter  " Using 'Delimiter' is more appropriate

hi def link jsonNumError Error
hi def link jsonStringSQ Error
hi def link jsonNoQuotes Error

" Syntax Matching
syn region jsonString start=+\"+ skip=+\\\\\|\\"+ end=+\"+ contains=jsonEscape
syn region jsonStringSQ start=+'+ skip=+\\\\\|\\"+ end=+'+
syn match jsonEscape +"\\["\\/bfnrt]+ contained
syn match jsonEscape +\\u\x\{4}+ contained

syn match jsonNumber +-\=\<\%(0\|[1-9]\d*\)\%(\.\d\+\)\=\%([eE][-+]\=\d\+\)\=\>+
syn match jsonNumError +-\=\<0\d\.\d*\>+

syn keyword jsonBoolean true false
syn keyword jsonNull null
syn match jsonBraces +[{}\[\]]+

" Error Highlighting (Explicitly match invalid patterns)
syn match jsonError +\%([^,:{}\[\]0-9.eE -]\|[,:{}\[\]]\@<!\s*[,:{}\[\]]\)+

" Advanced Configuration
" (Uncomment and customize as needed)

" Enable syntax folding for better navigation
" setlocal foldmethod=syntax
" setlocal foldlevelstart=1

" Enable concealing of quotes for cleaner visuals
" syntax conceal jsonString
" syntax conceal jsonEscape
" syntax conceal jsonNumber
" syntax conceal jsonBoolean
" syntax conceal jsonNull
