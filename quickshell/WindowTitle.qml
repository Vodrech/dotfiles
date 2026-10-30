import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

BarText {
    readonly property var toplevel: Hyprland.activeToplevel
    // Hide the title when the focused workspace is empty (activeToplevel lingers otherwise).
    readonly property bool onFocusedWorkspace: toplevel?.workspace?.id === Hyprland.focusedWorkspace?.id

    text: onFocusedWorkspace ? (toplevel?.title ?? "") : ""
    visible: text.length > 0
    color: Theme.subtext
    elide: Text.ElideRight
    Layout.maximumWidth: 360
}
