#This file has few bash commands to collect and parsing feature release year information on cloud providers (AWS, Azure and GCP)

#AWS
	#data collect
		for d in $(seq 2004 2019) ; do  curl https://aws.amazon.com/about-aws/whats-new/$d/ >> aws-blog.txt ; done
	#parsing
		for y in $(seq 2004 2019) ; do echo "$y: $(cat aws-blog.txt | grep "Posted On:" | grep $y | wc -l)" ; done
#Azure
	#data collect
		for d in $(seq 1 65) ; do  curl "https://azure.microsoft.com/en-us/updates/?updatetype=features&Page=$d" >> azure-blog.txt ; done
	#parsing
		y=0 ; c=0 ; for a in $(cat azure-blog.txt | grep -A1 -E '<div class="column medium-1">|<h2>' | grep -v "div" | sed 's/<[^>]*>//g' |  sed 's/[^[:print:]]//'); do [[ ${a} == 20[0-1][0-9] ]] && [[ $a != $y ]] && echo "$y:$c" && y=$a && c=0 ; [[ ${a} == [A-Z][a-z][a-z] ]] && c=$((c+1)) ; done
#GCP
	#data collect
		d=$(date +%Y-%m-%d) ; D=0 ; while [ $d != $D ] ; do  D=$d; curl https://cloudplatform.googleblog.com/search?updated-max="$d"T08:00:00-23:59 >> gcp-blog.txt ; d=$(cat gcp-blog.txt | grep -E '^(Sunday|Monday|Tuesday|Wednesday|Thursday|Friday|Saturday), [A-Z]' | tail -1 | date -f - +%Y-%m-%d) ; echo $d ; done
	#parsing
		for y in $(seq 2004 2019) ; do echo "$y: $(cat gcp-blog.txt | grep -E '^(Sunday|Monday|Tuesday|Wednesday|Thursday|Friday|Saturday), [A-Z]' | cut -d" " -f1-4 | grep $y | wc -l)" ; done
