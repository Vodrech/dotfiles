// Playerctl Service for displaying what is playing
pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Services.Mpris

QtObject {
    id: root

    // The currently active player object
    readonly property var activePlayer: findActivePlayer()

    // Formatted strings ready for the UI
    readonly property string trackTitle: activePlayer ? (activePlayer.trackTitle || "Unknown Track") : ""
    readonly property string trackArtist: {
        if (!activePlayer || !activePlayer.trackArtists) return "";
        return activePlayer.trackArtists.join(", ");
    }
    readonly property string displayLabel: {
        if (!activePlayer) return "No Media";
        if (!trackTitle) return activePlayer.identity || "Playing...";
        return trackArtist ? `${trackTitle} • ${trackArtist}` : trackTitle;
    }

    // Playback state helpers
    readonly property bool hasMedia: activePlayer !== null
    readonly property bool isPlaying: activePlayer ? (activePlayer.playbackState === MprisPlaybackState.Playing) : false

    // --- Media Controls API ---

    function togglePlayPause() {
        if (activePlayer) activePlayer.togglePlaying();
    }

    function nextTrack() {
        if (activePlayer && activePlayer.canGoNext) activePlayer.next();
    }

    function previousTrack() {
        if (activePlayer && activePlayer.canGoPrevious) activePlayer.previous();
    }

    // --- Internal Logic ---

    // Finds a playing player first, falls back to the first available player
    function findActivePlayer() {
        let players = Mpris.players.values;
        if (!players || players.length === 0) return null;

        // 1. Look for any player currently playing audio
        for (let i = 0; i < players.length; i++) {
            if (players[i].playbackState === MprisPlaybackState.Playing) {
                return players[i];
            }
        }

        // 2. Fall back to the first player in the list
        return players[0];
    }
}
