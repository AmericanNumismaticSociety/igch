<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">

	<xsl:template name="header">
		<!-- Static navbar -->
		<div class="navbar navbar-default navbar-static-top" role="navigation">
			<div class="container-fluid">
				<div class="navbar-header">
					<button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
						<span class="sr-only">Toggle navigation</span>
						<span class="icon-bar"/>
						<span class="icon-bar"/>
						<span class="icon-bar"/>
					</button>
					<a class="navbar-brand logo-nav" href="{$display_path}./">IGCH</a>
				</div>
				<div class="navbar-collapse collapse">
					<ul class="nav navbar-nav">
						<li>
							<a href="{$display_path}browse">Browse IDs</a>
						</li>						
					</ul>
					<!--<div class="col-sm-3 col-md-3 pull-right">
						<form class="navbar-form" role="search" action="{$display_path}browse" method="get">
							<div class="input-group">
								<input type="text" class="form-control" placeholder="Search" name="q" id="srch-term"/>
								<div class="input-group-btn">
									<button class="btn btn-default" type="submit">
										<i class="glyphicon glyphicon-search"/>
									</button>
								</div>
							</div>
						</form>
					</div>-->
				</div>
				<!--/.nav-collapse -->
			</div>
		</div>
	</xsl:template>

	<xsl:template name="footer">
		<div id="footer">
			<div class="container-fluid">
				<p class="text-muted"><a href="http://creativecommons.org/licenses/by/3.0/"><img alt="Creative Commons License" style="border-width:0"
							src="http://i.creativecommons.org/l/by/3.0/88x31.png"/></a><br/>Unless specified otherwise, content in <a href="http://coinhoards.org"
						xmlns:dc="http://purl.org/dc/elements/1.1/">Coinhoards.org</a> is licensed under a <a xmlns:cc="http://creativecommons.org/ns#" href="http://creativecommons.org/licenses/by/3.0/"
						>Creative Commons Attribution 3.0 License</a>.</p>
			</div>
		</div>
	</xsl:template>

</xsl:stylesheet>
