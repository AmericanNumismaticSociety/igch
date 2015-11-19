<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xhtml="http://www.w3.org/1999/xhtml"
	 exclude-result-prefixes="#all" version="2.0">
	<xsl:include href="../../templates.xsl"/>
	<xsl:variable name="id" select="substring-after(/content/xhtml:div/@about, 'id/')"/>

	<xsl:variable name="display_path">../</xsl:variable>

	<xsl:template match="/">
		<html lang="en" prefix="geo: http://www.w3.org/2003/01/geo/wgs84_pos# foaf: http://xmlns.com/foaf/0.1/ org: http://www.w3.org/ns/org# nmo: http://nomisma.org/ontology# dcterms:
			http://purl.org/dc/terms/ nm: http://nomisma.org/id/ xsd: http://www.w3.org/2001/XMLSchema# rdf: http://www.w3.org/1999/02/22-rdf-syntax-ns# osgeo:
			http://data.ordnancesurvey.co.uk/ontology/geometry/ rdfs: http://www.w3.org/2000/01/rdf-schema# un: http://www.owl-ontologies.com/Ontology1181490123.owl# skos:
			http://www.w3.org/2004/02/skos/core# dcmitype: http://purl.org/dc/dcmitype/">
			<head>
				<title id="{$id}">Inventory of Greek Coin Hoards: <xsl:value-of select="$id"/></title>
				<meta name="viewport" content="width=device-width, initial-scale=1"/>
				<script type="text/javascript" src="http://code.jquery.com/jquery-latest.min.js"/>
				<!-- bootstrap -->
				<link rel="stylesheet" href="http://netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css"/>
				<script src="http://netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"/>

				<script type="text/javascript" src="http://openlayers.org/api/2.12/OpenLayers.js"/>
				<script type="text/javascript" src="http://maps.google.com/maps/api/js?v=3.9&amp;sensor=false"/>
				<script type="text/javascript" src="{$display_path}ui/javascript/display_map_functions.js"/>
				<link rel="stylesheet" href="{$display_path}ui/css/style.css"/>
			</head>
			<body>
				<xsl:call-template name="header"/>
				<xsl:call-template name="body"/>
				<xsl:call-template name="footer"/>
			</body>
		</html>
	</xsl:template>

	<xsl:template name="body">
		<div class="container-fluid content" vocab="http://nomisma.org/id/">
			<div class="row">
				<div class="col-md-6">
					<xsl:apply-templates select="/content/xhtml:div"/>
				</div>
				<div class="col-md-6">
					<h2>Data Export</h2>
					<ul class="list-inline">
						<li>
							<a href="{$id}.rdf">RDF/XML</a>
						</li>
						<li>
							<a href="{$id}.kml">KML</a>
						</li>
					</ul>
					<div id="mapcontainer"/>
				</div>
			</div>
		</div>
	</xsl:template>
	
	<xsl:template match="xhtml:div">
		<div typeof="{@typeof}" about="{@about}">
			<xsl:copy-of select="xhtml:h1"/>
			<xsl:apply-templates select="xhtml:span[@rel='nmo:hasFindspot']"/>
			<xsl:apply-templates select="*[@property='nmo:hasClosingDate']"/>
			<xsl:copy-of select="xhtml:div[@property='dcterms:tableOfContents']"/>
		</div>
	</xsl:template>
	
	<xsl:template match="xhtml:span[@rel='nmo:hasFindspot']">
		<div rel="nmo:hasFindspot">
			<b>Findspot: </b>
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	
	<xsl:template match="xhtml:span[@property='geo:lat']|xhtml:span[@property='geo:long']">
		<span property="{@property}" datatype="xsd:decimal">
			<xsl:value-of select="."/>
			<i> (<xsl:value-of select="@property"/>)</i>
		</span>
	</xsl:template>
	
	<xsl:template match="*[@property='nmo:hasClosingDate']">
		<div property="nmo:hasClosingDate">			
			<xsl:choose>
				<xsl:when test="child::*">
					<div typeof="dcmitype:Collection">
						<b>Closing date: </b>
						<xsl:copy-of select="descendant::xhtml:span[@property='nmo:hasStartDate']"/>
						<xsl:text> - </xsl:text>
						<xsl:copy-of select="descendant::xhtml:span[@property='nmo:hasEndDate']"/>
					</div>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="datatype" select="@datatype"/>
					<xsl:attribute name="content" select="@content"/>
					<b>Closing date: </b>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>
	
</xsl:stylesheet>
