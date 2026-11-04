pragma Singleton
import QtQuick
import Quickshell

// Catppuccin Mocha palette + layout constants. Tweak here to restyle everything.
Singleton {
    readonly property color base: "#E61E1E2E"     // ~90% opaque
    readonly property color popupBase: "#1e1e2e"  // opaque, so popups stay readable
    readonly property color mantle: "#181825"
    readonly property color crust: "#11111b"
    readonly property color surface0: "#313244"
    readonly property color surface1: "#45475a"
    readonly property color overlay0: "#6c7086"
    readonly property color subtext: "#a6adc8"
    readonly property color text: "#cdd6f4"

    readonly property color accent: "#cba6f7"     // mauve
    readonly property color blue: "#89b4fa"
    readonly property color sky: "#89dceb"
    readonly property color teal: "#94e2d5"
    readonly property color green: "#a6e3a1"
    readonly property color yellow: "#f9e2af"
    readonly property color peach: "#fab387"
    readonly property color red: "#f38ba8"
    readonly property color claude: "#d97757"     // Claude orange

    readonly property string font: "FiraCode Nerd Font"
    readonly property int fontSize: 13
    readonly property int iconSize: 16

    readonly property int barHeight: 30
    readonly property int barMargin: 0    // space between bar and screen edges
    readonly property int gap: 6          // space between bar and dropdowns
    readonly property int radius: 12
    readonly property int spacing: 14     // between modules inside an island
    readonly property int animMs: 200

    // Colour that shifts toward red as a 0..1 usage value rises.
    function usageColor(v: real): color {
        return v > 0.85 ? red : v > 0.6 ? peach : text;
    }
}
