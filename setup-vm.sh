#!/usr/bin/env bash
# export PASSWORD='' && wget --no-cache https://raw.githubusercontent.com/s0meth1ng2dr1nk/initial-setup/main/setup-vm.sh && sudo bash setup-vm.sh && rm -f setup-vm.sh
set -eu

apt update
apt install -y \
    expect \
    curl \
    git \
    nodejs \
    npm \
    python3 \
    python3-pip

export PIP_ROOT_USER_ACTION=ignore
pip3 install --break-system-packages --upgrade \
    pip \
    curl_cffi

curl -fsSL https://get.docker.com -o get-docker.sh
bash get-docker.sh
rm -f get-docker.sh

for _FILE in $(grep -r PasswordAuthentication /etc/ssh -l); do
    sed -i -e "/PasswordAuthentication/s/^/#/" -e "/PermitRootLogin/s/^/#/" ${_FILE}
    echo "PasswordAuthentication yes" >> ${_FILE}
    echo "PermitRootLogin yes" >> ${_FILE}
done

expect -c "
spawn passwd
expect 'New password:'
send '${PASSWORD}\n'
expect 'Retype new password:'
send '${PASSWORD}\n'
expect "
systemctl restart ssh
