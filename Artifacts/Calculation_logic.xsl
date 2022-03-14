<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions">
	<xsl:import href="Utility.xsl"/>
	<xsl:output encoding="UTF-8" method="xml" indent="no"/>
	<xsl:variable name="Envelope">
		<xsl:call-template name="get_Compared_element_name"/>
	</xsl:variable>
	<xsl:variable name="Envelope1" select="/">

		</xsl:variable>
	<xsl:template match="/">
		<xsl:call-template name="DC"/>
	</xsl:template>
	<xsl:template name="DC">
		<xsl:element name="CalculationOutputWrapper">
			<xsl:for-each select="$Envelope1//node()[name()=$Envelope][1]/node()">
				<xsl:call-template name="COMPONENT_REC">
					<xsl:with-param name="component_root" select="current()"/>
					<xsl:with-param name="direction" select="'uptodown'"/>
				</xsl:call-template>
			</xsl:for-each>
			<xsl:for-each select="$Envelope1//node()[name()=$Envelope][2]/node()">
				<xsl:call-template name="COMPONENT_REC">
					<xsl:with-param name="component_root" select="current()"/>
					<xsl:with-param name="direction" select="'downtoup'"/>
				</xsl:call-template>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
	<xsl:template name="COMPONENT_REC">
		<xsl:param name="component_root"/>
		<xsl:param name="direction"/>
		<xsl:variable name="rootName" select="$component_root/name()"/>
		<xsl:variable name="rootPrimaryKey">
			<xsl:call-template name="get_primary_attribute_name_by_tag_name">
				<xsl:with-param name="component_name" select="$rootName"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="rootID" select="$component_root/attribute()[name()=$rootPrimaryKey]"/>
		<xsl:variable name="rootParentName" select="$component_root/parent::node()/name()"/>
		<xsl:variable name="rootParentPrimaryKey">
			<xsl:call-template name="get_primary_attribute_name_by_tag_name">
				<xsl:with-param name="component_name" select="$rootParentName"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="rootParentID" select="$component_root/parent::node()/attribute()[name()=$rootParentPrimaryKey]"/>
			<xsl:variable name="brother_root">
			<xsl:for-each select="ancestor::node()[name()=$Envelope]/following-sibling::node()[name()=$Envelope]/descendant::node()
				[name()=$rootName and (attribute()[name()=$rootPrimaryKey]=$rootID or (not(attribute()[name()=$rootPrimaryKey]) and not ($rootID)))]">
				<xsl:if test="not(parent::node()[name()=$Envelope]) and not($component_root/parent::node()[name()=$Envelope])">
					<xsl:if test="parent::node()[name()=$rootParentName and(attribute()[name()=$rootParentPrimaryKey]=$rootParentID
					or (not(attribute()[name()=$rootParentPrimaryKey]) and not ($rootParentID) ) )] ">
						<xsl:copy-of select="current()"/>
					</xsl:if>
				</xsl:if>
				<xsl:if test="parent::node()[name()=$Envelope] and $component_root/parent::node()[name()=$Envelope]">
					<xsl:copy-of select="current()"/>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="precedingBrother_root">
			<xsl:for-each select="ancestor::node()[name()=$Envelope]/preceding-sibling::node()[name()=$Envelope]/descendant::node()
				[name()=$rootName and (attribute()[name()=$rootPrimaryKey]=$rootID or (not(attribute()[name()=$rootPrimaryKey]) and not ($rootID)))]">
				<xsl:if test="not(parent::node()[name()=$Envelope])">
					<xsl:if test="parent::node()[name()=$rootParentName and((attribute()[name()=$rootParentPrimaryKey]=$rootParentID)
					or (not(attribute()[name()=$rootParentPrimaryKey]) and not ($rootParentID) ) )] ">
						<xsl:copy-of select="current()"/>
					</xsl:if>
				</xsl:if>
				<xsl:if test="parent::node()[name()=$Envelope]">
					<xsl:copy-of select="current()"/>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="child">
			<xsl:if test="$precedingBrother_root = '' ">
				<xsl:for-each select="$component_root/node()">
					<xsl:call-template name="COMPONENT_REC">
						<xsl:with-param name="component_root" select="current()"/>
						<xsl:with-param name="direction" select="$direction"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:if>
			<xsl:for-each select="$brother_root/node()/node()">
				<xsl:variable name="rootChildKey">
					<xsl:call-template name="get_primary_attribute_name_by_tag_name">
						<xsl:with-param name="component_name" select="current()/name()"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="not (	$component_root/node()[name()=current()/name() and 	(attribute()[name()=$rootChildKey]=current()/attribute()[name()=$rootChildKey])] or
					(
					not
					(attribute()[name()=$rootChildKey])
					 and not(current()/attribute()[name()=$rootChildKey] )
					 ))">
						<xsl:call-template name="COMPONENT_REC">
							<xsl:with-param name="component_root" select="current()"/>
							<xsl:with-param name="direction" select="'downtoup'"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>		
					
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$brother_root/node()[name()=$component_root/name()]">
				<xsl:choose>
					<xsl:when test=" $child/node()[name()!= ''] ">
						<xsl:copy>
							<xsl:copy-of select="@*"/>
							<xsl:attribute name="action"><xsl:call-template name="get_DC_Updated_Element"/></xsl:attribute>
							<xsl:copy-of select="$child"/>
						</xsl:copy>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:when test=" not($brother_root/node()[name()=$component_root/name()]) and $direction='uptodown' ">
				<xsl:call-template name="removeComponent">
					<xsl:with-param name="child" select="$child"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test=" not($precedingBrother_root/node()[name()=$component_root/name()])  and $direction='downtoup' ">
				<xsl:call-template name="addComponent">
					<xsl:with-param name="child" select="$child"/>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="removeComponent">
		<xsl:param name="child"/>
		<xsl:copy>
			<xsl:copy-of select="current()/@*"/>
			<xsl:attribute name="action"><xsl:call-template name="get_DC_Removed_Element"/></xsl:attribute>
			<xsl:copy-of select="$child"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template name="addComponent">
		<xsl:param name="child"/>
		<xsl:copy>
			<xsl:copy-of select="current()/@*"/>
			<xsl:attribute name="action"><xsl:call-template name="get_DC_Added_Element"/></xsl:attribute>
			<xsl:copy-of select="$child"/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
