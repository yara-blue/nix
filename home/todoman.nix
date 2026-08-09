{
  config,
  lib,
  ...
}:

{

  programs.todoman = {
    enable = true;
    extraConfig = ''
      date_format = "%d-%m-%Y"
      default_due = 0
      # set this to an existing list
      # default_list = "Inbox"
      humanize = True
      # path = ~/calendars/*"
      startable = False
      time_format = "%H:%M"
    '';
  };
  accounts.calendar.basePath = "${config.home.homeDirectory}/calendars";

  age.secrets.pimsync = {
    mode = "400";
    rekeyFile = ../secrets/home/pimsync.age;
  };
  age.secrets.caldav_url = {
    mode = "400";
    rekeyFile = ../secrets/home/caldav_url.age;
  };

  services.pimsync.enable = true;
  home.activation = {
    calendarsdir = lib.hm.dag.entryAfter [
      "writeBoundary"
    ] "mkdir -p ${config.home.homeDirectory}/calendars";
  };

  home.file.".config/pimsync/pimsync.conf".text = ''
        # use a standard location for the status database:
        status_path "~/.local/share/pimsync/status/"

        storage calendars_remote {
          type caldav
          url {
    		shell "cat ${config.age.secrets.caldav_url.path}"
    	  }
          username ${config.home.username}
          password {
            shell "cat ${config.age.secrets.pimsync.path}"
          }
        }

        storage calendars_local {
          type vdir/icalendar
          path ~/calendars/
          fileext ics
        }

        pair calendars {
          storage_a calendars_local
          storage_b calendars_remote
          collections all
        }
  '';
}
