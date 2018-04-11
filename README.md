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
 	The sample scripts are not supported under any Intelogy standard support program or service. 
    The sample scripts are provided AS IS without warranty of any kind. Intelogy further disclaims all implied warranties including, 
    without limitation, any implied warranties of merchantability or of fitness for a particular purpose. The entire risk arising out 
    of the use or performance of the sample scripts and documentation remains with you. In no event shall Intelogy, its authors, 
    or anyone else involved in the creation, production, or delivery of the scripts be liable for any damages whatsoever (including, 
    without limitation, damages for loss of business profits, business interruption, loss of business information, or other pecuniary loss) 
    arising out of the use of or inability to use the sample scripts or documentation, even if Intelogy has been advised of the possibility 
    of such damages. 

 	.EXAMPLE
 	None
#>
 
 
