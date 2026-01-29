class: TOP_DCS_Domain_v1_CLASS
!panel: DCS_Domain_v1.pnl
    state: NOT_READY
    !color: FwStateAttention1
        when ( any_in DCS_DOMAIN_V1_FWSETSTATES in_state {ERROR, EMERGENCY_OFF} )  move_to ERROR
        when ( all_in DCS_DOMAIN_V1_FWSETSTATES in_state OFF )  move_to OFF
        when ( all_in DCS_DOMAIN_V1_FWSETSTATES in_state READY )  move_to READY
        action: Switch_ON(string RUN_TYPE = "PHYSICS")	!visible: 1
            do Switch_ON(RUN_TYPE=RUN_TYPE) all_in DCS_DOMAIN_V1_FWSETACTIONS
            if ( any_in DCS_DOMAIN_V1_FWSETSTATES not_in_state READY )  then
              move_to NOT_READY
            endif
            move_to READY
        action: Switch_OFF	!visible: 1
            do Switch_OFF all_in DCS_DOMAIN_V1_FWSETACTIONS
            if ( any_in DCS_DOMAIN_V1_FWSETSTATES not_in_state OFF )  then
              move_to NOT_READY
            endif
            move_to OFF
        action: Do_Emergency_OFF	!visible: 0
            do Do_Emergency_OFF all_in DCS_DOMAIN_V1_FWSETACTIONS
            if ( any_in DCS_DOMAIN_V1_FWSETSTATES not_in_state EMERGENCY_OFF )  then
              move_to ERROR
            endif
            move_to EMERGENCY_OFF
        action: Load(string RUN_TYPE = "PHYSICS")	!visible: 1
            do Reset all_in DCS_DOMAIN_V1_FWSETACTIONS
            do LOAD(RUN_TYPE=RUN_TYPE,sMode=RUN_TYPE) all_in DCS_DOMAIN_V1_FWSETACTIONS
            move_to NOT_READY
        action: Reset	!visible: 1
            do Reset all_in DCS_DOMAIN_V1_FWSETACTIONS
            move_to NOT_READY
    state: READY
    !color: FwStateOKPhysics
        when ( any_in DCS_DOMAIN_V1_FWSETSTATES in_state {ERROR, EMERGENCY_OFF} )  move_to ERROR
        when ( all_in DCS_DOMAIN_V1_FWSETSTATES in_state OFF )  move_to OFF
        when ( any_in DCS_DOMAIN_V1_FWSETSTATES not_in_state READY )  move_to NOT_READY
        action: Switch_OFF	!visible: 1
            do Switch_OFF all_in DCS_DOMAIN_V1_FWSETACTIONS
            if ( any_in DCS_DOMAIN_V1_FWSETSTATES not_in_state OFF )  then
              move_to NOT_READY
            endif
            move_to OFF
        action: Do_Emergency_OFF	!visible: 0
            do Do_Emergency_OFF all_in DCS_DOMAIN_V1_FWSETACTIONS
            if ( any_in DCS_DOMAIN_V1_FWSETSTATES not_in_state EMERGENCY_OFF )  then
              move_to ERROR
            endif
            move_to EMERGENCY_OFF
        action: Reset	!visible: 1
            do Reset all_in DCS_DOMAIN_V1_FWSETACTIONS
            move_to NOT_READY
    state: OFF
    !color: FwStateOKNotPhysics
        when ( any_in DCS_DOMAIN_V1_FWSETSTATES in_state {ERROR, EMERGENCY_OFF} )  move_to ERROR
        when ( all_in DCS_DOMAIN_V1_FWSETSTATES in_state READY )  move_to READY
        when ( any_in DCS_DOMAIN_V1_FWSETSTATES not_in_state OFF )  move_to NOT_READY
        action: Switch_ON(string RUN_TYPE = "PHYSICS")	!visible: 1
            do Switch_ON(RUN_TYPE=RUN_TYPE) all_in DCS_DOMAIN_V1_FWSETACTIONS
            if ( any_in DCS_DOMAIN_V1_FWSETSTATES not_in_state READY )  then
              move_to NOT_READY
            endif
            move_to READY
        action: Do_Emergency_OFF	!visible: 0
            do Do_Emergency_OFF all_in DCS_DOMAIN_V1_FWSETACTIONS
            if ( any_in DCS_DOMAIN_V1_FWSETSTATES not_in_state EMERGENCY_OFF )  then
              move_to ERROR
            endif
            move_to EMERGENCY_OFF
        action: Reset	!visible: 1
            do Reset all_in DCS_DOMAIN_V1_FWSETACTIONS
            move_to NOT_READY
    state: ERROR
    !color: FwStateAttention3
        when ( all_in DCS_DOMAIN_V1_FWSETSTATES in_state EMERGENCY_OFF )  move_to EMERGENCY_OFF
        when ( all_in DCS_DOMAIN_V1_FWSETSTATES not_in_state {ERROR,EMERGENCY_OFF} )  move_to NOT_READY
        action: Recover	!visible: 1
            do Recover all_in DCS_DOMAIN_V1_FWSETACTIONS
            if ( any_in DCS_DOMAIN_V1_FWSETSTATES in_state ERROR )  then
                move_to ERROR
            endif
            move_to NOT_READY
        action: Do_Emergency_OFF	!visible: 0
            do Do_Emergency_OFF all_in DCS_DOMAIN_V1_FWSETACTIONS
            if ( any_in DCS_DOMAIN_V1_FWSETSTATES not_in_state EMERGENCY_OFF )  then
              move_to ERROR
            endif
            move_to EMERGENCY_OFF
    state: EMERGENCY_OFF
    !color: FwStateAttention3
        action: Clear_Emergency	!visible: 2
            do Clear_Emergency all_in DCS_DOMAIN_V1_FWSETACTIONS
            move_to NOT_READY

object: CODEXB_DCS is_of_class TOP_DCS_Domain_v1_CLASS

class: FwChildrenMode_CLASS
!panel: FwChildrenMode.pnl
    state: Complete
    !color: _3DFace
        when ( any_in FWCHILDRENMODE_FWSETSTATES in_state IncompleteDead ) move_to IncompleteDead
        when (  ( any_in FWCHILDRENMODE_FWSETSTATES in_state DEAD ) and ( any_in FWCHILDMODE_FWSETSTATES in_state MANUAL )  ) move_to IncompleteDead
        when ( any_in FWCHILDRENMODE_FWSETSTATES in_state Incomplete )  move_to Incomplete
        when ( any_in FWCHILDMODE_FWSETSTATES not_in_state {Included,ExcludedPerm,LockedOutPerm} )  move_to Incomplete
        when ( any_in FWCHILDRENMODE_FWSETSTATES in_state IncompleteDev )  move_to IncompleteDev
    state: Incomplete
    !color: FwStateAttention2
        when ( any_in FWCHILDRENMODE_FWSETSTATES in_state IncompleteDead ) move_to IncompleteDead
        when (  ( any_in FWCHILDRENMODE_FWSETSTATES in_state DEAD ) and ( any_in FWCHILDMODE_FWSETSTATES in_state MANUAL )  ) move_to IncompleteDead
        when (  ( all_in FWCHILDMODE_FWSETSTATES in_state {Included,ExcludedPerm,LockedOutPerm} ) and
       ( all_in FWCHILDRENMODE_FWSETSTATES not_in_state Incomplete )  )  move_to Complete
    state: IncompleteDev
    !color: FwStateAttention1
        when ( any_in FWCHILDRENMODE_FWSETSTATES in_state IncompleteDead ) move_to IncompleteDead
        when (  ( any_in FWCHILDRENMODE_FWSETSTATES in_state DEAD ) and ( any_in FWCHILDMODE_FWSETSTATES in_state MANUAL )  ) move_to IncompleteDead
        when (  ( any_in FWCHILDMODE_FWSETSTATES not_in_state {Included,ExcludedPerm,LockedOutPerm} ) or
       ( any_in FWCHILDRENMODE_FWSETSTATES in_state Incomplete )  )  move_to Incomplete
        when (  ( all_in FWCHILDRENMODE_FWSETSTATES not_in_state IncompleteDev )  ) move_to Complete
    state: IncompleteDead
    !color: FwStateAttention3
        when (  (  ( all_in FWCHILDRENMODE_FWSETSTATES not_in_state DEAD ) or ( all_in FWCHILDMODE_FWSETSTATES not_in_state MANUAL )  ) and ( all_in FWCHILDRENMODE_FWSETSTATES not_in_state IncompleteDead )  )  move_to Complete

object: CODEXB_DCS_FWCNM is_of_class FwChildrenMode_CLASS

class: ASS_FwChildrenMode_CLASS/associated
!panel: FwChildrenMode.pnl
    state: Complete
    !color: _3DFace
    state: Incomplete
    !color: FwStateAttention2
    state: IncompleteDev
    !color: FwStateAttention1
    state: IncompleteDead
    !color: FwStateAttention3

object: CODEXB_DCT_LV::CODEXB_DCT_LV_FWCNM is_of_class ASS_FwChildrenMode_CLASS

object: CODEXB_VANALOG::CODEXB_VANALOG_FWCNM is_of_class ASS_FwChildrenMode_CLASS

object: CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWCNM is_of_class ASS_FwChildrenMode_CLASS

object: CODEXB_VSENSE::CODEXB_VSENSE_FWCNM is_of_class ASS_FwChildrenMode_CLASS

object: CODEXB_VTHETA::CODEXB_VTHETA_FWCNM is_of_class ASS_FwChildrenMode_CLASS

object: CODEXB_VTHPHI::CODEXB_VTHPHI_FWCNM is_of_class ASS_FwChildrenMode_CLASS

objectset: FWCHILDRENMODE_FWSETSTATES is_of_class VOID

