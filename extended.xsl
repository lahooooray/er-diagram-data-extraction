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

            <h2>Inheritance</h2>
            <xsl:for-each select = "root/mxCell[@style='entity']">
                <p>
                <xsl:variable name='entityID' select="@id"/>
                <!-- looking for inheritance -->
                <xsl:call-template name="getInheritance">
                    <xsl:with-param name="entityID" select="$entityID"/>
                </xsl:call-template></p>
            </xsl:for-each>

            <h2>Relations</h2>
            <xsl:for-each select = "root/mxCell[@style='relationship']">
                <p><xsl:call-template name="getRelations"/></p>
            </xsl:for-each>
		</body>
	</html>
</xsl:template>


<xsl:template name="getAttributes">
    <xsl:param name="entityID"/>
    <xsl:for-each select = "../mxCell[@style='attributeConnector'][@target=$entityID]">
        <xsl:variable name='attributeID' select="@source"/>
        <xsl:variable name='connectorID' select="@id"/>

        <!-- key attribute -->
        <xsl:call-template name="isIdentifier">
            <xsl:with-param name="connectorID" select="$connectorID"/>
            <xsl:with-param name="attributeID" select="$attributeID"/>
        </xsl:call-template>


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

<xsl:template name="isIdentifier">
    <xsl:param name="attributeID"/>
    <xsl:param name="connectorID"/>
    <xsl:variable name='attributeName' select="../mxCell[starts-with(@style, 'attribute')][@id=$attributeID]/ErAttribute/@name"/>
    <xsl:variable name="attributeConnectors" select="../mxCell[@target=$connectorID]"/>
    
    <xsl:choose>
        <!-- simple identifier -->
        <xsl:when test="contains(//mxCell[@id=$attributeID]/@style, 'attributeIdentifier')">
            <b><xsl:value-of select="$attributeName" /></b>
        </xsl:when>
        <!-- composite identifier -->
        <xsl:when test="count($attributeConnectors) &gt; 0">
            <xsl:call-template name="isCompositeIdentifier">
                <xsl:with-param name="connectorID" select="$connectorID"/>
                <xsl:with-param name="attributeID" select="$attributeID"/>
            </xsl:call-template>
        </xsl:when>
        <!-- just an attribute -->
        <xsl:otherwise>
            <xsl:value-of select="$attributeName" />
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="isCompositeIdentifier">
    <xsl:param name="attributeID"/>
    <xsl:param name="connectorID"/>
    <xsl:for-each select="../mxCell[@target=$connectorID]">
        <xsl:variable name='compID' select="@source"/>
        <xsl:variable name='attributeName' select="../mxCell[starts-with(@style, 'attribute')][@id=$attributeID]/ErAttribute/@name"/>
        
        <xsl:if test="../mxCell[@id=$compID]/@style='compositeIdentifier'">
            <u><b><xsl:value-of select="$attributeName"/></b> </u>
        </xsl:if>
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