systemd-timesyncd:
  service.running:
    - enable: True

base-packages:
  pkg.installed:
    - names:
      - git
      - sudo
      - ssh
      - vim

unattended-upgrades:
  pkg.installed: []
  service.running:
    - enable: True

{% for service in ['rpcbind','nfs-common'] %}
{{ service }}:
  service.dead:
    - enable: False
{% endfor %}

ssh:
  pkg.installed: []
  service.running:
    - enable: True

ssh-keys:
  ssh_auth.present:
    - user: adtn
    - names:
      - ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAwA2g3fdU20r3FB2c/P3HdK8FiBxScXk5TQjLxiswThS7rubD2yMgf2E5Q0aVavH2O/XS+BFtud9iBT5pyATUBzcNd597isOpEfcypiAMXkFHkH6GJC5Ej2RKiUoGTnbW77+ZpVwzAd7l61iu7nNkBnYvuNTi/9u/xQ+IhEkPMdKUlFBIMarS11WXw3kUkGLMuHZvZtT2+B+c8aIzgzeT5zX09S7fcHzylg2VkqgTNi8knPuqiHMo9/qQfgb209Q9eXQdYEEdZVLXxZLF2merCdAN9hFJ1kW5SYHBEr6u9CrcwWS8jv9UwLfTk4WyswMFkSQJWAO0z92Gm5kFnKNtJw== christian@redlap
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDvi16dwq0/eLGPlWF4aedAgKA5Gsh0o6qxiWR0Yqb2rjTp7flLyzjagBVAQtIsiUcaMeoLMi3WD50GC7t73qY68uZkIBFlHZ3bsJaHvu5gCa38C1B3vGOSjnAY3QP7mCw0NWSsN+Dxbqwf53zP5vgwof4ZYeNMB4lYIDJ39fZzBxGQ1L57Gfy9Q+9tyFtYRrSDcuIZV5rv0EASDlTL95/JG+kfTzB/JKgL16AcDPHrjPKruMexwIRywOVkzHXxV9+79QVxYQK5MRH2ZlwmwApVJmQ+IoZVPK1Dl5oO1D4zlEkcQpWQ04Y7kkzjxs2Y13L/b2J/yoL2Rz2/KpcPPx0n ana's key
