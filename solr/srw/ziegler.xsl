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
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:ziegler="http://api.socialhistoryservices.org/ziegler/1/"
                xmlns:iisg="http://www.iisg.nl/api/sru/"
                xmlns:zr="http://explain.z3950.org/dtd/2.0/"
                xmlns:srw="http://www.loc.gov/zing/srw/"
                xmlns:ns2="http://oclc.org/srw/extraData"
                exclude-result-prefixes="ziegler iisg zr saxon srw ns2"
        >

    <xsl:import href="listitem.xsl"/>
    <xsl:strip-space elements="*"/>
    <xsl:variable name="maximumRecords"
                  select="/srw:searchRetrieveResponse/srw:echoedSearchRetrieveRequest/srw:maximumRecords"/>
    <xsl:param name="lang"/>
    <xsl:variable name="langUsage" select="response/lst[@name='solrparams']/str[@name='lang']"/>

    <xsl:template match="response">

        <xsl:variable name="record" select="saxon:parse(//doc/str[@name='resource']/text())/node()"/>
        <xsl:variable name="transport" select="str[@name='transport']/text()"/>
        <xsl:variable name="header" select="$record/extraRecordData"/>
        <xsl:variable name="metadata" select="$record/recordData"/>

        <!-- This is how the record inside the recordData will look like. -->
        <record>
            <recordData>
                <xsl:choose>
                    <xsl:when test="$transport='JSON'">
                        <xsl:apply-templates select="$metadata/ziegler:ziegler"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy-of select="$metadata/ziegler:ziegler"/>
                    </xsl:otherwise>
                </xsl:choose>
            </recordData>
            <xsl:choose>
                <xsl:when test="$transport='JSON'">
                    <extraRecordData>
                        <langUsage>
                            <xsl:value-of select="$langUsage"/>
                        </langUsage>
                        <Identifier>
                            <xsl:value-of select="$header/*/iisg:identifier"/>
                        </Identifier>
                    </extraRecordData>
                </xsl:when>
                <xsl:otherwise>
                    <extraRecordData>
                        <xsl:copy-of select="$header/*/*"/>
                        <langUsage>
                            <xsl:value-of select="$langUsage"/>
                        </langUsage>
                    </extraRecordData>
                    <Identifier>
                        <xsl:value-of select="$header/*/iisg:identifier"/>
                    </Identifier>
                </xsl:otherwise>
            </xsl:choose>
        </record>

    </xsl:template>

    <xsl:template match="ziegler:ziegler">
        <dl>
            <xsl:apply-templates/>
        </dl>
    </xsl:template>

    <!--<xsl:template match="ziegler:Signatur">
        <xsl:call-template name="listitem">
            <xsl:with-param name="index">Signatur</xsl:with-param>
            <xsl:with-param name="value">
                <xsl:apply-templates select="ziegler:lang[@code=$lang]"/>
            </xsl:with-param>
            <xsl:with-param name="explain" select="document('explain.ziegler.en.xml')"/>
            <xsl:with-param name="lang" select="$lang"/>
            <xsl:with-param name="recordSchema" select="'info:srw/schema/1/ziegler'"/>
            <xsl:with-param name="maximumRecords" select="$maximumRecords"/>
            <xsl:with-param name="relation" select="'exact'"/>
            <xsl:with-param name="query" select="true()"/>
            <xsl:with-param name="shortlist" select="'yes'"/>
        </xsl:call-template>

    </xsl:template>-->

    <xsl:template match="node()">

        <xsl:variable name="recordSchema" select="../../../srw:recordSchema"/>
        <xsl:variable name="maximumRecords"
                      select="/srw:searchRetrieveResponse/srw:echoedSearchRetrieveRequest/srw:maximumRecords"/>
        <xsl:variable name="tmp_lang" select="../../../srw:extraRecordData/ns2:extraData/ns2:langUsage"/>
        <xsl:variable name="lang">
            <xsl:if test="string-length($tmp_lang)=0">
                <xsl:value-of select="$langUsage"/>
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="yesno">
            <xsl:choose>
                <xsl:when test="local-name()='Jahr' or local-name()='Namen' or local-name()='Vornamen' or local-name()='Amt' or local-name()='Ortschaft' or local-name()='Wohin'">yes</xsl:when>
                <xsl:otherwise>no</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:call-template name="listitem">
            <!--<xsl:choose>-->
            <xsl:with-param name="value" select="text()"/>
 <!-- <xsl:when test="local-name()='Folio'>
            </xsl:choose>
 "http://www.iisg.nl/migration/ziegler/l77a-$Signatur.php?f=$Folio -->
            <xsl:with-param name="index" select="local-name()"/>
            <xsl:with-param name="explain" select="document('explain.ziegler.xml')"/>
            <xsl:with-param name="lang">
                <xsl:choose>
                    <xsl:when test="string-length($lang)=0">en-US</xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$lang"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:with-param>
            <xsl:with-param name="recordSchema" select="$recordSchema"/>
            <xsl:with-param name="maximumRecords" select="$maximumRecords"/>
            <xsl:with-param name="relation" select="'exact'"/>
            <xsl:with-param name="query" select="true()"/>
            <xsl:with-param name="shortlist" select="$yesno"/>
        </xsl:call-template>

    </xsl:template>

</xsl:stylesheet>