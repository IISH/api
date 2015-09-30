<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet
        version="2.0"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:template name="removeLastDot">
        <xsl:param name="tmp"/>
        <xsl:variable name="text" select="normalize-space($tmp)"/>
        <xsl:if test="string-length($text)!=0">
            <xsl:variable name="last" select="substring($text, string-length($text), 1)"/>
            <xsl:choose>
                <xsl:when test="$last='.'">
                    <xsl:value-of select="substring($text, 1, string-length($text)-1)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$text"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <xsl:template name="addLastDot">
        <xsl:param name="tmp"/>
        <xsl:variable name="text" select="normalize-space($tmp)"/>
        <xsl:if test="string-length($text)!=0">
            <xsl:value-of select="$text"/>
            <xsl:variable name="last" select="substring($text, string-length($text), 1)"/>
            <xsl:if test="contains('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', $last)">
                <xsl:text>.</xsl:text>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template name="addLastComma">
        <xsl:param name="tmp"/>
        <xsl:variable name="text" select="normalize-space($tmp)"/>
        <xsl:if test="string-length($text)!=0">
            <xsl:value-of select="$text"/>
            <xsl:variable name="last" select="substring($text, string-length($text), 1)"/>
            <xsl:if test="contains('()abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', $last)">
                <xsl:text>,</xsl:text>
            </xsl:if>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>