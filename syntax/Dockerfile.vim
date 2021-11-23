" Vim syntax file
" Language:	Dockerfile
" Maintainer:	lmao <spamspamspam@mumble.org.uk>
" Last Change:	2021 11 22
" Remark:	Stolen from https://github.com/vim/vim/blob/master/runtime/syntax/dockerfile.vim

if exists('b:current_syntax')
  finish
endif

let b:current_syntax = 'dockerfile'

syntax include @JSON syntax/json.vim
unlet b:current_syntax

syntax include @Shell syntax/sh.vim
unlet b:current_syntax

syntax case ignore
syntax match dockerfileLinePrefix /\v^\s*(ONBUILD\s+)?\ze\S/ contains=dockerfileKeyword nextgroup=dockerfileInstruction skipwhite
syntax region dockerfileFrom matchgroup=dockerfileKeyword start=/\v^\s*(FROM)\ze(\s|$)/ skip=/\v\\\_./ end=/\v((^|\s)AS(\s|$)|$)/ contains=dockerfileOption

syntax keyword dockerfileKeyword contained ADD ARG CMD COPY ENTRYPOINT ENV EXPOSE HEALTHCHECK LABEL MAINTAINER ONBUILD RUN SHELL STOPSIGNAL USER VOLUME WORKDIR
syntax match dockerfileOption contained /\v(^|\s)\zs--\S+/

syntax match dockerfileInstruction contained /\v<(\S+)>(\s+--\S+)*/             contains=dockerfileKeyword,dockerfileOption skipwhite nextgroup=dockerfileValue
syntax match dockerfileInstruction contained /\v<(ADD|COPY)>(\s+--\S+)*/        contains=dockerfileKeyword,dockerfileOption skipwhite nextgroup=dockerfileJSON
syntax match dockerfileInstruction contained /\v<(HEALTHCHECK)>(\s+--\S+)*/     contains=dockerfileKeyword,dockerfileOption skipwhite nextgroup=dockerfileInstruction
syntax match dockerfileInstruction contained /\v<(CMD|ENTRYPOINT|RUN)>/         contains=dockerfileKeyword skipwhite nextgroup=dockerfileShell
syntax match dockerfileInstruction contained /\v<(CMD|ENTRYPOINT|RUN)>\ze\s+\[/ contains=dockerfileKeyword skipwhite nextgroup=dockerfileJSON
syntax match dockerfileInstruction contained /\v<(SHELL|VOLUME)>/               contains=dockerfileKeyword skipwhite nextgroup=dockerfileJSON

syntax region dockerfileComment start=/\v^\s*#/ end=/\v$/
set commentstring=#\ %s

syntax region dockerfileString contained start=/\v"/ skip=/\v\\./ end=/\v"/
syntax region dockerfileJSON   contained keepend start=/\v\[/ skip=/\v\\\_./ end=/\v$/ contains=@JSON

" This is where the ugliness happens to make mutliline shell with comments even vaguely work.
" need to ugly look behind regex to fix there not being a \n\n after the last shell command
syntax region dockerfileShell  contained keepend start=/\v/ skip=/\v\\\_.#.*\_$/ end=/\v\_^\_$/ contains=@Shell
syntax region dockerfileValue  contained keepend start=/\v/ skip=/\v\\\_./ end=/\v$/ contains=dockerfileString

hi def link dockerfileString String
hi def link dockerfileKeyword Keyword
hi def link dockerfileComment Comment
hi def link dockerfileOption Special

let b:current_syntax = 'dockerfile'

" vim: set filetype=vim:
