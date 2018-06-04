eosiocpp -o ping.wast ping.cpp
eosiocpp -g ping.abi ping.cpp
cleos set contract ping.code ../ping -p ping.code
