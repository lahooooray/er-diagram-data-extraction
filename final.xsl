<xsl:stylesheet version = "1.0" 
xmlns:xsl = "http://www.w3.org/1999/XSL/Transform"> 

<xsl:template match = "/mxGraphModel">
	<html>
		<body>
			<h2>Entities and attributes</h2>
            <xsl:for-each select = "root/mxCell[@style='entity']">
                <p><xsl:call-template name="getAttributes"/></p>
            </xsl:for-each>

            <h2>Relations</h2> 
            <xsl:for-each select = "root/mxCell[@style='relationship']">
                <p><xsl:call-template name="getRelations"/></p>
            </xsl:for-each>
		</body>
	</html>
</xsl:template>

<xsl:template name="getAttributes">
    <xsl:value-of select = "ErEntity/@name"/>:
    <xsl:variable name='entityID' select="@id"/>
    <xsl:for-each select = "../mxCell[@style='attributeConnector'][@target=$entityID]">
        <xsl:variable name='attributeID' select="@source"/>
        <xsl:value-of select = "../mxCell[starts-with(@style, 'attribute')][@id=$attributeID]/ErAttribute/@name"/>
        <xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if>
    </xsl:for-each>
</xsl:template>


<xsl:template name="getRelations">
    <xsl:if test="ErRelationship/@name != 'new relationship'">
        <xsl:variable name='relationshipID' select="@id"/>
        <xsl:value-of select="ErRelationship/@name"/>: 
        <xsl:for-each select = "../mxCell[@style='relationshipConnector'][@source=$relationshipID]">
            <xsl:variable name='entityID' select="@target"/>
            <xsl:value-of select="../mxCell[@style='entity'][@id=$entityID]/ErEntity/@name"/>
            <xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if>
        </xsl:for-each>
    </xsl:if>
</xsl:template>

</xsl:stylesheet>