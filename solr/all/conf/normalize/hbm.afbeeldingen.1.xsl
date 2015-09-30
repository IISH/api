<?xml version="1.0" encoding="UTF-8" ?>

<!--

Voorbeeld

<item>
	<code_user>DAAN</code_user>
	<codefoto>213</codefoto>
	<plaats>Amsterdam</plaats>
	<collectienaam>Kenswil</collectienaam>
	<done>0</done>
	<datum>1963, ca.</datum>
	<vrij>ja</vrij>
	<beschrijving>Rudolphine Kenswil (rechts) en Nelly Dankerlui tijdens een uitstapje naar de Stadsschouwburg. Zij gingen naar een uitvoering van de opera La Bohème.</beschrijving>
	<Bevolkingsgroepen>Surinamers</Bevolkingsgroepen>
	<fld_source>daan</fld_source>
	<codecollectie>7</codecollectie>
	<materiaalsoort>foto</materiaalsoort>
	<volgnummer>HBM_DeBeun_18</volgnummer>
	<Trefwoorden>opera, recreatie</Trefwoorden>
</item>
-->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:iisg="http://www.iisg.nl/api/sru/"
                exclude-result-prefixes="marc iisg">

    <xsl:import href="../../../xslt/insertElement.xsl"/>
    <xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
    <xsl:strip-space elements="*"/>

    <xsl:variable name="iisg_thesaurus" select="document('hbm.afbeeldingen.thesaurus.xml')"/>

    <xsl:variable name="lcletters">abcdefghijklmnopqrstuvwxyz</xsl:variable>
    <xsl:variable name="ucletters">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>

    <xsl:param name="marc_controlfield_005"/>
    <xsl:param name="marc_controlfield_008"/>
    <xsl:param name="date_modified"/>
    <xsl:param name="collectionName"/>

    <xsl:template match="item">
        <xsl:apply-templates select="final"/>
    </xsl:template>

    <xsl:template match="final">
        <xsl:variable name="identifier" select="translate(volgnummer, $ucletters, $lcletters)"/>

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
                        <xsl:value-of
                                select="concat('http://search.iisg.nl/search/search?action=transform&amp;col=marc_images&amp;xsl=marc_images-detail.xsl&amp;lang=en&amp;docid=', $identifier, '_MARC')"/>
                    </iisg:isShownAt>
                    <iisg:isShownBy>
                        <xsl:value-of
                                select="concat('http://search.iisg.nl/search/search?action=get&amp;id=', $identifier, '&amp;col=images&amp;fieldname=resource')"/>
                    </iisg:isShownBy>
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
                    <marc:controlfield tag="001">
                        <xsl:value-of select="$identifier"/>
                    </marc:controlfield>
                    <marc:controlfield tag="003">HBM</marc:controlfield>
                    <marc:controlfield tag="005">
                        <xsl:value-of select="$marc_controlfield_005"/>
                    </marc:controlfield>
                    <marc:controlfield tag="008">
                        <xsl:value-of select="$marc_controlfield_008"/>
                    </marc:controlfield>

                    <marc:datafield tag="40" ind1="" ind2="">
                        <marc:subfield code="a">Ne</marc:subfield>
                        <marc:subfield code="d">AmISG</marc:subfield>
                    </marc:datafield>

                    <xsl:variable name="fotograaf" select="fotograaf"/>
                    <xsl:if test="$fotograaf">
                        <marc:datafield tag="100" ind1="0" ind2="">
                            <marc:subfield code="a">
                                <xsl:value-of select="$fotograaf"/>
                            </marc:subfield>
                            <marc:subfield code="c">fotograaf</marc:subfield>
                        </marc:datafield>
                    </xsl:if>

                    <xsl:variable name="fotobureau_studio" select="fotobureau_studio"/>
                    <xsl:if test="$fotobureau_studio">
                        <marc:datafield tag="100" ind1="0" ind2="">
                            <marc:subfield code="a">
                                <xsl:value-of select="$fotobureau_studio"/>
                            </marc:subfield>
                        </marc:datafield>
                    </xsl:if>

                    <marc:datafield tag="245" ind1="1" ind2="0">
                        <marc:subfield code="k">Beelddocument = Visual document</marc:subfield>
                    </marc:datafield>

                    <xsl:if test="datum">
                        <marc:datafield tag="260" ind1="" ind2="">
                            <marc:subfield code="c">
                                <xsl:value-of select="datum"/>
                            </marc:subfield>
                        </marc:datafield>
                    </xsl:if>


                    <xsl:if test="afmetingen">
                        <marc:datafield tag="300" ind1="" ind2="">
                            <marc:subfield code="p">
                                <xsl:value-of select="afmetingen"/>
                            </marc:subfield>
                        </marc:datafield>
                    </xsl:if>

                    <xsl:if test="beschrijving">
                        <marc:datafield tag="500" ind1="" ind2="">
                            <marc:subfield code="a">
                                <xsl:value-of select="beschrijving"/>
                            </marc:subfield>
                        </marc:datafield>
                    </xsl:if>

                    <xsl:if test="Bevolkingsgroepen">
                        <xsl:call-template name="ot">
                            <xsl:with-param name="tag">500</xsl:with-param>
                            <xsl:with-param name="ind1"></xsl:with-param>
                            <xsl:with-param name="ind2"></xsl:with-param>
                            <xsl:with-param name="codes">a</xsl:with-param>
                            <xsl:with-param name="list">
                                <xsl:value-of select="Bevolkingsgroepen"/>
                            </xsl:with-param>
                            <xsl:with-param name="delimiter">,</xsl:with-param>
                        </xsl:call-template>
                    </xsl:if>

                    <xsl:if test="Trefwoorden">
                        <xsl:call-template name="ot">
                            <xsl:with-param name="tag">500</xsl:with-param>
                            <xsl:with-param name="ind1"></xsl:with-param>
                            <xsl:with-param name="ind2"></xsl:with-param>
                            <xsl:with-param name="codes">a</xsl:with-param>
                            <xsl:with-param name="list">
                                <xsl:value-of select="Trefwoorden"/>
                            </xsl:with-param>
                            <xsl:with-param name="delimiter">,</xsl:with-param>
                        </xsl:call-template>
                    </xsl:if>

                    <marc:datafield tag="540" ind1="" ind2="">
                        <marc:subfield code="b">HBM</marc:subfield>
                    </marc:datafield>

                    <xsl:if test="collectienaam">
                        <marc:datafield tag="541" ind1="0" ind2="0">
                            <marc:subfield code="a">
                                <xsl:value-of select="collectienaam"/>
                            </marc:subfield>
                        </marc:datafield>
                    </xsl:if>

                    <xsl:if test="materiaalsoort">
                        <xsl:call-template name="ot">
                            <xsl:with-param name="tag">603</xsl:with-param>
                            <xsl:with-param name="ind1"></xsl:with-param>
                            <xsl:with-param name="ind2">0</xsl:with-param>
                            <xsl:with-param name="codes">ab</xsl:with-param>
                            <xsl:with-param name="list">
                                <xsl:value-of select="materiaalsoort"/>
                            </xsl:with-param>
                            <xsl:with-param name="delimiter">,</xsl:with-param>
                        </xsl:call-template>
                    </xsl:if>

                    <xsl:if test="Trefwoorden">
                        <xsl:call-template name="ot">
                            <xsl:with-param name="tag">603</xsl:with-param>
                            <xsl:with-param name="ind1"></xsl:with-param>
                            <xsl:with-param name="ind2">0</xsl:with-param>
                            <xsl:with-param name="codes">ab</xsl:with-param>
                            <xsl:with-param name="list">
                                <xsl:value-of select="Trefwoorden"/>
                            </xsl:with-param>
                            <xsl:with-param name="delimiter">,</xsl:with-param>
                        </xsl:call-template>
                    </xsl:if>

                    <xsl:if test="datum">

                        <xsl:variable name="year_string">
                            <xsl:choose>
                                <xsl:when test="string-length(datum) = 4">
                                    <xsl:value-of select="datum"/>
                                </xsl:when>
                                <xsl:when test="string-length(datum) &gt; 4">
                                    <xsl:value-of select="substring(datum, 1, 4)"/>
                                </xsl:when>
                                <xsl:otherwise>0</xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>

                        <xsl:variable name="year_number" select="$year_string mod 4"/>

                        <marc:datafield tag="604" ind1="" ind2="0">
                            <!-- tijdperkaanduiding afhankelijk van data in b en c [XX-1, XX-2, XX-3,XX-4] -->
                            <marc:subfield code="a">
                                <xsl:value-of select="concat('XX-', $year_number)"/>
                            </marc:subfield>
                            <!-- $datum [string/jaartal voor de komma] -->
                            <marc:subfield code="b">
                                <xsl:value-of select="$year_string"/>
                            </marc:subfield>
                            <!-- $datum [string/jaartal voor de komma] -->
                            <marc:subfield code="c">
                                <xsl:value-of select="$year_string"/>
                            </marc:subfield>
                        </marc:datafield>
                    </xsl:if>


                    <marc:datafield tag="605" ind1="" ind2="0">
                        <marc:subfield code="a">NED</marc:subfield>
                        <marc:subfield code="g">
                            <xsl:value-of select="plaats"/>
                        </marc:subfield>
                    </marc:datafield>

                    <marc:datafield tag="852" ind1="0" ind2="0">
                        <marc:subfield code="a">IISG</marc:subfield>
                        <marc:subfield code="b">IISG</marc:subfield>
                        <marc:subfield code="b">IISG</marc:subfield>
                        <marc:subfield code="b">HBM</marc:subfield>
                        <marc:subfield code="h">
                            <xsl:value-of select="plaatsnummerIISG"/>
                        </marc:subfield>
                        <marc:subfield code="p">
                            <xsl:value-of select="$identifier"/>
                        </marc:subfield>
                    </marc:datafield>

                </marc:record>
            </recordData>
        </record>

    </xsl:template>

    <!--
    http://www.abbeyworkshop.com/howto/xslt1/xslt1-split-values/
    -->
    <xsl:template name="ot">
        <xsl:param name="list"/>
        <xsl:param name="delimiter"/>
        <xsl:param name="tag"/>
        <xsl:param name="ind1"/>
        <xsl:param name="ind2"/>
        <xsl:param name="codes"/>

        <xsl:variable name="newlist">
            <xsl:choose>
                <xsl:when test="contains($list, $delimiter)">
                    <xsl:value-of select="normalize-space($list)"/>
                </xsl:when>

                <xsl:otherwise>
                    <xsl:value-of select="concat(normalize-space($list), $delimiter)"/>
                </xsl:otherwise>

            </xsl:choose>

        </xsl:variable>
        <xsl:variable name="first" select="substring-before($newlist, $delimiter)"/>
        <xsl:variable name="remaining" select="substring-after($newlist, $delimiter)"/>

        <!-- Thesaurus terms for some reason start with a capital -->
        <xsl:variable name="term"
                      select="concat( translate(substring($first, 1, 1),$lcletters,$ucletters), substring($first, 2) )"/>
        <xsl:variable name="keywords"
                      select="$iisg_thesaurus/collections/record/datafield[subfield=$term and position()&lt;3]/subfield"/>

        <xsl:if test="$keywords">
            <marc:datafield tag="{$tag}" ind1="{$ind1}" ind2="{$ind2}">
                <xsl:for-each select="$keywords">
                    <xsl:if test="contains($codes, @code)">
                        <marc:subfield code="{@code}">
                            <xsl:value-of select="."/>
                        </marc:subfield>
                    </xsl:if>
                </xsl:for-each>
            </marc:datafield>
        </xsl:if>

        <xsl:if test="$remaining">
            <xsl:call-template name="ot">
                <xsl:with-param name="list" select="$remaining"/>
                <xsl:with-param name="delimiter">
                    <xsl:value-of select="$delimiter"/>
                </xsl:with-param>
                <xsl:with-param name="tag" select="$tag"/>
                <xsl:with-param name="ind1" select="$ind1"/>
                <xsl:with-param name="ind2" select="$ind2"/>
                <xsl:with-param name="codes" select="$codes"/>
            </xsl:call-template>

        </xsl:if>
    </xsl:template>

</xsl:stylesheet>