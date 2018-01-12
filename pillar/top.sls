{{ saltenv }}:
  '*':
    - pnda
    - identity
    - flavors.{{ salt['grains.get']('pnda:flavor', 'standard') }}
    - services
    - env_parameters
    - packages.{{ grains['os'] }}
    - hadoop.{{ salt['grains.get']('hadoop.distro', 'HDP') }}

{% set roles = salt.file.find('/srv/salt/platform-salt/pillar/roles', print='name', maxdepth=1, type='d') %}
{% for role in roles %}
{% set files = salt.file.find('/srv/salt/platform-salt/pillar/roles/'+role, print='name', maxdepth=1, type='f') %}
  'G@roles:{{ role }}':
{% for file in files %}
    - roles.{{ role }}.{{ file|replace(".sls","") }}
{% endfor %}
{% endfor %}
