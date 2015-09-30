<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet
        version="2.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:ziegler="http://api.socialhistoryservices.org/ziegler/1/"
        exclude-result-prefixes="ziegler">

    <xsl:import href="../../../xslt/solrFields.xsl"/>
    <xsl:output method="xml" indent="no"/>
    <xsl:strip-space elements="*"/>

    <xsl:template match="record">
        <doc>
            <xsl:call-template name="extraRecordData">
                <xsl:with-param name="header" select="extraRecordData/*"/>
            </xsl:call-template>
            <xsl:for-each select="recordData/ziegler:ziegler">
                <xsl:apply-templates/>
            </xsl:for-each>
        </doc>
    </xsl:template>


    <xsl:template match="node()">
        <xsl:call-template name="insertSolrField">
            <xsl:with-param name="field_name" select="local-name()"/>
            <xsl:with-param name="field_value" select="text()"/>
        </xsl:call-template>
    </xsl:template>

</xsl:stylesheet>