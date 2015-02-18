<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
	<xsl:include href="../templates.xsl"/>
	<xsl:variable name="display_path">./</xsl:variable>

	<xsl:template match="/">
		<html lang="en">
			<head>
				<title>Inventory of Greek Coin Hoards</title>
				<meta name="viewport" content="width=device-width, initial-scale=1"/>
				<script type="text/javascript" src="http://code.jquery.com/jquery-latest.min.js"/>
				<!-- bootstrap -->
				<link rel="stylesheet" href="http://netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css"/>
				<script type="text/javascript" src="http://netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"/>
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
		<div class="container-fluid content">
			<div class="row">
				<div class="col-md-8">
					<h1>Inventory of Greek Coin Hoards</h1>
					<p>This is the placeholder for the IGCH temporary framework.</p>
				</div>
				<div class="col-md-4">
					<h2>Data Export</h2>
					<h3>Nomisma Linked Data</h3>
					<table class="table-dl">
						<tr>
							<td>
								<img src="{$display_path}ui/images/nomisma.png"/>
							</td>
							<td>
								<strong>Linked Data: </strong>
								<a href="nomisma.void.rdf">VoID RDF/XML</a>
								<br/>
								<!--<a href="nomisma.org.jsonld">JSON-LD</a>, <a href="nomisma.org.ttl">TTL</a>, -->
								<a href="nomisma.rdf">RDF/XML</a>
							</td>
						</tr>
					</table>
				</div>
			</div>
		</div>
	</xsl:template>
</xsl:stylesheet>
