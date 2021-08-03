param (
    [Parameter(Mandatory)]
    [ValidateNotNullOrEmpty]
    [string]$serverName,

    [Parameter]
    [switch]$OneInstance
)

Describe "SQL Install is good" {
    Context ('{0} - has the expected sql installs' -f $serverName) {
        $instances = Find-DbaInstance -ComputerName $serverName
        It "SQL Server 2019 should be installed as a default instance" {
            
        }
    }
