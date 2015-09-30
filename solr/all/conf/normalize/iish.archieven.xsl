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

                    <marc:leader>00742npc a22001930a 45 0</marc:leader>

                    <marc:controlfield tag="001">
                        <xsl:value-of select="$identifier"/>
                    </marc:controlfield>

                    <!-- For language codes see
                    http://www.loc.gov/standards/codelists/languages.xml
                    -->
                    <xsl:variable name="lm" select="//ead:langmaterial/ead:language/@langcode"/>

                    <!--
                      http://www.loc.gov/marc/bibliographic/bd044.html
                    -->
                    <marc:controlfield tag="008">
                        <xsl:variable name="tmp"
                                      select="lower-case(normalize-space(//ead:controlaccess/ead:geogname[@encodinganalog='044$c'][0]/@normal))"/>
                        <xsl:variable name="geocode">
                            <xsl:choose>
                                <xsl:when test="$tmp='ao'">ao</xsl:when>
                                <xsl:when test="$tmp='ar'">ag</xsl:when>
                                <xsl:when test="$tmp='am'">ai</xsl:when>
                                <xsl:when test="$tmp='au'">au</xsl:when>
                                <xsl:when test="$tmp='at'">at</xsl:when>
                                <xsl:when test="$tmp='az'">aj</xsl:when>
                                <xsl:when test="$tmp='bd'">bg</xsl:when>
                                <xsl:when test="$tmp='be'">be</xsl:when>
                                <xsl:when test="$tmp='bo'">bo</xsl:when>
                                <xsl:when test="$tmp='br'">bl</xsl:when>
                                <xsl:when test="$tmp='bg'">bu</xsl:when>
                                <xsl:when test="$tmp='kh'">cb</xsl:when>
                                <xsl:when test="$tmp='cm'">cm</xsl:when>
                                <xsl:when test="$tmp='cl'">cl</xsl:when>
                                <xsl:when test="$tmp='cn'">ch</xsl:when>
                                <xsl:when test="$tmp='hr'">ci</xsl:when>
                                <xsl:when test="$tmp='cu'">cu</xsl:when>
                                <xsl:when test="$tmp='cz'">xr</xsl:when>
                                <xsl:when test="$tmp='cs'">cs</xsl:when>
                                <xsl:when test="$tmp='cshh'">cs</xsl:when>
                                <xsl:when test="$tmp='dk'">dk</xsl:when>
                                <xsl:when test="$tmp='eg'">ua</xsl:when>
                                <xsl:when test="$tmp='sv'">es</xsl:when>
                                <xsl:when test="$tmp='fr'">fr</xsl:when>
                                <xsl:when test="$tmp='ge'">gs</xsl:when>
                                <xsl:when test="$tmp='de'">gw</xsl:when>
                                <xsl:when test="$tmp='gb'">gb</xsl:when>
                                <xsl:when test="$tmp='gr'">gr</xsl:when>
                                <xsl:when test="$tmp='gd'">gd</xsl:when>
                                <xsl:when test="$tmp='gt'">gt</xsl:when>
                                <xsl:when test="$tmp='hk'">hk</xsl:when>
                                <xsl:when test="$tmp='hu'">hu</xsl:when>
                                <xsl:when test="$tmp='in'">ii</xsl:when>
                                <xsl:when test="$tmp='id'">io</xsl:when>
                                <xsl:when test="$tmp='ia'">vp</xsl:when>
                                <xsl:when test="$tmp='ir'">ir</xsl:when>
                                <xsl:when test="$tmp='iq'">iq</xsl:when>
                                <xsl:when test="$tmp='ie'">ie</xsl:when>
                                <xsl:when test="$tmp='il'">is</xsl:when>
                                <xsl:when test="$tmp='it'">it</xsl:when>
                                <xsl:when test="$tmp='lv'">lv</xsl:when>
                                <xsl:when test="$tmp='lb'">le</xsl:when>
                                <xsl:when test="$tmp='mk'">xn</xsl:when>
                                <xsl:when test="$tmp='my'">my</xsl:when>
                                <xsl:when test="$tmp='mx'">mx</xsl:when>
                                <xsl:when test="$tmp='bu'">br</xsl:when>
                                <xsl:when test="$tmp='mm'">br</xsl:when>
                                <xsl:when test="$tmp='na'">sx</xsl:when>
                                <xsl:when test="$tmp='nl'">ne</xsl:when>
                                <xsl:when test="$tmp='ni'">nq</xsl:when>
                                <xsl:when test="$tmp='ne'">ng</xsl:when>
                                <xsl:when test="$tmp='ng'">nr</xsl:when>
                                <xsl:when test="$tmp='pk'">pk</xsl:when>
                                <xsl:when test="$tmp='py'">py</xsl:when>
                                <xsl:when test="$tmp='pe'">pe</xsl:when>
                                <xsl:when test="$tmp='ph'">ph</xsl:when>
                                <xsl:when test="$tmp='pl'">pl</xsl:when>
                                <xsl:when test="$tmp='pt'">po</xsl:when>
                                <xsl:when test="$tmp='pr'">pr</xsl:when>
                                <xsl:when test="$tmp='ro'">ru</xsl:when>
                                <xsl:when test="$tmp='ru'">ru</xsl:when>
                                <xsl:when test="$tmp='sa'">su</xsl:when>
                                <xsl:when test="$tmp='si'">xv</xsl:when>
                                <xsl:when test="$tmp='za'">sa</xsl:when>
                                <xsl:when test="$tmp='su'">xxr</xsl:when>
                                <xsl:when test="$tmp='suhh'">xxr</xsl:when>
                                <xsl:when test="$tmp='es'">sp</xsl:when>
                                <xsl:when test="$tmp='lk'">ce</xsl:when>
                                <xsl:when test="$tmp='sd'">sj</xsl:when>
                                <xsl:when test="$tmp='sr'">sr</xsl:when>
                                <xsl:when test="$tmp='se'">sw</xsl:when>
                                <xsl:when test="$tmp='ch'">sz</xsl:when>
                                <xsl:when test="$tmp='th'">th</xsl:when>
                                <xsl:when test="$tmp='tr'">tu</xsl:when>
                                <xsl:when test="$tmp='uk'">xxk</xsl:when>
                                <xsl:when test="$tmp='us'">xxu</xsl:when>
                                <xsl:when test="$tmp='vn'">vm</xsl:when>
                                <xsl:when test="$tmp='yu'">yu</xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$tmp"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:variable name="firstlanguagematerial">
                            <xsl:choose>
                                <xsl:when test="count($lm)>0">
                                    <xsl:value-of select="normalize-space($lm[1])"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>   </xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:value-of
                                select="concat('199507suuuuuuuu', substring(concat($geocode, '   '), 1, 3),'|||||||||||||||||',$firstlanguagematerial,' d')"/>
                    </marc:controlfield>

                    <xsl:if test="$lm">
                        <marc:datafield tag="041" ind1=" " ind2=" ">
                            <xsl:for-each select="$lm">
                                <marc:subfield code="a">
                                    <xsl:value-of select="normalize-space(.)"/>
                                </marc:subfield>
                            </xsl:for-each>
                        </marc:datafield>
                    </xsl:if>

                    <xsl:if test="//node()[@encodinganalog='044$c']">
                        <marc:datafield tag="044" ind1=" " ind2=" ">
                            <xsl:for-each select="//node()[@encodinganalog='044$c']">
                                <marc:subfield code="c">
                                    <xsl:value-of select="lower-case(@normal)"/>
                                </marc:subfield>
                            </xsl:for-each>
                        </marc:datafield>
                    </xsl:if>

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
                                    <xsl:for-each select="ead:p">
                                        <xsl:value-of select="text()"/>
                                        <xsl:if test="not(position()=last())">
                                            <xsl:text> </xsl:text>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:with-param>
                            </xsl:call-template>
                        </marc:datafield>
                    </xsl:for-each>

                    <xsl:for-each select="//node()[starts-with(@encodinganalog,'500$a')]">
                        <marc:datafield tag="500" ind1=" " ind2=" ">
                            <xsl:call-template name="subfield">
                                <xsl:with-param name="encodinganalog" select="@encodinganalog"/>
                                <xsl:with-param name="text">
                                    <xsl:for-each select="ead:p">
                                        <xsl:value-of select="text()"/>
                                        <xsl:if test="not(position()=last())">
                                            <xsl:text> </xsl:text>
                                        </xsl:if>
                                    </xsl:for-each>
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
                                    <xsl:for-each select="ead:p">
                                        <xsl:value-of select="text()"/>
                                        <xsl:if test="not(position()=last())">
                                            <xsl:text> </xsl:text>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:with-param>
                            </xsl:call-template>
                        </marc:datafield>
                    </xsl:for-each>

                    <xsl:for-each select="//node()[starts-with(@encodinganalog,'524$a')]">
                        <marc:datafield tag="524" ind1=" " ind2=" ">
                            <xsl:call-template name="subfield">
                                <xsl:with-param name="encodinganalog" select="@encodinganalog"/>
                                <xsl:with-param name="text">
                                    <xsl:for-each select="ead:p">
                                        <xsl:value-of select="text()"/>
                                        <xsl:if test="not(position()=last())">
                                            <xsl:text> </xsl:text>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:with-param>
                            </xsl:call-template>
                        </marc:datafield>
                    </xsl:for-each>

                    <xsl:for-each select="//node()[starts-with(@encodinganalog,'530$a')]">
                        <marc:datafield tag="530" ind1=" " ind2=" ">
                            <xsl:call-template name="subfield">
                                <xsl:with-param name="encodinganalog" select="@encodinganalog"/>
                                <xsl:with-param name="text">
                                    <xsl:for-each select="ead:p">
                                        <xsl:value-of select="text()"/>
                                        <xsl:if test="not(position()=last())">
                                            <xsl:text> </xsl:text>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:with-param>
                            </xsl:call-template>
                        </marc:datafield>
                    </xsl:for-each>

                    <xsl:for-each select="//node()[starts-with(@encodinganalog,'535$a')]">
                        <marc:datafield tag="535" ind1=" " ind2=" ">
                            <xsl:call-template name="subfield">
                                <xsl:with-param name="encodinganalog" select="@encodinganalog"/>
                                <xsl:with-param name="text">
                                    <xsl:for-each select="ead:p">
                                        <xsl:value-of select="text()"/>
                                        <xsl:if test="not(position()=last())">
                                            <xsl:text> </xsl:text>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:with-param>
                            </xsl:call-template>
                        </marc:datafield>
                    </xsl:for-each>

                    <xsl:for-each select="//node()[starts-with(@encodinganalog,'544$a')]">
                        <marc:datafield tag="544" ind1=" " ind2=" ">
                            <xsl:call-template name="subfield">
                                <xsl:with-param name="encodinganalog" select="@encodinganalog"/>
                                <xsl:with-param name="text">
                                    <xsl:for-each select="ead:p">
                                        <xsl:value-of select="text()"/>
                                        <xsl:if test="not(position()=last())">
                                            <xsl:text> </xsl:text>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:with-param>
                            </xsl:call-template>
                        </marc:datafield>
                    </xsl:for-each>

                    <xsl:for-each select="//node()[starts-with(@encodinganalog,'545$')]">
                        <xsl:sort select="@encodinganalog" data-type="text"/>
                        <marc:datafield tag="545" ind1=" " ind2=" ">
                            <xsl:call-template name="subfield">
                                <xsl:with-param name="encodinganalog" select="@encodinganalog"/>
                                <xsl:with-param name="text">
                                    <xsl:for-each select="ead:p">
                                        <xsl:value-of select="text()"/>
                                        <xsl:if test="not(position()=last())"></xsl:if>
                                    </xsl:for-each>
                                </xsl:with-param>
                            </xsl:call-template>
                        </marc:datafield>
                    </xsl:for-each>

                    <xsl:for-each select="//node()[starts-with(@encodinganalog,'583$a')]">
                        <marc:datafield tag="583" ind1=" " ind2=" ">
                            <xsl:call-template name="subfield">
                                <xsl:with-param name="encodinganalog" select="@encodinganalog"/>
                                <xsl:with-param name="text">
                                    <xsl:for-each select="ead:p">
                                        <xsl:value-of select="text()"/>
                                        <xsl:if test="not(position()=last())">
                                            <xsl:text> </xsl:text>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:with-param>
                            </xsl:call-template>
                        </marc:datafield>
                    </xsl:for-each>

                    <xsl:for-each select="//node()[starts-with(@encodinganalog,'650$a')]">
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
                            <xsl:with-param name="value"
                                            select="normalize-space(lower-case(@normal))"/>
                        </xsl:call-template>
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
                                <xsl:value-of select="concat('http://hdl.handle.net/', $identifier, '?locatt=view:level3')"/>
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

</xsl:stylesheet>
