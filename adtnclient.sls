/home/adtn/.virtualenvs/pyadtn:
    virtualenv.managed:
      - system_site_packages: True
      - user: adtn
      - python: /usr/bin/python3
      - require:
        - pkg: adtn-system-packages

#TODO: make repositories available in file server to save bandwidth

pyadtn:
  pip.installed:
    - user: adtn
    - editable: "git+https://github.com/megfault/aDTN-python.git#egg=pyadtn"
    - bin_env: /home/adtn/.virtualenvs/pyadtn
    #TODO: how to require set of packages under adtn-system-packages?
    - require: 
      - pkg: adtn-system-packages

pyric:
  pip.installed:
    - name: pyric
    - user: adtn
    - bin_env: /home/adtn/.virtualenvs/pyadtn

scapy-python3:
  pip.installed:
    - user: adtn
    - editable: "git+https://github.com/synnefy/scapy@0b70834c2506d899785d0c06d57d24fe6db2c087#egg=scapy-python3"
    - bin_env: /home/adtn/.virtualenvs/pyadtn

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
      - ipython3
      - python3-pip
      - virtualenvwrapper
      - gcc
      - libsodium13
      - libsodium-dev
      - libffi6
      - libffi-dev
      - python3-yaml
      - tcpdump
      - tshark 
