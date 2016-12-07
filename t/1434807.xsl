<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:marc="http://www.loc.gov/MARC21/slim" exclude-result-prefixes="marc ">

    <xsl:variable name="huidige_titel">[Jaarverslag = Annual report.]</xsl:variable>
    <xsl:variable name="toevoeging_titel_a" select="normalize-space(marc:record/marc:datafield[@tag='710'][1]/marc:subfield[@code='a'])"/>
    <xsl:variable name="toevoeging_titel_b" select="normalize-space(marc:record/marc:datafield[@tag='710'][1]/marc:subfield[@code='b'])"/>

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="marc:datafield[@tag='245']/marc:subfield[@code='a' and text()=$huidige_titel]">
        <xsl:choose>
            <xsl:when test="string-length($toevoeging_titel_a)=0"><xsl:value-of select="text()"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="normalize-space(concat(text(),' / ', $toevoeging_titel_a, ' ', $toevoeging_titel_b))"/></xsl:otherwise>
        </xsl:choose>

    </xsl:template>


</xsl:stylesheet>