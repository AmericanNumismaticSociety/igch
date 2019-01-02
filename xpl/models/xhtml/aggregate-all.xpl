<?xml version="1.0" encoding="UTF-8"?>
<p:config xmlns:p="http://www.orbeon.com/oxf/pipeline" xmlns:oxf="http://www.orbeon.com/oxf/processors">

	<p:param type="input" name="data"/>
	<p:param type="output" name="data"/>
	
	<p:processor name="oxf:directory-scanner">
		<!-- The configuration can often be inline -->
		<p:input name="config">
			<config>
				<base-directory>oxf:/apps/igch/data</base-directory>			
				<include>*.xml</include>				
				<case-sensitive>false</case-sensitive>
			</config>
		</p:input>
		<p:output name="data" id="directory-scan"/>
	</p:processor>

	<p:processor name="oxf:unsafe-xslt">
		<p:input name="data" href="#directory-scan"/>
		<p:input name="config">
			<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
				<xsl:template match="/">									
					<html xmlns="http://www.w3.org/1999/xhtml">
						<head>
							<title>aggregation</title>
						</head>
						<body>
							<xsl:for-each select="//file">
								<xsl:copy-of select="document(concat('oxf:/apps/igch/data/', @name))/*"/>
							</xsl:for-each>
						</body>
					</html>
				</xsl:template>
			</xsl:stylesheet>
		</p:input>
		<p:output name="data" ref="data"/>
	</p:processor>
</p:config>
