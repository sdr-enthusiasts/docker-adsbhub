#!/command/with-contenv bash
#shellcheck shell=bash

if [[ -n "$VERBOSE_LOGGING" ]]; then
    set -x
fi

function get_ip() {
    # $1 = IP(v4) address or hostname
    # -----
    local IP
    # Attempt to resolve $1 into an IP address with getent
    if IP=$(getent hosts "$1" 2> /dev/null | cut -d ' ' -f 1); then
        :
        if [[ -n "$VERBOSE_LOGGING" ]]; then
            >&2 echo "DEBUG: Got IP via getent"
        fi
    # Attempt to resolve $1 into an IP address with s6-dnsip4
    elif IP=$(s6-dnsip4 "$1" 2> /dev/null); then
        :
        if [[ -n "$VERBOSE_LOGGING" ]]; then
            >&2 echo "DEBUG: Got IP via s6-dnsip4"
        fi
    # Catch-all (maybe we were given an IP...)
    else
        if [[ -n "$VERBOSE_LOGGING" ]]; then
            >&2 echo "DEBUG: No host found, assuming IP was given instead of hostname"
        fi
        IP="$1"
    fi
    # Return the IP address
    echo "$IP"
}

function is_tcp_connection_established() {
    # $1 = ip
    # $2 = port
    # -----
    # Define local vars
    local pattern_ip_port
    local pattern
    # Prepare the part of the regex pattern that has the IP and port
    pattern_ip_port=$(echo "$1:$2" | sed 's/\./\\./g')
    # Prepare the remainder of the regex including the IP and port
    pattern="^tcp\s+\d+\s+\d+\s+\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}:\d{1,5}\s+${pattern_ip_port}\s+ESTABLISHED$"
    # Check to see if the connection is established
    if netstat -an | grep -P "$pattern" > /dev/null 2>&1; then
        true
    else
        false
    fi
}

##### MAIN SCRIPT #####

EXITCODE=0

##### Network Connections #####

# Check connection to SBSHOST
if is_tcp_connection_established "$(get_ip "$SBSHOST")" "$SBSPORT"; then
    echo "Connected to $SBSHOST:$SBSPORT OK: HEALTHY"
else
    echo "Not connected to $SBSHOST:$SBSPORT: UNHEALTHY"
    EXITCODE=1
fi

# Check connection to data.adsbhub.org
if is_tcp_connection_established "$(get_ip data.adsbhub.org)" "5001"; then
    echo "Connected to data.adsbhub.org:5001 OK: HEALTHY"
else
    echo "Not connected to data.adsbhub.org:5001: UNHEALTHY"
    EXITCODE=1
fi

exit $EXITCODE
