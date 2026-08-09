// Switching to desktop 2 is held back until desk2-auth.service (password dialog) confirms the password
// by invoking the Desk2Unlocked shortcut; a wrong password or Cancel leaves you where you were.

let allowed = false;
let revertTo = null;

function desk2() {
    return workspace.desktops[1];
}

// Revert on the next event loop pass, not inside currentDesktopChanged: a nested switch reaches the
// later listeners (taskbar, pager) out of order and leaves them showing desktop 2 as current.
const revert = new QTimer();
revert.singleShot = true;
revert.interval = 0;
revert.timeout.connect(() => {
    workspace.currentDesktop = revertTo;
    callDBus("org.freedesktop.systemd1", "/org/freedesktop/systemd1", "org.freedesktop.systemd1.Manager",
        "StartUnit", "desk2-auth.service", "replace");
});

registerShortcut("Desk2Unlocked", "Desktop 2 lock: switch after password", "", () => {
    allowed = true;
    workspace.currentDesktop = desk2();
    // Give back the sound that knob-desk-focus muted on double Escape
    callDBus("org.freedesktop.systemd1", "/org/freedesktop/systemd1", "org.freedesktop.systemd1.Manager",
        "StartUnit", "desk-mute@unmute.service", "replace");
});

workspace.currentDesktopChanged.connect(previous => {
    if (workspace.currentDesktop !== desk2()) {
        return;
    }
    if (allowed) {
        allowed = false;
        return;
    }
    revertTo = previous;
    revert.start();
});
