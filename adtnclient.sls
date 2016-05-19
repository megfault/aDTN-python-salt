adtn-app:
  git.latest:
    - name: "https://github.com/megfault/aDTN-python.git"
    - target: "/home/adtn/aDTN-python"
    - user: adtn

adtn-experiment:
  git.latest:
    - name: "https://github.com/megfault/aDTN-experiment.git"
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
