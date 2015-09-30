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
                xmlns:mets="http://www.loc.gov/METS/"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:iisg="http://www.iisg.nl/api/sru/"
                xmlns:zr="http://explain.z3950.org/dtd/2.0/"
                xmlns:srw="http://www.loc.gov/zing/srw/"
                xmlns:ns2="http://oclc.org/srw/extraData"
                exclude-result-prefixes="mets xlink iisg zr saxon srw ns2"
        >

    <xsl:import href="listitem.xsl"/>
    <xsl:strip-space elements="*"/>
    <xsl:variable name="langUsage" select="response/lst[@name='solrparams']/str[@name='lang']"/>
    <xsl:variable name="metsStartRecord" select="response/lst[@name='solrparams']/str[@name='metsStartRecord']"/>

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
                        <xsl:apply-templates select="$metadata/mets:mets"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy-of select="$metadata/mets:mets"/>
                    </xsl:otherwise>
                </xsl:choose>
            </recordData>
            <xsl:choose>
                <xsl:when test="$transport='JSON'">
                    <extraRecordData>
                        <langUsage><xsl:value-of select="$langUsage"/></langUsage>
                        <Identifier><xsl:value-of select="$header/*/iisg:identifier"/></Identifier>
                    </extraRecordData>
                </xsl:when>
                <xsl:otherwise>
                    <extraRecordData>
                        <xsl:copy-of select="$header/*/*"/>
                        <langUsage>
                            <xsl:value-of select="$langUsage"/>
                        </langUsage>
                        <metsStartRecord>
                            <xsl:value-of select="$metsStartRecord"/>
                            </metsStartRecord>
                    </extraRecordData>
                    <Identifier><xsl:value-of select="$header/*/iisg:identifier"/></Identifier>
                </xsl:otherwise>
            </xsl:choose>
        </record>

    </xsl:template>

    <xsl:template match="mets:mets">

        <xsl:variable name="recordSchema" select="../../../srw:recordSchema"/>
        <xsl:variable name="maximumRecords"
                      select="../../../../srw:searchRetrieveResponse/srw:echoedSearchRetrieveRequest/srw:maximumRecords"/>
        <!-- This is not the SRU startRecord, but the METS pager's -->
        <!--<xsl:variable name="startRecord" select="../../srw:extraRecordData/ns2:extraData/ns2:metsStartRecord"/>-->

        <xsl:variable name="tmp_lang" select="../../../srw:extraRecordData/ns2:extraData/ns2:langUsage"/>
        <xsl:variable name="lang">
            <xsl:if test="string-length($tmp_lang)=0">
                <xsl:value-of select="$langUsage"/>
            </xsl:if>
        </xsl:variable>

        <xsl:variable name="fileSecReference" select="mets:fileSec/mets:fileGrp[@USE='reference']"/>
        <xsl:variable name="fileSecThumbnail" select="mets:fileSec/mets:fileGrp[@USE='thumbnail']"/>

        <xsl:variable name="from">
            <xsl:choose>
                <xsl:when test="string(number($metsStartRecord))='NaN'">1</xsl:when>
                <xsl:otherwise><xsl:value-of select="$metsStartRecord"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="until">
            <xsl:choose>
                <xsl:when test="string(number($maximumRecords))='NaN'"><xsl:value-of select="$from+10"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="$from+$maximumRecords"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <dl>
            <xsl:variable name="dsc" select="mets:dmdSec/mets:mdWrap/mets:xmlData"/>

            <xsl:variable name="ulang">
            <xsl:choose>
                <xsl:when test="string-length($lang)=0">en-US</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$lang"/>
                </xsl:otherwise>
            </xsl:choose>
            </xsl:variable>
            <dt class="label">website</dt>
            <dd><a href="{concat('http://search.iisg.nl/search/search?action=transform&amp;col=archives&amp;xsl=archives-detail.xsl&amp;docid=10767897_EAD&amp;lang=', substring($ulang, 1, 2))}" target="_blank"><xsl:value-of select="document('explain.mets.dorarussell.xml')/zr:explain/zr:databaseInfo/zr:title[@lang=$ulang]/text()"/></a></dd>
            <xsl:for-each select="$dsc/ead/archdesc/dsc/head|$dsc//container">
                <xsl:call-template name="listitem">
                    <xsl:with-param name="value" select="text()"/>
                    <xsl:with-param name="index" select="local-name(.)"/>
                    <xsl:with-param name="explain" select="document('explain.mets.dorarussell.xml')"/>
                    <xsl:with-param name="lang" select="$ulang"/>
                    <xsl:with-param name="recordSchema" select="$recordSchema"/>
                    <xsl:with-param name="maximumRecords" select="$maximumRecords"/>
                    <xsl:with-param name="relation" select="'exact'"/>
                    <xsl:with-param name="query" select="true()"/>
                    <xsl:with-param name="shortlist"/>
                </xsl:call-template>
            </xsl:for-each>

            <xsl:for-each select="$dsc//node()[@level]">
                <xsl:call-template name="listitem">
                    <xsl:with-param name="value" select="did/unittitle//text()|did/unittitle/unitdate//text()"/>
                    <xsl:with-param name="index" select="@level"/>
                    <xsl:with-param name="explain" select="document('explain.mets.dorarussell.xml')"/>
                    <xsl:with-param name="lang" select="$ulang"/>
                    <xsl:with-param name="recordSchema" select="$recordSchema"/>
                    <xsl:with-param name="maximumRecords" select="$maximumRecords"/>
                    <xsl:with-param name="relation" select="'exact'"/>
                    <xsl:with-param name="query" select="true()"/>
                    <xsl:with-param name="shortlist"/>
                </xsl:call-template>
            </xsl:for-each>

            <dt>pages</dt>
            <dd><xsl:value-of select="count(mets:structMap//mets:div[@TYPE='page'])"/></dd>

            <dt class='documents'>documents</dt>
            <xsl:for-each select="mets:structMap//mets:div[@TYPE='page' and position()&gt;=$from and position()&lt;$until]">
                <dd class="label"><xsl:value-of select="@LABEL"/></dd>
                <xsl:for-each select="mets:fptr">
                    <xsl:variable name="FILEID" select="@FILEID"/>
                    <xsl:variable name="hrefThumbnail" select="$fileSecThumbnail/mets:file[@ID=$FILEID]/mets:FLocat/@xlink:href"/>
                    <xsl:variable name="hrefReference" select="$fileSecReference/mets:file[@ID=$FILEID]/mets:FLocat/@xlink:href"/>
                    <xsl:if test="$hrefThumbnail">
                        <dd class="thumbnail"><xsl:value-of select="$hrefThumbnail"/></dd>
                    </xsl:if>
                    <xsl:if test="$hrefReference">
                        <dd class="reference"><xsl:value-of select="$hrefReference"/></dd>
                    </xsl:if>
                    </xsl:for-each>
            </xsl:for-each>
        </dl>

    </xsl:template>

</xsl:stylesheet>