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
#include "libc/nexgen32e/x86feature.h"
#include "libc/dce.h"
#include "libc/macros.internal.h"

//	Searches for last instance of uint16_t in memory region.
//
//	@param	rdi points to data to search
//	@param	esi is treated as uint16_t
//	@param	rdx is short count in rdi
//	@return	rax is address of last %si in %rdi, or NULL
//	@note	AVX2 requires Haswell (2014+) or Excavator (2015+)
memrchr16:
	.leafprologue
	.profilable
#if !IsTiny()
	cmp	$16,%rdx
	jb	5f
	testb	X86_HAVE(AVX2)+kCpuids(%rip)
	jz	5f
	vmovd	%esi,%xmm0
	vpbroadcastw %xmm0,%ymm0
3:	vmovdqu	-32(%rdi,%rdx,2),%ymm1
	vpcmpeqw %ymm1,%ymm0,%ymm1
	vpmovmskb %ymm1,%eax
	lzcnt	%eax,%eax
	shr	%eax
	mov	%eax,%ecx
	sub	%rcx,%rdx
	cmp	$16,%eax
	jne	5f
	cmp	$15,%rdx
	ja	3b
	vzeroupper
#endif
5:	xor	%eax,%eax
	mov	%rdx,%rcx
6:	sub	$1,%rcx
	jb	9f
	cmp	%si,-2(%rdi,%rdx,2)
	mov	%rcx,%rdx
	jne	6b
	lea	(%rdi,%rcx,2),%rax
9:	.leafepilogue
	.endfn	memrchr16,globl
