@echo off
setlocal

set TEMP_BIN_DIR=%~d0%~p0bin

set SKIP_ISCDIR_SETUP=1
call "%TEMP_BIN_DIR%\setupCmdLine.bat"

set PATH=%TDI_HOME_DIR%;%TDI_JAVA_BIN_DIR%;%TDI_LIB_DIR%;%PATH%

rem Get solution directory parameter (overrides TDI_SOLDIR)
:checksol
if .%1==.-s (
	rem Make sure we are on the correct drive
	%~d2
	rem At this point overwrite the TDI_SOLDIR
	set TDI_SOLDIR=%2
	goto changedir
)
if .%1==.-tdishutdown (
	set TDI_SHUTDOWN=true
)
shift
if not .%1==. goto checksol

:changedir
rem Create the directory if it does not exist
if not exist %TDI_SOLDIR% mkdir %TDI_SOLDIR%
rem CD into solution directory
call "%TDI_BIN_DIR%\ibmdicwd" %TDI_SOLDIR%

:execute
if not exist logs mkdir logs

rem Always add the Solution Directory libs dir to the path
set PATH=%TDI_SOLDIR%\libs;%PATH%

rem if .%TDI_SHUTDOWN%==.true (
   "%TDI_HOME_DIR%\ce\eclipsece\miadmin" -tdishutdown -noSplash %* -vm "%TDI_JAVAW_PROGRAM%" -vmargs -Dcom.ibm.di.loader.IDILoader.path="%TDI_HOME_DIR%" -Dcom.ibm.security.jurisdictionPolicyDir=c:/IBM/javapolicyfiles -Dcom.ibm.mq.cfg.useIBMCipherMappings=true  
rem ) else (
rem   start /B "Security Directory Integrator" "%TDI_HOME_DIR%\ce\eclipsece\miadmin" %* -vm "%TDI_JAVAW_PROGRAM%" -vmargs -Dcom.ibm.di.loader.IDILoader.path="%TDI_HOME_DIR%" -Dcom.ibm.security.jurisdictionPolicyDir=c:/IBM/javapolicyfiles -Dcom.ibm.mq.cfg.useIBMCipherMappings=true
rem )
if .%TDI_SHUTDOWN%==.true (
   "%TDI_HOME_DIR%\ce\eclipsece\miadmin" -tdishutdown -noSplash %* -vm "%TDI_JAVAW_PROGRAM%" -vmargs -Djavax.net.debug=true -Dcom.ibm.security.jurisdictionPolicyDir="C:\IBM\javapolicyfiles" -Djava.security.debug=ibmjcefw -Dcom.sun.jndi.ldap.object.disableEndpointIdentification=true -Djdk.tls.rejectClientInitiatedRenegotiation=true -Djdk.tls.ephemeralDHKeySize=2048 -Dcom.ibm.mq.cfg.useIBMCipherMappings=true -Dcom.ibm.di.loader.IDILoader.path="%TDI_HOME_DIR%"    
) else (
   start /B "Security Directory Integrator" "%TDI_HOME_DIR%\ce\eclipsece\miadmin" %* -vm "%TDI_JAVAW_PROGRAM%" -vmargs -Djavax.net.debug=true -Dcom.ibm.security.jurisdictionPolicyDir="C:\IBM\javapolicyfiles" -Djava.security.debug=ibmjcefw -Dcom.sun.jndi.ldap.object.disableEndpointIdentification=true -Djdk.tls.rejectClientInitiatedRenegotiation=true -Djdk.tls.ephemeralDHKeySize=2048 -Dcom.ibm.mq.cfg.useIBMCipherMappings=true -Dcom.ibm.di.loader.IDILoader.path="%TDI_HOME_DIR%" 
)

endlocal
