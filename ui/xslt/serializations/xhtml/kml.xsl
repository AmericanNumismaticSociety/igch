<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xhtml="http://www.w3.org/1999/xhtml"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#" exclude-result-prefixes="#all"
	xmlns:nmo="http://nomisma.org/ontology#" xmlns="http://earth.google.com/kml/2.0" version="2.0">

	<xsl:variable name="id" select="/content/xhtml:div/@about"/>
	<xsl:variable name="uri">
		<xsl:text>http://nomisma.org/id/</xsl:text>
		<xsl:value-of select="$id"/>
	</xsl:variable>

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
		<kml xmlns="http://earth.google.com/kml/2.0">
			<Document>
				<Style id="mint">
					<IconStyle>
						<scale>1</scale>
						<hotSpot x="0.5" y="0" xunits="fraction" yunits="fraction"/>
						<Icon>
							<href>http://maps.google.com/intl/en_us/mapfiles/ms/micons/blue-dot.png</href>
						</Icon>
					</IconStyle>
				</Style>
				<Style id="findspot">
					<IconStyle>
						<scale>1</scale>
						<hotSpot x="0.5" y="0" xunits="fraction" yunits="fraction"/>
						<Icon>
							<href>http://maps.google.com/intl/en_us/mapfiles/ms/micons/red-dot.png</href>
						</Icon>
					</IconStyle>
				</Style>
				<Style id="polygon">
					<PolyStyle>
						<color>50F00014</color>
						<outline>1</outline>
					</PolyStyle>
				</Style>

				<xsl:apply-templates select="descendant::xhtml:*[@rel='nmo:hasFindspot']">
					<xsl:with-param name="label" select="*[@property='dcterms:title']"/>
				</xsl:apply-templates>

				<!-- apply templates to mints -->
				<xsl:apply-templates select="$rdf/geo:SpatialThing"/>



			</Document>
		</kml>
	</xsl:template>

	<xsl:template match="xhtml:*[@rel='nmo:hasFindspot']">
		<xsl:param name="label"/>

		<Placemark>
			<name>
				<xsl:value-of select="$label"/>
			</name>
			<styleUrl>#findspot</styleUrl>
			<xsl:if test="descendant::*[@property='geo:lat'] and descendant::*[@property='geo:long']">
				<Point>
					<coordinates>
						<xsl:value-of select="concat(descendant::*[@property='geo:long'], ',', descendant::*[@property='geo:lat'])"/>
					</coordinates>
				</Point>
			</xsl:if>
		</Placemark>
	</xsl:template>

	<xsl:template match="geo:SpatialThing">
		<xsl:variable name="uri" select="@rdf:about"/>
		<Placemark>
			<name>
				<xsl:value-of select="$rdf//nmo:Mint[geo:location/@rdf:resource=$uri]/skos:prefLabel[@xml:lang='en']"/>
			</name>
			<styleUrl>#mint</styleUrl>
			<Point>
				<coordinates>
					<xsl:value-of select="concat(geo:long, ',', geo:lat)"/>
				</coordinates>
			</Point>
			<description><![CDATA[<a href="]]><xsl:value-of select="substring-before($uri, '#this')"/><![CDATA[">]]><xsl:value-of select="substring-before($uri, '#this')"/><![CDATA[</a>]]></description>
		</Placemark>
	</xsl:template>
</xsl:stylesheet>
