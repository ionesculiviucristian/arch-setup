function deskFocus() {
    const [desk1, desk2] = workspace.desktops;
    const windows = workspace.windowList().filter(w => w.normalWindow && !w.onAllDesktops);

    const onDesk2 = windows.filter(w => w.desktops.includes(desk2));
    onDesk2.forEach(w => { w.minimized = true; });

    // Mute the apps that live only on desktop 2: a process that also has a window on desktop 1
    // (one Firefox for both) plays through the same audio stream, so muting it would silence desktop 1 too.
    const desk1Pids = new Set(windows.filter(w => w.desktops.includes(desk1)).map(w => w.pid));
    const pids = [...new Set(onDesk2.map(w => w.pid))].filter(pid => pid > 0 && !desk1Pids.has(pid));
    if (pids.length) {
        callDBus("org.freedesktop.systemd1", "/org/freedesktop/systemd1", "org.freedesktop.systemd1.Manager",
            "StartUnit", `desk-mute@mute_${pids.join("_")}.service`, "replace");
    }

    workspace.currentDesktop = desk1;

    const firefox = windows.find(w => w.resourceClass === "firefox" && w.desktops.includes(desk1));
    if (firefox) {
        firefox.minimized = false;
        firefox.fullScreen = false;
        firefox.setMaximize(true, true);
        workspace.activeWindow = firefox;
    }
}

registerShortcut("KnobDeskFocus", "Desk focus: minimize desktop 2, go to desktop 1, Firefox maximized",
    "", deskFocus);
