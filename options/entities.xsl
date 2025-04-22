<xsl:stylesheet version = "1.0" 
xmlns:xsl = "http://www.w3.org/1999/XSL/Transform"> 

<xsl:template match = "/mxGraphModel">
	<html>
		<body>
			<h2>Entities</h2>
            <ul>
            <xsl:for-each select = "root/mxCell[@style='entity']">
                <li><xsl:value-of select = "ErEntity/@name"/></li>
            </xsl:for-each>
            </ul>
		</body>
	</html>
</xsl:template>
</xsl:stylesheet>