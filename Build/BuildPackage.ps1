$buildToolPath = "..\..\..\Bin\PX.CommandLine.exe"
$vswherePath = ".\vswhere.exe"
$webSitePath = "..\..\..\"
$outPackagePath = ".\POCCI.zip"
$binSourceFolder = "..\POCCILib\POCCILib\bin\Release\*"
$projectSourceFolder = "..\POCCILib\*"
$tmpFolder = ".\Temp"
$tmpBinFolder = ".\Temp\Bin"
$solutionPath = "..\POCCILib\POCCILib.sln"

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

echo "Call to msbuild with command $MSBuildPath $solutionPath /p:Configuration=Release /p:Platform=Any CPU /verbosity:minimal"

& $MSBuildPath $solutionPath /p:Configuration=Release /p:Platform="Any CPU" /verbosity:minimal

echo "MSBuild called"

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

& $buildToolPath /method BuildProject /website $webSitePath /in $tmpFolder /out $outPackagePath /description "Test"






