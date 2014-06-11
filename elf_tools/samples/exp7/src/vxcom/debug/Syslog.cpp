/* Syslog.cpp -- Encapsulate logging */

/* Copyright 1999 Wind River Systems, Inc. */

/*
modification history
--------------------
01w,17dec01,nel  Add include symbol for diab.
01v,24jul01,dbs  remove some solaris-specific code
01u,18jul01,dbs  clean up stray printfs
01t,17jul01,dbs  fix up includes
01s,19jan00,nel  Modifications for Linux debug build
01r,19aug99,aim  change assert to VXDCOM_ASSERT
01q,18aug99,aim  removed inline for SIMNT build
01p,10aug99,aim  change default Syslog level on target
01o,30jul99,aim  print thread id under solaris
01n,21jul99,aim  raised priority level for solaris build
01m,20jul99,aim  made LOG_ERR the default
01l,19jul99,aim  moved options to MSB
01k,16jul99,aim  fix UMR
01j,14jul99,aim  added syslogShow
01i,13jul99,aim  rework levels, facilities and options
01h,30jun99,aim  don't show base when printing taskId
01g,29jun99,aim  make defaultSyslog long-lived
01f,24jun99,aim  rework
01e,15jun99,aim  change call from ostream to stream
01d,03jun99,aim  change from fprintf to ostream
01c,02jun99,aim  fixes for solaris build
01b,05may99,aim  fixes for Win32
01a,30apr99,aim  made logging multi-task safe
*/

/* Include symbol for diab */
extern "C" int include_vxcom_Syslog (void)
    {
    return 0;
    }

#ifdef INCLUDE_VXDCOM_SYSLOG

#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <time.h>
#include <errno.h>
#include <iomanip>

#include "Syslog.h"
#include "private/comMisc.h"
#include "taskLib.h"

static const int MAX_FACILTIES = 28;
static const int MAX_FACILTIES_MASK = ((1 << MAX_FACILTIES) -1);

static const char *level [] =
    {
	"emergency",
	"alert",
	"critical",
	"error",
	"warning",
	"notice",
	"info",
        "debug",
    };

static struct facility_t
    {
    Syslog::FacilityId	facility;
    const char*		name;
    }
facilities[] =
    {
	{ LOG_TRACE_CALL,   "trace"      },
	{ LOG_REG,          "registry"   },
	{ LOG_MEM,          "memory"     },
	{ LOG_AUTH,         "auth"       },
	{ LOG_REFC,         "refc"       },
	{ LOG_REACTOR,      "reactor"    },
	{ LOG_SCM,          "scm"        },
	{ LOG_OBJ_EXPORTER, "objexp"     },
	{ LOG_COM,          "com"        },
	{ LOG_DCOM,         "dcom"       },
	{ LOG_RPC,          "rpc"        },
	{ 0, NULL }
    };

Syslog::Syslog (ostream* stream)
  : m_stream (stream),
    m_streamLock ()
    {
    ::memset (m_facility, 0, sizeof (m_facility));

    for (const facility_t* pf = facilities; pf->facility != 0; ++pf)
	facilityMask (pf->facility, logUpTo (LOG_ERR));

    // special case
    facilityMask (0, logUpTo (LOG_DEBUG));
    }

Syslog::~Syslog()
    {
    }

int Syslog::facilityIndex (FacilityId f) const
    {
    int b;			// number of bits set.
    
    for (b = 0; f != 0; f >>= 1)
	b++;

    return b;
    }

long Syslog::facilityMask (FacilityId facility, int mask)
    {
    int i = facilityIndex (facility);

    long oldmask = m_facility [i];

    if (mask != 0)
	m_facility [i] = mask;

    return oldmask;
    }

int Syslog::log (unsigned long logmask)
    {
    long p = logmask & LOG_DEBUG;
    long f = logmask >> 3 & MAX_FACILTIES_MASK;

    if ((logMask (p) & m_facility [facilityIndex (f)]) == 0)
	return 0;

    const char* fac = "unknown";
    const char* pri = "unknown";

    if (p >= LOG_EMERG && p <= LOG_DEBUG)
	pri = level[p];

    if (f != 0)
	{
	for (int i = 0; facilities[i].facility != 0; ++i)
	    if (facilities[i].facility == f)
		{
		fac = facilities[i].name;
		break;
		}
	}

    logOptions ();

    if (f && fac)
	stream () << fac << "." << pri << ": ";
    else
	stream () << pri << ": ";

    return 1;
    }

