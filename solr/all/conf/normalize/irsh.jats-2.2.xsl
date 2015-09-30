<?xml version="1.0" encoding="UTF-8" ?>

<!-- near legacy xml mappings -->

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

    <xsl:template match="article">

        <xsl:variable name="identifier" select="concat('10622/', front/article-meta/article-id[@pub-id-type='pii'])"/>
        <xsl:variable name="isShownBy"
                      select="concat('http://hdl.handle.net/', $identifier, '?locatt=view:master')"/>

        <record>
            <extraRecordData>
                <iisg:iisg>
                    <xsl:call-template name="insertIISHIdentifiers">
                        <xsl:with-param name="identifier" select="front/article-meta/article-id[@pub-id-type='pii']"/>
                    </xsl:call-template>
                    <xsl:call-template name="insertCollection">
                        <xsl:with-param name="collection" select="$collectionName"/>
                    </xsl:call-template>
                    <iisg:isShownAt>
                        <xsl:value-of select="concat('http://hdl.handle.net/',$identifier,'?locatt=view:catalog')"/>
                    </iisg:isShownAt>
                    <iisg:isShownBy>
                        <xsl:value-of select="$isShownBy"/>
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
                        <xsl:value-of select="front/article-meta/article-id[@pub-id-type='pii']"/>
                    </marc:controlfield>
                    <marc:controlfield tag="003">NL-AMISG</marc:controlfield>
                    <marc:controlfield tag="005">
                        <xsl:value-of select="$marc_controlfield_005"/>
                    </marc:controlfield>
                    <marc:controlfield tag="008">199902suuuuuuuu||||||||||||||||||||||| d</marc:controlfield>

                    <xsl:for-each select="front/article-meta/contrib-group/contrib">
                        <xsl:variable name="tag">
                            <xsl:choose>
                                <xsl:when test="position()=1">100</xsl:when>
                                <xsl:otherwise>700</xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:call-template name="insertSingleElement">
                            <xsl:with-param name="tag">
                                <xsl:value-of select="$tag"/>
                            </xsl:with-param>
                            <xsl:with-param name="code">a</xsl:with-param>
                            <xsl:with-param name="value"
                                            select="concat(name/surname, ', ', name/given-names)"/>
                        </xsl:call-template>
                    </xsl:for-each>

                    <marc:datafield tag="245" ind1=" " ind2=" ">
                        <marc:subfield code="a">
                            <xsl:choose>
                                <xsl:when test="front/article-meta/title-group/article-title/text()">
                                    <xsl:value-of select="front/article-meta/title-group/article-title/text()"/>
                                </xsl:when>
                                <xsl:when test="front/article-meta/product/source">Review of "<xsl:value-of select="front/article-meta/product/source"/>"
                                    <xsl:text> </xsl:text>by<xsl:text> </xsl:text>
                                    <xsl:for-each select="front/article-meta/product/name">
                                        <xsl:value-of select="surname"/>,
                                        <xsl:value-of select="given-names"/>
                                        <xsl:if test="not(position()=last())">;</xsl:if>
                                    </xsl:for-each>
                                    <xsl:text>. </xsl:text>
                                    <xsl:value-of select="front/article-meta/product/publisher-loc"/>
                                </xsl:when>

                                <xsl:otherwise>
                                    <xsl:value-of
                                            select="concat('Article from the ', front/journal-meta/journal-title, ', ', front/article-meta/volume, '(', front/article-meta/pub-date[@pub-type='ppub']/year, ') no.', front/article-meta/issue, ', p. ', front/article-meta/fpage, '-', front/article-meta/lpage, '.')"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </marc:subfield>
                        <xsl:if test="@article-type">
                            <marc:subfield code="k">
                                <xsl:value-of select="@article-type"/>
                            </marc:subfield>
                        </xsl:if>
                    </marc:datafield>

<!--
                    <marc:datafield tag="260" ind1=" " ind2=" ">
                        <marc:subfield code="a">
                            <xsl:value-of select="concat(front/journal-meta/publisher/publisher-loc, ' :')"/>
                        </marc:subfield>
                        <marc:subfield code="b">
                            <xsl:value-of select="concat(front/journal-meta/publisher/publisher-name, ',')"/>
                        </marc:subfield>
                        <marc:subfield code="c">
                            <xsl:value-of select="front/article-meta/pub-date[1]/year"/>
                        </marc:subfield>
                    </marc:datafield>
-->

<!--
                    <xsl:call-template name="insertSingleElement">
                        <xsl:with-param name="tag">300</xsl:with-param>
                        <xsl:with-param name="code">a</xsl:with-param>
                        <xsl:with-param name="value"
                                        select="concat(front/article-meta/counts/page-count/@count, ' p.')"/>
                    </xsl:call-template>
-->

                    <xsl:call-template name="insertElement">
                        <xsl:with-param name="tag">452</xsl:with-param>
                        <xsl:with-param name="code">m</xsl:with-param>
                        <xsl:with-param name="value">irsh</xsl:with-param>
                    </xsl:call-template>

                    <xsl:call-template name="insertElement">
                        <xsl:with-param name="tag">520</xsl:with-param>
                        <xsl:with-param name="code">a</xsl:with-param>
                        <xsl:with-param name="value" select="front/article-meta/abstract"/>
                    </xsl:call-template>
                    <marc:datafield tag="773" ind1="0" ind2="#">
                        <marc:subfield code="t">
                            <xsl:value-of
                                    select="front/journal-meta/journal-title"/>
                        </marc:subfield>
                        <marc:subfield code="g">
                            <xsl:choose>
                                <xsl:when test="front/article-meta/issue">
                                    <xsl:value-of
                                            select="concat('vol. ', front/article-meta/volume, '(', front/article-meta/pub-date[1]/year, ') no.', front/article-meta/issue, ', p. ', front/article-meta/fpage, '-', front/article-meta/lpage, '.')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of
                                            select="concat('vol. ', front/article-meta/volume, '(', front/article-meta/pub-date[1]/year, ') p. ', front/article-meta/fpage, '-', front/article-meta/lpage, '.')"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </marc:subfield>
                    </marc:datafield>
                    <xsl:if test="front/article-meta/permissions/copyright-statement">
                        <xsl:call-template name="insertSingleElement">
                            <xsl:with-param name="tag">540</xsl:with-param>
                            <xsl:with-param name="code">b</xsl:with-param>
                            <xsl:with-param name="value" select="front/article-meta/permissions/copyright-statement"/>
                        </xsl:call-template>
                    </xsl:if>

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
                        <xsl:with-param name="value"
                                        select="$identifier"/>
                    </xsl:call-template>

                </marc:record>
            </recordData>
        </record>

    </xsl:template>

</xsl:stylesheet>