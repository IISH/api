<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet
        version="2.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:strikes="http://api.socialhistoryservices.org/strikes/1/"
        exclude-result-prefixes="strikes">

    <xsl:import href="../../../xslt/solrFields.xsl"/>
    <xsl:output method="xml" indent="no"/>
    <xsl:strip-space elements="*"/>

    <xsl:template match="record">
        <doc>
            <xsl:call-template name="extraRecordData">
                <xsl:with-param name="header" select="extraRecordData/*"/>
            </xsl:call-template>

            <xsl:for-each select="recordData/strikes:strikes">
                <xsl:apply-templates/>
            </xsl:for-each>
        </doc>
    </xsl:template>

    <xsl:template match="strikes:Bedrijven">

        <xsl:for-each select="distinct-values(strikes:Bedrijf_record/strikes:Naam)">
            <xsl:call-template name="insertSolrField">
                <xsl:with-param name="field_name" select="'bedrijf'"/>
                <xsl:with-param name="field_value" select="."/>
            </xsl:call-template>
        </xsl:for-each>

        <xsl:for-each select="strikes:Bedrijf_record">
            <xsl:variable name="tmp">
                <xsl:value-of select="strikes:Naam"/>
                <xsl:if test="strikes:Plaats">
                    <xsl:value-of select="concat(' (', strikes:Plaats, ')')"/>
                </xsl:if>
            </xsl:variable>

            <xsl:call-template name="insertSolrField">
                <xsl:with-param name="field_name" select="'bedrijf_plaats'"/>
                <xsl:with-param name="field_value" select="$tmp"/>
            </xsl:call-template>

        </xsl:for-each>
    </xsl:template>

    <xsl:template match="strikes:Beroepen">

        <xsl:for-each select="distinct-values(strikes:Beroep_record/strikes:Beroep/strikes:lang[@code='nl-NL'])">
            <xsl:call-template name="insertSolrField">
                <xsl:with-param name="field_name" select="'beroep_nl'"/>
                <xsl:with-param name="field_value" select="."/>
            </xsl:call-template>
        </xsl:for-each>

        <xsl:for-each select="distinct-values(strikes:Beroep_record/strikes:Beroep/strikes:lang[@code='en-US'])">
            <xsl:call-template name="insertSolrField">
                <xsl:with-param name="field_name" select="'beroep_en'"/>
                <xsl:with-param name="field_value" select="."/>
            </xsl:call-template>
        </xsl:for-each>
        <xsl:for-each select="distinct-values(strikes:Beroep_record/strikes:Beroepsgroep/strikes:lang[@code='nl-NL'])">
            <xsl:call-template name="insertSolrField">
                <xsl:with-param name="field_name" select="'beroepsgroep_nl'"/>
                <xsl:with-param name="field_value" select="."/>
            </xsl:call-template>
        </xsl:for-each>

        <xsl:for-each select="distinct-values(strikes:Beroep_record/strikes:Beroepsgroep/strikes:lang[@code='en-US'])">
            <xsl:call-template name="insertSolrField">
                <xsl:with-param name="field_name" select="'beroepsgroep_en'"/>
                <xsl:with-param name="field_value" select="."/>
            </xsl:call-template>

        </xsl:for-each>
    </xsl:template>

    <xsl:template match="strikes:Plaatsen">
        <xsl:for-each
                select="distinct-values(strikes:Plaats_record/strikes:Plaats|strikes:Plaats_record/strikes:Gemeente)">
            <xsl:call-template name="insertSolrField">
                <xsl:with-param name="field_name" select="'plaats'"/>
                <xsl:with-param name="field_value" select="."/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="strikes:Redenen">

        <xsl:for-each select="strikes:Reden_record">

            <xsl:for-each select="distinct-values(strikes:eisen/strikes:lang[@code='nl-NL'])">
                <xsl:call-template name="insertSolrField">
                    <xsl:with-param name="field_name" select="'reden_nl'"/>
                    <xsl:with-param name="field_value" select="."/>
                </xsl:call-template>
            </xsl:for-each>

            <xsl:for-each select="distinct-values(strikes:eisen/strikes:lang[@code='en-US'])">
                <xsl:call-template name="insertSolrField">
                    <xsl:with-param name="field_name" select="'reden_en'"/>
                    <xsl:with-param name="field_value" select="."/>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="strikes:Actie_soort">
        <xsl:for-each select="strikes:lang">
            <xsl:call-template name="insertSolrField">
                <xsl:with-param name="field_name" select="concat('actiesoort_', substring(@code, 1, 2))"/>
                <xsl:with-param name="field_value" select="."/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="strikes:Karakter">
        <xsl:for-each select="strikes:lang">
            <xsl:call-template name="insertSolrField">
                <xsl:with-param name="field_name" select="concat('karakter_', substring(@code, 1, 2))"/>
                <xsl:with-param name="field_value" select="."/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="strikes:Sector">
        <xsl:for-each select="strikes:lang">
            <xsl:call-template name="insertSolrField">
                <xsl:with-param name="field_name" select="concat('sector_', substring(@code, 1, 2))"/>
                <xsl:with-param name="field_value" select="."/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>


    <xsl:template match="strikes:Type">
        <xsl:for-each select="strikes:lang">
            <xsl:call-template name="insertSolrField">
                <xsl:with-param name="field_name" select="concat('type_', substring(@code, 1, 2))"/>
                <xsl:with-param name="field_value" select="."/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="strikes:Uitkomst">
        <xsl:for-each select="strikes:lang">
            <xsl:call-template name="insertSolrField">
                <xsl:with-param name="field_name" select="concat('uitkomst_', substring(@code, 1, 2))"/>
                <xsl:with-param name="field_value" select="."/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="strikes:Datum">
        <xsl:call-template name="insertSolrField">
            <xsl:with-param name="field_name" select="'datum'"/>
            <xsl:with-param name="field_value"
                            select="concat(substring(., 1, 4), '-', substring(., 5, 2), '-', substring(., 7, 2))"/>
        </xsl:call-template>
        <xsl:call-template name="insertSolrField">
            <xsl:with-param name="field_name" select="'jaar'"/>
            <xsl:with-param name="field_value" select="substring(., 1, 4)"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="node()">
        <xsl:comment select="concat('ignoring node: ', local-name(.), ':', text())"/>
    </xsl:template>

</xsl:stylesheet>