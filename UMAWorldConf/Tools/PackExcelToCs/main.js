var fs = require('fs');
var xlsx = require('node-xlsx');
var crypto = require('crypto');

var conf;
var cacheFileData;

var notUseCache = false;

if (process.argv.length >= 3)
{
	notUseCache = process.argv[2] == "notUseCache";
}

fs.readFile('./conf.json', 'utf8', function(err, data){
    conf = JSON.parse(data);
    cacheFileData = JSON.parse(notUseCache ? "{}" : fs.readFileSync('./cacheFile.json', 'utf8'));
    if(cacheFileData.tableFileCsStr == null)
    {
    	cacheFileData.tableFileCsStr = {};
    }
    if(cacheFileData.fileCache == null)
    {
    	cacheFileData.fileCache = {};
    }

    var newCacheFileData = {};
    newCacheFileData.tableFileCsStr = cacheFileData.tableFileCsStr;
    newCacheFileData.fileCache = cacheFileData.fileCache;
    var newCacheFileWriteCount = 0;

    //循环读取文件
    fs.readdir(conf.confPath, (err, files)=>{
    	var csScriptStr = "using System.Collections.Generic;\n\n";
    	var allTableName = new Array();

    	//读取excel文件内容
    	for (var i=0; i<files.length; i++)
    	{
    		var fileName = files[i];
    		var filePath = conf.confPath + '/' + fileName;

    		var md5Str = getFileMD5(filePath);

			var tableNames = new Array();

			console.log(fileName);
			if(cacheFileData.fileCache[fileName] != null && cacheFileData.fileCache[fileName].MD5 == md5Str)
			{
				for (var j=0; j<cacheFileData.fileCache[fileName].tableNames.length; j++)
				{
					var tabName = cacheFileData.fileCache[fileName].tableNames[j];
					allTableName.push(tabName);
					tableNames.push(tabName);
				}
			}
			else
			{
				var obj = xlsx.parse(filePath, {raw : false});//配置excel文件的路径
				for (var j=0; j<obj.length; j++)
				{
					if (obj[j].name.indexOf("#") != -1)
					{
						var name = obj[j].name.slice(1, obj[j].name.length);
						console.log(fileName + ":" +name);
				
						var csStr = ExcelToCsStr(name, obj[j].data);
				    	csStr = replaceAll(csStr, "\r", "");
				    	csStr = replaceAll(csStr, "\n", "\r\n");

						var tabName = [name, fileName];
						allTableName.push(tabName);
						tableNames.push(tabName);

						newCacheFileData.tableFileCsStr[name] = { csStr:csStr };
					}
				}
			}

    		//缓存数据
			newCacheFileData.fileCache[fileName] = { MD5: md5Str, tableNames: tableNames};
			newCacheFileWriteCount++;

			//写入完成
			if (newCacheFileWriteCount >= files.length)
			{
				fs.writeFileSync('./cacheFile.json', JSON.stringify(newCacheFileData, null, 4));

				var csPath = conf.csPath + '\\ConfPack';
    			if(!fs.existsSync(csPath))
    			{
					fs.mkdirSync(csPath);
    			}
			 	fs.readdir(csPath, function(err,files){
    			 	for (var key in files)
    			 	{ 
    			 		var filename = files[key];
					    var index = filename.lastIndexOf(".");
					    var suffix = filename.substring(index+1);
					    if (suffix == "cs")
					    {
					    	fs.unlinkSync(csPath + "\\" + files[key]);
					    }
    			 	}

    			 	var csStrText = "";
			    	for (let key in newCacheFileData.tableFileCsStr) {
			    		var isComplete = false;
			    		for (var i in allTableName) 
			    		{
			    			if (key == allTableName[i][0])
			    			{
			    				isComplete = true;
			    				break;
			    			}
			    		}

			    		if (isComplete)
			    		{
				    		var csStr = newCacheFileData.tableFileCsStr[key].csStr;
				    		csStrText += csStr + "\r\n";

							fs.writeFileSync(conf.csPath + '\\ConfPack\\Conf' + key + "Base.cs", csStr);
			    		}
			    	}

					fs.writeFileSync(conf.csPath + '\\ConfPack\\ConfPack.txt', csStrText);
    			});
			}
    	}    	

		//导出总配置
		ExcelTableToCsMgrStr(allTableName);
		ExcelTableToCsMgrVariantStr(allTableName);
    });
});

