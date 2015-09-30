<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet
        version="2.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:eci="urn:eci"
        xmlns:marc="http://www.loc.gov/MARC21/slim"
        xmlns:iisg="http://www.iisg.nl/api/sru/"
        exclude-result-prefixes="eci iisg">

    <xsl:import href="../../../xslt/insertElement.xsl"/>
    <xsl:import href="../../../xslt/punctionation.xsl"/>
    <xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
    <xsl:strip-space elements="*"/>
    <xsl:param name="marc_controlfield_005"/>
    <xsl:param name="marc_controlfield_008"/>
    <xsl:param name="date_modified"/><xsl:param name="collectionName"/>

    <xsl:template match="Iisg">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="eci">

        <xsl:variable name="identifier"
                      select="concat(meta/lcn, '_ECI')"/>

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
                                select="concat('http://hdl.handle.net/', $identifier)"/>
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

                    <xsl:variable name="materialtype_t" select="meta/materialtype/@name"/>
                    <xsl:variable name="materialtype">
                        <xsl:choose>
                            <xsl:when test="$materialtype_t='BK'">pm</xsl:when>
                            <xsl:when test="$materialtype_t='SE'">as</xsl:when>
                            <xsl:when test="$materialtype_t='MU'">im</xsl:when>
                            <xsl:when test="$materialtype_t='DO'">oc</xsl:when>
                            <xsl:when test="$materialtype_t='VM'">km</xsl:when>
                            <xsl:when test="$materialtype_t='AM'">pc</xsl:when>
                            <xsl:otherwise>am</xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>

                    <marc:leader>
                        <xsl:value-of select="concat('00742n', $materialtype, ' a22001930a 45 0')"/>
                    </marc:leader>

                    <marc:controlfield tag="001">
                        <xsl:value-of select="$identifier"/>
                    </marc:controlfield>

                    <xsl:variable name="geogname_t" select="meta/country"/>
                    <xsl:variable name="geogname">
                        <xsl:choose>
                            <xsl:when test="$geogname_t">
                                <xsl:value-of select="$geogname_t"/>
                            </xsl:when>
                            <xsl:otherwise>nl</xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <marc:controlfield tag="008">
                        <xsl:value-of
                                select="concat('199507suuuuuuuu', $geogname,' |||||||||||||||||','   ',' d')"/>
                    </marc:controlfield>

                    <xsl:if test="meta/language">
                        <xsl:call-template name="insertElement">
                            <xsl:with-param name="tag" select="'041'"/>
                            <xsl:with-param name="code" select="'a'"/>
                            <xsl:with-param name="value" select="meta/language"/>
                        </xsl:call-template>
                    </xsl:if>

                    <marc:datafield tag="245" ind1=" " ind2=" ">
                        <marc:subfield code="a">
                            <xsl:value-of select="body/title"/>
                        </marc:subfield>
                    </marc:datafield>

                    <xsl:variable name="material_t" select="meta/material/@name"/>
                    <xsl:if test="$material_t">
                        <xsl:variable name="cap" select="translate( substring($material_t, 1, 1) ,
                        'abcdefghijklmnopqrstuvxxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ' )"/>
                        <xsl:variable name="rest" select="substring($material_t, 2)"/>
                        <xsl:call-template name="insertElement">
                            <xsl:with-param name="tag" select="'655'"/>
                            <xsl:with-param name="code" select="'a'"/>
                            <xsl:with-param name="value" select="concat($cap, $rest)"/>
                        </xsl:call-template>
                    </xsl:if>

                    <xsl:if test="$geogname_t">
                        <xsl:call-template name="insertElement">
                            <xsl:with-param name="tag" select="'651'"/>
                            <xsl:with-param name="code" select="'a'"/>
                            <xsl:with-param name="value" select="$geogname"/>
                        </xsl:call-template>
                    </xsl:if>

                    <xsl:call-template name="insertElement">
                        <xsl:with-param name="tag" select="'856'"/>
                        <xsl:with-param name="code" select="'u'"/>
                        <xsl:with-param name="value"
                                        select="concat('http://api.socialhistoryservices.org/solr/all/oai?verb=GetRecord&amp;identifier=oai:socialhistoryservices.org:',$identifier,'&amp;metadataPrefix=eci')"/>
                    </xsl:call-template>

                    <xsl:call-template name="insertElement">
                        <xsl:with-param name="tag" select="'902'"/>
                        <xsl:with-param name="code" select="'a'"/>
                        <xsl:with-param name="value" select="$identifier"/>
                    </xsl:call-template>

                </marc:record>
            </recordData>
        </record>

    </xsl:template>

</xsl:stylesheet>