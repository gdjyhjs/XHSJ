using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using System.Data;
using System.IO;
using Excel;
using OfficeOpenXml;

/// <summary>
/// 读取静态配置表的基础编辑器类
/// </summary>
abstract public class  EditStaticData : Editor
{
    abstract public void OnSetScript();
    abstract public void OnSetConnectionInfo(out List<TableDataPath> pathList, out TableDataPath mainDataPath, out bool needTxt);
    abstract public bool OnFetchData(DataTable dataTable);
    abstract public HashSet<string> ReportPath();
    abstract public bool CheckTable( MainStaticDataCenter dataCenter);
    abstract public bool RefineTable();
    abstract public bool Search();

    private bool foldout = false;
    private GUIContent foldOutContent = new GUIContent("数据");
    
    public override void OnInspectorGUI()
    {
        if (GUILayout.Button("Load Excel"))
        {
            if (EditorUtility.DisplayDialog("读取配置表", "确定要导入这个配置表吗 ?   ", "OK", "Cancel"))
            {
                if (LoadXlsx())
                {
                    RefineTable();

                     MainStaticDataCenter dataCenter = AssetDatabase.LoadAssetAtPath< MainStaticDataCenter>( MainStaticDataCenter.prefabPath);
                    if(CheckTable(dataCenter))
                    {
                        EditorUtility.DisplayDialog("读取配置表", "读取成功 ", "OK");
                    }
                    else
                    {
                        EditorUtility.DisplayDialog("配置表检查出错误", "详情请看Console窗口", "OK");
                    }
                    EditorUtility.SetDirty(target);
                    AssetDatabase.SaveAssets();
                }
                else
                {
                    EditorUtility.DisplayDialog("读取配置表失败", "详情请看Console窗口", "OK");
                }
            }
        }
        if (GUILayout.Button("Report Path"))
        {
            Debug.Log("Report Path Begin");
            var s = ReportPath();
            foreach (var str in s)
            {
                Debug.Log(str);
            }
            Debug.Log("Report Path End");
        }
        if(GUILayout.Button("Search"))
        {
            if(!Search())
            {
                EditorUtility.DisplayDialog("搜索失败", "没有找到相应数据，请确认id是否正确", "OK");
            }
            
        }
        foldout = EditorGUILayout.Foldout(foldout, foldOutContent);
        if (foldout)
        {
            base.OnInspectorGUI();
        }
    }
    
    void OnEnable()
    {
        OnSetScript();
    }	

    public int GetRowCount(DataTable dataTable)
    {
        int count = 0;
        for (; count < dataTable.Rows.Count; count++)
        {
            if (dataTable.Rows[count][dataTable.Columns[0].ColumnName].ToString() == "")
                return count;
        }

        return count;
    }

    static int GetColumnsCount(ExcelWorksheet ws)
    {
        int count = 0;
        for (; count < ws.Dimension.Columns; count++)
        {
            object obj = ws.Cells[1, count + 1].Value;
            if (obj == null || obj.ToString() == string.Empty)
            {
                return count;
            }
        }
        return count;
    }

    static int GetRowsCount(ExcelWorksheet ws)
    {
        int count = 0;
        for (; count < ws.Dimension.Rows; count++)
        {
            object obj = ws.Cells[count + 1, 1].Value;
            if (obj == null || obj.ToString() == string.Empty)
            {
                return count;
            }
        }
        return count;
    }

