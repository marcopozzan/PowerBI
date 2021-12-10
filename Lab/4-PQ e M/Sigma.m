let
    Source = Csv.Document(Web.Contents("http://www.meteo.psu.edu/holocene/public_html/Mann/research/res_pages/ONLINE-PREPRINTS/Millennium/DATA/RECONS/nhem-standerr-labeled.dat"),null,{0, 3, 10, 21},null,1252),
    #"Promoted Headers" = Table.PromoteHeaders(Source),
    #"Changed Type" = Table.TransformColumnTypes(#"Promoted Headers",{{"   ", type text}, {"YEAR   ", Int64.Type}, {"1 SIGMA    ", type number}, {"2 SIGMA   IGNORE THESE COLUMNS", type text}}),
    #"Removed Columns" = Table.RemoveColumns(#"Changed Type",{"   "}),
    #"Changed Type1" = Table.TransformColumnTypes(#"Removed Columns",{{"YEAR   ", type text}}),
    #"Removed Columns1" = Table.RemoveColumns(#"Changed Type1",{"2 SIGMA   IGNORE THESE COLUMNS"}),
    #"Renamed Columns" = Table.RenameColumns(#"Removed Columns1",{{"1 SIGMA    ", "Sigma"}}),
    #"Changed Type2" = Table.TransformColumnTypes(#"Renamed Columns",{{"YEAR   ", type date}})
in
    #"Changed Type2"