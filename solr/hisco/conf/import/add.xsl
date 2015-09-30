<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet
        version="2.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:hisco="http://api.socialhistoryservices.org/hisco/1/"
        exclude-result-prefixes="hisco">

    <xsl:import href="../../../xslt/solrFields.xsl"/>
    <xsl:output method="xml" indent="no"/>
    <xsl:strip-space elements="*"/>

    <xsl:template match="record">
        <doc>
            <xsl:call-template name="extraRecordData">
                <xsl:with-param name="header" select="extraRecordData/*"/>
            </xsl:call-template>
            <xsl:for-each select="recordData/hisco:hisco/*">
                <xsl:call-template name="insertSolrField">
                    <xsl:with-param name="field_name" select="local-name(.)"/>
                    <xsl:with-param name="field_value" select="text()"/>
                </xsl:call-template>
            </xsl:for-each>
            <field name="has_images">
                <xsl:choose>
                    <xsl:when test="recordData/hisco:hisco/hisco:images">Yes</xsl:when>
                    <xsl:otherwise>No</xsl:otherwise>
                </xsl:choose>
            </field>
        </doc>
    </xsl:template>

</xsl:stylesheet>