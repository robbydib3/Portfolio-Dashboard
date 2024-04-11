echo off
cd /d %~dp0
set "current_dir=%cd%"
set "rscript_path="C:\Program Files\R\R-4.3.3\bin\Rscript.exe""
set "r_script=StockDataPull.R"

%rscript_path% "%current_dir%\%r_script%"