<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xhtml="http://www.w3.org/1999/xhtml"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#" exclude-result-prefixes="#all"
	xmlns:nmo="http://nomisma.org/ontology#" xmlns="http://earth.google.com/kml/2.0" version="2.0">

	<xsl:variable name="id" select="/content/xhtml:div/@about"/>
	<xsl:variable name="uri" select="$id"/>

	<xsl:variable name="rdf" as="element()*">
		<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:nm="http://nomisma.org/id/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
			xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#" xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:org="http://www.w3.org/ns/org#"
			xmlns:nomisma="http://nomisma.org/" xmlns:nmo="http://nomisma.org/ontology#">
			<xsl:variable name="id-param">
				<xsl:for-each select="distinct-values(descendant::xhtml:a[@rel='nmo:hasMint']/@href)">
					<xsl:value-of select="substring-after(., 'id/')"/>
					<xsl:if test="not(position()=last())">
						<xsl:text>|</xsl:text>
					</xsl:if>
				</xsl:for-each>
			</xsl:variable>

			<xsl:variable name="rdf_url" select="concat('http://nomisma.org/apis/getRdf?identifiers=', encode-for-uri($id-param))"/>
			<xsl:copy-of select="document($rdf_url)/rdf:RDF/*"/>
		</rdf:RDF>
	</xsl:variable>

	<xsl:template match="/">
		<xsl:apply-templates select="/content/xhtml:div"/>
	</xsl:template>

	<xsl:template match="xhtml:div">
		<xsl:text>{ "type": "FeatureCollection","features": [</xsl:text>
		<xsl:apply-templates select="descendant::xhtml:*[@rel='nmo:hasFindspot']">
			<xsl:with-param name="label" select="*[@property='skos:prefLabel']"/>
		</xsl:apply-templates>
		
		<!-- apply templates to mints -->
		<xsl:if test="$rdf//geo:SpatialThing">
			<xsl:text>,</xsl:text>
			<xsl:apply-templates select="$rdf//geo:SpatialThing"/>
		</xsl:if>
		<xsl:text>]}</xsl:text>
	</xsl:template>

	<xsl:template match="xhtml:*[@rel='nmo:hasFindspot']">
		<xsl:param name="label"/>

		<xsl:if test="descendant::*[@property='geo:lat'] and descendant::*[@property='geo:long']">
			<xsl:text>{"type": "Feature","geometry": {"type": "Point","coordinates": [</xsl:text>
			<xsl:value-of select="concat(descendant::*[@property='geo:long'], ',', descendant::*[@property='geo:lat'])"/>
			<xsl:text>]},"properties": {"name": "</xsl:text>
			<xsl:value-of select="$label"/>
			<xsl:text>", "uri": "</xsl:text>
			<xsl:value-of select="$uri"/>
			<xsl:text>","type": "findspot"</xsl:text>	
			<xsl:text>}}</xsl:text>				
		</xsl:if>
	</xsl:template>

	<xsl:template match="geo:SpatialThing">
		<xsl:variable name="uri" select="@rdf:about"/>
		<xsl:variable name="coordinates" select="concat(geo:long, ',', geo:lat)"/>
		
		<xsl:if test="string-length($coordinates) &gt; 0">
			<xsl:text>{"type": "Feature","geometry": {"type": "Point","coordinates": [</xsl:text>
			<xsl:value-of select="$coordinates"/>
			<xsl:text>]},"properties": {"name": "</xsl:text>
			<xsl:value-of select="$rdf//nmo:Mint[geo:location/@rdf:resource=$uri]/skos:prefLabel[@xml:lang='en']"/>
			<xsl:text>", "uri": "</xsl:text>
			<xsl:value-of select="substring-before($uri, '#this')"/>
			<xsl:text>","type": "mint"</xsl:text>	
			<xsl:text>}}</xsl:text>
			<xsl:if test="not(position()=last())">
				<xsl:text>,</xsl:text>
			</xsl:if>	
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
