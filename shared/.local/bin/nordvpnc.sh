#!/usr/bin/env bash

# Toggle NordVPN from i3/dmenu. This does not change the Wi-Fi connection.
export LC_ALL=C

notify() {
    # A missing notification daemon must not change the operation's exit status.
    if ! command -v notify-send >/dev/null 2>&1 ||
        ! notify-send "NordVPN" "$1"; then
        printf '%s\n' "NordVPN: $1" >&2
    fi
    return 0
}

clean_output() {
    local text=$1 ansi=$'\e''\[[0-?]*[ -/]*[@-~]'
    # Remove terminal colours/cursor controls and split carriage-return output.
    while [[ $text =~ $ansi ]]; do
        text=${text//"${BASH_REMATCH[0]}"/}
    done
    printf '%s' "${text//$'\r'/$'\n'}"
}

read_status() {
    local output line
    vpn_state=
    status_summary=
    if ! output=$(nordvpn status 2>&1); then
        notify "Could not read VPN status:

$(clean_output "$output")"
        return 1
    fi
    output=$(clean_output "$output")
    while IFS= read -r line; do
        if [[ $line =~ ^[[:space:]]*Status:[[:space:]]*(Connected|Disconnected|Connecting|Disconnecting)[[:space:]]*$ ]]; then
            vpn_state=${BASH_REMATCH[1]}
        fi
        if [[ $line =~ ^[[:space:]]*(Status|Server|Hostname|IP|Country|City): ]]; then
            status_summary+="${line}"$'\n'
        fi
    done <<< "$output"
    if [[ -z $vpn_state ]]; then
        notify "Unrecognized VPN status:

$output"
        return 1
    fi
}

change_connection() {
    local action=$1 expected=$2 output attempt rc
    notify "${action^}ing..."
    if output=$(nordvpn "$action" 2>&1); then
        :
    else
        rc=$?
        notify "Could not $action:

$(clean_output "$output")"
        return "$rc"
    fi

    # Check immediately, then allow a short settling period for the daemon.
    for ((attempt = 0; attempt < 10; attempt++)); do
        read_status || return 1
        if [[ $vpn_state == "$expected" ]]; then
            notify "$status_summary"
            return 0
        fi
        if ((attempt < 9)); then
            sleep 0.5
        fi
    done
    notify "VPN did not reach the expected state ($expected).

$status_summary
$(clean_output "$output")"
    return 1
}

main() {
    local dependency choice lock_fd
    for dependency in nordvpn flock; do
        if ! command -v "$dependency" >/dev/null 2>&1; then
            notify "Required command not found: $dependency"
            return 127
        fi
    done

    # Lock this script's inode; no shared temporary output or lock files needed.
    if ! exec {lock_fd}< "${BASH_SOURCE[0]}"; then
        notify "Could not open the script for locking."
        return 1
    fi
    if ! flock -n "$lock_fd"; then
        notify "Another VPN operation or menu is already running."
        return 1
    fi

    read_status || return 1
    case $vpn_state in
        Disconnected)
            change_connection connect Connected
            ;;
        Connected)
            if ! command -v dmenu >/dev/null 2>&1; then
                notify "Required command not found: dmenu"
                return 127
            fi
            # Escape/cancel must not trigger a VPN operation.
            choice=$(printf '%s\n' 'connect to new ip' 'disconnect' |
                dmenu -l 2 -p 'NordVPN:') || return 0
            case $choice in
                'connect to new ip') change_connection connect Connected ;;
                disconnect) change_connection disconnect Disconnected ;;
                '') return 0 ;;
                *) notify "Invalid option: $choice"; return 1 ;;
            esac
            ;;
        Connecting|Disconnecting)
            notify "VPN is currently $vpn_state. Try again once it finishes."
            return 1
            ;;
    esac
}

main "$@"
