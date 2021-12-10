let
    Source = Csv.Document(Web.Contents("http://www.meteo.psu.edu/holocene/public_html/Mann/research/res_pages/ONLINE-PREPRINTS/Millennium/DATA/RECONS/nhem-raw.dat"),null,"",null,1252),
    #"Change Type" = Table.TransformColumnTypes(Source,{{"Column1", type text}, {"Column2", type text}, {"Column3", type text}}),
    #"Removed Columns" = Table.RemoveColumns(#"Change Type",{"Column1"}),
    #"Renamed Columns" = Table.RenameColumns(#"Removed Columns",{{"Column2", "Year"}}),
    #"Changed Type" = Table.TransformColumnTypes(#"Renamed Columns",{{"Year", type date}}),
    #"Renamed Columns1" = Table.RenameColumns(#"Changed Type",{{"Column3", "Instrumental Temp. Change"}}),
    #"Changed Type1" = Table.TransformColumnTypes(#"Renamed Columns1",{{"Instrumental Temp. Change", type number}})
in
    #"Changed Type1"