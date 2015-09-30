<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:iisg="http://www.iisg.nl/api/sru/"
                exclude-result-prefixes="marc iisg">

    <xsl:import href="../../../xslt/insertElement.xsl"/>
    <xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
    <xsl:param name="collectionName"/>

    <xsl:template match="record">
        <xsl:for-each select="recordData">
            <xsl:for-each select="record">

                <record>
                    <recordData>
                        <marc:record>
                            <xsl:apply-templates select="leader"/>
                            <xsl:apply-templates select="controlfield"/>
                            <xsl:apply-templates select="datafield"/>
                        </marc:record>
                    </recordData>
                    <extraRecordData>
                        <iisg:iisg>
                            <xsl:variable name="identifier"
                                          select="concat('persmuseum:afbeeldingen:1:', controlfield[@tag='001'][1], '_MARC')"/>
                            <xsl:variable name="identifiershort"
                                          select="concat(controlfield[@tag='001'][1], '_MARC')"/>
                            <xsl:variable name="identifiershorter" select="concat($identifiershort,'IISG')"/>
                            <xsl:variable name="date_modified"
                                          select="/record/extraRecordData/extraData/date_modified"/>
                            <xsl:variable name="barcode"
                                          select="/record/recordData/record/datafield[@tag='852']/subfield[@code='p']"/>
                            <xsl:call-template name="insertIISHIdentifiers">
                                <xsl:with-param name="identifier" select="$identifier"/>
                            </xsl:call-template>
                            <iisg:isShownAt>
                                <xsl:value-of
                                        select="concat('http://search.iisg.nl/search/search?action=transform&amp;col=marc_images&amp;xsl=marc_images-detail.xsl&amp;lang=en&amp;docid=', $identifiershorter)"/>
                            </iisg:isShownAt>
                            <xsl:call-template name="insertCollection">
                                <xsl:with-param name="collection" select="$collectionName"/>
                            </xsl:call-template>
                            <iisg:isShownBy>
                                <xsl:value-of
                                        select="concat('http://search.iisg.nl/search/search?action=get&amp;id=',$barcode,'&amp;col=images&amp;fieldname=resource')"/>
                            </iisg:isShownBy>
                            <iisg:date_modified>
                                <xsl:call-template name="insertDateModified">
                                    <xsl:with-param name="cfDate" select="marc:controlfield[@tag='005']"/>
                                    <xsl:with-param name="fsDate" select="$date_modified"/>
                                </xsl:call-template>
                            </iisg:date_modified>
                        </iisg:iisg>
                    </extraRecordData>
                </record>

            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="leader">
        <marc:leader>
            <xsl:value-of select="text()"/>
        </marc:leader>
    </xsl:template>

    <xsl:template match="controlfield">
        <xsl:variable name="tag" select="@tag"/>

        <xsl:element name="marc:controlfield">
            <xsl:attribute name="tag">
                <xsl:value-of select="$tag"/>
            </xsl:attribute>

            <xsl:choose>
                <xsl:when test="$tag='001'">
                    <xsl:value-of select="concat('persmuseum:afbeeldingen:1:',text())"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="text()"/>
                </xsl:otherwise>
            </xsl:choose>

        </xsl:element>
    </xsl:template>

    <xsl:template match="datafield">
        <xsl:variable name="tag" select="@tag"/>
        <xsl:variable name="ind1" select="@ind1"/>
        <xsl:variable name="ind2" select="@ind2"/>

        <xsl:element name="marc:datafield">
            <xsl:attribute name="ind1">
                <xsl:value-of select="$ind1"/>
            </xsl:attribute>
            <xsl:attribute name="ind2">
                <xsl:value-of select="$ind2"/>
            </xsl:attribute>
            <xsl:attribute name="tag">
                <xsl:value-of select="$tag"/>
            </xsl:attribute>

            <xsl:for-each select="subfield">
                <xsl:variable name="code" select="@code"/>
                <xsl:element name="marc:subfield">
                    <xsl:attribute name="code">
                        <xsl:value-of select="$code"/>
                    </xsl:attribute>
                    <xsl:value-of select="text()"/>
                </xsl:element>

            </xsl:for-each>
        </xsl:element>
    </xsl:template>

    <xsl:template name="images">
        <xsl:param name="p"/>
        <xsl:for-each select="$p">
            <iisg:isShownBy>
                <xsl:value-of
                        select="concat('http://search.iisg.nl/search/search?action=get&amp;id=', ., '&amp;col=images&amp;fieldname=resource')"/>
            </iisg:isShownBy>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
