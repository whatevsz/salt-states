#!stateconf
{% from 'states/sudo/map.jinja' import sudo as sudo_map with context %}
{% from 'states/defaults.map.jinja' import defaults with context %}

.params:
    stateconf.set: []
# --- end of state config ---

{% for group in [params.group, params.group_nopw] %}
sudo-group-{{ group }}:
  group.present:
    - name: {{ group }}
{% endfor %}

sudoers:
  file.managed:
    - name: {{ sudo_map.sudoers }}
    - user: root
    - group: {{ defaults.rootgroup }}
    - mode: 600
    - source: salt://states/sudo/files/sudoers
    - template: jinja
    - defaults:
        group: {{ params.group }}
        group_nopw: {{ params.group_nopw }}
    - require:
      - pkg: sudo
      {% for group in [params.group, params.group_nopw] %}
      - group: sudo-group-{{ group }}
      {% endfor %}