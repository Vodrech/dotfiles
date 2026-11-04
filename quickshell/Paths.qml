pragma Singleton
import QtQuick
import Quickshell

// Where the bar keeps its data. Everything it saves goes in dataDir, outside the bar
// folder, so the bar files can be replaced or shared without the user's data.
Singleton {
    readonly property string dataDir: (Quickshell.env("XDG_DATA_HOME") || Quickshell.env("HOME") + "/.local/share") + "/quickshell-bar"

    function data(name: string): string {
        return dataDir + "/" + name;
    }
}
