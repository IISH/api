<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ead="urn:isbn:1-931666-22-9" xmlns:marc="http://www.loc.gov/MARC21/slim" exclude-result-prefixes="ead marc">

    <xsl:template match="node() | @*">
        <xsl:apply-templates select="node()|@*" />
    </xsl:template>

    <xsl:template match="ead:ead">
        <ead:ead xmlns:ead="urn:isbn:1-931666-22-9" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="https://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="urn:isbn:1-931666-22-9 https://www.loc.gov/ead/ead.xsd http://www.w3.org/1999/xlink https://www.w3.org/1999/xlink.xsd">
            <xsl:apply-templates mode="ead"/>
        </ead:ead>
    </xsl:template>

    <xsl:template match="marc:record">
        <marc:record xmlns:marc="http://www.loc.gov/MARC21/slim"
                     xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                     xsi:schemaLocation="http://www.loc.gov/MARC21/slim https://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd">
            <xsl:apply-templates mode="marc"/>
        </marc:record>
    </xsl:template>

    <xsl:template match="node() | @*" mode="ead">
        <xsl:choose>
            <xsl:when test="string-length(local-name())=0">
                <xsl:copy>
                    <xsl:apply-templates select="node()|@*" mode="ead" />
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="ead:{local-name()}">
                    <xsl:copy-of select="@*"/>
                    <xsl:apply-templates mode="ead" />
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="node() | @*" mode="marc">
        <xsl:choose>
            <xsl:when test="string-length(local-name())=0">
                <xsl:copy>
                    <xsl:apply-templates select="node()|@*" mode="marc" />
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="marc:{local-name()}">
                    <xsl:copy-of select="@*"/>
                    <xsl:apply-templates mode="marc" />
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="ead:datestamp|marc:datestamp|datestamp"/>

</xsl:stylesheet>