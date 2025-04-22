<xsl:stylesheet version = "1.0" 
xmlns:xsl = "http://www.w3.org/1999/XSL/Transform"> 

<xsl:template match = "/mxGraphModel">
	<html>
		<body>
            <h2>Inheritance</h2>
            <xsl:for-each select = "root/mxCell[@style='entity']">
                <p>
                <xsl:variable name='entityID' select="@id"/>
                <!-- looking for inheritance -->
                <xsl:call-template name="getInheritance">
                    <xsl:with-param name="entityID" select="$entityID"/>
                </xsl:call-template></p>
            </xsl:for-each>

		</body>
	</html>
</xsl:template>
<xsl:template name="getInheritance">
    <xsl:param name="entityID"/>
    <xsl:for-each select = "../mxCell[@style='specialization'][@target=$entityID]">
        <xsl:variable name='sourceID' select="@source"/>
        <xsl:for-each select = "../mxCell[@style='generalization'][@source=$sourceID]">
            <xsl:variable name='parentID' select='@target'/>
            <xsl:variable name="attributeConnectors" select="//mxCell[@style='attributeConnector' and @target=$parentID]"/>
            <xsl:if test="count($attributeConnectors) &gt; 0">
                <xsl:value-of select = "../mxCell[@id=$entityID]/ErEntity/@name"/>
                <xsl:text> inherits from </xsl:text>
                <xsl:value-of select = "../mxCell[@style='entity'][@id=$parentID]/ErEntity/@name"/>: 
                <xsl:call-template name="getAttributes">
                    <xsl:with-param name="entityID" select="$parentID"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:for-each>
    </xsl:for-each>
</xsl:template>
</xsl:stylesheet>