function ExcelToCsStr(name, data)
{
	var csStr = heredoc(function(){/*
using UnityEngine;
using UnityEditor;
using System.Collections.Generic;

public class ConfItemClassName : ConfBaseItem
{
//parameter
//constructor	

	public ConfItemClassName Clone()
	{
	    return base.CloneBase() as ConfItemClassName;
	}
}
public class ConfClassName : ConfBase
{
	private List<ConfClassItemName> _allConfList = new List<ConfClassItemName>();
	public IReadOnlyList<ConfClassItemName> allConfList {
		get { return _allConfList; }
	}

//keytovalueData
    public override void Init()
    {
//data1
	}

//data2

	public override void AddItem(int id, ConfBaseItem item)
	{
		base.AddItem(id, item);
		_allConfList.Add(item as ConfClassItemName);
	}

	public ConfClassItemName GetItem(int id)
	{
		return GetItemObject<ConfClassItemName>(id);
	}
	
//getItemInKey
}
	
	 */});
	
	var csConfStr = heredoc(function(){/*
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ConfClassName : ConfClassNameBase
{
    public override void OnInit()
    {
        base.OnInit();
    }
}
*/});

	//替换类名
	csStr = replaceAll(csStr, "ConfItemClassName", "Conf" + name + "Item");
	csStr = replaceAll(csStr, "ConfClassName", "Conf" + name + "Base");
	csStr = replaceAll(csStr, "ConfClassItemName", "Conf" + name + "Item");

	//添加参数
	var parStr = "";
	for(var i=0; i<data[0].length; i++)
	{
		if(data[1][i] == "id")
		{
			continue;
		}
		var dataStr = replaceAll(data[0][i], "\r\n", "");
		dataStr = replaceAll(dataStr, "\n", "");
		parStr += "\t" + "public " + data[2][i] + " " + data[1][i] + ";\t\t\t\t//" + dataStr + "\n";
	}
	csStr = csStr.replace("//parameter", parStr);

	//添加构造函数
	var corStr = heredoc(function(){/*
	public ConfClassName()
	{
	}

*/});
	corStr = replaceAll(corStr, "ConfClassName", "Conf" + name + "Item");
	
	corStr += "\tpublic " + "Conf" + name + "Item(";
	for(var i=0; i<data[0].length; i++)
	{
		corStr += data[2][i] + " " + data[1][i] + (i < data[0].length-1 ? ", " : "");
	}
	corStr += ")\n\t{\n";
	for(var i=0; i<data[0].length; i++)
	{
		corStr += "\t\tthis." + data[1][i] + " = " + data[1][i] + ";\n";
	}
	corStr += "\t}";
	csStr = csStr.replace("//constructor", corStr);

	//添加数据2
	var data2Str = "";
	var i = 3;
	var totalDataCount = 0;
	for (var initIndex=1; ; initIndex++)
	{
		var isComplete = true;
		data2Str += "\tprivate void Init" + initIndex + "()\n\t{\n";
		for(var curi=0; i<data.length && curi<1000; i++, curi++)
		{
			if (data[i][0] != null)
			{
				var tempStr = "\t\tallConfBase.Add(new " + "Conf" + name + "Item" + "(";
				totalDataCount++;

				for (var j=0; j<data[0].length; j++)
				{
					var type = data[2][j];
					var value = data[i][j];

					if (value == null || typeof(value) == "undefined")
					{
						if (data[0][j].indexOf("支持空字符串") != -1)
						{
							tempStr += '""';
						}
						else
						{
							tempStr += "undefined";
						}
					}
					else
					{
						if (type.indexOf("[][]") != -1)
						{
							tempStr += StringToArroy2(type, value);
						}
						else if (type.indexOf("[]") != -1)
						{
							tempStr += StringToArroy1(type, value);
						}
						else
						{
							if (type == "int")
							{
								tempStr += value;
							}
							else if (type == "string")
							{
								tempStr += '"' + value + '"';
							}
							else if (type == "float")
							{
								tempStr += value + "f";
							}
						}
					}

					if (j < data[0].length-1)
					{
						tempStr += ", ";
					}
				}
				data2Str += tempStr + "));\n";
			}
			else
			{
				isComplete = false;
				break;
			}
		}
		data2Str += "\t}\n";
		if (!isComplete || i >= data.length)
		{
			break;
		}
	}
	csStr = csStr.replace("//data2", data2Str.substring(0, data2Str.length-1));

	//导出数据1
	var data1Str = '\t\tconfName = "' + name + '";\n ';
	data1Str += "\t\tallConfBase = new List<ConfBaseItem>();\n";
	var startInitIndex = 1; 
	for (var i=0; i<totalDataCount; i+=1000)
	{
		data1Str += "\t\tInit" + startInitIndex + "();\n";
		startInitIndex++;
	}
	data1Str += heredoc(function(){/*
		 */});
	csStr = csStr.replace("//data1", data1Str.substring(0, data1Str.length-1));

	//处理只有Key Value的数据
	if (data[1].length == 3 && data[1][1] == "key" && data[1][2] == "value")
	{
		var type = data[2][2];
		csStr = csStr.replace("//keytovalueData", ExcelKeyAndValueCsStr(data));

		var funStr = heredoc(function(){/*
	public keytype GetItemValue(string key)
    {
        for (int i = 0; i < allConfList.Count; i++)
        {
			if (allConfList[i].key == key)
            {
				return allConfList[i].value;
            }
        }
		return null;
    }

    public bool ContainsItemKey(string key)
    {
        for (int i = 0; i < allConfList.Count; i++)
        {
            if (allConfList[i].key == key)
            {
                return true;
            }
        }
        return false;
    }
		 */});
		funStr = funStr.replace("keytype", data[2][2]);
		funStr = funStr.replace("return null", data[2][2].indexOf("[]") ? ("return default(" + data[2][2] + ")") : "return " + (data[2][2] == "string" ? "" : "0"));

		var typeStr = data[2][2];
		csStr = csStr.replace("//getItemInKey\r\n", funStr);
		var iType = (typeStr[0].toUpperCase() + typeStr.substring(1));
		iType = iType.replace("[][]", "Arr2");
		iType = iType.replace("[]", "Arr1");
		csStr = csStr.replace("Base : ConfBase", "Base : ConfBase, IContainsItemKey, IGetItemValue" + iType);
	}
	else
	{
		csStr = csStr.replace("//getItemInKey\r\n", "");
		csStr = csStr.replace("//keytovalueData\r\n", "");
	}

	//创建自定义类
	fs.exists(conf.csPath + "\\" + "Conf" + name + ".cs", function(exists){
		if(!exists){
			//替换类名
			csConfStr = replaceAll(csConfStr, "ConfClassNameBase", "Conf" + name + "Base");
			csConfStr = replaceAll(csConfStr, "ConfClassName", "Conf" + name);

			fs.writeFileSync(conf.csPath + "\\" + "Conf" + name + ".cs", csConfStr);
		}
	})

	return csStr;
}

