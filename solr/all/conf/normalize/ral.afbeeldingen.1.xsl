<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:iisg="http://www.iisg.nl/api/sru/"
                exclude-result-prefixes="marc iisg">

    <xsl:import href="../../../xslt/insertElement.xsl"/>
    <xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
    <xsl:variable name="url_lijst" select="document('ral.afbeeldingen.urls.1.xml')"/>
    <xsl:strip-space elements="*"/>
    <xsl:param name="marc_controlfield_005"/>
    <xsl:param name="marc_controlfield_008"/>
    <xsl:param name="date_modified"/><xsl:param name="collectionName"/>

    <xsl:template match="row">
        <xsl:variable name="identifier" select="concat('ral:afbeeldingen:1:', @id)"/>
        <xsl:variable name="Fotonummer" select="column[@label='Fotonummer']"/>
        <!--<xsl:variable name="isShownAt" select="concat('http://www.leidenarchief.nl/index.php?option=com_memorix&amp;Itemid=26&amp;task=topview&amp;CollectionID=1&amp;RecordID=', @id, '&amp;PhotoID=', $Fotonummer)"/>-->
        <xsl:variable name="isShownAt" select="concat('http://www.leidenarchief.nl/lei:col1:dat', @id, ':id127')"/>
        <xsl:variable name="afbeelding" select="concat($Fotonummer, '.jpg')"/>
        <xsl:variable name="isShownBy" select="$url_lijst/urls/url[contains(., $afbeelding)]"/>

        <record>
            <extraRecordData>
                <iisg:iisg>
                    <xsl:call-template name="insertIISHIdentifiers">
                        <xsl:with-param name="identifier" select="$identifier"/>
                    </xsl:call-template>
                    <xsl:call-template name="insertCollection">
                        <xsl:with-param name="collection" select="$collectionName"/>
                    </xsl:call-template><iisg:isShownAt>
                        <xsl:value-of select="$isShownAt"/>
                    </iisg:isShownAt>
                    <xsl:if test="$isShownBy">
                        <iisg:isShownBy>
                            <xsl:value-of select="$isShownBy"/>
                        </iisg:isShownBy>
                    </xsl:if>
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
                    <marc:controlfield tag="005">
                        <xsl:value-of select="column[@label='Fotonummer']/text()"/>
                    </marc:controlfield>

                    <xsl:apply-templates/>

                    <xsl:call-template name="insertElement">
                        <xsl:with-param name="tag" select="'655'"/>
                        <xsl:with-param name="code" select="'a'"/>
                        <xsl:with-param name="value" select="'Foto'"/>
                    </xsl:call-template>

                    <xsl:call-template name="insertElement">
                        <xsl:with-param name="tag" select="'852'"/>
                        <xsl:with-param name="code" select="'b'"/>
                        <xsl:with-param name="value" select="'Regionaal Archief Leiden'"/>
                    </xsl:call-template>

                    <xsl:call-template name="insertElement">
                        <xsl:with-param name="tag" select="'856'"/>
                        <xsl:with-param name="code" select="'u'"/>
                        <xsl:with-param name="value" select="$isShownBy"/>
                    </xsl:call-template>

                </marc:record>
            </recordData>
        </record>
    </xsl:template>

    <xsl:template match="column[@label='Fotonummer']">
        <xsl:call-template name="marc_elements">
            <xsl:with-param name="tag" select="'852'"/>
            <xsl:with-param name="code" select="'p'"/>
            <xsl:with-param name="values" select="."/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="column[@label='Signatuur']">
        <xsl:call-template name="marc_elements">
            <xsl:with-param name="tag" select="'852'"/>
            <xsl:with-param name="code" select="'h'"/>
            <xsl:with-param name="values" select="."/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="column[@label='Titel']">
        <xsl:call-template name="marc_elements">
            <xsl:with-param name="tag" select="'245'"/>
            <xsl:with-param name="code" select="'a'"/>
            <xsl:with-param name="values" select="."/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="column[@label='Maker']">
        <xsl:call-template name="marc_elements">
            <xsl:with-param name="tag" select="'100'"/>
            <xsl:with-param name="code" select="'a'"/>
            <xsl:with-param name="values" select="."/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="column[@label='Personen']">
        <xsl:call-template name="marc_elements">
            <xsl:with-param name="tag" select="'600'"/>
            <xsl:with-param name="code" select="'a'"/>
            <xsl:with-param name="values" select="."/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="column[@label='Plaatsnaam']">
        <xsl:call-template name="marc_elements">
            <xsl:with-param name="tag" select="'605'"/>
            <xsl:with-param name="code" select="'g'"/>
            <xsl:with-param name="values" select="."/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="column[@label='Trefwoord']">
        <xsl:call-template name="marc_elements">
            <xsl:with-param name="tag" select="'650'"/>
            <xsl:with-param name="code" select="'a'"/>
            <xsl:with-param name="values" select="."/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="column[@label='Beschrijving']">
        <xsl:call-template name="marc_elements">
            <xsl:with-param name="tag" select="'500'"/>
            <xsl:with-param name="code" select="'a'"/>
            <xsl:with-param name="values" select="."/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="column[@label='Datum vervaardiging']">
        <xsl:call-template name="marc_elements">
            <xsl:with-param name="tag" select="'260'"/>
            <xsl:with-param name="code" select="'c'"/>
            <xsl:with-param name="values" select="."/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="column[@label='Copyright']">
        <xsl:call-template name="marc_elements">
            <xsl:with-param name="tag" select="'540'"/>
            <xsl:with-param name="code" select="'b'"/>
            <xsl:with-param name="values" select="."/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="node()"/>

</xsl:stylesheet>                    