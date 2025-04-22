<xsl:stylesheet version = "1.0" 
xmlns:xsl = "http://www.w3.org/1999/XSL/Transform"> 

<xsl:template match = "/mxGraphModel">

	<html>
		<body>
            <h2>Entities and attributes</h2>
            <xsl:for-each select = "root/mxCell[@style='entity']">
                <p><xsl:value-of select = "ErEntity/@name"/>:
                <xsl:variable name='entityID' select="@id"/>
                <xsl:call-template name="isIdentifier">
                    <xsl:with-param name="entityID" select="$entityID"/>
                </xsl:call-template>
                <xsl:call-template name="isCompositeIdentifier">
                    <xsl:with-param name="entityID" select="$entityID"/>
                </xsl:call-template>
                </p>
            </xsl:for-each>
		</body>
	</html>
</xsl:template>


<xsl:template name="isIdentifier">
    <xsl:param name="entityID"/>
    <xsl:for-each select = "../mxCell[@style='attributeConnector'][@target=$entityID]">
        <xsl:variable name='attributeID' select="@source"/>
        <xsl:variable name='connectorID' select="@id"/>
        <xsl:variable name='attributeName' select="../mxCell[starts-with(@style, 'attribute')][@id=$attributeID]/ErAttribute/@name"/>
    
        <xsl:if test="contains(//mxCell[@id=$attributeID]/@style, 'attributeIdentifier')">
            <b><xsl:value-of select="$attributeName" /></b>
            <xsl:if test="position() != last()"><xsl:text>; </xsl:text></xsl:if>
        </xsl:if>

    </xsl:for-each>
</xsl:template>

<xsl:template name="isCompositeIdentifier">
    <xsl:param name="entityID"/>
    <xsl:for-each select="../mxCell[@style='compositeIdentifier']">
        <xsl:variable name='compID' select="@id"/>
        <!-- compositeIdentifier ID -> source in other mxCell which has attrConnector 
        as a target -> this attrConnector in its source has an attribute itself -->
        <xsl:for-each select="../mxCell[@id=../mxCell[@style='attributeConnector'][@id=../mxCell[@source=$compID]/@target]/@source]/ErAttribute">
            <u><xsl:value-of select="@name"/>
            <xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if></u>
        </xsl:for-each>
        <xsl:text>; </xsl:text>
    </xsl:for-each>
</xsl:template>

</xsl:stylesheet>