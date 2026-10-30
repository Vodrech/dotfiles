//@ pragma UseQApplication
import QtQuick
import Quickshell

ShellRoot {
    // One bar per monitor; bars are created/destroyed as monitors come and go.
    Variants {
        model: Quickshell.screens
        Bar {}
    }
}
