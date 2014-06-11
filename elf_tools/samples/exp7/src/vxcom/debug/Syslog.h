/* Syslog.h -- System logger */

/* Copyright 1999 Wind River Systems, Inc. */

/*
modification history
--------------------
01m,17jul01,dbs  fix up includes
01l,19jan00,nel  Modifications for Linux debug build
01k,18aug99,aim  removed inline for SIMNT build
01j,30jul99,aim  added mutex for output serialisation
01i,19jul99,aim  moved options to MSB
01h,14jul99,aim  added syslogShow
01g,13jul99,aim  rework levels, facilities and options
01f,30jun99,aim  added S_PERROR
01e,25jun99,aim  changed debug identity
01d,24jun99,aim  rework
01c,03jun99,aim  change from fprintf to ostream
01b,02jun99,aim  fixes for solaris build
01a,30apr99,aim  made logging multi-task safe
*/

#ifndef __INCSyslog_h
#define __INCSyslog_h

// We #define these for convienence.  We would normally enumerate these
// within the class, however, they are used extensively outside of this
// class.  When logging we can S_DEBUG(LOG_MEM, "foo") instead of the
// more labrorious S_DEBUG(Syslog::SYSLOG_MEM, "foo").  On face value it
// doesn't look that bad, but when when you string a few options
// together it becomes a mess.  Hmmm.  So much for encapsulation.  This
// is against my normal practice.

// priorties
#define LOG_EMERG		0
#define LOG_ALERT		1
#define LOG_CRIT		2
#define LOG_ERR			3
#define LOG_WARN		4
#define LOG_NOTICE		5
#define LOG_INFO		6
#define LOG_DEBUG		7

// facilities
#define LOG_TRACE_CALL		1
#define LOG_REG			2
#define LOG_MEM			4
#define LOG_AUTH		8
#define LOG_REFC		16
#define LOG_REACTOR		32
#define LOG_SCM			64
#define LOG_OBJ_EXPORTER	128
#define LOG_COM			256
#define LOG_DCOM		512
#define LOG_RPC			1024

#define SYSLOG_MAX_FACILTIES	28

// options
#define LOG_ERRNO		(1 << SYSLOG_MAX_FACILTIES)

#ifdef INCLUDE_VXDCOM_SYSLOG

#include <iostream>
#include <string>
#include <errno.h>
#include "private/comMisc.h"

class Syslog
    {
  public:
    typedef long FacilityId;
    typedef long PriorityMask;

    virtual ~Syslog ();
    Syslog (ostream* = &cerr);

    int log (unsigned long logmask);
    ostream& stream ();
    long facilityMask (FacilityId, int mask);

    static Syslog& defaultSyslog ();
    static const char* sysErrorString (int n);
    static long logUpTo (long pri);
    static long logMask (long pri);

    void streamLock ();
    void streamUnlock ();
    
    friend ostream& operator<< (ostream&, const Syslog&);

  private:

    FacilityId		m_facility [32];
    ostream*		m_stream;
    VxMutex		m_streamLock;
    
    int facilityIndex (FacilityId) const;

    ostream& logOptions ();
    ostream& logTime ();
    ostream& logTaskIdentity ();

    static string taskName (int tid);
    static int taskIdSelf ();
    static int taskNameToId (const char* name);

    // unsupported
    Syslog (const Syslog& other);
    Syslog& operator= (const Syslog& rhs);
    };

extern "C" long vxdcomSyslogUpTo (long facility, int priority);
extern "C" void vxdcomSyslogShow (void);

#define SYSLOG_LOG Syslog::defaultSyslog().log
#define SYSLOG_STREAM Syslog::defaultSyslog().stream()
#define SYSLOG_LOCK_STREAM Syslog::defaultSyslog().streamLock()
#define SYSLOG_UNLOCK_STREAM Syslog::defaultSyslog().streamUnlock()

#define SYSLOG(A,B)													\
    {															\
    int ___syslog_saved_errno = errno;											\
    SYSLOG_LOCK_STREAM;													\
    if (SYSLOG_LOG(A))													\
        {														\
	if ((((A) >> 3) & LOG_ERRNO) && ___syslog_saved_errno != 0)							\
	    SYSLOG_STREAM << ##B << " (" << Syslog::sysErrorString (___syslog_saved_errno) << ")" << endl << flush;	\
	else														\
            SYSLOG_STREAM << ##B << endl << flush;									\
        }														\
    SYSLOG_UNLOCK_STREAM;												\
    }

#define S_EMERG(A,B)  SYSLOG(((A) << 3) | LOG_EMERG, B)
#define S_ALERT(A,B)  SYSLOG(((A) << 3) | LOG_ALERT, B)
#define S_CRIT(A,B)   SYSLOG(((A) << 3) | LOG_CRIT, B)
#define S_ERR(A,B)    SYSLOG(((A) << 3) | LOG_ERR, B)
#define S_WARN(A,B)   SYSLOG(((A) << 3) | LOG_WARN, B)
#define S_NOTICE(A,B) SYSLOG(((A) << 3) | LOG_NOTICE, B)
#define S_INFO(A,B)   SYSLOG(((A) << 3) | LOG_INFO, B)
#define S_DEBUG(A,B)  SYSLOG(((A) << 3) | LOG_DEBUG, B)

#else  // INCLUDE_VXDCOM_SYSLOG

#define S_EMERG(A, B)
#define S_ALERT(A, B)
#define S_CRIT(A, B)
#define S_ERR(A, B)
#define S_WARN(A, B)
#define S_NOTICE(A, B)
#define S_INFO(A, B)
#define S_DEBUG(A, B)
#define S_PERROR(A, B)

#endif // INCLUDE_VXDCOM_SYSLOG

#endif // __INCSyslog_h
