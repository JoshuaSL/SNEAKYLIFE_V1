fx_version 'adamant'
games { 'gta5' };

server_script 	'@mysql-async/lib/MySQL.lua' 

client_scripts {
    "RageUI/RMenu.lua",
    "RageUI/menu/RageUI.lua",
    "RageUI/menu/Menu.lua",
    "RageUI/menu/MenuController.lua",
    "RageUI/components/*.lua", 
    "RageUI/menu/elements/*.lua",
    "RageUI/menu/items/*.lua",
    "RageUI/menu/panels/*.lua",
    "RageUI/menu/windows/*.lua",
}    

client_script "after/cl_general.lua"   
client_script "config.lua"
client_script "after/crypter/c.lua"

server_script "after/sv_general.lua"     
server_script "config.lua" 
   




