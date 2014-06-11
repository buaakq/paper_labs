/* elf.h - Extended Load Format header */

/* Copyright 1992-2002 Wind River Systems, Inc. */

/*
modification history
--------------------
01i,27mar02,jn   Add STT_ARM_16BIT to the list of supported types. Make defs of 
                 STT_ARM_TFUNC and STT_ARM_16BIT match the gnu definitions 
                 from host/src/gnu/include/elf/arm.h (use STT_LOPROC and
		 STT_HIPROC instead of numbers).
01h,25jan02,rec  merge in Coldfire changes
01g,31aug01,jn   change ARM OMF to ELF
01f,01mar00,frf  Add SH4 support for T2.
01f,04jun99,zl   hitachi SH4 architecture port, provided by Highlander
                 Engineering
01e,19jun96,ism  added N_TEXT family of defines
01d,20jul95,ism  added simsolaris support
01f,24mar95,yao  added EM_PPC_OLD for EABI backward compatability.
01e,23feb95,caf  fixed #endif.
01d,06dec94,yao  added PPC support.
01c,01nov94,kdl  removed reference to SPARC architecture.
01b,18apr94,caf  isolated architecture-specific #includes with "ifdef CPU".
01a,29oct92,ajm  derived from Motorola delta88 elf.h
*/

#ifndef __INCelfh
#define __INCelfh

