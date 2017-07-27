<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet
        version="2.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:ead="urn:isbn:1-931666-22-9"
        xmlns:marc="http://www.loc.gov/MARC21/slim"
        xmlns:iisg="http://www.iisg.nl/api/sru/"
        xmlns:xlink="http://www.w3.org/1999/xlink"
        exclude-result-prefixes="ead iisg marc xlink">

    <xsl:import href="../../../xslt/insertElement.xsl"/>
    <xsl:import href="../../../xslt/punctionation.xsl"/>
    <xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
    <xsl:strip-space elements="*"/>
    <xsl:param name="marc_controlfield_005"/>
    <xsl:param name="marc_controlfield_008"/>
    <xsl:param name="date_modified"/>
    <xsl:param name="collectionName"/>

    <xsl:template match="ead:ead">

        <xsl:variable name="identifier"
                      select="substring(ead:eadheader/ead:eadid/@identifier, 5)"/>
        <!-- remove the hdl: part -->

        <record>
            <extraRecordData>
                <iisg:iisg>
                    <xsl:call-template name="insertIISHIdentifiers">
                        <xsl:with-param name="identifier" select="$identifier"/>
                    </xsl:call-template>
                    <iisg:collectionName>iisg_ead</iisg:collectionName>
                    <iisg:collectionName>iisg.archieven.1</iisg:collectionName>
                    <xsl:call-template name="insertCollection">
                        <xsl:with-param name="collection" select="$collectionName"/>
                    </xsl:call-template>
                    <iisg:isShownAt>
                        <xsl:value-of
                                select="concat('http://hdl.handle.net/', $identifier)"/>
                    </iisg:isShownAt>
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

            <marc:leader>00620npc a22     7i 4500</marc:leader>

            <marc:controlfield tag="001">
                <xsl:value-of select="$identifier"/>
            </marc:controlfield>

            <marc:controlfield tag="003">NL-AmISG</marc:controlfield>

            <!-- For language codes see
            http://www.loc.gov/standards/codelists/languages.xml
            -->
            <xsl:variable name="lm" select="//ead:langmaterial/ead:language/@langcode"/>

            <marc:controlfield tag="008">

                <xsl:variable name="year_from">
                    <xsl:variable name="year"
                                  select="substring-before(ead:archdesc/ead:did/ead:unitdate/@normal, '/')"/>
                    <xsl:choose>
                        <xsl:when test="string-length($year)=0">
                            <xsl:value-of select="ead:archdesc/ead:did/ead:unitdate/@normal"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$year"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

                <xsl:variable name="year_until">
                    <xsl:variable name="year"
                                  select="substring-after(ead:archdesc/ead:did/ead:unitdate/@normal, '/')"/>
                    <xsl:choose>
                        <xsl:when test="string-length($year)=0">
                            <xsl:value-of select="ead:archdesc/ead:did/ead:unitdate/@normal"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$year"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

                <xsl:variable name="year">
                    <xsl:choose>
                        <xsl:when test="string-length($year_from)=0 and string-length($year_until)=0">uuuu</xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat($year_from, $year_until)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

                <xsl:variable name="place">
                    <xsl:variable name="tmp"
                                  select="ead:archdesc/ead:descgrp[@type='content_and_structure']/ead:controlaccess/ead:controlaccess/ead:geogname[@role='country of origin']/@normal"/>
                    <xsl:choose>
                        <xsl:when test="$tmp='AO'">ao </xsl:when>
                        <xsl:when test="$tmp='AR'">ag </xsl:when>
                        <xsl:when test="$tmp='AM'">ai </xsl:when>
                        <xsl:when test="$tmp='AU'">au </xsl:when>
                        <xsl:when test="$tmp='AT'">at </xsl:when>
                        <xsl:when test="$tmp='AZ'">aj </xsl:when>
                        <xsl:when test="$tmp='BD'">bg </xsl:when>
                        <xsl:when test="$tmp='BE'">be </xsl:when>
                        <xsl:when test="$tmp='BO'">bo </xsl:when>
                        <xsl:when test="$tmp='BR'">bl </xsl:when>
                        <xsl:when test="$tmp='BG'">bu </xsl:when>
                        <xsl:when test="$tmp='KH'">cb </xsl:when>
                        <xsl:when test="$tmp='CM'">cm </xsl:when>
                        <xsl:when test="$tmp='CL'">cl </xsl:when>
                        <xsl:when test="$tmp='CN'">ch </xsl:when>
                        <xsl:when test="$tmp='HR'">ci </xsl:when>
                        <xsl:when test="$tmp='CU'">cu </xsl:when>
                        <xsl:when test="$tmp='CZ'">xr </xsl:when>
                        <xsl:when test="$tmp='CS'">cs </xsl:when>
                        <xsl:when test="$tmp='CSHH'">cs </xsl:when>
                        <xsl:when test="$tmp='DK'">dk </xsl:when>
                        <xsl:when test="$tmp='EG'">ua </xsl:when>
                        <xsl:when test="$tmp='SV'">es </xsl:when>
                        <xsl:when test="$tmp='FR'">fr </xsl:when>
                        <xsl:when test="$tmp='GE'">gs </xsl:when>
                        <xsl:when test="$tmp='DE'">gw </xsl:when>
                        <xsl:when test="$tmp='GB'">gb </xsl:when>
                        <xsl:when test="$tmp='GR'">gr </xsl:when>
                        <xsl:when test="$tmp='GD'">gd </xsl:when>
                        <xsl:when test="$tmp='GT'">gt </xsl:when>
                        <xsl:when test="$tmp='HK'">hk </xsl:when>
                        <xsl:when test="$tmp='HU'">hu </xsl:when>
                        <xsl:when test="$tmp='IN'">ii </xsl:when>
                        <xsl:when test="$tmp='ID'">io </xsl:when>
                        <xsl:when test="$tmp='IA'">vp </xsl:when>
                        <xsl:when test="$tmp='IR'">ir </xsl:when>
                        <xsl:when test="$tmp='IQ'">iq </xsl:when>
                        <xsl:when test="$tmp='IE'">ie </xsl:when>
                        <xsl:when test="$tmp='IL'">is </xsl:when>
                        <xsl:when test="$tmp='IT'">it </xsl:when>
                        <xsl:when test="$tmp='LV'">lv </xsl:when>
                        <xsl:when test="$tmp='LB'">le </xsl:when>
                        <xsl:when test="$tmp='MK'">xn </xsl:when>
                        <xsl:when test="$tmp='MY'">my </xsl:when>
                        <xsl:when test="$tmp='MX'">mx </xsl:when>
                        <xsl:when test="$tmp='BU'">br </xsl:when>
                        <xsl:when test="$tmp='MM'">br </xsl:when>
                        <xsl:when test="$tmp='NA'">sx </xsl:when>
                        <xsl:when test="$tmp='NL'">ne </xsl:when>
                        <xsl:when test="$tmp='NI'">nq </xsl:when>
                        <xsl:when test="$tmp='NE'">ng </xsl:when>
                        <xsl:when test="$tmp='NG'">nr </xsl:when>
                        <xsl:when test="$tmp='PK'">pk </xsl:when>
                        <xsl:when test="$tmp='PY'">py </xsl:when>
                        <xsl:when test="$tmp='PE'">pe </xsl:when>
                        <xsl:when test="$tmp='PH'">ph </xsl:when>
                        <xsl:when test="$tmp='PL'">pl </xsl:when>
                        <xsl:when test="$tmp='PT'">po </xsl:when>
                        <xsl:when test="$tmp='PR'">pr </xsl:when>
                        <xsl:when test="$tmp='RO'">ru </xsl:when>
                        <xsl:when test="$tmp='RU'">ru </xsl:when>
                        <xsl:when test="$tmp='SA'">su </xsl:when>
                        <xsl:when test="$tmp='SI'">xv </xsl:when>
                        <xsl:when test="$tmp='ZA'">sa </xsl:when>
                        <xsl:when test="$tmp='SU'">xxr</xsl:when>
                        <xsl:when test="$tmp='SUHH'">xxr</xsl:when>
                        <xsl:when test="$tmp='ES'">sp </xsl:when>
                        <xsl:when test="$tmp='LK'">ce </xsl:when>
                        <xsl:when test="$tmp='SD'">sj </xsl:when>
                        <xsl:when test="$tmp='SR'">sr </xsl:when>
                        <xsl:when test="$tmp='SE'">sw </xsl:when>
                        <xsl:when test="$tmp='CH'">sz </xsl:when>
                        <xsl:when test="$tmp='TH'">th </xsl:when>
                        <xsl:when test="$tmp='TR'">tu </xsl:when>
                        <xsl:when test="$tmp='UK'">xxk</xsl:when>
                        <xsl:when test="$tmp='US'">xxu</xsl:when>
                        <xsl:when test="$tmp='VN'">vm </xsl:when>
                        <xsl:when test="$tmp='YU'">yu </xsl:when>
                        <xsl:when test="$tmp='SG'">si </xsl:when>
                        <xsl:when test="$tmp='SN'">sg </xsl:when>
                        <xsl:when test="$tmp='CG'">cg </xsl:when>
                        <xsl:when test="$tmp='AW'">aw </xsl:when>
                        <xsl:when test="$tmp='ET'">et </xsl:when>
                        <xsl:when test="$tmp='KE'">ke </xsl:when>
                        <xsl:when test="$tmp='MA'">mr </xsl:when>
                        <xsl:when test="$tmp='SO'">so </xsl:when>
                        <xsl:when test="$tmp='NP'">np </xsl:when>
                        <xsl:when test="$tmp='MZ'">mz </xsl:when>
                        <xsl:when test="$tmp='GH'">gh </xsl:when>
                        <xsl:when test="$tmp='LU'">lu </xsl:when>
                        <xsl:when test="$tmp='TN'">ti </xsl:when>
                        <xsl:when test="$tmp='VE'">ve </xsl:when>
                        <xsl:when test="$tmp='NZ'">nz </xsl:when>
                        <xsl:when test="$tmp='UY'">uy </xsl:when>
                        <xsl:when test="$tmp='NO'">no </xsl:when>
                        <xsl:when test="$tmp='JM'">jm </xsl:when>
                        <xsl:when test="$tmp='HN'">ho </xsl:when>
                        <xsl:when test="$tmp='HT'">ht </xsl:when>
                        <xsl:otherwise><xsl:text>   </xsl:text></xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

                <xsl:variable name="firstlanguagematerial">
                    <xsl:choose>
                        <xsl:when test="count($lm)=0">
                            <xsl:text>und</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="normalize-space($lm[1])"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

                <xsl:value-of
                        select="concat('110701i', $year, $place, '                 ', $firstlanguagematerial, ' d')"/>
            </marc:controlfield>

            <marc:datafield tag="040" ind1=" " ind2=" ">
                <marc:subfield code="a">NL-AmISG</marc:subfield>
            </marc:datafield>

            <xsl:if test="count($lm)>1">
                <marc:datafield tag="041" ind1=" " ind2=" ">
                    <xsl:for-each select="$lm">
                        <marc:subfield code="a">
                            <xsl:value-of select="normalize-space(.)"/>
                        </marc:subfield>
                    </xsl:for-each>
                </marc:datafield>
            </xsl:if>

            <!--
                                <xsl:if test="//node()[@encodinganalog='044$c']">
                                    <marc:datafield tag="044" ind1=" " ind2=" ">
                                        <xsl:for-each select="//node()[@encodinganalog='044$c']">
                                            <marc:subfield code="c">
                                                <xsl:value-of select="lower-case(@normal)"/>
                                            </marc:subfield>
                                        </xsl:for-each>
                                    </marc:datafield>
                                </xsl:if>
            -->

            <xsl:for-each select="//node()[@encodinganalog='100$a']">
                <xsl:if test="position()=1">
                    <marc:datafield tag="100" ind1="1" ind2=" ">
                        <xsl:call-template name="subfield">
                            <xsl:with-param name="encodinganalog" select="@encodinganalog"/>
                            <xsl:with-param name="text" select="normalize-space(text())"/>
                        </xsl:call-template>
                        <marc:subfield code="e">creator</marc:subfield>
                    </marc:datafield>
                </xsl:if>
            </xsl:for-each>

            <xsl:for-each select="//node()[@encodinganalog='110$a']">
                <xsl:if test="position()=1">
                    <marc:datafield tag="110" ind1="2" ind2=" ">
                        <xsl:call-template name="subfield">
                            <xsl:with-param name="encodinganalog" select="@encodinganalog"/>
                            <xsl:with-param name="text" select="normalize-space(text())"/>
                        </xsl:call-template>
                        <xsl:if test="node()[@encodinganalog='110$b']">
                            <marc:subfield code="b">
                                <xsl:value-of select="normalize-space(node()[@encodinganalog='110$b'])"/>
                            </marc:subfield>
                        </xsl:if>
                        <marc:subfield code="e">creator</marc:subfield>
                    </marc:datafield>
                </xsl:if>
            </xsl:for-each>

            <xsl:for-each select="//node()[@encodinganalog='130$a']">
                <xsl:if test="position()=1">
                    <marc:datafield tag="130" ind1="1" ind2=" ">
                        <xsl:call-template name="subfield">
                            <xsl:with-param name="encodinganalog" select="@encodinganalog"/>
                            <xsl:with-param name="text" select="normalize-space(text())"/>
                        </xsl:call-template>
                        <marc:subfield code="k">collection</marc:subfield>
                    </marc:datafield>
                </xsl:if>
            </xsl:for-each>

            <marc:datafield tag="245" ind1="1" ind2=" ">
                <xsl:for-each select="//node()[starts-with(@encodinganalog,'245$')]">
                    <xsl:sort select="@encodinganalog" data-type="text"/>
                    <xsl:call-template name="subfield">
                        <xsl:with-param name="encodinganalog" select="@encodinganalog"/>
                        <xsl:with-param name="text" select="normalize-space(text())"/>
                    </xsl:call-template>
                </xsl:for-each>
            </marc:datafield>

            <xsl:for-each select="//node()[starts-with(@encodinganalog,'260$b')]">
                <marc:datafield tag="260" ind1=" " ind2=" ">
                    <marc:subfield code="a">Amsterdam :</marc:subfield>
                    <xsl:call-template name="subfield">
                        <xsl:with-param name="encodinganalog" select="@encodinganalog"/>
                        <xsl:with-param name="text">
                            <xsl:value-of select="normalize-space(text())"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </marc:datafield>
            </xsl:for-each>

            <xsl:for-each select="//node()[starts-with(@encodinganalog,'300$')]">
                <xsl:sort select="@encodinganalog" data-type="text"/>
                <marc:datafield tag="300" ind1=" " ind2=" ">
                    <xsl:call-template name="subfield">
                        <xsl:with-param name="encodinganalog" select="@encodinganalog"/>
                        <xsl:with-param name="text" select="normalize-space(text())"/>
                    </xsl:call-template>
                </marc:datafield>
            </xsl:for-each>

            <xsl:for-each select="//node()[starts-with(@encodinganalog,'351$b')]">
                <marc:datafield tag="351" ind1=" " ind2=" ">
                    <xsl:call-template name="subfield">
                        <xsl:with-param name="encodinganalog" select="@encodinganalog"/>
                        <xsl:with-param name="text">
                            <xsl:apply-templates select="node()" mode="text" />
                        </xsl:with-param>
                    </xsl:call-template>
                </marc:datafield>
            </xsl:for-each>

            <xsl:for-each select="//node()[starts-with(@encodinganalog,'500$a')]">
                <marc:datafield tag="500" ind1=" " ind2=" ">
                    <xsl:call-template name="subfield">
                        <xsl:with-param name="encodinganalog" select="@encodinganalog"/>
                        <xsl:with-param name="text">
                            <xsl:apply-templates select="node()" mode="text" />
                        </xsl:with-param>
                    </xsl:call-template>
                </marc:datafield>
            </xsl:for-each>

            <xsl:for-each select="//node()[starts-with(@encodinganalog,'506$')]">
                <xsl:sort select="@encodinganalog" data-type="text"/>
                <xsl:variable name="p1" select="ead:p[1]"/>
                <xsl:variable name="p2" select="ead:p[2]"/>
                <marc:datafield tag="506" ind1=" " ind2=" ">
                    <marc:subfield code="a">
                        <xsl:value-of select="$p1"/>
                    </marc:subfield>
                    <xsl:if test="$p2">
                        <marc:subfield code="b">
                            <xsl:value-of select="$p2"/>
                        </marc:subfield>
                    </xsl:if>
                    <xsl:variable name="href" select="ead:p[2]/ead:extref/@href"/>
                    <xsl:if test="$href">
                        <marc:subfield code="c">
                            <xsl:value-of select="$href"/>
                        </marc:subfield>
                    </xsl:if>
                </marc:datafield>
            </xsl:for-each>

            <xsl:for-each select="//node()[starts-with(@encodinganalog,'520$')]">
                <xsl:sort select="@encodinganalog" data-type="text"/>
                <marc:datafield tag="520" ind1=" " ind2=" ">
                    <xsl:call-template name="subfield">
                        <xsl:with-param name="encodinganalog" select="@encodinganalog"/>
                        <xsl:with-param name="text">
                            <xsl:choose>
                                <xsl:when test="ead:p"><xsl:apply-templates select="node()" mode="text" /></xsl:when>
                                <xsl:otherwise><xsl:value-of select="text()"/></xsl:otherwise>
                            </xsl:choose>
                        </xsl:with-param>
                    </xsl:call-template>
                </marc:datafield>
            </xsl:for-each>

            <xsl:for-each select="//node()[starts-with(@encodinganalog,'524$a')]">
                <marc:datafield tag="524" ind1=" " ind2=" ">
                    <xsl:call-template name="subfield">
                        <xsl:with-param name="encodinganalog" select="@encodinganalog"/>
                        <xsl:with-param name="text">
                            <xsl:choose>
                                <xsl:when test="ead:p"><xsl:apply-templates select="node()" mode="text" /></xsl:when>
                                <xsl:otherwise><xsl:value-of select="text()"/></xsl:otherwise>
                            </xsl:choose>
                        </xsl:with-param>
                    </xsl:call-template>
                </marc:datafield>
            </xsl:for-each>

            <xsl:for-each select="//node()[starts-with(@encodinganalog,'530$a')]">
                <marc:datafield tag="530" ind1=" " ind2=" ">
                    <xsl:call-template name="subfield">
                        <xsl:with-param name="encodinganalog" select="@encodinganalog"/>
                        <xsl:with-param name="text">
                            <xsl:choose>
                                <xsl:when test="ead:p"><xsl:apply-templates select="node()" mode="text" /></xsl:when>
                                <xsl:otherwise><xsl:value-of select="text()"/></xsl:otherwise>
                            </xsl:choose>
                        </xsl:with-param>
                    </xsl:call-template>
                </marc:datafield>
            </xsl:for-each>

            <xsl:for-each select="//node()[starts-with(@encodinganalog,'535$a') and not(@audience='internal')]">
                <marc:datafield tag="535" ind1=" " ind2=" ">
                    <xsl:call-template name="subfield">
                        <xsl:with-param name="encodinganalog" select="@encodinganalog"/>
                        <xsl:with-param name="text">
                            <xsl:choose>
                                <xsl:when test="ead:p"><xsl:apply-templates select="node()" mode="text" /></xsl:when>
                                <xsl:otherwise><xsl:value-of select="text()"/></xsl:otherwise>
                            </xsl:choose>
                        </xsl:with-param>
                    </xsl:call-template>
                </marc:datafield>
            </xsl:for-each>

            <xsl:for-each select="//node()[starts-with(@encodinganalog,'540$a') and not(@audience='internal')]">
                <marc:datafield tag="540" ind1=" " ind2=" ">
                    <xsl:call-template name="subfield">
                        <xsl:with-param name="encodinganalog" select="@encodinganalog"/>
                        <xsl:with-param name="text">
                            <xsl:choose>
                                <xsl:when test="ead:p"><xsl:apply-templates select="node()" mode="text" /></xsl:when>
                                <xsl:otherwise><xsl:value-of select="text()"/></xsl:otherwise>
                            </xsl:choose>
                        </xsl:with-param>
                    </xsl:call-template>
                </marc:datafield>
            </xsl:for-each>

            <xsl:for-each select="//node()[starts-with(@encodinganalog,'541$a') and not(@audience='internal')]">
                <marc:datafield tag="541" ind1=" " ind2=" ">
                    <xsl:call-template name="subfield">
                        <xsl:with-param name="encodinganalog" select="@encodinganalog"/>
                        <xsl:with-param name="text">
                            <xsl:choose>
                                <xsl:when test="ead:p"><xsl:apply-templates select="node()" mode="text" /></xsl:when>
                                <xsl:otherwise><xsl:value-of select="text()"/></xsl:otherwise>
                            </xsl:choose>
                        </xsl:with-param>
                    </xsl:call-template>
                </marc:datafield>
            </xsl:for-each>

            <xsl:for-each select="//node()[starts-with(@encodinganalog,'544$a') and not(@audience='internal')]">
                <marc:datafield tag="544" ind1=" " ind2=" ">
                    <xsl:call-template name="subfield">
                        <xsl:with-param name="encodinganalog" select="@encodinganalog"/>
                        <xsl:with-param name="text">
                            <xsl:choose>
                                <xsl:when test="ead:p"><xsl:apply-templates select="node()" mode="text" /></xsl:when>
                                <xsl:otherwise><xsl:value-of select="text()"/></xsl:otherwise>
                            </xsl:choose>
                        </xsl:with-param>
                    </xsl:call-template>
                </marc:datafield>
            </xsl:for-each>


            <xsl:for-each select="//node()[starts-with(@encodinganalog,'545$') and not(@audience='internal')]">
                <xsl:sort select="@encodinganalog" data-type="text"/>
                <marc:datafield tag="545" ind1=" " ind2=" ">
                    <xsl:call-template name="subfield">
                        <xsl:with-param name="encodinganalog" select="@encodinganalog"/>
                        <xsl:with-param name="text">
                            <xsl:choose>
                                <xsl:when test="ead:p"><xsl:apply-templates select="node()" mode="text" /></xsl:when>
                                <xsl:otherwise><xsl:value-of select="text()"/></xsl:otherwise>
                            </xsl:choose>
                        </xsl:with-param>
                    </xsl:call-template>
                </marc:datafield>
            </xsl:for-each>

            <xsl:for-each select="//node()[starts-with(@encodinganalog,'561$') and not(@audience='internal')]">
                <xsl:sort select="@encodinganalog" data-type="text"/>
                <marc:datafield tag="561" ind1=" " ind2=" ">
                    <xsl:call-template name="subfield">
                        <xsl:with-param name="encodinganalog" select="@encodinganalog"/>
                        <xsl:with-param name="text">
                            <xsl:choose>
                                <xsl:when test="ead:p"><xsl:apply-templates select="node()" mode="text" /></xsl:when>
                                <xsl:otherwise><xsl:value-of select="text()"/></xsl:otherwise>
                            </xsl:choose>
                        </xsl:with-param>
                    </xsl:call-template>
                </marc:datafield>
            </xsl:for-each>

            <xsl:for-each select="//node()[starts-with(@encodinganalog,'583$a') and not(@audience='internal')]">
                <marc:datafield tag="583" ind1=" " ind2=" ">
                    <xsl:call-template name="subfield">
                        <xsl:with-param name="encodinganalog" select="@encodinganalog"/>
                        <xsl:with-param name="text">
                            <xsl:choose>
                                <xsl:when test="ead:p"><xsl:apply-templates select="node()" mode="text" /></xsl:when>
                                <xsl:otherwise><xsl:value-of select="text()"/></xsl:otherwise>
                            </xsl:choose>
                        </xsl:with-param>
                    </xsl:call-template>
                </marc:datafield>
            </xsl:for-each>

            <xsl:for-each select="//node()[starts-with(@encodinganalog,'600$a') and not(@audience='internal')]">
                <marc:datafield tag="600" ind1="1" ind2="4">
                    <xsl:call-template name="subfield">
                        <xsl:with-param name="encodinganalog" select="@encodinganalog"/>
                        <xsl:with-param name="text">
                            <xsl:choose>
                                <xsl:when test="ead:p"><xsl:apply-templates select="node()" mode="text" /></xsl:when>
                                <xsl:otherwise><xsl:value-of select="text()"/></xsl:otherwise>
                            </xsl:choose>
                        </xsl:with-param>
                    </xsl:call-template>
                </marc:datafield>
            </xsl:for-each>

            <xsl:for-each select="//node()[starts-with(@encodinganalog,'610$a') and not(@audience='internal')]">
                <marc:datafield tag="610" ind1="2" ind2="4">
                    <xsl:call-template name="subfield">
                        <xsl:with-param name="encodinganalog" select="@encodinganalog"/>
                        <xsl:with-param name="text">
                            <xsl:choose>
                                <xsl:when test="ead:p"><xsl:apply-templates select="node()" mode="text" /></xsl:when>
                                <xsl:otherwise><xsl:value-of select="text()"/></xsl:otherwise>
                            </xsl:choose>
                        </xsl:with-param>
                    </xsl:call-template>
                </marc:datafield>
            </xsl:for-each>

            <xsl:for-each select="//node()[starts-with(@encodinganalog,'650$a') and not(@audience='internal')]">
                <marc:datafield tag="650" ind1=" " ind2=" ">
                    <xsl:call-template name="subfield">
                        <xsl:with-param name="encodinganalog" select="@encodinganalog"/>
                        <xsl:with-param name="text">
                            <xsl:value-of select="text()"/>
                            <xsl:if test="not(position()=last())">
                                <xsl:text> </xsl:text>
                            </xsl:if>
                        </xsl:with-param>
                    </xsl:call-template>
                </marc:datafield>
            </xsl:for-each>

            <xsl:for-each select="//ead:controlaccess/ead:controlaccess/ead:geogname">
                <xsl:call-template name="insertSingleElement">
                    <xsl:with-param name="tag" select="'651'"/>
                    <xsl:with-param name="code" select="'a'"/>
                    <xsl:with-param name="ind2" select="'4'"/>
                    <xsl:with-param name="value"
                                    select="text()"/>
                </xsl:call-template>
            </xsl:for-each>

            <xsl:for-each select="//node()[starts-with(@encodinganalog,'655$a') and not(@audience='internal')]">
                <marc:datafield tag="655" ind1=" " ind2=" ">
                    <xsl:call-template name="subfield">
                        <xsl:with-param name="encodinganalog" select="@encodinganalog"/>
                        <xsl:with-param name="text">
                            <xsl:value-of select="text()"/>
                            <xsl:if test="not(position()=last())">
                                <xsl:text> </xsl:text>
                            </xsl:if>
                        </xsl:with-param>
                    </xsl:call-template>
                </marc:datafield>
            </xsl:for-each>

            <xsl:for-each select="//node()[@encodinganalog='100$a']">
                <xsl:if test="position()>1">
                    <marc:datafield tag="700" ind1="1" ind2=" ">
                        <xsl:call-template name="subfield">
                            <xsl:with-param name="encodinganalog" select="@encodinganalog"/>
                            <xsl:with-param name="text" select="normalize-space(text())"/>
                        </xsl:call-template>
                        <marc:subfield code="e">contributor</marc:subfield>
                    </marc:datafield>
                </xsl:if>
            </xsl:for-each>

            <xsl:for-each select="//node()[@encodinganalog='700$a']">
                <xsl:sort select="@encodinganalog" data-type="text"/>
                <marc:datafield tag="700" ind1="1" ind2=" ">
                    <xsl:call-template name="subfield">
                        <xsl:with-param name="encodinganalog" select="@encodinganalog"/>
                        <xsl:with-param name="text" select="normalize-space(text())"/>
                    </xsl:call-template>
                    <marc:subfield code="e">contributor</marc:subfield>
                </marc:datafield>
            </xsl:for-each>

            <xsl:for-each select="//node()[@encodinganalog='110$a']">
                <xsl:if test="position()>1">
                    <marc:datafield tag="110" ind1="2" ind2=" ">
                        <xsl:call-template name="subfield">
                            <xsl:with-param name="encodinganalog" select="@encodinganalog"/>
                            <xsl:with-param name="text" select="normalize-space(text())"/>
                        </xsl:call-template>
                        <xsl:if test="node()[@encodinganalog='710$b']">
                            <marc:subfield code="b">
                                <xsl:value-of select="normalize-space(node()[@encodinganalog='710$b'])"/>
                            </marc:subfield>
                        </xsl:if>
                        <marc:subfield code="e">contributor</marc:subfield>
                    </marc:datafield>
                </xsl:if>
            </xsl:for-each>

            <xsl:for-each select="//node()[@encodinganalog='710$a']">
                <xsl:sort select="@encodinganalog" data-type="text"/>
                <marc:datafield tag="710" ind1="2" ind2=" ">
                    <xsl:call-template name="subfield">
                        <xsl:with-param name="encodinganalog" select="@encodinganalog"/>
                        <xsl:with-param name="text" select="normalize-space(text())"/>
                    </xsl:call-template>
                    <marc:subfield code="e">contributor</marc:subfield>
                </marc:datafield>
            </xsl:for-each>

            <xsl:for-each select="//node()[starts-with(@encodinganalog,'720$a')]">
                <marc:datafield tag="720" ind1=" " ind2=" ">
                    <xsl:call-template name="subfield">
                        <xsl:with-param name="encodinganalog" select="@encodinganalog"/>
                        <xsl:with-param name="text" select="normalize-space(text())"/>
                    </xsl:call-template>
                </marc:datafield>
            </xsl:for-each>

            <xsl:for-each select="//node()[@encodinganalog='130$a']">
                <xsl:if test="position()>1">
                    <marc:datafield tag="730" ind1="1" ind2=" ">
                        <xsl:call-template name="subfield">
                            <xsl:with-param name="encodinganalog" select="@encodinganalog"/>
                            <xsl:with-param name="text" select="normalize-space(text())"/>
                        </xsl:call-template>
                        <marc:subfield code="k">contributor</marc:subfield>
                    </marc:datafield>
                </xsl:if>
            </xsl:for-each>

            <xsl:for-each select="//node()[@encodinganalog='730$a']">
                <xsl:sort select="@encodinganalog" data-type="text"/>
                <marc:datafield tag="730" ind1="1" ind2=" ">
                    <xsl:call-template name="subfield">
                        <xsl:with-param name="encodinganalog" select="@encodinganalog"/>
                        <xsl:with-param name="text" select="normalize-space(text())"/>
                    </xsl:call-template>
                    <marc:subfield code="k">contributor</marc:subfield>
                </marc:datafield>
            </xsl:for-each>

            <marc:datafield tag="852" ind1=" " ind2=" ">
                <marc:subfield code="a">
                    <xsl:value-of select="//node()[starts-with(@encodinganalog,'852$')]/ead:corpname"/>
                </marc:subfield>
                <marc:subfield code="j">
                    <xsl:value-of select="//node()[@encodinganalog='852$j']"/><xsl:value-of select="text()"/>
                </marc:subfield>
            </marc:datafield>

            <marc:datafield tag="856" ind1="4" ind2=" ">
                <marc:subfield code="q">text/xml</marc:subfield>
                <marc:subfield code="u">
                    <xsl:value-of select="concat('http://hdl.handle.net/', $identifier, '?locatt=view:ead')"/>
                </marc:subfield>
            </marc:datafield>

            <!-- A representative image -->
            <xsl:variable name="digital_items"
                          select="//ead:daogrp[ead:daoloc[starts-with(@xlink:href, 'http://hdl.handle.net/10622/')]]"/>
            <xsl:if test="count($digital_items)>0">
                <marc:datafield tag="856" ind1="4" ind2="2">
                    <marc:subfield code="q">image/jpeg</marc:subfield>
                    <marc:subfield code="u">
                        <xsl:value-of
                                select="concat('http://hdl.handle.net/', $identifier, '?locatt=view:level3')"/>
                    </marc:subfield>
                </marc:datafield>
            </xsl:if>

            <xsl:call-template name="insertSingleElement">
                <xsl:with-param name="tag" select="'902'"/>
                <xsl:with-param name="code" select="'a'"/>
                <xsl:with-param name="value" select="$identifier"/>
            </xsl:call-template>

                </marc:record>
            </recordData>
        </record>

    </xsl:template>

    <xsl:template name="subfield">
        <xsl:param name="encodinganalog"/>
        <xsl:param name="text"/>
        <xsl:variable name="code" select="substring($encodinganalog, 5, 1)"/>
        <marc:subfield code="{$code}">
            <xsl:value-of select="$text"/>
        </marc:subfield>
    </xsl:template>

    <xsl:template match="@*|node()" mode="text">
        <xsl:if test="local-name()='date'"><xsl:value-of select="text()"/></xsl:if>
        <xsl:if test="local-name()='p'"><xsl:value-of select="text()"/></xsl:if>
        <xsl:if test="local-name()='extref'"><xsl:value-of select="concat(text(), ': ', @xlink:href, ' ; ')"/></xsl:if>
        <xsl:apply-templates select="@*|node()" mode="text"/>
    </xsl:template>

</xsl:stylesheet>
