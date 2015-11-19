function Invoke-BuildTask (
	[CmdletBinding()]
	param (
		[Parameter(Mandatory=$true)]$TaskDefinitionFile
	)
	
	# Load task definition from json
	$taskDefinition = Get-Content $TaskDefinitionFile | ConvertFrom-Json
	
)

Export-Function Invoke-BuildTask