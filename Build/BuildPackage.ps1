#$buildToolPath = "C:\Projects\BlueIndigoBase\Customization\BlueIndigoBase\BlueIndigoBaseValidation\BlueIndigoBaseWebsite\Bin\PX.CommandLine.exe"
$buildToolPath = "..\..\..\..\Bin\PX.CommandLine.exe"
$vswherePath = ".\vswhere.exe"
$webSitePath = "C:\Projects\BlueIndigoBase\BlueIndigoBase"
#$webSitePath = "C:\Projects\BlueIndigoBase\Customization\BlueIndigoBase\BlueIndigoBaseValidation\BlueIndigoBaseWebsite\"
$outPackagePath = "..\Builds\POCCIBuild.zip"
$binSourceFolder = "..\Builds\Temp\POCCILib\bin\Release\*"
$projectSourceFolder = "..\POCCILib\*"
$tmpFolder = "..\Builds\Temp\"
$tmpBinFolder = "..\Builds\Temp\Bin"
$solutionPath = "..\POCCILib\POCCILib.sln"
$solutionPath2 = "..\POCCILib\POCCILib\POCCILib.csproj"

#$MSBuildPath = & $vswherePath -latest -products * -requires Microsoft.Component.MSBuild -property installationPath
#if ($MSBuildPath) {
#  $MSBuildPath = join-path $MSBuildPath 'MSBuild\Current\Bin\MSBuild.exe'
#  if (test-path $MSBuildPath) {
#    Write-Host $MSBuildPath
#  }
#  else
#  {
#    Write-Host "Failed to find MSBuild"
#  }
#}
#else
#{
#    Write-Host "Failed to find MSBuild"
#}
#
#set MSBuildEmitSolution=1
#& $MSBuildPath $solutionPath2  /p:Configuration=Release /p:Platform="AnyCPU" /verbosity:minimal 
#
#echo "MSBuild called"
#
#if (!(Test-Path $tmpFolder))
#{
#    md $tmpFolder >$null 2>&1
#}
#else
#{
#    Remove-Item $tmpFolder -recurse -Exclude "Temp"    
#}
#
#Copy-Item -Path $projectSourceFolder -Recurse -Destination $tmpFolder
#
#if (!(Test-Path $tmpBinFolder))
#{
#    md $tmpBinFolder >$null 2>&1
#}
#Copy-Item -Path $binSourceFolder -Recurse -Destination $tmpBinFolder

echo   "$buildToolPath /method BuildProject /website $webSitePath /in $tmpFolder /out $outPackagePath /description Test"

& $buildToolPath /method BuildProject /website $webSitePath /in $tmpFolder /out $outPackagePath /description "Test"


#echo   "$buildToolPath /method BuildProject /in $tmpFolder /out $outPackagePath /description Test"
#
#& $buildToolPath /method BuildProject  /in $tmpFolder /out $outPackagePath /description "Test"




