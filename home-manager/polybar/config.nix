{
  "bar/top" = {
    monitor = "\${env:MONITOR:HDMI-0}";
    width = "100%";
    height = "3$";
    radius = 0;
    modules-center = "date";
  };

  "module/date" = {
    type = "internal/date";
    internal = 5;
    date = "%d.%m.%y";
    time = "%H:%M";
    label = "%time% %date%";
  };
}
