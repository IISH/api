<?php
    /**
     * getrecord
     *
     * Take out and write the metadata contents of an OAI2 response.
     */
    
    $options = getopt("c:");
    $catalog = $options['c'];
    
    
    $xml = file_get_contents ( $catalog );
    $xml = preg_replace('/(^<metadata>)|(<\/metadata>$)/m', '', $xml);
    
    # Write the document
    file_put_contents($catalog, '<?xml version="1.0" encoding="UTF-8"?><marc:catalog xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.loc.gov/MARC21/slim http://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd">');
    file_put_contents($catalog, $xml, FILE_APPEND);
    file_put_contents($catalog, '</marc:catalog>', FILE_APPEND);
?>