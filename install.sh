#!/bin/bash

PKG=go1.13.6

# download go package
if [ ! -f $PKG.linux-amd64.tar.gz ]; then
  wget -c https://dl.google.com/go/$PKG.linux-amd64.tar.gz
  tar -xzf $PKG.linux-amd64.tar.gz
  sudo mv go /opt/$PKG

  if [ ! -L /opt/go  ]; then
    sudo ln -sf /opt/$PKG /opt/go
  fi
fi

# prepare setup script
if [ ! -f /opt/$PKG/setup.sh ]; then

cat <<EOF > setup.sh
#!/bin/bash
export GOPROXY=https://goproxy.cn
export GOROOT=/opt/go
export GOPATH=\$HOME/gows
export PATH=\$GOROOT/bin:\$GOPATH/bin:\$PATH
EOF

  chmod +x setup.sh
  sudo mv setup.sh /opt/$PKG/

fi

# append on bashrc
num=`grep -e "/opt/go/setup.sh" ~/.bashrc | wc -l`
if [ $num == "0" ]; then

cat <<EOF >> ~/.bashrc

if [ -f /opt/go/setup.sh ]; then
    source /opt/go/setup.sh
fi

EOF

fi

