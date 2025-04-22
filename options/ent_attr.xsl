<xsl:stylesheet version = "1.0" 
xmlns:xsl = "http://www.w3.org/1999/XSL/Transform"> 

<xsl:template match = "/mxGraphModel">
	<html>
		<body>
			<h2>Entities and attributes</h2>
            <xsl:for-each select = "root/mxCell[@style='entity']">
                <p><xsl:value-of select = "ErEntity/@name"/>:
                <xsl:variable name='entityID' select="@id"/>
                <xsl:call-template name="getAttributes">
                    <xsl:with-param name="entityID" select="$entityID"/>
                </xsl:call-template>
                </p>
            </xsl:for-each>
		</body>
	</html>
</xsl:template>

<xsl:template name="getAttributes">
    <xsl:param name="entityID"/>
    <xsl:for-each select = "../mxCell[@style='attributeConnector'][@target=$entityID]">
        <xsl:variable name='attributeID' select="@source"/>

        <!-- composite attibute -->
        <xsl:call-template name="isComposite">
            <xsl:with-param name="attributeID" select="$attributeID"/>
        </xsl:call-template>

        <xsl:if test="position() != last()"><xsl:text>; </xsl:text></xsl:if>
    </xsl:for-each>
</xsl:template>

<xsl:template name="isComposite">
    <xsl:param name="attributeID"/>
    <xsl:if test="count(//mxCell[@style='attributeConnector' and @target=$attributeID]) &gt; 0">
        <xsl:text>(</xsl:text>
        <xsl:for-each select="../mxCell[@style='attributeConnector'][@target=$attributeID]">
            <xsl:variable name='sourceID' select="@source"/>
            <xsl:value-of select = "../mxCell[@id=$sourceID]/ErAttribute/@name"/>
            <xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if>
        </xsl:for-each>
        <xsl:text>)</xsl:text>
    </xsl:if>
</xsl:template>

</xsl:stylesheet>