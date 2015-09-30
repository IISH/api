<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:iisg="http://www.iisg.nl/api/sru/"
                exclude-result-prefixes="marc iisg">

    <xsl:import href="../../../xslt/insertElement.xsl"/>
    <xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
    <xsl:strip-space elements="*"/>
    <xsl:param name="marc_controlfield_005"/>
    <xsl:param name="marc_controlfield_008"/>
    <xsl:param name="date_modified"/>
    <xsl:param name="collectionName"/>

    <xsl:template match="record">

        <xsl:variable name="identifier" select="concat('zaansmuseum:afbeeldingen:1:', recordid)"/>
        <xsl:variable name="isShownBy"
                      select="concat('http://webstore.iisg.nl/zaansmuseum.afbeeldingen.1/', recordid, '.jpg')"/>
        <xsl:variable name="isShownAt" select="'http://www.zaansmuseum.nl/'"/>
        <xsl:variable name="static852b" select="'Zaans Museum'"/>
        <xsl:variable name="static655a" select="'object'"/>

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
                        <xsl:value-of select="$isShownAt"/>
                    </iisg:isShownAt>
                    <iisg:isShownBy>
                        <xsl:value-of select="$isShownBy"/>
                    </iisg:isShownBy>
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
                    <xsl:apply-templates/>

                    <xsl:call-template name="insertElement">
                        <xsl:with-param name="tag" select="'852'"/>
                        <xsl:with-param name="code" select="'b'"/>
                        <xsl:with-param name="value" select="$static852b"/>
                    </xsl:call-template>

                    <xsl:call-template name="insertElement">
                        <xsl:with-param name="tag" select="'655'"/>
                        <xsl:with-param name="code" select="'a'"/>
                        <xsl:with-param name="value" select="$static655a"/>
                    </xsl:call-template>

                </marc:record>
            </recordData>
        </record>
    </xsl:template>

    <xsl:template match="titel">
        <xsl:call-template name="marc_elements">
            <xsl:with-param name="tag" select="'245'"/>
            <xsl:with-param name="code" select="'a'"/>
            <xsl:with-param name="values" select="."/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="datering">
        <xsl:call-template name="marc_elements">
            <xsl:with-param name="tag" select="'260'"/>
            <xsl:with-param name="code" select="'g'"/>
            <xsl:with-param name="values" select="."/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="beschrijving">
        <xsl:call-template name="marc_elements">
            <xsl:with-param name="tag" select="'500'"/>
            <xsl:with-param name="code" select="'a'"/>
            <xsl:with-param name="values" select="."/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="tags">
        <xsl:call-template name="marc_elements">
            <xsl:with-param name="tag" select="'650'"/>
            <xsl:with-param name="code" select="'a'"/>
            <xsl:with-param name="values" select="."/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="image-type">
        <xsl:call-template name="marc_elements">
            <xsl:with-param name="tag" select="'655'"/>
            <xsl:with-param name="code" select="'a'"/>
            <xsl:with-param name="values" select="."/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="node()"/>

</xsl:stylesheet>