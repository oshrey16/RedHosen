@echo off
cd ..


echo " ___  __  __  _  _  __     __  ____  __  ___     ___  ____  __   ___  ____  ___  ___  ";
echo "(  _)(  \/  )( )( )(  )   (  )(_  _)/  \(  ,)   / __)(_  _)(  ) (  ,)(_  _)(  _)(  ,) ";
echo " ) _) )    (  )()(  )(__  /__\  )( ( () ))  \   \__ \  )(  /__\  )  \  )(   ) _) )  \ ";
echo "(___)(_/\/\_) \__/ (____)(_)(_)(__) \__/(_)\_)  (___/ (__)(_)(_)(_)\_)(__) (___)(_)\_)";


echo "cohicee 0 - without export"
echo "choicee 1 - export"
set /p choicce="Enter choice: "
set "fixchoice="
if "%choicce%" == "0" goto cohice0
if "%choicce%" == "" goto cohice0
if "%choicce%" == "1" goto cohice1
:cohice0
start firebase emulators:start --import "EmulatorState"
goto commonexit

:cohice1
robocopy C:\Projects\RedHosen\red_hosen\EmulatorState C:\Projects\RedHosen\red_hosen\myscripts\EmulatorState /E
start firebase emulators:start --import "EmulatorState" --export-on-exit
goto commonexit

:commonexit
exit