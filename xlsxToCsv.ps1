    #pegar o idx da planilha se for passado o parametro, sen�o pega a primeira
    if ( $args[1] ){
        $nPlanilha = [int]$args[1]
    } Else {
        $nPlanilha = 1
    }
   
    #pega o diretorio
    #$dir = ( Get-Item $args[0] ).DirectoryName
    
    #pega o nome base do arquivo
    $fileBase = (Get-Item $args[0] ).BaseName

    #define o nome do arquivo de saida
    $outFile = "$env:TEMP\$fileBase.tmp"

    #deletar o arquivo tmp, se existir
    if( Test-Path $outFile ){
        Remove-Item $outFile     
    } 
    
    #deletar o arquivo csv, se existir
    if( Test-Path "$dir\$fileBase.csv" ){
        Remove-Item "$dir\$fileBase.csv"     
    } 


    #operacoes com o excel
    $Excel = New-Object -ComObject Excel.Application

	$Excel.DisplayAlerts = $false
	$Excel.ScreenUpdating = $false
	$Excel.Visible = $false
	$Excel.UserControl = $false
	$Excel.Interactive = $false

    $excelFile = $args[0]
    
    $wb = $Excel.Workbooks.Open($excelFile)

	$workSheet = $wb.Sheets.Item($nPlanilha);
    
	$workSheet.SaveAs($outFile, 06)

    $Excel.Quit()
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($Excel)
    spps -n Excel

    Rename-Item $outFile "$env:TEMP\$fileBase.csv"