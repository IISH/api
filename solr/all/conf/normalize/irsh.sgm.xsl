<?xml version="1.0" encoding="UTF-8" ?>

<!-- legacy sgm mappings -->

<xsl:stylesheet
        version="2.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:iisg="http://www.iisg.nl/api/sru/"
        xmlns:marc="http://www.loc.gov/MARC21/slim"
        exclude-result-prefixes="iisg marc">

    <xsl:import href="../../../xslt/insertElement.xsl"/>
    <xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
    <xsl:strip-space elements="*"/>
    <xsl:param name="marc_controlfield_005"/>
    <xsl:param name="marc_controlfield_008"/>
    <xsl:param name="date_modified"/>
    <xsl:param name="collectionName"/>

    <xsl:template match="ARTICLE">
        <xsl:apply-templates select="HEADER"/>
    </xsl:template>

    <xsl:template match="HEADER">

        <xsl:variable name="identifier" select="concat('10622/', ARTCON/GENHDR/ARTINFO/ALTID/PII)"/>
        <xsl:variable name="isShownBy"
                      select="concat('http://hdl.handle.net/',$identifier,'?locatt=view:master')"/>
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
                        <xsl:value-of select="concat('http://hdl.handle.net/',$identifier,'?locatt=view:catalog')"/>
                    </iisg:isShownAt>
                    <iisg:isShownBy>
                        <xsl:copy-of select="$isShownBy"/>
                    </iisg:isShownBy>
                    <iisg:date_modified>
                        <xsl:call-template name="insertDateModified">
                            <xsl:with-param name="cfDate" select="$marc_controlfield_005"/>
                            <xsl:with-param name="fsDate" select="$date_modified"/>
                        </xsl:call-template>
                    </iisg:date_modified>
                </iisg:iisg>
            </extraRecordData>

            <recordData>
                <marc:record xmlns:marc="http://www.loc.gov/MARC21/slim">

                    <marc:leader>00857nab a22001810a 4500</marc:leader>
                    <marc:controlfield tag="001">
                        <xsl:value-of select="ARTCON/GENHDR/ARTINFO/ALTID/PII"/>
                    </marc:controlfield>
                    <marc:controlfield tag="003">NL-AMISG</marc:controlfield>
                    <marc:controlfield tag="005">
                        <xsl:value-of select="$marc_controlfield_005"/>
                    </marc:controlfield>
                    <marc:controlfield tag="008">199902suuuuuuuu||||||||||||||||||||||| d</marc:controlfield>

                    <xsl:for-each select="ARTCON/GENHDR/AUG/AU[FNMS and SNM]">
                        <xsl:variable name="tag">
                            <xsl:choose>
                                <xsl:when test="position()=1">100</xsl:when>
                                <xsl:otherwise>700</xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:call-template name="insertSingleElement">
                            <xsl:with-param name="tag" select="$tag"/>
                            <xsl:with-param name="code">a</xsl:with-param>
                            <xsl:with-param name="value"
                                            select="concat(SNM, ', ', FNMS)"/>
                        </xsl:call-template>

                    </xsl:for-each>
                    <marc:datafield tag="245" ind1=" " ind2=" ">
                        <marc:subfield code="a">
                            <xsl:value-of select="ARTCON/GENHDR/TIG/ATL[1]/text()"/>
                        </marc:subfield>
                        <xsl:if test="ARTCON/GENHDR/ARTINFO/ARTTY/DISPART">
                            <marc:subfield code="k">
                                <xsl:value-of select="ARTCON/GENHDR/ARTINFO/ARTTY/DISPART"/>
                            </marc:subfield>
                        </xsl:if>
                    </marc:datafield>
<!--
                    <marc:datafield tag="260" ind1=" " ind2=" ">
                        <marc:subfield code="a">
                            <xsl:value-of select="concat(ISSUE/PINFO/LOC, ' :')"/>
                        </marc:subfield>
                        <marc:subfield code="b">
                            <xsl:value-of select="concat(ISSUE/PINFO/PNM, ',')"/>
                        </marc:subfield>
                        <marc:subfield code="c">
                            <xsl:value-of select="ISSUE/PUBINFO/CD/@YEAR"/>
                        </marc:subfield>
                    </marc:datafield>
-->

<!--
                    <xsl:call-template name="insertSingleElement">
                        <xsl:with-param name="tag">300</xsl:with-param>
                        <xsl:with-param name="code">a</xsl:with-param>
                        <xsl:with-param name="value"
                                        select="concat(ARTCON/GENHDR/ARTINFO/ARTTY/PPCT/@COUNT, ' p.')"/>
                    </xsl:call-template>
-->

                    <marc:datafield tag="773" ind1="0" ind2="#">
                        <marc:subfield code="t">
                            <xsl:value-of
                                    select="ISSUE/JINFO/JTL"/>
                        </marc:subfield>
                        <marc:subfield code="g">
                            <xsl:value-of
                                    select="concat(ISSUE/PUBINFO/VID, '(', ISSUE/PUBINFO/CD/@YEAR, ') no.', ISSUE/PUBINFO/IID, ', p. ',ARTCON/GENHDR/ARTINFO/ARTTY/PPCT/PPF, '-', ARTCON/GENHDR/ARTINFO/ARTTY/PPCT/PPL, '.')"/>
                        </marc:subfield>
                    </marc:datafield>

                    <xsl:for-each select="ARTCON/GENHDR/TIG/ATL[1]/FNR">
                        <xsl:call-template name="insertElement">
                            <xsl:with-param name="tag">500</xsl:with-param>
                            <xsl:with-param name="code">a</xsl:with-param>
                            <xsl:with-param name="value" select="FN//text()"/>
                        </xsl:call-template>
                    </xsl:for-each>

                    <xsl:call-template name="insertElement">
                        <xsl:with-param name="tag">520</xsl:with-param>
                        <xsl:with-param name="code">a</xsl:with-param>
                        <xsl:with-param name="value" select="ARTCON/GENHDR/ABS/P"/>
                    </xsl:call-template>

                    <xsl:if test="//CRN">
                        <xsl:call-template name="insertSingleElement">
                            <xsl:with-param name="tag">540</xsl:with-param>
                            <xsl:with-param name="code">b</xsl:with-param>
                            <xsl:with-param name="value" select="//CRN[1]"/>
                        </xsl:call-template>
                    </xsl:if>

                    <xsl:call-template name="insertSingleElement">
                        <xsl:with-param name="tag">452</xsl:with-param>
                        <xsl:with-param name="code">m</xsl:with-param>
                        <xsl:with-param name="value">irsh</xsl:with-param>
                    </xsl:call-template>

                    <marc:datafield tag="852" ind1=" " ind2=" ">
                        <marc:subfield code="a">IISG</marc:subfield>
                        <marc:subfield code="b">IISG</marc:subfield>
                        <marc:subfield code="c">IRSH</marc:subfield>
                        <marc:subfield code="j">IRSH</marc:subfield>
                    </marc:datafield>

                    <marc:datafield tag="856" ind1="4" ind2=" ">
                        <marc:subfield code="q">application/pdf</marc:subfield>
                        <marc:subfield code="u">
                            <xsl:value-of select="$isShownBy"/>
                        </marc:subfield>
                    </marc:datafield>

                    <xsl:call-template name="insertSingleElement">
                        <xsl:with-param name="tag">902</xsl:with-param>
                        <xsl:with-param name="code">a</xsl:with-param>
                        <xsl:with-param name="value" select="$identifier"/>
                    </xsl:call-template>

                </marc:record>
            </recordData>
        </record>

    </xsl:template>

</xsl:stylesheet>