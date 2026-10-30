pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Hyprland

// Hyprland actions in one place. Hyprland 0.56+ with a Lua config takes dispatches as
// Lua (`hl.dsp.*`), not the classic "workspace 3" strings, so Hyprland.dispatch() is
// passed Lua here. If you ever go back to a hyprland.conf, this is the file to change.
Singleton {
    function dispatch(lua: string) {
        Hyprland.dispatch(lua);
    }

    // Workspace id, or relative like "m+1" / "m-1" (next/previous on this monitor).
    function focusWorkspace(workspace) {
        dispatch(`hl.dsp.focus({ workspace = ${JSON.stringify(String(workspace))} })`);
    }

    function focusWindow(toplevel: HyprlandToplevel) {
        dispatch(`hl.dsp.focus({ window = "address:0x${toplevel.address.replace(/^0x/, "")}" })`);
    }

    // Ends the window's whole process: SIGTERM so it can shut down cleanly, then SIGKILL
    // if it's still running after 5 seconds. Needs lastIpcObject (call
    // Hyprland.refreshToplevels() beforehand); falls back to closing the window.
    function killWindowProcess(toplevel: HyprlandToplevel) {
        const pid = parseInt(toplevel.lastIpcObject?.pid);
        if (!(pid > 1)) {
            closeWindow(toplevel);
            return;
        }
        Quickshell.execDetached(["sh", "-c",
            `kill -TERM ${pid} || exit 0
             for i in 1 2 3 4 5; do sleep 1; kill -0 ${pid} 2>/dev/null || exit 0; done
             kill -KILL ${pid}`]);
    }

    // Asks the app to close (like clicking its close button), via the Wayland toplevel
    // protocol rather than a dispatch. Falls back to focusing it and closing the active window.
    function closeWindow(toplevel: HyprlandToplevel) {
        if (toplevel.wayland) {
            toplevel.wayland.close();
        } else {
            focusWindow(toplevel);
            dispatch("hl.dsp.window.close()");
        }
    }
}
