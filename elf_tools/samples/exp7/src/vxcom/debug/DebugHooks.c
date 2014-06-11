/* DebugHooks.c -- Table of debug hooks  */

/* Copyright 2001 Wind River Systems, Inc. */

/*
modification history
--------------------
01c,01oct01,nel  Add hook for dcomShow printing string.
01b,26sep01,nel  Modify hooks to pass IP and Port.
01a,21aug01,nel  created
*/

/*
DESCRIPTION
This module holds a table of hooks that are placed at certain points in the code to
allow debug data to be passed to routines and processed into debug output.
*/

#include <stdio.h>
#include "vxidl.h"

/* RPC library hooks. */
void (*pRpcClientOutput)(const BYTE *, DWORD, const char *, int, int)	= NULL;
void (*pRpcClientInput)(const BYTE *, DWORD, const char *, int, int)	= NULL;
void (*pRpcServerOutput)(const BYTE *, DWORD, const char *, int, int)	= NULL;
void (*pRpcServerInput)(const BYTE *, DWORD, const char *, int, int)	= NULL;

/* DCOM Show hooks */
void (*pDcomShowPrintStr)(const char *) 				= NULL;

