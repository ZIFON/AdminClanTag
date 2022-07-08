#include <sourcemod>
#include <cstrike>
#include <csgo_colors>


ConVar admin;
ConVar adminroot;
char tag[128];

public Plugin myinfo =
{
	name =  "AdminClanTag" ,
	author =  "ZIFON & Domikuss" ,
	description =  "https://github.com/ZIFON" ,
	version =  "1.0" ,
	url =  "https://github.com/ZIFON"
};

public OnPluginStart() 
{  
	RegAdminCmd("sm_tag", Tag, ADMFLAG_GENERIC);
	HookEvent("player_team", Team); 
	admin = CreateConVar("admin_clan_tag","[ADMIN]");
	adminroot = CreateConVar("root_admin_tag","[CREATOR]");
	AutoExecConfig(true, "AdminClanTag");
} 
static const char BORDER[] = "{LIME}--------------------------------------------------";

public void Team(Event hEvent, char[] name, bool dontBroadcast)
{ 
	new iClient = GetClientOfUserId(GetEventInt(hEvent, "userid")); 

	if(GetUserFlagBits(iClient) & ADMFLAG_ROOT)
	{
		GetConVarString(adminroot, tag, sizeof(tag));
	}
	if (GetUserFlagBits(iClient) & ADMFLAG_GENERIC)
	{
		GetConVarString(admin, tag, sizeof(tag));
	}
	CS_SetClientClanTag(iClient, tag);
}

public Action Tag(iClient, args){

	Menu menu = new Menu(Menu_Callback);
	menu.SetTitle("Tag:");
	menu.AddItem("item1", "Выключить");
	menu.AddItem("item2", "Включить");
	menu.Display(iClient, 30);
	return Plugin_Handled;

}

public int Menu_Callback(Menu hMenu, MenuAction action, int iClient, int iItem)
{
	switch(action)
	{
		case MenuAction_Select:
		{
			if(iItem == 0)
			{
				CGOPrintToChat(iClient, BORDER);
				CGOPrintToChat(iClient, "{RED}Вы успешно убрали клан тег!");
				CGOPrintToChat(iClient, BORDER);
				CS_SetClientClanTag(iClient, "");
			}
			if(iItem == 1)
			{
				CGOPrintToChat(iClient, BORDER);
				CGOPrintToChat(iClient, "{RED}Ваш клан тег теперь видно всем!");
				CGOPrintToChat(iClient, BORDER);
				CS_SetClientClanTag(iClient, tag);
			}
		}
		case MenuAction_End:
		{
			delete hMenu;
		}
	}

	return 0;
}
