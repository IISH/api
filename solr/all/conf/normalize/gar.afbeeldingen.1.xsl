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
    <xsl:param name="date_modified"/><xsl:param name="collectionName"/>

    <xsl:template match="Record">

        <xsl:variable name="identifier" select="concat('gar:afbeeldingen:1:', Catalogusnr)"/>

        <record>
            <extraRecordData>
                <iisg:iisg>
                    <xsl:call-template name="insertIISHIdentifiers">
                        <xsl:with-param name="identifier" select="$identifier"/>
                    </xsl:call-template>
                    <xsl:call-template name="insertCollection">
                        <xsl:with-param name="collection" select="$collectionName"/>
                    </xsl:call-template>
                    <iisg:isShownAt>http://www.gemeentearchief.rotterdam.nl/content/index.php?option=com_wrapper&amp;Itemid=148</iisg:isShownAt>
                    <iisg:isShownBy>
                        <xsl:value-of
                                select="concat('http://webstore.iisg.nl/gar.afbeeldingen.1/', Catalogusnr/text(), '.jpg')"/>
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
                    <marc:datafield tag="540">
                        <marc:subfield code="b">Gemeentearchief Rotterdam</marc:subfield>
                    </marc:datafield>
                    <marc:datafield tag="852">
                        <marc:subfield code="b">Gemeentearchief Rotterdam</marc:subfield>
                    </marc:datafield>
                </marc:record>
            </recordData>
        </record>
    </xsl:template>

    <xsl:template match="Trefwoorden">
        <xsl:variable name="subjects" select="tokenize(text(), ';')"/>
        <xsl:for-each select="$subjects">
            <xsl:call-template name="insertElement">
                <xsl:with-param name="tag" select="'650'"/>
                <xsl:with-param name="code" select="'a'"/>
                <xsl:with-param name="value" select="."/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="Documenttype">
        <xsl:call-template name="insertElement">
            <xsl:with-param name="tag" select="'655'"/>
            <xsl:with-param name="code" select="'a'"/>
            <xsl:with-param name="value" select="text()"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="Beschrijving | Annotatie">
        <xsl:call-template name="insertElement">
            <xsl:with-param name="tag" select="'500'"/>
            <xsl:with-param name="code" select="'a'"/>
            <xsl:with-param name="value" select="text()"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="Inhoudsdatering_vroegst">
        <xsl:call-template name="insertElement">
            <xsl:with-param name="tag" select="'260'"/>
            <xsl:with-param name="code" select="'c'"/>
            <xsl:with-param name="value" select="text()"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="Inhoudsdatering_laatst">
        <xsl:call-template name="insertElement">
            <xsl:with-param name="tag" select="'260'"/>
            <xsl:with-param name="code" select="'g'"/>
            <xsl:with-param name="value" select="text()"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="Img_src">
        <xsl:if test="contains(text(), 'http')">
            <xsl:call-template name="insertElement">
                <xsl:with-param name="tag" select="'856'"/>
                <xsl:with-param name="code" select="'u'"/>
                <xsl:with-param name="value" select="text()"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <xsl:template match="node()"/>

</xsl:stylesheet>