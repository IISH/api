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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <xsl:output omit-xml-declaration="yes"/>

    <!-- Initialize the Solr document variables -->
    <xsl:variable name="doc" select="//doc"/>
    <xsl:variable name="verb" select="//str[@name='verb']/text()"/>

    <xsl:template match="response">
        <xsl:choose>
            <xsl:when test="$verb='GetRecord'">
                <record>
                    <xsl:call-template name="header"/>
                    <xsl:call-template name="metadata"/>
                    <xsl:call-template name="about"/>
                </record>
            </xsl:when>
            <xsl:when test="$verb='ListRecords'">
                <record>
                    <xsl:call-template name="header"/>
                    <xsl:call-template name="metadata"/>
                    <xsl:call-template name="about"/>
                </record>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="header"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="header">
        <header>
            <xsl:if test="$doc//bool[@name='iisg_deleted']='true'">
                <xsl:attribute name="status">deleted</xsl:attribute>
            </xsl:if>
            <identifier>
                <xsl:value-of select="concat($prefix, $doc//str[@name='iisg_identifier'])"/>
            </identifier>
            <datestamp>
                <xsl:choose>
                    <xsl:when test="$doc//date[@name='iisg_date_modified']">
                        <xsl:value-of select="$doc//date[@name='iisg_date_modified']"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$doc//date[@name='iisg_datestamp']"/>
                    </xsl:otherwise>
                </xsl:choose>
            </datestamp>
            <xsl:for-each select="$doc//arr[@name='iisg_collectionName']/str">
                <setSpec>
                    <xsl:value-of select="."/>
                </setSpec>
            </xsl:for-each>
        </header>
    </xsl:template>

    <xsl:template name="about"/>

    <!--
    Usefull for debugging
        <xsl:template match="@*|node()">
            <xsl:copy>
                <xsl:apply-templates select="@*|node()"/>
            </xsl:copy>
        </xsl:template>
    -->


</xsl:stylesheet>
