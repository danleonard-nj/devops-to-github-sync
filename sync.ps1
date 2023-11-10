$stageDir = '$(Build.SourcesDirectory)' | Split-Path
$githubDir = $stageDir +"\"+"gitHub"

$destination = $githubDir +"\"+"$(GitHubRepositoryName).git"

$alias = 'build-agent:'+ "$(GithubPat)"
$sourceURL = 'https://$(AzureDevOps.PAT)@$(AzureDevOps.RepositoryUri)'
$destURL = 'https://' + $alias + '@github.com/$(GithubRepositoryUri)'

if((Test-Path -path $githubDir))
{
  Remove-Item -Path $githubDir -Recurse -force
}
if(!(Test-Path -path $githubDir))
{
  New-Item -ItemType directory -Path $githubDir
  Set-Location $githubDir
  git clone --mirror $sourceURL
}
else
{
  Write-Host "The given folder path $githubDir already exists";
}
Set-Location $destination
Write-Output '*****Git removing remote secondary****'

git remote rm secondary

Write-Output '*****Git remote add****'
git remote add --mirror=fetch secondary $destURL

Write-Output '*****Git fetch origin****'
git fetch $sourceURL

Write-Output '*****Git push secondary****'
git push secondary --all

Write-Output '**Azure Devops repo synced with Github repo**'
Set-Location $stageDir
if((Test-Path -path $githubDir))
{
 Remove-Item -Path $githubDir -Recurse -force
}