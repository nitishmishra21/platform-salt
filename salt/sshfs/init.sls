{% set sshfs_fs_location_path = salt['pillar.get']('sshfs:fs_location_path', '/opt/pnda/packages') %}
{% set sshfs_device = salt['pillar.get']('sshfs:device', 'cloud-user@127.0.0.1:/opt/packages') %}
{% set sshfs_identity_file = salt['pillar.get']('sshfs:identity_file', '/opt/pnda/id_rsa') %}

sshfs-install:
  pkg.installed:
    - name: sshfs

sshfs-create_directory:
  file.directory:
    - name: {{ sshfs_fs_location_path }}
    - user: cloud-user
    - group: cloud-user
    - mode: 755
    - makedirs: True
 
sshfs-mount_directory:
  mount.mounted:
    - name: {{ sshfs_fs_location_path }}
    - device: {{ sshfs_device }}
    - opts: IdentityFile={{ sshfs_identity_file }}
    - fstype: fuse.sshfs
    - persist: True
    - mkmnt: True