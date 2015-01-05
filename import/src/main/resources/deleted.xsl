<?xml version="1.0" encoding="UTF-8"?>

<!--
Select deleted records
-->

<xsl:stylesheet
        version="1.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:marc="http://www.loc.gov/MARC21/slim">

    <xsl:output method="text"/>

    <xsl:template match="record">
        <xsl:apply-templates select="recordData"/>
    </xsl:template>

    <xsl:template match="recordData">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="marc:record">
<xsl:text>
</xsl:text>
        <xsl:value-of select="marc:controlfield[@tag='001']"/>
    </xsl:template>

</xsl:stylesheet>