Function Install-RDSWebFeed
{
    [cmdletbinding()]
 
    Param
    (
        [Parameter(Mandatory=$true, HelpMessage="Please provide a valid URL, example 'https://remote.something.com/RDWeb/Feed/webfeed.aspx' .")]$URL
    )
 
    #Check if the RDS webfeed already exists.
    If(-not (Check-RDSWebFeed -URL $URL))
    {
        Write-Output "Information: Web feed doesn't exist.";
 
        #Create the WCX file.
        $WCX = (Create-WCXFile -URL $URL);
 
        #Add the web feed.
        Start-Process -FilePath rundll32.exe -ArgumentList 'tsworkspace,WorkspaceSilentSetup',$($WCX).ToString() -Wait -NoNewWindow;
 
        #Directory of the WCX file.
        $Directory = $WCX -split "\\";
 
        #Delete the WCX file.
        Remove-Item -Path ($Directory[0] + "\" + $Directory[1]) -Force -Confirm:$false -Recurse;
    }
    Else
    {
        Write-Output "Information: Web feed already exists.";
    }
}
 
Function Check-RDSWebFeed
{
    [cmdletbinding()]
 
    Param
    (
        [Parameter(Mandatory=$true, HelpMessage="Please provide a valid URL, example 'https://remote.something.com/RDWeb/Feed/webfeed.aspx' .")]$URL
    )
 
    #Get all feeds for the current user.
    $Feeds = Get-Item 'HKCU:\Software\Microsoft\Workspaces\Feeds\*';
 
    [bool]$InUse = $false;
 
    #Foreach feed.
    Foreach($Feed in $Feeds)
    {
        #If the feed is already in use.
        If($Feed.GetValue("URL") -eq "$URL")
        {
            #Set variable.
            $InUse = $true;
        }
    }
 
    Return $InUse;
}
 
Function Create-WCXFile
{
    [cmdletbinding()]
 
    Param
    (
        [Parameter(Mandatory=$true, HelpMessage="Please provide a valid URL, example 'https://remote.something.com/RDWeb/Feed/webfeed.aspx' .")]$URL
    )
 
    #Construct the XML file.
    $XML = @"
<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<workspace name="Company Remote Access" xmlns="http://schemas.microsoft.com/ts/2008/09/tswcx" xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<defaultFeed url="$URL" />
</workspace>
"@
 
    #WCX file path.
    $Directory = ("C:\" + [guid]::NewGuid() +"\");
    $WCX = "webfeed.wcx";
    $FullPath = ($Directory + $WCX);
 
    #New folder.
    New-Item $Directory -Type Directory -Force | Out-Null;
 
    #Export the file.
    $XML | Out-File -FilePath $FullPath -Encoding utf8 -Force | Out-Null;

    #Return file path.
    Return $FullPath;
}
 
Install-RDSWebFeed -URL "https://your.server/rdweb/Feed/webfeed.aspx";
