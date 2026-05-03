function mark(markName) {
	if (window.performance && performance.mark) {
		performance.mark(markName);
	}
}

rumapi.incrementOnLoadEndMarkers();
mark('3rdpartyloadstart');

function libraryLoaded() {
	window.librariesToLoad--;
	if (window.librariesToLoad == 0) {
		mark('3rdpartyloadend');
		window.performance && performance.measure && performance.measure('measure_social_bar_loadtime', '3rdpartyloadstart', '3rdpartyloadend');
		rumapi.signalOnLoadEnd();
	}
}