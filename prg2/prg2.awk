BEGIN {
	pingDrop =0;
}

{
	if( $1 == "d") 
		pingDrop++;
}

END {
	printf("Total ping packets dropped is: %d\n",pingDrop);
}


