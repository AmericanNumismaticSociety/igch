<?xml version="1.0" encoding="UTF-8"?>
<!--
	XPL handling SPARQL queries from Fuseki	
-->
<p:config xmlns:p="http://www.orbeon.com/oxf/pipeline" xmlns:oxf="http://www.orbeon.com/oxf/processors">

	<p:param type="input" name="data"/>
	<p:param type="output" name="data"/>

	<p:processor name="oxf:request">
		<p:input name="config">
			<config>
				<include>/request</include>
			</config>
		</p:input>
		<p:output name="data" id="request"/>
	</p:processor>

	<!-- generator config for URL generator -->
	<p:processor name="oxf:unsafe-xslt">
		<p:input name="request" href="#request"/>
		<p:input name="data" href="../../../config.xml"/>
		<p:input name="config">
			<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
				<xsl:param name="uri" select="concat('http://coinhoards.org/id/', tokenize(doc('input:request')/request/request-url, '/')[last()])"/>								

				<!-- config variables -->
				<xsl:variable name="sparql_endpoint" select="/config/nomisma_sparql"/>
				
				<xsl:variable name="query"><![CDATA[PREFIX rdf:	<http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX nm:	<http://nomisma.org/id/>
PREFIX nmo:	<http://nomisma.org/ontology#>
PREFIX skos:	<http://www.w3.org/2004/02/skos/core#>
PREFIX dcterms:	<http://purl.org/dc/terms/>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>

SELECT DISTINCT ?type ?label ?source ?sourceLabel ?startDate ?endDate ?mint ?mintLabel ?den ?denLabel WHERE {
?object dcterms:isPartOf <URI> ;
         nmo:hasTypeSeriesItem ?type .
?type a nmo:TypeSeriesItem ;
           skos:prefLabel ?label FILTER(langMatches(lang(?label), "en")) .
   MINUS {?type dcterms:isReplacedBy ?replaced}
   ?type dcterms:source ?source . 
   	?source skos:prefLabel ?sourceLabel FILTER(langMatches(lang(?sourceLabel), "en"))
   OPTIONAL {?type nmo:hasStartDate ?startDate}
   OPTIONAL {?type nmo:hasEndDate ?endDate}
   OPTIONAL {?type nmo:hasMint ?mint . 
   	?mint skos:prefLabel ?mintLabel FILTER(langMatches(lang(?mintLabel), "en"))}
   OPTIONAL {?type nmo:hasDenomination ?den . 
   	?den skos:prefLabel ?denLabel FILTER(langMatches(lang(?denLabel), "en"))}
} LIMIT 20]]></xsl:variable>

				<xsl:variable name="service">
					<xsl:value-of select="concat($sparql_endpoint, '?query=', encode-for-uri(replace($query, 'URI', $uri)), '&amp;output=xml')"/>					
				</xsl:variable>

				<xsl:template match="/">
					<config>
						<url>
							<xsl:value-of select="$service"/>
						</url>
						<content-type>application/xml</content-type>
						<encoding>utf-8</encoding>
					</config>
				</xsl:template>
			</xsl:stylesheet>
		</p:input>
		<p:output name="data" id="url-generator-config"/>
	</p:processor>

	<!-- get the data from fuseki -->
	<p:processor name="oxf:url-generator">
		<p:input name="config" href="#url-generator-config"/>
		<p:output name="data" ref="data"/>
	</p:processor>
</p:config>
