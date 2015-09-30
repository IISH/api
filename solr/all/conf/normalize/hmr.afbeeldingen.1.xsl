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

    <xsl:template match="record">

        <xsl:variable name="identifier" select="header/identifier"/>
        <xsl:variable name="identifier2" select="concat('hmr:afbeeldingen:1:', header/identifier)"/>
        <xsl:variable name="isShownBy"
                      select="concat('http://collectie.hmr.rotterdam.nl/beeld/_250/', substring-after(header/identifier,'hmr:'), '_1.jpg')"/>
        <xsl:variable name="isShownAt"
                      select="concat('http://collectie.hmr.rotterdam.nl/objecten/', substring-after(header/identifier, 'hmr:'))"/>

        <record>
            <extraRecordData>
                <iisg:iisg>
                    <xsl:call-template name="insertIISHIdentifiers">
                        <xsl:with-param name="identifier">
                            <xsl:call-template name="remove">
                                <xsl:with-param name="value" select="$identifier2"/>
                            </xsl:call-template>
                        </xsl:with-param>
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
                        <xsl:if test="contains($identifier,'oai:hmr:')">
                            <xsl:call-template name="remove">
                                <xsl:with-param name="value"
                                                select="concat('http://collectie.museumrotterdam.nl/objecten/',$identifier)"/>
                            </xsl:call-template>
                        </xsl:if>
                    </marc:controlfield>
                    <xsl:apply-templates/>
                    <xsl:call-template name="insertElement">
                        <xsl:with-param name="tag" select="'856'"/>
                        <xsl:with-param name="code" select="'u'"/>
                        <xsl:with-param name="value" select="$isShownBy"/>
                    </xsl:call-template>
                </marc:record>
            </recordData>
        </record>
    </xsl:template>

    <xsl:template match="metadata">
        <xsl:for-each select="oai_dc_dc">
            <xsl:for-each select="dc_title">
                <xsl:call-template name="marc_elements">
                    <xsl:with-param name="tag" select="'245'"/>
                    <xsl:with-param name="code" select="'a'"/>
                    <xsl:with-param name="values" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="dc_creator">
                <xsl:call-template name="marc_elements">
                    <xsl:with-param name="tag" select="'100'"/>
                    <xsl:with-param name="code" select="'a'"/>
                    <xsl:with-param name="values" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="dc_subject">
                <xsl:call-template name="marc_elements">
                    <xsl:with-param name="tag" select="'650'"/>
                    <xsl:with-param name="code" select="'a'"/>
                    <xsl:with-param name="values" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="dc_description">
                <xsl:call-template name="marc_elements">
                    <xsl:with-param name="tag" select="'500'"/>
                    <xsl:with-param name="code" select="'a'"/>
                    <xsl:with-param name="values" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="dc_date">
                <xsl:call-template name="marc_elements">
                    <xsl:with-param name="tag" select="'245'"/>
                    <xsl:with-param name="code" select="'f'"/>
                    <xsl:with-param name="values" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="dc_publisher">
                <xsl:call-template name="marc_elements">
                    <xsl:with-param name="tag" select="'852'"/>
                    <xsl:with-param name="code" select="'b'"/>
                    <xsl:with-param name="values" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="dc_type">
                <xsl:call-template name="marc_elements">
                    <xsl:with-param name="tag" select="'655'"/>
                    <xsl:with-param name="code" select="'a'"/>
                    <xsl:with-param name="values" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="dc_rights">
                <xsl:call-template name="marc_elements">
                    <xsl:with-param name="tag" select="'540'"/>
                    <xsl:with-param name="code" select="'b'"/>
                    <xsl:with-param name="values" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="image">
                <xsl:call-template name="marc_elements">
                    <xsl:with-param name="tag" select="'852'"/>
                    <xsl:with-param name="code" select="'p'"/>
                    <xsl:with-param name="values" select="."/>
                </xsl:call-template>
            </xsl:for-each>

        </xsl:for-each>
    </xsl:template>


    <xsl:template match="node()"/>

    <xsl:template name="remove">
        <xsl:param name="value"/>
        <xsl:value-of select="concat(substring-before($value, 'oai:hmr:'), substring-after($value, 'oai:hmr:'))"/>
    </xsl:template>

</xsl:stylesheet>
