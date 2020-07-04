#! /bin/sh
#set -x

# update /etc/apt/sources.list
sudo sed -i -e 's%http://.*.ubuntu.com%http://ftp.jaist.ac.jp/pub/Linux%g' /etc/apt/sources.list

# update OS
sudo apt update -y
sudo apt upgrade -y

# install gcc & ruby
sudo apt install build-essential -y
sudo apt install ruby -y

# install athrill
git clone https://github.com/tmori/athrill.git
git clone https://github.com/tmori/athrill-target.git
(cd athrill-target/v850e2m/build_linux; make timer32=true clean; make timer32=true)
export PATH="${HOME}/athrill/bin/linux:${PATH}"

# install 64bit gcc
wget https://github.com/toppers/athrill-gcc-v850e2m/releases/download/v1.1/athrill-gcc-package.tar.gz
tar xzf athrill-gcc-package.tar.gz
(cd athrill-gcc-package; tar xzvf athrill-gcc.tar.gz; sudo mv usr/local/athrill-gcc /usr/local)
export PATH="/usr/local/athrill-gcc/bin/:${HOME}/athrill/bin/linux:${PATH}"
export LD_LIBRARY_PATH="/usr/local/athrill-gcc:/usr/local/athrill-gcc/lib:${LD_LIBRARY_PATH}"

# install EV3RT development environment
git clone https://github.com/tmori/athrill-sample.git
ln -s athrill-sample/ev3rt/ev3rt-beta7-release/asp3/sdk/workspace
(cd workspace; make img=athrillsample clean; make img=athrillsample)

# setup bash initialize file
cat <<EOF >>${HOME}/.bashrc
export PATH=\"/usr/local/athrill-gcc/bin/:\${HOME}/athrill/bin/linux:\${PATH}\"
export LD_LIBRARY_PATH=\"/usr/local/athrill-gcc:/usr/local/athrill-gcc/lib:\${LD_LIBRARY_PATH}\"
EOF
