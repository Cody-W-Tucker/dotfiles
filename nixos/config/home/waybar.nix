{ config, pkgs, lib, ... }:

# Create a reusable function to create a bar (since I want to duplicate the bar for each monitor)
let
  createBar = waybarConfig: output: position: waybarConfig // { output = output; position = position; };
  waybarConfig = {
    layer = "top";
    reload_style_on_change = true;
    output = "DP-1";
    spacing = 4;
    modules-center = [ "clock" ];
    modules-left = [ "hyprland/workspaces" ];
    modules-right = [
      "bluetooth"
      "pulseaudio"
      "cpu"
      "memory"
      "temperature"
      "group/group-power"
    ];
    "hyprland/workspaces" = {
      on-click = "activate";
      format = "{}";
      on-scroll-up = "hyprctl dispatch workspace e+1";
      on-scroll-down = "hyprctl dispatch workspace e-1";
    };
    clock = {
      format = "{:%m/%d/%Y - %I:%M %p}";
      on-click-right = "exec google-chrome-stable --app=https://calendar.google.com/calendar/u/0/r";
    };
    cpu = {
      format = "{usage}% ";
      tooltip = false;
    };
    memory = {
      format = "{}% ";
    };
    temperature = {
      critical-threshold = 80;
      thermal-zone = 2;
      hwmon-path = "/sys/devices/platform/coretemp.0/hwmon/hwmon4/temp1_input";
      format = "{temperatureC}°C ";
    };
    bluetooth = {
      format = " {status}";
      format-connected = " {num_connections} connected";
      tooltip-format = "{controller_alias}\t{controller_address}";
      tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{device_enumerate}";
      tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
      on-click = "exec bluetoothSwitch";
    };
    pulseaudio = {
      format = "{volume}% {icon} {format_source}";
      format-bluetooth = "{volume}% {icon} {format_source}";
      format-bluetooth-muted = " {icon} {format_source}";
      format-muted = " {format_source}";
      format-source = "{volume}% ";
      format-source-muted = "";
      format-icons = {
        headphone = "";
        hands-free = "";
        headset = "";
        phone = "";
        portable = "";
        car = "";
        default = [ "" "" "" ];
      };
      on-click = "pavucontrol";
    };
    "hyprland/window" = {
      max-length = 200;
      separate-outputs = true;
    };
    "group/group-power" = {
      orientation = "inherit";
      drawer = {
        transition-duration = 500;
        children-class = "not-power";
        transition-left-to-right = false;
      };
      modules = [
        "custom/power"
        "custom/quit"
        "custom/lock"
        "custom/reboot"
      ];
    };
    "custom/quit" = {
      format = "󰗼";
      tooltip = true;
      tooltip-format = "Quit";
      on-click = "hyprctl dispatch exit";
    };
    "custom/lock" = {
      format = "󰍁";
      tooltip-format = "Lock";
      tooltip = true;
      on-click = "hyprlock";
    };
    "custom/reboot" = {
      format = "󰜉";
      tooltip-format = "Reboot";
      tooltip = true;
      on-click = "reboot";
    };
    "custom/power" = {
      format = "";
      tooltip-format = "Shutdown";
      tooltip = false;
      on-click = "shutdown now";
    };
  };

in
{
  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      target = "hyprland-session.target";
    };
    settings = {
      # Duplicate the bars for each monitor
      monitor1 = createBar waybarConfig "DP-1" "top";
      monitor2 = createBar waybarConfig "DP-2" "bottom";
    };
    style = ''
      @import '../../.cache/wal/colors-waybar.css';

      * {
        /* `otf-font-awesome` is required to be installed for icons */
        font-family: FontAwesome, Roboto, Helvetica, Arial, sans-serif;
        font-size: 15px;
      }

      window#waybar {
        background: rgba(0, 0, 0, 0);
        color: @theme_text_color;
        transition-property: background-color;
        transition-duration: 0.5s;
        transition-timing-function: ease;
      }

      window#waybar.hidden {
        opacity: 0.2;
      }

      #workspaces button {
        padding: 0 5px;
        background-color: transparent;
        color: #ffffff;
      }

      #workspaces button:hover {
        background: rgba(0, 0, 0, 0.2);
      }

      #workspaces button.focused {
        background-color: #64727d;
        box-shadow: inset 0 -3px #ffffff;
      }

      #workspaces button.urgent {
        background-color: #eb4d4b;
      }

      #mode {
        background-color: #64727d;
        border-bottom: 3px solid #ffffff;
      }

      #clock,
      #battery,
      #cpu,
      #memory,
      #disk,
      #temperature,
      #backlight,
      #network,
      #pulseaudio,
      #wireplumber,
      #custom-media,
      #tray,
      #mode,
      #idle_inhibitor,
      #scratchpad,
      #mpd,
      #custom-power,
      #custom-quit,
      #custom-lock,
      #custom-reboot {
        padding: 0 10px;
        color: #ffffff;
      }

      #window,
      #workspaces {
        margin: 0 4px;
      }

      /* If workspaces is the leftmost module, omit left margin */
      .modules-left > widget:first-child > #workspaces {
        margin-left: 0;
      }

      /* If workspaces is the rightmost module, omit right margin */
      .modules-right > widget:last-child > #workspaces {
        margin-right: 0;
      }

      @keyframes blink {
        to {
          background-color: #ffffff;
          color: #000000;
        }
      }

      label:focus {
        background-color: #000000;
      }

      #cpu,
      #memory,
      #disk,
      #pulseaudio,
      #pulseaudio.muted,
      #wireplumber,
      #wireplumber.muted,
      #temperature,
      #clock,
      #workspaces,
      #bluetooth {
        padding: 5px 10px;
        border: 1px solid @foreground;
        box-shadow: 0px 2px 5px rgba(0, 0, 0, 0.15);
        background-color: @background;
        color: @theme_text_color;
      }

      window.DP-1 * {
        border-radius: 0 0 10px 10px;
        border-top-style: none;
      }

      window.DP-2 * {
        border-radius: 10px 10px 0 0;
        border-bottom-style: none;
      }

      #idle_inhibitor {
        background-color: #2d3436;
      }

      #idle_inhibitor.activated {
        background-color: #ecf0f1;
        color: #2d3436;
      }

      #scratchpad {
        background: rgba(0, 0, 0, 0.2);
      }

      #scratchpad.empty {
        background-color: transparent;
      }

      #privacy {
        padding: 0;
      }

      #privacy-item {
        padding: 0 5px;
        color: white;
      }

      #privacy-item.screenshare {
        background-color: #cf5700;
      }

      #privacy-item.audio-in {
        background-color: #1ca000;
      }

      #privacy-item.audio-out {
        background-color: #0069d4;
      }

      #custom-power,
      #custom-quit,
      #custom-lock,
      #custom-reboot {
        font-size: large;
      }
    '';
  };
}