function ExcelTableToCsMgrStr(files)
{
	var csStr = heredoc(function(){/*
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ConfMgr
{
    public class Data
    {
//classData
    }

    public Data data = new Data();
    public List<ConfBase> allConfBase = new List<ConfBase>();

    public System.Action onInitCall;
	
//class
    public void Init(System.Action call)
    {
		g.game.timer.Thread(()=> {
			Init();
			onInitCall?.Invoke();
			InitEnd();
		}, ()=> {
			OnInit();
			call();
		});
    }
	
	public void Init()
    {
//add

        for (int i = 0; i < allConfBase.Count; i++)
        {
            allConfBase[i].Init();
        }
    }
	
    public void InitEnd()
    {
        for (int i = 0; i < allConfBase.Count; i++)
        {
            allConfBase[i].InitEnd();
        }
    }
	
	public void OnInit()
	{
		for (int i = 0; i < allConfBase.Count; i++)
		{
			allConfBase[i].OnInit();
		}
	}
}
	 */});
	
	var classDataStr = "";
	var classStr = "";
	var addStr = "";

	for (var i=0; i<files.length; i++)
	{
		var name = files[i][0];
		var fileNmae=  files[i][1];
		
		var className = "Conf" + name;
		var varName = name.substring(0, 1).toLocaleLowerCase() + name.substring(1, name.length);
		classDataStr += "\t\tpublic " + className + " " + varName + " = new " + className + "();\n"
		classStr += "\tpublic " + className + " " + varName + " { get { data." + varName + ".onGetItemObjectHandler = null; return data." + varName + "; } }" + "\t\t//" + fileNmae + "\n"
		addStr += "\t\t" + "allConfBase.Add(" + varName + ");\n";
	}

	csStr = csStr.replace("//classData", classDataStr);
	csStr = csStr.replace("//class", classStr);
	csStr = csStr.replace("//add", addStr);

	csStr = replaceAll(csStr, "\n", "\r\n");
	csStr = replaceAll(csStr, "\r\r\n", "\r\n");

	fs.writeFileSync(conf.csMgrPath, csStr);
}

