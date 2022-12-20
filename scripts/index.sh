# This script should index the genome file specified in the first argument ($1),
# creating the index in a directory specified by the second argument ($2).

# The STAR command is provided for you. You should replace the parts surrounded
# by "<>" and uncomment it.

# STAR --runThreadN 4 --runMode genomeGenerate --genomeDir <outdir> \
# --genomeFastaFiles <genomefile> --genomeSAindexNbases 9

echo  "Star Index" 

if [ -e $2 ]
then
	echo "Index files already completed"
	exit 0
fi

if test -d res/contaminants_idx
then
	echo "Directory already created"
else
	echo "Creating directory"
	mkdir -p res/contaminants_idx 
fi

STAR --runThreadN 4 --runMode genomeGenerate \
--genomeDir $2 \
--genomeFastaFiles $1 \
--genomeSAindexNbases 9

