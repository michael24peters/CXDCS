#uses "CODEXB_VANALOG$FwCaenChannelA2551$install"
#uses "CODEXB_VANALOG$FwFSMConfDB_DCS$install"
#uses "CODEXB_VANALOG$FwDevMode$install"

startDomainDevices_CODEXB_VANALOG()
{
	fwFsm_startDomainDevicesNew("CODEXB_VANALOG");
}
