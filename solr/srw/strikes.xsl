<?xml version="1.0" encoding="UTF-8"?>
<!--
Copyright 2010 International Institute for Social History, The Netherlands.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="2.0"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:strikes="http://api.socialhistoryservices.org/strikes/1/"
                xmlns:iisg="http://www.iisg.nl/api/sru/"
                xmlns:zr="http://explain.z3950.org/dtd/2.0/"
                xmlns:srw="http://www.loc.gov/zing/srw/"
                exclude-result-prefixes="strikes iisg zr saxon srw"
        >
    
    <xsl:import href="listitem.xsl"/>
    <xsl:strip-space elements="*"/>
    <xsl:variable name="maximumRecords" select="/srw:searchRetrieveResponse/srw:echoedSearchRetrieveRequest/srw:maximumRecords"/>
    <xsl:param name="lang"/>
    <xsl:variable name="langUsage" select="response/lst[@name='solrparams']/str[@name='lang']"/>

    <xsl:template match="response">

        <!-- Initialize the Solr document variables -->
        <xsl:variable name="record" select="saxon:parse(//doc/str[@name='resource']/text())/node()"/>
        <xsl:variable name="transport" select="str[@name='transport']/text()"/>
        <xsl:variable name="header" select="$record/extraRecordData"/>
        <xsl:variable name="metadata" select="$record/recordData"/>

        <!-- This is how the record inside the recordData will look like. -->
         <record>
            <recordData>
                <xsl:choose>
                    <xsl:when test="$transport='JSON'">
                        <xsl:apply-templates select="$metadata/strikes:strikes"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy-of select="$metadata/strikes:strikes"/>
                    </xsl:otherwise>
                </xsl:choose>
            </recordData>
            <xsl:choose>
                <xsl:when test="$transport='JSON'">
                    <extraRecordData>
                        <langUsage><xsl:value-of select="$langUsage"/></langUsage>
                        <Identifier><xsl:value-of select="$header/*/iisg:identifier"/></Identifier>
                    </extraRecordData>
                </xsl:when>
                <xsl:otherwise>
                    <extraRecordData>
                    <xsl:copy-of select="$header/*/*"/>
                    <langUsage><xsl:value-of select="$langUsage"/></langUsage>
                </extraRecordData>
                <Identifier><xsl:value-of select="$header/*/iisg:identifier"/></Identifier>
                </xsl:otherwise>
            </xsl:choose>
        </record>
    </xsl:template>

    <xsl:template match="strikes:strikes">

        <dl>
            <xsl:apply-templates select="strikes:Bedrijven"/>
            <xsl:apply-templates select="strikes:Redenen"/>
            <xsl:apply-templates select="strikes:Sector"/>
            <xsl:apply-templates select="strikes:Datum"/>
            <xsl:apply-templates select="strikes:Plaatsen"/>
            <xsl:apply-templates select="strikes:Beroepen"/>
            <xsl:apply-templates select="strikes:Actie_soort"/>
            <xsl:apply-templates select="strikes:Type"/>
            <xsl:apply-templates select="strikes:Karakter"/>
            <xsl:apply-templates select="strikes:Uitkomst"/>
            <xsl:apply-templates select="strikes:Duur"/>
            <xsl:apply-templates select="strikes:Uitleg"/>
            <xsl:apply-templates select="strikes:Vrouwen | strikes:Jongeren | strikes:Buitenlanders | strikes:Los_dienstverband"/>
            <xsl:apply-templates select="strikes:Aantallen"/>
            <xsl:apply-templates select="strikes:Bronnen"/>
        </dl>
    </xsl:template>

    <xsl:template match="strikes:Bedrijven">
        <xsl:call-template name="listitem">
            <xsl:with-param name="index">bedrijf</xsl:with-param>
            <xsl:with-param name="value">
                <xsl:for-each select="strikes:Bedrijf_record">
                    <dd><xsl:value-of select="strikes:Naam"/>
                        <xsl:if test="strikes:Naam and strikes:Plaats">
                            <xsl:text>, </xsl:text>
                        </xsl:if>
                        <xsl:value-of select="strikes:Plaats"/>
                        <xsl:if test="strikes:Provincie">
                            <xsl:value-of select="concat(' (', strikes:Provincie, ')')"/>
                        </xsl:if></dd>
                </xsl:for-each>
            </xsl:with-param>
            <xsl:with-param name="explain" select="document('explain.strikes.en.xml')"/>
            <xsl:with-param name="lang" select="$lang"/>
            <xsl:with-param name="recordSchema" select="'info:srw/schema/1/strikes'"/>
            <xsl:with-param name="maximumRecords" select="$maximumRecords"/>
            <xsl:with-param name="relation" select="'exact'"/>
            <xsl:with-param name="query" select="true()"/>
            <xsl:with-param name="shortlist" select="'yes'"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="strikes:Redenen">
        <xsl:call-template name="listitem">
            <xsl:with-param name="index">reden</xsl:with-param>
            <xsl:with-param name="value">
                <xsl:for-each select="strikes:Reden_record">
                    <dd><xsl:apply-templates select="strikes:eisen/strikes:lang[@code=$lang]"/></dd>
                </xsl:for-each>
            </xsl:with-param>
            <xsl:with-param name="explain" select="document('explain.strikes.en.xml')"/>
            <xsl:with-param name="lang" select="$lang"/>
            <xsl:with-param name="recordSchema" select="'info:srw/schema/1/strikes'"/>
            <xsl:with-param name="maximumRecords" select="$maximumRecords"/>
            <xsl:with-param name="relation" select="'exact'"/>
            <xsl:with-param name="query" select="true()"/>
            <xsl:with-param name="shortlist" select="'yes'"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="strikes:Sector">
        <xsl:call-template name="listitem">
            <xsl:with-param name="index">sector</xsl:with-param>
            <xsl:with-param name="value">
                <xsl:apply-templates select="strikes:lang[@code=$lang]"/>
            </xsl:with-param><xsl:with-param name="explain" select="document('explain.strikes.en.xml')"/>
            <xsl:with-param name="lang" select="$lang"/>
            <xsl:with-param name="recordSchema" select="'info:srw/schema/1/strikes'"/>
            <xsl:with-param name="maximumRecords" select="$maximumRecords"/>
            <xsl:with-param name="relation" select="'exact'"/>
            <xsl:with-param name="query" select="true()"/>
            <xsl:with-param name="shortlist" select="'yes'"/>
        </xsl:call-template></xsl:template>
    <xsl:template match="strikes:Datum">
        <xsl:call-template name="listitem">
            <xsl:with-param name="index">datum</xsl:with-param>
            <xsl:with-param name="value">
                <xsl:variable name="iso-date"
                              select="concat(substring(., 1, 4), '-', substring(., 5, 2), '-', substring(., 7, 2))"/>
                <xsl:variable name="formatted-date">
                    <xsl:call-template name="format-date">
                        <xsl:with-param name="date" select="$iso-date"/>
                        <xsl:with-param name="l" select="$lang"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="$formatted-date"/>
            </xsl:with-param>
            <xsl:with-param name="explain" select="document('explain.strikes.en.xml')"/>
            <xsl:with-param name="lang" select="$lang"/>
            <xsl:with-param name="recordSchema" select="'info:srw/schema/1/strikes'"/>
            <xsl:with-param name="maximumRecords" select="$maximumRecords"/>
            <xsl:with-param name="relation" select="'exact'"/>
            <xsl:with-param name="query" select="true()"/>
            <xsl:with-param name="shortlist"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="strikes:Plaatsen">
        <xsl:call-template name="listitem">
            <xsl:with-param name="index">Plaats</xsl:with-param>
            <xsl:with-param name="value">
                    <xsl:for-each select="strikes:Plaats_record"><dd>
                        <xsl:value-of select="strikes:Plaats/text()"/>
                <xsl:if test="strikes:Provincie">
                    <xsl:value-of select="concat(' (', strikes:Provincie, ')')"/>
                </xsl:if></dd>
            </xsl:for-each>
            </xsl:with-param>
            <xsl:with-param name="explain" select="document('explain.strikes.en.xml')"/>
            <xsl:with-param name="lang" select="$lang"/>
            <xsl:with-param name="recordSchema" select="'info:srw/schema/1/strikes'"/>
            <xsl:with-param name="maximumRecords" select="$maximumRecords"/>
            <xsl:with-param name="relation" select="'exact'"/>
            <xsl:with-param name="query" select="true()"/>
            <xsl:with-param name="shortlist" select="'yes'"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="strikes:Beroepen">
        <xsl:call-template name="listitem">
            <xsl:with-param name="index">beroep</xsl:with-param>
            <xsl:with-param name="value">
                <xsl:for-each select="strikes:Beroep_record"><dd>
                <xsl:apply-templates select="strikes:Beroep/strikes:lang[@code=$lang]"/></dd></xsl:for-each>
            </xsl:with-param>
            <xsl:with-param name="explain" select="document('explain.strikes.en.xml')"/>
            <xsl:with-param name="lang" select="$lang"/>
            <xsl:with-param name="recordSchema" select="'info:srw/schema/1/strikes'"/>
            <xsl:with-param name="maximumRecords" select="$maximumRecords"/>
            <xsl:with-param name="relation" select="'exact'"/>
            <xsl:with-param name="query" select="true()"/>
            <xsl:with-param name="shortlist"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="strikes:Actie_soort"> <!-- staking, uitsluiting, andere. -->
        <xsl:call-template name="listitem">
            <xsl:with-param name="index">actiesoort</xsl:with-param>
            <xsl:with-param name="value"><xsl:apply-templates select="strikes:lang[@code=$lang]"/></xsl:with-param>
            <xsl:with-param name="explain" select="document('explain.strikes.en.xml')"/>
            <xsl:with-param name="lang" select="$lang"/>
            <xsl:with-param name="recordSchema" select="'info:srw/schema/1/strikes'"/>
            <xsl:with-param name="maximumRecords" select="$maximumRecords"/>
            <xsl:with-param name="relation" select="'exact'"/>
            <xsl:with-param name="query" select="true()"/>
            <xsl:with-param name="shortlist"/>
        </xsl:call-template>

    </xsl:template>
    <xsl:template match="strikes:Type">
        <xsl:call-template name="listitem">
            <xsl:with-param name="index">type</xsl:with-param>
            <xsl:with-param name="value">
                <xsl:apply-templates select="strikes:lang[@code=$lang]"/>
            </xsl:with-param>
            <xsl:with-param name="explain" select="document('explain.strikes.en.xml')"/>
            <xsl:with-param name="lang" select="$lang"/>
            <xsl:with-param name="recordSchema" select="'info:srw/schema/1/strikes'"/>
            <xsl:with-param name="maximumRecords" select="$maximumRecords"/>
            <xsl:with-param name="relation" select="'exact'"/>
            <xsl:with-param name="query" select="true()"/>
            <xsl:with-param name="shortlist"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="strikes:Karakter">
        <xsl:call-template name="listitem">
            <xsl:with-param name="index">karakter</xsl:with-param>
            <xsl:with-param name="value">
                <xsl:apply-templates select="strikes:lang[@code=$lang]"/>
            </xsl:with-param>
            <xsl:with-param name="explain" select="document('explain.strikes.en.xml')"/>
            <xsl:with-param name="lang" select="$lang"/>
            <xsl:with-param name="recordSchema" select="'info:srw/schema/1/strikes'"/>
            <xsl:with-param name="maximumRecords" select="$maximumRecords"/>
            <xsl:with-param name="relation" select="'exact'"/>
            <xsl:with-param name="query" select="true()"/>
            <xsl:with-param name="shortlist"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="strikes:Uitkomst">
        <xsl:call-template name="listitem">
            <xsl:with-param name="index">result</xsl:with-param>
            <xsl:with-param name="value">
                <xsl:apply-templates select="strikes:lang[@code=$lang]"/>
            </xsl:with-param>
            <xsl:with-param name="explain" select="document('explain.strikes.en.xml')"/>
            <xsl:with-param name="lang" select="$lang"/>
            <xsl:with-param name="recordSchema" select="'info:srw/schema/1/strikes'"/>
            <xsl:with-param name="maximumRecords" select="$maximumRecords"/>
            <xsl:with-param name="relation" select="'exact'"/>
            <xsl:with-param name="query" select="true()"/>
            <xsl:with-param name="shortlist"/>
        </xsl:call-template>

    </xsl:template>
    <xsl:template match="strikes:Vrouwen">
        <xsl:call-template name="listitem">
            <xsl:with-param name="index">groep</xsl:with-param>
            <xsl:with-param name="value">
                <xsl:choose>
                    <xsl:when test="$lang='en'">Women</xsl:when>
                    <xsl:otherwise>Vrouwen</xsl:otherwise>
                </xsl:choose>
            </xsl:with-param>
            <xsl:with-param name="explain" select="document('explain.strikes.en.xml')"/>
            <xsl:with-param name="lang" select="$lang"/>
            <xsl:with-param name="recordSchema" select="'info:srw/schema/1/strikes'"/>
            <xsl:with-param name="maximumRecords" select="$maximumRecords"/>
            <xsl:with-param name="relation" select="'exact'"/>
            <xsl:with-param name="query" select="true()"/>
            <xsl:with-param name="shortlist"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="strikes:Jongeren">
        <xsl:call-template name="listitem">
            <xsl:with-param name="index">groep</xsl:with-param>
            <xsl:with-param name="value">
                <xsl:choose>
                    <xsl:when test="$lang='en'">Youth</xsl:when>
                    <xsl:otherwise>Jongeren</xsl:otherwise>
                </xsl:choose>
            </xsl:with-param>
            <xsl:with-param name="explain" select="document('explain.strikes.en.xml')"/>
            <xsl:with-param name="lang" select="$lang"/>
            <xsl:with-param name="recordSchema" select="'info:srw/schema/1/strikes'"/>
            <xsl:with-param name="maximumRecords" select="$maximumRecords"/>
            <xsl:with-param name="relation" select="'exact'"/>
            <xsl:with-param name="query" select="true()"/>
            <xsl:with-param name="shortlist"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="strikes:Buitenlanders">
        <xsl:call-template name="listitem">
            <xsl:with-param name="index">groep</xsl:with-param>
            <xsl:with-param name="value">
                <xsl:choose>
                    <xsl:when test="$lang='en'">Foreign</xsl:when>
                    <xsl:otherwise>Buitenlanders</xsl:otherwise>
                </xsl:choose>
            </xsl:with-param>
            <xsl:with-param name="explain" select="document('explain.strikes.en.xml')"/>
            <xsl:with-param name="lang" select="$lang"/>
            <xsl:with-param name="recordSchema" select="'info:srw/schema/1/strikes'"/>
            <xsl:with-param name="maximumRecords" select="$maximumRecords"/>
            <xsl:with-param name="relation" select="'exact'"/>
            <xsl:with-param name="query" select="true()"/>
            <xsl:with-param name="shortlist"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="strikes:Los_dienstverband">
        <xsl:call-template name="listitem">
            <xsl:with-param name="index">groep</xsl:with-param>
            <xsl:with-param name="value">
                <xsl:choose>
                    <xsl:when test="$lang='en'">Seasonal labour</xsl:when>
                    <xsl:otherwise>Los dienstverband</xsl:otherwise>
                </xsl:choose>
            </xsl:with-param>
            <xsl:with-param name="explain" select="document('explain.strikes.en.xml')"/>
            <xsl:with-param name="lang" select="$lang"/>
            <xsl:with-param name="recordSchema" select="'info:srw/schema/1/strikes'"/>
            <xsl:with-param name="maximumRecords" select="$maximumRecords"/>
            <xsl:with-param name="relation" select="'exact'"/>
            <xsl:with-param name="query" select="true()"/>
            <xsl:with-param name="shortlist"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="strikes:Duur">
        <xsl:call-template name="listitem">
            <xsl:with-param name="index">duur</xsl:with-param>
            <xsl:with-param name="value">
                <xsl:apply-templates/>
            </xsl:with-param>
            <xsl:with-param name="explain" select="document('explain.strikes.en.xml')"/>
            <xsl:with-param name="lang" select="$lang"/>
            <xsl:with-param name="recordSchema" select="'info:srw/schema/1/strikes'"/>
            <xsl:with-param name="maximumRecords" select="$maximumRecords"/>
            <xsl:with-param name="relation" select="'exact'"/>
            <xsl:with-param name="query" select="true()"/>
            <xsl:with-param name="shortlist"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="strikes:Uitleg">
        <xsl:call-template name="listitem">
            <xsl:with-param name="index">uitleg</xsl:with-param>
            <xsl:with-param name="value">
                <xsl:apply-templates/>
            </xsl:with-param>
            <xsl:with-param name="explain" select="document('explain.strikes.en.xml')"/>
            <xsl:with-param name="lang" select="$lang"/>
            <xsl:with-param name="recordSchema" select="'info:srw/schema/1/strikes'"/>
            <xsl:with-param name="maximumRecords" select="$maximumRecords"/>
            <xsl:with-param name="relation" select="'exact'"/>
            <xsl:with-param name="query" select="true()"/>
            <xsl:with-param name="shortlist"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="strikes:Bronnen">
        <xsl:call-template name="listitem">
            <xsl:with-param name="index">bron</xsl:with-param>
            <xsl:with-param name="value"><xsl:for-each select="strikes:Bron_record"><dd>
                <xsl:apply-templates select="strikes:Schrijver"/> <xsl:if test="strikes:Afkorting">(<xsl:apply-templates select="strikes:Afkorting"/>) </xsl:if><xsl:apply-templates select="strikes:Titel"/></dd></xsl:for-each>
            </xsl:with-param>
            <xsl:with-param name="explain" select="document('explain.strikes.en.xml')"/>
            <xsl:with-param name="lang" select="$lang"/>
            <xsl:with-param name="recordSchema" select="'info:srw/schema/1/strikes'"/>
            <xsl:with-param name="maximumRecords" select="$maximumRecords"/>
            <xsl:with-param name="relation" select="'exact'"/>
            <xsl:with-param name="query" select="true()"/>
            <xsl:with-param name="shortlist"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="strikes:Aantallen">
        <xsl:for-each select="Aantallen_record">
            <xsl:call-template name="listitem">
            <xsl:with-param name="index"><xsl:value-of select="strikes:Aantaltype/strikes:lang[@code=$lang]"/></xsl:with-param>
            <xsl:with-param name="value">
                <xsl:value-of select="concat(strikes:Aantalomschrijving, '=', strikes:Aantal)"/>
            </xsl:with-param>
            <xsl:with-param name="explain" select="document('explain.strikes.en.xml')"/>
            <xsl:with-param name="lang" select="$lang"/>
            <xsl:with-param name="recordSchema" select="'info:srw/schema/1/strikes'"/>
            <xsl:with-param name="maximumRecords" select="$maximumRecords"/>
            <xsl:with-param name="relation" select="'exact'"/>
            <xsl:with-param name="query" select="true()"/>
            <xsl:with-param name="shortlist"/>
        </xsl:call-template>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="strikes:lang">
        <xsl:value-of select="text()"/>
    </xsl:template>

    <xsl:template name="format-date">
        <xsl:param name="date"/>
        <xsl:param name="l">en</xsl:param>
        <xsl:variable name="month-day" select="substring-after($date, '-')"/>
        <xsl:variable name="month" select="substring-before($month-day, '-')"/>
        <xsl:variable name="day" select="format-number(number(substring-after($month-day, '-')), '#')"/>
        <xsl:variable name="year" select="substring-before($date, '-')"/>
        <xsl:variable name="translated-month">
            <xsl:choose>
                <xsl:when test="l = 'nl'">
                    <xsl:choose>
                        <xsl:when test="$month = '01'">januari</xsl:when>
                        <xsl:when test="$month = '02'">februari</xsl:when>
                        <xsl:when test="$month = '03'">maart</xsl:when>
                        <xsl:when test="$month = '04'">april</xsl:when>
                        <xsl:when test="$month = '05'">mei</xsl:when>
                        <xsl:when test="$month = '06'">juni</xsl:when>
                        <xsl:when test="$month = '07'">juli</xsl:when>
                        <xsl:when test="$month = '08'">augustus</xsl:when>
                        <xsl:when test="$month = '09'">september</xsl:when>
                        <xsl:when test="$month = '10'">oktober</xsl:when>
                        <xsl:when test="$month = '11'">november</xsl:when>
                        <xsl:when test="$month = '12'">december</xsl:when>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="$month = '01'">January</xsl:when>
                        <xsl:when test="$month = '02'">February</xsl:when>
                        <xsl:when test="$month = '03'">March</xsl:when>
                        <xsl:when test="$month = '04'">April</xsl:when>
                        <xsl:when test="$month = '05'">May</xsl:when>
                        <xsl:when test="$month = '06'">June</xsl:when>
                        <xsl:when test="$month = '07'">July</xsl:when>
                        <xsl:when test="$month = '08'">August</xsl:when>
                        <xsl:when test="$month = '09'">September</xsl:when>
                        <xsl:when test="$month = '10'">October</xsl:when>
                        <xsl:when test="$month = '11'">November</xsl:when>
                        <xsl:when test="$month = '12'">December</xsl:when>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!-- hier wordt de datum notatie in de juiste volgorde samengesteld mbv de variabelen  dag month jaar-->
        <xsl:value-of select="concat($day, ' ')"/>
        <xsl:value-of select="concat($translated-month, ' ')"/>
        <xsl:value-of select="$year"/>
    </xsl:template>

</xsl:stylesheet>