    public bool LoadXlsx()
    {
        List<TableDataPath> tablePathList;
        TableDataPath mainDataPath;
        bool needTxt;
        OnSetConnectionInfo(out tablePathList, out mainDataPath, out needTxt);

        // 合并表格
        if (!CombineExcel(mainDataPath, tablePathList))
        {
            Debug.LogError("合成表格错误");
            return false;
        }

        // 特殊情况：合并 modifier_node 表格
        if (Path.GetFileNameWithoutExtension(mainDataPath.dataPath) == "aura")
        {
            string pathPrefix = Application.dataPath + "/";

            TableDataPath data = new TableDataPath();
            data.dataPath = pathPrefix + "../../server/bin/data/modifier_node.xlsx";
            data.dataPath = data.dataPath.Replace("\\", "/");
            data.tableName = "Sheet1";

            TableDataPath data1 = new TableDataPath();
            data1.dataPath = pathPrefix + "../../server/bin/data/modifier_node_old.xlsx";
            data1.dataPath = data1.dataPath.Replace("\\", "/");
            data1.tableName = "Sheet1";

            TableDataPath data2 = new TableDataPath();
            data2.dataPath = pathPrefix + "../../server/bin/data/modifier_node_new.xlsx";
            data2.dataPath = data2.dataPath.Replace("\\", "/");
            data2.tableName = "Sheet1";

            TableDataPath data3 = new TableDataPath();
            data3.dataPath = pathPrefix + "../../server/bin/data/modifier_node_x.xlsx";
            data3.dataPath = data3.dataPath.Replace("\\", "/");
            data3.tableName = "Sheet1";

            TableDataPath data4 = new TableDataPath();
            data4.dataPath = pathPrefix + "../../server/bin/data/modifier_node_wxw.xlsx";
            data4.dataPath = data4.dataPath.Replace("\\", "/");
            data4.tableName = "Sheet1";

            TableDataPath data5 = new TableDataPath();
            data5.dataPath = pathPrefix + "../../server/bin/data/modifier_node_gqc.xlsx";
            data5.dataPath = data5.dataPath.Replace("\\", "/");
            data5.tableName = "Sheet1";

            TableDataPath data6 = new TableDataPath();
            data6.dataPath = pathPrefix + "../../server/bin/data/modifier_node_zikai.xlsx";
            data6.dataPath = data6.dataPath.Replace("\\", "/");
            data6.tableName = "Sheet1";

            TableDataPath data7 = new TableDataPath();
            data7.dataPath = pathPrefix + "../../server/bin/data/modifier_node_thy.xlsx";
            data7.dataPath = data7.dataPath.Replace("\\", "/");
            data7.tableName = "Sheet1";

            List<TableDataPath> pathList = new List<TableDataPath>() { data1, data2,data3, data4 , data5 , data6 , data7 };
            if (!(CombineExcel(data, pathList)))
            {
                Debug.LogError("合成 modifier_node 表错误");
                return false;
            }

            // 合并的表导出txt数据
            if (needTxt && !SaveAs_Txt(data.dataPath, data.tableName))
            {
                Debug.LogError("modifier_node 导出txt错误");
                return false;
            }
        }

        // 读取合并的表
        FileStream stream = File.Open(mainDataPath.dataPath, FileMode.Open, FileAccess.Read);
        IExcelDataReader excelReader = ExcelReaderFactory.CreateOpenXmlReader(stream);
        DataSet result = excelReader.AsDataSet();
        //DataTable dataTable = result.Tables[0];

        DataTable dataTable = result.Tables[mainDataPath.tableName];
        if (dataTable == null)
        {
            Debug.LogError("找不到子表, tableName: " + mainDataPath.tableName);
            return false;
        }

        if (!OnFetchData(dataTable))
        {
            Debug.LogError("读取表格有错");
            return false;
        }

        // 合并的表导出txt数据
        if (needTxt && !SaveAs_Txt(mainDataPath.dataPath, mainDataPath.tableName))
        {
            Debug.LogError("表格导出txt错误");
            return false;
        }

        Debug.Log("done");

        return true;
    }

