import QtQuick
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM
import org.kde.kquickcontrols as KQuickControls
import org.kde.kcmutils as KCM

KCM.SimpleKCM {
    property var root
    property int index
    property var effectArgValues

KQuickControls.ColorButton {

    visible:root.effect_arguments.length>index
    Kirigami.FormData.label: visible?root.effect_arguments[index]["name"]+":":""

    showAlphaChannel:true

    color:visible?effectArgValues[index]:""

    id:btn

    onColorChanged:{
        effectArgValues[index]=btn.color
        root.cfg_effectArgTrigger=!root.cfg_effectArgTrigger
    }
  }
}
