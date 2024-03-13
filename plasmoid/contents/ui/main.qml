import QtQuick
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore

PlasmoidItem {

    readonly property var cfg:plasmoid.configuration

    preferredRepresentation: compactRepresentation

    compactRepresentation: Spectrum{}

    toolTipItem: cfg.hideTooltip?tooltipitem:null

/*    backgroundHints: Types.DefaultBackground | Types.ConfigurableBackground
*/
    Item{id:tooltipitem}

}