ostream& Syslog::logTime ()
    {
    char buf[26];		// this is not Y10K safe. ;-)
    char* pbuf = buf;

    time_t tloc;
    time (&tloc);

#if defined VXDCOM_PLATFORM_VXWORKS
    unsigned int len = 26;
    ::ctime_r (&tloc, buf, &len);
#else
    (void) ::strcpy (buf, ctime (&tloc));
#endif
    buf[19] = '\0';
    pbuf += 11;

    return stream () << pbuf << " ";
    }

ostream& Syslog::logTaskIdentity ()
    {
    return stream () << "["
		     << hex
		     << taskIdSelf ()
		     << dec
		     << ":"
		     << taskName (taskIdSelf ())
		     << "] ";
    }

ostream& Syslog::logOptions ()
    {
    // We just log all options for the moment.
    logTime ();
    logTaskIdentity ();
    return stream ();
    }

Syslog& Syslog::defaultSyslog ()
    {
    static Syslog* s_defaultSyslog = 0;

    // We `new' a Syslog and never delete it in case other objects need
    // to use it in their static destructors.

    if (s_defaultSyslog == 0)
	s_defaultSyslog = new Syslog ();

    COM_ASSERT (s_defaultSyslog);

    return *s_defaultSyslog;
    }

ostream& operator<< (ostream& os, const Syslog& s)
    {
    const facility_t* pf = facilities;
    
    os << "FID     Name       Levels set" << endl;
    os << "-------------------------------------------------------------------------------" << endl;

    while (pf->facility != 0)
	{
	long pmask = s.m_facility[s.facilityIndex (pf->facility)];

	os.setf (ios::left, ios::adjustfield);

	os << setw (8)
	   << pf->facility
	   << setw (10) 
	   << pf->name;

	for (int i = LOG_EMERG; i <= LOG_DEBUG; ++i)
	    if ((Syslog::logMask (i) & pmask) != 0)
		os << " " << level[i];

	os << endl << flush;

	++pf;
	}

    return os;
    }

ostream& Syslog::stream ()
    {
    return *m_stream;
    }

long Syslog::logUpTo (long priority)
    {
    return ((1 << (priority) +1) - 1);
    }

long Syslog::logMask (long priority)
    {
    return (1 << priority);
    }

void Syslog::streamLock ()
    {
    m_streamLock.lock ();
    }

void Syslog::streamUnlock ()
    {
    m_streamLock.unlock ();
    }

long vxdcomSyslogUpTo (long facility, int priority)
    {
    long oldmask = 0;

    oldmask = Syslog::defaultSyslog().facilityMask (facility, 0);

    Syslog::defaultSyslog().facilityMask (facility, Syslog::logUpTo (priority));

    return oldmask;
    }

void vxdcomSyslogShow (void)
    {
    cout << Syslog::defaultSyslog() << endl;
    }

// {{{ stuff

/******************************************************************************
*
* Syslog::taskName - returns the task name for tid
*
* RETURNS: none 
*
* NOMANUAL
*/

string Syslog::taskName (int tid)
    {
#if defined VXDCOM_PLATFORM_VXWORKS
    return string (::taskName (tid));
#else
    return string ("thread");
#endif
    }

/******************************************************************************
*
* Syslog::taskIdSelf - returns the tid of the current task
*
* RETURNS: none 
*
* NOMANUAL
*/

int Syslog::taskIdSelf ()
    {
    return ::taskIdSelf ();
    }

/******************************************************************************
*
* Syslog::taskNameToId - returns the tid for task name
*
* RETURNS: none 
*
* NOMANUAL
*/

int Syslog::taskNameToId (const char* name)
    {
#ifdef VXDCOM_PLATFORM_VXWORKS
    return ::taskNameToId (const_cast<char*> (name));
#else
    return 0;
#endif
    }

/******************************************************************************
*
* Syslog::sysErrorString - returns the error string for the current errno
*
* RETURNS: error string 
*
* NOMANUAL
*/

const char* Syslog::sysErrorString (int errorNumber)
    {
#if (defined VXDCOM_PLATFORM_SOLARIS || defined VXDCOM_PLATFORM_LINUX)
#ifndef strerror
    extern const char * const sys_errlist[];
    extern int sys_nerr;
#define strerror(n) \
        (((n) >= 0 && (n) < sys_nerr) ? sys_errlist[n] : "unknown error")
#endif
    return strerror (errorNumber);
#endif

    // XXX not reentrant
#ifdef VXDCOM_PLATFORM_VXWORKS
    char buf[32];
    sprintf (buf, "%x", errorNumber);
    return buf;
#endif
    }

// }}}

#endif // INCLUDE_VXDCOM_SYSLOG
