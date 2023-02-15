#include <sourcemod>

#pragma semicolon 1
#pragma newdecls required

#define VERSION "1.0.0"

public Plugin myinfo = {
    name = "Medic round backup (restore)",
    author = "marqdevx",
    description = "",
    version = VERSION,
    url = "https://github.com/marqdevx/sm-plugins"}

public void OnPluginStart(){
    RegAdminCmd("sm_medic", Command_medic, ADMFLAG_GENERIC, "Restore backup");
}

public void restoreRound(int roundNumber)
{
    //Save the round number
    char nRound[128];
    IntToString(roundNumber, nRound, sizeof(nRound));

    //Needed to build a string with for the default restore, format "backup_round<round>.txt" the <round> with "XX" format like "backup_round02.txt"
    char backupFile[256] = "backup_round";

    if (roundNumber < 10)
        StrCat(backupFile, 256, "0");
    StrCat(backupFile, 256, nRound);
    
    StrCat(backupFile, 256, ".txt");

    ServerCommand("mp_backup_restore_load_file %s", backupFile);
    PrintToChatAll(" \x0BRestored r%s", backupFile);
}

public Action Command_medic(int client, int args)
{
    char arg[5];
    GetCmdArg(1, arg, sizeof(arg));
    int nRound = StringToInt(arg);

    char zero[5] = "";
    if (nRound < 10)
        zero = "0";

    char backupFile[256] = "backup_round";
    if (nRound < 10)
        StrCat(backupFile, 256, "0");
    StrCat(backupFile, 256, arg);
    StrCat(backupFile, 256, ".txt");

    ServerCommand("mp_backup_restore_load_file %s", backupFile);

    return Plugin_Handled;
}

public void OnClientSayCommand_Post(int client, const char[] command, const char[] sArgs)
{
    if (!CheckCommandAccess(client, "sm_medic", ADMFLAG_GENERIC))
    {
      return;
    }

    char command[8];
    StrCat(command, 8, sArgs);

    if (StrEqual(command, ".medic ", false))
    {
        int nRound;
        nRound = StringToInt(sArgs[6]);
        if (!IsCharNumeric((sArgs[7]))) return;
        restoreRound(nRound);        
    }
    else
    {
        return;
    }
}