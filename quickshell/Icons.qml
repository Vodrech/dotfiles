pragma Singleton
import QtQuick
import Quickshell

// Nerd Font (v3) glyphs, by code point so the source stays readable.
Singleton {
    readonly property string nixos: String.fromCodePoint(0xf313)
    readonly property string apps: String.fromCodePoint(0xf003b)
    readonly property string cpu: String.fromCodePoint(0xf061a)
    readonly property string memory: String.fromCodePoint(0xf035b)
    readonly property string clock: String.fromCodePoint(0xf0150)
    readonly property string calendar: String.fromCodePoint(0xf00ed)
    readonly property string chevronLeft: String.fromCodePoint(0xf0141)
    readonly property string close: String.fromCodePoint(0xf0156)
    readonly property string chevronRight: String.fromCodePoint(0xf0142)

    readonly property string volumeHigh: String.fromCodePoint(0xf057e)
    readonly property string volumeMedium: String.fromCodePoint(0xf0580)
    readonly property string volumeLow: String.fromCodePoint(0xf057f)
    readonly property string volumeOff: String.fromCodePoint(0xf0581)
    readonly property string speaker: String.fromCodePoint(0xf04c3)
    readonly property string microphone: String.fromCodePoint(0xf036c)
    readonly property string check: String.fromCodePoint(0xf012c)
    readonly property string keyboard: String.fromCodePoint(0xf030c)

    readonly property string ethernet: String.fromCodePoint(0xf0200)
    readonly property string disconnected: String.fromCodePoint(0xf0319)
    readonly property var wifi: [0xf092f, 0xf091f, 0xf0922, 0xf0925, 0xf0928].map(c => String.fromCodePoint(c))
}
