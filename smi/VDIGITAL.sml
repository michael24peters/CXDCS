class: TOP_DCS_Domain_v1_CLASS
!panel: DCS_Domain_v1.pnl
    state: NOT_READY
    !color: FwStateAttention1
        when ( any_in FWCAENCHANNELA2551_FWSETSTATES in_state {ERROR, EMERGENCY_OFF} )  move_to ERROR
        when ( all_in FWCAENCHANNELA2551_FWSETSTATES in_state OFF )  move_to OFF
        when ( all_in FWCAENCHANNELA2551_FWSETSTATES in_state READY )  move_to READY
        action: Switch_ON(string RUN_TYPE = "PHYSICS")	!visible: 1
            do Switch_ON(RUN_TYPE=RUN_TYPE) all_in FWCAENCHANNELA2551_FWSETACTIONS
            if ( any_in FWCAENCHANNELA2551_FWSETSTATES not_in_state READY )  then
              move_to NOT_READY
            endif
            move_to READY
        action: Switch_OFF	!visible: 1
            do Switch_OFF all_in FWCAENCHANNELA2551_FWSETACTIONS
            if ( any_in FWCAENCHANNELA2551_FWSETSTATES not_in_state OFF )  then
              move_to NOT_READY
            endif
            move_to OFF
        action: Do_Emergency_OFF	!visible: 0
            do Do_Emergency_OFF all_in FWCAENCHANNELA2551_FWSETACTIONS
            if ( any_in FWCAENCHANNELA2551_FWSETSTATES not_in_state EMERGENCY_OFF )  then
              move_to ERROR
            endif
            move_to EMERGENCY_OFF
        action: Load(string RUN_TYPE = "PHYSICS")	!visible: 1
            do Reset all_in FWCAENCHANNELA2551_FWSETACTIONS
            do LOAD(RUN_TYPE=RUN_TYPE,sMode=RUN_TYPE) all_in FWCAENCHANNELA2551_FWSETACTIONS
            move_to NOT_READY
        action: Reset	!visible: 1
            do Reset all_in FWCAENCHANNELA2551_FWSETACTIONS
            move_to NOT_READY
    state: READY
    !color: FwStateOKPhysics
        when ( any_in FWCAENCHANNELA2551_FWSETSTATES in_state {ERROR, EMERGENCY_OFF} )  move_to ERROR
        when ( all_in FWCAENCHANNELA2551_FWSETSTATES in_state OFF )  move_to OFF
        when ( any_in FWCAENCHANNELA2551_FWSETSTATES not_in_state READY )  move_to NOT_READY
        action: Switch_OFF	!visible: 1
            do Switch_OFF all_in FWCAENCHANNELA2551_FWSETACTIONS
            if ( any_in FWCAENCHANNELA2551_FWSETSTATES not_in_state OFF )  then
              move_to NOT_READY
            endif
            move_to OFF
        action: Do_Emergency_OFF	!visible: 0
            do Do_Emergency_OFF all_in FWCAENCHANNELA2551_FWSETACTIONS
            if ( any_in FWCAENCHANNELA2551_FWSETSTATES not_in_state EMERGENCY_OFF )  then
              move_to ERROR
            endif
            move_to EMERGENCY_OFF
        action: Reset	!visible: 1
            do Reset all_in FWCAENCHANNELA2551_FWSETACTIONS
            move_to NOT_READY
    state: OFF
    !color: FwStateOKNotPhysics
        when ( any_in FWCAENCHANNELA2551_FWSETSTATES in_state {ERROR, EMERGENCY_OFF} )  move_to ERROR
        when ( all_in FWCAENCHANNELA2551_FWSETSTATES in_state READY )  move_to READY
        when ( any_in FWCAENCHANNELA2551_FWSETSTATES not_in_state OFF )  move_to NOT_READY
        action: Switch_ON(string RUN_TYPE = "PHYSICS")	!visible: 1
            do Switch_ON(RUN_TYPE=RUN_TYPE) all_in FWCAENCHANNELA2551_FWSETACTIONS
            if ( any_in FWCAENCHANNELA2551_FWSETSTATES not_in_state READY )  then
              move_to NOT_READY
            endif
            move_to READY
        action: Do_Emergency_OFF	!visible: 0
            do Do_Emergency_OFF all_in FWCAENCHANNELA2551_FWSETACTIONS
            if ( any_in FWCAENCHANNELA2551_FWSETSTATES not_in_state EMERGENCY_OFF )  then
              move_to ERROR
            endif
            move_to EMERGENCY_OFF
        action: Reset	!visible: 1
            do Reset all_in FWCAENCHANNELA2551_FWSETACTIONS
            move_to NOT_READY
    state: ERROR
    !color: FwStateAttention3
        when ( all_in FWCAENCHANNELA2551_FWSETSTATES in_state EMERGENCY_OFF )  move_to EMERGENCY_OFF
        when ( all_in FWCAENCHANNELA2551_FWSETSTATES not_in_state {ERROR,EMERGENCY_OFF} )  move_to NOT_READY
        action: Recover	!visible: 1
            do Recover all_in FWCAENCHANNELA2551_FWSETACTIONS
            if ( any_in FWCAENCHANNELA2551_FWSETSTATES in_state ERROR )  then
                move_to ERROR
            endif
            move_to NOT_READY
        action: Do_Emergency_OFF	!visible: 0
            do Do_Emergency_OFF all_in FWCAENCHANNELA2551_FWSETACTIONS
            if ( any_in FWCAENCHANNELA2551_FWSETSTATES not_in_state EMERGENCY_OFF )  then
              move_to ERROR
            endif
            move_to EMERGENCY_OFF
    state: EMERGENCY_OFF
    !color: FwStateAttention3
        action: Clear_Emergency	!visible: 2
            do Clear_Emergency all_in FWCAENCHANNELA2551_FWSETACTIONS
            move_to NOT_READY

