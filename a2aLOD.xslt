<?xml version="1.0" encoding="UTF-8"?>
<!-- a2aLOD -->
<!-- CC0 Ivo Zandhuis (https://ivozandhuis.nl) -->
<!-- 20190612 -->

<xsl:stylesheet version="1.0"
  xmlns:ns1="http://Mindbus.nl/RecordCollectionA2A"  
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:a2a="http://Mindbus.nl/A2A"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
  xmlns:edm="http://www.europeana.eu/schemas/edm/"
  xmlns:schema="http://schema.org/"
  xmlns:pnv="https://w3id.org/pnv#"
  xmlns:sdmx="http://purl.org/linked-data/sdmx/2009/dimension#"
  xmlns:foaf="http://xmlns.com/foaf/0.1/"
  xmlns:sem="http://semanticweb.cs.vu.nl/2009/11/sem/"
  xmlns:skos="http://www.w3.org/2004/02/skos/core#"
  xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema#"
  xmlns:hg="http://rdf.histograph.io/"
  xmlns:geo="http://www.opengis.net/ont/geosparql#"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:dct="http://purl.org/dc/terms/"
  xmlns:aat="http://vocab.getty.edu/aat/"
  xmlns:gn="http://sws.geonames.org/"
  xmlns:hisco="https://iisg.amsterdam/hisco/code/hisco/"
  xmlns:bio="http://purl.org/vocab/bio/0.1/"
  xmlns:roar="http://hicsuntleones.nl/vocab/roar/0.1/"
  xmlns:dbo="http://dbpedia.org/ontology/"

  exclude-result-prefixes="ns1"

  >

  <xsl:output method="xml" indent="yes" encoding="UTF-8"/>

  <xsl:strip-space elements="*"/>

  <xsl:template match="@*|node()">
      <xsl:copy>
          <xsl:apply-templates select="@*|node()"/>
      </xsl:copy>
  </xsl:template>

  <xsl:template match="*[not(node())]"/>

  <!-- basic structure -->
  <xsl:template match="/">
    <xsl:apply-templates select="ns1:A2ACollection"/>
  </xsl:template>

  <xsl:template match="ns1:A2ACollection">
    <xsl:element name="rdf:RDF">
      <xsl:apply-templates select="a2a:A2A"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="a2a:A2A">
      <xsl:variable name="GUID" select="substring(a2a:Source/a2a:RecordGUID, 2, 36)"/>
      <xsl:variable name="bride" select="a2a:RelationEP[a2a:RelationType='Bruid']/a2a:PersonKeyRef"/>
      <xsl:variable name="groom" select="a2a:RelationEP[a2a:RelationType='Bruidegom']/a2a:PersonKeyRef"/>
      <xsl:apply-templates select="a2a:Person">
        <xsl:with-param name="GUID" select="$GUID"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="a2a:Event">
        <xsl:with-param name="GUID" select="$GUID"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="a2a:Source">
        <xsl:with-param name="GUID" select="$GUID"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="a2a:RelationEP">
        <xsl:with-param name="GUID" select="$GUID"/>
        <xsl:with-param name="bride" select="$bride"/>
        <xsl:with-param name="groom" select="$groom"/>
      </xsl:apply-templates>
  </xsl:template>

<!-- Person and subelements -->
  <xsl:template match="a2a:Person">
    <xsl:param name="GUID"/>
    <xsl:element name="rdf:Description">
      <xsl:attribute name="rdf:about">
        <xsl:text>urn:</xsl:text>
        <xsl:value-of select="$GUID"/>
        <xsl:text>#</xsl:text>
        <xsl:value-of select="@pid"/>
      </xsl:attribute>
      <xsl:element name="roar:documentedIn">
        <xsl:attribute name="rdf:resource">
          <xsl:text>urn:</xsl:text>
          <xsl:value-of select="$GUID"/>
        </xsl:attribute>
      </xsl:element>
      <!--xsl:apply-templates select="a2a:PersonName"/-->
      <xsl:apply-templates />
    </xsl:element>
  </xsl:template>

  <xsl:template match="a2a:PersonName">
    <xsl:element name="pnv:hasName">
      <xsl:element name="rdf:Description">
        <xsl:apply-templates/>
      </xsl:element>
    </xsl:element>
  </xsl:template>

  <xsl:template match="a2a:PersonNameFirstName">
    <xsl:element name="pnv:givenName">
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="a2a:PersonNamePatronym">
    <xsl:element name="pnv:patronym">
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="a2a:PersonNamePrefixLastName">
    <xsl:element name="pnv:surnamePrefix">
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="a2a:PersonNameLastName">
    <xsl:element name="pnv:baseSurname">
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="a2a:Residence"/>

  <xsl:template match="a2a:Age[a2a:PersonAgeLiteral != '']">
    <xsl:element name="schema:age">
      <xsl:value-of select="a2a:PersonAgeLiteral"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="a2a:BirthPlace[a2a:Place != '']">
    <xsl:element name="schema:birthPlace">
      <xsl:apply-templates />
    </xsl:element>
  </xsl:template>

  <xsl:template match="a2a:BirthDate[a2a:Year != '']">
    <xsl:element name="schema:birthDate">
      <xsl:attribute name="rdf:datatype">
        <xsl:text>http://www.w3.org/2001/XMLSchema#date</xsl:text>
      </xsl:attribute>
      <xsl:apply-templates />
    </xsl:element>
  </xsl:template>

  <xsl:template match="a2a:Year">
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="a2a:Month">
    <xsl:text>-</xsl:text>
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="a2a:Day">
    <xsl:text>-</xsl:text>
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:template match="a2a:Place ">
    <xsl:value-of select="."/>
  </xsl:template>

<!-- Relations (creates extra statements for the Person) -->
  <xsl:template match="a2a:RelationEP">
    <xsl:param name="GUID"/>
    <xsl:param name="bride"/>
    <xsl:param name="groom"/>
    <xsl:element name="rdf:Description">
      <xsl:attribute name="rdf:about">
        <xsl:text>urn:</xsl:text>
        <xsl:value-of select="$GUID"/>
        <xsl:text>#</xsl:text>
        <xsl:value-of select="a2a:PersonKeyRef"/>
      </xsl:attribute>
      <xsl:element name="roar:role">
        <xsl:attribute name="rdf:datatype">
          <xsl:text>http://www.w3.org/2001/XMLSchema#string</xsl:text>
        </xsl:attribute>
        <xsl:value-of select="a2a:RelationType"/>
      </xsl:element>
      <xsl:element name="schema:gender">
        <xsl:attribute name="rdf:resource">
          <xsl:choose>
            <xsl:when test="a2a:RelationType='Bruidegom'">http://schema.org/Male</xsl:when>
            <xsl:when test="a2a:RelationType='Vader van de bruidegom'">http://schema.org/Male</xsl:when>
            <xsl:when test="a2a:RelationType='Vader van de bruid'">http://schema.org/Male</xsl:when>
            <xsl:when test="a2a:RelationType='Bruid'">http://schema.org/Female</xsl:when>
            <xsl:when test="a2a:RelationType='Moeder van de bruidegom'">http://schema.org/Female</xsl:when>
            <xsl:when test="a2a:RelationType='Moeder van de bruid'">http://schema.org/Female</xsl:when>
            <xsl:otherwise>error</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </xsl:element>
      <xsl:choose>
        <xsl:when test="a2a:RelationType='Vader van de bruidegom'">
          <xsl:element name="schema:parent">
            <xsl:attribute name="rdf:resource">
              <xsl:text>urn:</xsl:text>
              <xsl:value-of select="$GUID"/>
              <xsl:text>#</xsl:text>
              <xsl:value-of select="$groom"/>
            </xsl:attribute>
          </xsl:element>
        </xsl:when>
        <xsl:when test="a2a:RelationType='Moeder van de bruidegom'">
          <xsl:element name="schema:parent">
            <xsl:attribute name="rdf:resource">
              <xsl:text>urn:</xsl:text>
              <xsl:value-of select="$GUID"/>
              <xsl:text>#</xsl:text>
              <xsl:value-of select="$groom"/>
            </xsl:attribute>
          </xsl:element>
        </xsl:when>
        <xsl:when test="a2a:RelationType='Vader van de bruid'">
          <xsl:element name="schema:parent">
            <xsl:attribute name="rdf:resource">
              <xsl:text>urn:</xsl:text>
              <xsl:value-of select="$GUID"/>
              <xsl:text>#</xsl:text>
              <xsl:value-of select="$bride"/>
            </xsl:attribute>
          </xsl:element>
        </xsl:when>
        <xsl:when test="a2a:RelationType='Moeder van de bruid'">
          <xsl:element name="schema:parent">
            <xsl:attribute name="rdf:resource">
              <xsl:text>urn:</xsl:text>
              <xsl:value-of select="$GUID"/>
              <xsl:text>#</xsl:text>
              <xsl:value-of select="$bride"/>
            </xsl:attribute>
          </xsl:element>
        </xsl:when>
        <xsl:when test="a2a:RelationType='Bruid'">
          <xsl:element name="schema:spouse">
            <xsl:attribute name="rdf:resource">
              <xsl:text>urn:</xsl:text>
              <xsl:value-of select="$GUID"/>
              <xsl:text>#</xsl:text>
              <xsl:value-of select="$groom"/>
            </xsl:attribute>
          </xsl:element>
        </xsl:when>
        <xsl:when test="a2a:RelationType='Bruidegom'">
          <xsl:element name="schema:spouse">
            <xsl:attribute name="rdf:resource">
              <xsl:text>urn:</xsl:text>
              <xsl:value-of select="$GUID"/>
              <xsl:text>#</xsl:text>
              <xsl:value-of select="$bride"/>
            </xsl:attribute>
          </xsl:element>
        </xsl:when>
      </xsl:choose>
    </xsl:element>
  </xsl:template>

<!-- Event and sub-elements -->
  <xsl:template match="a2a:Event">
    <xsl:param name="GUID"/>
    <xsl:element name="rdf:Description">
      <xsl:attribute name="rdf:about">
        <xsl:text>urn:</xsl:text>
        <xsl:value-of select="$GUID"/>
        <xsl:text>#</xsl:text>
        <xsl:value-of select="@eid"/>
      </xsl:attribute>
      <xsl:element name="roar:documentedIn">
        <xsl:attribute name="rdf:resource">
          <xsl:text>urn:</xsl:text>
          <xsl:value-of select="$GUID"/>
        </xsl:attribute>
      </xsl:element>
      <xsl:apply-templates select="a2a:EventType"/>
      <xsl:apply-templates select="a2a:EventDate"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="a2a:EventType">
    <xsl:element name="rdf:type">
      <xsl:attribute name="rdf:resource">
        <xsl:choose>
          <xsl:when test="'Huwelijk'">http://purl.org/vocab/bio/0.1/Marriage</xsl:when>
          <xsl:otherwise>error</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
    </xsl:element>
  </xsl:template>

  <xsl:template match="a2a:EventDate">
    <xsl:element name="schema:date">
      <xsl:attribute name="rdf:datatype">
        <xsl:text>http://www.w3.org/2001/XMLSchema#date</xsl:text>
      </xsl:attribute>
      <xsl:value-of select="a2a:Year"/>
      <xsl:text>-</xsl:text>
      <xsl:value-of select="a2a:Month"/>
      <xsl:text>-</xsl:text>
      <xsl:value-of select="a2a:Day"/>
    </xsl:element>
  </xsl:template>

<!-- Source and sub elements -->
  <xsl:template match="a2a:Source">
    <xsl:param name="GUID"/>
    <xsl:element name="rdf:Description">
      <xsl:attribute name="rdf:about">
        <xsl:text>urn:</xsl:text>
        <xsl:value-of select="$GUID"/>
      </xsl:attribute>
      <xsl:apply-templates select="a2a:SourceReference"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="a2a:SourceReference">
    <xsl:element name="a2a:institutionName">
      <xsl:attribute name="rdf:datatype">
        <xsl:text>http://www.w3.org/2001/XMLSchema#string</xsl:text>
      </xsl:attribute>
      <xsl:value-of select="a2a:InstitutionName"/>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>