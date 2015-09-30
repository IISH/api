<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:marc="http://www.loc.gov/MARC21/slim"
		xmlns:iisg="http://www.iisg.nl/api/sru/"
		exclude-result-prefixes="marc iisg">

    <xsl:import href="../../../xslt/insertElement.xsl"/>
	<xsl:output method="xml" indent="no" omit-xml-declaration="yes" />
	<xsl:strip-space elements="*"/>
	<xsl:param name="marc_controlfield_005"/>
	<xsl:param name="marc_controlfield_008"/>
	<xsl:param name="date_modified"/>
    <xsl:param name="collectionName"/>

	<xsl:template match="record">

		<xsl:variable name="identifier" select="concat('eemland:afbeeldingen:1:', header/identifier)"/>
		<xsl:variable name="isShownBy" select="concat('http://images.memorix.nl/gam/thumb/150x150/', about/files/file[1])"/>
		<xsl:variable name="isShownAt" select="concat('http://www.archiefeemland.nl/collectie/fotos/detail?id=', header/identifier)"/>

		<record>
			<extraRecordData>
				<iisg:iisg>
					<xsl:call-template name="insertIISHIdentifiers">
                        <xsl:with-param name="identifier" select="$identifier"/>
                    </xsl:call-template>
					<xsl:call-template name="insertCollection">
                        <xsl:with-param name="collection" select="$collectionName"/>
                    </xsl:call-template>
					<iisg:isShownAt><xsl:value-of select="$isShownAt"/></iisg:isShownAt>
					<iisg:isShownBy><xsl:value-of select="$isShownBy"/></iisg:isShownBy>
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

					<xsl:apply-templates />

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

	<xsl:template match="about">
		<xsl:for-each select="files">
			<xsl:for-each select="file">
				<xsl:call-template name="marc_elements">
					<xsl:with-param name="tag" select="'852'"/>
					<xsl:with-param name="code" select="'p'"/>
					<xsl:with-param name="values" select="."/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="header">
		<xsl:for-each select="identifier">
			<xsl:call-template name="marc_elements">
				<xsl:with-param name="tag" select="'852'"/>
				<xsl:with-param name="code" select="'h'"/>
				<xsl:with-param name="values" select="."/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="metadata">
		<xsl:for-each select="dc">

			<xsl:for-each select="description">
				<xsl:call-template name="marc_elements">
			  		 <xsl:with-param name="tag" select="'500'"/>
					<xsl:with-param name="code" select="'a'"/>
					<xsl:with-param name="values" select="."/>
				</xsl:call-template>
			</xsl:for-each>

			<xsl:for-each select="date">
				<xsl:call-template name="marc_elements">
					<xsl:with-param name="tag" select="'260'"/>
					<xsl:with-param name="code" select="'c'"/>
					<xsl:with-param name="values" select="."/>
				</xsl:call-template>
			</xsl:for-each>

			<xsl:for-each select="coverage">
				<xsl:call-template name="marc_elements">
					<xsl:with-param name="tag" select="'605'"/>
					<xsl:with-param name="code" select="'g'"/>
					<xsl:with-param name="values" select="."/>
				</xsl:call-template>
			</xsl:for-each>

			<xsl:for-each select="creator">
				<xsl:call-template name="marc_elements">
					<xsl:with-param name="tag" select="'100'"/>
					<xsl:with-param name="code" select="'a'"/>
					<xsl:with-param name="values" select="."/>
				</xsl:call-template>
			</xsl:for-each>

			<xsl:for-each select="rights">
				<xsl:call-template name="marc_elements">
					<xsl:with-param name="tag" select="'540'"/>
					<xsl:with-param name="code" select="'b'"/>
					<xsl:with-param name="values" select="."/>
				</xsl:call-template>
			</xsl:for-each>

			<xsl:for-each select="subject">
				<xsl:call-template name="marc_elements">
					<xsl:with-param name="tag" select="'650'"/>
					<xsl:with-param name="code" select="'a'"/>
					<xsl:with-param name="values" select="."/>
				</xsl:call-template>
			</xsl:for-each>

		</xsl:for-each>
	</xsl:template>

	<xsl:template match="node()"/>

</xsl:stylesheet>