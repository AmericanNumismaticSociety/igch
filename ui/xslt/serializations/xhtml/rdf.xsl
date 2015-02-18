<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:nm="http://nomisma.org/id/"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:skos="http://www.w3.org/2004/02/skos/core#"
	xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#" xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:org="http://www.w3.org/ns/org#" xmlns:dcmitype="http://purl.org/dc/dcmitype/"
	xmlns:nmo="http://nomisma.org/ontology#" xmlns:xhtml="http://www.w3.org/1999/xhtml" exclude-result-prefixes="xhtml" version="2.0">
	<!--<xsl:include href="rdf-templates.xsl"/>-->

	<xsl:template match="/">
		<rdf:RDF xmlns:dcterms="http://purl.org/dc/terms/" xmlns:nm="http://nomisma.org/id/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
			xmlns:skos="http://www.w3.org/2004/02/skos/core#" xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#" xmlns:foaf="http://xmlns.com/foaf/0.1/" xmlns:org="http://www.w3.org/ns/org#"
			xmlns:nomisma="http://nomisma.org/" xmlns:nmo="http://nomisma.org/ontology#" xmlns:xsd="http://www.w3.org/2001/XMLSchema#" xmlns:dcmitype="http://purl.org/dc/dcmitype/">
			<xsl:apply-templates select="//xhtml:div[@about]"/>
		</rdf:RDF>
	</xsl:template>

	<xsl:template match="xhtml:div[@about]">
		<nmo:Hoard rdf:about="{@about}">
			<dcterms:title xml:lang="en">
				<xsl:value-of select="xhtml:h1"/>
			</dcterms:title>

			<xsl:apply-templates select="descendant::*[@rel='nmo:hasFindspot']"/>

			<xsl:choose>
				<xsl:when test="*[@property='nmo:hasClosingDate']/@content">
					<nmo:hasClosingDate rdf:datatype="http://www.w3.org/2001/XMLSchema#gYear">
						<xsl:value-of select="*[@property='nmo:hasClosingDate']/@content"/>
					</nmo:hasClosingDate>
				</xsl:when>
				<xsl:when test="*[@property='nmo:hasClosingDate']/xhtml:div">
					<nmo:hasClosingDate>
						<dcterms:PeriodOfTime>
							<nmo:hasStartDate rdf:datatype="http://www.w3.org/2001/XMLSchema#gYear">
								<xsl:value-of select="descendant::*[@property='nmo:hasStartDate']/@content"/>
							</nmo:hasStartDate>
							<nmo:hasStartDate rdf:datatype="http://www.w3.org/2001/XMLSchema#gYear">
								<xsl:value-of select="descendant::*[@property='nmo:hasEndDate']/@content"/>
							</nmo:hasStartDate>
						</dcterms:PeriodOfTime>
					</nmo:hasClosingDate>
				</xsl:when>
			</xsl:choose>

			<xsl:apply-templates select="xhtml:div[@property='dcterms:tableOfContents']"/>

		</nmo:Hoard>
	</xsl:template>

	<xsl:template match="*[@rel='nmo:hasFindspot']">
		<nmo:hasFindspot>
			<geo:SpatialThing>
				<geo:lat rdf:datatype="http://www.w3.org/2001/XMLSchema#decimal">
					<xsl:value-of select="xhtml:span[@property='geo:lat']"/>
				</geo:lat>
				<geo:long rdf:datatype="http://www.w3.org/2001/XMLSchema#decimal">
					<xsl:value-of select="xhtml:span[@property='geo:long']"/>
				</geo:long>
			</geo:SpatialThing>
		</nmo:hasFindspot>
	</xsl:template>

	<xsl:template match="xhtml:div[@property='dcterms:tableOfContents']">
		<dcterms:tableOfContents>
			<dcmitype:Collection>
				<xsl:apply-templates select="descendant::*[@rel='nmo:hasMint']"/>
			</dcmitype:Collection>
		</dcterms:tableOfContents>
	</xsl:template>

	<xsl:template match="*[@rel='nmo:hasMint']">
		<nmo:hasMint rdf:resource="{@href}"/>
	</xsl:template>
</xsl:stylesheet>