#ifdef __cplusplus
extern "C" {
#endif

/*	Copyright (c) 1990 UNIX System Laboratories, Inc.	*/
/*	Copyright (c) 1984, 1986, 1987, 1988, 1989, 1990 AT&T	*/
/*	  All Rights Reserved  	*/

/*	THIS IS UNPUBLISHED PROPRIETARY SOURCE CODE OF     	*/
/*	UNIX System Laboratories, Inc.                     	*/
/*	The copyright notice above does not evidence any   	*/
/*	actual or intended publication of such source code.	*/

#include "elftypes.h"

#define ELF32_FSZ_ADDR	4
#define ELF32_FSZ_HALF	2
#define ELF32_FSZ_OFF	4
#define ELF32_FSZ_SWORD	4
#define ELF32_FSZ_WORD	4


/*	"Enumerations" below use ...NUM as the number of
 *	values in the list.  It should be 1 greater than the
 *	highest "real" value.
 */


/*	ELF header
 */

#define EI_NIDENT	16

typedef struct {
	unsigned char	e_ident[EI_NIDENT];	/* ident bytes */
	Elf32_Half	e_type;			/* file type */
	Elf32_Half	e_machine;		/* target machine */
	Elf32_Word	e_version;		/* file version */
	Elf32_Addr	e_entry;		/* start address */
	Elf32_Off	e_phoff;		/* phdr file offset */
	Elf32_Off	e_shoff;		/* shdr file offset */
	Elf32_Word	e_flags;		/* file flags */
	Elf32_Half	e_ehsize;		/* sizeof ehdr */
	Elf32_Half	e_phentsize;		/* sizeof phdr */
	Elf32_Half	e_phnum;		/* number phdrs */
	Elf32_Half	e_shentsize;		/* sizeof shdr */
	Elf32_Half	e_shnum;		/* number shdrs */
	Elf32_Half	e_shstrndx;		/* shdr string index */
} Elf32_Ehdr;

#define EI_MAG0		0		/* e_ident[] indexes */
#define EI_MAG1		1
#define EI_MAG2		2
#define EI_MAG3		3
#define EI_CLASS	4
#define EI_DATA		5
#define EI_VERSION	6
#define EI_PAD		7

#define ELFMAG0		0x7f		/* EI_MAG */
#define ELFMAG1		'E'
#define ELFMAG2		'L'
#define ELFMAG3		'F'
#define ELFMAG		"\177ELF"
#define SELFMAG		4

#define ELFCLASSNONE	0		/* EI_CLASS */
#define ELFCLASS32	1
#define ELFCLASS64	2
#define ELFCLASSNUM	3

#define ELFDATANONE	0		/* EI_DATA */
#define ELFDATA2LSB	1
#define ELFDATA2MSB	2
#define ELFDATANUM	3

#define ET_NONE		0		/* e_type */
#define ET_REL		1
#define ET_EXEC		2
#define ET_DYN		3
#define ET_CORE		4
#define ET_NUM		5

#define	ET_LOPROC	0xff00		/* processor specific range */
#define	ET_HIPROC	0xffff

#define EM_NONE		0		/* e_machine */
#define EM_M32		1		/* AT&T WE 32100 */
#define EM_SPARC	2		/* Sun SPARC */
#define EM_386		3		/* Intel 80386 */
#define EM_68K		4		/* Motorola 68000 */
#define EM_88K		5		/* Motorola 88000 */
#define EM_486		6		/* Intel 80486 */
#define EM_860		7		/* Intel i860 */
#define EM_MIPS		8		/* MIPS family  */
#define EM_PPC_OLD      17              /* PowerPC family - EABI draft 1.0 */
#define EM_PPC          20              /* PowerPC family */
#define EM_ARM		40		/* ARM/Thumb family */
#define EM_SH           42              /* Hitachi SH family */

#define EV_NONE		0		/* e_version, EI_VERSION */
#define EV_CURRENT	1
#define EV_NUM		2


#ifdef m88k				/* this should moved to  elf88k.h */
#define EF_88K_SYSINUSER	0x2	/* e_flags */
#endif

/* Program header */

typedef struct {
	Elf32_Word	p_type;		/* entry type */
	Elf32_Off	p_offset;	/* file offset */
	Elf32_Addr	p_vaddr;	/* virtual address */
	Elf32_Addr	p_paddr;	/* physical address */
	Elf32_Word	p_filesz;	/* file size */
	Elf32_Word	p_memsz;	/* memory size */
	Elf32_Word	p_flags;	/* entry flags */
	Elf32_Word	p_align;	/* memory/file alignment */
} Elf32_Phdr;

#define PT_NULL		0		/* p_type */
#define PT_LOAD		1
#define PT_DYNAMIC	2
#define PT_INTERP	3
#define PT_NOTE		4
#define PT_SHLIB	5
#define PT_PHDR		6
#define PT_NUM		7

#define PT_LOPROC	0x70000000	/* processor specific range */
#define PT_HIPROC	0x7fffffff

#define PF_R		0x4		/* p_flags */
#define PF_W		0x2
#define PF_X		0x1

#define PF_MASKPROC	0xf0000000	/* processor specific values */


/* Section header */

typedef struct {
	Elf32_Word	sh_name;	/* section name */
	Elf32_Word	sh_type;	/* SHT_... */
	Elf32_Word	sh_flags;	/* SHF_... */
	Elf32_Addr	sh_addr;	/* virtual address */
	Elf32_Off	sh_offset;	/* file offset */
	Elf32_Word	sh_size;	/* section size */
	Elf32_Word	sh_link;	/* misc info */
	Elf32_Word	sh_info;	/* misc info */
	Elf32_Word	sh_addralign;	/* memory alignment */
	Elf32_Word	sh_entsize;	/* entry size if table */
} Elf32_Shdr;

#define SHT_NULL	0		/* sh_type */
#define SHT_PROGBITS	1
#define SHT_SYMTAB	2
#define SHT_STRTAB	3
#define SHT_RELA	4
#define SHT_HASH	5
#define SHT_DYNAMIC	6
#define SHT_NOTE	7
#define SHT_NOBITS	8
#define SHT_REL		9
#define SHT_SHLIB	10
#define SHT_DYNSYM	11
#define SHT_NUM		12
#define SHT_LOUSER	0x80000000
#define SHT_HIUSER	0xffffffff

#define	SHT_LOPROC	0x70000000	/* processor specific range */
#define	SHT_HIPROC	0x7fffffff

#define SHF_WRITE	0x1		/* sh_flags */
#define SHF_ALLOC	0x2
#define SHF_EXECINSTR	0x4

#define SHF_MASKPROC	0xf0000000	/* processor specific values */

#define SHN_UNDEF	0		/* special section numbers */
#define SHN_LORESERVE	0xff00
#define SHN_ABS		0xfff1
#define SHN_COMMON	0xfff2
#define SHN_HIRESERVE	0xffff

#define SHN_LOPROC	0xff00		/* processor specific range */
#define SHN_HIPROC	0xff1f

/* Symbol table */

typedef struct {
	Elf32_Word	st_name;
	Elf32_Addr	st_value;
	Elf32_Word	st_size;
	unsigned char	st_info;	/* bind, type: ELF_32_ST_... */
	unsigned char	st_other;
	Elf32_Half	st_shndx;	/* SHN_... */
} Elf32_Sym;

#define STN_UNDEF	0

/*	The macros compose and decompose values for S.st_info
 *
 *	bind = ELF32_ST_BIND(S.st_info)
 *	type = ELF32_ST_TYPE(S.st_info)
 *	S.st_info = ELF32_ST_INFO(bind, type)
 */

#define ELF32_ST_BIND(info)		((info) >> 4)
#define ELF32_ST_TYPE(info)		((info) & 0xf)
#define ELF32_ST_INFO(bind,type)	(((bind)<<4)+((type)&0xf))

#define STB_LOCAL	0		/* BIND */
#define STB_GLOBAL	1
#define STB_WEAK	2
#define STB_NUM		3

#define STB_LOPROC	13		/* processor specific range */
#define STB_HIPROC	15

#define STT_NOTYPE	0		/* TYPE */
#define STT_OBJECT	1
#define STT_FUNC	2
#define STT_SECTION	3
#define STT_FILE	4
#define STT_NUM		5

#define STT_LOPROC	13		/* processor specific range */
#define STT_HIPROC	15

/* 
 * The STT_ARM_TFUNC type is used by the gnu compiler to mark Thumb
 * functions.  The STT_ARM_16BIT type is the thumb equivalent of an
 * object.  They are not part of the ARM ABI or EABI - they come from gnu.
 */

#define STT_ARM_TFUNC   STT_LOPROC      /* Thumb function */
#define STT_ARM_16BIT   STT_HIPROC      /* Thumb label    */

/* Relocation */

typedef struct {
	Elf32_Addr	r_offset;
	Elf32_Word	r_info;		/* sym, type: ELF32_R_... */
} Elf32_Rel;

typedef struct {
	Elf32_Addr	r_offset;
	Elf32_Word	r_info;		/* sym, type: ELF32_R_... */
	Elf32_Sword	r_addend;
} Elf32_Rela;

/*	The macros compose and decompose values for Rel.r_info, Rela.f_info
 *
 *	sym = ELF32_R_SYM(R.r_info)
 *	type = ELF32_R_TYPE(R.r_info)
 *	R.r_info = ELF32_R_INFO(sym, type)
 */

#define ELF32_R_SYM(info)	((info)>>8)
#define ELF32_R_TYPE(info)	((unsigned char)(info))
#define ELF32_R_INFO(sym,type)	(((sym)<<8)+(unsigned char)(type))

#if CPU==SIMSPARCSOLARIS
/*
 * Simple values for n_type.  VxWorks symbol defines.
 */

#define N_UNDF  0x0             /* undefined */
#define N_ABS   0x2             /* absolute */
#define N_TEXT  0x4             /* text */
#define N_DATA  0x6             /* data */
#define N_BSS   0x8             /* bss */
#define N_COMM  0x12            /* common (internal to ld) */
#define N_FN    0x1f            /* file name symbol */

#define N_EXT   01              /* external bit, or'ed in */
#define N_TYPE  0x1e            /* mask for all the type bits */

#define MAX_SCNS        11
#define NO_SCNS         0
#endif /* if CPU==SIMSPARCSOLARIS */

#ifdef	CPU

#if FALSE			/* SPARC does not currently use elf */
	#if 	(CPU_FAMILY == SPARC)
	#include "arch/sparc/elfSparc.h"
	#endif	/* (CPU_FAMILY == SPARC) */
#endif /* FALSE */

#if 	(CPU_FAMILY == SIMSPARCSOLARIS)
#include "arch/simsolaris/elfSparc.h"
#endif	/* (CPU_FAMILY == SIMSPARCSOLARIS) */

#if	(CPU_FAMILY == MIPS)
#include "arch/mips/elfMips.h"
#endif	/* (CPU_FAMILY) */

#if     (CPU_FAMILY == PPC)
#include "arch/ppc/elfPpc.h"
#endif  /* (CPU_FAMILY) */

#if     (CPU_FAMILY == SH)
#include "arch/sh/elfSh.h"
#endif  /* (CPU_FAMILY) */

#if     (CPU_FAMILY == ARM)
#include "arch/arm/elfArm.h"
#endif  /* (CPU_FAMILY) */

#if     (CPU_FAMILY == COLDFIRE)
#include "arch/coldfire/elfColdfire.h"
#endif  /* (CPU_FAMILY) */

#endif	/* CPU */

#ifdef __cplusplus
}
#endif

#endif /* __INCelfh */
