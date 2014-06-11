/* smUtilLib.h - include file for VxWorks shared memory utility library */

/* Copyright 1984-1999 Wind River Systems, Inc. */

/*
modification history
--------------------
02d,16mar99,dat  smUtilIntRoutine is made global (SPR 25804)
02c,09feb96,dat  chg'd arg for smUtilSoftTas to be volatile
02b,22sep92,rrr  added support for c++
02a,04jul92,jcf  cleaned up.
01c,23jun92,elh  cleanup.
01b,02jun92,elh  the tree shuffle
		  -changed includes to have absolute path from h/
01a,07feb92,elh	  created.
*/

#ifndef __INCsmUtilLibh
#define __INCsmUtilLibh

#ifdef __cplusplus
extern "C" {
#endif

/* includes */

#include "netinet/in.h"
#include "string.h"
#include "intLib.h"
#include "stdio.h"
#include "errno.h"

/* defines */

/* priority types of routines connected to shared memory interrupts */

#define LOW_PRIORITY  		0
#define HIGH_PRIORITY 		1


/* typedefs */

#if ((CPU_FAMILY==I960) && (defined __GNUC__))
#pragma align 1                 /* tell gcc960 not to optimize alignments */
#endif  /* CPU_FAMILY==I960 */

/* shared memory event handling routines */

typedef struct         /* SM_ROUTINE - shared memory routine */
    {
    FUNCPTR    routine;  /* routine to call */
    int        param;    /* routine parameter */
    } SM_ROUTINE;

#if ((CPU_FAMILY==I960) && (defined __GNUC__))
#pragma align 0                 /* turn off alignment requirement */
#endif  /* CPU_FAMILY==I960 */

/* function prototypes */

#if defined(__STDC__) || defined(__cplusplus)

extern STATUS 	smUtilMemProbe (char *pAddr, int op, int size, char *pVal);
extern BOOL 	smUtilSoftTas (volatile int * lockLocalAdrs);
extern BOOL 	smUtilTas (char * adrs);
extern void	smUtilTasClear (char *	adrs);
extern int 	smUtilProcNumGet (void);
extern STATUS 	smUtilDelay (char * pAddr, int ticks);
extern int 	smUtilRateGet (void);
extern STATUS 	smUtilIntGen (SM_CPU_DESC *pCpuDesc, int cpuNum);
extern STATUS 	smUtilIntConnect (int priorityType, FUNCPTR routine,
				  int param, int intType,
			          int intArg1, int intArg2, int intArg3);
extern void 	smUtilIntRoutine (void);
#else

extern STATUS 	smUtilMemProbe ();
extern BOOL 	smUtilSoftTas ();
extern BOOL 	smUtilTas ();
extern void	smUtilTasClear ();
extern int 	smUtilProcNumGet ();
extern STATUS 	smUtilDelay ();
extern int 	smUtilRateGet ();
extern STATUS 	smUtilIntGen ();
extern STATUS 	smUtilIntConnect ();
extern void 	smUtilIntRoutine ();

#endif	/* __STDC__ */

#ifdef __cplusplus
}
#endif

#endif /* __INCsmUtilLibh */
