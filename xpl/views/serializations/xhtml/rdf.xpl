<?xml version="1.0" encoding="UTF-8"?>
<!--
	Copyright (C) 2010 Ethan Gruber
	EADitor: http://code.google.com/p/eaditor/
	Apache License 2.0: http://code.google.com/p/eaditor/
	
-->
<p:config xmlns:p="http://www.orbeon.com/oxf/pipeline" xmlns:oxf="http://www.orbeon.com/oxf/processors">

	<p:param type="input" name="data"/>
	<p:param type="output" name="data"/>

	<p:processor name="oxf:unsafe-xslt">		
		<p:input name="data" href="aggregate('content', ../../../../config.xml, #data)"/>
		<p:input name="config" href="../../../../ui/xslt/serializations/xhtml/rdf.xsl"/>
		<p:output name="data" id="model"/>
	</p:processor>
	
	<p:processor name="oxf:xml-serializer">
		<p:input name="data" href="#model"/>
		<p:input name="config">
			<config>
				<content-type>application/rdf+xml</content-type>
				<indent>true</indent>
				<indent-amount>4</indent-amount>
			</config>
		</p:input>
		<p:output name="data" ref="data"/>
	</p:processor>
</p:config>
