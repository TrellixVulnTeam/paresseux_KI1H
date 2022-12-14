/*-*- mode:unix-assembly; indent-tabs-mode:t; tab-width:8; coding:utf-8     -*-│
│vi: set et ft=asm ts=8 tw=8 fenc=utf-8                                     :vi│
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
#include "libc/runtime/runtime.h"
#include "libc/dce.h"
#include "libc/macros.internal.h"

#define kTmpPathMax 80

//	RII constant holding /tmp/ directory.
//
//	@note	on win32 this is firstNonNull($TMP, $TEMP, $PWD)
//	@note	guarantees trailing slash if non-empty
	.initbss 300,_init_kTmpPath
kTmpPath:
	.zero	kTmpPathMax
	.endobj	kTmpPath,globl
	.previous

	.init.start 300,_init_kTmpPath
	movl	$'/'|'t'<<010|'m'<<020|'p'<<030,(%rdi)
	movw	$'/',4(%rdi)
#if SupportsWindows()
	pushpop	kTmpPathMax,%rdx
	ezlea	GetTempPathA_flunk,ax
	call	__getntsyspath
#else
	add	$kTmpPathMax,%rdi
#endif
	.init.end 300,_init_kTmpPath
