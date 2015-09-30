<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet
        version="2.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:migranten="http://api.socialhistoryservices.org/migranten/1/"
        exclude-result-prefixes="migranten">

    <xsl:import href="../../../xslt/solrFields.xsl"/>
    <xsl:output method="xml" indent="no"/>
    <xsl:strip-space elements="*"/>

    <xsl:template match="record">
        <doc>
            <xsl:call-template name="extraRecordData">
                <xsl:with-param name="header" select="extraRecordData/*"/>
            </xsl:call-template>
            <xsl:for-each select="recordData/migranten:migranten/*">
                <xsl:if test="text()">
                    <field name="{local-name(.)}">
                        <xsl:value-of select="text()"/>
                    </field>
                </xsl:if>
            </xsl:for-each>
        </doc>
    </xsl:template>


</xsl:stylesheet>