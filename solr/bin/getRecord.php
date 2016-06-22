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
    file_put_contents($catalog_file, $xml);
?>