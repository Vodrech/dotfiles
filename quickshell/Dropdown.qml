import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland

// Panel that drops down under the bar. Put content inside it and set implicitWidth /
// implicitHeight. Closes on outside click, focus loss, workspace/monitor switch, Escape.
//
// What it takes to make this work on Hyprland:
// - A layer-shell window, not a PopupWindow: popups inherit the bar's "no keyboard"
//   setting, so text fields in them can't be typed into.
// - Keyboard focus OnDemand, not Exclusive: an exclusive surface never loses focus,
//   so clicking elsewhere couldn't close it.
// - The focus grab lists only this window (adding the bar blocks keyboard input), and
//   is enabled shortly after opening: if it activates before the window is mapped,
//   clicks inside count as "outside".
PanelWindow {
    id: root
    required property PanelWindow bar
    // Bar item to line up under. Null = centred horizontally.
    property Item anchorItem: null
    default property alias content: background.data
    signal opened()

    property real _closedAt: 0
    property real _left: 0

    function open() {
        if (anchorItem) {
            const x = Theme.barMargin + anchorItem.mapToItem(bar.contentItem, 0, 0).x - Theme.spacing;
            _left = Math.max(Theme.gap, Math.min(x, screen.width - implicitWidth - Theme.gap));
        }
        visible = true;
    }

    function close() {
        visible = false;
    }

    // For the bar button. Clicking it while open first clears the focus grab (which
    // closes the dropdown); don't let that same click reopen it.
    function toggle() {
        if (visible)
            close();
        else if (Date.now() - _closedAt > 300)
            open();
    }

    visible: false
    screen: bar.screen
    color: "transparent"

    anchors.top: true
    anchors.left: anchorItem !== null
    margins.top: Theme.barMargin + Theme.barHeight + Theme.gap
    margins.left: _left
    exclusionMode: ExclusionMode.Ignore

    WlrLayershell.namespace: "quickshell-dropdown"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

    onVisibleChanged: {
        if (visible) {
            grabDelay.restart();
            background.forceActiveFocus();
            opened();
        } else {
            grab.active = false;
            background.hadFocus = false;
        }
    }

    HyprlandFocusGrab {
        id: grab
        windows: [root]
        onCleared: {
            root._closedAt = Date.now();
            root.close();
        }
    }

    Timer {
        id: grabDelay
        interval: 50
        onTriggered: grab.active = root.visible
    }

    Connections {
        target: Hyprland
        enabled: root.visible
        function onFocusedWorkspaceChanged() { root.close(); }
        function onFocusedMonitorChanged() { root.close(); }
    }

    Rectangle {
        id: background
        property bool hadFocus: false

        anchors.fill: parent
        radius: Theme.radius
        color: Theme.popupBase
        border.width: 1
        border.color: Theme.surface0

        focus: true
        Keys.onEscapePressed: root.close()

        // Close when the dropdown loses keyboard focus after having had it.
        Window.onActiveChanged: {
            if (Window.active)
                hadFocus = true;
            else if (hadFocus)
                root.close();
        }
    }
}
