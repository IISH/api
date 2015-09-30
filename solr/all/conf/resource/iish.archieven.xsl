<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes"/>
    <xsl:strip-space elements="*" />

    <xsl:template match="node()">
        <xsl:choose>
            <xsl:when test="@audience = 'internal'">
                <xsl:comment><xsl:value-of select="local-name()"/> removed.</xsl:comment>
            </xsl:when>
            <xsl:when test="string-length(local-name()) > 0">
                <xsl:element name="{concat('ead:',local-name())}" namespace="urn:isbn:1-931666-22-9">
                    <xsl:copy-of select="attribute::*"/>
                    <xsl:apply-templates select="node()"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="node()"/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

<!--
    <xsl:template match="text()">
        <xsl:copy-of select="."/>
    </xsl:template>
-->

</xsl:stylesheet>