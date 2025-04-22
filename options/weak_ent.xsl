<xsl:stylesheet version = "1.0" 
xmlns:xsl = "http://www.w3.org/1999/XSL/Transform"> 

<xsl:template match = "/mxGraphModel">

	<html>
		<body>
            <h2>Weak entities</h2>
            <xsl:call-template name="getWeakEntities"/>
		</body>
	</html>
</xsl:template>

<xsl:template name="getWeakEntities">
    <xsl:for-each select="//mxCell[@style='entity']">
        <xsl:variable name="entityID" select="@id" />
        <xsl:for-each select="//mxCell[@style='compositeIdentifier'][@id = //mxCell[@target=$entityID]/@source]">
            <xsl:variable name="compositeID" select="@id" />
            <xsl:value-of select="//mxCell[@id=$entityID]/ErEntity/@name"/>
            <xsl:text> (Identifier: </xsl:text>

            <xsl:for-each select="//mxCell[@source=$compositeID]">
            <xsl:variable name='targetID' select='@target'/>
            <xsl:choose>
                
                <xsl:when test="//mxCell[@id=$targetID][@style='attributeConnector']">
                <xsl:variable name = 'attrID' select="//mxCell[@id=$targetID][@style='attributeConnector']/@source"/>
                <xsl:value-of select="//mxCell[@id=$attrID]/ErAttribute/@name" />
                <xsl:text> </xsl:text>
                </xsl:when>

                <xsl:when test="//mxCell[@id=$targetID][@style='relationshipConnector']">
                <xsl:variable name="relID" select="//mxCell[@id=$targetID]/@source"/>
                <xsl:value-of select="//mxCell[@id=$relID]/ErRelationship/@name" />
                <xsl:text> </xsl:text>
                </xsl:when>
            </xsl:choose>
            </xsl:for-each>

            <xsl:text>)</xsl:text><br/>
        </xsl:for-each>
    </xsl:for-each>
</xsl:template>
</xsl:stylesheet>