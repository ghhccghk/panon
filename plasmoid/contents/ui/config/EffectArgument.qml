import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.kcmutils as KCM

import org.kde.kirigami as Kirigami
KCM.SimpleKCM {
    property var root
    property int index
    property var effectArgValues

    property var vali:null

  RowLayout {
    Kirigami.FormData.label: visible?root.effect_arguments[index]["name"]+":":""
    visible:root.effect_arguments.length>index
    QQC2.TextField {
        text:visible? effectArgValues[index]:""
        onTextChanged:{
            effectArgValues[index]=text
            root.cfg_effectArgTrigger=!root.cfg_effectArgTrigger
        }
        validator:vali
    }
  }
}
