import jinja2
import os
import json
import datetime
import collections
import re
from mod_pbxproj import XcodeProject

scriptDir = os.path.dirname(os.path.realpath(__file__))

with open(os.path.join("Components", "components.json")) as f:
    components = json.loads(f.read())

with open(os.path.join("Components", "Settings", "templateSettings.json")) as f:
    templateSettings = json.loads(f.read())

with open(os.path.join("Components", "Settings", "appSettings.json")) as f:
    appSettings = json.loads(f.read())


prefix = appSettings["prefix"]
project = XcodeProject.Load('%s.xcodeproj/project.pbxproj' % (appSettings["projectName"],))
project.backup()

jinjaEnvironment = jinja2.Environment(trim_blocks=True, extensions=["jinja2.ext.do"])


def GetDefaultDict():
    today = datetime.date.today()
    return {
        "projectName": appSettings["projectName"],
        "createdByName": appSettings["createdByName"],
        "currentDate": "%02d/%02d/%d" % (today.month, today.day, today.year),
        "currentYear": str(today.year),
        "companyName": appSettings["companyName"],
    }


def EnsureDir(filename):
    dirname = os.path.dirname(filename)
    if not os.path.exists(dirname):
        os.makedirs(dirname)

def Generate(templates, toPath, info, overwrite):
    templates = templateSettings[templates]
    toPath = templateSettings[toPath]

    finalInfo = GetDefaultDict()
    finalInfo.update(info)

    outputfilepathTemplate = jinjaEnvironment.from_string(toPath)
    outputfilepath = os.path.normpath(outputfilepathTemplate.render(finalInfo))

    for templateFilePath in templates["files"]:
        outputfilename = finalInfo[templates["filename"]] + os.path.splitext(templateFilePath)[1]

        realTemplateFilename = os.path.join(scriptDir, templateFilePath)

        with open(realTemplateFilename) as f:
            fileTemplate = jinjaEnvironment.from_string(f.read())

        finalInfo["fileName"] = outputfilename

        finalOutputFilename = os.path.join(outputfilepath, outputfilename)
        EnsureDir(finalOutputFilename)

        if overwrite or not os.path.exists(finalOutputFilename):
            with open(finalOutputFilename, "w") as f:
                f.write(fileTemplate.render(finalInfo))

        currentGroup = None
        outputfilepathInProject = "." + outputfilepath
        pathComponents = outputfilepathInProject.split(os.sep)
        for pathComponent in pathComponents:
            currentGroup = project.get_or_create_group(pathComponent, parent=currentGroup)
        project.add_file_if_doesnt_exist(finalOutputFilename, currentGroup)


def ToUpperCase(inStr):
    return inStr[0].upper() + inStr[1:]

def ToLowerCase(inStr):
    return inStr[0].lower() + inStr[1:]

def ToCamelCase(inStr):
    s1 = re.sub('(.)([A-Z][a-z]+)', r'\1_\2', inStr)
    return re.sub('([a-z0-9])([A-Z])', r'\1_\2', s1).lower()

controllers = []

for controllerDict in components.get("controllers", []):
    name = controllerDict["name"]
    defaultController = controllerDict.get("defaultController", None)

    newController = dict(controllerDict)
    newController["uppercaseName"] = ToUpperCase(name)
    newController["lowercaseName"] = ToLowerCase(name)
    newController["className"] = prefix + newController["uppercaseName"] + "ViewController"
    newController["defaultController"] = defaultController
    controllers.append(newController)

    if defaultController is None:
        Generate("controllerClassTemplates", "controllerClassFileLocation", newController, False)
        Generate("controllerXibTemplates", "controllerXibFileLocation", newController, False)
    else:
        Generate("controllerSectionTemplates", "controllerClassFileLocation", newController, False)
        Generate("controllerSectionXibTemplates", "controllerXibFileLocation", newController, False)


controllersInfo = {
    "className": prefix+"Controllers",
    "controllers": controllers
}

Generate("controllersFileTemplates", "controllersListFileLocation", controllersInfo, True)


for d in components.get("popups", []):
    name = d["name"]
    d["uppercaseName"] = ToUpperCase(name)
    d["lowercaseName"] = ToLowerCase(name)
    d["className"] = prefix + d["uppercaseName"] + "Popup"
    d["xibName"] = d["uppercaseName"] + "Popup"

    Generate("popupClassTemplates", "popupClassFileLocation", d, False)
    Generate("popupXibTemplates", "popupXibFileLocation", d, False)

for d in components.get("dataSources", []):
    name = d["name"]
    d["uppercaseName"] = ToUpperCase(name)
    d["lowercaseName"] = ToLowerCase(name)
    d["className"] = prefix + d["uppercaseName"] + "DataSource"

    cellTypes = [{
        "dataSource": d,
        "uppercaseName": ToUpperCase(cellName),
        "lowercaseName": ToLowerCase(cellName),
        "xibName": ToUpperCase(cellName) + "TableViewCell",
        "className": prefix + cellName[0].upper() + cellName[1:] + "TableViewCell"
    }
    for cellName in d.get("cells", [name])]

    d["cellTypes"] = cellTypes
    Generate("dataSourceClassTemplates", "dataSourceClassFileLocation", d, False)

    for cellDict in cellTypes:
        Generate("dataSourceCellClassTemplates", "dataSourceCellClassFileLocation", cellDict, False)
        Generate("dataSourceCellXibTemplates", "dataSourceCellXibFileLocation", cellDict, False)

for groupName, models in components.get("models", {}).iteritems():
    for model in models:
        modelName = model["name"]

        d = {
            "groupName": groupName,
            "name": modelName,
            "uppercaseName": ToUpperCase(modelName),
            "lowercaseName": ToLowerCase(modelName),
            "className": prefix + ToUpperCase(modelName),
            "fields": collections.defaultdict(list),
        }

        for field in model.get("fields", []):
            if "jsonFieldName" not in field:
                field["jsonFieldName"] = ToCamelCase(field["name"])
            if "referenceModel" in field:
                field["referenceModelClass"] = prefix + ToUpperCase(field["referenceModel"])
            if "readonly" not in field:
                field["readonly"] = True
            d["fields"][field["type"]].append(field)

        Generate("modelClassTemplates", "modelClassFileLocation", d, False)

project.save(sort=True)