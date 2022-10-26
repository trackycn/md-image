# Paths
$packFolder =Split-Path $script:MyInvocation.MyCommand.Path
$slnPath = Join-Path $packFolder "../"
$srcPath = Join-Path $slnPath "src"

# List of projects
$projects = (
"NL.Framework.Caching",
"NLog.Extensions.Configuration",
"NLog.Targets.Aliyun",
"NL.Framework.OpenTracing.SkyApm",
"NL.Framework.NalongIdGen",
#	"NL.Framework.BootstrapSwagger",
"NL.Framework.AspNetCore.Mvc",
"Microsoft.Extensions.Configuration.Apollo",
"NL.Framework.Configuration.Json",
"NL.Framework",
"NL.Framework.AspNetCore",
"NL.Framework.Utility",
"NL.Framework.EventBus.Abstractions",
"NL.Framework.EventBus.AspNetCore",
"NL.Framework.EventBus.Kafka",
"NL.Framework.EventBus.RabbitMQ",
"NL.Framework.EventBus.AsyncHttp",
"NL.Framework.EventBus.EntityFrameworkCore",
"NL.Framework.Domain.Events",
"NL.Framework.ObjectMapping.Abstractions",
"NL.Framework.ObjectMapping.AutoMapper",
"NL.Framework.Service",
"NL.Framework.BackgroundTasks",
"NL.Framework.Hosting.WindowsServices",
"NL.Framework.Localization.Abstractions",
"NL.Framework.Localization.Json",
"NL.Framework.MongoDB",
"NL.Framework.ApiClient",
"NL.Nacos",
"NL.Nacos.AspNetCore",
"NL.Nacos.Microsoft.Extensions.Configuration",
"NL.Nacos.YamlParser",
"NL.Zipkin.Microsoft.Extensions.Configuration",
"NL.Framework.EventBus.MongoDB",
"NL.Framework.Notification",
"NL.Framework.Lock",
"NL.Framework.Authorization"  ,
"NL.Framework.PersistenceAPI.Abstractions",
"NL.Framework.PersistenceAPI.MongoDB",
"NL.Framework.PersistenceAPI.FreeSQL",
"NL.Framework.S3.Client",
"NL.Framework.S3.StsTokenClient",
"NL.Framework.BackgroundJobs.Hangfire"
)

# Rebuild solution

Remove-Item -Recurse (Join-Path $packFolder "*.nupkg")
$slnPath = Join-Path $packFolder "../" "NL.Framework.sln"
# Copy all nuget packages to the pack folder
$propsPath = Join-Path $packFolder "../" "common.props"
Write-Host "this propsPath is $propsPath" -ForegroundColor Yellow
$buildresultmldata =[XML](Get-Content  $propsPath -Encoding UTF8)
#应用版本
$version=$buildresultmldata.Project.PropertyGroup.Version
Write-Host "this version is $version" -ForegroundColor Yellow

##dotnet sonarscanner begin /k:"NL.Framework" /v:"$version" /d:sonar.host.url="http://192.168.5.129:9000" /d:sonar.login="0700c9583c61d0d0ef20edbaca429953261e11ce"
dotnet build $slnPath --configuration Release
##dotnet sonarscanner end /d:sonar.login="0700c9583c61d0d0ef20edbaca429953261e11ce"

foreach($project in $projects) {

    $projectFolder = Join-Path $srcPath $project

    # Create nuget pack
    Set-Location $projectFolder
    & dotnet msbuild /t:pack /p:Configuration=Release /p:SourceLinkCreate=true
    $projectPackPath = Join-Path $projectFolder ("/bin/Release/" + $project + ".*.nupkg")
    Move-Item $projectPackPath $packFolder

}




Set-Location $packFolder
foreach($project in $projects) {
    $nupkgName=  $project+"."+$version+".nupkg"
    Write-Host "push nupkg " + $nupkgName
    & dotnet nuget push (Join-Path  $packFolder $nupkgName )  --api-key ProGetAPIKey --source http://proget.aecg.com.cn/nuget/AquariumPackage/
}

