// https://develop.kde.org/docs/plasma/scripting/api/
// https://invent.kde.org/plasma/plasma-workspace/-/tree/master/shell/scripting?ref_type=heads

var panels = panelIds;
for (var i = 0; i < panels.length; i++) {
  var p = panelById(panels[i]);
  if (p) {
    p.remove();
  }
}

var panel = new Panel();

panel.alignment = "center";
panel.floating = false;
panel.height = 40;
panel.hiding = "none";
panel.lengthMode = "fill";
panel.location = "bottom";
panel.opacity = "translucent";

panel.addWidget("org.kde.plasma.kickoff"); // Application Launcher
panel.addWidget("org.kde.plasma.taskmanager"); // Task Manager
panel.addWidget("org.kde.plasma.pager"); // Virtual Desktops
panel.addWidget("org.kde.plasma.systemtray"); // System Tray
panel.addWidget("org.kde.plasma.digitalclock"); // Digital Clock

var wallpaperPath =
  "file://" +
  userDataPath() +
  "/Pictures/Wallpapers/wp14259050-cyberpunk-3440x1440-wallpapers.png";

var allDesktops = desktops();
for (var i = 0; i < allDesktops.length; i++) {
  var d = allDesktops[i];
  d.wallpaperPlugin = "org.kde.image";
  d.currentConfigGroup = ["Wallpaper", "org.kde.image", "General"];
  d.writeConfig("Image", wallpaperPath);
  d.reloadConfig();
}
