<xsl:stylesheet
        version="1.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:marc="http://www.loc.gov/MARC21/slim">

    <xsl:output media-type="text" omit-xml-declaration="yes"/>

    <xsl:template match="record">
        <xsl:apply-templates select="recordData"/>
    </xsl:template>

    <xsl:template match="recordData">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="marc:record">

        <xsl:if test="marc:leader">
            marc:<xsl:value-of select="marc:leader/text()"/>" marc:leader "<xsl:value-of select="marc:leader" />" ;
        </xsl:if>

            <xsl:for-each select="marc:controlfield">
                marc:controlfield<xsl:value-of select="@tag"/>,text:"<xsl:call-template name="normalize">
                    <xsl:with-param name="data" select="text()"/>
                </xsl:call-template>"
                }
                <xsl:if test="not(position()=last())">
                    ,
                </xsl:if>
            </xsl:for-each>


        <xsl:if test="marc:datafield">,d:[
            <xsl:for-each select="marc:datafield[marc:subfield]">
                {t:<xsl:value-of select="@tag"/>,s:[
                <xsl:for-each select="marc:subfield">
                    {c:"<xsl:value-of select="@code"/>",text:"<xsl:call-template name="normalize">
                        <xsl:with-param name="data" select="text()"/>
                    </xsl:call-template>"}
                    <xsl:if test="not(position()=last())">,</xsl:if>
                </xsl:for-each>]}
                <xsl:if test="not(position()=last())">,</xsl:if>
            </xsl:for-each>]
        </xsl:if>

        }
    </xsl:template>

    <xsl:template name="normalize">
        <xsl:param name="data"/>

        <xsl:call-template name="doublequote">
            <xsl:with-param name="data">
                <xsl:call-template name="backwardslash">
                    <xsl:with-param name="data" select="$data"/>
                </xsl:call-template>
            </xsl:with-param>
        </xsl:call-template>

    </xsl:template>

    <xsl:template name="backwardslash">
        <xsl:param name="data"/>
        <xsl:if test="string-length($data) >0">
            <xsl:value-of select="substring-before(concat($data, '\'), '\')"/>

            <xsl:if test="contains($data, '\')">
                <xsl:text>\\</xsl:text>

                <xsl:call-template name="backwardslash">
                    <xsl:with-param name="data" select="substring-after($data, '\')"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template name="doublequote">
        <xsl:param name="data"/>
        <xsl:if test="string-length($data) >0">
            <xsl:value-of select="substring-before(concat($data, '&quot;'), '&quot;')"/>

            <xsl:if test="contains($data, '&quot;')">
                <xsl:text>\"</xsl:text>

                <xsl:call-template name="normalize">
                    <xsl:with-param name="data" select="substring-after($data, '&quot;')"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>