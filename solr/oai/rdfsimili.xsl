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
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="2.0"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                exclude-result-prefixes="saxon xlink marc">

    <xsl:import href="oai.xsl"/>
    <xsl:param name="prefix"/>
    <xsl:include href="../xslt/MARC21slimUtils.xsl"/>
    <xsl:include href="MARC21slim2MODS3.xsl"/>
    <xsl:include href="mods2rdf.xslt"/>

    <xsl:template name="metadata">
        <xsl:variable name="record" select="saxon:parse($doc//str[@name='resource']/text())/node()"/>
        <xsl:if test="$record//recordData">
            <metadata>
                <xsl:variable name="t">
                    <xsl:apply-templates mode="n" select="$record//recordData"/>
                </xsl:variable>
                <xsl:variable name="mods">
                    <xsl:for-each select="$t/recordData/*">
                        <mods version="3.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.loc.gov/mods/v3"
                              xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-0.xsd">
                            <xsl:call-template name="marcRecord"/>
                        </mods>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:apply-templates select="$mods"/>
            </metadata>
        </xsl:if>
    </xsl:template>

    <!-- identity template; replace ind1 and ind2 with a blank by a zero -->
    <xsl:template match="@*|node()" mode="n">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()" mode="n"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@ind1[.=' ']|@ind2[.=' ']" mode="n">
        <xsl:attribute name="{local-name()}">0</xsl:attribute>
    </xsl:template>

</xsl:stylesheet>