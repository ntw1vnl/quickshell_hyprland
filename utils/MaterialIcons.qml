pragma Singleton

import Quickshell

Singleton {
    id: root

    function getVolumeIcon(volume: real, isMuted: bool): string {
        if (isMuted)
            return "no_sound";
        if (volume >= 0.5)
            return "volume_up";
        if (volume > 0)
            return "volume_down";
        return "no_sound";
    }

    function fromDesktopIconId(id: string): string {
        if (id == "audio-headset") {
            return "headset_mic";
        } else if (id == "input-gaming") {
            return "stadia_controller";
        }
        return "";
    }
}
