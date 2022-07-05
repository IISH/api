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

    <!-- de archivesspace identifier hoeft niet mee -->
    <xsl:template match="@id"/>
    <xsl:template match="ead:language[@langcode='dut']/text()">Dutch</xsl:template>
    <xsl:template match="ead:language[@langcode='spa']/text()">Spanish</xsl:template>

</xsl:stylesheet>
