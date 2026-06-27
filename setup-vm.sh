#!/bin/bash
# export PASSWORD='' && wget --no-cache https://raw.githubusercontent.com/s0meth1ng2dr1nk/initial-setup/main/setup-vm.sh -O setup-vm.sh && sudo --preserve-env=PASSWORD bash setup-vm.sh && rm -f setup-vm.sh
set -eu

apt update

# setup ssh
echo "root:${PASSWORD}" | chpasswd
grep -rl ssh_pwauth /etc/cloud | xargs -r sed -i -E -e 's@^ssh_pwauth.*@ssh_pwauth:true@'
grep -rl PasswordAuthentication /etc/ssh | xargs -r sed -i -E \
    -e 's@^PasswordAuthentication@#PasswordAuthentication@' \
    -e 's@^PasswordAuthentication@#PasswordAuthentication@' \
    -e 's@^PermitRootLogin@#PermitRootLogin@' \
    -e 's@^UsePAM@#UsePAM@' \
    -e '$aPasswordAuthentication yes' \
    -e '$aPermitRootLogin yes' \
    -e '$aUsePAM yes'
systemctl restart ssh*

# setup python3
apt install -y python3 python3-pip
export PIP_ROOT_USER_ACTION=ignore
pip3 install --break-system-packages curl_cffi

# setup nodejs
apt install -y nodejs npm

# setup docker
wget --no-cache https://get.docker.com -O get-docker.sh
bash get-docker.sh
rm -f get-docker.sh
