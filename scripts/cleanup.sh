 
rm Log.out

for i in data/*.gz
do 
	rm $i 
done 

for dir in out/*
do
	rm -r $dir
done

for file in res/*
do
	rm -r $file
done

for files in log/*
do
	rm -r $files
done


tree
