<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:iisg="http://www.iisg.nl/api/sru/"
                exclude-result-prefixes="marc iisg">

    <xsl:import href="../../../xslt/insertElement.xsl"/>
    <xsl:output method="xml" indent="no" omit-xml-declaration="yes" />
    <xsl:strip-space elements="*" />
    <xsl:param name="marc_controlfield_005" />
    <xsl:param name="marc_controlfield_008" />
    <xsl:param name="date_modified" /><xsl:param name="collectionName"/>

    <xsl:template match="record">

        <xsl:variable name="identifier" select="concat('continium:afbeeldingen:1:', Recordid)"/>
        <xsl:variable name="aFotonummer" select="Fotonummer"/>
        <xsl:variable name="isShownBy" select="concat('http://webstore.iisg.nl/continium.afbeeldingen.1/', $aFotonummer, '.jpg')" />
        <xsl:variable name="isShownAt" select="'http://www.continium.nl/'" />

        <record>
            <extraRecordData><iisg:iisg>
                <xsl:call-template name="insertIISHIdentifiers">
                        <xsl:with-param name="identifier" select="$identifier"/>
                    </xsl:call-template>
                <xsl:call-template name="insertCollection">
                        <xsl:with-param name="collection" select="$collectionName"/>
                    </xsl:call-template>
                <iisg:isShownAt><xsl:value-of select="$isShownAt"/></iisg:isShownAt>
                <iisg:isShownBy><xsl:value-of select="$isShownBy"/></iisg:isShownBy>
                <iisg:date_modified>
                        <xsl:call-template name="insertDateModified">
                            <xsl:with-param name="cfDate" select="marc:controlfield[@tag='005']"/>
                            <xsl:with-param name="fsDate" select="$date_modified"/>
                        </xsl:call-template>
                    </iisg:date_modified>
            </iisg:iisg></extraRecordData>
            <recordData>
                <marc:record xmlns:marc="http://www.loc.gov/MARC21/slim">
                    <marc:controlfield tag="001"><xsl:value-of select="$identifier"/></marc:controlfield>
                    <xsl:apply-templates />

                    <xsl:call-template name="insertElement">
                        <xsl:with-param name="tag" select="'856'"/>
                        <xsl:with-param name="code" select="'u'"/>
                        <xsl:with-param name="value" select="$isShownBy"/>
                    </xsl:call-template>

                </marc:record>
            </recordData>
        </record>
    </xsl:template>

    <xsl:template match="Fotonummer">
        <xsl:call-template name="marc_elements">
            <xsl:with-param name="tag" select="'852'"/>
            <xsl:with-param name="code" select="'p'"/>
            <xsl:with-param name="values" select="."/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="Titel">
        <xsl:call-template name="marc_elements">
            <xsl:with-param name="tag" select="'245'"/>
            <xsl:with-param name="code" select="'a'"/>
            <xsl:with-param name="values" select="."/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="Beschrijving">
        <xsl:call-template name="marc_elements">
            <xsl:with-param name="tag" select="'500'"/>
            <xsl:with-param name="code" select="'a'"/>
            <xsl:with-param name="values" select="."/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="Datering">
        <xsl:call-template name="marc_elements">
            <xsl:with-param name="tag" select="'260'"/>
            <xsl:with-param name="code" select="'c'"/>
            <xsl:with-param name="values" select="."/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="Materiaalsoort">
        <xsl:call-template name="marc_elements">
            <xsl:with-param name="tag" select="'655'"/>
            <xsl:with-param name="code" select="'a'"/>
            <xsl:with-param name="values" select="."/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="Instelling">
        <xsl:call-template name="marc_elements">
            <xsl:with-param name="tag" select="'852'"/>
            <xsl:with-param name="code" select="'b'"/>
            <xsl:with-param name="values" select="."/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="node()"/>

    <xsl:template name="marc_elements">
        <xsl:param name="tag"/>
        <xsl:param name="code"/>
        <xsl:param name="values"/>
        <xsl:for-each select="$values/value">
            <xsl:call-template name="insertElement">
            <xsl:with-param name="tag" select="$tag"/>
            <xsl:with-param name="code" select="$code"/>
            <xsl:with-param name="value" select="text()"/>
        </xsl:call-template>
        </xsl:for-each>
        <xsl:if test="not($values/value)">
            <xsl:call-template name="insertElement">
            <xsl:with-param name="tag" select="$tag"/>
            <xsl:with-param name="code" select="$code"/>
            <xsl:with-param name="value" select="$values/text()"/>
        </xsl:call-template>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>

        