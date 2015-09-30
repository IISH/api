<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                exclude-result-prefixes="marc">

    <xsl:import href="../../../xslt/solrFields.xsl"/>
    <xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
    <xsl:param name="resource" />

    <xsl:template match="record">
        <doc>
            <xsl:call-template name="extraRecordData">
                <xsl:with-param name="header" select="extraRecordData/*"/>
            </xsl:call-template>
            <xsl:call-template name="recordData">
                <xsl:with-param name="record" select="recordData/*"/>
            </xsl:call-template>
        </doc>
    </xsl:template>

    <xsl:template name="recordData">
        <xsl:param name="record"/>
        <xsl:for-each select="$record/marc:controlfield">
            <xsl:call-template name="insertSolrField">
                <xsl:with-param name="field_name" select="marc_controlfield"/>
                <xsl:with-param name="field_value" select="."/>
            </xsl:call-template>
            <xsl:call-template name="insertSolrField">
                <xsl:with-param name="field_name" select="concat('marc_controlfield_', @tag)"/>
                <xsl:with-param name="field_value" select="."/>
            </xsl:call-template>
        </xsl:for-each>

        <xsl:for-each select="$record/marc:datafield">
            <xsl:variable name="tag" select="concat('marc_', @tag)"/>
            <xsl:variable name="ind1" select="@ind1"/>
            <xsl:variable name="ind2" select="@ind2"/>
                <xsl:call-template name="insertSolrField">
                    <xsl:with-param name="field_name" select="concat($tag, '_1')"/>
                    <xsl:with-param name="field_value" select="$ind1"/>
                </xsl:call-template>
                <xsl:call-template name="insertSolrField">
                    <xsl:with-param name="field_name" select="concat($tag, '_2')"/>
                    <xsl:with-param name="field_value" select="$ind2"/>
                </xsl:call-template>
            <xsl:for-each select="marc:subfield">
                <xsl:call-template name="insertSolrField">
                    <xsl:with-param name="field_name" select="$tag"/>
                    <xsl:with-param name="field_value" select="."/>
                </xsl:call-template>
                <xsl:call-template name="insertSolrField">
                    <xsl:with-param name="field_name" select="concat($tag, '_', @code)"/>
                    <xsl:with-param name="field_value" select="."/>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:for-each>
        <xsl:if test="$resource">
            <xsl:call-template name="insertSolrField">
                <xsl:with-param name="field_name" select="'resource'"/>
                <xsl:with-param name="field_value"><xsl:copy><xsl:copy-of select="$resource"/></xsl:copy></xsl:with-param>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
