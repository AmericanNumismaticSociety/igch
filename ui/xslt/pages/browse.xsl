<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
	<xsl:include href="../templates.xsl"/>
	<xsl:variable name="display_path"/>

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
					<h1>Browse</h1>
					<ul>
						<xsl:for-each select="descendant::file">
							<xsl:sort select="@name"/>
							<li>
								<a href="{$display_path}id/{substring-before(@name, '.')}">
									<xsl:value-of select="substring-before(@name, '.')"/>
								</a>
							</li>
						</xsl:for-each>
					</ul>					
				</div>				
			</div>
		</div>
	</xsl:template>
</xsl:stylesheet>
