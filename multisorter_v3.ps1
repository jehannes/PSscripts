#maybe check if file exists in target folder if so delete else move over
#maybe add check to files if they are more than a day old

 #folders to sort
 $Folders = "Downloads", "Documents"

 $targets=#an array with tuples: target folder & an array of extension to be sorted to it (sub targets)
 @("PDF",@("pdf")),
 @("POWERPOINT",@("ppt*")),
 @("EXE",@("exe","msi")),
 @("EXCEL",@("xlr","cls","xls*")),
 @("WPF",@("odt","tex","wps","wks","txt","txt","doc","rtf","wpd","docx")),
 @("AUDIO",@("aif","cda","mid","mp3","mpa","ogg","wav","wma","wpl","midi")),
 @("IMAGES",@("ai","ps","bmp","gif","ico","jpg","png","psd","svg","tif","pbm","pgm","ppm","tiff","jpeg")),
 @("VIDEOS",@("rm","swf","vob","wmv","3gp","avi","flv","m4v","mkv","mov","mp4","3g2","mpeg","h264","h265","hvec")),
 @("COMPRESSED",@("7z","rar","txz","tlz","war","xar","pea","arc","ark","apk","cdx","cab","sqx","arj","deb","pkg","rpm","zip","tar","wim","zpix","tbz2","rar4","tar.*")),
 @("CODE",@("c","h","md","ui","py","cs","sh","pl","vb","asp","pyc","pro","cpp","hpp","css","xml","pdb","dll","sql","cer","cgi","htm","jsp","rss","cfm","part","java","aspx",
 "xaml","html","json","make","class","xhtml","swift","stash","sqlite","release",".pro.user","gitignore"))
 



 for($i=0; $i -lt $Folders.count; $i++){

    $curFolder= $Folders[$i]

    #copied file remover 
    Get-ChildItem -Path $env:USERPROFILE\$curFolder\*| where { !$_.PSisContainer }  |Where-Object Name -Match "w*\(\d+\)*" |Select-Object FullName|ForEach-Object { Remove-Item -Path $_.FullName }

    
    for($j=0;$j -lt $targets.Count; $j++){
        #construct base and target path
        $curPath=$env:USERPROFILE+"\"+$curFolder+"\UNSORTED\"+$targets[$j][0]
        $basePath= $env:USERPROFILE+"\"+$curFolder+"\*."

        #check target path, if non existant make it
        if(-not (Test-Path $curPath)){
                New-Item -Path $curPath -ItemType Directory
        }

        #sort all sub targets for a given target folder
        forEach($element in $targets[$j][1]){
                Get-ChildItem -Path $basePath$element | Select-Object FullName | ForEach-Object {Move-Item -Path $_.FullName -Destination $curPath}
        }
    }

    #special cases
    Move-Item -Path $env:USERPROFILE\$curFolder\*LICENSE* -Destination $env:USERPROFILE\$curFolder\UNSORTED\CODE

    #remaining/other files
    Get-ChildItem -Path $env:USERPROFILE\$curFolder\* | where { !$_.PSisContainer } | Select-Object FullName| ForEach-Object {Move-Item -Path $_.FullName -Destination $env:USERPROFILE\$curFolder\UNSORTED\OTHER }
}