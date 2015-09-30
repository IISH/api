<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet
        version="2.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:ead="urn:isbn:1-931666-22-9"
        xmlns:marc="http://www.loc.gov/MARC21/slim"
        xmlns:iisg="http://www.iisg.nl/api/sru/"
        exclude-result-prefixes="ead iisg">

    <xsl:import href="../../../xslt/insertElement.xsl"/>
    <xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
    <xsl:strip-space elements="*"/>
    <xsl:param name="marc_controlfield_005"/>
    <xsl:param name="marc_controlfield_008"/>
    <xsl:param name="date_modified"/><xsl:param name="collectionName"/>

    <xsl:template match="ead">

        <xsl:variable name="identifier" select="eadheader/eadid"/>

        <record>
            <extraRecordData>
                <iisg:iisg>
                    <xsl:call-template name="insertIISHIdentifiers">
                        <xsl:with-param name="identifier" select="$identifier"/>
                    </xsl:call-template>
                    <xsl:call-template name="insertCollection">
                        <xsl:with-param name="collection" select="$collectionName"/>
                    </xsl:call-template>
                    <iisg:isShownAt>
                        <xsl:value-of
                                select="//eadgrp/archdescgrp/dscgrp/ead/archdesc/did/repository/address/addressline[@ID='URL']"/>
                    </iisg:isShownAt>
                    <iisg:date_modified>
                        <xsl:call-template name="insertDateModified">
                            <xsl:with-param name="cfDate" select="marc:controlfield[@tag='005']"/>
                            <xsl:with-param name="fsDate" select="$date_modified"/>
                        </xsl:call-template>
                    </iisg:date_modified>
                </iisg:iisg>
            </extraRecordData>

            <recordData>
                <marc:record xmlns:marc="http://www.loc.gov/MARC21/slim">

                    <marc:controlfield tag="001">
                        <xsl:value-of select="//eadgrp/archdescgrp/dscgrp/ead/archdesc/did/unitid"/>
                    </marc:controlfield>

                    <xsl:call-template name="insertElement">
                        <xsl:with-param name="tag" select="'245'"/>
                        <xsl:with-param name="code" select="'a'"/>
                        <xsl:with-param name="value" select="//eadgrp/archdescgrp/dscgrp/ead/archdesc/did/unittitle"/>
                    </xsl:call-template>

                    <xsl:call-template name="insertElement">
                        <xsl:with-param name="tag" select="'245'"/>
                        <xsl:with-param name="code" select="'f'"/>
                        <xsl:with-param name="value" select="concat(//eadgrp/archdescgrp/dscgrp/ead/eadheader/filedesc/titlestmt/titleproper/date[@ID='from'],' - ',
						 //eadgrp/archdescgrp/dscgrp/ead/eadheader/filedesc/titlestmt/titleproper/date[@ID='to'])"/>
                    </xsl:call-template>

                    <xsl:for-each select="//eadgrp/archdescgrp/dscgrp/ead/archdesc/did/index/indexentry/name">
                        <xsl:call-template name="insertElement">
                            <xsl:with-param name="tag" select="'650'"/>
                            <xsl:with-param name="code" select="'a'"/>
                            <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                    </xsl:for-each>

                    <xsl:call-template name="insertElement">
                        <xsl:with-param name="tag" select="'655'"/>
                        <xsl:with-param name="code" select="'a'"/>
                        <xsl:with-param name="value" select="'archief'"/>
                    </xsl:call-template>

                    <xsl:call-template name="insertElement">
                        <xsl:with-param name="tag" select="'852'"/>
                        <xsl:with-param name="code" select="'a'"/>
                        <xsl:with-param name="value"
                                        select="//eadgrp/archdescgrp/dscgrp/ead/archdesc/did/repository/corpname"/>
                    </xsl:call-template>

                    <xsl:call-template name="insertElement">
                        <xsl:with-param name="tag" select="'856'"/>
                        <xsl:with-param name="code" select="'u'"/>
                        <xsl:with-param name="value"
                                        select="//eadgrp/archdescgrp/dscgrp/ead/archdesc/did/repository/address/addressline[@ID='URL']"/>
                    </xsl:call-template>

                </marc:record>
            </recordData>
        </record>

    </xsl:template>

</xsl:stylesheet>
