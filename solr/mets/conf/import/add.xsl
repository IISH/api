<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:mets="http://www.loc.gov/METS/"
        xmlns:ead="urn:isbn:1-931666-22-9"
         exclude-result-prefixes="mets ead">

    <xsl:import href="../../../xslt/solrFields.xsl" />
    <xsl:output method="xml" indent="no"/>

    <xsl:template match="record">

        <doc>
          <xsl:call-template name="extraRecordData">
            <xsl:with-param name="header" select="extraRecordData/*" />
          </xsl:call-template>

            <!-- Index the dsc and did elements -->
            <xsl:variable name="dsc" select="recordData/mets:mets//ead/archdesc/dsc"/>
            <xsl:for-each select="$dsc//node()[@level]">
                <field name="level_{@level}"><xsl:value-of select="did/unittitle/text()"/></field>
            </xsl:for-each>

            <xsl:variable name="levels">
                <xsl:for-each select="$dsc//node()[@level='series' or @level='subseries' or @level='file']"><xsl:value-of select="position()"/><xsl:if test="not(position()=last())">.</xsl:if></xsl:for-each>
            </xsl:variable>

            <field name="level">
                <xsl:value-of select="concat($levels, ' ')"/>
                <xsl:for-each select="$dsc//node()[@level='series' or @level='subseries' or @level='file']">
                <xsl:for-each select="did/unittitle//text()">
                        <xsl:value-of select="concat(normalize-space(.),' ')"/>
                    </xsl:for-each>
                    <xsl:if test="not(position()=last())"><xsl:value-of select="concat(',', ' ')"/></xsl:if>
                </xsl:for-each>
            </field>

<field name="container">
                <xsl:for-each select="$dsc//container/text()">
                    <xsl:value-of select="concat(normalize-space(.),' ')"/>
                </xsl:for-each>
            </field>

        </doc>

    </xsl:template>

</xsl:stylesheet>
