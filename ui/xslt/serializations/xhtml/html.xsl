<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:nomisma="http://nomisma.org/"
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

				<link rel="stylesheet" href="http://cdn.leafletjs.com/leaflet/v0.7.7/leaflet.css"/>
				<script src="http://cdn.leafletjs.com/leaflet/v0.7.7/leaflet.js"/>					
				<script type="text/javascript" src="{$display_path}ui/javascript/leaflet.ajax.min.js"/>
				<script type="text/javascript" src="{$display_path}ui/javascript/jquery.fancybox.pack.js"/>
				<script type="text/javascript" src="{$display_path}ui/javascript/display_map_functions.js"/>
				<link rel="stylesheet" href="{$display_path}ui/css/jquery.fancybox.css"/>
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
								<xsl:if test="/content/res:sparql[2][descendant::res:result]">
									<li>
										<a href="#associated-types">Associated Types</a>
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
						<li>
							<a href="{$id}.geoJSON">geoJSON</a>
						</li>
					</ul>
					<div id="mapcontainer"/>
					<div style="margin:10px 0">
						<table>
							<tbody>
								<tr>
									<td style="background-color:#6992fd;border:2px solid black;width:50px;"/>
									<td style="width:100px">Mints</td>
									<td style="background-color:#d86458;border:2px solid black;width:50px;"/>
									<td style="width:100px">Hoard</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
			</div>
			<xsl:if test="/content/res:sparql[descendant::res:result]">
				<div class="row">
					<div class="col-md-12">
						<div>
							<h2>Associated Content</h2>
							<xsl:apply-templates select="/content/res:sparql[1][descendant::res:result]" mode="annotations"/>
							<xsl:apply-templates select="/content/res:sparql[2][descendant::res:result]" mode="types"/>							
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
		<div style="display:none">
			<span id="mapboxKey">
				<xsl:value-of select="//config/mapboxKey"/>
			</span>
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

	<!-- **************** OPEN ANNOTATIONS (E.G., LINKS FROM A TEI FILE) **************** -->
	<xsl:template match="res:sparql" mode="annotations">
		<xsl:variable name="sources" select="distinct-values(descendant::res:result/res:binding[@name='source']/res:uri)"/>
		<xsl:variable name="results" as="element()*">
			<xsl:copy-of select="res:results"/>
		</xsl:variable>

		<div id="associated-content">
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
			<hr/>
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

	<!-- **************** ASSOCIATED COIN TYPES WITH EXAMPLE COIN IMAGES **************** -->
	<xsl:template match="res:sparql" mode="types">
		<xsl:variable name="listTypes-query"><![CDATA[PREFIX rdf:	<http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX nm:	<http://nomisma.org/id/>
PREFIX nmo:	<http://nomisma.org/ontology#>
PREFIX skos:	<http://www.w3.org/2004/02/skos/core#>
PREFIX dcterms:	<http://purl.org/dc/terms/>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX geo:	<http://www.w3.org/2003/01/geo/wgs84_pos#>

SELECT ?type ?hoard ?label ?source ?sourceLabel ?startDate ?endDate ?mint ?mintLabel ?lat ?long ?den ?denLabel WHERE {
BIND (<URI> AS ?hoard)
?object dcterms:isPartOf ?hoard ;
         nmo:hasTypeSeriesItem ?type .
?type a nmo:TypeSeriesItem ;
           skos:prefLabel ?label FILTER(langMatches(lang(?label), "en")) .
   MINUS {?type dcterms:isReplacedBy ?replaced}
   ?type dcterms:source ?source . 
   	?source skos:prefLabel ?sourceLabel FILTER(langMatches(lang(?sourceLabel), "en"))
   OPTIONAL {?type nmo:hasStartDate ?startDate}
   OPTIONAL {?type nmo:hasEndDate ?endDate}
   OPTIONAL {?type nmo:hasMint ?mint . 
   	?mint skos:prefLabel ?mintLabel FILTER(langMatches(lang(?mintLabel), "en"))
   	OPTIONAL {?mint geo:location ?loc .
   	?loc geo:lat ?lat ; geo:long ?long}}
   OPTIONAL {?type nmo:hasDenomination ?den . 
   	?den skos:prefLabel ?denLabel FILTER(langMatches(lang(?denLabel), "en"))}
}]]></xsl:variable>
		
		<xsl:variable name="listCoins-query"><![CDATA[PREFIX rdf:	<http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX nm:	<http://nomisma.org/id/>
PREFIX nmo:	<http://nomisma.org/ontology#>
PREFIX skos:	<http://www.w3.org/2004/02/skos/core#>
PREFIX dcterms:	<http://purl.org/dc/terms/>
PREFIX foaf: <http://xmlns.com/foaf/0.1/>
PREFIX geo:	<http://www.w3.org/2003/01/geo/wgs84_pos#>

SELECT ?object ?title ?hoard ?weight ?diameter ?axis ?type ?label ?source ?sourceLabel ?startDate ?endDate ?mint ?mintLabel ?lat ?long ?den ?denLabel WHERE {
BIND (<URI> AS ?hoard)
?object dcterms:isPartOf ?hoard ;
         dcterms:title ?title ;
         nmo:hasTypeSeriesItem ?type .
OPTIONAL {?object nmo:hasWeight ?weight}
OPTIONAL {?object nmo:hasDiameter ?diameter}
OPTIONAL {?object nmo:hasAxis ?axis}
?type a nmo:TypeSeriesItem ;
           skos:prefLabel ?label FILTER(langMatches(lang(?label), "en")) .
   MINUS {?type dcterms:isReplacedBy ?replaced}
   ?type dcterms:source ?source . 
   	?source skos:prefLabel ?sourceLabel FILTER(langMatches(lang(?sourceLabel), "en"))
   OPTIONAL {?type nmo:hasStartDate ?startDate}
   OPTIONAL {?type nmo:hasEndDate ?endDate}
   OPTIONAL {?type nmo:hasMint ?mint . 
   	?mint skos:prefLabel ?mintLabel FILTER(langMatches(lang(?mintLabel), "en"))
   	OPTIONAL {?mint geo:location ?loc .
   	?loc geo:lat ?lat ; geo:long ?long}}
   OPTIONAL {?type nmo:hasDenomination ?den . 
   	?den skos:prefLabel ?denLabel FILTER(langMatches(lang(?denLabel), "en"))}
}]]></xsl:variable>
		
		<!-- aggregate ids and get URI space -->
		<xsl:variable name="type_series_items" as="element()*">
			<type_series_items>
				<xsl:for-each select="descendant::res:result/res:binding[@name='type']/res:uri">
					<item>
						<xsl:value-of select="."/>
					</item>
				</xsl:for-each>
			</type_series_items>
		</xsl:variable>

		<xsl:variable name="type_series" as="element()*">
			<list>
				<xsl:for-each select="distinct-values(descendant::res:result/res:binding[@name='type']/substring-before(res:uri, 'id/'))">
					<xsl:variable name="uri" select="."/>
					<type_series uri="{$uri}">
						<xsl:for-each select="$type_series_items//item[starts-with(., $uri)]">
							<item>
								<xsl:value-of select="substring-after(., 'id/')"/>
							</item>
						</xsl:for-each>
					</type_series>
				</xsl:for-each>
			</list>
		</xsl:variable>
		
		<!-- use the Numishare Results API to display example coins -->
		<xsl:variable name="sparqlResult" as="element()*">
			<response>
				<xsl:for-each select="$type_series//type_series">
					<xsl:variable name="baseUri" select="concat(@uri, 'id/')"/>
					<xsl:variable name="ids" select="string-join(item, '|')"/>
					
					<xsl:variable name="service" select="concat('http://nomisma.org/apis/numishareResults?identifiers=', encode-for-uri($ids), '&amp;baseUri=',
						encode-for-uri($baseUri))"/>
					<xsl:copy-of select="document($service)/response/*"/>
				</xsl:for-each>
			</response>
		</xsl:variable>
		
		<!-- HTML output -->
		<div id="associated-types">
			<h3>Associated Types <small>(max 20)</small><small><a href="#top" title="Return to top"><span class="glyphicon glyphicon-arrow-up"/></a></small></h3>
			<div style="margin-bottom:10px;">			
				<a href="http://nomisma.org/query?query={encode-for-uri(replace($listTypes-query, 'URI', concat('http://coinhoards.org/id/', $id)))}&amp;output=csv" title="Download CSV" class="btn btn-primary" style="margin-left:10px">
					<span class="glyphicon glyphicon-download"/>Download CSV of Types</a>
				<a href="http://nomisma.org/query?query={encode-for-uri(replace($listCoins-query, 'URI', concat('http://coinhoards.org/id/', $id)))}&amp;output=csv" title="Download CSV" class="btn btn-primary" style="margin-left:10px">
					<span class="glyphicon glyphicon-download"/>Download CSV of Coins</a>
			</div>
			
			<table class="table table-striped">
				<thead>
					<tr>
						<th>Type</th>
						<th>Type Series</th>
						<th style="width:280px">Example</th>
					</tr>
				</thead>
				<tbody>
					<xsl:for-each select="descendant::res:result">
						<xsl:variable name="type_id" select="substring-after(res:binding[@name='type']/res:uri, 'id/')"/>
						
						<tr>
							<td>
								<h4><a href="{res:binding[@name='type']/res:uri}">
									<xsl:value-of select="res:binding[@name='label']/res:literal"/>
								</a></h4>
								<dl class="dl-horizontal">
									<xsl:if test="res:binding[@name='mint']/res:uri">
										<dt>Mint</dt>
										<dd>
											<a href="{res:binding[@name='mint']/res:uri}">
												<xsl:value-of select="res:binding[@name='mintLabel']/res:literal"/>
											</a>
										</dd>
									</xsl:if>
									<xsl:if test="res:binding[@name='den']/res:uri">
										<dt>Denomination</dt>
										<dd>
											<a href="{res:binding[@name='den']/res:uri}">
												<xsl:value-of select="res:binding[@name='denLabel']/res:literal"/>
											</a>
										</dd>
									</xsl:if>
									<xsl:if test="res:binding[@name='startDate']/res:literal or res:binding[@name='endDate']/res:literal">
										<dt>Date</dt>
										<dd>
											<xsl:value-of select="nomisma:normalizeDate(res:binding[@name='startDate']/res:literal)"/>
											<xsl:if test="res:binding[@name='startDate']/res:literal and res:binding[@name='startDate']/res:literal"> - </xsl:if>
											<xsl:value-of select="nomisma:normalizeDate(res:binding[@name='endDate']/res:literal)"/>
										</dd>
									</xsl:if>
								</dl>
							</td>
							<td>
								<a href="{res:binding[@name='source']/res:uri}">
									<xsl:value-of select="res:binding[@name='sourceLabel']/res:literal"/>
								</a>
							</td>
							<td class="text-right">
								<xsl:apply-templates select="$sparqlResult//group[@id=$type_id]/descendant::object" mode="results"/>
							</td>
						</tr>
					</xsl:for-each>
				</tbody>
			</table>
		</div>		
	</xsl:template>
	
	<xsl:template match="object" mode="results">
		<xsl:variable name="position" select="position()"/>
		<!-- obverse -->
		<xsl:choose>
			<xsl:when test="string(obvRef) and string(obvThumb)">
				<a class="thumbImage" rel="gallery" href="{obvRef}" title="Obverse of {@identifier}: {@collection}" id="{@uri}">
					<xsl:if test="$position &gt; 1">
						<xsl:attribute name="style">display:none</xsl:attribute>
					</xsl:if>
					<img src="{obvThumb}"/>
				</a>
			</xsl:when>
			<xsl:when test="not(string(obvRef)) and string(obvThumb)">
				<img src="{obvThumb}">
					<xsl:if test="$position &gt; 1">
						<xsl:attribute name="style">display:none</xsl:attribute>
					</xsl:if>
				</img>
			</xsl:when>
			<xsl:when test="string(obvRef) and not(string(obvThumb))">
				<a class="thumbImage" rel="gallery" href="{obvRef}" title="Obverse of {@identifier}: {@collection}" id="{@uri}">
					<xsl:if test="$position &gt; 1">
						<xsl:attribute name="style">display:none</xsl:attribute>
					</xsl:if>
					<img src="{obvRef}" style="max-width:120px"/>
				</a>
			</xsl:when>
		</xsl:choose>
		<!-- reverse-->
		<xsl:choose>
			<xsl:when test="string(revRef) and string(revThumb)">
				<a class="thumbImage" rel="gallery" href="{revRef}" title="Reverse of {@identifier}: {@collection}" id="{@uri}">
					<xsl:if test="$position &gt; 1">
						<xsl:attribute name="style">display:none</xsl:attribute>
					</xsl:if>
					<img src="{revThumb}"/>
				</a>
			</xsl:when>
			<xsl:when test="not(string(revRef)) and string(revThumb)">
				<img src="{revThumb}">
					<xsl:if test="$position &gt; 1">
						<xsl:attribute name="style">display:none</xsl:attribute>
					</xsl:if>
				</img>
			</xsl:when>
			<xsl:when test="string(revRef) and not(string(revThumb))">
				<a class="thumbImage" rel="gallery" href="{revRef}" title="Obverse of {@identifier}: {@collection}" id="{@uri}">
					<xsl:if test="$position &gt; 1">
						<xsl:attribute name="style">display:none</xsl:attribute>
					</xsl:if>
					<img src="{revRef}" style="max-width:120px"/>
				</a>
			</xsl:when>
		</xsl:choose>
		<!-- combined -->
		<xsl:choose>
			<xsl:when test="string(comRef) and string(comThumb)">
				<a class="thumbImage" rel="gallery" href="{comRef}" title="Reverse of {@identifier}: {@collection}" id="{@uri}">
					<xsl:if test="$position &gt; 1">
						<xsl:attribute name="style">display:none</xsl:attribute>
					</xsl:if>
					<img src="{comThumb}"/>
				</a>
			</xsl:when>
			<xsl:when test="not(string(comRef)) and string(comThumb)">
				<img src="{comThumb}">
					<xsl:if test="$position &gt; 1">
						<xsl:attribute name="style">display:none</xsl:attribute>
					</xsl:if>
				</img>
			</xsl:when>
			<xsl:when test="string(comRef) and not(string(comThumb))">
				<a class="thumbImage" rel="gallery" href="{comRef}" title="Obverse of {@identifier}: {@collection}" id="{@uri}">
					<xsl:if test="$position &gt; 1">
						<xsl:attribute name="style">display:none</xsl:attribute>
					</xsl:if>
					<img src="{comRef}" style="max-width:240px"/>
				</a>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<!-- ***** FUNCTIONS ***** -->
	<xsl:function name="nomisma:normalizeDate">
		<xsl:param name="date"/>

		<xsl:choose>
			<xsl:when test="number($date) &lt; 0">
				<xsl:value-of select="abs(number($date)) + 1"/>
				<xsl:text> B.C.</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>A.D. </xsl:text>
				<xsl:value-of select="number($date)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:function>

</xsl:stylesheet>
