<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet
        version="2.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:marc="http://www.loc.gov/MARC21/slim"
        xmlns:ead="urn:isbn:1-931666-22-9"
        xmlns:iisg="http://www.iisg.nl/api/sru/" xmlns:xls="http://www.w3.org/1999/XSL/Transform"
        exclude-result-prefixes="iisg marc">


    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- taalcodes -->
    <xsl:template match="ead:language[@langcode='dut']/text()" mode="ead">Dutch</xsl:template>
    <xsl:template match="ead:language[@langcode='spa']/text()" mode="ead">Spanish</xsl:template>


    <xsl:template match="ead:ead">
        <ead:ead xmlns:ead="urn:isbn:1-931666-22-9" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="https://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="urn:isbn:1-931666-22-9 https://www.loc.gov/ead/ead.xsd http://www.w3.org/1999/xlink https://www.w3.org/1999/xlink.xsd">
            <xsl:apply-templates mode="ead"/>
        </ead:ead>
    </xsl:template>

    <xsl:template match="node() | @*" mode="ead">
        <xsl:choose>
            <xsl:when test="string-length(local-name())=0">
                <xsl:copy>
                    <xsl:apply-templates select="node()|@*" mode="ead" />
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="ead:{local-name()}">
                    <xsl:copy-of select="@*"/>
                    <xsl:apply-templates mode="ead" />
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
