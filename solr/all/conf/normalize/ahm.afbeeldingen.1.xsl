<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet
        version="2.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
        xmlns:dc="http://purl.org/dc/elements/1.1/"
        xmlns:iisg="http://www.iisg.nl/api/sru/"
        xmlns:marc="http://www.loc.gov/MARC21/slim"
        exclude-result-prefixes="oai_dc dc iisg marc">

    <xsl:import href="../../../xslt/insertElement.xsl"/>
    <xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
    <xsl:strip-space elements="*"/>
    <xsl:param name="marc_controlfield_005"/>
    <xsl:param name="marc_controlfield_008"/>
    <xsl:param name="date_modified"/>
    <xsl:param name="collectionName"/>

    <xsl:template match="ListRecords">

        <xsl:variable name="isShownBy">
            <xsl:call-template name="images">
                <xsl:with-param name="p" select="record/oai_dc:dc/dc:identifier[contains(.,'images')]"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="identifier"
                      select="concat('ahm.adlibsoft.com:', record/oai_dc:dc/dc:identifier[not(contains(.,'images'))])"/>

        <record>
            <extraRecordData>
                <iisg:iisg>
                    <xsl:call-template name="insertIISHIdentifiers">
                        <xsl:with-param name="identifier" select="$identifier"/>
                    </xsl:call-template>
                    <xsl:call-template name="insertCollection">
                        <xsl:with-param name="collection" select="$collectionName"/>
                    </xsl:call-template>
                    <iisg:isShownAt>http://ahm.adlibsoft.com/</iisg:isShownAt>
                    <xsl:copy-of select="$isShownBy"/>
                    <iisg:date_modified>
                        <xsl:call-template name="insertDateModified">
                            <xsl:with-param name="cfDate" select="marc:controlfield[@tag='005']"/>
                            <xsl:with-param name="fsDate" select="$date_modified"/>
                        </xsl:call-template>
                    </iisg:date_modified>
                </iisg:iisg>
            </extraRecordData>
            <recordData>
                <marc:record xmlns:marc="http://www.loc.gov/MARC21/slim">
                    <xsl:for-each select="record/*/*">
                        <xsl:variable name="ln" select="local-name()"/>
                        <xsl:choose>
                            <xsl:when test="$ln='title'">
                                <xsl:call-template name="insertElement">
                                    <xsl:with-param name="tag">245</xsl:with-param>
                                    <xsl:with-param name="code">a</xsl:with-param>
                                    <xsl:with-param name="value" select="."/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:when test="$ln='contributor' or $ln='creator'">
                                <xsl:call-template name="insertElement">
                                    <xsl:with-param name="tag">100</xsl:with-param>
                                    <xsl:with-param name="code">a</xsl:with-param>
                                    <xsl:with-param name="value" select="."/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:when test="$ln='coverage'">
                                <xsl:call-template name="insertElement">
                                    <xsl:with-param name="tag">651</xsl:with-param>
                                    <xsl:with-param name="code">a</xsl:with-param>
                                    <xsl:with-param name="value" select="."/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:when test="$ln='date'">
                                <xsl:call-template name="insertElement">
                                    <xsl:with-param name="tag">260</xsl:with-param>
                                    <xsl:with-param name="code">c</xsl:with-param>
                                    <xsl:with-param name="value" select="."/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:when test="$ln='description'">
                                <xsl:call-template name="insertElement">
                                    <xsl:with-param name="tag">500</xsl:with-param>
                                    <xsl:with-param name="code">a</xsl:with-param>
                                    <xsl:with-param name="value" select="."/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:when test="$ln='format'">
                                <xsl:call-template name="insertElement">
                                    <xsl:with-param name="tag">340</xsl:with-param>
                                    <xsl:with-param name="code">a</xsl:with-param>
                                    <xsl:with-param name="value" select="."/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:when test="$ln='language'">
                                <xsl:call-template name="insertElement">
                                    <xsl:with-param name="tag">041</xsl:with-param>
                                    <xsl:with-param name="code">a</xsl:with-param>
                                    <xsl:with-param name="value" select="."/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:when test="$ln='publisher'">
                                <xsl:call-template name="insertElement">
                                    <xsl:with-param name="tag">260</xsl:with-param>
                                    <xsl:with-param name="code">a</xsl:with-param>
                                    <xsl:with-param name="value" select="."/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:when test="$ln='relation'">
                                <xsl:call-template name="insertElement">
                                    <xsl:with-param name="tag">530</xsl:with-param>
                                    <xsl:with-param name="code">a</xsl:with-param>
                                    <xsl:with-param name="value" select="."/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:when test="$ln='rights'">
                                <xsl:call-template name="insertElement">
                                    <xsl:with-param name="tag">506</xsl:with-param>
                                    <xsl:with-param name="code">a</xsl:with-param>
                                    <xsl:with-param name="value" select="."/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:when test="$ln='source'">
                                <xsl:call-template name="insertElement">
                                    <xsl:with-param name="tag">534</xsl:with-param>
                                    <xsl:with-param name="code">t</xsl:with-param>
                                    <xsl:with-param name="value" select="."/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:when test="$ln='subject'">
                                <xsl:call-template name="insertElement">
                                    <xsl:with-param name="tag">650</xsl:with-param>
                                    <xsl:with-param name="code">a</xsl:with-param>
                                    <xsl:with-param name="value" select="."/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:for-each>
                    <xsl:for-each select="$isShownBy">
                        <xsl:call-template name="insertElement">
                            <xsl:with-param name="tag">856</xsl:with-param>
                            <xsl:with-param name="code">u</xsl:with-param>
                            <xsl:with-param name="value" select="."/>
                        </xsl:call-template>
                    </xsl:for-each>
                </marc:record>
            </recordData>
        </record>
    </xsl:template>

    <xsl:template name="images">
        <xsl:param name="p"/>
        <xsl:for-each select="$p">
            <xsl:variable name="image" select="substring-after($p, '\images\')"/>
            <iisg:isShownBy>
                <xsl:value-of select="concat('http://ahm.adlibsoft.com/ahmimages/', $image)"/>
            </iisg:isShownBy>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>