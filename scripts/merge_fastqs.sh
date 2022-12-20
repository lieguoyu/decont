# This script should merge all files from a given sample (the sample id is
# provided in the third argument ($3)) into a single file, which should be
# stored in the output directory specified by the second argument ($2).
#
# The directory containing the samples is indicated by the first argument ($1).



if [ -e $2/$3.fastq.gz ]
then
	echo "Merge files already completed"
	exit 0
fi

if test -d out/merged
then
	echo "Directory already created"
else
	echo "Creating directory"
	mkdir -p  out/merged
fi

cat $1/${sampleid}*.fastq.gz > $2/$3.fastq.gz
