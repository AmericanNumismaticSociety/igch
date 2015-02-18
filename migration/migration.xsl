<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns="http://www.w3.org/1999/xhtml" exclude-result-prefixes="#all" version="2.0">

	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
	<!--<xsl:template match="xhtml:a[@rel='nmo:hasMint'][child::xhtml:a]">
		<span resource="{@href}" rel="nmo:hasMint">
			<xsl:apply-templates/>
		</span>
	</xsl:template>-->

	<xsl:template match="xhtml:div[@about]">
		<div typeof="{@typeof}" about="{@about}">
			<xsl:apply-templates select="xhtml:div[@property='skos:prefLabel']"/>
			<!-- full findspot out of pre, if necessary -->
			<xsl:if test="descendant::xhtml:pre/*[@rel='nmo:hasFindspot']">
				<xsl:copy-of select="descendant::xhtml:pre/*[@rel='nmo:hasFindspot']"/>
			</xsl:if>
			
			<!-- pull closing date out of pre, if necessary -->
			<xsl:if test="descendant::*[@property='closing_date_start'] and descendant::*[@property='closing_date_end']">
				<div property="nmo:hasClosingDate">
					<div typeof="dcterms:PerodOfTime">
						<xsl:apply-templates select="descendant::*[@property='closing_date_start']|descendant::*[@property='closing_date_end']" mode="pull"/>
					</div>
				</div>
			</xsl:if>	
			
			<xsl:if test="descendant::*[@property='closing_date']">
				<xsl:apply-templates select="descendant::*[@property='closing_date']" mode="pull"/>
			</xsl:if>
			
			<xsl:apply-templates select="*[not(@property='closing_date_start') and not(@property='closing_date_end') and not(@property='closing_date') and not(@property='skos:prefLabel')]"/>
		</div>
	</xsl:template>

	<xsl:template match="xhtml:div[@property='skos:prefLabel']">
		<h1 property="dcterms:title" lang="en">
			<xsl:value-of select="."/>
		</h1>
	</xsl:template>

	<xsl:template match="*[@property='closing_date_start']|*[@property='closing_date_end']" mode="pull">
		<span property="{if (@property='closing_date_start') then 'nmo:hasStartDate' else 'nmo:hasEndDate'}" datatype="xsd:gYear" content="{@content}">
			<xsl:value-of select="."/>
		</span>
	</xsl:template>

	<xsl:template match="*[@property='closing_date']" mode="pull">
		<span property="nmo:hasClosingDate" datatype="xsd:gYear" content="{@content}">
			<xsl:value-of select="."/>
		</span>
	</xsl:template>

	<xsl:template match="xhtml:span[@rel][@resource]">
		<a href="http://nomisma.org/id/{@resource}" rel="{@rel}" target="_blank">
			<xsl:value-of select="."/>
		</a>
	</xsl:template>
	
	<xsl:template match="xhtml:pre/*[@property='closing_date']|xhtml:pre/*[@property='closing_date_start']|xhtml:pre/*[@property='closing_date_end']|xhtml:pre/*[@rel='nmo:hasFindspot']"/>

</xsl:stylesheet>
