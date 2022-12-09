#!/usr/bin/env python3

##############################
###### Load The Delta   ######
##############################
###
### Input delta in folder :  /data/delta
json_cv_file="/opt/spark/examples/data/delta/json-cv-pdf"
json_cv_table="pdf_cv"
#
ngrams_cv_file="/opt/spark/examples/data/delta/cv-files-ngrams"
ngrams_cv_table="ngrams_cv"
#
skills_file="/opt/spark/examples/data/delta/role_skills"
skills_table="role_skills"

skills_matrix="/opt/spark/examples/data/Skills_matrix"
###
######
##############################Execution##########################
#import findspark
#findspark.init()
#
#
import pyspark
from pyspark.sql import functions as pfunc
from pyspark.sql import SQLContext
from pyspark.sql import SparkSession
from pyspark.sql import Window, types
import re
import pandas as pd
import numpy as np
from pandas import DataFrame
from pyspark.sql.types import IntegerType
from pyspark.sql.types import FloatType
from pyspark.sql.functions import udf
from pyspark.sql.functions import *
from scipy.stats import kstest
from scipy import stats
from datetime import datetime
#
import subprocess
import os
#
#sc = pyspark.SparkContext(appName="Daily_CV_Analysis-Delta")
#sqlContext = SQLContext(sc)
sqlContext = SparkSession.builder.appName("Daily_CV_Analysis-Delta").config("spark.jars.packages", "io.delta:delta-core_2.12:1.2.1") .config("spark.jars.repositories", "https://maven-central.storage-download.googleapis.com/maven2/").getOrCreate()
#

#
# Join with Internal Curation Data in urltopredict staged folder
from pyspark.sql import functions as F
### use version=1
version=1
## .option("versionAsOf", version)
delta_df1=sqlContext.read.format("delta").load(json_cv_file)\
.persist(pyspark.StorageLevel.MEMORY_AND_DISK_2)
delta_df1.printSchema()
delta_df1.registerTempTable(json_cv_table)
#
delta_df2=sqlContext.read.format("delta").load(ngrams_cv_file)\
.persist(pyspark.StorageLevel.MEMORY_AND_DISK_2)
delta_df2.printSchema()
delta_df2.registerTempTable(ngrams_cv_table)
#
delta_df3=sqlContext.read.format("delta").load(skills_file)\
.persist(pyspark.StorageLevel.MEMORY_AND_DISK_2)
delta_df3.printSchema()
delta_df3.registerTempTable(skills_table)
#
print("Table Loading Done")
#
####
#### Expose most frequent Terms in CV pages
####
from pyspark.sql.functions import *
from pyspark.sql.types import *
#
mywords=sqlContext.sql("select filename,pages from pdf_cv where filename IS NOT NULL ") ## ='cv-x1' 
mywords=mywords.select("filename",explode("pages.p_content").alias("p_cont"))\
.select("filename",explode(split(col("p_cont"), "\s+")).alias("terms_in_pages"))
###
mywords.printSchema()
####
filler_words_list=['the','a','of','to','is','or','in','on','for','by','an','The','and','A','at',\
                   'your','as','that','when','their','it','be','with','you','are','It','from','can','usually',\
                   '--','-',':','•','|','●','§','&','–','.','_',';',',','(',')','/',\
                   '1','2','3','4','5','6','7','8','9','0',\
                   'a','b','c','d','e','f','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',\
                   ' ','\n','\n ','  ','\n  ','   ','\n   ','    ','     ','      ','       ','        ','         ','          ','           ']
####
wordCountDF = mywords.filter(~(col("terms_in_pages").isin(filler_words_list))).groupBy("filename","terms_in_pages").count().orderBy(col('count').desc())
####        
wordCountDF.show(138)
#
#
data_analytics_df1=sqlContext.sql("select * from pdf_cv limit 5")
data_analytics_df1.printSchema()
data_analytics_df1.show(5)
#
#
data_analytics_df2=sqlContext.sql("select * from ngrams_cv limit 5")
data_analytics_df2.printSchema()
data_analytics_df2.show(5)
#
#
data_analytics_df3=sqlContext.sql("select * from role_skills limit 5")
data_analytics_df3.printSchema()
data_analytics_df3.show(5)
#
#
data_analytics_df4=sqlContext.sql(" select distinct(a.filename) from ngrams_cv as a, role_skills as b where b.role = 'devops engineer' AND b.level='5' AND b.skill = 'terraform' AND (array_contains(a.1_grams,b.skill)) limit 10 ")
data_analytics_df4.printSchema()
data_analytics_df4.show(5)
#
#



engineer_matrix_skills=sqlContext.sql(" select a.filename,b.role,b.skill,b.level,b.skill_type from ngrams_cv as a, role_skills as b  where  b.level in ('2','3','4','5','6','7') and \
 ( array_contains(a.1_grams,b.skill) or array_contains(a.2_grams,b.skill) or array_contains(a.3_grams,b.skill) or array_contains(a.4_grams,b.skill) or array_contains(a.5_grams,b.skill) ) \
 and b.skill IS NOT NULL and b.role IS NOT NULL  ")
#
engineer_matrix_skills.printSchema()
engineer_matrix_skills.head(2)
#
datepath=datetime.today().strftime('%Y_%m_%d')

skills_matrix_output=skills_matrix+"/skill_matrix_"+datepath
os.system('mkdir -p '+skills_matrix_output)
skills_matrix_file_path= "skills_matrix_file_" + datepath  + ".csv"
#
# cast columns as strings
#engineer_matrix_skills_wrt = engineer_matrix_skills.withColumn('filename', col('filename').cast('string')).withColumn('role', col('role').cast('string')).withColumn('skill', col('skill').cast('string'))
#engineer_matrix_skills_wrt.printschema()
#
tmp_skills_matrix_file_path= skills_matrix+"/tmp_" + skills_matrix_file_path
engineer_matrix_skills.write.mode("overwrite").option("mergeSchema", "true").option("header", "true").format("csv").save(tmp_skills_matrix_file_path)
#

print(skills_matrix)
#
cmd_convert_file = "cat " + tmp_skills_matrix_file_path + "/part-*.csv > " +skills_matrix_output +"/"+ skills_matrix_file_path
print(cmd_convert_file)
os.system(cmd_convert_file)
#
#
# import com.github.mrpowers.spark.daria.sql.DariaWriters
# DariaWriters.writeSingleFile( df = engineer_matrix_skills , format = "csv", sc = sc, tmpFolder = "skils_matrix_tmp/", filename = skills_matrix_file)
#
print(" ------ Matrix Skills File Generated for Engineer ----- ")

sqlContext.stop()
#
##
#
###
#########
###
##
#
