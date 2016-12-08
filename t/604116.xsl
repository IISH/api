<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:marc="http://www.loc.gov/MARC21/slim" exclude-result-prefixes="marc ">

    <xsl:variable name="huidige_titel">[Picture postcard.]</xsl:variable>
    <xsl:variable name="nieuwe_titel">Photograph / </xsl:variable>
    <xsl:variable name="toevoeging_titel" select="normalize-space(marc:record/marc:datafield[@tag='500'][1]/marc:subfield[@code='a'])"/>

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="marc:datafield[@tag='245']/marc:subfield[@code='a' and text()=$huidige_titel]/text()">
        <xsl:choose>
            <xsl:when test="string-length($toevoeging_titel)=0"><xsl:value-of select="text()"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="concat($nieuwe_titel, $toevoeging_titel)"/></xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="marc:datafield[@tag='500']"/>

</xsl:stylesheet>