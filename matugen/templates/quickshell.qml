pragma Singleton
import QtQuick

QtObject {
    property color background: "{{colors.surface.default.hex}}"
    property color surface: "{{colors.surface_container.default.hex}}"
    property color primary: "{{colors.primary.default.hex}}"
    property color text: "{{colors.on_surface.default.hex}}"
}
