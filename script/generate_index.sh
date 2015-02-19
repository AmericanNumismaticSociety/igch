#!/bin/sh
#Create dumps
cd /usr/local/projects/igch
echo "Generating XHTML dump"
echo "<body>" > dump.xml
cat data/*.xml >> dump.xml
echo "</body>" >> dump.xml
echo "Stripping XML declaration"
sed -i 's/<?xml\ version=\"1\.0\"\ encoding=\"UTF-8\"?>//g' dump.xml
echo "Creating Solr add doc"
java -jar script/saxon9.jar -s:dump.xml -o:solr.xml -xsl:ui/xslt/serializations/xhtml/solr.xsl

#Post to Solr
echo "Posting Solr add doc"
INDEX=http://localhost:8080/solr/igch/update
curl $INDEX --data-binary @solr.xml -H 'Content-type:text/xml; charset=utf-8'
curl $INDEX --data-binary '<commit/>' -H 'Content-type:text/xml; charset=utf-8'
echo "Done. Cleaning up."
rm dump.xml
rm solr.xml