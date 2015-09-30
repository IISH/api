<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet
        version="2.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:iisg="http://www.iisg.nl/api/sru/"
        xmlns:marc="http://www.loc.gov/MARC21/slim"
        exclude-result-prefixes="marc iisg">

    <xsl:import href="../../../xslt/insertElement.xsl"/>
    <xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
    <xsl:strip-space elements="*"/>
    <xsl:param name="marc_controlfield_005"/>
    <xsl:param name="marc_controlfield_008"/>
    <xsl:param name="date_modified"/><xsl:param name="collectionName"/>

    <xsl:template match="XMLDOCUMENT">

        <xsl:variable name="identifier" select="OWNEROID"/>
        <xsl:variable name="isShownBy"
                      select="concat('http://studiezaal.nijmegen.nl/HttpHandler/icoon.ico?icoonfromxmlbeschr=',$identifier)"/>

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
                        <xsl:value-of select="concat('http://studiezaal.nijmegen.nl/ran/beeldbank.detail.aspx?view=lijst&amp;xmldescid=', $identifier, '&amp;volgnummer=0&amp;globaal=&amp;mode=&amp;uitgebreid_zoeken=true&amp;positie=0')"/>
                    </iisg:isShownAt>
                    <iisg:isShownBy><xsl:value-of select="$isShownBy"/></iisg:isShownBy>
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
                        <xsl:value-of select="$identifier"/>
                    </marc:controlfield>
                    <xsl:call-template name="insertElement">
                        <xsl:with-param name="tag" select="'245'"/>
                        <xsl:with-param name="code" select="'a'"/>
                        <xsl:with-param name="value" select="TITELS"/>
                    </xsl:call-template>
                    <xsl:call-template name="insertElement">
                        <xsl:with-param name="tag" select="'852'"/>
                        <xsl:with-param name="code" select="'h'"/>
                        <xsl:with-param name="value" select="DOCUMENTNUMMER"/>
                    </xsl:call-template>
                    <xsl:call-template name="insertElement">
                        <xsl:with-param name="tag" select="'500'"/>
                        <xsl:with-param name="code" select="'a'"/>
                        <xsl:with-param name="value" select="BESCHRIJVING"/>
                    </xsl:call-template>
                    <xsl:call-template name="insertElement">
                        <xsl:with-param name="tag" select="'100'"/>
                        <xsl:with-param name="code" select="'a'"/>
                        <xsl:with-param name="value" select="AUTEUR"/>
                    </xsl:call-template>
                    <xsl:call-template name="insertElement">
                        <xsl:with-param name="tag" select="'655'"/>
                        <xsl:with-param name="code" select="'a'"/>
                        <xsl:with-param name="value" select="DOCUMENTTYPE"/>
                    </xsl:call-template>
                    <xsl:call-template name="insertElement">
                        <xsl:with-param name="tag" select="'540'"/>
                        <xsl:with-param name="code" select="'b'"/>
                        <xsl:with-param name="value" select="AUTEURSRECHTHOUDER"/>
                    </xsl:call-template>
                    <xsl:call-template name="insertElement">
                        <xsl:with-param name="tag" select="'605'"/>
                        <xsl:with-param name="code" select="'g'"/>
                        <xsl:with-param name="value" select="PLAATSNAAM"/>
                    </xsl:call-template>
                    <xsl:call-template name="insertElement">
                        <xsl:with-param name="tag" select="'260'"/>
                        <xsl:with-param name="code" select="'c'"/>
                        <xsl:with-param name="value" select="concat(DATERING/VROEGST, '-', DATERING/LAATST)"/>
                    </xsl:call-template>
                    <xsl:call-template name="insertElement">
                        <xsl:with-param name="tag" select="'650'"/>
                        <xsl:with-param name="code" select="'a'"/>
                        <xsl:with-param name="value" select="TREFWOORDEN"/>
                    </xsl:call-template>
                    <xsl:call-template name="insertElement">
                        <xsl:with-param name="tag" select="'852'"/>
                        <xsl:with-param name="code" select="'b'"/>
                        <xsl:with-param name="value" select="'Regionaal Archief Nijmegen'"/>
                    </xsl:call-template>
                    <xsl:call-template name="insertElement">
                        <xsl:with-param name="tag" select="'856'"/>
                        <xsl:with-param name="code" select="'u'"/>
                        <xsl:with-param name="value" select="$isShownBy"/>
                    </xsl:call-template>
                </marc:record>

            </recordData>
        </record>
    </xsl:template>

</xsl:stylesheet>