rem command prompt script

rem load script type from type.sh
rem find the line with the '=' sign, and store it into 'delme.txt'
type type.sh | findstr = > delme.txt
rem read that content and save into temporary variable
set /p TEMP=<delme.txt
rem skip the first 5 characters and save the rest of the string
set TYPE=%TEMP:~5%
rem delete temporary file
del delme.txt
rem now inside %TYPE% variable we have the analysis type

rem # get current date
for /F "usebackq tokens=1,2 delims==" %%i in (`wmic os get LocalDateTime /VALUE 2^>NUL`) do if '.%%i.'=='.LocalDateTime.' set ldt=%%j
rem set ldt=%ldt:~0,4%-%ldt:~4,2%-%ldt:~6,2% %ldt:~8,2%:%ldt:~10,2%:%ldt:~12,6%
set DATE=%ldt:~0,4%%ldt:~4,2%%ldt:~6,2%_%ldt:~8,2%%ldt:~10,2%%ldt:~12,2%
rem echo Local date is [%DATE%]

rem # get current directory
set DIR=%cd%
set DIRFFF="..\3F"

rem # copy files and folder in the framework folder

rem provide your own drawing
copy /Y *.fem %DIRFFF%
rem provide your motor_data
copy /Y motor_data.lua %DIRFFF%\motor_data.lua
rem provide your materials
copy /Y materials_and_bc.lua %DIRFFF%\materials_and_bc.lua
rem provide your overwriting inputs
robocopy /e /y input %DIRFFF%\input


cd %DIRFFF%
rem # change directory to the framework one

femm33Mar\bin\femme.exe -lua-script="%TYPE%.lua"
rem # previous command calls femme and starts $TYPE in this case

if %TYPE% == "ANALYSIS" (
  rem # copy results
  copy /y output\results.out %DIR%\output\results.out
  copy /y %DIR%\output\results.out %DIR%\output\results_%DATE%.out
  rem # copy temps
  copy /y temp.fem %DIR%\temp.fem
  copy /y temp.ans %DIR%\temp.ans
  rem # remove *.fem from framework folder
  del *.fem
  del motor_data.lua
  del materials_and_bc.lua
  )

if %TYPE% == "DRAWING" (
 copy /y *.fem %DIR%\
 del *.fem
 )

if %TYPE% == "DRAWING+ANALYSIS" (
  rem # copy results
  copy /y output\results.out %DIR%\output\results.out
  copy /y %DIR%\output\results.out %DIR%\output\results_%DATE%.out
  rem # copy temps
  copy /y temp.ans %DIR%\temp.ans
  copy *.fem %DIR%\
  del *.fem 
  del motor_data.lua
  del materials_and_bc.lua
  )

