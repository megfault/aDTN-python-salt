pyadtn:
  pip.installed:
    - editable: "https://github.com/megfault/aDTN-python.git"
    - user: adtn
    - bin_env: "/usr/bin/pip3"

adtn-experiment:
  git.latest:
    - name: "https://github.com/megfault/aDTN-python-experiment.git"
    - target: "/home/adtn/aDTN-experiment"
    - user: adtn

/etc/sudoers.d/adtn:
  file.managed:
    - source: salt://sudoers/adtn
    - user: root
    - group: root
    - mode: 0440

/etc/systemd/system/adtn.service:
  file.managed:
    - source: salt://systemd/adtn.service
    - user: root
    - group: root
    - mode: 0444

adtn:
  service.running:
    - enable: True
    - require:
      - file: /etc/systemd/system/adtn.service

adtn-system-packages:
  pakg.installed:
    - names:
      - iw
      - python3
      - virtualenvwrapper
      - git
      - sudo
      - python3-pip
      - gcc
      - ssh
      - vim
      - libsodium13
      - libsodium-dev
      - libffi6
      - libffi-dev
