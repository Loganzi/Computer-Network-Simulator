#!/usr/bin/awk -f

BEGIN {
	cbrPkt = 0;
	tcpPkt = 0;
}
{
	if(($1 == "d") && ($5 == "cbr"))
		cbrPkt++;
	if(($1 == "d") && ($5 == "tcp"))
		tcpPkt++;
}
END {
	print("No. of CBR pakets dropped:  \n", cbrPkt);
	print("No. of TCP pakets dropped:  \n", tcpPkt);
}

