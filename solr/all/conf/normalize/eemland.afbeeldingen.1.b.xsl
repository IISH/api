<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:marc="http://www.loc.gov/MARC21/slim"
                xmlns:iisg="http://www.iisg.nl/api/sru/"
                exclude-result-prefixes="marc iisg">

    <xsl:import href="../../../xslt/insertElement.xsl"/>
    <xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
    <xsl:strip-space elements="*"/>
    <xsl:param name="marc_controlfield_005"/>
    <xsl:param name="marc_controlfield_008"/>
    <xsl:param name="date_modified"/>
    <xsl:param name="collectionName"/>

    <xsl:template match="row">

        <xsl:variable name="identifier" select="concat('eemland:afbeeldingen:1:', uuid)"/>
        <xsl:variable name="isShownBy"
                      select="concat('http://images.memorix.nl/gam/thumb/150x150/', file-uuid, '.jpg')"/>
        <xsl:variable name="isShownAt"
                      select="concat('http://www.archiefeemland.nl/collectie/fotos/detail?id=', uuid)"/>

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
                        <xsl:value-of select="$isShownAt"/>
                    </iisg:isShownAt>
                    <iisg:isShownBy>
                        <xsl:value-of select="$isShownBy"/>
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

                    <xsl:apply-templates/>

                    <xsl:call-template name="insertElement">
                        <xsl:with-param name="tag" select="'655'"/>
                        <xsl:with-param name="code" select="'a'"/>
                        <xsl:with-param name="value" select="'foto'"/>
                    </xsl:call-template>

                    <xsl:call-template name="insertElement">
                        <xsl:with-param name="tag" select="'852'"/>
                        <xsl:with-param name="code" select="'b'"/>
                        <xsl:with-param name="value" select="'Archief Eemland'"/>
                    </xsl:call-template>

                </marc:record>
            </recordData>
        </record>
    </xsl:template>

    <xsl:template match="file-uuid">
        <xsl:call-template name="marc_elements">
            <xsl:with-param name="tag" select="'852'"/>
            <xsl:with-param name="code" select="'p'"/>
            <xsl:with-param name="values" select="."/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="fotonummer">
        <xsl:call-template name="marc_elements">
            <xsl:with-param name="tag" select="'852'"/>
            <xsl:with-param name="code" select="'h'"/>
            <xsl:with-param name="values" select="."/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="beschrijving">
        <xsl:call-template name="marc_elements">
            <xsl:with-param name="tag" select="'500'"/>
            <xsl:with-param name="code" select="'a'"/>
            <xsl:with-param name="values" select="."/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="vervaardiger">
        <xsl:call-template name="marc_elements">
            <xsl:with-param name="tag" select="'100'"/>
            <xsl:with-param name="code" select="'a'"/>
            <xsl:with-param name="values" select="."/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="datering_van">
        <xsl:call-template name="marc_elements">
            <xsl:with-param name="tag" select="'260'"/>
            <xsl:with-param name="code" select="'c'"/>
            <xsl:with-param name="values" select="."/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="datering_tot">
        <xsl:call-template name="marc_elements">
            <xsl:with-param name="tag" select="'260'"/>
            <xsl:with-param name="code" select="'g'"/>
            <xsl:with-param name="values" select="."/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="bijzonderheden">
        <xsl:call-template name="marc_elements">
            <xsl:with-param name="tag" select="'520'"/>
            <xsl:with-param name="code" select="'a'"/>
            <xsl:with-param name="values" select="."/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="copyright">
        <xsl:call-template name="marc_elements">
            <xsl:with-param name="tag" select="'540'"/>
            <xsl:with-param name="code" select="'b'"/>
            <xsl:with-param name="values" select="."/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="trefwoord">
        <xsl:call-template name="marc_elements">
            <xsl:with-param name="tag" select="'650'"/>
            <xsl:with-param name="code" select="'a'"/>
            <xsl:with-param name="values" select="."/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="plaatsnaam">
        <xsl:call-template name="marc_elements">
            <xsl:with-param name="tag" select="'605'"/>
            <xsl:with-param name="code" select="'g'"/>
            <xsl:with-param name="values" select="."/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="node()"/>

</xsl:stylesheet>