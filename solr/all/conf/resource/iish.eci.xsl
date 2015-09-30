<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:eci="urn:eci">

    <xsl:output method="xml" encoding="UTF-8"/>

    <!-- Change the odd Iisg header -->
    <xsl:template match="Iisg">
            <xsl:apply-templates select="node()"/>
    </xsl:template>

    <xsl:template match="node()">
        <xsl:choose>
            <xsl:when test="local-name()">
                <xsl:element name="{concat('eci:',local-name())}" namespace="urn:eci">
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

    <xsl:template match="text()">
        <xsl:copy-of select="."/>
    </xsl:template>

</xsl:stylesheet>