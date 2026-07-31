import QtQuick
import Quickshell.Networking

pragma Singleton

QtObject {
    id: root

		function status(){
			console.log("Networking Module")
			console.log(Object.keys(Networking.checkConnectivity))
			console.log(Networking.wifi)
		}
}

