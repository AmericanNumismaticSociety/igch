<?xml version="1.0" encoding="UTF-8"?>

<p:config xmlns:p="http://www.orbeon.com/oxf/pipeline"
	xmlns:oxf="http://www.orbeon.com/oxf/processors">

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
		<p:input name="config" href="../../../ui/xslt/pages/browse.xsl"/>
		<p:output name="data" ref="data"/>
	</p:processor>
	

</p:config>
