@echo off
:: veuillez saisir le login et le mot de passe de votre base de donnée dans les variables dbUser et dbPassword
 set dbUser="root"
 set dbPassword=""
 set backupDir="C:\Users\root\Documents\testbackup"
 set mysqldump="C:\wamp64\bin\mysql\mysql5.7.21\bin\mysqldump.exe"
 set mysqlDataDir="C:\wamp64\bin\mysql\mysql5.7.21\data"
 set zip="C:\Program Files (x86)\WinRAR\WinRAR.exe"

 : get date
  for /F "tokens=2-4 delims=/ " %%i in ('date /t') do (
	set mm=%%i
	set dd=%%j
	set yy=%%k
)

:: get time
for /F "tokens=5-8 delims=:. " %%i in ('echo.^| time ^| find "current" ') do (
	set hh=%%i
	set mm=%%j
)

set dirName=%yy%%mm%%dd%_%hh%%mm%

:: switch to the "data" folder
pushd %mysqlDataDir%

:: iterate over the folder structure in the "data" folder to get the databases
for /d %%f in (*) do (

	if not exist %backupDir%\%dirName%\ (
		mkdir %backupDir%\%dirName%
	)

	%mysqldump% --host="localhost" --user=%dbUser% --password=%dbPassword% --single-transaction --add-drop-table --databases %%f > %backupDir%\%dirName%\%%f.sql

	%zip% a -tgzip %backupDir%\%dirName%\%%f.sql.gz %backupDir%\%dirName%\%%f.sql

	del %backupDir%\%dirName%\%%f.sql

)
 popd
