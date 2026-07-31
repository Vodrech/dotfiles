pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Hyprland

QtObject {
    readonly property var workspaces: Hyprland.workspaces.values
    readonly property var activeWorkspace: Hyprland.focusedWorkspace

    function switchTo(id) {
        Hyprland.dispatch("hl.dsp.focus({ workspace = " + id + " })")
    }

    function isActive(id) {
        return activeWorkspace && activeWorkspace.id === id
    }
}
