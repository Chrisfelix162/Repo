for i in {3..100}; do ping -c1 192.65.241.$i|grep -B1 "1 packets received"; done