    public static bool CombineExcel(TableDataPath resultDataPath, List<TableDataPath> dataPathList)
    {
        if (string.IsNullOrEmpty(resultDataPath.dataPath) || string.IsNullOrEmpty(resultDataPath.tableName))
        {
            Debug.LogError("目标表格路径或名字为空");
            return false;
        }
        if (dataPathList.Count <= 0)
        {
            return true;
        }

        // 创建合并表
        var fi = new FileInfo(resultDataPath.dataPath);
        if (fi.Exists)
        {
            File.SetAttributes(resultDataPath.dataPath, FileAttributes.Normal);
            //fi.Delete();
            //fi = new FileInfo(resultDataPath.dataPath);
        }
        using (var package = new ExcelPackage(fi))
        {
            if (ContainSheet(package.Workbook, resultDataPath.tableName))
            {
                package.Workbook.Worksheets.Delete(resultDataPath.tableName);
            }
            ExcelWorksheet worksheet = package.Workbook.Worksheets.Add(resultDataPath.tableName);

            Dictionary<string, List<object>> tableDict = new Dictionary<string, List<object>>();
            Dictionary<string, int> tableColumnDict = new Dictionary<string, int>();

            HashSet<string> pathSet = new HashSet<string>();
            pathSet.Add(resultDataPath.dataPath + "." + resultDataPath.tableName);

            // 从所有表中提取数据
            for (int i = 0; i < dataPathList.Count; i++)
            {
                var data = dataPathList[i];
                var cPath = data.dataPath + "." + data.tableName;
                if (pathSet.Contains(cPath))
                {
                    Debug.LogError("路径不能重复");
                    return false;
                }
                pathSet.Add(cPath);

                bool hasDefaultValue = true;

                var fileInfo = new FileInfo(data.dataPath);
                using (var pkg = new ExcelPackage(fileInfo))
                {
                    if (!ContainSheet(pkg.Workbook, data.tableName))
                    {
                        Debug.LogError(data.dataPath + " 没有找到子表 " + data.tableName);
                        return false;
                    }
                    ExcelWorksheet ws = pkg.Workbook.Worksheets[data.tableName];
                    int colNum = GetColumnsCount(ws);
                    int rowNum = GetRowsCount(ws);
                    if (colNum == 0 || rowNum < 2 || (i == 0 && rowNum == 2))
                    {
                        Debug.LogError("表格行数或列数错误, path:" + data.dataPath);
                        return false;
                    }
                    if (i == 0 && ws.Cells[3, 1].Value.ToString() != "0")
                    {
                        hasDefaultValue = false;
                    }

                    // 从第一张表复制前两行
                    if (i == 0) ws.Cells[1, 1, 2, colNum].Copy(worksheet.Cells[1, 1, 2, colNum]);

                    // 建立当前表第一行的索引
                    Dictionary<string, int> colDict = new Dictionary<string, int>();
                    for (int col = 1; col <= colNum; col++)
                    {
                        string key = ws.Cells[1, col].Value.ToString().Trim();
                        if (colDict.ContainsKey(key))
                        {
                            Debug.LogError("不允许重复的列 " + key + " path:" + data.dataPath);
                            return false;
                        }
                        colDict.Add(key, col);
                        // 从第一张表第一行用于建立主索引
                        if (i == 0) tableColumnDict.Add(key, col);
                    }

                    if (rowNum > 2)
                    {
                        // 迭代主索引，从当前表中获取数据
                        foreach (var v in tableColumnDict)
                        {
                            if (!tableDict.ContainsKey(v.Key))
                            {
                                tableDict.Add(v.Key, new List<object>());
                            }

                            int col;
                            bool hasKey = colDict.TryGetValue(v.Key, out col);
                            if (!hasKey && !hasDefaultValue)
                            {
                                Debug.LogError("该表缺少字段 " + v.Key + " 并且没有默认值, path:" + data.dataPath);
                                //return false;
                            }
                            for (int row = 3; row <= rowNum; row++)
                            {
                                // 使用默认值
                                var val = hasKey ? ws.Cells[row, col].Value : tableDict[v.Key][0];
                                tableDict[v.Key].Add(val);
                                if (!hasKey)
                                {
                                    Debug.LogWarning("该表缺少字段 " + v.Key + " path:" + data.dataPath);
                                }
                            }
                        }
                    }
                }
            }

            // 把数据复制到目标表中
            int colCount = 0;
            int rowCount = 0;
            foreach (var v in tableDict)
            {
                int col = tableColumnDict[v.Key];
                int totalRow = v.Value.Count + 2;
                for (int row = 0; row < v.Value.Count; row++)
                {
                    worksheet.Cells[row + 3, col].Value = v.Value[row];
                }
                
                colCount++;
                if (rowCount != 0 && rowCount != totalRow)
                {
                    Debug.LogError("合并表格错误，行数不同");
                }
                rowCount = totalRow;
            }

            // set style
            var range = worksheet.Cells[1, 1, rowCount, colCount];
            range.Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
            range.Style.VerticalAlignment = OfficeOpenXml.Style.ExcelVerticalAlignment.Center;

            package.Workbook.Worksheets.MoveToStart(resultDataPath.tableName);
            worksheet.View.TabSelected = true;

            worksheet.Calculate();
            worksheet.Cells.AutoFitColumns(5, 100);
            package.Save();
        }

        Debug.Log("Generate excel to : " + resultDataPath.dataPath);
        return true;
    }

    private static bool ContainSheet(ExcelWorkbook workBook, string sheetName)
    {
        foreach (var ws in workBook.Worksheets)
        {
            if (ws.Name == sheetName) return true;
        }
        return false;
    }

