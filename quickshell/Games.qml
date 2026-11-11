import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets

// Gamepad button: dropdown of installed Lutris games, most recently played first.
// Folder chips pick a Lutris category; type to filter, Up/Down to pick, Enter or click to launch.
Item {
    id: root
    required property PanelWindow bar

    readonly property string lutrisData: (Quickshell.env("XDG_DATA_HOME") || Quickshell.env("HOME") + "/.local/share") + "/lutris"

    property var games: []
    // Slugs that have a banner file, so missing ones aren't requested (and logged as errors).
    property var banners: ({})
    property bool loaded: false

    // Lutris categories (set with right-click > Categories in Lutris), read from its
    // database. gameCategories maps a game id to the names of its categories.
    property var categories: []
    property var gameCategories: ({})
    // Selected category; "" shows all games. Kept while the bar runs.
    property string category: ""

    function inCategory(game, name) {
        return (gameCategories[game.id] ?? []).includes(name);
    }

    readonly property var visibleGames: games.filter(g => !inCategory(g, ".hidden"))
    readonly property var filtered: {
        const q = search.text.trim().toLowerCase();
        return visibleGames.filter(g =>
            (!category || inCategory(g, category)) && (!q || g.name.toLowerCase().includes(q)));
    }

    function launch(game) {
        Quickshell.execDetached(["lutris", "lutris:rungameid/" + game.id]);
        menu.close();
    }

    function formatPlaytime(seconds) {
        if (!(seconds > 0))
            return "Never played";
        const h = Math.floor(seconds / 3600);
        return h > 0 ? `${h} h played` : `${Math.max(1, Math.round(seconds / 60))} min played`;
    }

    function formatLastPlayed(text) {
        if (!text)
            return "";
        const then = new Date(text.replace(" ", "T"));
        const days = Math.floor((new Date().setHours(0, 0, 0, 0) - new Date(then).setHours(0, 0, 0, 0)) / 86400000);
        return days <= 0 ? "today" : days === 1 ? "yesterday" : days < 30 ? `${days} days ago` : then.toLocaleDateString(Qt.locale(), "d MMM yyyy");
    }

    // Reloaded each time the dropdown opens; the previous list stays visible meanwhile.
    Process {
        id: lister
        command: ["lutris", "--list-games", "--installed", "--json"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const list = JSON.parse(text.slice(text.indexOf("[")));
                    list.sort((a, b) => (b.lastplayed || "").localeCompare(a.lastplayed || "") || a.name.localeCompare(b.name));
                    root.games = list;
                } catch (e) {
                    console.warn("Games: couldn't read the Lutris game list:", e);
                }
                root.loaded = true;
            }
        }
    }

    Process {
        id: bannerLister
        command: ["ls", root.lutrisData + "/banners"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const found = {};
                for (const name of text.split("\n"))
                    if (name.endsWith(".jpg"))
                        found[name.slice(0, -4)] = true;
                root.banners = found;
            }
        }
    }

    // Lutris has no CLI option for categories, so read them from its database (read-only).
    Process {
        id: categoryLister
        command: ["python3", "-c", `
import json, sqlite3, sys
db = sqlite3.connect("file:" + sys.argv[1] + "?mode=ro", uri=True)
names = [r[0] for r in db.execute("SELECT name FROM categories ORDER BY name COLLATE NOCASE")]
games = {}
for game, name in db.execute("SELECT gc.game_id, c.name FROM games_categories gc JOIN categories c ON c.id = gc.category_id"):
    games.setdefault(str(game), []).append(name)
print(json.dumps({"categories": names, "games": games}))
`, root.lutrisData + "/pga.db"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const data = JSON.parse(text);
                    root.categories = data.categories.filter(c => c !== ".hidden");
                    root.gameCategories = data.games;
                    if (!root.categories.includes(root.category))
                        root.category = "";
                } catch (e) {
                    console.warn("Games: couldn't read Lutris categories:", e);
                }
            }
        }
    }

    implicitWidth: icon.implicitWidth
    implicitHeight: icon.implicitHeight

    Icon {
        id: icon
        text: Icons.gamepad
        color: mouse.containsMouse || menu.visible ? Theme.accent : Theme.text
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        anchors.margins: -4
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: menu.toggle()
    }

    Dropdown {
        id: menu
        bar: root.bar
        anchorItem: root
        implicitWidth: 380
        implicitHeight: content.implicitHeight + 24
        WlrLayershell.namespace: "quickshell-games"
        onOpened: {
            search.text = "";
            list.currentIndex = 0;
            search.input.forceActiveFocus();
            list.positionViewAtBeginning();
            if (!lister.running)
                lister.running = true;
            if (!bannerLister.running)
                bannerLister.running = true;
            if (!categoryLister.running)
                categoryLister.running = true;
        }

        ColumnLayout {
            id: content
            anchors { fill: parent; margins: 12 }
            spacing: 8

            BarText {
                text: "Games"
                color: Theme.accent
                font.bold: true
                Layout.leftMargin: 6
            }

            // Category chips: "All", then each Lutris category.
            Flow {
                Layout.fillWidth: true
                spacing: 4
                visible: root.categories.length > 0

                Repeater {
                    model: [""].concat(root.categories)

                    delegate: Rectangle {
                        id: chip
                        required property string modelData
                        readonly property bool selected: root.category === modelData
                        readonly property int count: modelData
                            ? root.visibleGames.filter(g => root.inCategory(g, modelData)).length
                            : root.visibleGames.length

                        implicitWidth: chipRow.implicitWidth + 16
                        implicitHeight: 26
                        radius: 8
                        color: selected ? Theme.accent : chipMouse.containsMouse ? Theme.surface1 : Theme.surface0
                        Behavior on color { ColorAnimation { duration: Theme.animMs / 2 } }

                        RowLayout {
                            id: chipRow
                            anchors.centerIn: parent
                            spacing: 6
                            Icon {
                                text: chip.modelData ? Icons.folder : Icons.gamepad
                                color: chip.selected ? Theme.crust : Theme.subtext
                                font.pixelSize: Theme.iconSize - 2
                            }
                            BarText {
                                text: chip.modelData || "All"
                                color: chip.selected ? Theme.crust : Theme.text
                                font.pixelSize: Theme.fontSize - 1
                                font.bold: chip.selected
                            }
                            BarText {
                                text: chip.count
                                color: chip.selected ? Theme.crust : Theme.overlay0
                                font.pixelSize: Theme.fontSize - 2
                            }
                        }

                        MouseArea {
                            id: chipMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                root.category = chip.modelData;
                                list.currentIndex = 0;
                                list.positionViewAtBeginning();
                                search.input.forceActiveFocus();
                            }
                        }
                    }
                }
            }

            Field {
                id: search
                Layout.fillWidth: true
                placeholder: "Search games"
                onTextChanged: {
                    list.currentIndex = 0;
                    list.positionViewAtBeginning();
                }
                onAccepted: {
                    const game = root.filtered[list.currentIndex];
                    if (game)
                        root.launch(game);
                }
                onEscaped: menu.close()
                input.Keys.onDownPressed: list.currentIndex = Math.min(list.currentIndex + 1, list.count - 1)
                input.Keys.onUpPressed: list.currentIndex = Math.max(list.currentIndex - 1, 0)
            }

            BarText {
                visible: list.count === 0
                text: !root.loaded ? "Loading…"
                    : root.visibleGames.length === 0 ? "No Lutris games installed"
                    : search.text.trim() ? "No matches"
                    : `No games in ${root.category}`
                color: Theme.overlay0
                Layout.leftMargin: 6
            }

            ListView {
                id: list
                Layout.fillWidth: true
                implicitHeight: Math.min(contentHeight, 440)
                visible: count > 0
                clip: true
                spacing: 2
                boundsBehavior: Flickable.StopAtBounds
                highlightMoveDuration: 0
                model: root.filtered
                onCurrentIndexChanged: positionViewAtIndex(currentIndex, ListView.Contain)

                delegate: Rectangle {
                    id: entry
                    required property var modelData
                    required property int index

                    // Lutris's own icon if it made one, then its banner, then its cover art, otherwise a letter.
                    readonly property string iconSource: Quickshell.iconPath("lutris_" + modelData.slug, true)
                        || (root.banners[modelData.slug] ? "file://" + root.lutrisData + "/banners/" + modelData.slug + ".jpg" : "")
                        || (modelData.coverPath ? "file://" + modelData.coverPath : "")
                    readonly property bool selected: ListView.isCurrentItem

                    width: ListView.view.width
                    implicitHeight: 44
                    radius: 8
                    color: rowMouse.pressed ? Theme.surface1 : rowMouse.containsMouse || selected ? Theme.surface0 : "transparent"

                    MouseArea {
                        id: rowMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.launch(entry.modelData)
                    }

                    RowLayout {
                        anchors { fill: parent; leftMargin: 8; rightMargin: 8 }
                        spacing: 10

                        Rectangle {
                            implicitWidth: 28
                            implicitHeight: 28
                            radius: 6
                            color: Theme.surface1

                            BarText {
                                anchors.centerIn: parent
                                visible: art.status !== Image.Ready
                                text: entry.modelData.name.charAt(0).toUpperCase()
                                font.bold: true
                            }

                            ClippingRectangle {
                                anchors.fill: parent
                                radius: parent.radius
                                color: "transparent"
                                Image {
                                    id: art
                                    anchors.fill: parent
                                    source: entry.iconSource
                                    asynchronous: true
                                    fillMode: Image.PreserveAspectCrop
                                    sourceSize.height: 56
                                    visible: status === Image.Ready
                                }
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 0
                            BarText {
                                Layout.fillWidth: true
                                text: entry.modelData.name
                                font.bold: true
                                elide: Text.ElideRight
                            }
                            BarText {
                                Layout.fillWidth: true
                                text: [root.formatPlaytime(entry.modelData.playtimeSeconds), root.formatLastPlayed(entry.modelData.lastplayed)].filter(s => s).join(" · ")
                                color: Theme.subtext
                                font.pixelSize: Theme.fontSize - 2
                                elide: Text.ElideRight
                            }
                        }

                        // Runner badge (wine, linux, steam, ...)
                        Rectangle {
                            implicitWidth: runnerLabel.implicitWidth + 10
                            implicitHeight: 20
                            radius: 6
                            color: Theme.surface0
                            visible: !!entry.modelData.runner
                            BarText {
                                id: runnerLabel
                                anchors.centerIn: parent
                                text: entry.modelData.runner ?? ""
                                color: Theme.subtext
                                font.pixelSize: Theme.fontSize - 2
                            }
                        }
                    }
                }
            }
        }
    }
}
