{
  writeShellApplication,
  pkgs,
}:
writeShellApplication {
  name = "switch-theme";
  runtimeInputs = with pkgs; [ coreutils ];
  text = ''
    if [ "$EUID" -ne 0 ]
      then echo "Please run as root"
      exit
    fi

    function set_dark {
    	/nix/var/nix/profiles/system/bin/switch-to-configuration test
    }

    function set_light {
    	/nix/var/nix/profiles/system/specialisation/day/bin/switch-to-configuration test
    }

    function sleep_till {
    	readonly deadline=$1
    	readonly now_secs
    	local deadline_secs

    	deadline_secs=$(date --date="$deadline" "+%s")
    	now_secs=$(date +%s)

    	if [[ $now_secs > $deadline_secs ]]; then
    		deadline_secs=$(date --date="$deadline tomorrow" "+%s")
    	fi

    	local duration=$((deadline_secs-now_secs))
    	echo "sleeping till $deadline \($duration seconds\)" >&2
    	sleep $duration
    }


    if [ $# -eq 0 ]; then
    	# called from service do auto logic
		# could be started during a nixos switch, delay run for a bit
		sleep 300 # should be done in 5s right?
    	while true; do
    		now=$(date +%H:%M)
    		if [[ $now < 06:00 ]] || [[ $now > 21:00 ]]; then
    			set_dark
    			sleep_till 06:00
    		else
    			set_light
    			sleep_till 21:00
    		fi
    	done
    elif [ "$1" = "light" ]; then
    	set_light
    elif [ "$1" = "dark" ]; then
    	set_dark
    else 
    	echo "Can only be called with one or zero args"
    fi
  '';
}
