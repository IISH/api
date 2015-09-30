<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:migranten="http://api.socialhistoryservices.org/migranten/1/"
                xmlns:iisg="http://www.iisg.nl/api/sru/"
                exclude-result-prefixes="migranten iisg">

    <xsl:import href="../../../xslt/insertElement.xsl"/>
    <xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
    <xsl:strip-space elements="*"/>
    <xsl:param name="marc_controlfield_005"/>
    <xsl:param name="marc_controlfield_008"/>
    <xsl:param name="date_modified"/>
    <xsl:param name="collectionName"/>
    <xsl:variable name="prefix" select="'migranten'"/>

    <xsl:template match="item">

        <xsl:variable name="identifier" select="concat($prefix, ':', idOrg, '.', importId, '.', scholar_Id)"/>

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
                                select="concat('http://search.iisg.nl/search/search?action=transform&amp;col=migranten&amp;xsl=migranten-detail.xsl&amp;lang=nl&amp;docid=', $identifier)"/>
                    </iisg:isShownAt>
                    <iisg:date_modified>
                        <xsl:value-of select="$date_modified"/>
                    </iisg:date_modified>
                </iisg:iisg>
            </extraRecordData>
            <recordData>
                <migranten:migranten>
                    <xsl:apply-templates select="final/*" mode="all"/>
                </migranten:migranten>
            </recordData>
        </record>

    </xsl:template>

    <xsl:template match="node()" mode="all">
        <xsl:call-template name="insertCustomElement">
            <xsl:with-param name="localname" select="local-name(.)"/>
            <xsl:with-param name="value" select="text()"/>
            <xsl:with-param name="p" select="$prefix"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="IsOph" mode="all">
        <xsl:variable name="jn">
            <xsl:choose>
                <xsl:when test=".='J'">Ja</xsl:when>
                <xsl:when test=".='N'">Nee</xsl:when>
                <xsl:otherwise>Onbekend</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:call-template name="insertCustomElement">
            <xsl:with-param name="localname" select="'opgeheven'"/>
            <xsl:with-param name="value" select="$jn"/>
            <xsl:with-param name="p" select="$prefix"/>
        </xsl:call-template>

        <xsl:variable name="jn_en">
            <xsl:choose>
                <xsl:when test=".='J'">Yes</xsl:when>
                <xsl:when test=".='N'">No</xsl:when>
                <xsl:otherwise>Unknown</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:call-template name="insertCustomElement">
            <xsl:with-param name="localname" select="'opgeheven_en'"/>
            <xsl:with-param name="value" select="$jn_en"/>
            <xsl:with-param name="p" select="$prefix"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="StJaar" mode="all">
        <xsl:variable name="jaar">
            <xsl:choose>
                <xsl:when test=".='Onbekend'">0</xsl:when>
                <xsl:when test=".='-1'">0</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:call-template name="insertCustomElement">
            <xsl:with-param name="localname" select="'stichtingsjaar'"/>
            <xsl:with-param name="value" select="$jaar"/>
            <xsl:with-param name="p" select="$prefix"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="Doelgroep" mode="all">
        <xsl:variable name="dg">
            <xsl:choose>
                <xsl:when test=".='J'">Jongeren</xsl:when>
                <xsl:when test=".='O'">Ouderen</xsl:when>
                <xsl:when test=".='M'">Mannen</xsl:when>
                <xsl:when test=".='V'">Vrouwen</xsl:when>
                <xsl:otherwise>Niet gespecificeerd</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:call-template name="insertCustomElement">
            <xsl:with-param name="localname" select="local-name(.)"/>
            <xsl:with-param name="value" select="$dg"/>
            <xsl:with-param name="p" select="$prefix"/>
        </xsl:call-template>

        <xsl:variable name="dg_en">
            <xsl:choose>
                <xsl:when test=".='J'">Youth</xsl:when>
                <xsl:when test=".='O'">Elderly</xsl:when>
                <xsl:when test=".='M'">Men</xsl:when>
                <xsl:when test=".='V'">Women</xsl:when>
                <xsl:when test=".='O'">Unknown</xsl:when>
                <xsl:otherwise>Not Specified</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:call-template name="insertCustomElement">
            <xsl:with-param name="localname" select="concat(local-name(.), '_en')"/>
            <xsl:with-param name="value" select="$dg_en"/>
            <xsl:with-param name="p" select="$prefix"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="Soort" mode="all">
        <xsl:variable name="soort">
            <xsl:choose>
                <xsl:when test=".='S'">Stichting</xsl:when>
                <xsl:when test=".='V'">Vereniging</xsl:when>
                <xsl:when test=".='I'">Informeel</xsl:when>
                <xsl:when test=".='O'">Onderneming</xsl:when>
                <xsl:when test=".='R'">Radio, televisie, media</xsl:when>
                <xsl:when test=".='W'">Website</xsl:when>
                <xsl:otherwise>Onbekend</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:call-template name="insertCustomElement">
            <xsl:with-param name="localname" select="local-name(.)"/>
            <xsl:with-param name="value" select="$soort"/>
            <xsl:with-param name="p" select="$prefix"/>
        </xsl:call-template>
        <xsl:variable name="soort_en">
            <xsl:choose>
                <xsl:when test=".='S'">Foundation</xsl:when>
                <xsl:when test=".='V'">Association</xsl:when>
                <xsl:when test=".='I'">Informal</xsl:when>
                <xsl:when test=".='O'">Commercial</xsl:when>
                <xsl:when test=".='R'">Radio, Television, Media</xsl:when>
                <xsl:when test=".='W'">Website</xsl:when>
                <xsl:otherwise>Unknown</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:call-template name="insertCustomElement">
            <xsl:with-param name="localname" select="concat(local-name(.), '_en')"/>
            <xsl:with-param name="value" select="$soort_en"/>
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
