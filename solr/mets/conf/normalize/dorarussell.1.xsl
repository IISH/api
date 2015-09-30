<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet
        version="2.0"
        xmlns:saxon="http://saxon.sf.net/"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:xlink="http://www.w3.org/1999/xlink"
        xmlns:mets="http://www.loc.gov/METS/"
        xmlns:iisg="http://www.iisg.nl/api/sru/"
        xmlns:ead="urn:isbn:1-931666-22-9"
        exclude-result-prefixes="ead iisg saxon">

    <xsl:import href="../../../xslt/insertElement.xsl"/>
    <xsl:strip-space elements="*"/>
    <xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>
    <xsl:strip-space elements="*"/>
    <xsl:param name="marc_controlfield_005"/>
    <xsl:param name="marc_controlfield_008"/>
    <xsl:param name="date_modified"/>
    <xsl:param name="Inventarisnummer_container"/>
    <xsl:param name="ead_file"/>
    <xsl:param name="concordance"/>
    <xsl:variable name="ead_document" select="document($ead_file)"/>
    <xsl:variable name="concordance_document" select="document($concordance)"/>
    <xsl:variable name="url" select="'http://webstore.iisg.nl/dorarussel/Jpeg/'"/>

    <xsl:template match="dataroot">
        <xsl:call-template name="record">
            <xsl:with-param name="inventarisnummer"
                            select="$concordance_document/dataroot/c[in=$Inventarisnummer_container]"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="record">
        <xsl:param name="inventarisnummer"/>
        <xsl:variable name="identifier"
                      select="concat(substring(normalize-space( $ead_document/Iisg/eadheader/eadid/@identifier ), 6), '_EAD', ':', $Inventarisnummer_container)"/>

        <record>
            <extraRecordData>
                <iisg:iisg>
                    <xsl:call-template name="insertIISHIdentifiers">
                        <xsl:with-param name="identifier" select="$identifier"/>
                    </xsl:call-template>
                    <iisg:collectionName>dorarussell</iisg:collectionName>
                    <iisg:collectionName>dorarussell.1</iisg:collectionName>
                    <iisg:isShownAt>
                        <xsl:value-of
                                select="concat('http://search.iisg.nl/search/search?action=transform&amp;col=archives&amp;xsl=archives-detail.xsl&amp;lang=en&amp;docid=', $identifier)"/>
                    </iisg:isShownAt>
                    <iisg:date_modified>
                        <xsl:value-of select="$date_modified"/>
                    </iisg:date_modified>
                </iisg:iisg>
            </extraRecordData>
            <recordData>
                <mets:mets
                        xmlns:mets="http://www.loc.gov/METS/"
                        xmlns:ead="urn:isbn:1-931666-22-9"
                        xmlns:xlink="http://www.w3.org/1999/xlink"
                        TYPE="text"
                        PROFILE="http://www.loc.gov/standards/mets/profiles/00000003.xml">
                    <xsl:attribute name="OBJID" select="$identifier"/>

                    <xsl:attribute name="LABEL">
                        <xsl:call-template name="ead_context_of_mets"/>
                    </xsl:attribute>

                    <mets:metsHdr>
                        <xsl:attribute name="CREATEDATE" select="$date_modified"/>
                        <xsl:attribute name="LASTMODDATE" select="$date_modified"/>
                        <mets:agent ROLE="ARCHIVIST" TYPE="INDIVIDUAL">
                            <mets:name>Jack Hofman</mets:name>
                        </mets:agent>
                        <mets:agent ROLE="CREATOR" TYPE="INDIVIDUAL">
                            <mets:name>Luciën van Wouw</mets:name>
                        </mets:agent>
                        <mets:agent ROLE="PRESERVATION" TYPE="ORGANIZATION">
                            <mets:name>International Institute for Social History</mets:name>
                        </mets:agent>
                    </mets:metsHdr>
                    <mets:dmdSec ID="DMD1">
                        <mets:mdWrap MDTYPE="EAD">
                            <xsl:attribute name="LABEL"
                                           select="concat($ead_document/Iisg/archdesc/did/unittitle, ', ', $ead_document/Iisg/archdesc/did/unitdate)"/>
                            <mets:xmlData>
                                <ead>
                                    <xsl:apply-templates select="$ead_document/Iisg/*" mode="all"/>
                                </ead>
                            </mets:xmlData>
                        </mets:mdWrap>
                    </mets:dmdSec>

                    <mets:fileSec>
                        <mets:fileGrp USE="archive image">
                            <xsl:for-each select="$inventarisnummer">
                                <xsl:sort data-type="number" select="volgnummer"/>
                                <xsl:variable name="href">
                                    <xsl:choose>
                                        <xsl:when test="tg">
                                            <xsl:value-of select="concat($url,tg/text(), '_thumbnail.png')"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="concat($url,f/text(),'/',m/text())"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>

                                <xsl:call-template name="file">
                                    <xsl:with-param name="ID" select="concat('A', position())"/>
                                    <xsl:with-param name="GROUPID" select="position()"/>
                                    <xsl:with-param name="MIMETYPE" select="'image/tiff'"/>
                                    <xsl:with-param name="SEQ" select="position()"/>
                                    <xsl:with-param name="HREF" select="$href"/>
                                </xsl:call-template>
                            </xsl:for-each>
                        </mets:fileGrp>
                        <mets:fileGrp USE="reference">
                            <xsl:for-each select="$inventarisnummer">
                                <xsl:sort data-type="number" select="volgnummer"/>
                                <xsl:variable name="href">
                                    <xsl:choose>
                                        <xsl:when test="tg">
                                            <xsl:value-of select="concat($url,tg/text(), '_thumbnail.png')"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="concat($url,f/text(),'/',a/text())"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>
                                <xsl:call-template name="file">
                                    <xsl:with-param name="ID" select="concat('B', position())"/>
                                    <xsl:with-param name="GROUPID" select="position()"/>
                                    <xsl:with-param name="MIMETYPE" select="'image/jpeg'"/>
                                    <xsl:with-param name="SEQ" select="position()"/>
                                    <xsl:with-param name="HREF" select="$href"/>
                                </xsl:call-template>
                            </xsl:for-each>
                        </mets:fileGrp>
                        <mets:fileGrp USE="thumbnail">
                            <xsl:for-each select="$inventarisnummer">
                                <xsl:sort data-type="number" select="volgnummer"/>
                                <xsl:variable name="href">
                                    <xsl:choose>
                                        <xsl:when test="tg">
                                            <xsl:value-of select="concat($url,tg/text(), '_thumbnail.png')"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="concat($url,f/text(),'/',tn/text())"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:variable>

                                <xsl:call-template name="file">
                                    <xsl:with-param name="ID" select="concat('C', position())"/>
                                    <xsl:with-param name="GROUPID" select="position()"/>
                                    <xsl:with-param name="MIMETYPE" select="'image/jpeg'"/>
                                    <xsl:with-param name="SEQ" select="position()"/>
                                    <xsl:with-param name="HREF" select="$href"/>
                                </xsl:call-template>
                            </xsl:for-each>
                        </mets:fileGrp>
                    </mets:fileSec>

                    <mets:structMap TYPE="physical">
                        <mets:div ORDER="1" TYPE="text" DMDID="DMD1">
                            <xsl:attribute name="LABEL">
                                <xsl:call-template name="ead_context_of_mets"/>
                            </xsl:attribute>
                            <xsl:for-each select="$inventarisnummer">
                                <xsl:sort data-type="number" select="volgnummer"/>
                                <mets:div ORDER="{position()}" TYPE="page">
                                    <xsl:attribute name="LABEL" select="concat('page ', position())"/>
                                    <mets:fptr>
                                        <xsl:attribute name="FILEID" select="concat('A', position())"/>
                                    </mets:fptr>
                                    <mets:fptr>
                                        <xsl:attribute name="FILEID" select="concat('B', position())"/>
                                    </mets:fptr>
                                    <mets:fptr>
                                        <xsl:attribute name="FILEID" select="concat('C', position())"/>
                                    </mets:fptr>
                                </mets:div>
                            </xsl:for-each>
                        </mets:div>
                    </mets:structMap>

                </mets:mets>
            </recordData>
        </record>

    </xsl:template>

    <xsl:template name="ead_context_of_mets">
        <xsl:value-of
                select="concat('From archive ', $ead_document/Iisg/archdesc/did/unittitle, ', ', $ead_document/Iisg/archdesc/did/unitdate, ': ')"/>
        <xsl:variable name="context">
            <xsl:apply-templates select="$ead_document/Iisg/archdesc/dsc" mode="all"/>
        </xsl:variable>
        <xsl:for-each select="$context//did">
            <xsl:value-of select="concat(head/text(),../@level, ': ')"/>
            <xsl:value-of select="unittitle//text()"/>
            <xsl:text>,</xsl:text>
        </xsl:for-each>
        <xsl:value-of select="concat('container: ', $Inventarisnummer_container)"/>
    </xsl:template>


    <xsl:template name="file">
        <xsl:param name="ID"/>
        <xsl:param name="MIMETYPE"/>
        <xsl:param name="GROUPID"/>
        <xsl:param name="SEQ"/>
        <xsl:param name="HREF"/>

        <mets:file>
            <xsl:attribute name="ID" select="$ID"/>
            <xsl:attribute name="MIMETYPE" select="$MIMETYPE"/>
            <xsl:attribute name="SEQ" select="$SEQ"/>
            <xsl:attribute name="GROUPID" select="$GROUPID"/>
            <mets:FLocat LOCTYPE="URL" xlink:type="simple">
                <xsl:attribute name="xlink:href" select="$HREF"/>
            </mets:FLocat>
        </mets:file>

    </xsl:template>

    <xsl:template match="@*|node()" mode="all">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()" mode="all"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="dsc|ead:dsc" mode="all">
        <xsl:if test="node()//container[.=$Inventarisnummer_container]">
            <xsl:copy>
                <xsl:if test="head">
                    <head>
                        <xsl:value-of select="head/text()"/>
                    </head>
                </xsl:if>
                <xsl:apply-templates select="@*|node()" mode="did"/>
            </xsl:copy>
        </xsl:if>
    </xsl:template>

    <xsl:template match="node()|@*" mode="did">
        <xsl:if test="node()//container[.=$Inventarisnummer_container]"><!-- Altijd een c[n] element-->
            <xsl:element name="{local-name(.)}">
                <xsl:copy-of select="@*"/>
                <xsl:apply-templates select="did" mode="unittitle"/>
                <xsl:apply-templates select="@*|node()" mode="did"/>
            </xsl:element>
        </xsl:if>
    </xsl:template>

    <!-- Simplify the EAD unittitle -->
    <xsl:template match="did" mode="unittitle">
        <did>
            <xsl:for-each select="node()">
                <xsl:choose>
                    <xsl:when test="local-name(.)='unittitle'">
                        <unittitle>
                            <xsl:for-each select="node()">
                                <xsl:value-of select="normalize-space(.)"/>
                                <xsl:if test="not(position()=last())">
                                    <xsl:text> </xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </unittitle>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy-of select="node()/.."/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </did>
    </xsl:template>

    <xsl:template match="acqinfo" mode="all"/>
    <xsl:template match="profiledesc" mode="all"/>
    <xsl:template match="revisiondesc" mode="all"/>
    <xsl:template match="descgrp" mode="all"/>
    <xsl:template match="bioghist" mode="all"/>
    <xsl:template match="scopecontent" mode="all"/>
    <xsl:template match="controlaccess" mode="all"/>
    <xsl:template match="odd" mode="all"/>

</xsl:stylesheet>