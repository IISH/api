<?php
    /**
     * getrecord
     *
     * Take out and write the metadata contents of an OAI2 response.
     */
    
    $options = getopt("f:");
    $catalog_file = $options['f'];
    
    
    $xml = file_get_contents ( $catalog_file );
    $xml = preg_replace('/(.*<metadata>)|(<\/metadata>.*)/m', '', $xml);
    print('xml=' . $xml);
    # Write the document
    file_put_contents($catalog_file, '<?xml version="1.0" encoding="UTF-8"?><marc:catalog xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.loc.gov/MARC21/slim http://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd">');
    file_put_contents($catalog_file, $xml, FILE_APPEND);
    file_put_contents($catalog_file, '</marc:catalog>', FILE_APPEND);
?>