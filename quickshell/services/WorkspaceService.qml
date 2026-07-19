pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Hyprland

QtObject {
    readonly property var workspaces: Hyprland.workspaces
    readonly property var activeWorkspace: Hyprland.focusedWorkspace

    function switchTo(id) {
        for (const ws of workspaces) {
            if (ws.id === id) {
                ws.activate()
                return
            }
        }
    }

    function isActive(id) {
        return activeWorkspace && activeWorkspace.id === id
    }
}
