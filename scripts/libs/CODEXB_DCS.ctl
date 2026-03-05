#uses "CODEXB_DCS$FwCaenChannelA2551$install"
#uses "CODEXB_DCS$FwFSMConfDB_DCS$install"
#uses "CODEXB_DCS$FwDevMode$install"

startDomainDevices_CODEXB_DCS()
{
	fwFsm_startDomainDevicesNew("CODEXB_DCS");
}
