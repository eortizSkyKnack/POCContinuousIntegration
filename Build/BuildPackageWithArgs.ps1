#$acumaticaURL = "https://citesting.allendobbins.com/api/servicegate.asmx"
#$acumaticaUsername = "admin"
#$acumaticaPassword = "Test@123"
#$webSitePath = "C:\inetpub\wwwroot\CITesting"


#
# Script that builds , upload and publish blue indigo project
# Arguments
# acumaticaURL : URL where the customiztion packages are going to be deployed
# acumaticaUsername : Username
# acumaticaPassword : Password
# webSitePath : Path where an Acumatica instance is installed
#


param(
    [String]
    $acumaticaURL,
    [String]
    $acumaticaUsername,
    [String]
    $acumaticaPassword,
    [String]
    $webSitePath)

if(-NOT(Test-Path $webSitePath -PathType "Container"))
{
    Throw "$($webSitePath) is not a valid directory"
}



$buildToolPath = "$webSitePath\Bin\PX.CommandLine.exe"

if(-NOT(Test-Path $buildToolPath -PathType "Leaf"))
{
    Throw "PX.CommandLine.exe is not located in $($buildToolPath)"
}

$date = Get-Date -format "yyyy-MM-dd hh:mm:ss"

echo "Acumatica url: $acumaticaURL"
echo "Acumatica username: $acumaticaUsername"
echo "Website: $webSitePath"
echo "PX.CommandLine.exe path: $buildToolPath"
echo "Building at $date"


$packageDir = "..\packages"
$vswherePath = ".\vswhere.exe"
$nugetPath = ".\nuget.exe"



# Installing nuget packages.
echo "Installing nuget package in custom directory"
& $nugetPath install MSBuildTasks -version 1.5.0.235 -OutputDirectory $packageDir



# Validating if MSBuild does exists
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


# AD.BlueIndigo settings.
$binSourceFolderBlueIndigo = "..\WebApp\bin\AD.BlueIndigo.dll"
$binSourceFolderBlueIndigoPdb = "..\WebApp\bin\AD.BlueIndigo.pdb"
$projectSourceFolderBlueIndigo = "..\CustomizationFiles\ADBlueIndigoV20R2\*"
$tmpFolderBlueIndigo = "..\Builds\TempBlueIndigo\"
$tmpBinFolderBlueIndigo = "..\Builds\TempBlueIndigo\Bin"
$solutionPathBlueIndigo = "..\AD.BlueIndigo\AD.BlueIndigo.csproj"
$outPackagePathBlueIndigo = "..\Builds\ADBlueIndigoV20R2.zip"

# AD.APICode settings
$solutionPathADPCode = "..\AD.APICode\AD.APICode.csproj"
$projectSourceFolderApiCode = "..\CustomizationFiles\ADWebServiceManagementV20R2\*"
$binSourceFolderApiCode = "..\WebApp\bin\AD.APICode.dll"
$binSourceFolderApiCodePdb = "..\WebApp\bin\AD.APICode.pdb"
$tmpFolderApiCode = "..\Builds\TempApiCode\"
$tmpBinFolderApiCode = "..\Builds\TempApiCode\Bin"
$outPackagePathApiCode = "..\Builds\ADWebServiceManagementV20R2.zip"


echo "Building AD.APICode dll"
& $MSBuildPath $solutionPathADPCode  /p:Configuration=Release /p:Platform="AnyCPU" /verbosity:minimal  /t:Rebuild /p:AcumaticaDir="$webSitePath"


echo "Building AD.BlueIndigo dll"
& $MSBuildPath $solutionPathBlueIndigo  /p:Configuration=Release /p:Platform="AnyCPU" /verbosity:minimal  /t:Rebuild /p:AcumaticaDir="$webSitePath"


# Getting version number Blue Indigo
$versionBlueIndigoInfoFileCompletePath = Get-Item  ..\AD.BlueIndigo\Properties\version.txt | Resolve-Path -Relative
$versionBlueIndigo = Get-Content $versionBlueIndigoInfoFileCompletePath

