import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

// CPU and RAM usage, sampled from /proc every 2 seconds.
RowLayout {
    id: root
    spacing: Theme.spacing

    property real cpu: 0
    property real mem: 0
    property real _lastTotal: 0
    property real _lastIdle: 0

    function parse(out: string) {
        const lines = out.trim().split("\n");

        // "cpu user nice system idle iowait irq softirq steal ..."
        const f = lines[0].trim().split(/\s+/).slice(1, 9).map(Number);
        const idle = f[3] + f[4];
        const total = f.reduce((a, b) => a + b, 0);
        if (_lastTotal > 0 && total > _lastTotal)
            cpu = 1 - (idle - _lastIdle) / (total - _lastTotal);
        _lastTotal = total;
        _lastIdle = idle;

        const kb = {};
        for (const l of lines.slice(1)) {
            const [k, v] = l.split(/:\s+/);
            kb[k] = parseInt(v);
        }
        if (kb.MemTotal > 0)
            mem = 1 - kb.MemAvailable / kb.MemTotal;
    }

    Process {
        id: proc
        command: ["sh", "-c", "head -n1 /proc/stat; grep -E '^(MemTotal|MemAvailable):' /proc/meminfo"]
        stdout: StdioCollector { onStreamFinished: root.parse(text) }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: proc.running = true
    }

    RowLayout {
        spacing: 6
        Icon { text: Icons.cpu; color: Theme.blue }
        BarText {
            text: Math.round(root.cpu * 100) + "%"
            color: Theme.usageColor(root.cpu)
            Layout.minimumWidth: 32
        }
    }

    RowLayout {
        spacing: 6
        Icon { text: Icons.memory; color: Theme.green }
        BarText {
            text: Math.round(root.mem * 100) + "%"
            color: Theme.usageColor(root.mem)
            Layout.minimumWidth: 32
        }
    }
}
