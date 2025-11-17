this is my custom hyprland theme :) (i made the bar, theme inspired by nord theme, Nord theme repo here 
https://github.com/a-lebailly/nord-dotfiles/commits?author=a-lebailly)

all dependencies for this theme (Arch based system) - yay required

>
  <pre><code id="myCode">yay -S hyprland wayland wlroots xwayland hyprutils hyprcursor waybar lm_sensors gtk3 jq networkmanager network-manager-applet pipewire wireplumber pipewire-pulse pavucontrol ttf-cascadia-code ttf-nerd-fonts-symbols dunst libnotify hyprshot wl-clipboard kitty dolphin zenity
</code></pre>
</div>


all dependencies for debian based system first, run this command to add hyprland's repo (since hyprland repo isn't officially added)

>
  <pre><code id="myCode">curl -fsSL https://repo.hyprland.org/hyprland.gpg | sudo gpg --dearmor -o /usr/share/keyrings/hyprland.gpg

echo "deb [signed-by=/usr/share/keyrings/hyprland.gpg] https://repo.hyprland.org/apt/ ./" | sudo tee /etc/apt/sources.list.d/hyprland.list

sudo apt update
</code></pre>
</div>

then, install the dependencies, as required:

>
  <pre><code id="myCode">sudo apt install -y hyprland hyprutils hyprcursor waybar lm-sensors network-manager network-manager-gnome pipewire pipewire-audio wireplumber pavucontrol fonts-cascadia-code fonts-nerd-fonts dunst libnotify-bin wl-clipboard kitty dolphin grim slurp hyprshot jq zenity
</code></pre>
</div>


(of course there are some optional packages included, but you can always delete those later)

