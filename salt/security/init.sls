{% set security_certs_tarball = pillar['security']['security_certs_tarball'] %}
{% set security_certs_tarball_hash = pillar['security']['security_certs_tarball_hash'] %}
{% set dirs = salt.file.find('/srv/security-certs/', print='name', maxdepth=1, type='d') %}

security-extract:
  archive.extracted:
    - name: /srv/security-certs-{{ security_certs_tarball_hash }}
    - source: {{ security_certs_tarball }}
    - archive_format: tar
    - tar_options: --strip-components=1

security-link:
  file.symlink:
    - name: /srv/security-certs
    - target: /srv/security-certs-{{ security_certs_tarball_hash }}

{% for sub in dirs %}
{% set files = salt.file.find('/srv/security-certs/'+sub , print='name', type='f') %}
{% for file in files %}
{% if file.endswith('.key') %}
security-link-{{ sub }}-{{ file }}:
  file.symlink:
    - name: /srv/security-certs/{{ sub }}.key
    - target: /srv/security-certs/{{ sub }}/{{ file }}
{% endif %}
{% if file.endswith('.crt') %}
security-link-{{ sub }}-{{ file }}:
  file.symlink:
    - name: /srv/security-certs/{{ sub }}.crt
    - target: /srv/security-certs/{{ sub }}/{{ file }}
{% endif %}
{% endfor %}
{% endfor %}