# Getting version api code
$versionApiCodeFileCompletePath = Get-Item  ..\AD.APICode\Properties\version.txt | Resolve-Path -Relative
$versionApiCode = Get-Content $versionApiCodeFileCompletePath


echo "Preparing ADCustomIncludeFilesV20R2"
$webSitePathCustomIncludeFiles = "..\CustomizationFiles\ADCustomIncludeFilesV20R2\"
$outPackagePathCustomIncludeFiles = "..\Builds\ADCustomIncludeFilesV20R2.zip"
& $buildToolPath /method BuildProject /website $webSitePath /in $webSitePathCustomIncludeFiles /out $outPackagePathCustomIncludeFiles /description "Version 20.R2 $date Include Files"  /level 0
echo "$outPackagePathCustomIncludeFiles built"


echo "Preparing ADWebServiceManagementV20R2"

if (!(Test-Path $tmpFolderApiCode))
{
    md $tmpFolderApiCode >$null 2>&1
}
else
{
    Remove-Item $tmpFolderApiCode -recurse -Exclude "TempApiCode"
}

Copy-Item -Path $projectSourceFolderApiCode -Recurse -Destination $tmpFolderApiCode

if (!(Test-Path $tmpBinFolderBlueIndigo))
{
    md $tmpBinFolderBlueIndigo >$null 2>&1
}


Copy-Item -Path $binSourceFolderApiCode -Recurse -Destination $tmpBinFolderApiCode
Copy-Item -Path $binSourceFolderApiCodePdb -Recurse -Destination $tmpBinFolderApiCode

echo "PX.CommandLine.Exe going to be called for API Code"

& $buildToolPath /method BuildProject /website $webSitePath /in $tmpFolderApiCode /out $outPackagePathApiCode /description "Version 20.R2 $date Build $versionApiCode" /level 1

echo "$outPackagePathApiCode built"



echo "Preparing ADDataBaseUpdatesV20R2"
$webSitePathADDDate = "..\CustomizationFiles\ADDataBaseUpdatesV20R2\"
$outPackagePathADDData = "..\Builds\ADDataBaseUpdatesV20R2.zip"
& $buildToolPath /method BuildProject /website $webSitePath /in $webSitePathADDDate /out $outPackagePathADDData /description "Version 20.R2 $date Database Scripts" /level 3
echo "$outPackagePathADDData built"



echo "Preparing ADBlueIndigoV20R2"

if (!(Test-Path $tmpFolderBlueIndigo))
{
    md $tmpFolderBlueIndigo >$null 2>&1
}
else
{
    Remove-Item $tmpFolderBlueIndigo -recurse -Exclude "TempBlueIndigo"
}

Copy-Item -Path $projectSourceFolderBlueIndigo -Recurse -Destination $tmpFolderBlueIndigo

if (!(Test-Path $tmpBinFolderBlueIndigo))
{
    md $tmpBinFolderBlueIndigo >$null 2>&1
}


Copy-Item -Path $binSourceFolderBlueIndigo -Recurse -Destination $tmpBinFolderBlueIndigo
Copy-Item -Path $binSourceFolderBlueIndigoPdb -Recurse -Destination $tmpBinFolderBlueIndigo

echo "PX.CommandLine.Exe going to be called for BlueIndigo"

& $buildToolPath /method BuildProject /website $webSitePath /in $tmpFolderBlueIndigo /out $outPackagePathBlueIndigo /description "Version 20.R2 $date Build $versionBlueIndigo" /level 2

echo "$outPackagePathBlueIndigo built"




echo "Preparing ADCustomizedScreensV20R2"
$webSitePathAdCustomizedScreens = "..\CustomizationFiles\ADCustomizedScreensV20R2\"
$outPackageADCustomizedScreens = "..\Builds\ADCustomizedScreensV20R2.zip"
& $buildToolPath /method BuildProject /website $webSitePath /in $webSitePathAdCustomizedScreens /out $outPackageADCustomizedScreens /description "Version 20.R2 $date Modified Screns" /level 4
echo "$outPackageADCustomizedScreens built"


