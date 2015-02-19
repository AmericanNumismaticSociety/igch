<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xhtml="http://www.w3.org/1999/xhtml"
	xmlns:nmo="http://nomisma.org/ontology#" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:skos="http://www.w3.org/2004/02/skos/core#"
	xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#" exclude-result-prefixes="#all" version="2.0">

	<xsl:output encoding="UTF-8" indent="yes" method="xml"/>

	<xsl:variable name="rdf" as="element()*">
		<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:nm="http://nomisma.org/id/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
			xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#"
			xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:org="http://www.w3.org/ns/org#" xmlns:nomisma="http://nomisma.org/" xmlns:nmo="http://nomisma.org/ontology#">
			<xsl:variable name="id-param">
				<xsl:for-each select="distinct-values(descendant::xhtml:a[@rel='nmo:hasMint']/@href)">
					<xsl:value-of select="substring-after(., 'id/')"/>
					<xsl:choose>
						<xsl:when test="position() mod 100 = 0">
							<xsl:text>,</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if test="not(position()=last())">
								<xsl:text>|</xsl:text>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</xsl:variable>

			<xsl:for-each select="tokenize($id-param, ',')">
				<xsl:variable name="rdf_url" select="concat('http://nomisma.org/apis/getRdf?identifiers=', encode-for-uri(.))"/>
				<xsl:copy-of select="document($rdf_url)/rdf:RDF/*"/>
			</xsl:for-each>
		</rdf:RDF>
	</xsl:variable>

	<xsl:template match="/">
		<add>
			<xsl:apply-templates select="//xhtml:div[@about]"/>
		</add>
	</xsl:template>

	<xsl:template match="xhtml:div[@about]">
		<xsl:variable name="id" select="substring-after(@about, 'id/')"/>
		<doc>
			<field name="id">
				<xsl:value-of select="$id"/>
			</field>
			<field name="title_display">
				<xsl:value-of select="xhtml:h1"/>
			</field>
			<xsl:if test="descendant::*[@property='nmo:hasClosingDate']">
				<field name="closingDate_display">
					<xsl:choose>
						<xsl:when test="descendant::*[@property='nmo:hasClosingDate']/@content">
							<xsl:value-of select="descendant::*[@property='nmo:hasClosingDate']"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="descendant::*[@property='nmo:hasStartDate']"/>
							<xsl:text> - </xsl:text>
							<xsl:value-of select="descendant::*[@property='nmo:hasEndDate']"/>
						</xsl:otherwise>
					</xsl:choose>
				</field>
			</xsl:if>
			<xsl:for-each select="descendant::xhtml:a[@rel='nmo:hasMint'][@href]">
				<xsl:variable name="uri" select="@href"/>
				<xsl:if test="string($rdf//nmo:Mint[@rdf:about=$uri]/skos:relatedMatch[contains(@rdf:resource, 'pleiades')]/@rdf:resource)">
					<field name="pleiades_uri">
						<xsl:value-of select="$rdf//nmo:Mint[@rdf:about=$uri]/skos:relatedMatch[contains(@rdf:resource, 'pleiades')]/@rdf:resource"/>
					</field>
				</xsl:if>
			</xsl:for-each>
			<field name="timestamp">
				<xsl:variable name="timestamp" select="string(current-dateTime())"/>
				<xsl:choose>
					<xsl:when test="contains($timestamp, 'Z')">
						<xsl:value-of select="$timestamp"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="concat($timestamp, 'Z')"/>
					</xsl:otherwise>
				</xsl:choose>
			</field>
			<field name="text">
				<xsl:variable name="text">
					<xsl:value-of select="$id"/>
					<xsl:text> </xsl:text>
					<xsl:for-each select="descendant-or-self::node()">
						<xsl:value-of select="text()"/>
						<xsl:text> </xsl:text>
						<xsl:if test="string(@resource)">
							<xsl:value-of select="@resource"/>
							<xsl:text> </xsl:text>
						</xsl:if>
					</xsl:for-each>
				</xsl:variable>

				<xsl:value-of select="normalize-space($text)"/>
			</field>
		</doc>
	</xsl:template>
</xsl:stylesheet>
