// This is musl-libc commit 37e18b7bf307fa4a8c745feebfcba54a0ba74f30:
//
// src/string/memcpy.c
//
// This was compiled into assembly with:
//
// clang-14 -target riscv32 -march=rv32im -O3 -S memcpy.c -nostdlib -fno-builtin -funroll-loops
//
// and labels manually updated to not conflict.
//
// musl as a whole is licensed under the following standard MIT license:
//
// ----------------------------------------------------------------------
// Copyright © 2005-2020 Rich Felker, et al.
//
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
// CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
// ----------------------------------------------------------------------
//
// Authors/contributors include:
//
// A. Wilcox
// Ada Worcester
// Alex Dowad
// Alex Suykov
// Alexander Monakov
// Andre McCurdy
// Andrew Kelley
// Anthony G. Basile
// Aric Belsito
// Arvid Picciani
// Bartosz Brachaczek
// Benjamin Peterson
// Bobby Bingham
// Boris Brezillon
// Brent Cook
// Chris Spiegel
// Clément Vasseur
// Daniel Micay
// Daniel Sabogal
// Daurnimator
// David Carlier
// David Edelsohn
// Denys Vlasenko
// Dmitry Ivanov
// Dmitry V. Levin
// Drew DeVault
// Emil Renner Berthing
// Fangrui Song
// Felix Fietkau
// Felix Janda
// Gianluca Anzolin
// Hauke Mehrtens
// He X
// Hiltjo Posthuma
// Isaac Dunham
// Jaydeep Patil
// Jens Gustedt
// Jeremy Huntwork
// Jo-Philipp Wich
// Joakim Sindholt
// John Spencer
// Julien Ramseier
// Justin Cormack
// Kaarle Ritvanen
// Khem Raj
// Kylie McClain
// Leah Neukirchen
// Luca Barbato
// Luka Perkov
// M Farkas-Dyck (Strake)
// Mahesh Bodapati
// Markus Wichmann
// Masanori Ogino
// Michael Clark
// Michael Forney
// Mikhail Kremnyov
// Natanael Copa
// Nicholas J. Kain
// orc
// Pascal Cuoq
// Patrick Oppenlander
// Petr Hosek
// Petr Skocik
// Pierre Carrier
// Reini Urban
// Rich Felker
// Richard Pennington
// Ryan Fairfax
// Samuel Holland
// Segev Finer
// Shiz
// sin
// Solar Designer
// Stefan Kristiansson
// Stefan O'Rear
// Szabolcs Nagy
// Timo Teräs
// Trutz Behn
// Valentin Ochs
// Will Dietz
// William Haddon
// William Pitcock
//
// Portions of this software are derived from third-party works licensed
// under terms compatible with the above MIT license:
//
// The TRE regular expression implementation (src/regex/reg* and
// src/regex/tre*) is Copyright © 2001-2008 Ville Laurikari and licensed
// under a 2-clause BSD license (license text in the source files). The
// included version has been heavily modified by Rich Felker in 2012, in
// the interests of size, simplicity, and namespace cleanliness.
//
// Much of the math library code (src/math/* and src/complex/*) is
// Copyright © 1993,2004 Sun Microsystems or
// Copyright © 2003-2011 David Schultz or
// Copyright © 2003-2009 Steven G. Kargl or
// Copyright © 2003-2009 Bruce D. Evans or
// Copyright © 2008 Stephen L. Moshier or
// Copyright © 2017-2018 Arm Limited
// and labelled as such in comments in the individual source files. All
// have been licensed under extremely permissive terms.
//
// The ARM memcpy code (src/string/arm/memcpy.S) is Copyright © 2008
// The Android Open Source Project and is licensed under a two-clause BSD
// license. It was taken from Bionic libc, used on Android.
//
// The AArch64 memcpy and memset code (src/string/aarch64/*) are
// Copyright © 1999-2019, Arm Limited.
//
// The implementation of DES for crypt (src/crypt/crypt_des.c) is
// Copyright © 1994 David Burren. It is licensed under a BSD license.
//
// The implementation of blowfish crypt (src/crypt/crypt_blowfish.c) was
// originally written by Solar Designer and placed into the public
// domain. The code also comes with a fallback permissive license for use
// in jurisdictions that may not recognize the public domain.
//
// The smoothsort implementation (src/stdlib/qsort.c) is Copyright © 2011
// Valentin Ochs and is licensed under an MIT-style license.
//
// The x86_64 port was written by Nicholas J. Kain and is licensed under
// the standard MIT terms.
//
// The mips and microblaze ports were originally written by Richard
// Pennington for use in the ellcc project. The original code was adapted
// by Rich Felker for build system and code conventions during upstream
// integration. It is licensed under the standard MIT terms.
//
// The mips64 port was contributed by Imagination Technologies and is
// licensed under the standard MIT terms.
//
// The powerpc port was also originally written by Richard Pennington,
// and later supplemented and integrated by John Spencer. It is licensed
// under the standard MIT terms.
//
// All other files which have no copyright comments are original works
// produced specifically for use as part of this library, written either
// by Rich Felker, the main author of the library, or by one or more
// contibutors listed above. Details on authorship of individual files
// can be found in the git version control history of the project. The
// omission of copyright and license comments in each file is in the
// interest of source tree size.
//
// In addition, permission is hereby granted for all public header files
// (include/* and arch/* /bits/* ) and crt files intended to be linked into
// applications (crt/*, ldso/dlstart.c, and arch/* /crt_arch.h) to omit
// the copyright notice and permission notice otherwise required by the
// license, and to use these files without any requirement of
// attribution. These files include substantial contributions from:
//
// Bobby Bingham
// John Spencer
// Nicholas J. Kain
// Rich Felker
// Richard Pennington
// Stefan Kristiansson
// Szabolcs Nagy
//
// all of whom have explicitly granted such permission.
//
// This file previously contained text expressing a belief that most of
// the files covered by the above exception were sufficiently trivial not
// to be subject to copyright, resulting in confusion over whether it
// negated the permissions granted in the license. In the spirit of
// permissive licensing, and of not having licensing issues being an
// obstacle to adoption, that text has been removed.
	.file	"memcpy.c"
	.option nopic
	.attribute arch, "rv32im"
	.attribute unaligned_access, 0
	.attribute stack_align, 16
	.text
	.align	2
	.globl	memcpy
	.type	memcpy, @function
