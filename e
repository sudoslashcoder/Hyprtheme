#!/bin/bash
# Waybar setup + Weather-on-hover Clock (Hyprland)
# Arch Hyprland, GTK-compatible

set -euo pipefail

# === CUSTOMIZATION ===
GAP=5
RADIUS=10
BG_OPACITY=0.5
BG_COLOR="15,15,20"
RIGHT_MARGIN=25
FONT='"CaskaydiaCove Nerd Font", "Ubuntu Nerd Font", sans-serif'

CONFIG_DIR="$HOME/.config/waybar"
WAYBAR_CONFIG="$CONFIG_DIR/config"
WAYBAR_STYLE="$CONFIG_DIR/style.css"

mkdir -p "$CONFIG_DIR"

# --- WAYBAR CONFIG ---
cat > "$WAYBAR_CONFIG" <<'EOF'
{
  "layer": "top",
  "position": "top",
  "margin": 5,
  "spacing": 8,

  "modules-left": [
    "custom/launcher",
    "hyprland/workspaces"
  ],

  "modules-center": ["custom/clock"],

  "modules-right": ["cpu", "memory", "network", "pulseaudio", "battery", "tray","custom/power"],

  "hyprland/workspaces": {
    "disable-scroll": false,
    "all-outputs": true,
    "format": "{icon}",
    "format-icons": {
      "1": "◉","2": "◉","3": "◉","4": "◉","5": "◉",
      "6": "◉","7": "◉","8": "◉","9": "◉","10": "◉"
    }
  },

  "custom/clock": {
    "exec": "echo \"{ \\\"text\\\": \\\"$(date +'%a %d %b %H:%M')\\\" }\"",
    "interval": 1,
    "return-type": "json",
    "format": "{}",
    "tooltip-format": "{}"
  },

  "cpu": {
    "format": "󰍛 {usage}%"
  },

  "memory": {
    "format": "󰍛 {used:0.1f}G",
    "interval": 1
  },

  "pulseaudio": {
    "format": "{icon} {volume}%",
    "format-muted": "󰖁 Mute",
    "format-icons": { "default": ["󰕿","󰖀","󰕾"] },
    "on-click": "pavucontrol",
    "on-scroll-up": "pactl set-sink-volume @DEFAULT_SINK@ +2%",
    "on-scroll-down": "pactl set-sink-volume @DEFAULT_SINK@ -2%"
  },

  "battery": {
    "format": "{icon} {capacity}%",
    "format-icons": ["󰁺","󰁼","󰁾","󰂀","󰂂","󰁹"]
  },

  "network": {
    "format-wifi": "󰖩 {essid}",
    "format-ethernet": "󰈀 {ifname}",
    "format-disconnected": "󰤮",
    "tooltip-format": "{ifname}: {ipaddr}"
  },

  "custom/launcher": {
    "exec": "echo '   '",
    "interval": 0,
    "tooltip": "Launcher",
    "on-click": "rofi -show drun -theme ~/.config/rofi/config.rasi"
  },

  "custom/power": {
    "exec": "echo '⏻  '",
    "interval": 0,
    "tooltip": "Launcher",
    "on-click": "wlogout"
  }
}
EOF

# --- WAYBAR STYLE ---
cat > "$WAYBAR_STYLE" <<EOF
* {
  font-family: ${FONT};
  font-size: 13px;
  color: #fff;
  min-height: 30px;
  border: none;
}

window#waybar {
  background: rgba(${BG_COLOR}, ${BG_OPACITY});
  border-radius: ${RADIUS}px;
  margin: ${GAP}px;
  padding: 6px 12px;
}

#hyprland-workspaces {
  margin-left: 8px;
}

#hyprland-workspaces button,
#custom-simplenote button,
#custom-mousepad button {
  border-radius: 50%;
  padding: 6px;
  min-width: 26px;
  min-height: 26px;
  margin: 0 4px;
  background: rgba(255,255,255,0.08);
  border: 1px solid rgba(255,255,255,0);
  transition: background 0.15s, border-color 0.15s;
}

#hyprland-workspaces button.active {
  background: rgba(255,255,255,0.25);
  border-color: rgba(255,255,255,0.35);
}

#hyprland-workspaces button:hover,
#custom-simplenote button:hover,
#custom-mousepad button:hover {
  background: rgba(255,255,255,0.18);
  border-color: rgba(255,255,255,0.22);
}

#cpu, #memory, #network, #pulseaudio, #battery, #tray,
#custom-simplenote, #custom-mousepad {
  margin: 0 8px;
  color: #ffffff;
}

#modules-right {
  margin-right: ${RIGHT_MARGIN}px;
}
EOF

# Reload Hyprland config
hyprctl reload

# Restart Waybar
pkill waybar || true
sleep 0.5
waybar &