object: VDIGITAL is_of_class TOP_DCS_Domain_v1_CLASS

class: FwChildrenMode_CLASS
!panel: FwChildrenMode.pnl
    state: Complete
    !color: _3DFace
        when ( any_in FWDEVMODE_FWSETSTATES in_state DISABLED )  move_to IncompleteDev
    state: Incomplete
    !color: FwStateAttention2
    state: IncompleteDev
    !color: FwStateAttention1
        when (  ( all_in FWDEVMODE_FWSETSTATES not_in_state DISABLED )  ) move_to Complete
    state: IncompleteDead
    !color: FwStateAttention3

object: VDIGITAL_FWCNM is_of_class FwChildrenMode_CLASS

class: FwMode_CLASS
!panel: FwMode.pnl
    state: Excluded
    !color: FwStateOKNotPhysics
        action: Take(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 1
            move_to InLocal
        action: Include(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 0
            move_to Included
        action: Manual	!visible: 0
            move_to Manual
        action: Ignore	!visible: 0
            move_to Ignored
    state: Included
    !color: FwStateOKPhysics
        action: Exclude(string OWNER = "")	!visible: 0
            move_to Excluded
        action: Manual(string OWNER = "")	!visible: 0
            move_to Manual
        action: Ignore(string OWNER = "")	!visible: 0
            move_to Ignored
        action: ExcludeAll(string OWNER = "")	!visible: 0
            move_to Excluded
        action: Include(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 0
            move_to Included
        action: Free(string OWNER = "")	!visible: 0
            move_to Included
        action: SetMode(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 0
    state: InLocal
    !color: FwStateOKNotPhysics
        action: Release(string OWNER = "")	!visible: 1
            move_to Excluded
        action: ReleaseAll(string OWNER = "")	!visible: 1
            move_to Excluded
        action: SetMode(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 0
        action: Take(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 1
            move_to InLocal
    state: Manual
    !color: FwStateOKNotPhysics
        action: Include(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 0
            move_to Included
        action: Take(string OWNER = "")	!visible: 1
            move_to InManual
        action: Exclude(string OWNER = "")	!visible: 0
            move_to Excluded
        action: Ignore	!visible: 0
            move_to Ignored
        action: Free(string OWNER = "")	!visible: 0
            move_to Excluded
        action: ExcludeAll(string OWNER = "")	!visible: 0
            move_to Excluded
    state: InManual
    !color: FwStateOKNotPhysics
        action: Release(string OWNER = "")	!visible: 1
            move_to Manual
        action: SetMode(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 0
        action: ReleaseAll(string OWNER = "")	!visible: 0
            move_to Excluded
        action: SetInLocal	!visible: 0
            move_to InLocal
    state: Ignored
    !color: FwStateOKNotPhysics
        action: Include	!visible: 0
            move_to Included
        action: Exclude(string OWNER = "")	!visible: 0
            move_to Excluded
        action: Manual	!visible: 0
            move_to Manual
        action: SetMode(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 0
        action: Free(string OWNER = "")	!visible: 0
            move_to Included
        action: ExcludeAll(string OWNER = "")	!visible: 0
            move_to Excluded

object: VDIGITAL_FWM is_of_class FwMode_CLASS

class: FwCaenChannelA2551_FwDevMode_CLASS
    state: READY
        action: Disable(Device)
            remove &VAL_OF_Device from FWCAENCHANNELA2551_FWSETSTATES
            remove &VAL_OF_Device from FWCAENCHANNELA2551_FWSETACTIONS
            move_to READY
        action: Enable(Device)
            insert &VAL_OF_Device in FWCAENCHANNELA2551_FWSETSTATES
            insert &VAL_OF_Device in FWCAENCHANNELA2551_FWSETACTIONS
            move_to READY

object: FwCaenChannelA2551_FWDM is_of_class FwCaenChannelA2551_FwDevMode_CLASS


class: FwCaenChannelA2551_CLASS/associated
!panel: FwCaenChannelA2551.pnl
    parameters: string EXTERNALY = "UNKNOWN"
    state: READY
    !color: FwStateOKPhysics
        action: Switch_OFF	!visible: 1
        action: Do_Emergency_OFF	!visible: 0
    state: OFF
    !color: FwStateOKNotPhysics
        action: Switch_ON(string RUN_TYPE = "PHYSICS")	!visible: 1
        action: Do_Emergency_OFF	!visible: 0
    state: ERROR
    !color: FwStateAttention3
        action: Recover	!visible: 1
    state: EMERGENCY_OFF
    !color: FwStateAttention3
        action: Clear_Emergency	!visible: 1
    state: NOT_READY
    !color: FwStateAttention1
        action: Do_Emergency_OFF	!visible: 0
        action: Switch_OFF	!visible: 1

object: CAEN:cxcaen01:board10:channel003 is_of_class FwCaenChannelA2551_CLASS

object: CAEN:cxcaen01:board10:channel007 is_of_class FwCaenChannelA2551_CLASS

object: CAEN:cxcaen01:board11:channel003 is_of_class FwCaenChannelA2551_CLASS

object: CAEN:cxcaen01:board11:channel007 is_of_class FwCaenChannelA2551_CLASS

object: CAEN:cxcaen01:board12:channel003 is_of_class FwCaenChannelA2551_CLASS

object: CAEN:cxcaen01:board12:channel007 is_of_class FwCaenChannelA2551_CLASS

object: CAEN:cxcaen01:board13:channel003 is_of_class FwCaenChannelA2551_CLASS

objectset: FWCAENCHANNELA2551_FWSETSTATES is_of_class VOID {CAEN:cxcaen01:board10:channel003,
	CAEN:cxcaen01:board10:channel007,
	CAEN:cxcaen01:board11:channel003,
	CAEN:cxcaen01:board11:channel007,
	CAEN:cxcaen01:board12:channel003,
	CAEN:cxcaen01:board12:channel007,
	CAEN:cxcaen01:board13:channel003 }
objectset: FWCAENCHANNELA2551_FWSETACTIONS is_of_class VOID {CAEN:cxcaen01:board10:channel003,
	CAEN:cxcaen01:board10:channel007,
	CAEN:cxcaen01:board11:channel003,
	CAEN:cxcaen01:board11:channel007,
	CAEN:cxcaen01:board12:channel003,
	CAEN:cxcaen01:board12:channel007,
	CAEN:cxcaen01:board13:channel003 }

class: FwDevMode_FwDevMode_CLASS
    state: READY
        action: Disable(Device)
            remove &VAL_OF_Device from FWDEVMODE_FWSETSTATES
            remove &VAL_OF_Device from FWDEVMODE_FWSETACTIONS
            move_to READY
        action: Enable(Device)
            insert &VAL_OF_Device in FWDEVMODE_FWSETSTATES
            insert &VAL_OF_Device in FWDEVMODE_FWSETACTIONS
            move_to READY

object: FwDevMode_FWDM is_of_class FwDevMode_FwDevMode_CLASS


class: FwDevMode_CLASS/associated
!panel: FwDevMode.pnl
    state: ENABLED
    !color: FwStateOKPhysics
    state: DISABLED
    !color: FwStateAttention1

object: VDIGITAL_FWDM is_of_class FwDevMode_CLASS

objectset: FWDEVMODE_FWSETSTATES is_of_class VOID {VDIGITAL_FWDM }
objectset: FWDEVMODE_FWSETACTIONS is_of_class VOID {VDIGITAL_FWDM }


objectset: FWCHILDREN_FWSETACTIONS union {FWCAENCHANNELA2551_FWSETACTIONS } is_of_class VOID
objectset: FWCHILDREN_FWSETSTATES union {FWCAENCHANNELA2551_FWSETSTATES } is_of_class VOID