memcpy:
	andi	a3, a1, 3
	seqz	a3, a3
	seqz	a4, a2
	or	a4, a3, a4
	mv	a3, a0
	bnez	a4, .LBB0_11memcpy
	addi	a0, a1, 1
	mv	a6, a3
.LBB0_2memcpy:
	lb	a7, 0(a1)
	addi	a5, a1, 1
	addi	a4, a6, 1
	sb	a7, 0(a6)
	addi	a2, a2, -1
	andi	a1, a0, 3
	snez	a1, a1
	snez	a6, a2
	and	a7, a1, a6
	addi	a0, a0, 1
	mv	a1, a5
	mv	a6, a4
	bnez	a7, .LBB0_2memcpy
	andi	a0, a4, 3
	beqz	a0, .LBB0_12memcpy
.LBB0_4memcpy:
	li	a1, 32
	bltu	a2, a1, .LBB0_32memcpy
	li	a1, 3
	beq	a0, a1, .LBB0_25memcpy
	li	a1, 2
	beq	a0, a1, .LBB0_28memcpy
	li	a1, 1
	bne	a0, a1, .LBB0_32memcpy
	lw	a6, 0(a5)
	sb	a6, 0(a4)
	srli	a0, a6, 8
	sb	a0, 1(a4)
	srli	a1, a6, 16
	addi	a0, a4, 3
	sb	a1, 2(a4)
	addi	a2, a2, -3
	addi	a1, a5, 16
	li	a4, 16
.LBB0_9memcpy:
	lw	a5, -12(a1)
	srli	a6, a6, 24
	slli	a7, a5, 8
	lw	t0, -8(a1)
	or	a6, a7, a6
	sw	a6, 0(a0)
	srli	a5, a5, 24
	slli	a6, t0, 8
	lw	a7, -4(a1)
	or	a5, a6, a5
	sw	a5, 4(a0)
	srli	a5, t0, 24
	slli	t0, a7, 8
	lw	a6, 0(a1)
	or	a5, t0, a5
	sw	a5, 8(a0)
	srli	a5, a7, 24
	slli	a7, a6, 8
	or	a5, a7, a5
	sw	a5, 12(a0)
	addi	a0, a0, 16
	addi	a2, a2, -16
	addi	a1, a1, 16
	bltu	a4, a2, .LBB0_9memcpy
	addi	a5, a1, -13
	j	.LBB0_31memcpy
