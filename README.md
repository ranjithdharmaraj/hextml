Hextml
======

We have two (admittedly not very clean) .xml files - taxonomy.xml holds the information about how 
destinations are related to each other and destinations.xml holds the actual text content for each destination.

Hextml is a batch processor that takes these input files and produces an .html file (based on the output template
given) for each destination. 

Each generated web page has:
1. Some destination content. 
2. Navigation that allows the user to browse to destinations that are higher in the taxonomy. 
   For example, Beijing should have a link to China.
3. Navigation that allows the user to browse to destinations that are lower in the taxonomy. 
   For example, China should have a link to Beijing.

The batch processor should take the location of the two input files and the output directory as parameters.


Execution
=========

The processor is scheduled as a rake task "bundle exec rake process_xml" or simply "bundle exec rake"
