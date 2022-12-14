/*-*- mode:unix-assembly; indent-tabs-mode:t; tab-width:8; coding:utf-8     -*-│
│vi: set et ft=asm ts=8 sw=8 fenc=utf-8                                     :vi│
╞══════════════════════════════════════════════════════════════════════════════╡
│ Copyright 2020 Justine Alexandra Roberts Tunney                              │
│                                                                              │
│ Permission to use, copy, modify, and/or distribute this software for         │
│ any purpose with or without fee is hereby granted, provided that the         │
│ above copyright notice and this permission notice appear in all copies.      │
│                                                                              │
│ THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL                │
│ WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED                │
│ WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE             │
│ AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL         │
│ DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR        │
│ PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER               │
│ TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR             │
│ PERFORMANCE OF THIS SOFTWARE.                                                │
╚─────────────────────────────────────────────────────────────────────────────*/
#include "libc/macros.internal.h"

	.initbss 400,_init_program_invocation_short_name
//	Supplies basename(argv[0]) The GNU Way.
//
//	If argv[0] isn't supplied, this value will be null.
//
//	@see	GetProgramExecutableName()
//	@see	program_invocation_name
program_invocation_short_name:
	.quad	0
	.endobj	program_invocation_short_name,globl
	.previous

	.init.start 400,_init_program_invocation_short_name
	push	%rsi
	xor	%eax,%eax
	test	%r12d,%r12d		# argc
	jz	2f
	mov	(%r13),%rsi		# argv[0]
	mov	%rsi,%rcx
1:	lodsb
	cmp	$'/',%al
	cmoveq	%rsi,%rcx
	cmp	$'\\',%al
	cmoveq	%rsi,%rcx
	test	%al,%al
	jnz	1b
	xchg	%rcx,%rax
	pop	%rsi
2:	stosq
	.init.end 400,_init_program_invocation_short_name
