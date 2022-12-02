#!/usr/bin/env python3


from pyspark import SparkContext  
import pyspark  
sc = SparkContext (  
  "local",  
  "StorageLevel app"  
)  
rdd1 = sc.parallelize([1,2])  
rdd1.persist( pyspark.StorageLevel.MEMORY_AND_DISK_2 )  
rdd1.getStorageLevel()  
print(rdd1.getStorageLevel())