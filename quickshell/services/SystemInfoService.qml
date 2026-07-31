pragma Singleton
import QtQuick

QtObject {
	id: root

	property string hostname: "Loading..."
	property string kernal: "Loading..."

	function update(){
		hostname = "my-machine"
		kernal = "Linux"
	}

	Component.onCompleted: {
			update()
	}
}
