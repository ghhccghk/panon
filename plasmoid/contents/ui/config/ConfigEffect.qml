import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2

import org.kde.plasma.plasma5support as Plasma5Support
import org.kde.kcmutils as KCM
import org.kde.kirigami  as Kirigami
import org.kde.plasma.core as PlasmaCore
import org.kde.newstuff as NewStuff

import "utils.js" as Utils
KCM.SimpleKCM {

    property string cfg_visualEffect

    property var cfg_effectArgValues:[]
    property bool cfg_effectArgTrigger:false

  Kirigami.FormLayout {
    id:root

    anchors.right: parent.right
    anchors.left: parent.lef

    NewStuff.Button {
        downloadNewWhat: i18n("Effects")
        configFile: Utils.get_root() + "/config/panon.knsrc"
        onChangedEntriesChanged:{
            /*
             * Triggers the executable DataSource to execute this line again: 
             * if(shaderOptions.count<1)return[sh_get_visual_effects]
             * So that the list model shaderOptions will be refreshed.
             */
            shaderOptions.clear()
        }
    }

    RowLayout {
        Kirigami.FormData.label: i18n("Effect:")
        Layout.fillWidth: true

        QQC2.ComboBox {
            id:visualeffect
            model: ListModel {
                id: shaderOptions
            }
            textRole: 'name'
            onCurrentIndexChanged:cfg_visualEffect= shaderOptions.get(currentIndex).id
        }
    }

    RowLayout {
        Kirigami.FormData.label: i18n("Hint:")
        Layout.fillWidth: true
        visible:hint.text.length>0
        QQC2.Label {
            id:hint
            text:''
            onLinkActivated: Qt.openUrlExternally(link)
        }
    }


    readonly property string sh_get_visual_effects:Utils.chdir_scripts_root()+'python3 -m panon.effect.get_effect_list'

    readonly property string sh_read_effect_hint:Utils.chdir_scripts_root()+'python3 -m panon.effect.read_file "'+cfg_visualEffect+'" hint.html'
    readonly property string sh_read_effect_args:Utils.chdir_scripts_root()+'python3 -m panon.effect.read_file "'+cfg_visualEffect+'" meta.json'

    onCfg_visualEffectChanged:{
        hint.text=''
        effect_arguments=[]
    }
    property bool firstTimeLoadArgs:true
    property var effect_arguments:[]

     
    Plasma5Support.DataSource {
        engine: 'executable'
        connectedSources: {
            // Load visual effects when shaderOptions is empty.
            if(shaderOptions.count<1)return[sh_get_visual_effects]

            // Load hint.html and meta.json
            if(!cfg_visualEffect.endsWith('.frag'))
                return[sh_read_effect_hint,sh_read_effect_args]

            return []
        }

        // Text field components used to represent the arguments of the visual effect.
        property var textfieldlst:[]
        
        onNewData: {
            if(sourceName==sh_read_effect_hint){
                hint.text=(data.stdout)
            }else if(sourceName==sh_read_effect_args){
                if(data.stdout.length>0){
                    effect_arguments=JSON.parse(data.stdout)['arguments']
                    //while(textfieldlst.length>0)textfieldlst.pop().destroy() 
                    textfieldlst.map(function(o){o.visible=false})
                    for(var index=0;index<effect_arguments.length;index++){
                        var arg=effect_arguments[index]
                        if(!firstTimeLoadArgs)
                            cfg_effectArgValues[index]=arg['default']
                        
                        var component
                        if(arg['type'])
                            component= Qt.createComponent({
                                "int":"EffectArgumentInt.qml",
                                "double":"EffectArgumentDouble.qml",
                                "float":"EffectArgumentDouble.qml",
                                "bool":"EffectArgumentBool.qml",
                                "color":"EffectArgumentColor.qml",
                            }[arg["type"]]);
                        else
                            component= Qt.createComponent("EffectArgument.qml");
                        var obj= component.createObject(root, {
                            index:index,
                            root:root,
                            effectArgValues:cfg_effectArgValues,
                        });
                            
                        textfieldlst.push(obj)
                    }
                }
                firstTimeLoadArgs=false
            }else if(sourceName==sh_get_visual_effects){
                var lst=JSON.parse(data.stdout)
                for(var i in lst)
                    shaderOptions.append(lst[i])
                var ci;
                // Set a default effect.
                for(var i=0;i<lst.length;i++)
                    if(shaderOptions.get(i).name=='default')
                        ci=i;
                // Search for the effect identity cfg_visualEffect
                for(var i=0;i<lst.length;i++)
                    if(shaderOptions.get(i).id==cfg_visualEffect)
                        ci=i;
                visualeffect.currentIndex=ci;
            }
        }
    }
  }
}
