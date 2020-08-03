// This file contains your Data Connector logic
section PQExtensionForBox;

// OAuth configuration settings
client_id = Text.FromBinary(Extension.Contents("client_id"));
client_secret = Text.FromBinary(Extension.Contents("client_secret"));
redirect_uri = "https://oauth.powerbi.com/views/oauthredirect.html";
windowWidth = 1200;
windowHeight = 1000;

[DataSource.Kind="PQExtensionForBox", Publish="PQExtensionForBox.Publish"]
shared PQExtensionForBox.Simple = (folderUri as text) as table =>
    let
        objects = #table(
            {"Name",       "Key",          "Data",                                "ItemKind", "ItemName", "IsLeaf"},
            {                                                                     
                {"FileList", "fileList", GetListByFolderId(folderUri),       "Table",    "Table",    true}
            }),
        NavTable = Table.ToNavigationTable(objects, {"Key"}, "Name", "Data", "ItemKind", "ItemName", "IsLeaf")
    in
        NavTable;

// Get a file list by using box folder uri
GetListByFolderId = (folderUri) =>
let
    
    folderId = List.Last(Text.Split(folderUri, "/")),
    source = Web.Contents("https://app.box.com/2.0/folders/"&folderId&"/items"),
    json = Json.Document(source),
    value = json[entries],
    thisFolderList = Table.FromList(value, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    boxlistsDetail = Table.ExpandRecordColumn(thisFolderList, "Column1", {"type", "id", "name"},  {"type", "id", "name"}),
    detailWithContent = Table.AddColumn(boxlistsDetail, "content", each GetFileContents([type],[id],[name]))
in
    detailWithContent;

// Get contens if the file is Excel or CSV
GetFileContents = (objectType, fileId, fileName)  =>
    let
        detailWithContent = if objectType ="file" and Text.EndsWith(fileName,".csv") then  
                                Csv.Document(Web.Contents("https://app.box.com/2.0/files/"&fileId&"/content"))
                            else if objectType ="file" and Text.EndsWith(fileName,".xlsx")then  
                                Excel.Workbook(Web.Contents("https://app.box.com/2.0/files/"&fileId&"/content"))
                            else
                                null
    in 
        detailWithContent;

// Data Source Kind description
PQExtensionForBox = [
    TestConnection = (dataSourcePath) => {"PQExtensionForBox.Simple", dataSourcePath},
    Authentication = [
        // Key = [],
        // UsernamePassword = [],
        // Windows = [],
        OAuth = [
            StartLogin = StartLogin,
            FinishLogin =FinishLogin
        ],
        Implicit = []
    ],
    Label = "Boxのファイルを取得する"
];


StartLogin = (resourceUrl, state, display) =>
        let
            AuthorizeUrl = "https://account.box.com/api/oauth2/authorize?" & Uri.BuildQueryString([
                client_id = client_id,
                response_type="code",
                redirect_uri = redirect_uri])
        in
            [
                LoginUri = AuthorizeUrl,
                CallbackUri = redirect_uri,
                WindowHeight = windowHeight,
                WindowWidth = windowWidth,
                Context = null
            ];

FinishLogin = (context, callbackUri, state) =>
    let
        Parts = Uri.Parts(callbackUri)[Query]
    in
        TokenMethod(Parts[code]);


TokenMethod = (code) =>
    let
        Response = Web.Contents("https://api.box.com/oauth2/token", [
            Content = Text.ToBinary(Uri.BuildQueryString([
                client_id = client_id,
                client_secret = client_secret,
                code = code,
                grant_type = "authorization_code"])),
            Headers=[#"Content-type" = "application/x-www-form-urlencoded",#"Accept" = "application/json"]]),
        Parts = Json.Document(Response)
    in
        Parts;

// Data Source UI publishing description
PQExtensionForBox.Publish = [
    Beta = true,
//    SupportsDirectQuery = true,     // enables direct query
    Category = "Other",
    ButtonText = { Extension.LoadString("FormulaTitle"), Extension.LoadString("FormulaHelp")  },
//     LearnMoreUrl = "https://powerbi.microsoft.com/",
     SourceImage = PQExtensionForBox.Icons,
     SourceTypeImage = PQExtensionForBox.Icons
];

// Common library code
Table.ToNavigationTable = (
    table as table,
    keyColumns as list,
    nameColumn as text,
    dataColumn as text,
    itemKindColumn as text,
    itemNameColumn as text,
    isLeafColumn as text
) as table =>
    let
        tableType = Value.Type(table),
        newTableType = Type.AddTableKey(tableType, keyColumns, true) meta 
        [
            NavigationTable.NameColumn = nameColumn, 
            NavigationTable.DataColumn = dataColumn,
            NavigationTable.ItemKindColumn = itemKindColumn, 
            Preview.DelayColumn = itemNameColumn, 
            NavigationTable.IsLeafColumn = isLeafColumn
        ],
        NavigationTable = Value.ReplaceType(table, newTableType)
    in
        NavigationTable;

PQExtensionForBox.Icons = [
    Icon16 = { Extension.Contents("PQExtensionForBox16.png"), Extension.Contents("PQExtensionForBox20.png"), Extension.Contents("PQExtensionForBox24.png"), Extension.Contents("PQExtensionForBox32.png") },
    Icon32 = { Extension.Contents("PQExtensionForBox32.png"), Extension.Contents("PQExtensionForBox40.png"), Extension.Contents("PQExtensionForBox48.png"), Extension.Contents("PQExtensionForBox64.png") }
];

