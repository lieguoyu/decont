
echo "############ Starting pipeline at $(date +'%H:%M:%S')... ############"
#Download all the files specified in data/filenames 
for url in $(cat data/urls) #TODO
do
    bash scripts/download.sh $url data
done

# Download the contaminants fasta file, uncompress it, and
# filter to remove all small nuclear RNAs
bash scripts/download.sh https://bioinformatics.cnio.es/data/courses/decont/contaminants.fasta.gz res yes #TODO

# Index the contaminants file
bash scripts/index.sh res/contaminants.fasta res/contaminants_idx

# Merge the samples into a single file
for sid in $(ls data/*.fastq.gz | cut -d "-" -f1 | sed "s:data/::"  | sort | uniq) #TODO
do
    bash scripts/merge_fastqs.sh data out/merged $sid
done

# TODO: run cutadapt for all merged files
# cutadapt -m 18 -a TGGAATTCTCGGGTGCCAAGG --discard-untrimmed \
#     -o <trimmed_file> <input_file> > <log_file>

echo "Running cutadapt"

if test -d log/cutadapt
then
	echo "Directory already created"
else
	echo "Creating directory"
	mkdir -p log/cutadapt
fi

if test -d out/trimmed
then 
	echo "Directory already created"
else
	echo "Creating directory"
	mkdir -p out/trimmed
fi


for sampleid in $(ls out/merged/*fastq.gz | cut -d "." -f1| sed "s:out/merged/::" | sort | uniq)
do
	if [ -e out/trimmed/${sampleid}.trimmed.fastq.gz ]
	then
		echo "Sample $sampleid already completed"
		continue
	fi

	cutadapt -m 18 -a TGGAATTCTCGGGTGCCAAGG --discard-untrimmed \
	-o out/trimmed/${sampleid}.trimmed.fastq.gz out/merged/${sampleid}.fastq.gz > log/cutadapt/${sampleid}.log
done


# TODO: run STAR for all trimmed files
    # you will need to obtain the sample ID from the filename
    # mkdir -p out/star/$sid
    # STAR --runThreadN 4 --genomeDir res/contaminants_idx \
    #    --outReadsUnmapped Fastx --readFilesIn <input_file> \
    #    --readFilesCommand gunzip -c --outFileNamePrefix <output_directory> 

echo "Running STAR alignment"
for fname in out/trimmed/*.fastq.gz
do 
	sid=$(basename $fname .trimmed.fastq.gz)
	if [ -e out/star/$sid ]
	then
		echo "Sample $sid already completed"
		continue
	fi

	if test -d out/star/${sid}
	then
		echo "Directory already created"
	else
		echo "Creating directory"
		mkdir -p out/star/${sid}
	fi
	STAR --runThreadN 4 --genomeDir res/contaminants_idx \
		--outReadsUnmapped Fastx \
		--readFilesIn out/trimmed/${sid}.trimmed.fastq.gz \
		--readFilesCommand gunzip -c \
		--outFileNamePrefix out/star/${sid}/
done


#TODO: create a log file containing information from cutadapt and star logs
# (this should be a single log file, and information should be *appended* to it on each run)
# - cutadapt: Reads with adapters and total basepairs
# - star: Percentages of uniquely mapped reads, reads mapped to multiple loci, and to too many loci
# tip: use grep to filter the lines you're interested in

echo "log file cutadapt"
for file in log/cutadapt/*.log
do 
	cat $file | grep -E "%|basepairs|adapters" > log/pipeline.log
done 
cat log/pipeline.log

echo "log file star"
for files in out/star/*
do
	ls $files/*.out | cat $files/*out | grep -E "%|multiple|many" > Log.out
done 
cat Log.out

echo "############ Pipeline finished at $(date +'%H:%M:%S')... ############"
