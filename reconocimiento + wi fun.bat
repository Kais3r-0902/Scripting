@echo off
echo Bienvenido a Duckery v1 dev:P0ISON3R APH0TH3C4RY "Intimus angulus inferni reservatur illis qui suam neutralitatem servant"
echo Estoy Trabajando...
start chrome "www.youtube.com/watch?v=1H-LqG14JTw&ab_channel=Enya-Topic"

echo ************************************ EVENTOS DEL SISTEMA, INFORMACION DE FALLOS: ************************************ >> System_Info.txt
PowerShell -Command "Set-ExecutionPolicy -Scope CurrentUser Unrestricted"
PowerShell -Command "Get-WinEvent -FilterHashtable @{Logname='System'; Level=2; StartTime=(Get-Date).AddHours(-24)}" >> System_Info.txt

echo ************************************ Todos los Programas de la PC: ************************************ >> System_Info.txt
wmic product get name /FORMAT:TABLE >> temp.txt && type temp.txt >> System_Info.txt && del temp.txt

echo ************************************ Todos los SERVICIOS de la PC: ************************************ >> System_Info.txt
net start >> System_Info.txt

echo ************************************ Todos las conexiones activas de la PC: ************************************ >> System_Info.txt
netstat -a >> System_Info.txt

echo ************************************ Listas de enrutamiento de la PC: ************************************ >> System_Info.txt 
route print >> System_Info.txt

echo ************************************ Todos los Usuarios de la PC: ************************************ >> System_Info.txt
net user >> System_Info.txt

echo ************************************ Informacion del Firewall de la PC: ************************************ >> System_Info.txt

echo Verificando la configuracion del Firewall de Windows >> System_Info.txt
netsh advfirewall show allprofiles >> System_Info.txt
echo Configuracion del Firewall de Windows guardada en System_Info.txt

::echo Verificando la configuracion de las actualizaciones de Windows >> System_Info.txt
::reg query "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" >> windows_update_config.txt >> System_Info.txt
::echo Configuracion de las actualizaciones de Windows guardada en System_Info.txt

echo ********************************** DIRECCION IP PUBLICA: ********************************** >> System_Info.txt
nslookup myip.opendns.com resolver1.opendns.com >> System_Info.txt

echo ************************************ DIRECCIONES IPS: ************************************ >> System_Info.txt
ipconfig /all >> System_Info.txt

echo ************************************ Informacion de Hardware y otros componentes: ************************************ >> System_Info.txt
systeminfo >> System_Info.txt
echo ************************************ Informacion de Motherboard: ************************************ >> System_Info.txt
wmic baseboard get product,Manufacturer,version,serialnumber /FORMAT:TABLE >> temp.txt && type temp.txt >> System_Info.txt && del temp.txt
echo ************************************ Informacion de BIOS: ************************************ >> System_Info.txt
wmic bios get name,serialnumber,version /FORMAT:TABLE > temp.txt && type temp.txt >> System_Info.txt && del temp.txt
echo ************************************ Informacion de CPU: ************************************ >> System_Info.txt
wmic cpu get name,CurrentClockSpeed,MaxClockSpeed /FORMAT:TABLE >> temp.txt && type temp.txt >> System_Info.txt && del temp.txt
echo ************************************ Informacion de ALMACENAMIENTO: ************************************ >> System_Info.txt
wmic diskdrive get name,size,model /FORMAT:TABLE >> temp.txt && type temp.txt >> System_Info.txt && del temp.txt 
echo ************************************ Informacion de MEMORIAS Y FREQ: ************************************ >> System_Info.txt
wmic MemoryChip get BankLabel, Capacity, MemoryType, TypeDetail, Speed, Manufacturer, DeviceLocator /FORMAT:TABLE > temp.txt && type temp.txt >> System_Info.txt && del temp.txt
echo ************************************ESQUEMA DE USUARIO: ************************************ >> tree_users.txt
tree c:\\users /f >> tree_users.txt
echo ************************************Lista de Wifi a las que se conecto resumen: ************************************ >> System_Info.txt
netsh wlan show profiles >> System_Info.txt

echo ************************************ Lista de Wifi a las que se conecto completo: ************************************ >> System_Info.txt

SetLocal EnableDelayedExpansion
@echo|set /p="Leer las redes existentes:"
netsh wlan show profile > SavedNetworks.temp
@echo|set /p="Procesar las redes leidas (1):"
@echo off
for /F "tokens=2 delims=:" %%i in (SavedNetworks.temp) do (
call :Trim Actual %%i
netsh wlan show profile "!Actual!" key=clear >> SavedNetworks2.temp 
) 
@echo on
move SavedNetworks2.temp SavedNetworks.temp 
@echo|set /p="Contenido de la clave de seguridad (2):"
findstr "SSID-Name Contenido de la clave de seguridad" SavedNetworks.temp >> SavedNetworks.txt >> System_Info.txt
::notepad SavedNetworks.temp 
del SavedNetworks.temp
exit /b Leer las redes existentes

:Trim
::Line below already at the top.
::SetLocal EnableDelayedExpansion
set Params=%*
for /f "tokens=1*" %%a in ("!Params!") do EndLocal & set %1=%%b
exit /b
