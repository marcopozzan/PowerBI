let
    Source = Csv.Document(Web.Contents("http://www.meteo.psu.edu/holocene/public_html/Mann/research/res_pages/ONLINE-PREPRINTS/Millennium/DATA/RECONS/nhem-recon.dat"),null,"",null,1252),
    #"Change Type" = Table.TransformColumnTypes(Source,{{"Column1", type text}, {"Column2", type text}, {"Column3", type text}}),
    #"Removed Columns" = Table.RemoveColumns(#"Change Type",{"Column1"}),
    #"Renamed Columns" = Table.RenameColumns(#"Removed Columns",{{"Column2", "Year"}, {"Column3", "Reconstructed Temp. Change"}}),
    #"Changed Type" = Table.TransformColumnTypes(#"Renamed Columns",{{"Reconstructed Temp. Change", type number}, {"Year", type date}}),
    #"Merged Queries" = Table.NestedJoin(#"Changed Type",{"Year"},Instrumental,{"Year"},"NewColumn",JoinKind.FullOuter),
    #"Expanded NewColumn" = Table.ExpandTableColumn(#"Merged Queries", "NewColumn", {"Year", "Instrumental Temp. Change"}, {"Year.1", "Instrumental Temp. Change"}),
    #"Added Index" = Table.AddIndexColumn(#"Expanded NewColumn", "Index", 1000, 1),
    #"Changed Type1" = Table.TransformColumnTypes(#"Added Index",{{"Index", type text}}),
    #"Removed Columns1" = Table.RemoveColumns(#"Changed Type1",{"Year", "Year.1"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Removed Columns1",{{"Index", "Year"}}),
    #"Changed Type2" = Table.TransformColumnTypes(#"Renamed Columns1",{{"Year", type date}}),
    #"Reordered Columns" = Table.ReorderColumns(#"Changed Type2",{"Year", "Reconstructed Temp. Change", "Instrumental Temp. Change"}),
    #"Merged Queries1" = Table.NestedJoin(#"Reordered Columns",{"Year"},Sigma,{"YEAR   "},"NewColumn",JoinKind.LeftOuter),
    #"Expanded NewColumn1" = Table.ExpandTableColumn(#"Merged Queries1", "NewColumn", {"Sigma"}, {"NewColumn.Sigma"}),
    #"Renamed Columns2" = Table.RenameColumns(#"Expanded NewColumn1",{{"NewColumn.Sigma", "Sigma"}}),
    #"Added Custom" = Table.AddColumn(#"Renamed Columns2", "Positive variance", each [Reconstructed Temp. Change] + [Sigma]),
    #"Added Custom1" = Table.AddColumn(#"Added Custom", "Negative variance", each [Reconstructed Temp. Change] - [Sigma]),
    #"Removed Columns2" = Table.RemoveColumns(#"Added Custom1",{"Sigma"}),
    #"Changed Type3" = Table.TransformColumnTypes(#"Removed Columns2",{{"Positive variance", type number}, {"Negative variance", type number}}),
    #"Renamed Columns3" = Table.RenameColumns(#"Changed Type3",{{"Instrumental Temp. Change", "Instrumental Temp Change"}, {"Reconstructed Temp. Change", "Reconstructed Temp Change"}})
in
    #"Renamed Columns3"