.LBB0_11memcpy:
	mv	a4, a3
	mv	a5, a1
	andi	a0, a4, 3
	bnez	a0, .LBB0_4memcpy
.LBB0_12memcpy:
	li	a0, 64
	bltu	a2, a0, .LBB0_15memcpy
	lui	a0, 16
	addi	a6, a0, 401
	li	a7, 63
.LBB0_14memcpy:
	#APP
	mv	t0, a6
	mv	a0, a5
	mv	a1, a4
	ecall	
	#NO_APP
	addi	a5, a5, 64
	addi	a2, a2, -64
	addi	a4, a4, 64
	bltu	a7, a2, .LBB0_14memcpy
.LBB0_15memcpy:
	li	a0, 32
	bltu	a2, a0, .LBB0_18memcpy
	lui	a0, 16
	addi	a6, a0, 400
	li	a7, 31
.LBB0_17memcpy:
	#APP
	mv	t0, a6
	mv	a0, a5
	mv	a1, a4
	ecall	
	#NO_APP
	addi	a5, a5, 32
	addi	a2, a2, -32
	addi	a4, a4, 32
	bltu	a7, a2, .LBB0_17memcpy
.LBB0_18memcpy:
	li	a0, 16
	bltu	a2, a0, .LBB0_21memcpy
	li	a0, 15
.LBB0_20memcpy:
	lw	a1, 0(a5)
	lw	a6, 4(a5)
	lw	a7, 8(a5)
	lw	t0, 12(a5)
	sw	a1, 0(a4)
	sw	a6, 4(a4)
	sw	a7, 8(a4)
	sw	t0, 12(a4)
	addi	a5, a5, 16
	addi	a2, a2, -16
	addi	a4, a4, 16
	bltu	a0, a2, .LBB0_20memcpy
.LBB0_21memcpy:
	andi	a0, a2, 8
	beqz	a0, .LBB0_23memcpy
	lw	a0, 0(a5)
	lw	a1, 4(a5)
	sw	a0, 0(a4)
	sw	a1, 4(a4)
	addi	a4, a4, 8
	addi	a5, a5, 8
.LBB0_23memcpy:
	andi	a0, a2, 4
	beqz	a0, .LBB0_36memcpy
	lw	a0, 0(a5)
	sw	a0, 0(a4)
	addi	a4, a4, 4
	addi	a5, a5, 4
	j	.LBB0_36memcpy
.LBB0_25memcpy:
	lw	a6, 0(a5)
	addi	a0, a4, 1
	sb	a6, 0(a4)
	addi	a2, a2, -1
	addi	a1, a5, 16
	li	a4, 18
.LBB0_26memcpy:
	lw	a5, -12(a1)
	srli	a6, a6, 8
	slli	a7, a5, 24
	lw	t0, -8(a1)
	or	a6, a7, a6
	sw	a6, 0(a0)
	srli	a5, a5, 8
	slli	a6, t0, 24
	lw	a7, -4(a1)
	or	a5, a6, a5
	sw	a5, 4(a0)
	srli	a5, t0, 8
	slli	t0, a7, 24
	lw	a6, 0(a1)
	or	a5, t0, a5
	sw	a5, 8(a0)
	srli	a5, a7, 8
	slli	a7, a6, 24
	or	a5, a7, a5
	sw	a5, 12(a0)
	addi	a0, a0, 16
	addi	a2, a2, -16
	addi	a1, a1, 16
	bltu	a4, a2, .LBB0_26memcpy
	addi	a5, a1, -15
	j	.LBB0_31memcpy
.LBB0_28memcpy:
	lw	a6, 0(a5)
	sb	a6, 0(a4)
	srli	a1, a6, 8
	addi	a0, a4, 2
	sb	a1, 1(a4)
	addi	a2, a2, -2
	addi	a1, a5, 16
	li	a4, 17
.LBB0_29memcpy:
	lw	a5, -12(a1)
	srli	a6, a6, 16
	slli	a7, a5, 16
	lw	t0, -8(a1)
	or	a6, a7, a6
	sw	a6, 0(a0)
	srli	a5, a5, 16
	slli	a6, t0, 16
	lw	a7, -4(a1)
	or	a5, a6, a5
	sw	a5, 4(a0)
	srli	a5, t0, 16
	slli	t0, a7, 16
	lw	a6, 0(a1)
	or	a5, t0, a5
	sw	a5, 8(a0)
	srli	a5, a7, 16
	slli	a7, a6, 16
	or	a5, a7, a5
	sw	a5, 12(a0)
	addi	a0, a0, 16
	addi	a2, a2, -16
	addi	a1, a1, 16
	bltu	a4, a2, .LBB0_29memcpy
	addi	a5, a1, -14
