<?xml version="1.0" encoding="UTF-8"?>
<!--
Copyright 2010 International Institute for Social History, The Netherlands.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns="http://www.openarchives.org/OAI/2.0/">

    <xsl:import href="oai.xsl"/>
    <xsl:param name="prefix"/>

    <xsl:template name="header">
        <header>
            <identifier>
                <xsl:value-of select="concat($prefix, $doc//str[@name='iisg_identifier'])"/>
            </identifier>
            <datestamp>
                <xsl:value-of select="$doc//date[@name='iisg_date_modified']"/>
            </datestamp>
            <xsl:for-each select="$doc//arr[@name='iisg_collectionName']/str">
                <setSpec>
                    <xsl:value-of select="."/>
                </setSpec>
            </xsl:for-each>
        </header>
    </xsl:template>

    <xsl:template name="metadata">
        <metadata>
            <xsl:copy-of select="$doc"/>
        </metadata>
    </xsl:template>

    <xsl:template name="about"/>

</xsl:stylesheet>