# set -x
usage(){
#here doc for printing multiline
	cat <<Endofmessage
usage:
	-h	help
	-s 	summarize
	-a 	show hidden files
Endofmessage
	printf "\E[0m"
}

#show file sizes of all files in pwd
#checking for presence of sorted flag which is
#set in getopts
dontSummarizeSizes(){
	if [[ $sorted ]]; then
		du -sh * | gsort -h
	else
		du -sh * 
	fi
}

#show just summarize size
summarizeSizes(){
	du -sh `pwd`
}

showHidden(){
	#checking for presence of sorted flag which is
	#set in getopts
	if [[ $sorted ]]; then
		#take output of ls -A (no . and ..) and call du -sh on each file and then pipe into gsort -h
		{
			while read line; do
			du -sh "$line"
			done < <(ls -A)
		} | gsort -h
	else
		#same while read llop but dont pipe into gsort
		while read line; do
		du -sh "$line"
		done < <(ls -A)
	fi

}

#valid options
optstring=shta

while getopts $optstring opt
do
  case $opt in
  	h) usage; exit;;
	#set boolean for sorted
  	s) sorted=true;;
	#set boolean for showing hidden files
	a) showHiddenBool=true;;
	#set boolean for showing just summary
  	t) summarizeSizesBool=true;;
    *) usage; exit;;
	esac
done

#check boolean for showing hidden files, sorted flag has been set or not set by here
#exit after finishing to prevent illegal combination of -a and -t
if [[ ! -z "$showHiddenBool" ]]; then
	showHidden
	exit
#check boolean for showing summary, sorted flag has been set or not set by here
#exit after finishing
elif [[ ! -z "$summarizeSizesBool" ]]; then
	summarizeSizes
	exit
fi

#if passed the -a or -t options then this point will not be reached
if [[ -z $leave ]]; then
	dontSummarizeSizes
fi
