##download###
https://openvpn.net/index.php/open-source/downloads.html
git clone https://github.com/OpenVPN/openvpn
git clone git://openvpn.git.sourceforge.net/gitroot/openvpn/openvpn

###deps####
yum install lzo-devel pam-devel
##install####

tar zxvf openvpn-2.3.4.tar.gz && cd openvpn-2.3.4 && ./configure && make && make install

###easy-rsa####
wget -c https://github.com/OpenVPN/easy-rsa/archive/release/2.x.zip
