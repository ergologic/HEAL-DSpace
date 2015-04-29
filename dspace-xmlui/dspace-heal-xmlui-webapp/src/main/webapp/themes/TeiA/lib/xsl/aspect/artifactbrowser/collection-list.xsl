<!--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

-->
<!--
    Rendering of a list of collections (e.g. on a community homepage,
    or on the community-list page)

    Author: art.lowel at atmire.com
    Author: lieven.droogmans at atmire.com
    Author: ben at atmire.com
    Author: Alexey Maslov

-->

<xsl:stylesheet
        xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
        xmlns:dri="http://di.tamu.edu/DRI/1.0/"
        xmlns:mets="http://www.loc.gov/METS/"
        xmlns:dim="http://www.dspace.org/xmlns/dspace/dim"
        xmlns:xlink="http://www.w3.org/TR/xlink/"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
        xmlns:atom="http://www.w3.org/2005/Atom"
        xmlns:ore="http://www.openarchives.org/ore/terms/"
        xmlns:oreatom="http://www.openarchives.org/ore/atom/"
        xmlns="http://www.w3.org/1999/xhtml"
        xmlns:xalan="http://xml.apache.org/xalan"
        xmlns:encoder="xalan://java.net.URLEncoder"
        xmlns:util="org.dspace.app.xmlui.utils.XSLUtils"
        xmlns:confman="org.dspace.core.ConfigurationManager"
        exclude-result-prefixes="xalan encoder i18n dri mets dim xlink xsl util confman">

    <xsl:output indent="yes"/>

    <!-- A collection rendered in the summaryList pattern. Encountered on the community-list page -->
    <xsl:template name="collectionSummaryList-DIM">
        <xsl:variable name="data" select="./mets:dmdSec/mets:mdWrap/mets:xmlData/dim:dim"/>
        <div class="artifact-description ">
            <div class="artifact-title">
                <a href="{@OBJID}">
                    <i class="glyphicon glyphicon-folder-open">&#x00AD;</i>
                    <span class="Z3988">
                        <i18n:choose>
                            <i18n:when locale="el">
                                <xsl:choose>
                                    <xsl:when test="string-length($data/dim:field[@element='title'][1]) &gt; 0">
                                        <xsl:value-of select="$data/dim:field[@element='title'][1]"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </i18n:when>
                            <i18n:otherwise>
                                <xsl:choose>
                                    <xsl:when test="string-length($data/dim:field[@element='rights'][1]) &gt; 0">
                                        <xsl:value-of select="$data/dim:field[@element='rights'][1]"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="$data/dim:field[@element='title'][1]"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </i18n:otherwise>
                        </i18n:choose>
                    </span>
                </a>
                <!--Display community strengths (item counts) if they exist-->
                <xsl:if test="number($data/dim:field[@element='format'][@qualifier='extent'][1]) &gt; 0">
                    <span class="badge badge-strength">
                        <xsl:value-of select="$data/dim:field[@element='format'][@qualifier='extent'][1]"/>
                    </span>
                </xsl:if>
            </div>
            <xsl:variable name="abstract" select="$data/dim:field[@element = 'description' and @qualifier='abstract']/node()"/>
            <xsl:if test="$abstract and string-length($abstract[1]) &gt; 0">
                <div class="artifact-info">
                    <span class="short-description">
                        <xsl:value-of select="util:shortenString($abstract, 220, 10)"/>
                    </span>
                </div>
            </xsl:if>
        </div>
    </xsl:template>

    <!-- A collection rendered in the detailList pattern. Encountered on the item view page as
        the "this item is part of these collections" list -->
    <xsl:template name="collectionDetailList-DIM">
        <xsl:variable name="data" select="./mets:dmdSec/mets:mdWrap/mets:xmlData/dim:dim"/>
        <xsl:attribute name="class">ds-artifact-item list-group-item collection</xsl:attribute>
        <div class="artifact-description">
            <div class="artifact-title">
                <a href="{@OBJID}">
                    <i18n:choose>
                        <i18n:when locale="el">
                            <xsl:choose>
                                <xsl:when test="string-length($data/dim:field[@element='title'][1]) &gt; 0">
                                    <i class="glyphicon glyphicon-folder-open">&#x00AD;</i>
                                    <span>
                                        <xsl:value-of select="$data/dim:field[@element='title'][1]"/>
                                    </span>
                                </xsl:when>
                                <xsl:otherwise>
                                    <i18n:text>xmlui.dri2xhtml.METS-1.0.no-title</i18n:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </i18n:when>
                        <i18n:otherwise>
                            <xsl:choose>
                                <xsl:when test="string-length($data/dim:field[@element='rights'][1]) &gt; 0">
                                    <i class="glyphicon glyphicon-folder-open">&#x00AD;</i>
                                    <span>
                                        <xsl:value-of select="$data/dim:field[@element='rights'][1]"/>
                                    </span>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$data/dim:field[@element='title'][1]"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </i18n:otherwise>
                    </i18n:choose>

                </a>
                <!--Display collection strengths (item counts) if they exist-->
                <!--<xsl:if test="number($data/dim:field[@element='format'][@qualifier='extent'][1]) &gt; 0">-->
                <!--<span class="badge badge-strength">-->
                <!--<xsl:value-of select="$data/dim:field[@element='format'][@qualifier='extent'][1]"/>-->
                <!--</span>-->
                <!--</xsl:if>-->
            </div>

            <xsl:choose>
                <xsl:when test="$data/dim:field[@element='description' and @qualifier='abstract']">
                    <div class="artifact-info">
                        <span class="short-description">
                            <xsl:copy-of select="$data/dim:field[@element='description' and @qualifier='abstract']/node()"/>
                        </span>
                    </div>
                </xsl:when>
                <xsl:otherwise>
                    <div class="artifact-info">
                        <span class="short-description">
                            <xsl:copy-of select="$data/dim:field[@element='description'][1]/node()"/>
                        </span>
                    </div>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>

</xsl:stylesheet>