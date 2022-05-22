 <#
    This is the code from dbatools in a Month of Lunches chapter 16

    You will have to pay attention to the names of instances and databases.

    You running this script/function/code means you will not blame the author(s) if this breaks your stuff. 
    This script/function is provided AS IS without warranty of any kind. Author(s) disclaim all implied warranties 
    including, without limitation, any implied warranties of merchantability or of fitness for a particular purpose. 
    The entire risk arising out of the use or performance of the sample scripts and documentation remains with you. 
    In no event shall author(s) be held liable for any damages whatsoever (including, without limitation, damages 
    for loss of business profits, business interruption, loss of business information, or other pecuniary loss) 
    arising out of the use of or inability to use the script or documentation.

    Chrissy Rob Jess Claudio
    #>

    
$copyLoginSplat = @{
    Source      = "sql01"
    Destination = "sql02"
    Login       = "WWI_Owner","WWI_ReadWrite","WWI_ReadOnly",
    [CA]"ad\JaneReeves"
}
Copy-DbaLogin @copyLoginSplat


        ###########
        
$dbSplat = @{
        SqlInstance     = "sql02"
        ExcludeSystem   = $true
        OutVariable     = "databases" 
    }
Get-DbaDatabase @dbSplat

$databases 

        ###########
        
$copyLoginSplat = @{
        Source              = "sql01"
        Destination         = "sql02"
        ExcludeSystemLogins = $true
    }
Copy-DbaLogin @copyLoginSplat


        ###########
        
$copyLoginSplat = @{
    Source          = "sql01"
    Destination     = "sql02"
    ExcludeLogin    = "ad\JaneReeves"
}
Copy-DbaLogin @copyLoginSplat

        ###########
        
Get-DbaAgentJob -SqlInstance sql01 | select-Object SqlInstance, Name, Category


        ###########
        
$copyJobSplat = @{
        Source          = "sql01"
        Destination     = "sql02"
        Job             = 'dbatools lab job','dbatools lab job - where am I'
        DisableOnSource = $true
    }
    Copy-DbaAgentJob @copyJobSplat


        ###########
        
$copyJobOperatorSplat = @{
    Source          = "sql01"
    Destination     = "sql02"
    Operator        = 'dba'
}
Copy-DbaAgentOperator @copyJobOperatorSplat


        ###########
        
$copyJobSplat = @{
    Source          = "sql01"
    Destination     = "sql02"
    Job             = 'dbatools lab job','dbatools lab job - where am I'
    DisableOnSource = $true
}
Copy-DbaAgentJob @copyJobSplat


        ###########
        
$copyMessageSplat = @{
    Source          = "sql01"
    Destination     = "sql02"
    CustomError     = 50005
}
Copy-DbaCustomError @copyMessageSplat


        ###########
        
$copyAlertSplat = @{
    Source          = "sql01"
    Destination     = "sql02"
    Alert           = 'FactoryApp - Custom Alert'
}
Copy-DbaAgentAlert @copyAlertSplat


        ###########
        
Get-DbaAgentJob -SqlInstance sql01 |
        Out-GridView -Passthru |
        Copy-DbaAgentJob -Destination dbatoolslab

        ###########
        
$copyLinkedServerSplat = @{
    Source      = "sql01"
    Destination = "sql02"
}
Copy-DbaLinkedServer @copyLinkedServerSplat


        ###########
        
Get-Command -Module dbatools -Verb Copy

        ###########
        
