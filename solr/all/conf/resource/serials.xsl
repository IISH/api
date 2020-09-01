<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ead="urn:isbn:1-931666-22-9"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

    <xsl:output method="xml" encoding="UTF-8" omit-xml-declaration="yes"/>
    <xsl:strip-space elements="*"/>

    <xsl:template match="ead:ead">
        <ead:ead xmlns:ead="urn:isbn:1-931666-22-9" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                 xsi:schemaLocation="urn:isbn:1-931666-22-9 https://www.loc.gov/ead/ead.xsd http://www.w3.org/1999/xlink http://www.loc.gov/standards/xlink/xlink.xsd">
            <xsl:apply-templates/>
        </ead:ead>
    </xsl:template>

    <xsl:template match="node()">
        <xsl:choose>
            <xsl:when test="@audience = 'internal'">
                <xsl:comment>
                    <xsl:value-of select="local-name()"/> removed.
                </xsl:comment>
            </xsl:when>
            <xsl:when test="string-length(local-name()) > 0">
                <xsl:element name="{concat('ead:',local-name())}" namespace="urn:isbn:1-931666-22-9">
                    <xsl:copy-of select="attribute::*"/>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>