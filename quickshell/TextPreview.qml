import QtQuick
import QtQuick.Layouts
import Qt.labs.folderlistmodel
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

// Text file previewer. Browse folders (starting at home, showing only .md and .txt files),
// type a path, or pick a pinned / recent file. Then select text and press Ctrl+C, click a
// line number to copy that line, or copy the whole file.
// Ctrl+F finds, Ctrl+L focuses the path field. The preview follows changes to the file.
Item {
    id: root
    required property PanelWindow bar

    // Files always offered as chips, e.g. ["~/notes.txt", "~/todo.md"].
    readonly property var pinned: []
    readonly property int maxRecent: 6
    // Bigger files are cut off, so the preview stays responsive.
    readonly property int maxChars: 200000
    // File types the folder browser lists. Typed paths can open any file.
    readonly property var nameFilters: ["*.md", "*.txt"]

    readonly property string home: Quickshell.env("HOME")
    property string path: ""
    property string dir: home          // folder shown in the browser
    readonly property var dirParts: dir.split("/").filter(s => s.length > 0)
    readonly property string content: file.loaded ? file.text() : ""
    // Without the final newline, which would otherwise show as an extra empty line.
    readonly property string shown: (content.length > maxChars ? content.slice(0, maxChars) : content).replace(/\n$/, "")
    readonly property int lineCount: shown.length === 0 ? 0 : shown.split("\n").length
    property string error: ""
    property string toast: ""

    function expand(p: string): string {
        p = p.trim();
        return p === "~" ? home : p.startsWith("~/") ? home + p.slice(1) : p;
    }

    function pretty(p: string): string {
        return p.startsWith(home + "/") ? "~" + p.slice(home.length) : p;
    }

    function parentOf(p: string): string {
        return p.replace(/\/[^\/]*$/, "") || "/";
    }

    function fileUrl(p: string): string {
        return "file://" + p.split("/").map(encodeURIComponent).join("/");
    }

    function openFile(p: string) {
        const full = expand(p);
        if (full === "")
            return;
        error = "";
        path = full;
        pathField.text = pretty(full);
    }

    // Only files that opened go in the recent list; ones that fail to open are dropped.
    function setRecent(recent: var) {
        if (JSON.stringify(recent) === JSON.stringify(state.recent))
            return;
        state.recent = recent;
        stateFile.writeAdapter();
    }

    function copy(text: string, what: string) {
        if (text.length === 0)
            return;
        Quickshell.clipboardText = text;
        toast = "Copied " + what;
        toastTimer.restart();
    }

    function findNext() {
        const needle = findField.text;
        if (needle.length === 0)
            return;
        const hay = shown.toLowerCase(), n = needle.toLowerCase();
        let at = hay.indexOf(n, viewer.selectionEnd);
        if (at < 0)
            at = hay.indexOf(n);       // wrap around
        if (at < 0) {
            findField.invalid = true;
            return;
        }
        findField.invalid = false;
        viewer.select(at, at + needle.length);
        flick.ensureVisible(viewer.positionToRectangle(at));
    }

    implicitWidth: icon.implicitWidth
    implicitHeight: icon.implicitHeight

    Icon {
        id: icon
        text: Icons.fileText
        color: mouse.containsMouse || menu.visible ? Theme.accent : Theme.teal
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        anchors.margins: -4
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: menu.toggle()
    }

    FileView {
        id: file
        path: root.path
        watchChanges: true
        onFileChanged: reload()
        printErrors: false
        onLoaded: {
            root.error = "";
            root.dir = root.parentOf(root.path);
            root.setRecent([root.path, ...state.recent.filter(r => r !== root.path)].slice(0, root.maxRecent));
        }
        onLoadFailed: err => {
            root.setRecent(state.recent.filter(r => r !== root.path));
            if (err === FileViewError.NotAFile) {    // a folder: browse it instead
                root.dir = root.path;
                root.path = "";
                root.error = "";
                return;
            }
            root.error = err === FileViewError.FileNotFound ? "File not found"
                       : err === FileViewError.PermissionDenied ? "Permission denied"
                       : err === FileViewError.NotAFile ? "Not a file"
                       : "Could not read file";
        }
    }

    // Recently opened files, kept between restarts.
    FileView {
        id: stateFile
        path: Paths.data("text-preview.json")
        printErrors: false

        JsonAdapter {
            id: state
            property var recent: []
        }
    }

    Timer {
        id: toastTimer
        interval: 1500
        onTriggered: root.toast = ""
    }

    Dropdown {
        id: menu
        bar: root.bar
        anchorItem: root
        implicitWidth: 940
        implicitHeight: 540
        WlrLayershell.namespace: "quickshell-text-preview"

        onOpened: {
            if (root.path === "")
                pathField.input.forceActiveFocus();
            else
                viewer.forceActiveFocus();
        }

        Shortcut {
            sequence: "Ctrl+F"
            enabled: menu.visible
            onActivated: { findField.input.forceActiveFocus(); findField.input.selectAll(); }
        }
        Shortcut {
            sequence: "Ctrl+L"
            enabled: menu.visible
            onActivated: { pathField.input.forceActiveFocus(); pathField.input.selectAll(); }
        }

        ColumnLayout {
            anchors { fill: parent; margins: 12 }
            spacing: 8

            RowLayout {
                Layout.fillWidth: true
                spacing: 6

                Field {
                    id: pathField
                    Layout.fillWidth: true
                    placeholder: "Path to a file or folder, e.g. ~/notes.txt"
                    invalid: root.error !== ""
                    onAccepted: root.openFile(text)
                    onEscaped: menu.close()
                }

                IconButton {
                    text: Icons.openExternal
                    visible: root.path !== "" && root.error === ""
                    onClicked: {
                        Quickshell.execDetached(["xdg-open", root.path]);
                        menu.close();
                    }
                }
            }

            // Pinned and recent files.
            Flow {
                Layout.fillWidth: true
                spacing: 4
                visible: chips.count > 0

                Repeater {
                    id: chips
                    model: [...root.pinned.map(p => root.expand(p)),
                            ...state.recent.filter(r => !root.pinned.map(p => root.expand(p)).includes(r))]

                    delegate: Rectangle {
                        id: chip
                        required property string modelData
                        readonly property bool current: modelData === root.path

                        implicitWidth: chipText.implicitWidth + 16
                        implicitHeight: 24
                        radius: 6
                        color: current ? Theme.surface1 : chipMouse.containsMouse ? Theme.surface0 : Theme.mantle
                        Behavior on color { ColorAnimation { duration: Theme.animMs / 2 } }

                        BarText {
                            id: chipText
                            anchors.centerIn: parent
                            text: chip.modelData.split("/").pop()
                            color: chip.current ? Theme.accent : Theme.subtext
                            font.pixelSize: Theme.fontSize - 2
                        }

                        MouseArea {
                            id: chipMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.openFile(chip.modelData)
                        }
                    }
                }
            }

            // Where the browser is. Click a part of the path to go to that folder.
            RowLayout {
                Layout.fillWidth: true
                spacing: 2

                IconButton {
                    text: Icons.arrowUp
                    enabled: root.dir !== "/"
                    opacity: enabled ? 1 : 0.4
                    onClicked: root.dir = root.parentOf(root.dir)
                }
                IconButton {
                    text: Icons.home
                    onClicked: root.dir = root.home
                }

                Item {
                    Layout.fillWidth: true
                    Layout.leftMargin: 4
                    implicitHeight: crumbs.implicitHeight
                    clip: true

                    Row {
                        id: crumbs
                        // A long path keeps its end in view.
                        x: Math.min(0, parent.width - width)
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 2

                        Repeater {
                            model: ["/", ...root.dirParts]

                            delegate: Row {
                                id: crumb
                                required property string modelData
                                required property int index
                                readonly property bool last: index === root.dirParts.length
                                spacing: 2

                                Icon {
                                    visible: crumb.index > 1
                                    anchors.verticalCenter: parent.verticalCenter
                                    text: Icons.chevronRight
                                    color: Theme.overlay0
                                    font.pixelSize: Theme.iconSize - 2
                                }

                                Rectangle {
                                    implicitWidth: crumbText.implicitWidth + 12
                                    implicitHeight: 24
                                    radius: 6
                                    color: crumbMouse.containsMouse && !crumb.last ? Theme.surface0 : "transparent"
                                    Behavior on color { ColorAnimation { duration: Theme.animMs / 2 } }

                                    BarText {
                                        id: crumbText
                                        anchors.centerIn: parent
                                        text: crumb.modelData
                                        color: crumb.last ? Theme.accent : crumbMouse.containsMouse ? Theme.text : Theme.subtext
                                        font.bold: crumb.last
                                        font.pixelSize: Theme.fontSize - 1
                                    }

                                    MouseArea {
                                        id: crumbMouse
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: crumb.last ? Qt.ArrowCursor : Qt.PointingHandCursor
                                        onClicked: root.dir = "/" + root.dirParts.slice(0, crumb.index).join("/")
                                    }
                                }
                            }
                        }
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 8

                // Folder browser.
                Rectangle {
                    Layout.preferredWidth: 250
                    Layout.fillHeight: true
                    radius: 8
                    color: Theme.mantle
                    border.width: 1
                    border.color: Theme.surface0
                    clip: true

                    ColumnLayout {
                        anchors { fill: parent; margins: 6 }
                        spacing: 4

                        ListView {
                            id: browser
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            clip: true
                            boundsBehavior: Flickable.StopAtBounds
                            spacing: 1

                            model: FolderListModel {
                                id: folderModel
                                folder: root.fileUrl(root.dir)
                                nameFilters: root.nameFilters
                                caseSensitive: false
                                showDirsFirst: true
                                showDotAndDotDot: false
                                sortCaseSensitive: false
                            }

                            delegate: Rectangle {
                                id: entry
                                required property string fileName
                                required property string filePath
                                required property bool fileIsDir
                                readonly property bool current: filePath === root.path

                                width: ListView.view.width
                                height: 26
                                radius: 6
                                color: current ? Theme.surface1 : entryMouse.containsMouse ? Theme.surface0 : "transparent"
                                Behavior on color { ColorAnimation { duration: Theme.animMs / 2 } }

                                RowLayout {
                                    anchors { fill: parent; leftMargin: 8; rightMargin: 8 }
                                    spacing: 8

                                    Icon {
                                        text: entry.fileIsDir ? Icons.folder
                                            : entry.fileName.toLowerCase().endsWith(".md") ? Icons.markdown
                                            : Icons.fileText
                                        color: entry.fileIsDir ? Theme.blue : entry.current ? Theme.accent : Theme.subtext
                                        font.pixelSize: Theme.iconSize - 2
                                    }
                                    BarText {
                                        Layout.fillWidth: true
                                        text: entry.fileName
                                        color: entry.current ? Theme.accent : Theme.text
                                        font.pixelSize: Theme.fontSize - 1
                                        elide: Text.ElideRight
                                    }
                                }

                                MouseArea {
                                    id: entryMouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        if (entry.fileIsDir)
                                            root.dir = entry.filePath;
                                        else
                                            root.openFile(entry.filePath);
                                    }
                                }
                            }

                            BarText {
                                anchors.centerIn: parent
                                visible: browser.count === 0 && folderModel.status === FolderListModel.Ready
                                text: "No folders or text files"
                                color: Theme.overlay0
                                font.pixelSize: Theme.fontSize - 1
                            }
                        }
                    }
                }

                // The file itself.
                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    radius: 8
                    color: Theme.mantle
                    border.width: 1
                    border.color: Theme.surface0
                    clip: true

                    BarText {
                        anchors.centerIn: parent
                        visible: root.path === "" || root.error !== "" || root.lineCount === 0
                        text: root.path === "" ? "Pick a file to preview it" : root.error !== "" ? root.error : "Empty file"
                        color: root.error !== "" ? Theme.red : Theme.overlay0
                    }

                    Flickable {
                        id: flick
                        anchors { fill: parent; margins: 1 }
                        visible: root.lineCount > 0
                        contentWidth: gutter.width + viewer.contentWidth + 20
                        contentHeight: viewer.contentHeight + 16
                        boundsBehavior: Flickable.StopAtBounds
                        clip: true

                        function ensureVisible(r: rect) {
                            const x = r.x + viewer.x, y = r.y + viewer.y;
                            if (y < contentY)
                                contentY = y - 8;
                            else if (y + r.height > contentY + height)
                                contentY = y + r.height - height + 8;
                            if (x < contentX + gutter.width)
                                contentX = Math.max(0, x - gutter.width - 8);
                            else if (x > contentX + width)
                                contentX = x - width + 24;
                        }

                        // Line numbers. Click one to copy that line.
                        Rectangle {
                            id: gutter
                            x: flick.contentX       // stays put when scrolling sideways
                            z: 1
                            width: numbers.implicitWidth + 20
                            height: Math.max(flick.height, flick.contentHeight)
                            color: Theme.mantle

                            Text {
                                id: numbers
                                x: 10
                                y: viewer.y
                                horizontalAlignment: Text.AlignRight
                                width: implicitWidth
                                text: Array.from({ length: root.lineCount }, (_, i) => i + 1).join("\n")
                                font: viewer.font
                                color: Theme.overlay0
                            }

                            Rectangle {
                                anchors.right: parent.right
                                width: 1
                                height: parent.height
                                color: Theme.surface0
                            }

                            Rectangle {
                                id: lineHover
                                readonly property real lineHeight: root.lineCount > 0 ? numbers.contentHeight / root.lineCount : 0
                                property int line: -1
                                visible: gutterMouse.containsMouse && line >= 0 && line < root.lineCount
                                y: viewer.y + line * lineHeight
                                width: flick.width
                                height: lineHeight
                                color: Theme.accent
                                opacity: 0.12
                            }

                            MouseArea {
                                id: gutterMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onPositionChanged: mouse => lineHover.line = Math.floor((mouse.y - viewer.y) / lineHover.lineHeight)
                                onClicked: {
                                    const n = lineHover.line;
                                    if (n >= 0 && n < root.lineCount)
                                        root.copy(root.shown.split("\n")[n], "line " + (n + 1));
                                }
                            }
                        }

                        TextEdit {
                            id: viewer
                            x: gutter.width + 10
                            y: 8
                            text: root.shown
                            textFormat: TextEdit.PlainText
                            readOnly: true
                            selectByMouse: true
                            persistentSelection: true
                            wrapMode: TextEdit.NoWrap
                            color: Theme.text
                            selectionColor: Theme.accent
                            selectedTextColor: Theme.crust
                            font.family: Theme.font
                            font.pixelSize: Theme.fontSize
                            Keys.onEscapePressed: menu.close()
                            onCursorRectangleChanged: if (activeFocus) flick.ensureVisible(cursorRectangle)
                        }

                        WheelHandler {
                            acceptedModifiers: Qt.ShiftModifier
                            onWheel: e => flick.contentX = Math.max(0, Math.min(flick.contentWidth - flick.width,
                                                                               flick.contentX - e.angleDelta.y))
                        }
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 6

                Field {
                    id: findField
                    Layout.preferredWidth: 200
                    placeholder: "Find (Enter for next)"
                    onTextChanged: invalid = false
                    onAccepted: root.findNext()
                    onEscaped: viewer.forceActiveFocus()
                }

                BarText {
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                    text: root.toast !== "" ? root.toast
                        : root.lineCount === 0 ? ""
                        : root.lineCount + " lines" + (root.content.length > root.maxChars ? " (truncated)" : "")
                          + (viewer.selectedText.length > 0 ? " · " + viewer.selectedText.length + " selected" : "")
                    color: root.toast !== "" ? Theme.green : Theme.overlay0
                    font.pixelSize: Theme.fontSize - 1
                }

                ActionButton {
                    label: "Copy selection"
                    enabled: viewer.selectedText.length > 0
                    onClicked: root.copy(viewer.selectedText, "selection")
                }
                ActionButton {
                    label: "Copy all"
                    enabled: root.content.length > 0
                    onClicked: root.copy(root.content, "file")
                }
            }
        }
    }

    component ActionButton: Rectangle {
        id: btn
        property string label
        signal clicked()

        implicitWidth: btnRow.implicitWidth + 20
        implicitHeight: 30
        radius: 8
        opacity: enabled ? 1 : 0.4
        color: btnMouse.pressed ? Theme.surface1 : btnMouse.containsMouse ? Theme.surface0 : Theme.mantle
        border.width: 1
        border.color: Theme.surface0
        Behavior on color { ColorAnimation { duration: Theme.animMs / 2 } }

        RowLayout {
            id: btnRow
            anchors.centerIn: parent
            spacing: 6
            Icon {
                text: Icons.copy
                font.pixelSize: Theme.iconSize - 2
                color: btnMouse.containsMouse ? Theme.accent : Theme.subtext
            }
            BarText {
                text: btn.label
                font.pixelSize: Theme.fontSize - 1
            }
        }

        MouseArea {
            id: btnMouse
            anchors.fill: parent
            enabled: btn.enabled
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: btn.clicked()
        }
    }
}
