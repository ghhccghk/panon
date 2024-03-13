import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2

import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    property var root
    property int index
    property var effectArgValues

  QQC2.CheckBox {

    visible:root.effect_arguments.length>index
    text: visible?root.effect_arguments[index]["name"]:""
    checked:visible?(effectArgValues[index]=="true"):false

    onCheckedChanged:{
        effectArgValues[index]=checked
        root.cfg_effectArgTrigger=!root.cfg_effectArgTrigger
    }
  }
}
