#include <cstrike>
#include <sdktools>
#include <smlib>
#include <sourcemod>

#include "include/csgo_common.inc"

#pragma semicolon 1
#pragma newdecls required

public
Plugin myinfo = {
    name = "Medic backups restore",
    author = "marqdevx",
    description = "",
    version = VERSION,
    url = "https://github.com/marqdevx"}

public void
OnPluginStart()
{
    RegAdminCmd("sm_medic", Command_medic, ADMFLAG_GENERIC, "Restore backup");
}

public
void restoreRound(int roundNumber)
{

    char nRound[128];
    IntToString(roundNumber, nRound, sizeof(nRound));
    char backupFile[256] = "backup_round";
    if (roundNumber < 10)
        StrCat(backupFile, 256, "0");
    StrCat(backupFile, 256, nRound);
    StrCat(backupFile, 256, ".txt");

    //PrintToChatAll("Restoring %s", backupFile);
    ServerCommand("mp_backup_restore_load_file %s", backupFile);
}
public
Action Command_medic(int client, int args)
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

    //PrintToChatAll("Restoring %s", backupFile);
    ServerCommand("mp_backup_restore_load_file %s", backupFile);
}

public
void OnClientSayCommand_Post(int client, const char[] command, const char[] sArgs)
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