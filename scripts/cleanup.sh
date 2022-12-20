 
rm Log.out

for i in data/*.gz*
do 
	rm -r -f $i 
done 

for dir in out/*
do
	rm -r -f  $dir
done

for file in res/*
do
	rm -r -f $file
done

for files in log/*
do
	rm -r -f $files
done


tree
