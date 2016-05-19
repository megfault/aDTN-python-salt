/home/adtn/pyadtn:
    virtualenv.managed:
      - system_site_packages: True 
      - user: adtn
      - python: /usr/bin/python3
      - require:
        - pkg: python3-pip

#TODO: make repositories available in file server to save bandwidth

pyadtn:
  pip.installed:
    - user: adtn
    - editable: "git+https://github.com/megfault/aDTN-python.git#egg=pyadtn"
    - bin_env: /home/adtn/pyadtn

scapy-python3:
  pip.installed:
    - user: adtn
    - editable: "git+https://github.com/phaethon/scapy@a7cd488b51e29c48430afffe4810aa13bffe62f7#egg=scapy-python3"
    - bin_env: /home/adtn/pyadtn

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
  pkg.installed:
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
