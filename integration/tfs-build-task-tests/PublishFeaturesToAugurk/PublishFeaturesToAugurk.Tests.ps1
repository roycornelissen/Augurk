$sut = "$PSScriptRoot\..\..\tfs-build-task\PublishFeaturesToAugurk\PublishFeaturesToAugurk.ps1"

# Dummy function definitions so that we can Mock them
Function Find-Files { }
Function Get-ServiceEndpoint { }
Function Invoke-Tool { }

Describe "Publishes Features To Augurk" {
	Mock Import-Module
	Mock Get-ServiceEndpoint { return "UrlToAugurkService" }
	
	Context "When Group Name Is Provided" {
		Mock Find-Files { return [PSCustomObject]@{FullName = "SomeInteresting.feature"} }
		Mock Invoke-Tool -Verifiable -ParameterFilter { $Arguments -like "*--groupName=SomeGroupName*" }
		$augurk = New-Item TestDrive:\augurk.exe -Type File
			
		& $sut -features "**\*.features" -connectedServiceName "SomeAugurkService" -productName "SomeProductName" `
			   -version "SomeVersion" -useFolderStructure "false" -groupName "SomeGroupName" -language "en-US" `
			   -augurkLocation $augurk.FullName -treatWarningsAsErrors "false"
			   
		It "Calls augurk.exe with the provided group name" {
			Assert-VerifiableMocks
		}
	}
	
	Context "When Folder Structure is used" {
		Mock Find-Files { return [PSCustomObject]@{FullName = "SomeInteresting.feature"; Directory = "SomeParentFolder"} }
		Mock Invoke-Tool -Verifiable -ParameterFilter { $Arguments -like "*--groupName=SomeParentFolder*" }
		$augurk = New-Item TestDrive:\augurk.exe -Type File
		
		& $sut -features "**\*.features" -connectedServiceName "SomeAugurkService" -productName "SomeProductName" `
			   -version "SomeVersion" -useFolderStructure "true" -language "en-US" `
			   -augurkLocation $augurk.FullName -treatWarningsAsErrors "false"
			   
		It "Calls augurk.exe with the provided group name" {
			Assert-VerifiableMocks
		}
	}
}