    public static bool SaveAs_Txt(string filePath, string tableName)
    {
        if (!filePath.EndsWith(".xlsx"))
        {
            Debug.LogError("路径错误, filePath:" + filePath);
            return false;
        }
        string targetFilePath = filePath.Replace(".xlsx", ".txt");

        var fi = new FileInfo(filePath);
        if (!fi.Exists)
        {
            Debug.LogError("文件不存在, filePath:" + filePath);
            return false;
        }

        // 设置要导出的txt文件，去掉只读
        var targetFI = new FileInfo(targetFilePath);
        if (targetFI.Exists)
        {
            File.SetAttributes(targetFilePath, FileAttributes.Normal);
        }

        using (var package = new ExcelPackage(fi))
        {
            if (!ContainSheet(package.Workbook, tableName))
            {
                Debug.LogError(filePath + " 没有找到子表 " + tableName);
                return false;
            }
            ExcelWorksheet ws = package.Workbook.Worksheets[tableName];
            int rowNum = GetRowsCount(ws);
            int colNum = GetColumnsCount(ws);

            using (TextWriter tw = new StreamWriter(targetFilePath, false, System.Text.Encoding.Unicode))
            {
                System.Text.StringBuilder sb = new System.Text.StringBuilder(10000);
                for (int i = 1; i <= rowNum; i++)
                {
                    for (int j = 1; j <= colNum; j++)
                    {
                        if (j != 1)
                        {
                            sb.Append("\t");
                        }
                        var value = ws.Cells[i, j].Value;
                        if (value != null)
                        {
                            if (ws.Cells[i,j].Style.WrapText)
                            {
                                sb.Append("\"");
                                sb.Append(value.ToString());
                                sb.Append("\"");
                            }
                            else
                            {
                                sb.Append(value.ToString());
                            }
                        }
                    }
                    sb.Append("\r\n");
                }
                tw.Write(sb);
            }
        }

        Debug.Log("generate txt : " + targetFilePath);
        return true;
    }
}

/// <summary>
/// 使用模板简化读取操作
/// </summary>
/// <typeparam name="T"></typeparam>
//[CustomEditor(typeof(T))]
public class  EditTemplateStaticData<T> :  EditStaticData where T :  StaticDataTableBase
{
    protected T script;

    public override void OnSetScript()
    {
        script = target as T;
    }

    public override void OnSetConnectionInfo(out List<TableDataPath> pathList, out TableDataPath mainDataPath, out bool needTxt)
    {
        pathList = new List<TableDataPath>();
        foreach (var data in script.tablePathList)
        {
            string fileFullName = Application.dataPath + "/" + data.dataPath;
            fileFullName = fileFullName.Replace("\\", "/");

            TableDataPath newDataPath = new TableDataPath();
            newDataPath.dataPath = fileFullName;
            newDataPath.tableName = data.tableName;
            pathList.Add(newDataPath);
        }

        string mainFileFullName = script.dataPath;
        mainFileFullName = mainFileFullName.Replace("\\", "/");
        mainDataPath = new TableDataPath();
        mainDataPath.dataPath = mainFileFullName;
        mainDataPath.tableName = script.tableName;

        needTxt = script.generateTxt;
    }

    public override bool OnFetchData(DataTable dataTable)
    {
        throw new System.NotImplementedException();
    }

    public override HashSet<string> ReportPath()
    {
        HashSet<string> s = new HashSet<string>();
        script.ReportAllAssetsPath(s);
        return s;
    }

    public override bool CheckTable( MainStaticDataCenter dataCenter)
    {
        return script.Check(dataCenter);
    }

    public override bool RefineTable()
    {
        return true;
    }
    public override bool Search()
    {
        return true;
    }
    
}


/// <summary>
/// 解析表格数据的基类，提供接口用
/// </summary>
public class  EditStaticDataParser<TK>
{
    //读取一个字段的接口
    public virtual bool OnRow( StaticIDData<TK> data, string key, string value)
    {
        return false;
    }

    //提供关心的字段
    public virtual string[] CareKeys()
    {
        return null;
    }

    //初始化时用于注册回调函数
    public virtual void Init()
    {

    }
}

/// <summary>
/// 模板类型的解析类，用于简化定义
/// </summary>
/// <typeparam name="T"></typeparam>
public class  EditStaticDataTemplateParser<T, TK> :  EditStaticDataParser<TK> where T :  StaticData
{
    public delegate bool ReadBlock(T newData, string dataValueOfName);

    protected Dictionary<string, ReadBlock> dataReadingTable = new Dictionary<string, ReadBlock>();

    protected void RegisterReadingMethod(string name, ReadBlock method)
    {
        if (dataReadingTable.ContainsKey(name)) {
            Debug.LogErrorFormat("reading method name conflict: {0}", name);
            return;
        }
        dataReadingTable.Add(name, method);
    }

    public override string[] CareKeys()
    {
        if (dataReadingTable.Count > 0)
        {
            string[] output = new string[dataReadingTable.Count];
            dataReadingTable.Keys.CopyTo(output, 0);
            return output;
        }
        return base.CareKeys();
    }

