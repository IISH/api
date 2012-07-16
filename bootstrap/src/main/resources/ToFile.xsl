<!--
  ~ OAI4Solr exposes your Solr indexes using an OAI2 protocol handler.
  ~
  ~     Copyright (C) 2012  International Institute of Social History
  ~
  ~     This program is free software: you can redistribute it and/or modify
  ~     it under the terms of the GNU General Public License as published by
  ~     the Free Software Foundation, either version 3 of the License, or
  ~     (at your option) any later version.
  ~
  ~     This program is distributed in the hope that it will be useful,
  ~     but WITHOUT ANY WARRANTY; without even the implied warranty of
  ~     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  ~     GNU General Public License for more details.
  ~
  ~     You should have received a copy of the GNU General Public License
  ~     along with this program.  If not, see <http://www.gnu.org/licenses/>.
  -->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mets="http://www.loc.gov/METS/">

    <xsl:template match="mets:mets">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()" mode="c"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@*|node()" mode="c">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()" mode="c"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@*|node()">
        <xsl:apply-templates select="@*|node()"/>
    </xsl:template>

</xsl:stylesheet>