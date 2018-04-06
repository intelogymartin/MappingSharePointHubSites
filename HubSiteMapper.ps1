
<#
 	.SYNOPSIS
 	Used to reveal a map of the hub site relationships in a tenancy.
 	 
 	.DESCRIPTION
 	This code iterates each site in the stated tenancy and produces an xml file that can imported into Draw.IO to show a diagram of the hub site relationships.
 	 	 
 	.INPUTS
    Change the $tenantPrefix variable to the start of the tenancy url e.g. "https://m365x529894"
     	 
 	.OUTPUTS
 	NewDrawIO.xml file stored in the current location>
 	 
 	.NOTES
 	Version: 1.0
 	Author: Martin White
 	Creation Date: 06/04/2018
 	Purpose/Change: Initial script development
 	 
 	.EXAMPLE
 	None
#>
 
 
$cred = Get-Credential
#$user = "admin@M365x529894.onmicrosoft.com"
#$pw = Get-Content "C:\Users\mwhite\OneDrive - Intelogy\MyDocs\PowerShell scripts\Contoso52894PW.txt" | ConvertTo-SecureString 
#$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $pw

$tenantPrefix = "https://m365x529894"

$tenantUrl = "$tenantPrefix.sharepoint.com"
Connect-SPOService $tenantPrefix-admin.sharepoint.com -Credential $cred

$tenantUrlLength = $tenantUrl.length
$hubSites=@()
$inheritingSites=@()

Write-Host "Getting site data..."
foreach($site in Get-SPOSite -limit all | select Url)
{
    $aSite = Get-SPOSite -id $site.Url  | select HubSiteId, IsHubSite, title, Url

    if ($aSite.IsHubSite -eq $true)
    {
        #It's a hub site    
        Write-Host HubSite: $aSite.Title $aSite.HubSiteId        
        $hubSites += $aSite
    }
    elseIf ($aSite.HubSiteId -ne "00000000-0000-0000-0000-000000000000") 
    {
        #It's not a hub site and it is using a hubsite
        Write-Host Inheriting site: $aSite.Title $aSite.HubSiteId           
        $inheritingSites += $aSite
    }
}

#Build the XML  
Write-Host "Build XML..."  
#Get start of xml file
Get-Content "DrawHeader.xml" > "NewDrawIO.xml"
$index = 1
$hubsYpos = 400
$inheritedYpos = 100
#loop all the hubsites
foreach ($hubsite in $hubSites)
{    
    $hubindex = $index++
    $theTitle = $hubsite.Title 
    $Url = $hubsite.Url.Substring($tenantUrlLength)

    Write-Host HubSite: $theTitle       
    #Add the hub site box
    "<mxCell id=`"6357f3653d729334-$hubindex`" value=`"$theTitle&lt;br&gt;$Url`" style=`"rounded=0;whiteSpace=wrap;html=1;`" vertex=`"1`" parent=`"1`">" >> "NewDrawIO.xml"
    "<mxGeometry x=`"100`" y=`"$hubsYpos`" width=`"200`" height=`"60`" as=`"geometry`"/>" >> "NewDrawIO.xml"
    "</mxCell>" >> "NewDrawIO.xml"
    $hubsYpos += 350

    #Get the sites that inherit from this hub site
    foreach ($inheritingsite in $inheritingsites | Where-Object { $_.HubSiteId -eq $hubsite.HubSiteId })
    {
        $inheritedindex = $index++
        #$index = $HubSitesIndexer[$hubsite.HubSiteId]
        
        $theTitle = $inheritingsite.Title 
        $url = $inheritingsite.Url.Substring($tenantUrlLength)
        Write-Host HubSite:  $theTitle         
        #Add the inheriting site box
        "<mxCell id=`"6357f3653d729334-$inheritedindex`" value=`"$theTitle&lt;br&gt;$url`" style=`"rounded=0;whiteSpace=wrap;html=1;`" vertex=`"1`" parent=`"1`">" >> "NewDrawIO.xml"
        "<mxGeometry x=`"500`" y=`"$inheritedYpos`" width=`"200`" height=`"60`" as=`"geometry`"/>" >> "NewDrawIO.xml"
        "</mxCell>" >> "NewDrawIO.xml"

        #Add the arrow            
        "<mxCell id=`"6357f3653d729334-$index`" value=`"`" style=`"endArrow=classic;html=1;`" edge=`"1`" parent=`"1`" source=`"6357f3653d729334-$hubindex`" target=`"6357f3653d729334-$inheritedindex`">" >> "NewDrawIO.xml"
            "<mxGeometry width=`"50`" height=`"50`" relative=`"1`" as=`"geometry`">" >> "NewDrawIO.xml"
                "<mxPoint x=`"140`" y=`"410`" as=`"sourcePoint`"/>" >> "NewDrawIO.xml"
                "<mxPoint x=`"190`" y=`"360`" as=`"targetPoint`"/>" >> "NewDrawIO.xml"
            "</mxGeometry>" >> "NewDrawIO.xml"
        "</mxCell>" >> "NewDrawIO.xml"

        $inheritedYpos += 150
        $index++
    }   
}

#Add the end of the file
Get-Content "DrawFooter.xml" >> "NewDrawIO.xml"
 
Disconnect-SPOService 
