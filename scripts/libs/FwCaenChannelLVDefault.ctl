dyn_string CaenLVLastAction;

FwCaenChannelLVDefault_initialize(string domain, string device)
{
  fwDU_createGlobalIndex(domain, device);
  CaenLVLastAction[fwDU_getGlobalIndex(domain, device)] = "";
}

FwCaenChannelLVDefault_valueChanged( string domain, string device,
      int actual_dot_status, string &fwState )
{
  string state; 
  fwDU_getState(domain, device, state);
  int index = fwDU_getGlobalIndex(domain, device);
  string lastAction = CaenLVLastAction[index];
       
  if (state == "EMERGENCY_OFF") 
  { 
    fwState = ""; 
  } 
  else if (actual_dot_status == 0)
  {
    fwDU_setParameter(domain, device, "EXTERNALY", "ENABLED");
    fwState = "OFF"; 
  }
  else if (actual_dot_status == 384)
  {
    fwDU_setParameter(domain, device, "EXTERNALY", "DISABLED");
    fwState = "OFF";
  }
  else if (actual_dot_status == 1)
  {
    if (lastAction == "Switch_OFF")
      fwState = "";
    else
      fwState = "READY";
  }
  else if (actual_dot_status == 3)
  {
    if (lastAction == "Switch_ON")
      fwState = "";
    else
      fwState = "NOT_READY";
  }
  else if (actual_dot_status == 5) 
  {
    if (lastAction == "Switch_OFF")
      fwState = "";
    else
      fwState = "NOT_READY";
  } 
  else 
  {
    fwState = "ERROR"; 
  }
  
//DebugN(actual_dot_status, lastAction, fwState);
  if (fwState != "")
    CaenLVLastAction[index] = "";
}


FwCaenChannelLVDefault_doCommand(string domain, string device, string command)
{ 
  string runType;
  
  CaenLVLastAction[fwDU_getGlobalIndex(domain, device)] = command;
  
  if (command == "Do_Emergency_OFF")  
  {  
    fwDU_setState(domain, device, "EMERGENCY_OFF");   
    dpSet(device + ".settings.onOff", 0); 
  }  
  else 
  if (command == "Clear_Emergency")  
  {  
    fwDU_setState(domain, device, "OFF"); 
    dpSet(device + ".settings.onOff", 0); 
  } 	 
  else 
  if (command == "Recover")  
  {  
    dpSet(device + ".settings.onOff", 0); 
    dyn_string dpeName = strsplit(device, "/");
    dpSet(dpeName[1]+"/"+dpeName[2]+".Commands.ClearAlarm", true);
    fwDU_startTimeout(7, domain, device, "ERROR");
  } 	 
  else 
  if (command == "Switch_OFF")  
  {  
    dpSet(device + ".settings.onOff", 0); 
  } 	 
  else 
  if (command == "Switch_ON")   
  {
    int status;
    dpGet(device + ".actual.status", status);
    if (status == 384)
    {
      fwDU_setState(domain, device, "OFF");
    }
    else
    { 
      fwDU_getCommandParameter(domain, device, "RUN_TYPE", runType);
      fwFSMConfDB_ApplyRecipeFromCache(domain, device, command, runType);
      fwDU_startTimeout(20, domain, device, "OFF");
    }
  }  
}
