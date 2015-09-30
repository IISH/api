<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:strikes="http://api.socialhistoryservices.org/strikes/1/"
                xmlns:iisg="http://www.iisg.nl/api/sru/"
                exclude-result-prefixes="strikes iisg">

    <xsl:import href="../../../xslt/insertElement.xsl"/>
    <xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
    <xsl:strip-space elements="*"/>
    <xsl:param name="marc_controlfield_005"/>
    <xsl:param name="marc_controlfield_008"/>
    <xsl:param name="date_modified"/>
    <xsl:param name="collectionName"/>
    <xsl:variable name="prefix" select="'strikes'"/>

    <xsl:template match="Iisg">

        <xsl:variable name="identifier" select="@stakingid"/>

        <record>
            <extraRecordData><iisg:iisg>
                <xsl:call-template name="insertIISHIdentifiers">
                        <xsl:with-param name="identifier" select="concat($prefix, ':', $identifier)"/>
                    </xsl:call-template>
                <xsl:call-template name="insertCollection">
                        <xsl:with-param name="collection" select="$collectionName"/>
                    </xsl:call-template>
                <iisg:isShownAt><xsl:value-of select="concat('http://search.iisg.nl/search/search?action=transform&amp;col=strikes&amp;xsl=strikes-detail.xsl&amp;lang=en&amp;docid=', $identifier)"/></iisg:isShownAt>
                <iisg:date_modified>
                    <xsl:value-of select="$date_modified"/>
                </iisg:date_modified></iisg:iisg>
            </extraRecordData>
            <recordData>
                <strikes:strikes>
                    <xsl:apply-templates select="node()"/>
                </strikes:strikes>
            </recordData>
        </record>
    </xsl:template>

    <xsl:template match="node()">
        <xsl:if test="string-length(local-name(.))>0">
            <xsl:element name="{concat($prefix, ':', local-name())}">
                <xsl:copy-of select="@*" />
                <xsl:copy-of select="text()" />
                <xsl:apply-templates select="node()"/>
            </xsl:element>
        </xsl:if>
    </xsl:template>

    <xsl:template match="lang">
        <strikes:lang>
        <xsl:attribute name="code">
            <xsl:choose>
                <xsl:when test="@code='nl'">nl-NL</xsl:when>
                <xsl:when test="@code='en'">en-US</xsl:when>
                <xsl:when test="@code='fr'">fr-FR</xsl:when>
                <xsl:otherwise>en-US</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <xsl:value-of select="text()"/></strikes:lang>
    </xsl:template>

</xsl:stylesheet>