    public override bool OnRow( StaticIDData<TK> data, string key, string value)
    {
        if (!dataReadingTable.ContainsKey(key)) {
            Debug.LogErrorFormat("reading column not exist: {0}", key);
            return false;
        }
        ReadBlock rb = dataReadingTable[key];
        T specData = data as T;
        return rb(specData, value);
    }
}


//[CustomEditor(typeof( StaticIDDataTable<T>))]
public class  EditIDTemplateStaticData<T, TK> :  EditTemplateStaticData< StaticIDDataTable<T, TK>> where T :  StaticIDData<TK>, new()
{
    protected virtual void OnInit() { }
    bool initialized = false;
    //xrb
    public override bool Search()
    {
        script.AfterSearchDatalist = new List<T>();
        for (int i=0;i<script.datalist.Count;i++)
        {
            if(script.datalist[i].Id.ToString() == script.searchid)
            {
                script.AfterSearchDatalist.Add(script.datalist[i]);
                return true;
            }
        }
        return false;
    }

    public override bool OnFetchData(DataTable dataTable)
    {
        if (!initialized)
        {
            //初始化
            OnInit();
            initialized = true;
        }
        int count = GetRowCount(dataTable);
        if (count <= 0) return false;

        List<T> copyData = new List<T>();
        bool result = true;
        Dictionary<string, int> columnNameIndexTable = new Dictionary<string, int>();

        for (int i = 0; i < count; i++)
        {
            if (i == 0)
            {
                //第一行是表头，初始化列查找表
                int columns = dataTable.Columns.Count;
                for (int j = 0; j < columns; ++j)
                {
                    string name = dataTable.Rows[i][j].ToString();
                    if (columnNameIndexTable.ContainsKey(name))
                    {
                        Debug.LogErrorFormat("Param name conflicted:{0}", name == null ? "null" : name);
                    }
                    else
                    {
                        columnNameIndexTable.Add(name, j);
                    }
                }

                continue;
            }

            else if (i == 1)
            {
                continue;   //服务器表中标记读权限的行，客户端不需要
            }

            //余下的是数据
            T newData = new T();

            //依次用解析器
            foreach ( EditStaticDataParser<TK> parser in parsers)
            {
                string[] careKeys = parser.CareKeys();
                if (careKeys != null)
                {
                    foreach (string key in careKeys)
                    {
                        //LogMgr.AssertParam(LogMgr.Section.Editor, columnNameIndexTable.ContainsKey(key), "static data key not found:{0}",key);
                        if (!columnNameIndexTable.ContainsKey(key))
                        {
                            Debug.LogErrorFormat("没有找到列:{0}", key);
                            continue;
                        }
                        var col = columnNameIndexTable[key];
                        string value = dataTable.Rows[i][col].ToString();

                        bool res = parser.OnRow(newData, key, value);
                        if (!res)
                        {
                            Debug.LogErrorFormat("第{0}行 第{1}列错误", i, key);
                        }
                        result &= res;
                    }
                }
            }

            //添加到表中
            copyData.Add(newData);
        }

        script.datalist = copyData;
        return result;
    }


    /// <summary>
    /// 解析器
    /// </summary>
    private List< EditStaticDataParser<TK>> parsers = new List< EditStaticDataParser<TK>>();

    protected void AddParser<TP>() where TP: EditStaticDataParser<TK>, new()
    {
        TP p = new TP();
        p.Init();
        parsers.Add(p);
    }

}


public class  EditIntIDTemplateStaticData<T> :  EditIDTemplateStaticData<T, int> where T :  StaticIDData<int>, new()
{

    //定义读取ID的解析类
    public class Parser :  EditStaticDataTemplateParser< StaticIDData<int>, int>
    {
        public override void Init()
        {
            base.Init();

            //解析ID
            RegisterReadingMethod("ID", (_data, _value) =>
            {
                if (int.TryParse(_value, out _data.Id))
                    return true;
                return false;
            });
        }
    }
    protected override void OnInit()
    {
        AddParser<Parser>();
    }
}


public class  EditStringIDTemplateStaticData<T> :  EditIDTemplateStaticData<T, string> where T :  StaticIDData<string>, new()
{

    //定义读取ID的解析类
    public class Parser :  EditStaticDataTemplateParser< StaticIDData<string>, string>
    {
        public override void Init()
        {
            base.Init();

            //解析ID
            RegisterReadingMethod("ID", (_data, _value) =>
            {
                _data.Id = _value;
                return true;
            });
        }
    }
    protected override void OnInit()
    {
        AddParser<Parser>();
    }

}