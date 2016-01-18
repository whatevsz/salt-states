{% from 'states/nagios/map.jinja' import nagios as nagios_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

check_mk-server-livestatus:
  pkg.installed:
    - name: {{ nagios_map.check_mk.server.livestatus.package }}
    - require:
      - pkg: check_mk-server

check_mk-server-livestatus-conf:
  file.accumulated:
    - filename: {{ nagios_map.conf }}
    - text:
      - broker_module: "{{ nagios_map.check_mk.server.livestatus.module_path }} {{ nagios_map.check_mk.server.livestatus.socket_dir }}/{{ nagios_map.check_mk.server.livestatus.socket_name }}"
    - require_in:
      - file: nagios.cfg

check_mk-server-livestatus-socketdir:
  file.directory:
    - name: {{ nagios_map.check_mk.server.livestatus.socket_dir }}
    - user: nagios
    - group: nagios
    - mode: 755
    - require_in:
      - file: nagios.cfg
    - require:
      - pkg: check_mk-server-livestatus
    - watch_in:
      - service: nagios