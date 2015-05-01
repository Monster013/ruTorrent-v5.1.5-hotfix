#!/bin/sh
#
# $1 - unzip
# $2 - input directory with tail slash
# $3 - output directory with tail slash
# $5 - delete archives after auto unpack

ret=0

process_directory()
{
        for fn in "$2"*.zip ; do
        	if [ -f "${fn}" ] && [ -r "${fn}" ] ; then
	        	mkdir -p "$3"
			"$1" -o "${fn}" -d "$3"
			last=$?
			[ $last -gt 1 ] && ret=$last
		fi
	done
	for fn in "$2"* ; do
		if [ -d "${fn}" ] && [ ! -L "${fn}" ] ; then
			name=$(basename "${fn}")
			process_directory "$1" "${fn}/" "$3${name}/"
			last=$?
			[ $last -gt 1 ] && ret=$last
		fi
	done
	return $ret
}

process_directory "$1" "$2" "$3"

ret=$?
[ $ret -le 1 ] && echo 'All OK'
if [ $ret -le 1 ] && [ "$5" = 'true' ] ; then
	find "$2" \( -name '*.zip' -o -name '*.ziP' -o -name '*.zIp' -o -name '*.zIP' -o -name '*.Zip' -o -name '*.ZiP' -o -name '*.ZIp' -o -name '*.ZIP' \) -exec rm {} +
fi

exit $ret
