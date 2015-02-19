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
				<div class="col-md-12">
					<h1>Inventory of Greek Coin Hoards</h1>
					<p>The original Inventory of Greek Coin Hoards (IGCH), edited by Margaret Thompson of the ANS, Otto Mørkholm of the Danish cabinet in Copenhagen and Coin Kraay
						of the Heberden Coin Room in the Ashmolean Museum, Oxford, was published in 1973 by the ANS for the International Numismatic Commission. The work contains
						inventory listings of 2387 hoards, covering the whole of the ancient Greek numismatic world.</p>

					<p>Online IGCH was devised by Sebastian Heath and Andrew Meadows as an attempt to create an open and accessible version of IGCH on the world Wide Web using the
						principles of Linked Open Data. The test version was housed within the <a href="http://nomisma.org/">Nomisma.org</a> namespace before its migration to its
						own domain in February 2015. </p>

					<p>Work on the original project was enabled by funding from the American Numismatic Society, Stanford University, and the UK’s Arts and Humanities Research
						Council. Data was contributed by the Nomisma project based at Paris IV Sorbonne. Subsequent work to create the new site has been supported by the
						International Numismatic Council, under whose auspices the project has now been incorporated. Technical realisation of the new IGCH site is by Ethan
						Gruber.</p>

					<p>The current site is a prototype, and will undergo enhancement through the course of 2015. It is the long term aim of the project to incorporate all published
						Greek coin hoards as part of the broader Online Greek Coinage initiative.</p>
				</div>
			</div>
			<div class="row">
				<div class="col-md-6">
					<h3>Data Export</h3>
					<div>
						<h4>Nomisma Linked Data</h4>
						<table class="table-dl">
							<tr>
								<td>
									<a href="http://nomisma.org">
										<img src="{$display_path}ui/images/nomisma.png"/>
									</a>
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
					<div>
						<h4>Pelagios Annotations</h4>
						<table class="table-dl">
							<tr>
								<td>
									<a href="http://pelagios-project.blogspot.com/">
										<img src="{$display_path}ui/images/pelagios_icon.png"/>
									</a>
								</td>
								<td>
									<strong>VoID (RDF): </strong>
									<a href="pelagios.void.rdf">XML</a>
									<br/>
									<strong>Dump (RDF): </strong>
									<a href="pelagios.rdf">XML</a>
								</td>
							</tr>
						</table>
					</div>
				</div>
				<div class="col-md-6">
					<h3>Contributors</h3>
					<p>The following institutions have contributed data, specialist advice and/or financial support to the IGCH:</p>
					<div class="media">
						<a href="http://numismatics.org" title="http://numismatics.org" rel="nofollow">
							<img src="http://www.numismatics.org/pmwiki/pub/skins/ans/ans_seal.gif" alt="http://numismatics.org"/>
						</a>
					</div>
					<div class="media">
						<a href="http://www.paris-sorbonne.fr/" title="http://www.paris-sorbonne.fr/" rel="nofollow">
							<img src="ui/images/paris-small.jpg" alt="http://www.paris-sorbonne.fr/"/>
						</a>
					</div>
					<div class="media">
						<a href="http://stanford.edu" title="http://stanford.edu" rel="nofollow">
							<img src="ui/images/stanford-small.jpg" alt="http://stanford.edu"/>
						</a>
					</div>
					<div class="media">
						<a href="http://www.ahrc.ac.uk/" title="http://www.ahrc.ac.uk/" rel="nofollow">
							<img src="http://archaeologydataservice.ac.uk/images/logos/org34.png" alt="http://www.ahrc.ac.uk/"/>
						</a>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>
</xsl:stylesheet>
