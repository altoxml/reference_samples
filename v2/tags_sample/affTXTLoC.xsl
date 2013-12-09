<?xml version="1.0" encoding="UTF-8"?>
<!-- edited with XMLSpy v2010 rel. 3 sp1 (http://www.altova.com) by BnF (BNF) -->

<!--Auteur  : BnF/DSR/DSC/NUM/JP Moreux, Version : 1.0 -->
<!-- To be used with Xalan-Java -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" 
 xmlns:alto="http://www.loc.gov/standards/alto/ns-v2#"
 xmlns:str="http://exslt.org/strings" extension-element-prefixes="str">


<xsl:output method="html" indent="no" omit-xml-declaration="yes"/>
	
<xsl:template match="/">
      <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"&gt;</xsl:text>
      <xsl:text disable-output-escaping='yes'>&lt;html xmlns="http://www.w3.org/1999/xhtml"&gt;</xsl:text>
      <head>
         <xsl:text disable-output-escaping='yes'>&lt;meta http-equiv="Content-Type" content="application/xhtml+xml; charset=UTF-8"/&gt;</xsl:text>      
         <xsl:text disable-output-escaping='yes'>&lt;link rel="stylesheet" href="CSS\stylesheet.css" type="text/css"/&gt;</xsl:text>
         
         <title>Affichage des contenus ALTO selon le taux de confiance</title> 
   </head>
   <body>
        <xsl:apply-templates select="/alto:alto/alto:Tags"/>
        <hr/>
        <xsl:apply-templates select="/alto:alto/alto:Layout/alto:Page"/>
  </body>
      <xsl:text disable-output-escaping='yes'>&lt;/html&gt;</xsl:text>
</xsl:template>

<!-- Traitement des tags   -->
<xsl:template match="//alto:Tag">
      <p class="comment"><a><xsl:attribute name="id"><xsl:value-of select="attribute::ID"/></xsl:attribute></a><xsl:value-of select="@ID"/>: <xsl:value-of select="@TYPE"/> /  <xsl:value-of select="@SUBTYPE"/> / <xsl:value-of select="@LABEL"/></p>
</xsl:template> 

<!-- Traitement des pages   -->
<xsl:template match="//alto:Page">
   <xsl:apply-templates/>
</xsl:template>



<!-- Traitement du texte  -->
<xsl:template match="alto:TextBlock">
     
<xsl:choose>
           <!-- tag ?  -->
            <xsl:when test="@TAGREFS">  
            <xsl:text disable-output-escaping='yes'>&lt;p class="TextBlock </xsl:text>   
            
				<xsl:variable name="tagID"><xsl:value-of select="@TAGREFS"/></xsl:variable>                
				<xsl:variable name="tagType"><xsl:value-of select="/alto:alto/alto:Tags/alto:Tag[@ID=$tagID]/@TYPE"/></xsl:variable>
				  <xsl:choose>  
						<xsl:when test="$tagType='STRUCTURE'"><xsl:text disable-output-escaping='yes'>tagStructureContent"&gt;</xsl:text></xsl:when>					
						<xsl:when test="$tagType='LAYOUT'"><xsl:text disable-output-escaping='yes'>tagLayoutContent"&gt;</xsl:text></xsl:when>					
						<xsl:when test="$tagType='OTHER'"><xsl:text disable-output-escaping='yes'>tagOtherContent"&gt;</xsl:text></xsl:when> 
				</xsl:choose>
				<xsl:apply-templates/><span class="tb">&#167;</span>
				<!-- link on tag ID  -->
				<a><xsl:attribute name="href">#<xsl:value-of select="attribute::TAGREFS"/></xsl:attribute>
						<sup class="tagID"><xsl:value-of select="@TAGREFS"/></sup> </a>
						<xsl:text disable-output-escaping='yes'>&lt;/p&gt;</xsl:text>		
		  </xsl:when> 
          <xsl:otherwise><p class="TextBlock"><xsl:apply-templates/><span class="tb">&#167;</span></p></xsl:otherwise>
  </xsl:choose>
      
   
</xsl:template>   

<xsl:template match="//alto:TextLine">
  	     <xsl:choose>
           <!-- tag ?  -->
            <xsl:when test="@TAGREFS">
				<xsl:variable name="tagID"><xsl:value-of select="@TAGREFS"/></xsl:variable>                
                <xsl:variable name="tagType"><xsl:value-of select="/alto:alto/alto:Tags/alto:Tag[@ID=$tagID]/@TYPE"/></xsl:variable>
				
				<xsl:choose>  
					<xsl:when test="$tagType='STRUCTURE'"><span class="tagStructureContent"><xsl:apply-templates/></span></xsl:when>					
					<xsl:when test="$tagType='LAYOUT'"><span class="tagLayoutContent"><xsl:apply-templates/></span></xsl:when>					
					<xsl:when test="$tagType='OTHER'"><span class="tagOtherContent"><xsl:apply-templates/></span></xsl:when> 
				</xsl:choose>
				<!-- link on tag ID  -->
				<a><xsl:attribute name="href">#<xsl:value-of select="attribute::TAGREFS"/></xsl:attribute>
						<sup class="tagID"><xsl:value-of select="@TAGREFS"/></sup> </a>				
			</xsl:when>   				
						 
			 <xsl:otherwise><xsl:apply-templates/></xsl:otherwise>	
		</xsl:choose>
			
		 <xsl:if test="following-sibling::alto:TextLine">  <!-- si une ligne suit, un retour à la ligne -->
           <span class="st">&#8629;</span><br/>
         </xsl:if> 
	</xsl:template>
	 
	 
 
<xsl:template match="//alto:String">
	<xsl:variable name="tagContent"><xsl:value-of select="@CONTENT"/></xsl:variable>
                
	<xsl:choose>
	<!-- tag exists?  -->
    <xsl:when test="@TAGREFS">	
      
       <!-- <p class="comment">contenu :<xsl:value-of select="$tagContent"/></p>-->
  		
  		<xsl:variable name="tagID"><xsl:value-of select="@TAGREFS"/></xsl:variable>                
        <xsl:variable name="tagType"><xsl:value-of select="/alto:alto/alto:Tags/alto:Tag[@ID=$tagID]/@TYPE"/></xsl:variable>
                	 	 
        <!-- <xsl:for-each select="str:tokenize(@TAGREFS,'\ ')"> 
			<xsl:variable name="tagID"><xsl:value-of select="."/></xsl:variable>			
			<xsl:variable name="tagType"><xsl:value-of select="/alto:alto/alto:Tags/alto:Tag[@ID=$tagID]"/></xsl:variable> 
			
			<p class="comment">tagID :<xsl:value-of select="$tagID"/>/</p>			 
			<p class="comment">tagType : <xsl:value-of select="$tagType"/>/</p> -->
			 
				<xsl:choose>  
					<xsl:when test="$tagType='NAMED-ENTITY'">
					    <xsl:text disable-output-escaping='yes'>&lt;span class="tagNEContent </xsl:text>   
						<xsl:variable name="tagSubType"><xsl:value-of select="/alto:alto/alto:Tags/alto:Tag[@ID=$tagID]/@SUBTYPE"/></xsl:variable>
						<xsl:choose>
							<!-- which kind of NE?  -->
								 <xsl:when test="$tagSubType='Person'"><xsl:text disable-output-escaping='yes'> tagNEPContent"&gt;</xsl:text></xsl:when>
								 <xsl:when test="$tagSubType='Location'"><xsl:text disable-output-escaping='yes'> tagNELContent"&gt;</xsl:text></xsl:when> 
								 <xsl:when test="$tagSubType='Organization'"><xsl:text disable-output-escaping='yes'> tagNEOContent"&gt;</xsl:text></xsl:when>
							     <xsl:otherwise><xsl:text disable-output-escaping='yes'>"&gt;</xsl:text><sup class="tagID">unknown NE subtype:<xsl:value-of select="$tagSubType"/></sup></xsl:otherwise>
						</xsl:choose>
						<xsl:value-of select="$tagContent"/><xsl:text disable-output-escaping='yes'>&lt;/span&gt;</xsl:text>						
						</xsl:when>	 
					<xsl:when test="$tagType='ROLE'"><span class="tagRoleContent"><xsl:value-of select="$tagContent"/></span></xsl:when> 
					<xsl:when test="$tagType='OTHER'"><span class="tagOtherContent"><xsl:value-of select="$tagContent"/></span></xsl:when> 
					<xsl:otherwise><sup class="tagID">unknown ID</sup><span class="tagPBContent"><xsl:value-of select="$tagContent"/></span></xsl:otherwise>
				</xsl:choose>
				<!-- link on tag ID  -->
				<a><xsl:attribute name="href">#<xsl:value-of select="$tagID"/></xsl:attribute>
						<sup class="tagID"><xsl:value-of select="$tagID"/></sup> </a>
			 <!--  </xsl:for-each>	-->		
			</xsl:when>   
			
			<!-- no tag  -->				
			<xsl:otherwise><xsl:value-of select="$tagContent"/></xsl:otherwise>
		</xsl:choose>
  </xsl:template>
	
	
	
	
	<!-- Graphical blocks  -->
<xsl:template match="alto:GraphicalElement">
      <!-- Traitement des types de bloc  -->
      
      <p class="GraphicalElement"><span class="ge">GE</span></p>
  </xsl:template>    
    
<!-- Illustration  -->
<xsl:template match="alto:Illustration">
    
      <p class="Illustration"> Ill </p>
           
  </xsl:template>    
  
 <!-- Composed blocks  -->
<xsl:template match="alto:ComposedBlock">
    <p class="ComposedBlockDebut"><span class="cb">CB {</span></p>
     <xsl:apply-templates />
    <p class="ComposedBlockFin"><span class="cb">} CB</span></p>
           
  </xsl:template>      
       

</xsl:stylesheet>
