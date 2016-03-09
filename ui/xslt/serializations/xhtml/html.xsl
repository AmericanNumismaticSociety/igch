<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xhtml="http://www.w3.org/1999/xhtml"
	xmlns:res="http://www.w3.org/2005/sparql-results#" exclude-result-prefixes="#all" version="2.0">
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
		<div class="container-fluid content" vocab="http://nomisma.org/id/" id="top">
			<div class="row">
				<div class="col-md-6">
					<xsl:if test="/content/res:sparql[1][descendant::res:result]">
						<div>
							<ul class="list-inline">
								<li>
									<strong>Jump to section: </strong>
								</li>
								<xsl:if test="/content/res:sparql[1][descendant::res:result]">
									<li>
										<a href="#associated-content">Annotations</a>
									</li>
								</xsl:if>
							</ul>
						</div>
					</xsl:if>

					<xsl:apply-templates select="/content/xhtml:div"/>

					<!-- apply templates to SPARQL results, when applicable -->

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
			<xsl:if test="/content/res:sparql[descendant::res:result]">
				<div class="row" id="associated-content">
					<div class="col-md-12">
						<div>
							<h2>Associated Content</h2>
							<xsl:apply-templates select="/content/res:sparql[1][descendant::res:result]" mode="annotations"/>
							<xsl:apply-templates select="/content/res:sparql[2][descendant::res:result]" mode="coins"/>
							<hr/>
						</div>
					</div>
				</div>
			</xsl:if>
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

	<!-- **************** OPEN ANNOTATIONS (E.G., LINKS FROM A TEI FILE **************** -->
	<xsl:template match="res:sparql" mode="annotations">
		<xsl:variable name="sources" select="distinct-values(descendant::res:result/res:binding[@name='source']/res:uri)"/>
		<xsl:variable name="results" as="element()*">
			<xsl:copy-of select="res:results"/>
		</xsl:variable>

		<div>
			<h3>Annotations <small><a href="#top" title="Return to top"><span class="glyphicon glyphicon-arrow-up"/></a></small></h3>
			<xsl:for-each select="$sources">
				<xsl:variable name="uri" select="."/>


				<div class="row">
					<div class="col-md-12">
						<h4>
							<xsl:value-of select="position()"/>
							<xsl:text>. </xsl:text>
							<a href="{$uri}">
								<xsl:value-of select="$results/res:result[res:binding[@name='source']/res:uri = $uri][1]/res:binding[@name='bookTitle']/res:literal"/>
							</a>
						</h4>
					</div>
					<div class="col-md-{if ($results/res:result[res:binding[@name='source']/res:uri = $uri][1]/res:binding[@name='thumbnail']/res:uri) then '8' else '12'}">						
						<dl class="dl-horizontal">
							<dt>Sections</dt>
							<dd>
								<xsl:apply-templates select="$results/res:result[res:binding[@name='source']/res:uri = $uri]" mode="annotations"/>
							</dd>
							<dt>Creator</dt>
							<dd>
								<xsl:choose>
									<xsl:when test="$results/res:result[res:binding[@name='source']/res:uri = $uri][1]/res:binding[@name='name']/res:literal">
										<a href="{$results/res:result[res:binding[@name='source']/res:uri = $uri][1]/res:binding[@name='creator']/res:uri}">
											<xsl:value-of select="$results/res:result[res:binding[@name='source']/res:uri = $uri][1]/res:binding[@name='name']/res:literal"/>
										</a>
									</xsl:when>
									<xsl:otherwise>
										<a href="{$results/res:result[res:binding[@name='source']/res:uri = $uri][1]/res:binding[@name='creator']/res:uri}">
											<xsl:value-of select="$results/res:result[res:binding[@name='source']/res:uri = $uri][1]/res:binding[@name='creator']/res:uri"/>
										</a>
									</xsl:otherwise>
								</xsl:choose>
							</dd>
							<xsl:if test="$results/res:result[res:binding[@name='source']/res:uri = $uri][1]/res:binding[@name='abstract']/res:literal">
								<dt>Abstract</dt>
								<dd>
									<xsl:value-of select="$results/res:result[res:binding[@name='source']/res:uri = $uri][1]/res:binding[@name='abstract']/res:literal"/>
								</dd>
							</xsl:if>
						</dl>
					</div>					
					<xsl:if test="$results/res:result[res:binding[@name='source']/res:uri = $uri][1]/res:binding[@name='thumbnail']/res:uri">
						<div class="col-md-4 text-right">
							<a href="{$uri}">
								<img src="{$results/res:result[res:binding[@name='source']/res:uri = $uri][1]/res:binding[@name='thumbnail']/res:uri}" alt="thumbnail"/>
							</a>
						</div>
					</xsl:if>
				</div>
			</xsl:for-each>
		</div>
	</xsl:template>

	<xsl:template match="res:result" mode="annotations">
		<a href="{res:binding[@name='target']/res:uri}">
			<xsl:value-of select="res:binding[@name='title']/res:literal"/>
		</a>
		<xsl:if test="not(position()=last())">
			<xsl:text>, </xsl:text>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
