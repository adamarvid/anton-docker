#!/bin/bash

# Add local user
# Either use the LOCAL_USER_ID if passed in at runtime or
# fallback

USER_ID=${LOCAL_USER_ID:-9001}

echo "Starting with UID : $USER_ID"
useradd --shell /bin/bash -u $USER_ID -o -c "" -m user
export HOME=/home/user

mkdir /home/user/.ssh
echo -e "Host *" > /home/user/.ssh/config
echo -e "\tStrictHostKeyChecking no" >> /home/user/.ssh/config
echo -e "\tUserKnownHostsFile=/dev/null" >> /home/user/.ssh/config
chown -R user:user /home/user/.ssh

cd /workspace

exec gosu user "$@"