function ExcelTableToCsMgrVariantStr(files)
{
	var csStr = heredoc(function(){/*
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ConfMgrVariantBase
{
//class
    public virtual ReturnAction<ConfBaseItem, int> GetItemObjectHandler(ConfBase confBase)
    {
        return null;
    }
}
*/});
	
	var classStr = "";

	for (var i=0; i<files.length; i++)
	{
		var name = files[i][0];
		var fileNmae=  files[i][1];
		
		var className = "Conf" + name;
		var varName = name.substring(0, 1).toLocaleLowerCase() + name.substring(1, name.length);
		classStr += "\tpublic " + className + " " + varName + " { get { g.game.conf." + varName + ".onGetItemObjectHandler = GetItemObjectHandler(g.game.conf." + varName + "); return g.game.conf.data." + varName + "; } }\t\t//" + fileNmae + "\r\n";
	}

	csStr = csStr.replace("//class", classStr);

	fs.writeFileSync(conf.csMgrVariantPath, csStr);
}

//字符串转一维数组
function StringToArroy1(type, strValue, splitChar)
{
	splitChar = splitChar == null ? (strValue.indexOf("|") != -1 ? "|" : "_") : splitChar;
	
	if (strValue == "0")
	{
		return "new " + type + "{ }";
	}
	else
	{
		var strValues = strValue.split(splitChar);
		var csStr = "new " + type + "{ data }";
		var csDataStr = ValueStrToCsStr(type, strValues[0]);
		for(var i=1; i<strValues.length; i++)
		{
			csDataStr += ", " + ValueStrToCsStr(type, strValues[i]);
		}
		csStr = replaceAll(csStr, "data", csDataStr);
		
		return csStr;
	}
}

//字符串转二维数组
function StringToArroy2(type, strValue, splitChar1, splitChar2)
{
	splitChar1 = splitChar1 == null ? "|" : splitChar1;
	splitChar2 = splitChar2 == null ? "_" : splitChar2;
	
	if (strValue == "0")
	{
		return "new " + type + "{ }";
	}
	else
	{
		var strValues = strValue.split(splitChar1);
		var csStr = "new " + type + "{ data }";
		var csDataStr = StringToArroy1(replaceAll(type, "[][]", "[]"), strValues[0], splitChar2);
		for(var i=1; i<strValues.length; i++)
		{
			csDataStr += ", " + StringToArroy1(replaceAll(type, "[][]", "[]"), strValues[i], splitChar2);
		}
		csStr = replaceAll(csStr, "data", csDataStr);
		
		return csStr;
	}
}

//根据类型获取实际代码字符串
function ValueStrToCsStr(type, strValue)
{
	type = replaceAll(type, "[]", "");
	if (type == "string")
	{
		return '"' + strValue + '"';
	}
	else if (type == "int")
	{
		return strValue;
	}
	else if (type == "float")
	{
		return strValue + "f";
	}
	return "";
}

//额外增加key到value配置字段
function ExcelKeyAndValueCsStr(data)
{
	//添加数据
	var dataStr = '';
	for(var i=3; i<data.length; i++)
	{
		if (data[i][0] != null && data[i].length >= data[0].length)
		{
		    var type = data[2][2];
		    dataStr += "\t" + "public " + type + " " + data[i][1] + " { get { return GetItem(" + data[i][0] + ").value; } }\n";
		}
	}
	return dataStr;
}

function heredoc(fn) {
    return fn.toString().split('\n').slice(1,-1).join('\n') + '\n';
}


//替换所有字符串
function replaceAll(str, s1, s2) 
{
    var arr = str.split(s1);
    var afterName = "";
    for(var i=0; i<arr.length; i++){
        afterName += arr[i] + s2;
    }
    afterName = afterName.substring(0,afterName.length-s2.length);

    return afterName;
}

//读取MD5
function getFileMD5(filePath)
{
	var data = fs.readFileSync(filePath, {encoding: 'utf8'});
	var md5 = crypto.createHash('md5');
    md5.update(data);
    var md5Str = md5.digest('hex').toUpperCase();
    return md5Str;
}

//删除文件夹
function deleteFolder(path) {
    let files = [];
    if( fs.existsSync(path) ) {
        files = fs.readdirSync(path);
        files.forEach(function(file,index){
            let curPath = path + "/" + file;
            if(fs.statSync(curPath).isDirectory()) {
                deleteFolder(curPath);
            } else {
                fs.unlinkSync(curPath);
            }
        });
        fs.rmdirSync(path);
    }
}