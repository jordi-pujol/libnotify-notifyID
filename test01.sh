#!/bin/sh

set -e

_notify_send() {
	notify-send ${notifyID:+-r ${notifyID}} -u "${urgency}" \
	${icon:+-i ${icon}} -t "${timeout}" -a "Testing notifyID" \
	"$(date +'%F %X')" "${c}"
}

_notify() {
	local DBUS_SESSION_BUS_ADDRESS notifyID="" c=10 \
		timeout=0 urgency="critical" icon=""

	DBUS_SESSION_BUS_ADDRESS="$(grep -z DBUS_SESSION_BUS_ADDRESS /proc/${$}/environ | \
		tr -d '\0')" || return 0
	export DISPLAY
	export "${DBUS_SESSION_BUS_ADDRESS}"

	while notifyID="$(_notify_send)" && [ $((c--)) -gt 0 ]; do
		sleep 1
	done

	c=0
	urgency="normal"
	timeout=2000
	notifyID="$(_notify_send)"
}

_notify
