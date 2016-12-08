<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:marc="http://www.loc.gov/MARC21/slim" exclude-result-prefixes="marc ">

    <xsl:variable name="huidige_titel">[Jaarverslag = Annual report.]</xsl:variable>
    <xsl:variable name="nieuwe_titel">[Jaarverslag = Annual report nieuwe titel.]</xsl:variable>
    <xsl:variable name="toevoeging_titel_a"
                  select="normalize-space(marc:record/marc:datafield[@tag='710'][1]/marc:subfield[@code='a'])"/>
    <xsl:variable name="toevoeging_titel_b"
                  select="normalize-space(marc:record/marc:datafield[@tag='710'][1]/marc:subfield[@code='b'])"/>

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="marc:datafield[@tag='245' and marc:subfield[@code='a' and text()=$huidige_titel]]">
        <marc:datafield ind1="{@ind1}" ind2="{@ind2}" tag="245">
            <marc:subfield code="a">
                <xsl:value-of select="$nieuwe_titel"/>
            </marc:subfield>
            <xsl:apply-templates select="marc:subfield[@code='b']"/>
            <xsl:if test="string-length($toevoeging_titel_a) > 0">
                <marc:subfield code="c"><xsl:value-of select="concat($toevoeging_titel_a, ' ', $toevoeging_titel_b)"/></marc:subfield>
            </xsl:if>
            <xsl:apply-templates select="marc:subfield[@code='c']"/>
            <xsl:apply-templates select="marc:subfield[@code='d']"/>
            <xsl:apply-templates select="marc:subfield[@code='e']"/>
            <xsl:apply-templates select="marc:subfield[@code='f']"/>
            <xsl:apply-templates select="marc:subfield[@code='g']"/>
            <xsl:apply-templates select="marc:subfield[@code='h']"/>
            <xsl:apply-templates select="marc:subfield[@code='i']"/>
            <xsl:apply-templates select="marc:subfield[@code='j']"/>
            <xsl:apply-templates select="marc:subfield[@code='k']"/>
            <xsl:apply-templates select="marc:subfield[@code='l']"/>
            <xsl:apply-templates select="marc:subfield[@code='m']"/>
            <xsl:apply-templates select="marc:subfield[@code='n']"/>
            <xsl:apply-templates select="marc:subfield[@code='o']"/>
            <xsl:apply-templates select="marc:subfield[@code='p']"/>
            <xsl:apply-templates select="marc:subfield[@code='q']"/>
            <xsl:apply-templates select="marc:subfield[@code='r']"/>
            <xsl:apply-templates select="marc:subfield[@code='s']"/>
            <xsl:apply-templates select="marc:subfield[@code='t']"/>
            <xsl:apply-templates select="marc:subfield[@code='u']"/>
            <xsl:apply-templates select="marc:subfield[@code='v']"/>
            <xsl:apply-templates select="marc:subfield[@code='w']"/>
            <xsl:apply-templates select="marc:subfield[@code='x']"/>
            <xsl:apply-templates select="marc:subfield[@code='y']"/>
            <xsl:apply-templates select="marc:subfield[@code='z']"/>
        </marc:datafield>
    </xsl:template>


</xsl:stylesheet>