printf "α alpha\nβ beta\nγ gamma\nδ delta\nε epsilon\nθ theta\nλ lambda\nπ pi\nσ sigma\nω omega\nΑ Alpha\nΓ Gamma\nΔ Delta\nΠ Pi\nΣ Sigma\nΩ Omega\n" \
| rofi -dmenu -i -p "Greek" \
| awk '{print $1}' \
| tee >(wl-copy) \
| wtype -
