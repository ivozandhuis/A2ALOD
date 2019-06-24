#!/bin/bash

# transform A2A XML into RDF/XML
for xml_file in data/*.a2a.xml
do
        rdf_file=$(basename -- "$xml_file")
        xsltproc -o data/${rdf_file%%.*}.rdf.xml a2aLOD.xslt $xml_file
done

# serialize RDF/XML into turtle for the ultimate test
for rdf_file in data/*.rdf.xml
do
        ttl_file=$(basename -- "$rdf_file")
        rapper -q -o turtle $rdf_file > data/${ttl_file%%.*}.ttl
done