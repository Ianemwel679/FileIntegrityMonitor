Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms

$xamlFile="C:\Scripts\FileMonitorGUI\MainWindow.xaml"
$inputXAML=Get-Content -Path $xamlFile -Raw
$inputXAML=$inputXAML -replace 'mc:Ignorable="d"','' -replace "x:N","N" -replace "^<Win.*","<Window"
[xml]$XAML=$inputXAML

$reader = New-Object System.Xml.XmlNodeReader $XAML
try{
    $psform=[Windows.Markup.XamlReader]::Load($reader)
}catch{
    Write-Host $_.Exception
    throw
}
$XAML.SelectNodes("//*[@Name]") | ForEach-Object {
    try {
        Set-Variable -Name "var_$($_.Name)" -Value $psform.FindName($_.Name) -ErrorAction stop
    }
    catch {
        throw
    }
}

Get-Variable var_*

function Load-Baseline{
    $baselineFilePath=$var_lblBaseline.Content
    $baselineContents=Import-Csv -Path $baselineFilePath -Delimiter ','
    foreach($file in $baselineContents){
        $var_lstPath.Items.Add("$($file.path)")

    }
}

$var_btnLoadBaseline.Add_Click({
    $var_lstPath.Items.Clear()
    $inputFilePick=New-Object System.Windows.Forms.OpenFileDialog
    $inputFilePick.Filter= "CSV(*.csv) | *.csv"
    $inputFilePick.showDialog()
    $baselineFilePath=$inputFilePick.FileName
    if(Test-Path -Path $baselineFilePath){
        if(($baselineFilePath.Substring($baselineFilePath.Length-4,4) -eq ".csv")){
            $var_lblBaseline.Content=$baselineFilePath
            Load-Baseline
        }else{
            $var_lblBaseline="Invalid file needs to be a csv file"
        }
    }


})

$var_btnCheckFiles.Add_Click({
    $var_lstPath.Items.Clear()
    $baselineFilePath=$var_lblBaseline.Content
    $baselineContents=Import-Csv -Path $baselineFilePath -Delimiter ','
    foreach($file in $baselineContents){
        if(Test-Path -Path $file.path){
            $currenthash=Get-FileHash -Path $file.path
            if($currenthash.hash -eq $file.hash){
                $var_lstPath.Items.Add("$($file.path) has not changed")
            }else{
                $var_lstPath.Items.Add("$($file.path) has changed")
            }
        }else{
            $var_lstPath.Items.Add("$($file.path) is not found!")
        }
    }
})

$var_btnAddPath.Add_Click({
    $var_lstPath.Items.Clear() 
    $inputFilePick=New-Object System.Windows.Forms.OpenFileDialog
    $inputFilePick.ShowDialog()
    $baselineFilePath=$var_lblBaseline.Content
    $targetFilePath=$inputFilePick.FileName
    $currentBaseline=Import-Csv -Path $baselineFilePath -Delimiter ',' 

    if($targetFilePath -in $currentBaseline.path){
        $currentBaseline | Where-Object path -ne $targetFilePath | Export-Csv -Path $baselineFilePath -Delimiter ',' -NoTypeInformation
        $hash=Get-FileHash -Path $targetFilePath
        "$($targetFilePath),$($hash.hash)" | Out-File -FilePath $baselineFilePath -Append

    }else{
        $hash=Get-FileHash -Path $targetFilePath
        "$($targetFilePath),$($hash.hash)" | Out-File -FilePath $baselineFilePath -Append
    }
    $currentBaseline=Import-Csv -Path $baselineFilePath -Delimiter ','
    $currentBaseline | Export-Csv -Path $baselineFilePath -Delimiter ',' -NoTypeInformation
    Load-Baseline


})

$var_btnCreateBaseline.Add_Click({
    $var_lstPath.Items.Clear()
    $inputFilePick=New-Object System.Windows.Forms.SaveFileDialog
    $inputFilePick.Filter = "CSV (*.csv) | *.csv"
    $inputFilePick.ShowDialog()
    $baselineFilePath=$inputFilePick.FileName
    "path,hash" | Out-FilePath $baselineFilePath -Force
    $var_lblBaseline.Content=$baselineFilePath
    Load-Baseline
})

$psform.ShowDialog()
