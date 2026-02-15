#!/usr/bin/env bash

# Map numbers 1-10 to Kanji
declare -A kanji_map=(
	[1]="󰬺" [2]="󰬻" [3]="󰬼" [4]="󰬽" [5]="󰬾"
	[6]="󰬿" [7]="󰭀" [8]="󰭁" [9]="󰭂" [10]="󰿩"
)

ws() {
	local persistent=(1 2 3 4 5 6)
	local output=""

	# Fetch data once
	workspace_data=$(hyprctl workspaces -j)
	current_workspace=$(hyprctl activeworkspace -j | jq -r '.id')

	# Get all workspace IDs (sorted)
	mapfile -t all_ws_ids < <(echo "$workspace_data" | jq -r '.[].id' | sort -n)

	# Workspaces to show: persistent + active/dynamic with windows
	declare -A show_ws=()
	for wsid in "${persistent[@]}"; do
		show_ws[$wsid]=1
	done
	for wsid in "${all_ws_ids[@]}"; do
		[[ " ${persistent[*]} " == *" $wsid "* ]] && continue
		windows=$(echo "$workspace_data" | jq -r --argjson id "$wsid" '[.[] | select(.id == $id)] | .[0]?.windows // 0')
		[[ "$current_workspace" == "$wsid" || "$windows" -gt 0 ]] && show_ws[$wsid]=1
	done

	# Sort and filter workspaces to show (skip negatives)
	mapfile -t ws_to_show < <(printf "%s\n" "${!show_ws[@]}" | sort -n | grep -E '^[1-9][0-9]*$')

	# Helper to get CSS class
	get_class() {
		local wsid=$1 windows=$2
		if [[ "$current_workspace" == "$wsid" ]]; then
			echo "workspace-active"
		elif [[ " ${persistent[*]} " == *" $wsid "* ]]; then
			[[ "$windows" -gt 0 ]] && echo "workspace" || echo "workspace-empty"
		elif [[ "$windows" -gt 0 ]]; then
			echo "workspace"
		fi
	}

	# Build output
	for wsid in "${ws_to_show[@]}"; do
		windows=$(echo "$workspace_data" | jq -r --argjson id "$wsid" '[.[] | select(.id == $id)] | .[0]?.windows // 0')
		label=$([[ "$wsid" -ge 1 && "$wsid" -le 10 ]] && echo "${kanji_map[$wsid]}" || echo "$wsid")
		cls=$(get_class "$wsid" "$windows")
		[[ -n "$cls" ]] && output+="(eventbox :class \"workspace-e\" :cursor \"pointer\" :onclick \"hyprctl dispatch workspace $wsid\" (label :class \"$cls\" :text \"$label\"))"
	done

	echo "(box :halign 'start' :orientation 'h' $output)"
}

# Exit if not in Hyprland
[[ -z "$HYPRLAND_INSTANCE_SIGNATURE" ]] && { echo "(box :halign 'start' :orientation 'h')"; exit 0; }

SOCKET="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

# Initial call
ws

# Listen for changes (already handles workspace switches!)
# Listen for ALL workspace-related events
# Listen for ALL workspace visibility changes
stdbuf -oL socat -U - UNIX-CONNECT:"$SOCKET" | while read -r line; do
	case $line in
		"workspace>>"* | "workspacev2>>"* | "focusedmon>>"* | "activeworkspace>>"* | "createworkspace>>"* | "destroyworkspace>>"*)
			ws
			;;
	esac
done

