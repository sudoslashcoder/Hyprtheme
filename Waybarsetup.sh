#!/bin/bash
# Waybar setup – top dock with workspace icons, CPU, RAM, network, audio, battery, tray, and centered floating Zenity power menu
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
POWER_SCRIPT="$CONFIG_DIR/power_menu.sh"

mkdir -p "$CONFIG_DIR"

# Backup existing config
for f in "$WAYBAR_CONFIG" "$WAYBAR_STYLE" "$POWER_SCRIPT"; do
  [ -f "$f" ] && cp "$f" "$f.bak.$(date +%s)"
done

# --- POWER MENU SCRIPT (Zenity, centered) ---
cat > "$POWER_SCRIPT" <<'EOF'
#!/bin/bash
# Floating, semi-transparent, centered power menu using Zenity

ZENITY_TITLE="Power Menu"
ZENITY_WIDTH=250
ZENITY_HEIGHT=180

selection=$(zenity --list \
  --title="$ZENITY_TITLE" \
  --text="Select an action" \
  --column="Action" Shutdown Reboot Logout Lock Cancel \
  --width=$ZENITY_WIDTH \
  --height=$ZENITY_HEIGHT \
  --ok-label="Select" \
  --cancel-label="Cancel" \
  --timeout=10
)

case "$selection" in
    Shutdown) systemctl poweroff ;;
    Reboot) systemctl reboot ;;
    Logout) hyprctl dispatch exit ;;
    Lock) swaylock ;;
    Cancel|"") exit 0 ;;
esac
EOF
chmod +x "$POWER_SCRIPT"

# --- WAYBAR CONFIG ---
cat > "$WAYBAR_CONFIG" <<EOF
{
  "layer": "top",
  "position": "top",
  "margin": ${GAP},
  "spacing": 8,

  "modules-left": ["hyprland/workspaces", "custom/power"],
  "modules-center": ["clock"],
  "modules-right": ["cpu", "memory", "network", "pulseaudio", "battery", "tray"],

  "hyprland/workspaces": {
    "disable-scroll": false,
    "all-outputs": true,
    "format": "{icon}",
    "format-icons": {
      "1": "◉","2": "◉","3": "◉","4": "◉","5": "◉",
      "6": "◉","7": "◉","8": "◉","9": "◉","10": "◉"
    }
  },

  "clock": {
    "format": "{:%a %d %b  %H:%M}",
    "tooltip-format": "{:%Y-%m-%d %H:%M:%S}"
  },

  "cpu": {
    "format": "󰍛 {usage}%",
    "tooltip": "cat /proc/stat | awk 'NR>1 {print \"Core\" NR-1\": \"\$2+0 \"%\"\"}'",
    "tooltip-format": "{output}"
  },

  "memory": { "format": "󰍛 {used:0.1f}G", "tooltip": false },

  "pulseaudio": {
    "format": "{icon} {volume}%",
    "format-muted": "󰖁  Mute",
    "format-icons": { "default": ["󰕿","󰖀","󰕾"] },
    "on-click": "pavucontrol",
    "on-scroll-up": "pactl set-sink-volume @DEFAULT_SINK@ +2%",
    "on-scroll-down": "pactl set-sink-volume @DEFAULT_SINK@ -2%"
  },

  "network": {
    "format-wifi": "󰖩 {essid}",
    "format-ethernet": "󰈀 {ifname}",
    "format-disconnected": "󰤮",
    "tooltip-format": "{ifname}: {ipaddr}"
  },

  "battery": {
    "format": "{icon} {capacity}%",
    "format-icons": ["󰁺","󰁼","󰁾","󰂀","󰂂","󰁹"]
  },

  "custom/power": {
    "exec": "echo '󰚥'",
    "interval": 0,
    "tooltip": "Power Menu",
    "on-click": "$POWER_SCRIPT"
  }
}
EOF

# --- WAYBAR STYLE ---
cat > "$WAYBAR_STYLE" <<EOF
* { font-family: ${FONT}; font-size: 13px; color: #fff; min-height: 30px; border: none; }

window#waybar {
  background: rgba(${BG_COLOR}, ${BG_OPACITY});
  border-radius: ${RADIUS}px;
  margin: ${GAP}px;
  padding: 6px 12px;
}

#hyprland-workspaces { margin-left: 8px; }

#hyprland-workspaces button, #custom-power button {
  border-radius: 50%;
  padding: 6px; min-width: 26px; min-height: 26px;
  margin: 0 4px; background: rgba(255,255,255,0.08);
  border: 1px solid rgba(255,255,255,0);
  transition: background 0.15s, border-color 0.15s;
}

#hyprland-workspaces button.active { background: rgba(255,255,255,0.25); border-color: rgba(255,255,255,0.35); }
#hyprland-workspaces button:hover, #custom-power button:hover { background: rgba(255,255,255,0.18); border-color: rgba(255,255,255,0.22); }

#cpu, #memory, #network, #pulseaudio, #battery, #tray, #clock, #custom-power {
  margin: 0 8px; color: #ffffff;
}

#modules-right { margin-right: ${RIGHT_MARGIN}px; }
EOF

# --- HYPRLAND FLOATING RULES ---
HYPR_CONF="$HOME/.config/hypr/hyprland.conf"

if ! grep -q "Power Menu" "$HYPR_CONF"; then
cat >> "$HYPR_CONF" <<'EOF'

# Floating centered semi-transparent Power Menu
windowrulev2 = float, title:Power Menu
windowrulev2 = opacity:0.85, title:Power Menu
windowrulev2 = center, title:Power Menu
EOF
fi

# Reload Hyprland config to apply rules
hyprctl reload

# --- Restart Waybar ---
pkill waybar || true
sleep 0.5
waybar &

echo "✅ Waybar setup complete! Centered, floating, semi-transparent Zenity power menu ready."
