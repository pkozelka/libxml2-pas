all:
	echo "ERROR: not yet implemented!"

checkapi:
	utils/checkapi.sh /home/pk/cvs/gnome.org `find libxml2 libxslt -name '*.inc'`
