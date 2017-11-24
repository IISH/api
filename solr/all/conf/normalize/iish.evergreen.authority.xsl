<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet
        version="2.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:marc="http://www.loc.gov/MARC21/slim"
        xmlns:iisg="http://www.iisg.nl/api/sru/" xmlns:xls="http://www.w3.org/1999/XSL/Transform"
        exclude-result-prefixes="iisg marc">

    <xsl:import href="../../../xslt/insertElement.xsl"/>
    <xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
    <xsl:strip-space elements="*"/>
    <xsl:param name="marc_controlfield_005"/>
    <xsl:param name="marc_controlfield_008"/>
    <xsl:param name="date_modified"/>
    <xsl:param name="collectionName"/>

    <xsl:template match="marc:record">

        <xsl:variable name="status_deleted">
            <xsl:choose>
                <xsl:when
                        test="status['deleted']">true</xsl:when>
                <xsl:otherwise>false</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="datestamp">
            <xsl:choose>
                <xsl:when test="datestamp">
                    <xsl:value-of select="datestamp"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="insertDateModified">
                        <xsl:with-param name="cfDate" select="$date_modified"/>
                        <xsl:with-param name="fsDate" select="$date_modified"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <record>
            <extraRecordData>
                <iisg:iisg>
                    <xsl:call-template name="insertIISHIdentifiers">
                        <xsl:with-param name="identifier"
                                        select="concat($collectionName, ':', marc:controlfield[@tag='001']/text())"/>
                    </xsl:call-template>
                    <xsl:call-template name="insertCollection">
                        <xsl:with-param name="collection" select="$collectionName"/>
                    </xsl:call-template>
                    <iisg:date_modified>
                        <xsl:value-of select="$datestamp"/>
                    </iisg:date_modified>
                    <iisg:deleted>
                        <xsl:value-of select="$status_deleted"/>
                    </iisg:deleted>
                </iisg:iisg>
            </extraRecordData>

            <xsl:if test="$status_deleted='false'">
                <recordData>
                    <marc:record xmlns:marc="http://www.loc.gov/MARC21/slim"
                                 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                                 xsi:schemaLocation="http://www.loc.gov/MARC21/slim http://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd">
                        <xsl:apply-templates select="marc:*"/>
                    </marc:record>
                </recordData>
            </xsl:if>
        </record>

    </xsl:template>

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
