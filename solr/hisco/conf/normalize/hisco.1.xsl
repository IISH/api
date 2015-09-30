<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:hisco="http://api.socialhistoryservices.org/hisco/1/"
                xmlns:iisg="http://www.iisg.nl/api/sru/"
                exclude-result-prefixes="hisco iisg">

    <xsl:import href="../../../xslt/insertElement.xsl"/>
    <xsl:strip-space elements="*"/>
    <xsl:param name="marc_controlfield_005"/>
    <xsl:param name="marc_controlfield_008"/>
    <xsl:param name="date_modified"/>
    <xsl:param name="collectionName"/>
    <xsl:variable name="prefix" select="'hisco'"/>

    <xsl:template match="item">

        <xsl:variable name="identifier">
            <xsl:choose>
                <xsl:when test="final/link_id">
                    <xsl:value-of select="concat($prefix, ':occupations:', final/link_id)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat($prefix, ':', final/hisco_1_id)"/>
                    <xsl:if test="final/hisco_2_id">
                        <xsl:value-of select="concat(':', final/hisco_2_id)"/>
                    </xsl:if>
                    <xsl:if test="final/hisco_3_id">
                        <xsl:value-of select="concat(':', final/hisco_3_id)"/>
                    </xsl:if>
                    <xsl:if test="final/hisco_45_id">
                        <xsl:choose>
                            <xsl:when test="string-length(final/hisco_45_id)=1">
                                <xsl:value-of select="concat(':0', final/hisco_45_id)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat(':', final/hisco_45_id)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <record>
            <extraRecordData>
                <iisg:iisg>
                    <xsl:call-template name="insertIISHIdentifiers">
                        <xsl:with-param name="identifier" select="$identifier"/>
                    </xsl:call-template>
                    <xsl:call-template name="insertCollection">
                        <xsl:with-param name="collection" select="$collectionName"/>
                    </xsl:call-template>
                    <iisg:isShownAt>.</iisg:isShownAt>
                    <iisg:date_modified>
                        <xsl:value-of select="$date_modified"/>
                    </iisg:date_modified>
                </iisg:iisg>
            </extraRecordData>
            <recordData>
                <hisco:hisco>
                    <xsl:choose>
                        <xsl:when test="final/link_id">
                            <!-- the hisco value must be split into the four parts that constitute it's compound index
                                                     0.0.0.00
                                                     -->

                            <xsl:variable name="hisco_id">
                                <xsl:choose>
                                    <xsl:when test="string-length(final/hisco_id)=4">
                                        <xsl:value-of
                                                select="concat(substring(final/hisco_id, 1, 3), '0', substring(final/hisco_id, 4, 1))"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="final/hisco_id"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>

                            <xsl:call-template name="insertCustomElement">
                                <xsl:with-param name="localname" select="'group_ids'"/>
                                <xsl:with-param name="value">
                                    <xsl:value-of select="substring($hisco_id, 1, 1)"/>
                                </xsl:with-param>
                                <xsl:with-param name="p" select="$prefix"/>
                            </xsl:call-template>

                            <xsl:call-template name="insertCustomElement">
                                <xsl:with-param name="localname" select="'group_ids'"/>
                                <xsl:with-param name="value">
                                    <xsl:value-of
                                            select="concat(substring($hisco_id, 1, 1), substring($hisco_id, 2, 1))"/>
                                </xsl:with-param>
                                <xsl:with-param name="p" select="$prefix"/>
                            </xsl:call-template>

                            <xsl:call-template name="insertCustomElement">
                                <xsl:with-param name="localname" select="'group_ids'"/>
                                <xsl:with-param name="value">
                                    <xsl:value-of
                                            select="concat(substring($hisco_id, 1, 1), substring($hisco_id, 2, 1), substring($hisco_id, 3, 1))"/>
                                </xsl:with-param>
                                <xsl:with-param name="p" select="$prefix"/>
                            </xsl:call-template>

                            <xsl:call-template name="insertCustomElement">
                                <xsl:with-param name="localname" select="'group_ids'"/>
                                <xsl:with-param name="value">
                                    <xsl:value-of
                                            select="concat(substring($hisco_id, 1, 1), substring($hisco_id, 2, 1), substring($hisco_id, 3, 1), substring($hisco_id, 4))"/>
                                </xsl:with-param>
                                <xsl:with-param name="p" select="$prefix"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:call-template name="insertCustomElement">
                                <xsl:with-param name="localname" select="'group_id'"/>
                                <xsl:with-param name="value">
                                    <xsl:if test="final/table='major'">hisco</xsl:if>
                                    <xsl:if test="final/hisco_2_id">
                                        <xsl:value-of select="concat('hisco:',final/hisco_1_id)"/>
                                    </xsl:if>
                                    <xsl:if test="final/hisco_3_id">
                                        <xsl:value-of select="concat(':',final/hisco_2_id)"/>
                                    </xsl:if>
                                    <xsl:if test="final/hisco_45_id">
                                        <xsl:value-of select="concat(':',final/hisco_3_id)"/>
                                    </xsl:if>
                                </xsl:with-param>
                                <xsl:with-param name="p" select="$prefix"/>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>

                    <xsl:apply-templates select="final/*"/>

                    <!-- Here we give the images a base URL and apply some formatting. -->
                    <xsl:if test="final/images">
                        <hisco:images>
                            <xsl:for-each select="final/images/image_url">
                                <xsl:variable name="tmp_before" select="substring-before(text(), '_')"/>
                                <xsl:variable name="tmp_after" select="substring-after(text(), '_')"/>
                                <xsl:choose>
                                    <xsl:when
                                            test="string(number($tmp_after)) != 'NaN' and string-length($tmp_after)=1">
                                        <hisco:image_url>
                                            <xsl:value-of
                                                    select="concat('http://webstore.iisg.nl/historyofwork/', $tmp_before, '_00', $tmp_after, '.jpg')"/>
                                        </hisco:image_url>
                                    </xsl:when>
                                    <xsl:when
                                            test="string(number($tmp_after)) != 'NaN' and string-length($tmp_after)=2">
                                        <hisco:image_url>
                                            <xsl:value-of
                                                    select="concat('http://webstore.iisg.nl/historyofwork/', $tmp_before, '_0', $tmp_after, '.jpg')"/>
                                        </hisco:image_url>
                                    </xsl:when>
                                    <xsl:otherwise/>
                                </xsl:choose>
                            </xsl:for-each>
                        </hisco:images>
                    </xsl:if>
                </hisco:hisco>
            </recordData>
        </record>
    </xsl:template>


    <xsl:template match="country_code">

        <xsl:call-template name="insertCustomElement">
            <xsl:with-param name="localname" select="'country_code_id'"/>
            <xsl:with-param name="value" select="text()"/>
            <xsl:with-param name="p" select="$prefix"/>
        </xsl:call-template>

        <xsl:call-template name="insertCustomElement">
            <xsl:with-param name="localname" select="'country_code_label'"/>
            <xsl:with-param name="value">
                <xsl:choose>
                    <xsl:when test=".='BEL'">Belgium</xsl:when>
                    <xsl:when test=".='CAN'">Canada (Quebec)</xsl:when>
                    <xsl:when test=".='DK'">Denmark</xsl:when>
                    <xsl:when test=".='FR'">France</xsl:when>
                    <xsl:when test=".='GER'">Germany</xsl:when>
                    <xsl:when test=".='HE'">Greece</xsl:when>
                    <xsl:when test=".='UK'">Great Britain</xsl:when>
                    <xsl:when test=".='NL'">Netherlands</xsl:when>
                    <xsl:when test=".='NOR'">Norway</xsl:when>
                    <xsl:when test=".='PT'">Portugal</xsl:when>
                    <xsl:when test=".='SP'">Spain</xsl:when>
                    <xsl:when test=".='SW'">Sweden</xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:with-param>
            <xsl:with-param name="p" select="$prefix"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="lang_code">
        <xsl:call-template name="insertCustomElement">
            <xsl:with-param name="localname" select="'language_code_id'"/>
            <xsl:with-param name="value" select="text()"/>
            <xsl:with-param name="p" select="$prefix"/>
        </xsl:call-template>
        <xsl:call-template name="insertCustomElement">
            <xsl:with-param name="localname" select="'language_code_label'"/>
            <xsl:with-param name="value">
                <xsl:choose>
                    <xsl:when test=".='CA'">Catalan</xsl:when>
                    <xsl:when test=".='DK'">Danish</xsl:when>
                    <xsl:when test=".='NL'">Dutch</xsl:when>
                    <xsl:when test=".='UK'">English</xsl:when>
                    <xsl:when test=".='FR'">French</xsl:when>
                    <xsl:when test=".='GE'">German</xsl:when>
                    <xsl:when test=".='GR'">Greek</xsl:when>
                    <xsl:when test=".='NO'">Norwegian</xsl:when>
                    <xsl:when test=".='PT'">Portugese</xsl:when>
                    <xsl:when test=".='SP'">Spanish</xsl:when>
                    <xsl:when test=".='SW'">Swedish</xsl:when>
                </xsl:choose>
            </xsl:with-param>
            <xsl:with-param name="p" select="$prefix"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="provenance">
        <xsl:call-template name="insertCustomElement">
            <xsl:with-param name="localname" select="'provenance_id'"/>
            <xsl:with-param name="value" select="text()"/>
            <xsl:with-param name="p" select="$prefix"/>
        </xsl:call-template>
        <xsl:call-template name="insertCustomElement">
            <xsl:with-param name="localname" select="'provenance_label'"/>
            <xsl:with-param name="value">
                <xsl:choose>
                    <xsl:when test=".='BALSAC1'">BALSAC database 1842-1971</xsl:when>
                    <xsl:when test=".='DDA'">Danish Data Archive census 1800</xsl:when>
                    <xsl:when test=".='DDB1'">Demographic Data Base 1803-1900</xsl:when>
                    <xsl:when test=".='HSN1'">Historical Sample of the Netherlands 1: 1850-1940</xsl:when>
                    <xsl:when test=".='HSN2'">Historical Sample of the Netherlands 2: 1850-1940</xsl:when>
                    <xsl:when test=".='DA1'">History Data Service 1851</xsl:when>
                    <xsl:when test=".='Knodel'">Knodel Village Genealogy Sample 1692-1950</xsl:when>
                    <xsl:when test=".='LNP'">Leuven nuptiality project 1800-1913</xsl:when>
                    <xsl:when test=".='LIT1'">Leverhulme Literacy Sample 1839-1914 1839-1914</xsl:when>
                    <xsl:when test=".='MYK'">Mykonos marriage acts 1859-1959</xsl:when>
                    <xsl:when test=".='NHDC1'">Norwegian Historical Data Centre 1900</xsl:when>
                    <xsl:when test=".='PACO'">PACO 16th-19th C</xsl:when>
                    <xsl:when test=".='SPCAT'">Spanish and Catalonian titles in Catalonian sources</xsl:when>
                    <xsl:when test=".='TRAprelim'">TRA preliminary version 1803-1970</xsl:when>
                    <xsl:when test=".='TRA1'">TRA survey 1803-1945</xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:with-param>
            <xsl:with-param name="p" select="$prefix"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="link_id">
        <xsl:call-template name="insertCustomElement">
            <xsl:with-param name="localname" select="'occupations_id'"/>
            <xsl:with-param name="value" select="text()"/>
            <xsl:with-param name="p" select="$prefix"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="hisco_id">
        <xsl:if test="not(text()='-1')">
            <xsl:call-template name="insertCustomElement">
                <xsl:with-param name="localname" select="local-name(.)"/>
                <xsl:with-param name="value" select="text()"/>
                <xsl:with-param name="p" select="$prefix"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template match="node()">
        <xsl:call-template name="insertCustomElement">
            <xsl:with-param name="localname" select="local-name(.)"/>
            <xsl:with-param name="value" select="text()"/>
            <xsl:with-param name="p" select="$prefix"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="insertCustomElement">
        <xsl:param name="localname"/>
        <xsl:param name="value"/>
        <xsl:param name="p"/>
        <xsl:if test="$value">
            <xsl:element name="{concat($p, ':', lower-case($localname))}">
                <xsl:value-of select="normalize-space($value)"/>
            </xsl:element>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
