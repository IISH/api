<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ead="urn:isbn:1-931666-22-9"
                xmlns:iisg="http://www.iisg.nl/api/sru/"
                exclude-result-prefixes="ead iisg">

    <xsl:import href="../../../xslt/insertElement.xsl"/>
    <xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
    <xsl:strip-space elements="*"/>
    <xsl:param name="marc_controlfield_005"/>
    <xsl:param name="marc_controlfield_008"/>
    <xsl:param name="date_modified"/><xsl:param name="collectionName"/>

    <xsl:template match="ead">

        <xsl:variable name="identifier" select="concat('archieven.nl:', eadheader/eadid)"/>

        <record>
            <extraRecordData>
                <iisg:iisg>
                    <xsl:call-template name="insertIISHIdentifiers">
                        <xsl:with-param name="identifier" select="$identifier"/>
                    </xsl:call-template>
                    <xsl:call-template name="insertCollection">
                        <xsl:with-param name="collection" select="$collectionName"/>
                    </xsl:call-template>
                    <iisg:isShownAt>
                        <xsl:value-of select="archdesc/did/repository/address/addressline"/>
                    </iisg:isShownAt>
                    <iisg:date_modified>
                        <xsl:value-of select="$date_modified"/>
                    </iisg:date_modified>
                </iisg:iisg>
            </extraRecordData>
            <recordData>
                <marc:record xmlns:marc="http://www.loc.gov/MARC21/slim">
                    <marc:controlfield tag="001">
                        <xsl:value-of select="$identifier"/>
                    </marc:controlfield>

                    <xsl:call-template name="insertElement">
                        <xsl:with-param name="tag" select="'245'"/>
                        <xsl:with-param name="code" select="'a'"/>
                        <xsl:with-param name="value" select="//archdesc/did/unittitle"/>
                    </xsl:call-template>

                    <xsl:variable name="from" select="//titleproper/date[@ID='from']"/>
                    <xsl:variable name="to" select="//titleproper/date[@ID='to']"/>
                    <xsl:call-template name="insertElement">
                        <xsl:with-param name="tag" select="'245'"/>
                        <xsl:with-param name="code" select="'f'"/>
                        <xsl:with-param name="value" select="concat($from, '-', $to)"/>
                    </xsl:call-template>

                    <xsl:call-template name="insertElement">
                        <xsl:with-param name="tag" select="'650'"/>
                        <xsl:with-param name="code" select="'a'"/>
                        <xsl:with-param name="value" select="//indexentry/name"/>
                    </xsl:call-template>

                    <xsl:call-template name="insertElement">
                        <xsl:with-param name="tag" select="'655'"/>
                        <xsl:with-param name="code" select="'a'"/>
                        <xsl:with-param name="value" select="'archief'"/>
                    </xsl:call-template>

                    <xsl:call-template name="insertElement">
                        <xsl:with-param name="tag" select="'506'"/>
                        <xsl:with-param name="code" select="'a'"/>
                        <xsl:with-param name="value" select="//defitem[label='Openbaarheid']/item"/>
                    </xsl:call-template>

                    <xsl:call-template name="insertElement">
                        <xsl:with-param name="tag" select="'852'"/>
                        <xsl:with-param name="code" select="'a'"/>
                        <xsl:with-param name="value" select="//repository/corpname"/>
                    </xsl:call-template>

                    <xsl:call-template name="insertElement">
                        <xsl:with-param name="tag" select="'856'"/>
                        <xsl:with-param name="code" select="'u'"/>
                        <xsl:with-param name="value" select="//address/addressline"/>
                    </xsl:call-template>

                </marc:record>
            </recordData>
        </record>
    </xsl:template>

    <xsl:template match="node()" mode="all">

        <xsl:variable name="element" select="local-name(.)"/>
        <xsl:if test="string-length($element)>0">
            <xsl:element name="{concat('ead:', $element)}">
                <xsl:copy-of select="@*"/>
                <xsl:copy-of select="text()"/>
                <xsl:apply-templates select="node()" mode="all"/>
            </xsl:element>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>