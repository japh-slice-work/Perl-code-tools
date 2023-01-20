/*++
    Sample file
--*/

#ifndef PM_DEFS_H
#define PM_DEFS_H
#define VP_SOCKET_ADDRESS  "127.0.0.1;9998"

#include <Windows.h>
typedef struct _PM_CMD_LUT {
	int value;
	char * text;
} PM_CMD_LUT;
/** 
 * @brief PM_OPS Enumeration
 */
typedef enum _PM_ACTS {
	PMACT_GOTOMEETING,
	PMACT_GOTODESK,
	PMACT_IDLE,
	PMACT_WORK,
	PMACT_PLACEHOLDER
} PM_ACTS;
typedef enum _PM_OPS {
   PMOP_NOP = 0,
   PMOP_GRST,
   PMOP_CSERST,
   PMOP_CSMERST=PMOP_CSERST,
   PMOP_PCR,
   PMOP_NPCR,
} PM_OPS;
