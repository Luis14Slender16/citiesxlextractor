for /d %%a in (*) do if exist %%a\obj rd %%a\obj /S /Q
cd..
if exist Bin (
  cd Bin
  for %%a in (*.exe) do rd %%~na /S /Q
  for %%a in (*.exe) do del %%~na.pdb /F /Q
  for %%a in (*.exe) do del %%~na.xml /F /Q
  del *.vshost.exe /F /Q
  del *.manifest /F /Q
  cd..
)
cd Src
del *.cache /F /Q
del *.ncb /F /Q
pause
