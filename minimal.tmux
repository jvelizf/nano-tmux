#!/usr/bin/env bash

get_tmux_option() {
	local option=$1
	local default_value="$2"
	# shellcheck disable=SC2155
	local option_value=$(tmux show-options -gqv "$option")
	if [ -n "$option_value" ]; then
		echo "$option_value"
		return
	fi
	echo "$default_value"
}

bg=$(get_tmux_option "@minimal-tmux-bg" '#90a4ae')
fg=$(get_tmux_option "@minimal-tmux-fg" '#ffffff')

status=$(get_tmux_option "@minimal-tmux-status" "top")
justify=$(get_tmux_option "@minimal-tmux-justify" "left")

indicator_state=$(get_tmux_option "@minimal-tmux-indicator" false)
right_state=$(get_tmux_option "@minimal-tmux-right" false)
left_state=$(get_tmux_option "@minimal-tmux-left" true)

if [ "$indicator_state" = true ]; then
	indicator=""
else
	indicator=""
fi

window_status_format=$(get_tmux_option "@minimal-tmux-window-status-format" ' #I #W ')
status_right=$(get_tmux_option "@minimal-tmux-status-right" "#S")
status_left=$(get_tmux_option "@minimal-tmux-status-left" "#[bg=default,fg=default,bold]#{?client_prefix,,${indicator}}#[bg=${bg},fg=${fg},bold]#{?client_prefix,${indicator},}#[bg=default,fg=default,bold]")
expanded_icon=$(get_tmux_option "@minimal-tmux-expanded-icon" ' 󰊓 ')
show_expanded_icon_for_all_tabs=$(get_tmux_option "@minimal-tmux-show-expanded-icon-for-all-tabs" false)

status_right_extra="$status_right$(get_tmux_option "@minimal-tmux-status-right-extra" '')"
status_left_extra="$status_left$(get_tmux_option "@minimal-tmux-status-left-extra" '')"

if [ "$right_state" = false ]; then
	status_right_extra=""
fi

if [ "$left_state" = false ]; then
	status_left_extra=""
fi

tmux set-option -g status-position "${status}"
tmux set-option -g status-style bg=default,fg=default
tmux set-option -g status-justify "${justify}"
tmux set-option -g status-left "${status_left_extra}"
tmux set-option -g status-right "${status_right_extra}"
tmux set-option -g window-status-format "${window_status_format}"
tmux set-option -g window-status-current-format "#[bg=${bg},fg=${fg}] ${window_status_format}#{?window_zoomed_flag,${expanded_icon}, }"

if [ "$show_expanded_icon_for_all_tabs" = true ]; then
	tmux set-option -g window-status-format " ${window_status_format}#{?window_zoomed_flag,${expanded_icon}, }"
fi
