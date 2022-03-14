<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions">
	<xsl:output encoding="UTF-8" method="xml"/>
	<xsl:template name="get_primary_attribute_name_by_tag_name">
		<xsl:param name="component_name"/>
		<xsl:for-each select="document('Configuration.xml')/configuration/Component[@tagname= $component_name]">
			<xsl:variable name="primaryKey" select="current()/@primarykey"/>
			<xsl:value-of select="$primaryKey"/>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="get_valueComparing_attribute_name_by_tag_name">
		<xsl:param name="component_name"/>
		<xsl:for-each select="document('Configuration.xml')/configuration/Component[@tagname= $component_name]">
			<xsl:variable name="value_comparing" select="current()/@value_comparing"/>
			<xsl:value-of select="$value_comparing"/>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="get_Compared_element_name">
	
		<xsl:for-each select="document('Configuration.xml')/configuration/DC-ComparedElement">
			<xsl:variable name="elementName" select="current()/@elementName"/>
			<xsl:value-of select="$elementName"/>
		</xsl:for-each>
	</xsl:template>
	
		<xsl:template name="get_DC_Updated_Element">
	
		<xsl:for-each select="document('Configuration.xml')/configuration/DC-UpdatedElement">
			<xsl:variable name="updatedElement" select="current()/@flagValue"/>
			<xsl:value-of select="$updatedElement"/>
		</xsl:for-each>
	</xsl:template>
		<xsl:template name="get_DC_Removed_Element">
	
		<xsl:for-each select="document('Configuration.xml')/configuration/DC-RemovedElement">
			<xsl:variable name="removedElement" select="current()/@flagValue"/>
			<xsl:value-of select="$removedElement"/>
		</xsl:for-each>
	</xsl:template>
		<xsl:template name="get_DC_Added_Element">
	
		<xsl:for-each select="document('Configuration.xml')/configuration/DC-AddedElement">
			<xsl:variable name="addedElement" select="current()/@flagValue"/>
			<xsl:value-of select="$addedElement"/>
		</xsl:for-each>
	</xsl:template>	
</xsl:stylesheet>
