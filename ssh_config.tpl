cat << EOF >> /home/markon/.ssh/config

Host $(hostname)
  HostName $(hostname)
  User $(user)
  IdentityFile $(identityfile)
EOF