class: FwMode_CLASS
!panel: FwMode.pnl
    state: Excluded
    !color: FwStateOKNotPhysics
        action: Take(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 1
            do Include(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) all_in FWCHILDMODE_FWSETACTIONS
            move_to InLocal
        action: Include(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 0
            do Include(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) all_in FWCHILDMODE_FWSETACTIONS
            move_to Included
        action: Manual	!visible: 0
            move_to Manual
        action: Ignore	!visible: 0
            move_to Ignored
    state: Included
    !color: FwStateOKPhysics
        action: Exclude(string OWNER = "")	!visible: 0
            do Free(OWNER=OWNER) all_in FWCHILDMODE_FWSETACTIONS
            move_to Excluded
        action: Manual(string OWNER = "")	!visible: 0
            do Free(OWNER=OWNER) all_in FWCHILDMODE_FWSETACTIONS
            move_to Manual
        action: Ignore(string OWNER = "")	!visible: 0
            move_to Ignored
        action: ExcludeAll(string OWNER = "")	!visible: 0
            do ExcludeAll(OWNER=OWNER) all_in FWCHILDMODE_FWSETACTIONS
            move_to Excluded
        action: Include(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 0
            do Include(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) all_in FWCHILDMODE_FWSETACTIONS
            move_to Included
        action: Free(string OWNER = "")	!visible: 0
            do Free(OWNER=OWNER) all_in FWCHILDMODE_FWSETACTIONS
            move_to Included
        action: SetMode(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 0
            do SetMode(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) all_in FWCHILDMODE_FWSETACTIONS
    state: InLocal
    !color: FwStateOKNotPhysics
        action: Release(string OWNER = "")	!visible: 1
            do Free(OWNER=OWNER) all_in FWCHILDMODE_FWSETACTIONS
            move_to Excluded
        action: ReleaseAll(string OWNER = "")	!visible: 1
            do ExcludeAll(OWNER=OWNER) all_in FWCHILDMODE_FWSETACTIONS
            move_to Excluded
        action: SetMode(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 0
            do SetMode(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) all_in FWCHILDMODE_FWSETACTIONS
        action: Take(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 1
            do Include(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) all_in FWCHILDMODE_FWSETACTIONS
            move_to InLocal
    state: Manual
    !color: FwStateOKNotPhysics
        action: Include(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 0
            do Include(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) all_in FWCHILDMODE_FWSETACTIONS
            move_to Included
        action: Take(string OWNER = "")	!visible: 1
            do Include(OWNER=OWNER) all_in FWCHILDMODE_FWSETACTIONS
            move_to InManual
        action: Exclude(string OWNER = "")	!visible: 0
            do Exclude(OWNER=OWNER) all_in FWCHILDMODE_FWSETACTIONS
            move_to Excluded
        action: Ignore	!visible: 0
            move_to Ignored
        action: Free(string OWNER = "")	!visible: 0
            do Free(OWNER=OWNER) all_in FWCHILDMODE_FWSETACTIONS
            move_to Excluded
        action: ExcludeAll(string OWNER = "")	!visible: 0
            do ExcludeAll(OWNER=OWNER) all_in FWCHILDMODE_FWSETACTIONS
            move_to Excluded
    state: InManual
    !color: FwStateOKNotPhysics
        action: Release(string OWNER = "")	!visible: 1
            do Free(OWNER=OWNER) all_in FWCHILDMODE_FWSETACTIONS
            move_to Manual
        action: SetMode(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 0
            do SetMode(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) all_in FWCHILDMODE_FWSETACTIONS
        action: ReleaseAll(string OWNER = "")	!visible: 0
            do ExcludeAll(OWNER=OWNER) all_in FWCHILDMODE_FWSETACTIONS
            move_to Excluded
        action: SetInLocal	!visible: 0
            move_to InLocal
    state: Ignored
    !color: FwStateOKNotPhysics
        action: Include	!visible: 0
            move_to Included
        action: Exclude(string OWNER = "")	!visible: 0
            do Exclude(OWNER=OWNER) all_in FWCHILDMODE_FWSETACTIONS
            move_to Excluded
        action: Manual	!visible: 0
            move_to Manual
        action: SetMode(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 0
            do SetMode(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) all_in FWCHILDMODE_FWSETACTIONS
        action: Free(string OWNER = "")	!visible: 0
            do Free(OWNER=OWNER) all_in FWCHILDMODE_FWSETACTIONS
            move_to Included
        action: ExcludeAll(string OWNER = "")	!visible: 0
            do ExcludeAll(OWNER=OWNER) all_in FWCHILDMODE_FWSETACTIONS
            move_to Excluded

object: CODEXB_DCS_FWM is_of_class FwMode_CLASS

class: ASS_FwMode_CLASS/associated
!panel: FwMode.pnl
    state: Excluded
    !color: FwStateOKNotPhysics
        action: Take(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 1
        action: Include(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 0
        action: Manual	!visible: 0
        action: Ignore	!visible: 0
    state: Included
    !color: FwStateOKPhysics
        action: Exclude(string OWNER = "")	!visible: 0
        action: Manual(string OWNER = "")	!visible: 0
        action: Ignore(string OWNER = "")	!visible: 0
        action: ExcludeAll(string OWNER = "")	!visible: 0
        action: Include(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 0
        action: Free(string OWNER = "")	!visible: 0
        action: SetMode(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 0
    state: InLocal
    !color: FwStateOKNotPhysics
        action: Release(string OWNER = "")	!visible: 1
        action: ReleaseAll(string OWNER = "")	!visible: 1
        action: SetMode(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 0
        action: Take(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 1
    state: Manual
    !color: FwStateOKNotPhysics
        action: Include(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 0
        action: Take(string OWNER = "")	!visible: 1
        action: Exclude(string OWNER = "")	!visible: 0
        action: Ignore	!visible: 0
        action: Free(string OWNER = "")	!visible: 0
        action: ExcludeAll(string OWNER = "")	!visible: 0
    state: InManual
    !color: FwStateOKNotPhysics
        action: Release(string OWNER = "")	!visible: 1
        action: SetMode(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 0
        action: ReleaseAll(string OWNER = "")	!visible: 0
        action: SetInLocal	!visible: 0
    state: Ignored
    !color: FwStateOKNotPhysics
        action: Include	!visible: 0
        action: Exclude(string OWNER = "")	!visible: 0
        action: Manual	!visible: 0
        action: SetMode(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 0
        action: Free(string OWNER = "")	!visible: 0
        action: ExcludeAll(string OWNER = "")	!visible: 0

object: CODEXB_DCT_LV::CODEXB_DCT_LV_FWM is_of_class ASS_FwMode_CLASS

object: CODEXB_VANALOG::CODEXB_VANALOG_FWM is_of_class ASS_FwMode_CLASS

object: CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM is_of_class ASS_FwMode_CLASS

object: CODEXB_VSENSE::CODEXB_VSENSE_FWM is_of_class ASS_FwMode_CLASS

object: CODEXB_VTHETA::CODEXB_VTHETA_FWM is_of_class ASS_FwMode_CLASS

object: CODEXB_VTHPHI::CODEXB_VTHPHI_FWM is_of_class ASS_FwMode_CLASS

class: CODEXB_DCT_LV_FwChildMode_CLASS

!panel: FwChildMode.pnl
    state: Excluded
    !color: FwStateOKNotPhysics
        action: Include(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 1
            if ( CODEXB_DCT_LV::CODEXB_DCT_LV_FWM in_state Dead ) then
              move_to Manual
            endif
            if ( CODEXB_DCT_LV::CODEXB_DCT_LV_FWM not_in_state {Excluded, Manual} ) then
            !    else
                    move_to Excluded
            !    endif
            else
                do Include(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) CODEXB_DCT_LV::CODEXB_DCT_LV_FWM
                insert CODEXB_DCT_LV::CODEXB_DCT_LV in DCS_DOMAIN_V1_FWSETSTATES
                insert CODEXB_DCT_LV::CODEXB_DCT_LV in DCS_DOMAIN_V1_FWSETACTIONS
                insert CODEXB_DCT_LV::CODEXB_DCT_LV_FWCNM in FWCHILDRENMODE_FWSETSTATES
            endif
            move_to Included
        action: Manual	!visible: 0
            do Manual CODEXB_DCT_LV::CODEXB_DCT_LV_FWM
            insert CODEXB_DCT_LV::CODEXB_DCT_LV in DCS_DOMAIN_V1_FWSETSTATES
            remove CODEXB_DCT_LV::CODEXB_DCT_LV from DCS_DOMAIN_V1_FWSETACTIONS
            move_to Manual
        action: Ignore	!visible: 0
            do Ignore CODEXB_DCT_LV::CODEXB_DCT_LV_FWM
            insert CODEXB_DCT_LV::CODEXB_DCT_LV in DCS_DOMAIN_V1_FWSETACTIONS
            remove CODEXB_DCT_LV::CODEXB_DCT_LV from DCS_DOMAIN_V1_FWSETSTATES
            move_to Ignored
        action: LockOut	!visible: 1
            move_to LockedOut
        action: Exclude(string OWNER = "")	!visible: 1
            do Exclude(OWNER=OWNER) CODEXB_DCT_LV::CODEXB_DCT_LV_FWM
            remove CODEXB_DCT_LV::CODEXB_DCT_LV from DCS_DOMAIN_V1_FWSETSTATES
            remove CODEXB_DCT_LV::CODEXB_DCT_LV from DCS_DOMAIN_V1_FWSETACTIONS
            remove CODEXB_DCT_LV::CODEXB_DCT_LV_FWCNM from FWCHILDRENMODE_FWSETSTATES
            move_to Excluded
        action: ExcludePerm(string OWNER = "")	!visible: 0
            move_to ExcludedPerm
        action: Exclude&LockOut(string OWNER = "")	!visible: 0
            move_to LockedOut
    state: Included
    !color: FwStateOKPhysics
        when ( CODEXB_DCT_LV::CODEXB_DCT_LV_FWM in_state Excluded )  do Exclude
        when ( CODEXB_DCT_LV::CODEXB_DCT_LV_FWM in_state Ignored )  move_to IGNORED
        when ( CODEXB_DCT_LV::CODEXB_DCT_LV_FWM in_state Manual )  move_to MANUAL
        when ( CODEXB_DCT_LV::CODEXB_DCT_LV_FWM in_state Dead )  do Manual
        action: Exclude(string OWNER = "")	!visible: 1
            if ( CODEXB_DCT_LV::CODEXB_DCT_LV_FWM not_in_state Included ) then
                if ( CODEXB_DCT_LV::CODEXB_DCT_LV_FWM in_state InManual ) then
                    do Release(OWNER=OWNER) CODEXB_DCT_LV::CODEXB_DCT_LV_FWM
                    remove CODEXB_DCT_LV::CODEXB_DCT_LV from DCS_DOMAIN_V1_FWSETSTATES
                    remove CODEXB_DCT_LV::CODEXB_DCT_LV from DCS_DOMAIN_V1_FWSETACTIONS
                    remove CODEXB_DCT_LV::CODEXB_DCT_LV_FWCNM from FWCHILDRENMODE_FWSETSTATES
                else
                        do Exclude(OWNER=OWNER) CODEXB_DCT_LV::CODEXB_DCT_LV_FWM
                        remove CODEXB_DCT_LV::CODEXB_DCT_LV from DCS_DOMAIN_V1_FWSETSTATES
                        remove CODEXB_DCT_LV::CODEXB_DCT_LV from DCS_DOMAIN_V1_FWSETACTIONS
                        remove CODEXB_DCT_LV::CODEXB_DCT_LV_FWCNM from FWCHILDRENMODE_FWSETSTATES
            !       else
            !            move_to Included
            !        endif
                endif
            else
                do Exclude(OWNER=OWNER) CODEXB_DCT_LV::CODEXB_DCT_LV_FWM
                remove CODEXB_DCT_LV::CODEXB_DCT_LV from DCS_DOMAIN_V1_FWSETSTATES
                remove CODEXB_DCT_LV::CODEXB_DCT_LV from DCS_DOMAIN_V1_FWSETACTIONS
                remove CODEXB_DCT_LV::CODEXB_DCT_LV_FWCNM from FWCHILDRENMODE_FWSETSTATES
            endif
            move_to Excluded
        action: Manual(string OWNER = "")	!visible: 1
            do Manual(OWNER=OWNER) CODEXB_DCT_LV::CODEXB_DCT_LV_FWM
            insert CODEXB_DCT_LV::CODEXB_DCT_LV in DCS_DOMAIN_V1_FWSETSTATES
            remove CODEXB_DCT_LV::CODEXB_DCT_LV from DCS_DOMAIN_V1_FWSETACTIONS
            move_to Manual
        action: Ignore(string OWNER = "")	!visible: 1
            do Ignore(OWNER=OWNER) CODEXB_DCT_LV::CODEXB_DCT_LV_FWM
            insert CODEXB_DCT_LV::CODEXB_DCT_LV in DCS_DOMAIN_V1_FWSETACTIONS
            remove CODEXB_DCT_LV::CODEXB_DCT_LV from DCS_DOMAIN_V1_FWSETSTATES
            move_to Ignored
        action: ExcludeAll(string OWNER = "")	!visible: 1
            if ( CODEXB_DCT_LV::CODEXB_DCT_LV_FWM not_in_state {Included,Ignored,Manual} ) then
                if ( CODEXB_DCT_LV::CODEXB_DCT_LV_FWM in_state InManual ) then
                    do ReleaseAll(OWNER=OWNER) CODEXB_DCT_LV::CODEXB_DCT_LV_FWM
                    remove CODEXB_DCT_LV::CODEXB_DCT_LV from DCS_DOMAIN_V1_FWSETSTATES
                    remove CODEXB_DCT_LV::CODEXB_DCT_LV from DCS_DOMAIN_V1_FWSETACTIONS
                    remove CODEXB_DCT_LV::CODEXB_DCT_LV_FWCNM from FWCHILDRENMODE_FWSETSTATES
                else
                    move_to Included
                endif
            else
                do ExcludeAll(OWNER=OWNER) CODEXB_DCT_LV::CODEXB_DCT_LV_FWM
                remove CODEXB_DCT_LV::CODEXB_DCT_LV from DCS_DOMAIN_V1_FWSETSTATES
                remove CODEXB_DCT_LV::CODEXB_DCT_LV from DCS_DOMAIN_V1_FWSETACTIONS
                remove CODEXB_DCT_LV::CODEXB_DCT_LV_FWCNM from FWCHILDRENMODE_FWSETSTATES
            endif
            move_to Excluded
        action: Include(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 1
            do Include(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) CODEXB_DCT_LV::CODEXB_DCT_LV_FWM
            insert CODEXB_DCT_LV::CODEXB_DCT_LV in DCS_DOMAIN_V1_FWSETSTATES
            insert CODEXB_DCT_LV::CODEXB_DCT_LV in DCS_DOMAIN_V1_FWSETACTIONS
            insert CODEXB_DCT_LV::CODEXB_DCT_LV_FWCNM in FWCHILDRENMODE_FWSETSTATES
            move_to Included
        action: Free(string OWNER = "")	!visible: 0
            do Free(OWNER=OWNER) CODEXB_DCT_LV::CODEXB_DCT_LV_FWM
            move_to Included
        action: SetMode(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 0
            do SetMode(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) CODEXB_DCT_LV::CODEXB_DCT_LV_FWM
        action: ExcludePerm(string OWNER = "")	!visible: 0
            if ( CODEXB_DCT_LV::CODEXB_DCT_LV_FWM not_in_state Included ) then
                if ( CODEXB_DCT_LV::CODEXB_DCT_LV_FWM in_state InManual ) then
                    do Release(OWNER=OWNER) CODEXB_DCT_LV::CODEXB_DCT_LV_FWM
                    remove CODEXB_DCT_LV::CODEXB_DCT_LV from DCS_DOMAIN_V1_FWSETSTATES
                    remove CODEXB_DCT_LV::CODEXB_DCT_LV from DCS_DOMAIN_V1_FWSETACTIONS
                    remove CODEXB_DCT_LV::CODEXB_DCT_LV_FWCNM from FWCHILDRENMODE_FWSETSTATES
                else
                    move_to Included
                endif
            else
                do Exclude(OWNER=OWNER) CODEXB_DCT_LV::CODEXB_DCT_LV_FWM
                remove CODEXB_DCT_LV::CODEXB_DCT_LV from DCS_DOMAIN_V1_FWSETSTATES
                remove CODEXB_DCT_LV::CODEXB_DCT_LV from DCS_DOMAIN_V1_FWSETACTIONS
                remove CODEXB_DCT_LV::CODEXB_DCT_LV_FWCNM from FWCHILDRENMODE_FWSETSTATES
            endif
            move_to ExcludedPerm
        action: Exclude&LockOut(string OWNER = "")	!visible: 1
            if ( CODEXB_DCT_LV::CODEXB_DCT_LV_FWM not_in_state Included ) then
                if ( CODEXB_DCT_LV::CODEXB_DCT_LV_FWM in_state InManual ) then
                    do Release(OWNER=OWNER) CODEXB_DCT_LV::CODEXB_DCT_LV_FWM
                    remove CODEXB_DCT_LV::CODEXB_DCT_LV from DCS_DOMAIN_V1_FWSETSTATES
                    remove CODEXB_DCT_LV::CODEXB_DCT_LV from DCS_DOMAIN_V1_FWSETACTIONS
                    remove CODEXB_DCT_LV::CODEXB_DCT_LV_FWCNM from FWCHILDRENMODE_FWSETSTATES
                else
                    if ( CODEXB_DCT_LV::CODEXB_DCT_LV_FWM in_state Dead ) then
                        do Exclude(OWNER=OWNER) CODEXB_DCT_LV::CODEXB_DCT_LV_FWM
                        remove CODEXB_DCT_LV::CODEXB_DCT_LV from DCS_DOMAIN_V1_FWSETSTATES
                        remove CODEXB_DCT_LV::CODEXB_DCT_LV from DCS_DOMAIN_V1_FWSETACTIONS
                        remove CODEXB_DCT_LV::CODEXB_DCT_LV_FWCNM from FWCHILDRENMODE_FWSETSTATES
                   else
                        move_to Included
                    endif
                endif
            else
                do Exclude(OWNER=OWNER) CODEXB_DCT_LV::CODEXB_DCT_LV_FWM
                remove CODEXB_DCT_LV::CODEXB_DCT_LV from DCS_DOMAIN_V1_FWSETSTATES
                remove CODEXB_DCT_LV::CODEXB_DCT_LV from DCS_DOMAIN_V1_FWSETACTIONS
                remove CODEXB_DCT_LV::CODEXB_DCT_LV_FWCNM from FWCHILDRENMODE_FWSETSTATES
            endif
            move_to LockedOut
    state: Manual
    !color: FwStateOKNotPhysics
        when ( CODEXB_DCT_LV::CODEXB_DCT_LV_FWM in_state Included )  move_to EXCLUDED
        action: Include(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 1
            if ( CODEXB_DCT_LV::CODEXB_DCT_LV_FWM in_state Dead ) then
              move_to Manual
            endif
            if ( CODEXB_DCT_LV::CODEXB_DCT_LV_FWM not_in_state InManual ) then
              do Include(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) CODEXB_DCT_LV::CODEXB_DCT_LV_FWM
              insert CODEXB_DCT_LV::CODEXB_DCT_LV in DCS_DOMAIN_V1_FWSETSTATES
              insert CODEXB_DCT_LV::CODEXB_DCT_LV in DCS_DOMAIN_V1_FWSETACTIONS
              insert CODEXB_DCT_LV::CODEXB_DCT_LV_FWCNM in FWCHILDRENMODE_FWSETSTATES
            endif
              if ( CODEXB_DCT_LV::CODEXB_DCT_LV_FWM in_state Included ) then
                move_to Included
              endif
            move_to Manual
        action: Exclude(string OWNER = "")	!visible: 1
                do Exclude(OWNER=OWNER) CODEXB_DCT_LV::CODEXB_DCT_LV_FWM
                remove CODEXB_DCT_LV::CODEXB_DCT_LV from DCS_DOMAIN_V1_FWSETSTATES
                remove CODEXB_DCT_LV::CODEXB_DCT_LV from DCS_DOMAIN_V1_FWSETACTIONS
                remove CODEXB_DCT_LV::CODEXB_DCT_LV_FWCNM from FWCHILDRENMODE_FWSETSTATES
            !    move_to Excluded
            !endif
            !    else
            !    endif
            !else
            !endif
            !    move_to Excluded
            !endif
            !move_to Manual
            if ( CODEXB_DCT_LV::CODEXB_DCT_LV_FWM in_state InManual ) then
                 do SetInLocal CODEXB_DCT_LV::CODEXB_DCT_LV_FWM
            endif
            move_to Excluded
        action: Ignore	!visible: 0
            do Ignore CODEXB_DCT_LV::CODEXB_DCT_LV_FWM
            insert CODEXB_DCT_LV::CODEXB_DCT_LV in DCS_DOMAIN_V1_FWSETACTIONS
            remove CODEXB_DCT_LV::CODEXB_DCT_LV from DCS_DOMAIN_V1_FWSETSTATES
            move_to Ignored
        action: Free(string OWNER = "")	!visible: 0
            do Free(OWNER=OWNER) CODEXB_DCT_LV::CODEXB_DCT_LV_FWM
            !move_to Manual
            if ( CODEXB_DCT_LV::CODEXB_DCT_LV_FWM in_state InManual ) then
                 do SetInLocal CODEXB_DCT_LV::CODEXB_DCT_LV_FWM
            endif
            move_to Excluded
        action: ExcludeAll(string OWNER = "")	!visible: 1
            !    else
            !        move_to Included
            !    endif
            !else
            !endif
              do ExcludeAll(OWNER=OWNER) CODEXB_DCT_LV::CODEXB_DCT_LV_FWM
              remove CODEXB_DCT_LV::CODEXB_DCT_LV from DCS_DOMAIN_V1_FWSETSTATES
              remove CODEXB_DCT_LV::CODEXB_DCT_LV from DCS_DOMAIN_V1_FWSETACTIONS
              remove CODEXB_DCT_LV::CODEXB_DCT_LV_FWCNM from FWCHILDRENMODE_FWSETSTATES
            !endif
            !move_to Manual
            if ( CODEXB_DCT_LV::CODEXB_DCT_LV_FWM in_state InManual ) then
                 do SetInLocal CODEXB_DCT_LV::CODEXB_DCT_LV_FWM
            endif
            move_to Excluded
        action: Manual	!visible: 0
            do Manual CODEXB_DCT_LV::CODEXB_DCT_LV_FWM
            insert CODEXB_DCT_LV::CODEXB_DCT_LV in DCS_DOMAIN_V1_FWSETSTATES
            remove CODEXB_DCT_LV::CODEXB_DCT_LV from DCS_DOMAIN_V1_FWSETACTIONS
            move_to Manual
        action: Exclude&LockOut(string OWNER = "")	!visible: 1
                do Exclude(OWNER=OWNER) CODEXB_DCT_LV::CODEXB_DCT_LV_FWM
                remove CODEXB_DCT_LV::CODEXB_DCT_LV from DCS_DOMAIN_V1_FWSETSTATES
                remove CODEXB_DCT_LV::CODEXB_DCT_LV from DCS_DOMAIN_V1_FWSETACTIONS
                remove CODEXB_DCT_LV::CODEXB_DCT_LV_FWCNM from FWCHILDRENMODE_FWSETSTATES
            !    move_to Excluded
            !endif
            !    else
            !    endif
            !else
            !endif
            !    move_to Excluded
            !endif
            !move_to Manual
            if ( CODEXB_DCT_LV::CODEXB_DCT_LV_FWM in_state InManual ) then
                 do SetInLocal CODEXB_DCT_LV::CODEXB_DCT_LV_FWM
            endif
            move_to LockedOut
    state: Ignored
    !color: FwStateOKNotPhysics
        when ( CODEXB_DCT_LV::CODEXB_DCT_LV_FWM in_state Included )  move_to INCLUDED
        when ( CODEXB_DCT_LV::CODEXB_DCT_LV_FWM in_state Excluded ) move_to EXCLUDED
        when ( CODEXB_DCT_LV::CODEXB_DCT_LV_FWM in_state Dead )  do Exclude
        action: Include(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 1
            do Include(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) CODEXB_DCT_LV::CODEXB_DCT_LV_FWM
            insert CODEXB_DCT_LV::CODEXB_DCT_LV in DCS_DOMAIN_V1_FWSETSTATES
            insert CODEXB_DCT_LV::CODEXB_DCT_LV in DCS_DOMAIN_V1_FWSETACTIONS
            insert CODEXB_DCT_LV::CODEXB_DCT_LV_FWCNM in FWCHILDRENMODE_FWSETSTATES
            move_to Included
        action: Exclude(string OWNER = "")	!visible: 1
            if ( CODEXB_DCT_LV::CODEXB_DCT_LV_FWM not_in_state Included ) then
                if ( CODEXB_DCT_LV::CODEXB_DCT_LV_FWM in_state InManual ) then
                    do Release(OWNER=OWNER) CODEXB_DCT_LV::CODEXB_DCT_LV_FWM
                    remove CODEXB_DCT_LV::CODEXB_DCT_LV from DCS_DOMAIN_V1_FWSETSTATES
                    remove CODEXB_DCT_LV::CODEXB_DCT_LV from DCS_DOMAIN_V1_FWSETACTIONS
                    remove CODEXB_DCT_LV::CODEXB_DCT_LV_FWCNM from FWCHILDRENMODE_FWSETSTATES
                else
                    do Exclude(OWNER=OWNER) CODEXB_DCT_LV::CODEXB_DCT_LV_FWM
                    remove CODEXB_DCT_LV::CODEXB_DCT_LV from DCS_DOMAIN_V1_FWSETSTATES
                    remove CODEXB_DCT_LV::CODEXB_DCT_LV from DCS_DOMAIN_V1_FWSETACTIONS
                    remove CODEXB_DCT_LV::CODEXB_DCT_LV_FWCNM from FWCHILDRENMODE_FWSETSTATES
                endif
            else
                do Exclude(OWNER=OWNER) CODEXB_DCT_LV::CODEXB_DCT_LV_FWM
                remove CODEXB_DCT_LV::CODEXB_DCT_LV from DCS_DOMAIN_V1_FWSETSTATES
                remove CODEXB_DCT_LV::CODEXB_DCT_LV from DCS_DOMAIN_V1_FWSETACTIONS
                remove CODEXB_DCT_LV::CODEXB_DCT_LV_FWCNM from FWCHILDRENMODE_FWSETSTATES
            endif
            move_to Excluded
        action: Manual(string OWNER = "")	!visible: 0
            do Manual(OWNER=OWNER) CODEXB_DCT_LV::CODEXB_DCT_LV_FWM
            insert CODEXB_DCT_LV::CODEXB_DCT_LV in DCS_DOMAIN_V1_FWSETSTATES
            remove CODEXB_DCT_LV::CODEXB_DCT_LV from DCS_DOMAIN_V1_FWSETACTIONS
            move_to Manual
        action: SetMode(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 0
            do SetMode(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) CODEXB_DCT_LV::CODEXB_DCT_LV_FWM
        action: Free(string OWNER = "")	!visible: 0
            do Free(OWNER=OWNER) CODEXB_DCT_LV::CODEXB_DCT_LV_FWM
            move_to Included
        action: ExcludeAll(string OWNER = "")	!visible: 1
            if ( CODEXB_DCT_LV::CODEXB_DCT_LV_FWM not_in_state {Included,Ignored,Manual} ) then
                if ( CODEXB_DCT_LV::CODEXB_DCT_LV_FWM in_state InManual ) then
                    do ReleaseAll(OWNER=OWNER) CODEXB_DCT_LV::CODEXB_DCT_LV_FWM
                    remove CODEXB_DCT_LV::CODEXB_DCT_LV from DCS_DOMAIN_V1_FWSETSTATES
                    remove CODEXB_DCT_LV::CODEXB_DCT_LV from DCS_DOMAIN_V1_FWSETACTIONS
                    remove CODEXB_DCT_LV::CODEXB_DCT_LV_FWCNM from FWCHILDRENMODE_FWSETSTATES
                else
                    move_to Included
                endif
            else
                do ExcludeAll(OWNER=OWNER) CODEXB_DCT_LV::CODEXB_DCT_LV_FWM
                remove CODEXB_DCT_LV::CODEXB_DCT_LV from DCS_DOMAIN_V1_FWSETSTATES
                remove CODEXB_DCT_LV::CODEXB_DCT_LV from DCS_DOMAIN_V1_FWSETACTIONS
                remove CODEXB_DCT_LV::CODEXB_DCT_LV_FWCNM from FWCHILDRENMODE_FWSETSTATES
            endif
            move_to Excluded
    state: LockedOut
    !color: FwStateOKNotPhysics
        action: UnLockOut	!visible: 1
            move_to Excluded
        action: UnLockOut&Include(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 1
            if ( CODEXB_DCT_LV::CODEXB_DCT_LV_FWM not_in_state Excluded ) then
            !    else
                    move_to LockedOut
            !    endif
            else
                do Include(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) CODEXB_DCT_LV::CODEXB_DCT_LV_FWM
                insert CODEXB_DCT_LV::CODEXB_DCT_LV in DCS_DOMAIN_V1_FWSETSTATES
                insert CODEXB_DCT_LV::CODEXB_DCT_LV in DCS_DOMAIN_V1_FWSETACTIONS
                insert CODEXB_DCT_LV::CODEXB_DCT_LV_FWCNM in FWCHILDRENMODE_FWSETSTATES
            endif
            move_to Included
        action: LockOutPerm	!visible: 0
            move_to LockedOutPerm
    state: ExcludedPerm
    !color: FwStateOKNotPhysics
        action: Include(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 1
            !    else
            !        move_to Excluded
            !    endif
            !else
            !endif
            !move_to Included
            if ( CODEXB_DCT_LV::CODEXB_DCT_LV_FWM not_in_state {Excluded, Manual} ) then
                move_to ExcludedPerm
            else
                do Include(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) CODEXB_DCT_LV::CODEXB_DCT_LV_FWM
                insert CODEXB_DCT_LV::CODEXB_DCT_LV in DCS_DOMAIN_V1_FWSETSTATES
                insert CODEXB_DCT_LV::CODEXB_DCT_LV in DCS_DOMAIN_V1_FWSETACTIONS
                insert CODEXB_DCT_LV::CODEXB_DCT_LV_FWCNM in FWCHILDRENMODE_FWSETSTATES
            endif
            move_to Included
        action: LockOut	!visible: 1
            move_to LockedOut
        action: Exclude(string OWNER = "")	!visible: 0
            move_to Excluded
    state: LockedOutPerm
    !color: FwStateOKNotPhysics
        action: UnLockOut	!visible: 1
            move_to Excluded
        action: UnLockOut&Include(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 1
            if ( CODEXB_DCT_LV::CODEXB_DCT_LV_FWM not_in_state Excluded ) then
            !    else
                    move_to LockedOutPerm
            !    endif
            else
                do Include(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) CODEXB_DCT_LV::CODEXB_DCT_LV_FWM
                insert CODEXB_DCT_LV::CODEXB_DCT_LV in DCS_DOMAIN_V1_FWSETSTATES
                insert CODEXB_DCT_LV::CODEXB_DCT_LV in DCS_DOMAIN_V1_FWSETACTIONS
                insert CODEXB_DCT_LV::CODEXB_DCT_LV_FWCNM in FWCHILDRENMODE_FWSETSTATES
            endif
            move_to Included
        action: LockOut	!visible: 0
            move_to LockedOut

object: CODEXB_DCT_LV_FWM is_of_class CODEXB_DCT_LV_FwChildMode_CLASS

class: CODEXB_VANALOG_FwChildMode_CLASS

!panel: FwChildMode.pnl
    state: Excluded
    !color: FwStateOKNotPhysics
        action: Include(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 1
            if ( CODEXB_VANALOG::CODEXB_VANALOG_FWM in_state Dead ) then
              move_to Manual
            endif
            if ( CODEXB_VANALOG::CODEXB_VANALOG_FWM not_in_state {Excluded, Manual} ) then
            !    else
                    move_to Excluded
            !    endif
            else
                do Include(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) CODEXB_VANALOG::CODEXB_VANALOG_FWM
                insert CODEXB_VANALOG::CODEXB_VANALOG in DCS_DOMAIN_V1_FWSETSTATES
                insert CODEXB_VANALOG::CODEXB_VANALOG in DCS_DOMAIN_V1_FWSETACTIONS
                insert CODEXB_VANALOG::CODEXB_VANALOG_FWCNM in FWCHILDRENMODE_FWSETSTATES
            endif
            move_to Included
        action: Manual	!visible: 0
            do Manual CODEXB_VANALOG::CODEXB_VANALOG_FWM
            insert CODEXB_VANALOG::CODEXB_VANALOG in DCS_DOMAIN_V1_FWSETSTATES
            remove CODEXB_VANALOG::CODEXB_VANALOG from DCS_DOMAIN_V1_FWSETACTIONS
            move_to Manual
        action: Ignore	!visible: 0
            do Ignore CODEXB_VANALOG::CODEXB_VANALOG_FWM
            insert CODEXB_VANALOG::CODEXB_VANALOG in DCS_DOMAIN_V1_FWSETACTIONS
            remove CODEXB_VANALOG::CODEXB_VANALOG from DCS_DOMAIN_V1_FWSETSTATES
            move_to Ignored
        action: LockOut	!visible: 1
            move_to LockedOut
        action: Exclude(string OWNER = "")	!visible: 1
            do Exclude(OWNER=OWNER) CODEXB_VANALOG::CODEXB_VANALOG_FWM
            remove CODEXB_VANALOG::CODEXB_VANALOG from DCS_DOMAIN_V1_FWSETSTATES
            remove CODEXB_VANALOG::CODEXB_VANALOG from DCS_DOMAIN_V1_FWSETACTIONS
            remove CODEXB_VANALOG::CODEXB_VANALOG_FWCNM from FWCHILDRENMODE_FWSETSTATES
            move_to Excluded
        action: ExcludePerm(string OWNER = "")	!visible: 0
            move_to ExcludedPerm
        action: Exclude&LockOut(string OWNER = "")	!visible: 0
            move_to LockedOut
    state: Included
    !color: FwStateOKPhysics
        when ( CODEXB_VANALOG::CODEXB_VANALOG_FWM in_state Excluded )  do Exclude
        when ( CODEXB_VANALOG::CODEXB_VANALOG_FWM in_state Ignored )  move_to IGNORED
        when ( CODEXB_VANALOG::CODEXB_VANALOG_FWM in_state Manual )  move_to MANUAL
        when ( CODEXB_VANALOG::CODEXB_VANALOG_FWM in_state Dead )  do Manual
        action: Exclude(string OWNER = "")	!visible: 1
            if ( CODEXB_VANALOG::CODEXB_VANALOG_FWM not_in_state Included ) then
                if ( CODEXB_VANALOG::CODEXB_VANALOG_FWM in_state InManual ) then
                    do Release(OWNER=OWNER) CODEXB_VANALOG::CODEXB_VANALOG_FWM
                    remove CODEXB_VANALOG::CODEXB_VANALOG from DCS_DOMAIN_V1_FWSETSTATES
                    remove CODEXB_VANALOG::CODEXB_VANALOG from DCS_DOMAIN_V1_FWSETACTIONS
                    remove CODEXB_VANALOG::CODEXB_VANALOG_FWCNM from FWCHILDRENMODE_FWSETSTATES
                else
                        do Exclude(OWNER=OWNER) CODEXB_VANALOG::CODEXB_VANALOG_FWM
                        remove CODEXB_VANALOG::CODEXB_VANALOG from DCS_DOMAIN_V1_FWSETSTATES
                        remove CODEXB_VANALOG::CODEXB_VANALOG from DCS_DOMAIN_V1_FWSETACTIONS
                        remove CODEXB_VANALOG::CODEXB_VANALOG_FWCNM from FWCHILDRENMODE_FWSETSTATES
            !       else
            !            move_to Included
            !        endif
                endif
            else
                do Exclude(OWNER=OWNER) CODEXB_VANALOG::CODEXB_VANALOG_FWM
                remove CODEXB_VANALOG::CODEXB_VANALOG from DCS_DOMAIN_V1_FWSETSTATES
                remove CODEXB_VANALOG::CODEXB_VANALOG from DCS_DOMAIN_V1_FWSETACTIONS
                remove CODEXB_VANALOG::CODEXB_VANALOG_FWCNM from FWCHILDRENMODE_FWSETSTATES
            endif
            move_to Excluded
        action: Manual(string OWNER = "")	!visible: 1
            do Manual(OWNER=OWNER) CODEXB_VANALOG::CODEXB_VANALOG_FWM
            insert CODEXB_VANALOG::CODEXB_VANALOG in DCS_DOMAIN_V1_FWSETSTATES
            remove CODEXB_VANALOG::CODEXB_VANALOG from DCS_DOMAIN_V1_FWSETACTIONS
            move_to Manual
        action: Ignore(string OWNER = "")	!visible: 1
            do Ignore(OWNER=OWNER) CODEXB_VANALOG::CODEXB_VANALOG_FWM
            insert CODEXB_VANALOG::CODEXB_VANALOG in DCS_DOMAIN_V1_FWSETACTIONS
            remove CODEXB_VANALOG::CODEXB_VANALOG from DCS_DOMAIN_V1_FWSETSTATES
            move_to Ignored
        action: ExcludeAll(string OWNER = "")	!visible: 1
            if ( CODEXB_VANALOG::CODEXB_VANALOG_FWM not_in_state {Included,Ignored,Manual} ) then
                if ( CODEXB_VANALOG::CODEXB_VANALOG_FWM in_state InManual ) then
                    do ReleaseAll(OWNER=OWNER) CODEXB_VANALOG::CODEXB_VANALOG_FWM
                    remove CODEXB_VANALOG::CODEXB_VANALOG from DCS_DOMAIN_V1_FWSETSTATES
                    remove CODEXB_VANALOG::CODEXB_VANALOG from DCS_DOMAIN_V1_FWSETACTIONS
                    remove CODEXB_VANALOG::CODEXB_VANALOG_FWCNM from FWCHILDRENMODE_FWSETSTATES
                else
                    move_to Included
                endif
            else
                do ExcludeAll(OWNER=OWNER) CODEXB_VANALOG::CODEXB_VANALOG_FWM
                remove CODEXB_VANALOG::CODEXB_VANALOG from DCS_DOMAIN_V1_FWSETSTATES
                remove CODEXB_VANALOG::CODEXB_VANALOG from DCS_DOMAIN_V1_FWSETACTIONS
                remove CODEXB_VANALOG::CODEXB_VANALOG_FWCNM from FWCHILDRENMODE_FWSETSTATES
            endif
            move_to Excluded
        action: Include(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 1
            do Include(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) CODEXB_VANALOG::CODEXB_VANALOG_FWM
            insert CODEXB_VANALOG::CODEXB_VANALOG in DCS_DOMAIN_V1_FWSETSTATES
            insert CODEXB_VANALOG::CODEXB_VANALOG in DCS_DOMAIN_V1_FWSETACTIONS
            insert CODEXB_VANALOG::CODEXB_VANALOG_FWCNM in FWCHILDRENMODE_FWSETSTATES
            move_to Included
        action: Free(string OWNER = "")	!visible: 0
            do Free(OWNER=OWNER) CODEXB_VANALOG::CODEXB_VANALOG_FWM
            move_to Included
        action: SetMode(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 0
            do SetMode(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) CODEXB_VANALOG::CODEXB_VANALOG_FWM
        action: ExcludePerm(string OWNER = "")	!visible: 0
            if ( CODEXB_VANALOG::CODEXB_VANALOG_FWM not_in_state Included ) then
                if ( CODEXB_VANALOG::CODEXB_VANALOG_FWM in_state InManual ) then
                    do Release(OWNER=OWNER) CODEXB_VANALOG::CODEXB_VANALOG_FWM
                    remove CODEXB_VANALOG::CODEXB_VANALOG from DCS_DOMAIN_V1_FWSETSTATES
                    remove CODEXB_VANALOG::CODEXB_VANALOG from DCS_DOMAIN_V1_FWSETACTIONS
                    remove CODEXB_VANALOG::CODEXB_VANALOG_FWCNM from FWCHILDRENMODE_FWSETSTATES
                else
                    move_to Included
                endif
            else
                do Exclude(OWNER=OWNER) CODEXB_VANALOG::CODEXB_VANALOG_FWM
                remove CODEXB_VANALOG::CODEXB_VANALOG from DCS_DOMAIN_V1_FWSETSTATES
                remove CODEXB_VANALOG::CODEXB_VANALOG from DCS_DOMAIN_V1_FWSETACTIONS
                remove CODEXB_VANALOG::CODEXB_VANALOG_FWCNM from FWCHILDRENMODE_FWSETSTATES
            endif
            move_to ExcludedPerm
        action: Exclude&LockOut(string OWNER = "")	!visible: 1
            if ( CODEXB_VANALOG::CODEXB_VANALOG_FWM not_in_state Included ) then
                if ( CODEXB_VANALOG::CODEXB_VANALOG_FWM in_state InManual ) then
                    do Release(OWNER=OWNER) CODEXB_VANALOG::CODEXB_VANALOG_FWM
                    remove CODEXB_VANALOG::CODEXB_VANALOG from DCS_DOMAIN_V1_FWSETSTATES
                    remove CODEXB_VANALOG::CODEXB_VANALOG from DCS_DOMAIN_V1_FWSETACTIONS
                    remove CODEXB_VANALOG::CODEXB_VANALOG_FWCNM from FWCHILDRENMODE_FWSETSTATES
                else
                    if ( CODEXB_VANALOG::CODEXB_VANALOG_FWM in_state Dead ) then
                        do Exclude(OWNER=OWNER) CODEXB_VANALOG::CODEXB_VANALOG_FWM
                        remove CODEXB_VANALOG::CODEXB_VANALOG from DCS_DOMAIN_V1_FWSETSTATES
                        remove CODEXB_VANALOG::CODEXB_VANALOG from DCS_DOMAIN_V1_FWSETACTIONS
                        remove CODEXB_VANALOG::CODEXB_VANALOG_FWCNM from FWCHILDRENMODE_FWSETSTATES
                   else
                        move_to Included
                    endif
                endif
            else
                do Exclude(OWNER=OWNER) CODEXB_VANALOG::CODEXB_VANALOG_FWM
                remove CODEXB_VANALOG::CODEXB_VANALOG from DCS_DOMAIN_V1_FWSETSTATES
                remove CODEXB_VANALOG::CODEXB_VANALOG from DCS_DOMAIN_V1_FWSETACTIONS
                remove CODEXB_VANALOG::CODEXB_VANALOG_FWCNM from FWCHILDRENMODE_FWSETSTATES
            endif
            move_to LockedOut
    state: Manual
    !color: FwStateOKNotPhysics
        when ( CODEXB_VANALOG::CODEXB_VANALOG_FWM in_state Included )  move_to EXCLUDED
        action: Include(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 1
            if ( CODEXB_VANALOG::CODEXB_VANALOG_FWM in_state Dead ) then
              move_to Manual
            endif
            if ( CODEXB_VANALOG::CODEXB_VANALOG_FWM not_in_state InManual ) then
              do Include(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) CODEXB_VANALOG::CODEXB_VANALOG_FWM
              insert CODEXB_VANALOG::CODEXB_VANALOG in DCS_DOMAIN_V1_FWSETSTATES
              insert CODEXB_VANALOG::CODEXB_VANALOG in DCS_DOMAIN_V1_FWSETACTIONS
              insert CODEXB_VANALOG::CODEXB_VANALOG_FWCNM in FWCHILDRENMODE_FWSETSTATES
            endif
              if ( CODEXB_VANALOG::CODEXB_VANALOG_FWM in_state Included ) then
                move_to Included
              endif
            move_to Manual
        action: Exclude(string OWNER = "")	!visible: 1
                do Exclude(OWNER=OWNER) CODEXB_VANALOG::CODEXB_VANALOG_FWM
                remove CODEXB_VANALOG::CODEXB_VANALOG from DCS_DOMAIN_V1_FWSETSTATES
                remove CODEXB_VANALOG::CODEXB_VANALOG from DCS_DOMAIN_V1_FWSETACTIONS
                remove CODEXB_VANALOG::CODEXB_VANALOG_FWCNM from FWCHILDRENMODE_FWSETSTATES
            !    move_to Excluded
            !endif
            !    else
            !    endif
            !else
            !endif
            !    move_to Excluded
            !endif
            !move_to Manual
            if ( CODEXB_VANALOG::CODEXB_VANALOG_FWM in_state InManual ) then
                 do SetInLocal CODEXB_VANALOG::CODEXB_VANALOG_FWM
            endif
            move_to Excluded
        action: Ignore	!visible: 0
            do Ignore CODEXB_VANALOG::CODEXB_VANALOG_FWM
            insert CODEXB_VANALOG::CODEXB_VANALOG in DCS_DOMAIN_V1_FWSETACTIONS
            remove CODEXB_VANALOG::CODEXB_VANALOG from DCS_DOMAIN_V1_FWSETSTATES
            move_to Ignored
        action: Free(string OWNER = "")	!visible: 0
            do Free(OWNER=OWNER) CODEXB_VANALOG::CODEXB_VANALOG_FWM
            !move_to Manual
            if ( CODEXB_VANALOG::CODEXB_VANALOG_FWM in_state InManual ) then
                 do SetInLocal CODEXB_VANALOG::CODEXB_VANALOG_FWM
            endif
            move_to Excluded
        action: ExcludeAll(string OWNER = "")	!visible: 1
            !    else
            !        move_to Included
            !    endif
            !else
            !endif
              do ExcludeAll(OWNER=OWNER) CODEXB_VANALOG::CODEXB_VANALOG_FWM
              remove CODEXB_VANALOG::CODEXB_VANALOG from DCS_DOMAIN_V1_FWSETSTATES
              remove CODEXB_VANALOG::CODEXB_VANALOG from DCS_DOMAIN_V1_FWSETACTIONS
              remove CODEXB_VANALOG::CODEXB_VANALOG_FWCNM from FWCHILDRENMODE_FWSETSTATES
            !endif
            !move_to Manual
            if ( CODEXB_VANALOG::CODEXB_VANALOG_FWM in_state InManual ) then
                 do SetInLocal CODEXB_VANALOG::CODEXB_VANALOG_FWM
            endif
            move_to Excluded
        action: Manual	!visible: 0
            do Manual CODEXB_VANALOG::CODEXB_VANALOG_FWM
            insert CODEXB_VANALOG::CODEXB_VANALOG in DCS_DOMAIN_V1_FWSETSTATES
            remove CODEXB_VANALOG::CODEXB_VANALOG from DCS_DOMAIN_V1_FWSETACTIONS
            move_to Manual
        action: Exclude&LockOut(string OWNER = "")	!visible: 1
                do Exclude(OWNER=OWNER) CODEXB_VANALOG::CODEXB_VANALOG_FWM
                remove CODEXB_VANALOG::CODEXB_VANALOG from DCS_DOMAIN_V1_FWSETSTATES
                remove CODEXB_VANALOG::CODEXB_VANALOG from DCS_DOMAIN_V1_FWSETACTIONS
                remove CODEXB_VANALOG::CODEXB_VANALOG_FWCNM from FWCHILDRENMODE_FWSETSTATES
            !    move_to Excluded
            !endif
            !    else
            !    endif
            !else
            !endif
            !    move_to Excluded
            !endif
            !move_to Manual
            if ( CODEXB_VANALOG::CODEXB_VANALOG_FWM in_state InManual ) then
                 do SetInLocal CODEXB_VANALOG::CODEXB_VANALOG_FWM
            endif
            move_to LockedOut
    state: Ignored
    !color: FwStateOKNotPhysics
        when ( CODEXB_VANALOG::CODEXB_VANALOG_FWM in_state Included )  move_to INCLUDED
        when ( CODEXB_VANALOG::CODEXB_VANALOG_FWM in_state Excluded ) move_to EXCLUDED
        when ( CODEXB_VANALOG::CODEXB_VANALOG_FWM in_state Dead )  do Exclude
        action: Include(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 1
            do Include(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) CODEXB_VANALOG::CODEXB_VANALOG_FWM
            insert CODEXB_VANALOG::CODEXB_VANALOG in DCS_DOMAIN_V1_FWSETSTATES
            insert CODEXB_VANALOG::CODEXB_VANALOG in DCS_DOMAIN_V1_FWSETACTIONS
            insert CODEXB_VANALOG::CODEXB_VANALOG_FWCNM in FWCHILDRENMODE_FWSETSTATES
            move_to Included
        action: Exclude(string OWNER = "")	!visible: 1
            if ( CODEXB_VANALOG::CODEXB_VANALOG_FWM not_in_state Included ) then
                if ( CODEXB_VANALOG::CODEXB_VANALOG_FWM in_state InManual ) then
                    do Release(OWNER=OWNER) CODEXB_VANALOG::CODEXB_VANALOG_FWM
                    remove CODEXB_VANALOG::CODEXB_VANALOG from DCS_DOMAIN_V1_FWSETSTATES
                    remove CODEXB_VANALOG::CODEXB_VANALOG from DCS_DOMAIN_V1_FWSETACTIONS
                    remove CODEXB_VANALOG::CODEXB_VANALOG_FWCNM from FWCHILDRENMODE_FWSETSTATES
                else
                    do Exclude(OWNER=OWNER) CODEXB_VANALOG::CODEXB_VANALOG_FWM
                    remove CODEXB_VANALOG::CODEXB_VANALOG from DCS_DOMAIN_V1_FWSETSTATES
                    remove CODEXB_VANALOG::CODEXB_VANALOG from DCS_DOMAIN_V1_FWSETACTIONS
                    remove CODEXB_VANALOG::CODEXB_VANALOG_FWCNM from FWCHILDRENMODE_FWSETSTATES
                endif
            else
                do Exclude(OWNER=OWNER) CODEXB_VANALOG::CODEXB_VANALOG_FWM
                remove CODEXB_VANALOG::CODEXB_VANALOG from DCS_DOMAIN_V1_FWSETSTATES
                remove CODEXB_VANALOG::CODEXB_VANALOG from DCS_DOMAIN_V1_FWSETACTIONS
                remove CODEXB_VANALOG::CODEXB_VANALOG_FWCNM from FWCHILDRENMODE_FWSETSTATES
            endif
            move_to Excluded
        action: Manual(string OWNER = "")	!visible: 0
            do Manual(OWNER=OWNER) CODEXB_VANALOG::CODEXB_VANALOG_FWM
            insert CODEXB_VANALOG::CODEXB_VANALOG in DCS_DOMAIN_V1_FWSETSTATES
            remove CODEXB_VANALOG::CODEXB_VANALOG from DCS_DOMAIN_V1_FWSETACTIONS
            move_to Manual
        action: SetMode(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 0
            do SetMode(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) CODEXB_VANALOG::CODEXB_VANALOG_FWM
        action: Free(string OWNER = "")	!visible: 0
            do Free(OWNER=OWNER) CODEXB_VANALOG::CODEXB_VANALOG_FWM
            move_to Included
        action: ExcludeAll(string OWNER = "")	!visible: 1
            if ( CODEXB_VANALOG::CODEXB_VANALOG_FWM not_in_state {Included,Ignored,Manual} ) then
                if ( CODEXB_VANALOG::CODEXB_VANALOG_FWM in_state InManual ) then
                    do ReleaseAll(OWNER=OWNER) CODEXB_VANALOG::CODEXB_VANALOG_FWM
                    remove CODEXB_VANALOG::CODEXB_VANALOG from DCS_DOMAIN_V1_FWSETSTATES
                    remove CODEXB_VANALOG::CODEXB_VANALOG from DCS_DOMAIN_V1_FWSETACTIONS
                    remove CODEXB_VANALOG::CODEXB_VANALOG_FWCNM from FWCHILDRENMODE_FWSETSTATES
                else
                    move_to Included
                endif
            else
                do ExcludeAll(OWNER=OWNER) CODEXB_VANALOG::CODEXB_VANALOG_FWM
                remove CODEXB_VANALOG::CODEXB_VANALOG from DCS_DOMAIN_V1_FWSETSTATES
                remove CODEXB_VANALOG::CODEXB_VANALOG from DCS_DOMAIN_V1_FWSETACTIONS
                remove CODEXB_VANALOG::CODEXB_VANALOG_FWCNM from FWCHILDRENMODE_FWSETSTATES
            endif
            move_to Excluded
    state: LockedOut
    !color: FwStateOKNotPhysics
        action: UnLockOut	!visible: 1
            move_to Excluded
        action: UnLockOut&Include(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 1
            if ( CODEXB_VANALOG::CODEXB_VANALOG_FWM not_in_state Excluded ) then
            !    else
                    move_to LockedOut
            !    endif
            else
                do Include(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) CODEXB_VANALOG::CODEXB_VANALOG_FWM
                insert CODEXB_VANALOG::CODEXB_VANALOG in DCS_DOMAIN_V1_FWSETSTATES
                insert CODEXB_VANALOG::CODEXB_VANALOG in DCS_DOMAIN_V1_FWSETACTIONS
                insert CODEXB_VANALOG::CODEXB_VANALOG_FWCNM in FWCHILDRENMODE_FWSETSTATES
            endif
            move_to Included
        action: LockOutPerm	!visible: 0
            move_to LockedOutPerm
    state: ExcludedPerm
    !color: FwStateOKNotPhysics
        action: Include(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 1
            !    else
            !        move_to Excluded
            !    endif
            !else
            !endif
            !move_to Included
            if ( CODEXB_VANALOG::CODEXB_VANALOG_FWM not_in_state {Excluded, Manual} ) then
                move_to ExcludedPerm
            else
                do Include(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) CODEXB_VANALOG::CODEXB_VANALOG_FWM
                insert CODEXB_VANALOG::CODEXB_VANALOG in DCS_DOMAIN_V1_FWSETSTATES
                insert CODEXB_VANALOG::CODEXB_VANALOG in DCS_DOMAIN_V1_FWSETACTIONS
                insert CODEXB_VANALOG::CODEXB_VANALOG_FWCNM in FWCHILDRENMODE_FWSETSTATES
            endif
            move_to Included
        action: LockOut	!visible: 1
            move_to LockedOut
        action: Exclude(string OWNER = "")	!visible: 0
            move_to Excluded
    state: LockedOutPerm
    !color: FwStateOKNotPhysics
        action: UnLockOut	!visible: 1
            move_to Excluded
        action: UnLockOut&Include(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 1
            if ( CODEXB_VANALOG::CODEXB_VANALOG_FWM not_in_state Excluded ) then
            !    else
                    move_to LockedOutPerm
            !    endif
            else
                do Include(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) CODEXB_VANALOG::CODEXB_VANALOG_FWM
                insert CODEXB_VANALOG::CODEXB_VANALOG in DCS_DOMAIN_V1_FWSETSTATES
                insert CODEXB_VANALOG::CODEXB_VANALOG in DCS_DOMAIN_V1_FWSETACTIONS
                insert CODEXB_VANALOG::CODEXB_VANALOG_FWCNM in FWCHILDRENMODE_FWSETSTATES
            endif
            move_to Included
        action: LockOut	!visible: 0
            move_to LockedOut

object: CODEXB_VANALOG_FWM is_of_class CODEXB_VANALOG_FwChildMode_CLASS

class: CODEXB_VDIGITAL_FwChildMode_CLASS

!panel: FwChildMode.pnl
    state: Excluded
    !color: FwStateOKNotPhysics
        action: Include(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 1
            if ( CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM in_state Dead ) then
              move_to Manual
            endif
            if ( CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM not_in_state {Excluded, Manual} ) then
            !    else
                    move_to Excluded
            !    endif
            else
                do Include(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM
                insert CODEXB_VDIGITAL::CODEXB_VDIGITAL in DCS_DOMAIN_V1_FWSETSTATES
                insert CODEXB_VDIGITAL::CODEXB_VDIGITAL in DCS_DOMAIN_V1_FWSETACTIONS
                insert CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWCNM in FWCHILDRENMODE_FWSETSTATES
            endif
            move_to Included
        action: Manual	!visible: 0
            do Manual CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM
            insert CODEXB_VDIGITAL::CODEXB_VDIGITAL in DCS_DOMAIN_V1_FWSETSTATES
            remove CODEXB_VDIGITAL::CODEXB_VDIGITAL from DCS_DOMAIN_V1_FWSETACTIONS
            move_to Manual
        action: Ignore	!visible: 0
            do Ignore CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM
            insert CODEXB_VDIGITAL::CODEXB_VDIGITAL in DCS_DOMAIN_V1_FWSETACTIONS
            remove CODEXB_VDIGITAL::CODEXB_VDIGITAL from DCS_DOMAIN_V1_FWSETSTATES
            move_to Ignored
        action: LockOut	!visible: 1
            move_to LockedOut
        action: Exclude(string OWNER = "")	!visible: 1
            do Exclude(OWNER=OWNER) CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM
            remove CODEXB_VDIGITAL::CODEXB_VDIGITAL from DCS_DOMAIN_V1_FWSETSTATES
            remove CODEXB_VDIGITAL::CODEXB_VDIGITAL from DCS_DOMAIN_V1_FWSETACTIONS
            remove CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWCNM from FWCHILDRENMODE_FWSETSTATES
            move_to Excluded
        action: ExcludePerm(string OWNER = "")	!visible: 0
            move_to ExcludedPerm
        action: Exclude&LockOut(string OWNER = "")	!visible: 0
            move_to LockedOut
    state: Included
    !color: FwStateOKPhysics
        when ( CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM in_state Excluded )  do Exclude
        when ( CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM in_state Ignored )  move_to IGNORED
        when ( CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM in_state Manual )  move_to MANUAL
        when ( CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM in_state Dead )  do Manual
        action: Exclude(string OWNER = "")	!visible: 1
            if ( CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM not_in_state Included ) then
                if ( CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM in_state InManual ) then
                    do Release(OWNER=OWNER) CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM
                    remove CODEXB_VDIGITAL::CODEXB_VDIGITAL from DCS_DOMAIN_V1_FWSETSTATES
                    remove CODEXB_VDIGITAL::CODEXB_VDIGITAL from DCS_DOMAIN_V1_FWSETACTIONS
                    remove CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWCNM from FWCHILDRENMODE_FWSETSTATES
                else
                        do Exclude(OWNER=OWNER) CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM
                        remove CODEXB_VDIGITAL::CODEXB_VDIGITAL from DCS_DOMAIN_V1_FWSETSTATES
                        remove CODEXB_VDIGITAL::CODEXB_VDIGITAL from DCS_DOMAIN_V1_FWSETACTIONS
                        remove CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWCNM from FWCHILDRENMODE_FWSETSTATES
            !       else
            !            move_to Included
            !        endif
                endif
            else
                do Exclude(OWNER=OWNER) CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM
                remove CODEXB_VDIGITAL::CODEXB_VDIGITAL from DCS_DOMAIN_V1_FWSETSTATES
                remove CODEXB_VDIGITAL::CODEXB_VDIGITAL from DCS_DOMAIN_V1_FWSETACTIONS
                remove CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWCNM from FWCHILDRENMODE_FWSETSTATES
            endif
            move_to Excluded
        action: Manual(string OWNER = "")	!visible: 1
            do Manual(OWNER=OWNER) CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM
            insert CODEXB_VDIGITAL::CODEXB_VDIGITAL in DCS_DOMAIN_V1_FWSETSTATES
            remove CODEXB_VDIGITAL::CODEXB_VDIGITAL from DCS_DOMAIN_V1_FWSETACTIONS
            move_to Manual
        action: Ignore(string OWNER = "")	!visible: 1
            do Ignore(OWNER=OWNER) CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM
            insert CODEXB_VDIGITAL::CODEXB_VDIGITAL in DCS_DOMAIN_V1_FWSETACTIONS
            remove CODEXB_VDIGITAL::CODEXB_VDIGITAL from DCS_DOMAIN_V1_FWSETSTATES
            move_to Ignored
        action: ExcludeAll(string OWNER = "")	!visible: 1
            if ( CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM not_in_state {Included,Ignored,Manual} ) then
                if ( CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM in_state InManual ) then
                    do ReleaseAll(OWNER=OWNER) CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM
                    remove CODEXB_VDIGITAL::CODEXB_VDIGITAL from DCS_DOMAIN_V1_FWSETSTATES
                    remove CODEXB_VDIGITAL::CODEXB_VDIGITAL from DCS_DOMAIN_V1_FWSETACTIONS
                    remove CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWCNM from FWCHILDRENMODE_FWSETSTATES
                else
                    move_to Included
                endif
            else
                do ExcludeAll(OWNER=OWNER) CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM
                remove CODEXB_VDIGITAL::CODEXB_VDIGITAL from DCS_DOMAIN_V1_FWSETSTATES
                remove CODEXB_VDIGITAL::CODEXB_VDIGITAL from DCS_DOMAIN_V1_FWSETACTIONS
                remove CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWCNM from FWCHILDRENMODE_FWSETSTATES
            endif
            move_to Excluded
        action: Include(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 1
            do Include(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM
            insert CODEXB_VDIGITAL::CODEXB_VDIGITAL in DCS_DOMAIN_V1_FWSETSTATES
            insert CODEXB_VDIGITAL::CODEXB_VDIGITAL in DCS_DOMAIN_V1_FWSETACTIONS
            insert CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWCNM in FWCHILDRENMODE_FWSETSTATES
            move_to Included
        action: Free(string OWNER = "")	!visible: 0
            do Free(OWNER=OWNER) CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM
            move_to Included
        action: SetMode(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 0
            do SetMode(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM
        action: ExcludePerm(string OWNER = "")	!visible: 0
            if ( CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM not_in_state Included ) then
                if ( CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM in_state InManual ) then
                    do Release(OWNER=OWNER) CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM
                    remove CODEXB_VDIGITAL::CODEXB_VDIGITAL from DCS_DOMAIN_V1_FWSETSTATES
                    remove CODEXB_VDIGITAL::CODEXB_VDIGITAL from DCS_DOMAIN_V1_FWSETACTIONS
                    remove CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWCNM from FWCHILDRENMODE_FWSETSTATES
                else
                    move_to Included
                endif
            else
                do Exclude(OWNER=OWNER) CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM
                remove CODEXB_VDIGITAL::CODEXB_VDIGITAL from DCS_DOMAIN_V1_FWSETSTATES
                remove CODEXB_VDIGITAL::CODEXB_VDIGITAL from DCS_DOMAIN_V1_FWSETACTIONS
                remove CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWCNM from FWCHILDRENMODE_FWSETSTATES
            endif
            move_to ExcludedPerm
        action: Exclude&LockOut(string OWNER = "")	!visible: 1
            if ( CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM not_in_state Included ) then
                if ( CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM in_state InManual ) then
                    do Release(OWNER=OWNER) CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM
                    remove CODEXB_VDIGITAL::CODEXB_VDIGITAL from DCS_DOMAIN_V1_FWSETSTATES
                    remove CODEXB_VDIGITAL::CODEXB_VDIGITAL from DCS_DOMAIN_V1_FWSETACTIONS
                    remove CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWCNM from FWCHILDRENMODE_FWSETSTATES
                else
                    if ( CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM in_state Dead ) then
                        do Exclude(OWNER=OWNER) CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM
                        remove CODEXB_VDIGITAL::CODEXB_VDIGITAL from DCS_DOMAIN_V1_FWSETSTATES
                        remove CODEXB_VDIGITAL::CODEXB_VDIGITAL from DCS_DOMAIN_V1_FWSETACTIONS
                        remove CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWCNM from FWCHILDRENMODE_FWSETSTATES
                   else
                        move_to Included
                    endif
                endif
            else
                do Exclude(OWNER=OWNER) CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM
                remove CODEXB_VDIGITAL::CODEXB_VDIGITAL from DCS_DOMAIN_V1_FWSETSTATES
                remove CODEXB_VDIGITAL::CODEXB_VDIGITAL from DCS_DOMAIN_V1_FWSETACTIONS
                remove CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWCNM from FWCHILDRENMODE_FWSETSTATES
            endif
            move_to LockedOut
    state: Manual
    !color: FwStateOKNotPhysics
        when ( CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM in_state Included )  move_to EXCLUDED
        action: Include(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 1
            if ( CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM in_state Dead ) then
              move_to Manual
            endif
            if ( CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM not_in_state InManual ) then
              do Include(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM
              insert CODEXB_VDIGITAL::CODEXB_VDIGITAL in DCS_DOMAIN_V1_FWSETSTATES
              insert CODEXB_VDIGITAL::CODEXB_VDIGITAL in DCS_DOMAIN_V1_FWSETACTIONS
              insert CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWCNM in FWCHILDRENMODE_FWSETSTATES
            endif
              if ( CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM in_state Included ) then
                move_to Included
              endif
            move_to Manual
        action: Exclude(string OWNER = "")	!visible: 1
                do Exclude(OWNER=OWNER) CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM
                remove CODEXB_VDIGITAL::CODEXB_VDIGITAL from DCS_DOMAIN_V1_FWSETSTATES
                remove CODEXB_VDIGITAL::CODEXB_VDIGITAL from DCS_DOMAIN_V1_FWSETACTIONS
                remove CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWCNM from FWCHILDRENMODE_FWSETSTATES
            !    move_to Excluded
            !endif
            !    else
            !    endif
            !else
            !endif
            !    move_to Excluded
            !endif
            !move_to Manual
            if ( CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM in_state InManual ) then
                 do SetInLocal CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM
            endif
            move_to Excluded
        action: Ignore	!visible: 0
            do Ignore CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM
            insert CODEXB_VDIGITAL::CODEXB_VDIGITAL in DCS_DOMAIN_V1_FWSETACTIONS
            remove CODEXB_VDIGITAL::CODEXB_VDIGITAL from DCS_DOMAIN_V1_FWSETSTATES
            move_to Ignored
        action: Free(string OWNER = "")	!visible: 0
            do Free(OWNER=OWNER) CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM
            !move_to Manual
            if ( CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM in_state InManual ) then
                 do SetInLocal CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM
            endif
            move_to Excluded
        action: ExcludeAll(string OWNER = "")	!visible: 1
            !    else
            !        move_to Included
            !    endif
            !else
            !endif
              do ExcludeAll(OWNER=OWNER) CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM
              remove CODEXB_VDIGITAL::CODEXB_VDIGITAL from DCS_DOMAIN_V1_FWSETSTATES
              remove CODEXB_VDIGITAL::CODEXB_VDIGITAL from DCS_DOMAIN_V1_FWSETACTIONS
              remove CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWCNM from FWCHILDRENMODE_FWSETSTATES
            !endif
            !move_to Manual
            if ( CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM in_state InManual ) then
                 do SetInLocal CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM
            endif
            move_to Excluded
        action: Manual	!visible: 0
            do Manual CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM
            insert CODEXB_VDIGITAL::CODEXB_VDIGITAL in DCS_DOMAIN_V1_FWSETSTATES
            remove CODEXB_VDIGITAL::CODEXB_VDIGITAL from DCS_DOMAIN_V1_FWSETACTIONS
            move_to Manual
        action: Exclude&LockOut(string OWNER = "")	!visible: 1
                do Exclude(OWNER=OWNER) CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM
                remove CODEXB_VDIGITAL::CODEXB_VDIGITAL from DCS_DOMAIN_V1_FWSETSTATES
                remove CODEXB_VDIGITAL::CODEXB_VDIGITAL from DCS_DOMAIN_V1_FWSETACTIONS
                remove CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWCNM from FWCHILDRENMODE_FWSETSTATES
            !    move_to Excluded
            !endif
            !    else
            !    endif
            !else
            !endif
            !    move_to Excluded
            !endif
            !move_to Manual
            if ( CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM in_state InManual ) then
                 do SetInLocal CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM
            endif
            move_to LockedOut
    state: Ignored
    !color: FwStateOKNotPhysics
        when ( CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM in_state Included )  move_to INCLUDED
        when ( CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM in_state Excluded ) move_to EXCLUDED
        when ( CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM in_state Dead )  do Exclude
        action: Include(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 1
            do Include(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM
            insert CODEXB_VDIGITAL::CODEXB_VDIGITAL in DCS_DOMAIN_V1_FWSETSTATES
            insert CODEXB_VDIGITAL::CODEXB_VDIGITAL in DCS_DOMAIN_V1_FWSETACTIONS
            insert CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWCNM in FWCHILDRENMODE_FWSETSTATES
            move_to Included
        action: Exclude(string OWNER = "")	!visible: 1
            if ( CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM not_in_state Included ) then
                if ( CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM in_state InManual ) then
                    do Release(OWNER=OWNER) CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM
                    remove CODEXB_VDIGITAL::CODEXB_VDIGITAL from DCS_DOMAIN_V1_FWSETSTATES
                    remove CODEXB_VDIGITAL::CODEXB_VDIGITAL from DCS_DOMAIN_V1_FWSETACTIONS
                    remove CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWCNM from FWCHILDRENMODE_FWSETSTATES
                else
                    do Exclude(OWNER=OWNER) CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM
                    remove CODEXB_VDIGITAL::CODEXB_VDIGITAL from DCS_DOMAIN_V1_FWSETSTATES
                    remove CODEXB_VDIGITAL::CODEXB_VDIGITAL from DCS_DOMAIN_V1_FWSETACTIONS
                    remove CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWCNM from FWCHILDRENMODE_FWSETSTATES
                endif
            else
                do Exclude(OWNER=OWNER) CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM
                remove CODEXB_VDIGITAL::CODEXB_VDIGITAL from DCS_DOMAIN_V1_FWSETSTATES
                remove CODEXB_VDIGITAL::CODEXB_VDIGITAL from DCS_DOMAIN_V1_FWSETACTIONS
                remove CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWCNM from FWCHILDRENMODE_FWSETSTATES
            endif
            move_to Excluded
        action: Manual(string OWNER = "")	!visible: 0
            do Manual(OWNER=OWNER) CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM
            insert CODEXB_VDIGITAL::CODEXB_VDIGITAL in DCS_DOMAIN_V1_FWSETSTATES
            remove CODEXB_VDIGITAL::CODEXB_VDIGITAL from DCS_DOMAIN_V1_FWSETACTIONS
            move_to Manual
        action: SetMode(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 0
            do SetMode(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM
        action: Free(string OWNER = "")	!visible: 0
            do Free(OWNER=OWNER) CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM
            move_to Included
        action: ExcludeAll(string OWNER = "")	!visible: 1
            if ( CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM not_in_state {Included,Ignored,Manual} ) then
                if ( CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM in_state InManual ) then
                    do ReleaseAll(OWNER=OWNER) CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM
                    remove CODEXB_VDIGITAL::CODEXB_VDIGITAL from DCS_DOMAIN_V1_FWSETSTATES
                    remove CODEXB_VDIGITAL::CODEXB_VDIGITAL from DCS_DOMAIN_V1_FWSETACTIONS
                    remove CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWCNM from FWCHILDRENMODE_FWSETSTATES
                else
                    move_to Included
                endif
            else
                do ExcludeAll(OWNER=OWNER) CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM
                remove CODEXB_VDIGITAL::CODEXB_VDIGITAL from DCS_DOMAIN_V1_FWSETSTATES
                remove CODEXB_VDIGITAL::CODEXB_VDIGITAL from DCS_DOMAIN_V1_FWSETACTIONS
                remove CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWCNM from FWCHILDRENMODE_FWSETSTATES
            endif
            move_to Excluded
    state: LockedOut
    !color: FwStateOKNotPhysics
        action: UnLockOut	!visible: 1
            move_to Excluded
        action: UnLockOut&Include(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 1
            if ( CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM not_in_state Excluded ) then
            !    else
                    move_to LockedOut
            !    endif
            else
                do Include(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM
                insert CODEXB_VDIGITAL::CODEXB_VDIGITAL in DCS_DOMAIN_V1_FWSETSTATES
                insert CODEXB_VDIGITAL::CODEXB_VDIGITAL in DCS_DOMAIN_V1_FWSETACTIONS
                insert CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWCNM in FWCHILDRENMODE_FWSETSTATES
            endif
            move_to Included
        action: LockOutPerm	!visible: 0
            move_to LockedOutPerm
    state: ExcludedPerm
    !color: FwStateOKNotPhysics
        action: Include(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 1
            !    else
            !        move_to Excluded
            !    endif
            !else
            !endif
            !move_to Included
            if ( CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM not_in_state {Excluded, Manual} ) then
                move_to ExcludedPerm
            else
                do Include(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM
                insert CODEXB_VDIGITAL::CODEXB_VDIGITAL in DCS_DOMAIN_V1_FWSETSTATES
                insert CODEXB_VDIGITAL::CODEXB_VDIGITAL in DCS_DOMAIN_V1_FWSETACTIONS
                insert CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWCNM in FWCHILDRENMODE_FWSETSTATES
            endif
            move_to Included
        action: LockOut	!visible: 1
            move_to LockedOut
        action: Exclude(string OWNER = "")	!visible: 0
            move_to Excluded
    state: LockedOutPerm
    !color: FwStateOKNotPhysics
        action: UnLockOut	!visible: 1
            move_to Excluded
        action: UnLockOut&Include(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 1
            if ( CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM not_in_state Excluded ) then
            !    else
                    move_to LockedOutPerm
            !    endif
            else
                do Include(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWM
                insert CODEXB_VDIGITAL::CODEXB_VDIGITAL in DCS_DOMAIN_V1_FWSETSTATES
                insert CODEXB_VDIGITAL::CODEXB_VDIGITAL in DCS_DOMAIN_V1_FWSETACTIONS
                insert CODEXB_VDIGITAL::CODEXB_VDIGITAL_FWCNM in FWCHILDRENMODE_FWSETSTATES
            endif
            move_to Included
        action: LockOut	!visible: 0
            move_to LockedOut

object: CODEXB_VDIGITAL_FWM is_of_class CODEXB_VDIGITAL_FwChildMode_CLASS

class: CODEXB_VSENSE_FwChildMode_CLASS

!panel: FwChildMode.pnl
    state: Excluded
    !color: FwStateOKNotPhysics
        action: Include(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 1
            if ( CODEXB_VSENSE::CODEXB_VSENSE_FWM in_state Dead ) then
              move_to Manual
            endif
            if ( CODEXB_VSENSE::CODEXB_VSENSE_FWM not_in_state {Excluded, Manual} ) then
            !    else
                    move_to Excluded
            !    endif
            else
                do Include(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) CODEXB_VSENSE::CODEXB_VSENSE_FWM
                insert CODEXB_VSENSE::CODEXB_VSENSE in DCS_DOMAIN_V1_FWSETSTATES
                insert CODEXB_VSENSE::CODEXB_VSENSE in DCS_DOMAIN_V1_FWSETACTIONS
                insert CODEXB_VSENSE::CODEXB_VSENSE_FWCNM in FWCHILDRENMODE_FWSETSTATES
            endif
            move_to Included
        action: Manual	!visible: 0
            do Manual CODEXB_VSENSE::CODEXB_VSENSE_FWM
            insert CODEXB_VSENSE::CODEXB_VSENSE in DCS_DOMAIN_V1_FWSETSTATES
            remove CODEXB_VSENSE::CODEXB_VSENSE from DCS_DOMAIN_V1_FWSETACTIONS
            move_to Manual
        action: Ignore	!visible: 0
            do Ignore CODEXB_VSENSE::CODEXB_VSENSE_FWM
            insert CODEXB_VSENSE::CODEXB_VSENSE in DCS_DOMAIN_V1_FWSETACTIONS
            remove CODEXB_VSENSE::CODEXB_VSENSE from DCS_DOMAIN_V1_FWSETSTATES
            move_to Ignored
        action: LockOut	!visible: 1
            move_to LockedOut
        action: Exclude(string OWNER = "")	!visible: 1
            do Exclude(OWNER=OWNER) CODEXB_VSENSE::CODEXB_VSENSE_FWM
            remove CODEXB_VSENSE::CODEXB_VSENSE from DCS_DOMAIN_V1_FWSETSTATES
            remove CODEXB_VSENSE::CODEXB_VSENSE from DCS_DOMAIN_V1_FWSETACTIONS
            remove CODEXB_VSENSE::CODEXB_VSENSE_FWCNM from FWCHILDRENMODE_FWSETSTATES
            move_to Excluded
        action: ExcludePerm(string OWNER = "")	!visible: 0
            move_to ExcludedPerm
        action: Exclude&LockOut(string OWNER = "")	!visible: 0
            move_to LockedOut
    state: Included
    !color: FwStateOKPhysics
        when ( CODEXB_VSENSE::CODEXB_VSENSE_FWM in_state Excluded )  do Exclude
        when ( CODEXB_VSENSE::CODEXB_VSENSE_FWM in_state Ignored )  move_to IGNORED
        when ( CODEXB_VSENSE::CODEXB_VSENSE_FWM in_state Manual )  move_to MANUAL
        when ( CODEXB_VSENSE::CODEXB_VSENSE_FWM in_state Dead )  do Manual
        action: Exclude(string OWNER = "")	!visible: 1
            if ( CODEXB_VSENSE::CODEXB_VSENSE_FWM not_in_state Included ) then
                if ( CODEXB_VSENSE::CODEXB_VSENSE_FWM in_state InManual ) then
                    do Release(OWNER=OWNER) CODEXB_VSENSE::CODEXB_VSENSE_FWM
                    remove CODEXB_VSENSE::CODEXB_VSENSE from DCS_DOMAIN_V1_FWSETSTATES
                    remove CODEXB_VSENSE::CODEXB_VSENSE from DCS_DOMAIN_V1_FWSETACTIONS
                    remove CODEXB_VSENSE::CODEXB_VSENSE_FWCNM from FWCHILDRENMODE_FWSETSTATES
                else
                        do Exclude(OWNER=OWNER) CODEXB_VSENSE::CODEXB_VSENSE_FWM
                        remove CODEXB_VSENSE::CODEXB_VSENSE from DCS_DOMAIN_V1_FWSETSTATES
                        remove CODEXB_VSENSE::CODEXB_VSENSE from DCS_DOMAIN_V1_FWSETACTIONS
                        remove CODEXB_VSENSE::CODEXB_VSENSE_FWCNM from FWCHILDRENMODE_FWSETSTATES
            !       else
            !            move_to Included
            !        endif
                endif
            else
                do Exclude(OWNER=OWNER) CODEXB_VSENSE::CODEXB_VSENSE_FWM
                remove CODEXB_VSENSE::CODEXB_VSENSE from DCS_DOMAIN_V1_FWSETSTATES
                remove CODEXB_VSENSE::CODEXB_VSENSE from DCS_DOMAIN_V1_FWSETACTIONS
                remove CODEXB_VSENSE::CODEXB_VSENSE_FWCNM from FWCHILDRENMODE_FWSETSTATES
            endif
            move_to Excluded
        action: Manual(string OWNER = "")	!visible: 1
            do Manual(OWNER=OWNER) CODEXB_VSENSE::CODEXB_VSENSE_FWM
            insert CODEXB_VSENSE::CODEXB_VSENSE in DCS_DOMAIN_V1_FWSETSTATES
            remove CODEXB_VSENSE::CODEXB_VSENSE from DCS_DOMAIN_V1_FWSETACTIONS
            move_to Manual
        action: Ignore(string OWNER = "")	!visible: 1
            do Ignore(OWNER=OWNER) CODEXB_VSENSE::CODEXB_VSENSE_FWM
            insert CODEXB_VSENSE::CODEXB_VSENSE in DCS_DOMAIN_V1_FWSETACTIONS
            remove CODEXB_VSENSE::CODEXB_VSENSE from DCS_DOMAIN_V1_FWSETSTATES
            move_to Ignored
        action: ExcludeAll(string OWNER = "")	!visible: 1
            if ( CODEXB_VSENSE::CODEXB_VSENSE_FWM not_in_state {Included,Ignored,Manual} ) then
                if ( CODEXB_VSENSE::CODEXB_VSENSE_FWM in_state InManual ) then
                    do ReleaseAll(OWNER=OWNER) CODEXB_VSENSE::CODEXB_VSENSE_FWM
                    remove CODEXB_VSENSE::CODEXB_VSENSE from DCS_DOMAIN_V1_FWSETSTATES
                    remove CODEXB_VSENSE::CODEXB_VSENSE from DCS_DOMAIN_V1_FWSETACTIONS
                    remove CODEXB_VSENSE::CODEXB_VSENSE_FWCNM from FWCHILDRENMODE_FWSETSTATES
                else
                    move_to Included
                endif
            else
                do ExcludeAll(OWNER=OWNER) CODEXB_VSENSE::CODEXB_VSENSE_FWM
                remove CODEXB_VSENSE::CODEXB_VSENSE from DCS_DOMAIN_V1_FWSETSTATES
                remove CODEXB_VSENSE::CODEXB_VSENSE from DCS_DOMAIN_V1_FWSETACTIONS
                remove CODEXB_VSENSE::CODEXB_VSENSE_FWCNM from FWCHILDRENMODE_FWSETSTATES
            endif
            move_to Excluded
        action: Include(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 1
            do Include(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) CODEXB_VSENSE::CODEXB_VSENSE_FWM
            insert CODEXB_VSENSE::CODEXB_VSENSE in DCS_DOMAIN_V1_FWSETSTATES
            insert CODEXB_VSENSE::CODEXB_VSENSE in DCS_DOMAIN_V1_FWSETACTIONS
            insert CODEXB_VSENSE::CODEXB_VSENSE_FWCNM in FWCHILDRENMODE_FWSETSTATES
            move_to Included
        action: Free(string OWNER = "")	!visible: 0
            do Free(OWNER=OWNER) CODEXB_VSENSE::CODEXB_VSENSE_FWM
            move_to Included
        action: SetMode(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 0
            do SetMode(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) CODEXB_VSENSE::CODEXB_VSENSE_FWM
        action: ExcludePerm(string OWNER = "")	!visible: 0
            if ( CODEXB_VSENSE::CODEXB_VSENSE_FWM not_in_state Included ) then
                if ( CODEXB_VSENSE::CODEXB_VSENSE_FWM in_state InManual ) then
                    do Release(OWNER=OWNER) CODEXB_VSENSE::CODEXB_VSENSE_FWM
                    remove CODEXB_VSENSE::CODEXB_VSENSE from DCS_DOMAIN_V1_FWSETSTATES
                    remove CODEXB_VSENSE::CODEXB_VSENSE from DCS_DOMAIN_V1_FWSETACTIONS
                    remove CODEXB_VSENSE::CODEXB_VSENSE_FWCNM from FWCHILDRENMODE_FWSETSTATES
                else
                    move_to Included
                endif
            else
                do Exclude(OWNER=OWNER) CODEXB_VSENSE::CODEXB_VSENSE_FWM
                remove CODEXB_VSENSE::CODEXB_VSENSE from DCS_DOMAIN_V1_FWSETSTATES
                remove CODEXB_VSENSE::CODEXB_VSENSE from DCS_DOMAIN_V1_FWSETACTIONS
                remove CODEXB_VSENSE::CODEXB_VSENSE_FWCNM from FWCHILDRENMODE_FWSETSTATES
            endif
            move_to ExcludedPerm
        action: Exclude&LockOut(string OWNER = "")	!visible: 1
            if ( CODEXB_VSENSE::CODEXB_VSENSE_FWM not_in_state Included ) then
                if ( CODEXB_VSENSE::CODEXB_VSENSE_FWM in_state InManual ) then
                    do Release(OWNER=OWNER) CODEXB_VSENSE::CODEXB_VSENSE_FWM
                    remove CODEXB_VSENSE::CODEXB_VSENSE from DCS_DOMAIN_V1_FWSETSTATES
                    remove CODEXB_VSENSE::CODEXB_VSENSE from DCS_DOMAIN_V1_FWSETACTIONS
                    remove CODEXB_VSENSE::CODEXB_VSENSE_FWCNM from FWCHILDRENMODE_FWSETSTATES
                else
                    if ( CODEXB_VSENSE::CODEXB_VSENSE_FWM in_state Dead ) then
                        do Exclude(OWNER=OWNER) CODEXB_VSENSE::CODEXB_VSENSE_FWM
                        remove CODEXB_VSENSE::CODEXB_VSENSE from DCS_DOMAIN_V1_FWSETSTATES
                        remove CODEXB_VSENSE::CODEXB_VSENSE from DCS_DOMAIN_V1_FWSETACTIONS
                        remove CODEXB_VSENSE::CODEXB_VSENSE_FWCNM from FWCHILDRENMODE_FWSETSTATES
                   else
                        move_to Included
                    endif
                endif
            else
                do Exclude(OWNER=OWNER) CODEXB_VSENSE::CODEXB_VSENSE_FWM
                remove CODEXB_VSENSE::CODEXB_VSENSE from DCS_DOMAIN_V1_FWSETSTATES
                remove CODEXB_VSENSE::CODEXB_VSENSE from DCS_DOMAIN_V1_FWSETACTIONS
                remove CODEXB_VSENSE::CODEXB_VSENSE_FWCNM from FWCHILDRENMODE_FWSETSTATES
            endif
            move_to LockedOut
    state: Manual
    !color: FwStateOKNotPhysics
        when ( CODEXB_VSENSE::CODEXB_VSENSE_FWM in_state Included )  move_to EXCLUDED
        action: Include(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 1
            if ( CODEXB_VSENSE::CODEXB_VSENSE_FWM in_state Dead ) then
              move_to Manual
            endif
            if ( CODEXB_VSENSE::CODEXB_VSENSE_FWM not_in_state InManual ) then
              do Include(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) CODEXB_VSENSE::CODEXB_VSENSE_FWM
              insert CODEXB_VSENSE::CODEXB_VSENSE in DCS_DOMAIN_V1_FWSETSTATES
              insert CODEXB_VSENSE::CODEXB_VSENSE in DCS_DOMAIN_V1_FWSETACTIONS
              insert CODEXB_VSENSE::CODEXB_VSENSE_FWCNM in FWCHILDRENMODE_FWSETSTATES
            endif
              if ( CODEXB_VSENSE::CODEXB_VSENSE_FWM in_state Included ) then
                move_to Included
              endif
            move_to Manual
        action: Exclude(string OWNER = "")	!visible: 1
                do Exclude(OWNER=OWNER) CODEXB_VSENSE::CODEXB_VSENSE_FWM
                remove CODEXB_VSENSE::CODEXB_VSENSE from DCS_DOMAIN_V1_FWSETSTATES
                remove CODEXB_VSENSE::CODEXB_VSENSE from DCS_DOMAIN_V1_FWSETACTIONS
                remove CODEXB_VSENSE::CODEXB_VSENSE_FWCNM from FWCHILDRENMODE_FWSETSTATES
            !    move_to Excluded
            !endif
            !    else
            !    endif
            !else
            !endif
            !    move_to Excluded
            !endif
            !move_to Manual
            if ( CODEXB_VSENSE::CODEXB_VSENSE_FWM in_state InManual ) then
                 do SetInLocal CODEXB_VSENSE::CODEXB_VSENSE_FWM
            endif
            move_to Excluded
        action: Ignore	!visible: 0
            do Ignore CODEXB_VSENSE::CODEXB_VSENSE_FWM
            insert CODEXB_VSENSE::CODEXB_VSENSE in DCS_DOMAIN_V1_FWSETACTIONS
            remove CODEXB_VSENSE::CODEXB_VSENSE from DCS_DOMAIN_V1_FWSETSTATES
            move_to Ignored
        action: Free(string OWNER = "")	!visible: 0
            do Free(OWNER=OWNER) CODEXB_VSENSE::CODEXB_VSENSE_FWM
            !move_to Manual
            if ( CODEXB_VSENSE::CODEXB_VSENSE_FWM in_state InManual ) then
                 do SetInLocal CODEXB_VSENSE::CODEXB_VSENSE_FWM
            endif
            move_to Excluded
        action: ExcludeAll(string OWNER = "")	!visible: 1
            !    else
            !        move_to Included
            !    endif
            !else
            !endif
              do ExcludeAll(OWNER=OWNER) CODEXB_VSENSE::CODEXB_VSENSE_FWM
              remove CODEXB_VSENSE::CODEXB_VSENSE from DCS_DOMAIN_V1_FWSETSTATES
              remove CODEXB_VSENSE::CODEXB_VSENSE from DCS_DOMAIN_V1_FWSETACTIONS
              remove CODEXB_VSENSE::CODEXB_VSENSE_FWCNM from FWCHILDRENMODE_FWSETSTATES
            !endif
            !move_to Manual
            if ( CODEXB_VSENSE::CODEXB_VSENSE_FWM in_state InManual ) then
                 do SetInLocal CODEXB_VSENSE::CODEXB_VSENSE_FWM
            endif
            move_to Excluded
        action: Manual	!visible: 0
            do Manual CODEXB_VSENSE::CODEXB_VSENSE_FWM
            insert CODEXB_VSENSE::CODEXB_VSENSE in DCS_DOMAIN_V1_FWSETSTATES
            remove CODEXB_VSENSE::CODEXB_VSENSE from DCS_DOMAIN_V1_FWSETACTIONS
            move_to Manual
        action: Exclude&LockOut(string OWNER = "")	!visible: 1
                do Exclude(OWNER=OWNER) CODEXB_VSENSE::CODEXB_VSENSE_FWM
                remove CODEXB_VSENSE::CODEXB_VSENSE from DCS_DOMAIN_V1_FWSETSTATES
                remove CODEXB_VSENSE::CODEXB_VSENSE from DCS_DOMAIN_V1_FWSETACTIONS
                remove CODEXB_VSENSE::CODEXB_VSENSE_FWCNM from FWCHILDRENMODE_FWSETSTATES
            !    move_to Excluded
            !endif
            !    else
            !    endif
            !else
            !endif
            !    move_to Excluded
            !endif
            !move_to Manual
            if ( CODEXB_VSENSE::CODEXB_VSENSE_FWM in_state InManual ) then
                 do SetInLocal CODEXB_VSENSE::CODEXB_VSENSE_FWM
            endif
            move_to LockedOut
    state: Ignored
    !color: FwStateOKNotPhysics
        when ( CODEXB_VSENSE::CODEXB_VSENSE_FWM in_state Included )  move_to INCLUDED
        when ( CODEXB_VSENSE::CODEXB_VSENSE_FWM in_state Excluded ) move_to EXCLUDED
        when ( CODEXB_VSENSE::CODEXB_VSENSE_FWM in_state Dead )  do Exclude
        action: Include(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 1
            do Include(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) CODEXB_VSENSE::CODEXB_VSENSE_FWM
            insert CODEXB_VSENSE::CODEXB_VSENSE in DCS_DOMAIN_V1_FWSETSTATES
            insert CODEXB_VSENSE::CODEXB_VSENSE in DCS_DOMAIN_V1_FWSETACTIONS
            insert CODEXB_VSENSE::CODEXB_VSENSE_FWCNM in FWCHILDRENMODE_FWSETSTATES
            move_to Included
        action: Exclude(string OWNER = "")	!visible: 1
            if ( CODEXB_VSENSE::CODEXB_VSENSE_FWM not_in_state Included ) then
                if ( CODEXB_VSENSE::CODEXB_VSENSE_FWM in_state InManual ) then
                    do Release(OWNER=OWNER) CODEXB_VSENSE::CODEXB_VSENSE_FWM
                    remove CODEXB_VSENSE::CODEXB_VSENSE from DCS_DOMAIN_V1_FWSETSTATES
                    remove CODEXB_VSENSE::CODEXB_VSENSE from DCS_DOMAIN_V1_FWSETACTIONS
                    remove CODEXB_VSENSE::CODEXB_VSENSE_FWCNM from FWCHILDRENMODE_FWSETSTATES
                else
                    do Exclude(OWNER=OWNER) CODEXB_VSENSE::CODEXB_VSENSE_FWM
                    remove CODEXB_VSENSE::CODEXB_VSENSE from DCS_DOMAIN_V1_FWSETSTATES
                    remove CODEXB_VSENSE::CODEXB_VSENSE from DCS_DOMAIN_V1_FWSETACTIONS
                    remove CODEXB_VSENSE::CODEXB_VSENSE_FWCNM from FWCHILDRENMODE_FWSETSTATES
                endif
            else
                do Exclude(OWNER=OWNER) CODEXB_VSENSE::CODEXB_VSENSE_FWM
                remove CODEXB_VSENSE::CODEXB_VSENSE from DCS_DOMAIN_V1_FWSETSTATES
                remove CODEXB_VSENSE::CODEXB_VSENSE from DCS_DOMAIN_V1_FWSETACTIONS
                remove CODEXB_VSENSE::CODEXB_VSENSE_FWCNM from FWCHILDRENMODE_FWSETSTATES
            endif
            move_to Excluded
        action: Manual(string OWNER = "")	!visible: 0
            do Manual(OWNER=OWNER) CODEXB_VSENSE::CODEXB_VSENSE_FWM
            insert CODEXB_VSENSE::CODEXB_VSENSE in DCS_DOMAIN_V1_FWSETSTATES
            remove CODEXB_VSENSE::CODEXB_VSENSE from DCS_DOMAIN_V1_FWSETACTIONS
            move_to Manual
        action: SetMode(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 0
            do SetMode(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) CODEXB_VSENSE::CODEXB_VSENSE_FWM
        action: Free(string OWNER = "")	!visible: 0
            do Free(OWNER=OWNER) CODEXB_VSENSE::CODEXB_VSENSE_FWM
            move_to Included
        action: ExcludeAll(string OWNER = "")	!visible: 1
            if ( CODEXB_VSENSE::CODEXB_VSENSE_FWM not_in_state {Included,Ignored,Manual} ) then
                if ( CODEXB_VSENSE::CODEXB_VSENSE_FWM in_state InManual ) then
                    do ReleaseAll(OWNER=OWNER) CODEXB_VSENSE::CODEXB_VSENSE_FWM
                    remove CODEXB_VSENSE::CODEXB_VSENSE from DCS_DOMAIN_V1_FWSETSTATES
                    remove CODEXB_VSENSE::CODEXB_VSENSE from DCS_DOMAIN_V1_FWSETACTIONS
                    remove CODEXB_VSENSE::CODEXB_VSENSE_FWCNM from FWCHILDRENMODE_FWSETSTATES
                else
                    move_to Included
                endif
            else
                do ExcludeAll(OWNER=OWNER) CODEXB_VSENSE::CODEXB_VSENSE_FWM
                remove CODEXB_VSENSE::CODEXB_VSENSE from DCS_DOMAIN_V1_FWSETSTATES
                remove CODEXB_VSENSE::CODEXB_VSENSE from DCS_DOMAIN_V1_FWSETACTIONS
                remove CODEXB_VSENSE::CODEXB_VSENSE_FWCNM from FWCHILDRENMODE_FWSETSTATES
            endif
            move_to Excluded
    state: LockedOut
    !color: FwStateOKNotPhysics
        action: UnLockOut	!visible: 1
            move_to Excluded
        action: UnLockOut&Include(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 1
            if ( CODEXB_VSENSE::CODEXB_VSENSE_FWM not_in_state Excluded ) then
            !    else
                    move_to LockedOut
            !    endif
            else
                do Include(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) CODEXB_VSENSE::CODEXB_VSENSE_FWM
                insert CODEXB_VSENSE::CODEXB_VSENSE in DCS_DOMAIN_V1_FWSETSTATES
                insert CODEXB_VSENSE::CODEXB_VSENSE in DCS_DOMAIN_V1_FWSETACTIONS
                insert CODEXB_VSENSE::CODEXB_VSENSE_FWCNM in FWCHILDRENMODE_FWSETSTATES
            endif
            move_to Included
        action: LockOutPerm	!visible: 0
            move_to LockedOutPerm
    state: ExcludedPerm
    !color: FwStateOKNotPhysics
        action: Include(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 1
            !    else
            !        move_to Excluded
            !    endif
            !else
            !endif
            !move_to Included
            if ( CODEXB_VSENSE::CODEXB_VSENSE_FWM not_in_state {Excluded, Manual} ) then
                move_to ExcludedPerm
            else
                do Include(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) CODEXB_VSENSE::CODEXB_VSENSE_FWM
                insert CODEXB_VSENSE::CODEXB_VSENSE in DCS_DOMAIN_V1_FWSETSTATES
                insert CODEXB_VSENSE::CODEXB_VSENSE in DCS_DOMAIN_V1_FWSETACTIONS
                insert CODEXB_VSENSE::CODEXB_VSENSE_FWCNM in FWCHILDRENMODE_FWSETSTATES
            endif
            move_to Included
        action: LockOut	!visible: 1
            move_to LockedOut
        action: Exclude(string OWNER = "")	!visible: 0
            move_to Excluded
    state: LockedOutPerm
    !color: FwStateOKNotPhysics
        action: UnLockOut	!visible: 1
            move_to Excluded
        action: UnLockOut&Include(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 1
            if ( CODEXB_VSENSE::CODEXB_VSENSE_FWM not_in_state Excluded ) then
            !    else
                    move_to LockedOutPerm
            !    endif
            else
                do Include(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) CODEXB_VSENSE::CODEXB_VSENSE_FWM
                insert CODEXB_VSENSE::CODEXB_VSENSE in DCS_DOMAIN_V1_FWSETSTATES
                insert CODEXB_VSENSE::CODEXB_VSENSE in DCS_DOMAIN_V1_FWSETACTIONS
                insert CODEXB_VSENSE::CODEXB_VSENSE_FWCNM in FWCHILDRENMODE_FWSETSTATES
            endif
            move_to Included
        action: LockOut	!visible: 0
            move_to LockedOut

object: CODEXB_VSENSE_FWM is_of_class CODEXB_VSENSE_FwChildMode_CLASS

class: CODEXB_VTHETA_FwChildMode_CLASS

!panel: FwChildMode.pnl
    state: Excluded
    !color: FwStateOKNotPhysics
        action: Include(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 1
            if ( CODEXB_VTHETA::CODEXB_VTHETA_FWM in_state Dead ) then
              move_to Manual
            endif
            if ( CODEXB_VTHETA::CODEXB_VTHETA_FWM not_in_state {Excluded, Manual} ) then
            !    else
                    move_to Excluded
            !    endif
            else
                do Include(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) CODEXB_VTHETA::CODEXB_VTHETA_FWM
                insert CODEXB_VTHETA::CODEXB_VTHETA in DCS_DOMAIN_V1_FWSETSTATES
                insert CODEXB_VTHETA::CODEXB_VTHETA in DCS_DOMAIN_V1_FWSETACTIONS
                insert CODEXB_VTHETA::CODEXB_VTHETA_FWCNM in FWCHILDRENMODE_FWSETSTATES
            endif
            move_to Included
        action: Manual	!visible: 0
            do Manual CODEXB_VTHETA::CODEXB_VTHETA_FWM
            insert CODEXB_VTHETA::CODEXB_VTHETA in DCS_DOMAIN_V1_FWSETSTATES
            remove CODEXB_VTHETA::CODEXB_VTHETA from DCS_DOMAIN_V1_FWSETACTIONS
            move_to Manual
        action: Ignore	!visible: 0
            do Ignore CODEXB_VTHETA::CODEXB_VTHETA_FWM
            insert CODEXB_VTHETA::CODEXB_VTHETA in DCS_DOMAIN_V1_FWSETACTIONS
            remove CODEXB_VTHETA::CODEXB_VTHETA from DCS_DOMAIN_V1_FWSETSTATES
            move_to Ignored
        action: LockOut	!visible: 1
            move_to LockedOut
        action: Exclude(string OWNER = "")	!visible: 1
            do Exclude(OWNER=OWNER) CODEXB_VTHETA::CODEXB_VTHETA_FWM
            remove CODEXB_VTHETA::CODEXB_VTHETA from DCS_DOMAIN_V1_FWSETSTATES
            remove CODEXB_VTHETA::CODEXB_VTHETA from DCS_DOMAIN_V1_FWSETACTIONS
            remove CODEXB_VTHETA::CODEXB_VTHETA_FWCNM from FWCHILDRENMODE_FWSETSTATES
            move_to Excluded
        action: ExcludePerm(string OWNER = "")	!visible: 0
            move_to ExcludedPerm
        action: Exclude&LockOut(string OWNER = "")	!visible: 0
            move_to LockedOut
    state: Included
    !color: FwStateOKPhysics
        when ( CODEXB_VTHETA::CODEXB_VTHETA_FWM in_state Excluded )  do Exclude
        when ( CODEXB_VTHETA::CODEXB_VTHETA_FWM in_state Ignored )  move_to IGNORED
        when ( CODEXB_VTHETA::CODEXB_VTHETA_FWM in_state Manual )  move_to MANUAL
        when ( CODEXB_VTHETA::CODEXB_VTHETA_FWM in_state Dead )  do Manual
        action: Exclude(string OWNER = "")	!visible: 1
            if ( CODEXB_VTHETA::CODEXB_VTHETA_FWM not_in_state Included ) then
                if ( CODEXB_VTHETA::CODEXB_VTHETA_FWM in_state InManual ) then
                    do Release(OWNER=OWNER) CODEXB_VTHETA::CODEXB_VTHETA_FWM
                    remove CODEXB_VTHETA::CODEXB_VTHETA from DCS_DOMAIN_V1_FWSETSTATES
                    remove CODEXB_VTHETA::CODEXB_VTHETA from DCS_DOMAIN_V1_FWSETACTIONS
                    remove CODEXB_VTHETA::CODEXB_VTHETA_FWCNM from FWCHILDRENMODE_FWSETSTATES
                else
                        do Exclude(OWNER=OWNER) CODEXB_VTHETA::CODEXB_VTHETA_FWM
                        remove CODEXB_VTHETA::CODEXB_VTHETA from DCS_DOMAIN_V1_FWSETSTATES
                        remove CODEXB_VTHETA::CODEXB_VTHETA from DCS_DOMAIN_V1_FWSETACTIONS
                        remove CODEXB_VTHETA::CODEXB_VTHETA_FWCNM from FWCHILDRENMODE_FWSETSTATES
            !       else
            !            move_to Included
            !        endif
                endif
            else
                do Exclude(OWNER=OWNER) CODEXB_VTHETA::CODEXB_VTHETA_FWM
                remove CODEXB_VTHETA::CODEXB_VTHETA from DCS_DOMAIN_V1_FWSETSTATES
                remove CODEXB_VTHETA::CODEXB_VTHETA from DCS_DOMAIN_V1_FWSETACTIONS
                remove CODEXB_VTHETA::CODEXB_VTHETA_FWCNM from FWCHILDRENMODE_FWSETSTATES
            endif
            move_to Excluded
        action: Manual(string OWNER = "")	!visible: 1
            do Manual(OWNER=OWNER) CODEXB_VTHETA::CODEXB_VTHETA_FWM
            insert CODEXB_VTHETA::CODEXB_VTHETA in DCS_DOMAIN_V1_FWSETSTATES
            remove CODEXB_VTHETA::CODEXB_VTHETA from DCS_DOMAIN_V1_FWSETACTIONS
            move_to Manual
        action: Ignore(string OWNER = "")	!visible: 1
            do Ignore(OWNER=OWNER) CODEXB_VTHETA::CODEXB_VTHETA_FWM
            insert CODEXB_VTHETA::CODEXB_VTHETA in DCS_DOMAIN_V1_FWSETACTIONS
            remove CODEXB_VTHETA::CODEXB_VTHETA from DCS_DOMAIN_V1_FWSETSTATES
            move_to Ignored
        action: ExcludeAll(string OWNER = "")	!visible: 1
            if ( CODEXB_VTHETA::CODEXB_VTHETA_FWM not_in_state {Included,Ignored,Manual} ) then
                if ( CODEXB_VTHETA::CODEXB_VTHETA_FWM in_state InManual ) then
                    do ReleaseAll(OWNER=OWNER) CODEXB_VTHETA::CODEXB_VTHETA_FWM
                    remove CODEXB_VTHETA::CODEXB_VTHETA from DCS_DOMAIN_V1_FWSETSTATES
                    remove CODEXB_VTHETA::CODEXB_VTHETA from DCS_DOMAIN_V1_FWSETACTIONS
                    remove CODEXB_VTHETA::CODEXB_VTHETA_FWCNM from FWCHILDRENMODE_FWSETSTATES
                else
                    move_to Included
                endif
            else
                do ExcludeAll(OWNER=OWNER) CODEXB_VTHETA::CODEXB_VTHETA_FWM
                remove CODEXB_VTHETA::CODEXB_VTHETA from DCS_DOMAIN_V1_FWSETSTATES
                remove CODEXB_VTHETA::CODEXB_VTHETA from DCS_DOMAIN_V1_FWSETACTIONS
                remove CODEXB_VTHETA::CODEXB_VTHETA_FWCNM from FWCHILDRENMODE_FWSETSTATES
            endif
            move_to Excluded
        action: Include(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 1
            do Include(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) CODEXB_VTHETA::CODEXB_VTHETA_FWM
            insert CODEXB_VTHETA::CODEXB_VTHETA in DCS_DOMAIN_V1_FWSETSTATES
            insert CODEXB_VTHETA::CODEXB_VTHETA in DCS_DOMAIN_V1_FWSETACTIONS
            insert CODEXB_VTHETA::CODEXB_VTHETA_FWCNM in FWCHILDRENMODE_FWSETSTATES
            move_to Included
        action: Free(string OWNER = "")	!visible: 0
            do Free(OWNER=OWNER) CODEXB_VTHETA::CODEXB_VTHETA_FWM
            move_to Included
        action: SetMode(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 0
            do SetMode(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) CODEXB_VTHETA::CODEXB_VTHETA_FWM
        action: ExcludePerm(string OWNER = "")	!visible: 0
            if ( CODEXB_VTHETA::CODEXB_VTHETA_FWM not_in_state Included ) then
                if ( CODEXB_VTHETA::CODEXB_VTHETA_FWM in_state InManual ) then
                    do Release(OWNER=OWNER) CODEXB_VTHETA::CODEXB_VTHETA_FWM
                    remove CODEXB_VTHETA::CODEXB_VTHETA from DCS_DOMAIN_V1_FWSETSTATES
                    remove CODEXB_VTHETA::CODEXB_VTHETA from DCS_DOMAIN_V1_FWSETACTIONS
                    remove CODEXB_VTHETA::CODEXB_VTHETA_FWCNM from FWCHILDRENMODE_FWSETSTATES
                else
                    move_to Included
                endif
            else
                do Exclude(OWNER=OWNER) CODEXB_VTHETA::CODEXB_VTHETA_FWM
                remove CODEXB_VTHETA::CODEXB_VTHETA from DCS_DOMAIN_V1_FWSETSTATES
                remove CODEXB_VTHETA::CODEXB_VTHETA from DCS_DOMAIN_V1_FWSETACTIONS
                remove CODEXB_VTHETA::CODEXB_VTHETA_FWCNM from FWCHILDRENMODE_FWSETSTATES
            endif
            move_to ExcludedPerm
        action: Exclude&LockOut(string OWNER = "")	!visible: 1
            if ( CODEXB_VTHETA::CODEXB_VTHETA_FWM not_in_state Included ) then
                if ( CODEXB_VTHETA::CODEXB_VTHETA_FWM in_state InManual ) then
                    do Release(OWNER=OWNER) CODEXB_VTHETA::CODEXB_VTHETA_FWM
                    remove CODEXB_VTHETA::CODEXB_VTHETA from DCS_DOMAIN_V1_FWSETSTATES
                    remove CODEXB_VTHETA::CODEXB_VTHETA from DCS_DOMAIN_V1_FWSETACTIONS
                    remove CODEXB_VTHETA::CODEXB_VTHETA_FWCNM from FWCHILDRENMODE_FWSETSTATES
                else
                    if ( CODEXB_VTHETA::CODEXB_VTHETA_FWM in_state Dead ) then
                        do Exclude(OWNER=OWNER) CODEXB_VTHETA::CODEXB_VTHETA_FWM
                        remove CODEXB_VTHETA::CODEXB_VTHETA from DCS_DOMAIN_V1_FWSETSTATES
                        remove CODEXB_VTHETA::CODEXB_VTHETA from DCS_DOMAIN_V1_FWSETACTIONS
                        remove CODEXB_VTHETA::CODEXB_VTHETA_FWCNM from FWCHILDRENMODE_FWSETSTATES
                   else
                        move_to Included
                    endif
                endif
            else
                do Exclude(OWNER=OWNER) CODEXB_VTHETA::CODEXB_VTHETA_FWM
                remove CODEXB_VTHETA::CODEXB_VTHETA from DCS_DOMAIN_V1_FWSETSTATES
                remove CODEXB_VTHETA::CODEXB_VTHETA from DCS_DOMAIN_V1_FWSETACTIONS
                remove CODEXB_VTHETA::CODEXB_VTHETA_FWCNM from FWCHILDRENMODE_FWSETSTATES
            endif
            move_to LockedOut
    state: Manual
    !color: FwStateOKNotPhysics
        when ( CODEXB_VTHETA::CODEXB_VTHETA_FWM in_state Included )  move_to EXCLUDED
        action: Include(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 1
            if ( CODEXB_VTHETA::CODEXB_VTHETA_FWM in_state Dead ) then
              move_to Manual
            endif
            if ( CODEXB_VTHETA::CODEXB_VTHETA_FWM not_in_state InManual ) then
              do Include(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) CODEXB_VTHETA::CODEXB_VTHETA_FWM
              insert CODEXB_VTHETA::CODEXB_VTHETA in DCS_DOMAIN_V1_FWSETSTATES
              insert CODEXB_VTHETA::CODEXB_VTHETA in DCS_DOMAIN_V1_FWSETACTIONS
              insert CODEXB_VTHETA::CODEXB_VTHETA_FWCNM in FWCHILDRENMODE_FWSETSTATES
            endif
              if ( CODEXB_VTHETA::CODEXB_VTHETA_FWM in_state Included ) then
                move_to Included
              endif
            move_to Manual
        action: Exclude(string OWNER = "")	!visible: 1
                do Exclude(OWNER=OWNER) CODEXB_VTHETA::CODEXB_VTHETA_FWM
                remove CODEXB_VTHETA::CODEXB_VTHETA from DCS_DOMAIN_V1_FWSETSTATES
                remove CODEXB_VTHETA::CODEXB_VTHETA from DCS_DOMAIN_V1_FWSETACTIONS
                remove CODEXB_VTHETA::CODEXB_VTHETA_FWCNM from FWCHILDRENMODE_FWSETSTATES
            !    move_to Excluded
            !endif
            !    else
            !    endif
            !else
            !endif
            !    move_to Excluded
            !endif
            !move_to Manual
            if ( CODEXB_VTHETA::CODEXB_VTHETA_FWM in_state InManual ) then
                 do SetInLocal CODEXB_VTHETA::CODEXB_VTHETA_FWM
            endif
            move_to Excluded
        action: Ignore	!visible: 0
            do Ignore CODEXB_VTHETA::CODEXB_VTHETA_FWM
            insert CODEXB_VTHETA::CODEXB_VTHETA in DCS_DOMAIN_V1_FWSETACTIONS
            remove CODEXB_VTHETA::CODEXB_VTHETA from DCS_DOMAIN_V1_FWSETSTATES
            move_to Ignored
        action: Free(string OWNER = "")	!visible: 0
            do Free(OWNER=OWNER) CODEXB_VTHETA::CODEXB_VTHETA_FWM
            !move_to Manual
            if ( CODEXB_VTHETA::CODEXB_VTHETA_FWM in_state InManual ) then
                 do SetInLocal CODEXB_VTHETA::CODEXB_VTHETA_FWM
            endif
            move_to Excluded
        action: ExcludeAll(string OWNER = "")	!visible: 1
            !    else
            !        move_to Included
            !    endif
            !else
            !endif
              do ExcludeAll(OWNER=OWNER) CODEXB_VTHETA::CODEXB_VTHETA_FWM
              remove CODEXB_VTHETA::CODEXB_VTHETA from DCS_DOMAIN_V1_FWSETSTATES
              remove CODEXB_VTHETA::CODEXB_VTHETA from DCS_DOMAIN_V1_FWSETACTIONS
              remove CODEXB_VTHETA::CODEXB_VTHETA_FWCNM from FWCHILDRENMODE_FWSETSTATES
            !endif
            !move_to Manual
            if ( CODEXB_VTHETA::CODEXB_VTHETA_FWM in_state InManual ) then
                 do SetInLocal CODEXB_VTHETA::CODEXB_VTHETA_FWM
            endif
            move_to Excluded
        action: Manual	!visible: 0
            do Manual CODEXB_VTHETA::CODEXB_VTHETA_FWM
            insert CODEXB_VTHETA::CODEXB_VTHETA in DCS_DOMAIN_V1_FWSETSTATES
            remove CODEXB_VTHETA::CODEXB_VTHETA from DCS_DOMAIN_V1_FWSETACTIONS
            move_to Manual
        action: Exclude&LockOut(string OWNER = "")	!visible: 1
                do Exclude(OWNER=OWNER) CODEXB_VTHETA::CODEXB_VTHETA_FWM
                remove CODEXB_VTHETA::CODEXB_VTHETA from DCS_DOMAIN_V1_FWSETSTATES
                remove CODEXB_VTHETA::CODEXB_VTHETA from DCS_DOMAIN_V1_FWSETACTIONS
                remove CODEXB_VTHETA::CODEXB_VTHETA_FWCNM from FWCHILDRENMODE_FWSETSTATES
            !    move_to Excluded
            !endif
            !    else
            !    endif
            !else
            !endif
            !    move_to Excluded
            !endif
            !move_to Manual
            if ( CODEXB_VTHETA::CODEXB_VTHETA_FWM in_state InManual ) then
                 do SetInLocal CODEXB_VTHETA::CODEXB_VTHETA_FWM
            endif
            move_to LockedOut
    state: Ignored
    !color: FwStateOKNotPhysics
        when ( CODEXB_VTHETA::CODEXB_VTHETA_FWM in_state Included )  move_to INCLUDED
        when ( CODEXB_VTHETA::CODEXB_VTHETA_FWM in_state Excluded ) move_to EXCLUDED
        when ( CODEXB_VTHETA::CODEXB_VTHETA_FWM in_state Dead )  do Exclude
        action: Include(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 1
            do Include(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) CODEXB_VTHETA::CODEXB_VTHETA_FWM
            insert CODEXB_VTHETA::CODEXB_VTHETA in DCS_DOMAIN_V1_FWSETSTATES
            insert CODEXB_VTHETA::CODEXB_VTHETA in DCS_DOMAIN_V1_FWSETACTIONS
            insert CODEXB_VTHETA::CODEXB_VTHETA_FWCNM in FWCHILDRENMODE_FWSETSTATES
            move_to Included
        action: Exclude(string OWNER = "")	!visible: 1
            if ( CODEXB_VTHETA::CODEXB_VTHETA_FWM not_in_state Included ) then
                if ( CODEXB_VTHETA::CODEXB_VTHETA_FWM in_state InManual ) then
                    do Release(OWNER=OWNER) CODEXB_VTHETA::CODEXB_VTHETA_FWM
                    remove CODEXB_VTHETA::CODEXB_VTHETA from DCS_DOMAIN_V1_FWSETSTATES
                    remove CODEXB_VTHETA::CODEXB_VTHETA from DCS_DOMAIN_V1_FWSETACTIONS
                    remove CODEXB_VTHETA::CODEXB_VTHETA_FWCNM from FWCHILDRENMODE_FWSETSTATES
                else
                    do Exclude(OWNER=OWNER) CODEXB_VTHETA::CODEXB_VTHETA_FWM
                    remove CODEXB_VTHETA::CODEXB_VTHETA from DCS_DOMAIN_V1_FWSETSTATES
                    remove CODEXB_VTHETA::CODEXB_VTHETA from DCS_DOMAIN_V1_FWSETACTIONS
                    remove CODEXB_VTHETA::CODEXB_VTHETA_FWCNM from FWCHILDRENMODE_FWSETSTATES
                endif
            else
                do Exclude(OWNER=OWNER) CODEXB_VTHETA::CODEXB_VTHETA_FWM
                remove CODEXB_VTHETA::CODEXB_VTHETA from DCS_DOMAIN_V1_FWSETSTATES
                remove CODEXB_VTHETA::CODEXB_VTHETA from DCS_DOMAIN_V1_FWSETACTIONS
                remove CODEXB_VTHETA::CODEXB_VTHETA_FWCNM from FWCHILDRENMODE_FWSETSTATES
            endif
            move_to Excluded
        action: Manual(string OWNER = "")	!visible: 0
            do Manual(OWNER=OWNER) CODEXB_VTHETA::CODEXB_VTHETA_FWM
            insert CODEXB_VTHETA::CODEXB_VTHETA in DCS_DOMAIN_V1_FWSETSTATES
            remove CODEXB_VTHETA::CODEXB_VTHETA from DCS_DOMAIN_V1_FWSETACTIONS
            move_to Manual
        action: SetMode(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 0
            do SetMode(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) CODEXB_VTHETA::CODEXB_VTHETA_FWM
        action: Free(string OWNER = "")	!visible: 0
            do Free(OWNER=OWNER) CODEXB_VTHETA::CODEXB_VTHETA_FWM
            move_to Included
        action: ExcludeAll(string OWNER = "")	!visible: 1
            if ( CODEXB_VTHETA::CODEXB_VTHETA_FWM not_in_state {Included,Ignored,Manual} ) then
                if ( CODEXB_VTHETA::CODEXB_VTHETA_FWM in_state InManual ) then
                    do ReleaseAll(OWNER=OWNER) CODEXB_VTHETA::CODEXB_VTHETA_FWM
                    remove CODEXB_VTHETA::CODEXB_VTHETA from DCS_DOMAIN_V1_FWSETSTATES
                    remove CODEXB_VTHETA::CODEXB_VTHETA from DCS_DOMAIN_V1_FWSETACTIONS
                    remove CODEXB_VTHETA::CODEXB_VTHETA_FWCNM from FWCHILDRENMODE_FWSETSTATES
                else
                    move_to Included
                endif
            else
                do ExcludeAll(OWNER=OWNER) CODEXB_VTHETA::CODEXB_VTHETA_FWM
                remove CODEXB_VTHETA::CODEXB_VTHETA from DCS_DOMAIN_V1_FWSETSTATES
                remove CODEXB_VTHETA::CODEXB_VTHETA from DCS_DOMAIN_V1_FWSETACTIONS
                remove CODEXB_VTHETA::CODEXB_VTHETA_FWCNM from FWCHILDRENMODE_FWSETSTATES
            endif
            move_to Excluded
    state: LockedOut
    !color: FwStateOKNotPhysics
        action: UnLockOut	!visible: 1
            move_to Excluded
        action: UnLockOut&Include(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 1
            if ( CODEXB_VTHETA::CODEXB_VTHETA_FWM not_in_state Excluded ) then
            !    else
                    move_to LockedOut
            !    endif
            else
                do Include(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) CODEXB_VTHETA::CODEXB_VTHETA_FWM
                insert CODEXB_VTHETA::CODEXB_VTHETA in DCS_DOMAIN_V1_FWSETSTATES
                insert CODEXB_VTHETA::CODEXB_VTHETA in DCS_DOMAIN_V1_FWSETACTIONS
                insert CODEXB_VTHETA::CODEXB_VTHETA_FWCNM in FWCHILDRENMODE_FWSETSTATES
            endif
            move_to Included
        action: LockOutPerm	!visible: 0
            move_to LockedOutPerm
    state: ExcludedPerm
    !color: FwStateOKNotPhysics
        action: Include(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 1
            !    else
            !        move_to Excluded
            !    endif
            !else
            !endif
            !move_to Included
            if ( CODEXB_VTHETA::CODEXB_VTHETA_FWM not_in_state {Excluded, Manual} ) then
                move_to ExcludedPerm
            else
                do Include(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) CODEXB_VTHETA::CODEXB_VTHETA_FWM
                insert CODEXB_VTHETA::CODEXB_VTHETA in DCS_DOMAIN_V1_FWSETSTATES
                insert CODEXB_VTHETA::CODEXB_VTHETA in DCS_DOMAIN_V1_FWSETACTIONS
                insert CODEXB_VTHETA::CODEXB_VTHETA_FWCNM in FWCHILDRENMODE_FWSETSTATES
            endif
            move_to Included
        action: LockOut	!visible: 1
            move_to LockedOut
        action: Exclude(string OWNER = "")	!visible: 0
            move_to Excluded
    state: LockedOutPerm
    !color: FwStateOKNotPhysics
        action: UnLockOut	!visible: 1
            move_to Excluded
        action: UnLockOut&Include(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 1
            if ( CODEXB_VTHETA::CODEXB_VTHETA_FWM not_in_state Excluded ) then
            !    else
                    move_to LockedOutPerm
            !    endif
            else
                do Include(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) CODEXB_VTHETA::CODEXB_VTHETA_FWM
                insert CODEXB_VTHETA::CODEXB_VTHETA in DCS_DOMAIN_V1_FWSETSTATES
                insert CODEXB_VTHETA::CODEXB_VTHETA in DCS_DOMAIN_V1_FWSETACTIONS
                insert CODEXB_VTHETA::CODEXB_VTHETA_FWCNM in FWCHILDRENMODE_FWSETSTATES
            endif
            move_to Included
        action: LockOut	!visible: 0
            move_to LockedOut

object: CODEXB_VTHETA_FWM is_of_class CODEXB_VTHETA_FwChildMode_CLASS

class: CODEXB_VTHPHI_FwChildMode_CLASS

!panel: FwChildMode.pnl
    state: Excluded
    !color: FwStateOKNotPhysics
        action: Include(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 1
            if ( CODEXB_VTHPHI::CODEXB_VTHPHI_FWM in_state Dead ) then
              move_to Manual
            endif
            if ( CODEXB_VTHPHI::CODEXB_VTHPHI_FWM not_in_state {Excluded, Manual} ) then
            !    else
                    move_to Excluded
            !    endif
            else
                do Include(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) CODEXB_VTHPHI::CODEXB_VTHPHI_FWM
                insert CODEXB_VTHPHI::CODEXB_VTHPHI in DCS_DOMAIN_V1_FWSETSTATES
                insert CODEXB_VTHPHI::CODEXB_VTHPHI in DCS_DOMAIN_V1_FWSETACTIONS
                insert CODEXB_VTHPHI::CODEXB_VTHPHI_FWCNM in FWCHILDRENMODE_FWSETSTATES
            endif
            move_to Included
        action: Manual	!visible: 0
            do Manual CODEXB_VTHPHI::CODEXB_VTHPHI_FWM
            insert CODEXB_VTHPHI::CODEXB_VTHPHI in DCS_DOMAIN_V1_FWSETSTATES
            remove CODEXB_VTHPHI::CODEXB_VTHPHI from DCS_DOMAIN_V1_FWSETACTIONS
            move_to Manual
        action: Ignore	!visible: 0
            do Ignore CODEXB_VTHPHI::CODEXB_VTHPHI_FWM
            insert CODEXB_VTHPHI::CODEXB_VTHPHI in DCS_DOMAIN_V1_FWSETACTIONS
            remove CODEXB_VTHPHI::CODEXB_VTHPHI from DCS_DOMAIN_V1_FWSETSTATES
            move_to Ignored
        action: LockOut	!visible: 1
            move_to LockedOut
        action: Exclude(string OWNER = "")	!visible: 1
            do Exclude(OWNER=OWNER) CODEXB_VTHPHI::CODEXB_VTHPHI_FWM
            remove CODEXB_VTHPHI::CODEXB_VTHPHI from DCS_DOMAIN_V1_FWSETSTATES
            remove CODEXB_VTHPHI::CODEXB_VTHPHI from DCS_DOMAIN_V1_FWSETACTIONS
            remove CODEXB_VTHPHI::CODEXB_VTHPHI_FWCNM from FWCHILDRENMODE_FWSETSTATES
            move_to Excluded
        action: ExcludePerm(string OWNER = "")	!visible: 0
            move_to ExcludedPerm
        action: Exclude&LockOut(string OWNER = "")	!visible: 0
            move_to LockedOut
    state: Included
    !color: FwStateOKPhysics
        when ( CODEXB_VTHPHI::CODEXB_VTHPHI_FWM in_state Excluded )  do Exclude
        when ( CODEXB_VTHPHI::CODEXB_VTHPHI_FWM in_state Ignored )  move_to IGNORED
        when ( CODEXB_VTHPHI::CODEXB_VTHPHI_FWM in_state Manual )  move_to MANUAL
        when ( CODEXB_VTHPHI::CODEXB_VTHPHI_FWM in_state Dead )  do Manual
        action: Exclude(string OWNER = "")	!visible: 1
            if ( CODEXB_VTHPHI::CODEXB_VTHPHI_FWM not_in_state Included ) then
                if ( CODEXB_VTHPHI::CODEXB_VTHPHI_FWM in_state InManual ) then
                    do Release(OWNER=OWNER) CODEXB_VTHPHI::CODEXB_VTHPHI_FWM
                    remove CODEXB_VTHPHI::CODEXB_VTHPHI from DCS_DOMAIN_V1_FWSETSTATES
                    remove CODEXB_VTHPHI::CODEXB_VTHPHI from DCS_DOMAIN_V1_FWSETACTIONS
                    remove CODEXB_VTHPHI::CODEXB_VTHPHI_FWCNM from FWCHILDRENMODE_FWSETSTATES
                else
                        do Exclude(OWNER=OWNER) CODEXB_VTHPHI::CODEXB_VTHPHI_FWM
                        remove CODEXB_VTHPHI::CODEXB_VTHPHI from DCS_DOMAIN_V1_FWSETSTATES
                        remove CODEXB_VTHPHI::CODEXB_VTHPHI from DCS_DOMAIN_V1_FWSETACTIONS
                        remove CODEXB_VTHPHI::CODEXB_VTHPHI_FWCNM from FWCHILDRENMODE_FWSETSTATES
            !       else
            !            move_to Included
            !        endif
                endif
            else
                do Exclude(OWNER=OWNER) CODEXB_VTHPHI::CODEXB_VTHPHI_FWM
                remove CODEXB_VTHPHI::CODEXB_VTHPHI from DCS_DOMAIN_V1_FWSETSTATES
                remove CODEXB_VTHPHI::CODEXB_VTHPHI from DCS_DOMAIN_V1_FWSETACTIONS
                remove CODEXB_VTHPHI::CODEXB_VTHPHI_FWCNM from FWCHILDRENMODE_FWSETSTATES
            endif
            move_to Excluded
        action: Manual(string OWNER = "")	!visible: 1
            do Manual(OWNER=OWNER) CODEXB_VTHPHI::CODEXB_VTHPHI_FWM
            insert CODEXB_VTHPHI::CODEXB_VTHPHI in DCS_DOMAIN_V1_FWSETSTATES
            remove CODEXB_VTHPHI::CODEXB_VTHPHI from DCS_DOMAIN_V1_FWSETACTIONS
            move_to Manual
        action: Ignore(string OWNER = "")	!visible: 1
            do Ignore(OWNER=OWNER) CODEXB_VTHPHI::CODEXB_VTHPHI_FWM
            insert CODEXB_VTHPHI::CODEXB_VTHPHI in DCS_DOMAIN_V1_FWSETACTIONS
            remove CODEXB_VTHPHI::CODEXB_VTHPHI from DCS_DOMAIN_V1_FWSETSTATES
            move_to Ignored
        action: ExcludeAll(string OWNER = "")	!visible: 1
            if ( CODEXB_VTHPHI::CODEXB_VTHPHI_FWM not_in_state {Included,Ignored,Manual} ) then
                if ( CODEXB_VTHPHI::CODEXB_VTHPHI_FWM in_state InManual ) then
                    do ReleaseAll(OWNER=OWNER) CODEXB_VTHPHI::CODEXB_VTHPHI_FWM
                    remove CODEXB_VTHPHI::CODEXB_VTHPHI from DCS_DOMAIN_V1_FWSETSTATES
                    remove CODEXB_VTHPHI::CODEXB_VTHPHI from DCS_DOMAIN_V1_FWSETACTIONS
                    remove CODEXB_VTHPHI::CODEXB_VTHPHI_FWCNM from FWCHILDRENMODE_FWSETSTATES
                else
                    move_to Included
                endif
            else
                do ExcludeAll(OWNER=OWNER) CODEXB_VTHPHI::CODEXB_VTHPHI_FWM
                remove CODEXB_VTHPHI::CODEXB_VTHPHI from DCS_DOMAIN_V1_FWSETSTATES
                remove CODEXB_VTHPHI::CODEXB_VTHPHI from DCS_DOMAIN_V1_FWSETACTIONS
                remove CODEXB_VTHPHI::CODEXB_VTHPHI_FWCNM from FWCHILDRENMODE_FWSETSTATES
            endif
            move_to Excluded
        action: Include(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 1
            do Include(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) CODEXB_VTHPHI::CODEXB_VTHPHI_FWM
            insert CODEXB_VTHPHI::CODEXB_VTHPHI in DCS_DOMAIN_V1_FWSETSTATES
            insert CODEXB_VTHPHI::CODEXB_VTHPHI in DCS_DOMAIN_V1_FWSETACTIONS
            insert CODEXB_VTHPHI::CODEXB_VTHPHI_FWCNM in FWCHILDRENMODE_FWSETSTATES
            move_to Included
        action: Free(string OWNER = "")	!visible: 0
            do Free(OWNER=OWNER) CODEXB_VTHPHI::CODEXB_VTHPHI_FWM
            move_to Included
        action: SetMode(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 0
            do SetMode(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) CODEXB_VTHPHI::CODEXB_VTHPHI_FWM
        action: ExcludePerm(string OWNER = "")	!visible: 0
            if ( CODEXB_VTHPHI::CODEXB_VTHPHI_FWM not_in_state Included ) then
                if ( CODEXB_VTHPHI::CODEXB_VTHPHI_FWM in_state InManual ) then
                    do Release(OWNER=OWNER) CODEXB_VTHPHI::CODEXB_VTHPHI_FWM
                    remove CODEXB_VTHPHI::CODEXB_VTHPHI from DCS_DOMAIN_V1_FWSETSTATES
                    remove CODEXB_VTHPHI::CODEXB_VTHPHI from DCS_DOMAIN_V1_FWSETACTIONS
                    remove CODEXB_VTHPHI::CODEXB_VTHPHI_FWCNM from FWCHILDRENMODE_FWSETSTATES
                else
                    move_to Included
                endif
            else
                do Exclude(OWNER=OWNER) CODEXB_VTHPHI::CODEXB_VTHPHI_FWM
                remove CODEXB_VTHPHI::CODEXB_VTHPHI from DCS_DOMAIN_V1_FWSETSTATES
                remove CODEXB_VTHPHI::CODEXB_VTHPHI from DCS_DOMAIN_V1_FWSETACTIONS
                remove CODEXB_VTHPHI::CODEXB_VTHPHI_FWCNM from FWCHILDRENMODE_FWSETSTATES
            endif
            move_to ExcludedPerm
        action: Exclude&LockOut(string OWNER = "")	!visible: 1
            if ( CODEXB_VTHPHI::CODEXB_VTHPHI_FWM not_in_state Included ) then
                if ( CODEXB_VTHPHI::CODEXB_VTHPHI_FWM in_state InManual ) then
                    do Release(OWNER=OWNER) CODEXB_VTHPHI::CODEXB_VTHPHI_FWM
                    remove CODEXB_VTHPHI::CODEXB_VTHPHI from DCS_DOMAIN_V1_FWSETSTATES
                    remove CODEXB_VTHPHI::CODEXB_VTHPHI from DCS_DOMAIN_V1_FWSETACTIONS
                    remove CODEXB_VTHPHI::CODEXB_VTHPHI_FWCNM from FWCHILDRENMODE_FWSETSTATES
                else
                    if ( CODEXB_VTHPHI::CODEXB_VTHPHI_FWM in_state Dead ) then
                        do Exclude(OWNER=OWNER) CODEXB_VTHPHI::CODEXB_VTHPHI_FWM
                        remove CODEXB_VTHPHI::CODEXB_VTHPHI from DCS_DOMAIN_V1_FWSETSTATES
                        remove CODEXB_VTHPHI::CODEXB_VTHPHI from DCS_DOMAIN_V1_FWSETACTIONS
                        remove CODEXB_VTHPHI::CODEXB_VTHPHI_FWCNM from FWCHILDRENMODE_FWSETSTATES
                   else
                        move_to Included
                    endif
                endif
            else
                do Exclude(OWNER=OWNER) CODEXB_VTHPHI::CODEXB_VTHPHI_FWM
                remove CODEXB_VTHPHI::CODEXB_VTHPHI from DCS_DOMAIN_V1_FWSETSTATES
                remove CODEXB_VTHPHI::CODEXB_VTHPHI from DCS_DOMAIN_V1_FWSETACTIONS
                remove CODEXB_VTHPHI::CODEXB_VTHPHI_FWCNM from FWCHILDRENMODE_FWSETSTATES
            endif
            move_to LockedOut
    state: Manual
    !color: FwStateOKNotPhysics
        when ( CODEXB_VTHPHI::CODEXB_VTHPHI_FWM in_state Included )  move_to EXCLUDED
        action: Include(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 1
            if ( CODEXB_VTHPHI::CODEXB_VTHPHI_FWM in_state Dead ) then
              move_to Manual
            endif
            if ( CODEXB_VTHPHI::CODEXB_VTHPHI_FWM not_in_state InManual ) then
              do Include(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) CODEXB_VTHPHI::CODEXB_VTHPHI_FWM
              insert CODEXB_VTHPHI::CODEXB_VTHPHI in DCS_DOMAIN_V1_FWSETSTATES
              insert CODEXB_VTHPHI::CODEXB_VTHPHI in DCS_DOMAIN_V1_FWSETACTIONS
              insert CODEXB_VTHPHI::CODEXB_VTHPHI_FWCNM in FWCHILDRENMODE_FWSETSTATES
            endif
              if ( CODEXB_VTHPHI::CODEXB_VTHPHI_FWM in_state Included ) then
                move_to Included
              endif
            move_to Manual
        action: Exclude(string OWNER = "")	!visible: 1
                do Exclude(OWNER=OWNER) CODEXB_VTHPHI::CODEXB_VTHPHI_FWM
                remove CODEXB_VTHPHI::CODEXB_VTHPHI from DCS_DOMAIN_V1_FWSETSTATES
                remove CODEXB_VTHPHI::CODEXB_VTHPHI from DCS_DOMAIN_V1_FWSETACTIONS
                remove CODEXB_VTHPHI::CODEXB_VTHPHI_FWCNM from FWCHILDRENMODE_FWSETSTATES
            !    move_to Excluded
            !endif
            !    else
            !    endif
            !else
            !endif
            !    move_to Excluded
            !endif
            !move_to Manual
            if ( CODEXB_VTHPHI::CODEXB_VTHPHI_FWM in_state InManual ) then
                 do SetInLocal CODEXB_VTHPHI::CODEXB_VTHPHI_FWM
            endif
            move_to Excluded
        action: Ignore	!visible: 0
            do Ignore CODEXB_VTHPHI::CODEXB_VTHPHI_FWM
            insert CODEXB_VTHPHI::CODEXB_VTHPHI in DCS_DOMAIN_V1_FWSETACTIONS
            remove CODEXB_VTHPHI::CODEXB_VTHPHI from DCS_DOMAIN_V1_FWSETSTATES
            move_to Ignored
        action: Free(string OWNER = "")	!visible: 0
            do Free(OWNER=OWNER) CODEXB_VTHPHI::CODEXB_VTHPHI_FWM
            !move_to Manual
            if ( CODEXB_VTHPHI::CODEXB_VTHPHI_FWM in_state InManual ) then
                 do SetInLocal CODEXB_VTHPHI::CODEXB_VTHPHI_FWM
            endif
            move_to Excluded
        action: ExcludeAll(string OWNER = "")	!visible: 1
            !    else
            !        move_to Included
            !    endif
            !else
            !endif
              do ExcludeAll(OWNER=OWNER) CODEXB_VTHPHI::CODEXB_VTHPHI_FWM
              remove CODEXB_VTHPHI::CODEXB_VTHPHI from DCS_DOMAIN_V1_FWSETSTATES
              remove CODEXB_VTHPHI::CODEXB_VTHPHI from DCS_DOMAIN_V1_FWSETACTIONS
              remove CODEXB_VTHPHI::CODEXB_VTHPHI_FWCNM from FWCHILDRENMODE_FWSETSTATES
            !endif
            !move_to Manual
            if ( CODEXB_VTHPHI::CODEXB_VTHPHI_FWM in_state InManual ) then
                 do SetInLocal CODEXB_VTHPHI::CODEXB_VTHPHI_FWM
            endif
            move_to Excluded
        action: Manual	!visible: 0
            do Manual CODEXB_VTHPHI::CODEXB_VTHPHI_FWM
            insert CODEXB_VTHPHI::CODEXB_VTHPHI in DCS_DOMAIN_V1_FWSETSTATES
            remove CODEXB_VTHPHI::CODEXB_VTHPHI from DCS_DOMAIN_V1_FWSETACTIONS
            move_to Manual
        action: Exclude&LockOut(string OWNER = "")	!visible: 1
                do Exclude(OWNER=OWNER) CODEXB_VTHPHI::CODEXB_VTHPHI_FWM
                remove CODEXB_VTHPHI::CODEXB_VTHPHI from DCS_DOMAIN_V1_FWSETSTATES
                remove CODEXB_VTHPHI::CODEXB_VTHPHI from DCS_DOMAIN_V1_FWSETACTIONS
                remove CODEXB_VTHPHI::CODEXB_VTHPHI_FWCNM from FWCHILDRENMODE_FWSETSTATES
            !    move_to Excluded
            !endif
            !    else
            !    endif
            !else
            !endif
            !    move_to Excluded
            !endif
            !move_to Manual
            if ( CODEXB_VTHPHI::CODEXB_VTHPHI_FWM in_state InManual ) then
                 do SetInLocal CODEXB_VTHPHI::CODEXB_VTHPHI_FWM
            endif
            move_to LockedOut
    state: Ignored
    !color: FwStateOKNotPhysics
        when ( CODEXB_VTHPHI::CODEXB_VTHPHI_FWM in_state Included )  move_to INCLUDED
        when ( CODEXB_VTHPHI::CODEXB_VTHPHI_FWM in_state Excluded ) move_to EXCLUDED
        when ( CODEXB_VTHPHI::CODEXB_VTHPHI_FWM in_state Dead )  do Exclude
        action: Include(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 1
            do Include(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) CODEXB_VTHPHI::CODEXB_VTHPHI_FWM
            insert CODEXB_VTHPHI::CODEXB_VTHPHI in DCS_DOMAIN_V1_FWSETSTATES
            insert CODEXB_VTHPHI::CODEXB_VTHPHI in DCS_DOMAIN_V1_FWSETACTIONS
            insert CODEXB_VTHPHI::CODEXB_VTHPHI_FWCNM in FWCHILDRENMODE_FWSETSTATES
            move_to Included
        action: Exclude(string OWNER = "")	!visible: 1
            if ( CODEXB_VTHPHI::CODEXB_VTHPHI_FWM not_in_state Included ) then
                if ( CODEXB_VTHPHI::CODEXB_VTHPHI_FWM in_state InManual ) then
                    do Release(OWNER=OWNER) CODEXB_VTHPHI::CODEXB_VTHPHI_FWM
                    remove CODEXB_VTHPHI::CODEXB_VTHPHI from DCS_DOMAIN_V1_FWSETSTATES
                    remove CODEXB_VTHPHI::CODEXB_VTHPHI from DCS_DOMAIN_V1_FWSETACTIONS
                    remove CODEXB_VTHPHI::CODEXB_VTHPHI_FWCNM from FWCHILDRENMODE_FWSETSTATES
                else
                    do Exclude(OWNER=OWNER) CODEXB_VTHPHI::CODEXB_VTHPHI_FWM
                    remove CODEXB_VTHPHI::CODEXB_VTHPHI from DCS_DOMAIN_V1_FWSETSTATES
                    remove CODEXB_VTHPHI::CODEXB_VTHPHI from DCS_DOMAIN_V1_FWSETACTIONS
                    remove CODEXB_VTHPHI::CODEXB_VTHPHI_FWCNM from FWCHILDRENMODE_FWSETSTATES
                endif
            else
                do Exclude(OWNER=OWNER) CODEXB_VTHPHI::CODEXB_VTHPHI_FWM
                remove CODEXB_VTHPHI::CODEXB_VTHPHI from DCS_DOMAIN_V1_FWSETSTATES
                remove CODEXB_VTHPHI::CODEXB_VTHPHI from DCS_DOMAIN_V1_FWSETACTIONS
                remove CODEXB_VTHPHI::CODEXB_VTHPHI_FWCNM from FWCHILDRENMODE_FWSETSTATES
            endif
            move_to Excluded
        action: Manual(string OWNER = "")	!visible: 0
            do Manual(OWNER=OWNER) CODEXB_VTHPHI::CODEXB_VTHPHI_FWM
            insert CODEXB_VTHPHI::CODEXB_VTHPHI in DCS_DOMAIN_V1_FWSETSTATES
            remove CODEXB_VTHPHI::CODEXB_VTHPHI from DCS_DOMAIN_V1_FWSETACTIONS
            move_to Manual
        action: SetMode(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 0
            do SetMode(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) CODEXB_VTHPHI::CODEXB_VTHPHI_FWM
        action: Free(string OWNER = "")	!visible: 0
            do Free(OWNER=OWNER) CODEXB_VTHPHI::CODEXB_VTHPHI_FWM
            move_to Included
        action: ExcludeAll(string OWNER = "")	!visible: 1
            if ( CODEXB_VTHPHI::CODEXB_VTHPHI_FWM not_in_state {Included,Ignored,Manual} ) then
                if ( CODEXB_VTHPHI::CODEXB_VTHPHI_FWM in_state InManual ) then
                    do ReleaseAll(OWNER=OWNER) CODEXB_VTHPHI::CODEXB_VTHPHI_FWM
                    remove CODEXB_VTHPHI::CODEXB_VTHPHI from DCS_DOMAIN_V1_FWSETSTATES
                    remove CODEXB_VTHPHI::CODEXB_VTHPHI from DCS_DOMAIN_V1_FWSETACTIONS
                    remove CODEXB_VTHPHI::CODEXB_VTHPHI_FWCNM from FWCHILDRENMODE_FWSETSTATES
                else
                    move_to Included
                endif
            else
                do ExcludeAll(OWNER=OWNER) CODEXB_VTHPHI::CODEXB_VTHPHI_FWM
                remove CODEXB_VTHPHI::CODEXB_VTHPHI from DCS_DOMAIN_V1_FWSETSTATES
                remove CODEXB_VTHPHI::CODEXB_VTHPHI from DCS_DOMAIN_V1_FWSETACTIONS
                remove CODEXB_VTHPHI::CODEXB_VTHPHI_FWCNM from FWCHILDRENMODE_FWSETSTATES
            endif
            move_to Excluded
    state: LockedOut
    !color: FwStateOKNotPhysics
        action: UnLockOut	!visible: 1
            move_to Excluded
        action: UnLockOut&Include(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 1
            if ( CODEXB_VTHPHI::CODEXB_VTHPHI_FWM not_in_state Excluded ) then
            !    else
                    move_to LockedOut
            !    endif
            else
                do Include(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) CODEXB_VTHPHI::CODEXB_VTHPHI_FWM
                insert CODEXB_VTHPHI::CODEXB_VTHPHI in DCS_DOMAIN_V1_FWSETSTATES
                insert CODEXB_VTHPHI::CODEXB_VTHPHI in DCS_DOMAIN_V1_FWSETACTIONS
                insert CODEXB_VTHPHI::CODEXB_VTHPHI_FWCNM in FWCHILDRENMODE_FWSETSTATES
            endif
            move_to Included
        action: LockOutPerm	!visible: 0
            move_to LockedOutPerm
    state: ExcludedPerm
    !color: FwStateOKNotPhysics
        action: Include(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 1
            !    else
            !        move_to Excluded
            !    endif
            !else
            !endif
            !move_to Included
            if ( CODEXB_VTHPHI::CODEXB_VTHPHI_FWM not_in_state {Excluded, Manual} ) then
                move_to ExcludedPerm
            else
                do Include(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) CODEXB_VTHPHI::CODEXB_VTHPHI_FWM
                insert CODEXB_VTHPHI::CODEXB_VTHPHI in DCS_DOMAIN_V1_FWSETSTATES
                insert CODEXB_VTHPHI::CODEXB_VTHPHI in DCS_DOMAIN_V1_FWSETACTIONS
                insert CODEXB_VTHPHI::CODEXB_VTHPHI_FWCNM in FWCHILDRENMODE_FWSETSTATES
            endif
            move_to Included
        action: LockOut	!visible: 1
            move_to LockedOut
        action: Exclude(string OWNER = "")	!visible: 0
            move_to Excluded
    state: LockedOutPerm
    !color: FwStateOKNotPhysics
        action: UnLockOut	!visible: 1
            move_to Excluded
        action: UnLockOut&Include(string OWNER = "", string EXCLUSIVE = "YES")	!visible: 1
            if ( CODEXB_VTHPHI::CODEXB_VTHPHI_FWM not_in_state Excluded ) then
            !    else
                    move_to LockedOutPerm
            !    endif
            else
                do Include(OWNER=OWNER,EXCLUSIVE=EXCLUSIVE) CODEXB_VTHPHI::CODEXB_VTHPHI_FWM
                insert CODEXB_VTHPHI::CODEXB_VTHPHI in DCS_DOMAIN_V1_FWSETSTATES
                insert CODEXB_VTHPHI::CODEXB_VTHPHI in DCS_DOMAIN_V1_FWSETACTIONS
                insert CODEXB_VTHPHI::CODEXB_VTHPHI_FWCNM in FWCHILDRENMODE_FWSETSTATES
            endif
            move_to Included
        action: LockOut	!visible: 0
            move_to LockedOut

object: CODEXB_VTHPHI_FWM is_of_class CODEXB_VTHPHI_FwChildMode_CLASS

objectset: FWCHILDMODE_FWSETSTATES is_of_class VOID {CODEXB_DCT_LV_FWM,
	CODEXB_VANALOG_FWM,
	CODEXB_VDIGITAL_FWM,
	CODEXB_VSENSE_FWM,
	CODEXB_VTHETA_FWM,
	CODEXB_VTHPHI_FWM }
objectset: FWCHILDMODE_FWSETACTIONS is_of_class VOID {CODEXB_DCT_LV_FWM,
	CODEXB_VANALOG_FWM,
	CODEXB_VDIGITAL_FWM,
	CODEXB_VSENSE_FWM,
	CODEXB_VTHETA_FWM,
	CODEXB_VTHPHI_FWM }

class: ASS_DCS_Domain_v1_CLASS/associated
!panel: DCS_Domain_v1.pnl
    state: NOT_READY
    !color: FwStateAttention1
        action: Switch_ON(string RUN_TYPE = "PHYSICS")	!visible: 1
        action: Switch_OFF	!visible: 1
        action: Do_Emergency_OFF	!visible: 0
        action: Load(string RUN_TYPE = "PHYSICS")	!visible: 1
        action: Reset	!visible: 1
    state: READY
    !color: FwStateOKPhysics
        action: Switch_OFF	!visible: 1
        action: Do_Emergency_OFF	!visible: 0
        action: Reset	!visible: 1
    state: OFF
    !color: FwStateOKNotPhysics
        action: Switch_ON(string RUN_TYPE = "PHYSICS")	!visible: 1
        action: Do_Emergency_OFF	!visible: 0
        action: Reset	!visible: 1
    state: ERROR
    !color: FwStateAttention3
        action: Recover	!visible: 1
        action: Do_Emergency_OFF	!visible: 0
    state: EMERGENCY_OFF
    !color: FwStateAttention3
        action: Clear_Emergency	!visible: 2

object: CODEXB_DCT_LV::CODEXB_DCT_LV is_of_class ASS_DCS_Domain_v1_CLASS

object: CODEXB_VANALOG::CODEXB_VANALOG is_of_class ASS_DCS_Domain_v1_CLASS

object: CODEXB_VDIGITAL::CODEXB_VDIGITAL is_of_class ASS_DCS_Domain_v1_CLASS

object: CODEXB_VSENSE::CODEXB_VSENSE is_of_class ASS_DCS_Domain_v1_CLASS

object: CODEXB_VTHETA::CODEXB_VTHETA is_of_class ASS_DCS_Domain_v1_CLASS

object: CODEXB_VTHPHI::CODEXB_VTHPHI is_of_class ASS_DCS_Domain_v1_CLASS

objectset: DCS_DOMAIN_V1_FWSETSTATES is_of_class VOID
objectset: DCS_DOMAIN_V1_FWSETACTIONS is_of_class VOID


objectset: FWCHILDREN_FWSETACTIONS union {DCS_DOMAIN_V1_FWSETACTIONS } is_of_class VOID
objectset: FWCHILDREN_FWSETSTATES union {DCS_DOMAIN_V1_FWSETSTATES } is_of_class VOID