echo "Preparing ADSiteMap20R2"
$webSitePathAdSiteMap = "..\CustomizationFiles\ADSiteMap20R2\"
$outPackageADSiteMap = "..\Builds\ADSiteMap20R2.zip"
& $buildToolPath /method BuildProject /website $webSitePath /in $webSitePathAdSiteMap /out $outPackageADSiteMap /description "Version 20.R2 $date Site map and GIs" /level 11
echo "$outPackageADSiteMap built"


echo "Preparing ADSidePanelsAssetManagement"
$webSitePathADSidePanelsAssetManagemente = "..\CustomizationFiles\ADSidePanelsAssetManagement\"
$outPackagePathADSidePanelsAssetManagemente = "..\Builds\ADSidePanelsAssetManagement.zip"
& $buildToolPath /method BuildProject /website $webSitePath /in $webSitePathADSidePanelsAssetManagemente /out $outPackagePathADSidePanelsAssetManagemente /description "Version 20.R2 $date Side Panel Screens" /level 12
echo "$outPackagePathADSidePanelsAssetManagemente built"




#
# Uploading packages
#

$uploadPatch = "..\Build\UploadAcumatica.exe"

echo "Uploading acumatica packages"

echo "Uploading ADCustomIncludeFilesV20R2"

& $uploadPatch $acumaticaUsername $acumaticaPassword $acumaticaURL $outPackagePathCustomIncludeFiles "ADCustomIncludeFilesV20R2"

echo "Uploading ADWebServiceManagementV20R2"

& $uploadPatch $acumaticaUsername $acumaticaPassword $acumaticaURL $outPackagePathApiCode "ADWebServiceManagementV20R2"

echo "Uploading ADDataBasesV20R2"

& $uploadPatch $acumaticaUsername $acumaticaPassword $acumaticaURL $outPackagePathADDData "ADDataBaseUpdatesV20R2"

echo "Uploading ADBlueIndigoV20R2"

& $uploadPatch $acumaticaUsername $acumaticaPassword $acumaticaURL $outPackagePathBlueIndigo "ADBlueIndigoV20R2"

echo "Uploadig ADCustomizedScreensV20R2"

& $uploadPatch $acumaticaUsername $acumaticaPassword $acumaticaURL $outPackageADCustomizedScreens "ADCustomizedScreensV20R2"

echo "Uploadig ADSiteMap20R2"

& $uploadPatch $acumaticaUsername $acumaticaPassword $acumaticaURL $outPackageADSiteMap "ADSiteMap20R2"

echo "Uploading ADSidePanelsAssetManagement"

& $uploadPatch $acumaticaUsername $acumaticaPassword $acumaticaURL $outPackagePathADSidePanelsAssetManagemente "ADSidePanelsAssetManagement"

#
# Publish packages
#

echo "Publishing packages"

$publishPath = "..\Build\PublishAcumatica.exe"

echo "Publishing first stage"

& $publishPath $acumaticaUsername $acumaticaPassword $acumaticaURL "ADCustomIncludeFilesV20R2" "ADWebServiceManagementV20R2"

echo "Publishing second stage"

& $publishPath $acumaticaUsername $acumaticaPassword $acumaticaURL "ADCustomIncludeFilesV20R2" "ADWebServiceManagementV20R2" "ADBlueIndigoV20R2"

echo "Publishing last stage"

& $publishPath $acumaticaUsername $acumaticaPassword $acumaticaURL "ADCustomIncludeFilesV20R2" "ADWebServiceManagementV20R2" "ADBlueIndigoV20R2" "ADDataBaseUpdatesV20R2" "ADCustomizedScreensV20R2" "ADSiteMap20R2" "ADSidePanelsAssetManagement"


