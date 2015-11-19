$sut = "$PSScriptRoot\..\..\tfs-build-task\PublishFeaturesToAugurk\PublishFeaturesToAugurk.ps1"
$augurkPath = "$PSScriptRoot\augurk.exe"

# Dummy function definitions so that we can Mock them
Function Find-Files { }
Function Get-ServiceEndpoint { }

Describe "Publishes Features To Augurk" {
	Mock Import-Module
	Mock Get-ServiceEndpoint { return "UrlToAugurkService" }
	
	Context "When Group Name Is Provided" {
		Mock Find-Files { return [PSCustomObject]@{FullName = "SomeInteresting.feature"} }
			
		& $sut -features "**\*.features" -connectedServiceName "SomeAugurkService" -productName "SomeProductName" `
			   -version "SomeVersion" -useFolderStructure "false" -groupName "SomeGroupName" -language "en-US" `
			   -augurkLocation "$augurkPath" -treatWarningsAsErrors "false"
			   
		It "Calls augurk.exe with the provided group name" {
			$arguments = (Get-Content "$augurkPath.out")
			$arguments | ? { $_.StartsWith("--groupName") } | Should Be "--groupName=SomeGroupName"
			Remove-Item "$augurkPath.out"
		}
	}
	
	Context "When Folder Structure is used" {
		Mock Find-Files { return [PSCustomObject]@{FullName = "SomeInteresting.feature"; Directory = "SomeParentFolder"} }
		
		& $sut -features "**\*.features" -connectedServiceName "SomeAugurkService" -productName "SomeProductName" `
			   -version "SomeVersion" -useFolderStructure "true" -language "en-US" `
			   -augurkLocation "$augurkPath" -treatWarningsAsErrors "false"
			   
		It "Calls augurk.exe with the provided group name" {
			$arguments = (Get-Content "$augurkPath.out")
			$arguments | ? { $_.StartsWith("--groupName") } | Should Be "--groupName=SomeParentFolder"
			Remove-Item "$augurkPath.out"
		}
	}
}