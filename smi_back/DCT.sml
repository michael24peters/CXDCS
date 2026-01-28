class: TOP_DCS_Domain_v1_CLASS
!panel: DCS_Domain_v1.pnl
    state: NOT_READY
    !color: FwStateAttention1
        action: Switch_ON(string RUN_TYPE = "PHYSICS")	!visible: 1
            move_to READY
        action: Switch_OFF	!visible: 1
            move_to OFF
        action: Do_Emergency_OFF	!visible: 0
            move_to EMERGENCY_OFF
        action: Load(string RUN_TYPE = "PHYSICS")	!visible: 1
            move_to NOT_READY
        action: Reset	!visible: 1
            move_to NOT_READY
    state: READY
    !color: FwStateOKPhysics
        action: Switch_OFF	!visible: 1
            move_to OFF
        action: Do_Emergency_OFF	!visible: 0
            move_to EMERGENCY_OFF
        action: Reset	!visible: 1
            move_to NOT_READY
    state: OFF
    !color: FwStateOKNotPhysics
        action: Switch_ON(string RUN_TYPE = "PHYSICS")	!visible: 1
            move_to READY
        action: Do_Emergency_OFF	!visible: 0
            move_to EMERGENCY_OFF
        action: Reset	!visible: 1
            move_to NOT_READY
    state: ERROR
    !color: FwStateAttention3
        action: Recover	!visible: 1
            move_to NOT_READY
        action: Do_Emergency_OFF	!visible: 0
            move_to EMERGENCY_OFF
    state: EMERGENCY_OFF
    !color: FwStateAttention3
        action: Clear_Emergency	!visible: 2
            move_to NOT_READY

object: DCT is_of_class TOP_DCS_Domain_v1_CLASS

class: FwChildrenMode_CLASS
!panel: FwChildrenMode.pnl
    state: Complete
    !color: _3DFace
    state: Incomplete
    !color: FwStateAttention2
    state: IncompleteDev
    !color: FwStateAttention1
    state: IncompleteDead
    !color: FwStateAttention3

object: DCT_FWCNM is_of_class FwChildrenMode_CLASS

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

object: DCT_FWM is_of_class FwMode_CLASS


objectset: FWCHILDREN_FWSETACTIONS is_of_class VOID
objectset: FWCHILDREN_FWSETSTATES is_of_class VOID

