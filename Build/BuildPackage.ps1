$buildToolPath = "C:\Projects\BlueIndigoBase\BlueIndigoBase\Bin\PX.CommandLine.exe"
$vswherePath = ".\vswhere.exe"
$webSitePath = "C:\Projects\BlueIndigoBase\BlueIndigoBase"
$outPackagePath = "..\Builds\POCCIBuild.zip"
$binSourceFolder = "..\POCCILib\POCCILib\bin\Release\POCCILib.*"
$projectSourceFolder = "..\POCCI\*"
$tmpFolder = "..\Builds\Temp\"
$tmpBinFolder = "..\Builds\Temp\Bin"
$solutionPath = "..\POCCILib\POCCILib\POCCILib.csproj"

$MSBuildPath = & $vswherePath -latest -products * -requires Microsoft.Component.MSBuild -property installationPath
if ($MSBuildPath) {
  $MSBuildPath = join-path $MSBuildPath 'MSBuild\Current\Bin\MSBuild.exe'
  if (test-path $MSBuildPath) {
    Write-Host $MSBuildPath
  }
  else
  {
    Write-Host "Failed to find MSBuild"
  }
}
else
{
    Write-Host "Failed to find MSBuild"
}

#set MSBuildEmitSolution=1
echo "$MSBuildPath $solutionPath  /p:Configuration=Release /p:Platform='AnyCPU' /verbosity:minimal"
& $MSBuildPath $solutionPath  /p:Configuration=Release /p:Platform="AnyCPU" /verbosity:minimal  /t:Rebuild

echo "MSBuild going to be called"

if (!(Test-Path $tmpFolder))
{
    md $tmpFolder >$null 2>&1
}
else
{
    Remove-Item $tmpFolder -recurse -Exclude "Temp"    
}

Copy-Item -Path $projectSourceFolder -Recurse -Destination $tmpFolder

if (!(Test-Path $tmpBinFolder))
{
    md $tmpBinFolder >$null 2>&1
}
Copy-Item -Path $binSourceFolder -Recurse -Destination $tmpBinFolder

echo "PX.CommandLine.Exe going to be called"
#echo   "$buildToolPath /method BuildProject /website $webSitePath /in $tmpFolder /out $outPackagePath /description Test"

& $buildToolPath /method BuildProject /website $webSitePath /in $tmpFolder /out $outPackagePath /description "Test"




