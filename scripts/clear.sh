
rm Log.out

for i in data/*.gz
do 
	rm $i 
done 

for dir in out/*
do
	rm -r $dir
done

cd log/
rm -r cutadapt/
rm pipeline.log

cd ..

cd res/
rm -r contaminants_idx
rm contaminants.fasta
rm contaminants.fasta.gz

cd ..

tree