.LBB0_31memcpy:
	mv	a4, a0
.LBB0_32memcpy:
	andi	a0, a2, 16
	bnez	a0, .LBB0_41memcpy
	andi	a0, a2, 8
	bnez	a0, .LBB0_42memcpy
.LBB0_34memcpy:
	andi	a0, a2, 4
	beqz	a0, .LBB0_36memcpy
.LBB0_35memcpy:
	lb	a0, 0(a5)
	lb	a1, 1(a5)
	lb	a6, 2(a5)
	sb	a0, 0(a4)
	sb	a1, 1(a4)
	lb	a0, 3(a5)
	sb	a6, 2(a4)
	addi	a5, a5, 4
	addi	a1, a4, 4
	sb	a0, 3(a4)
	mv	a4, a1
.LBB0_36memcpy:
	andi	a0, a2, 2
	bnez	a0, .LBB0_39memcpy
	andi	a0, a2, 1
	bnez	a0, .LBB0_40memcpy
.LBB0_38memcpy:
	mv	a0, a3
	ret
.LBB0_39memcpy:
	lb	a0, 0(a5)
	lb	a1, 1(a5)
	sb	a0, 0(a4)
	addi	a5, a5, 2
	addi	a0, a4, 2
	sb	a1, 1(a4)
	mv	a4, a0
	andi	a0, a2, 1
	beqz	a0, .LBB0_38memcpy
.LBB0_40memcpy:
	lb	a0, 0(a5)
	sb	a0, 0(a4)
	mv	a0, a3
	ret
.LBB0_41memcpy:
	lb	a0, 0(a5)
	lb	a1, 1(a5)
	lb	a6, 2(a5)
	sb	a0, 0(a4)
	sb	a1, 1(a4)
	lb	a0, 3(a5)
	sb	a6, 2(a4)
	lb	a1, 4(a5)
	lb	a6, 5(a5)
	sb	a0, 3(a4)
	lb	a0, 6(a5)
	sb	a1, 4(a4)
	sb	a6, 5(a4)
	lb	a1, 7(a5)
	sb	a0, 6(a4)
	lb	a0, 8(a5)
	lb	a6, 9(a5)
	sb	a1, 7(a4)
	lb	a1, 10(a5)
	sb	a0, 8(a4)
	sb	a6, 9(a4)
	lb	a0, 11(a5)
	sb	a1, 10(a4)
	lb	a1, 12(a5)
	lb	a6, 13(a5)
	sb	a0, 11(a4)
	lb	a0, 14(a5)
	sb	a1, 12(a4)
	sb	a6, 13(a4)
	lb	a1, 15(a5)
	sb	a0, 14(a4)
	addi	a5, a5, 16
	addi	a0, a4, 16
	sb	a1, 15(a4)
	mv	a4, a0
	andi	a0, a2, 8
	beqz	a0, .LBB0_34memcpy
.LBB0_42memcpy:
	lb	a0, 0(a5)
	lb	a1, 1(a5)
	lb	a6, 2(a5)
	sb	a0, 0(a4)
	sb	a1, 1(a4)
	lb	a0, 3(a5)
	sb	a6, 2(a4)
	lb	a1, 4(a5)
	lb	a6, 5(a5)
	sb	a0, 3(a4)
	lb	a0, 6(a5)
	sb	a1, 4(a4)
	sb	a6, 5(a4)
	lb	a1, 7(a5)
	sb	a0, 6(a4)
	addi	a5, a5, 8
	addi	a0, a4, 8
	sb	a1, 7(a4)
	mv	a4, a0
	andi	a0, a2, 4
	bnez	a0, .LBB0_35memcpy
	j	.LBB0_36memcpy
.Lfunc_end0memcpy:
	.size	memcpy, .Lfunc_end0memcpy-memcpy

	.ident	"Ubuntu clang version 14.0.0-1ubuntu1.1"
	.section	".note.GNU-stack","",@progbits
	.addrsig
