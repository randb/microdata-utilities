<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:date="http://exslt.org/dates-and-times"
	extension-element-prefixes="date">
	
	

<!--
	Article - http://schema.org/Article
-->	
	<xsl:template match="entry" mode="article">

		<!-- 
			Pass in a param here for more specific types of articles (e.g. Blog Posting). See: http://www.schema.org/Article
		-->
			<xsl:param name="type" select="'Article'" />
		
		<!-- 
			Pass in a path the full item , e.g. 'blog/read' if displaying on the listing page
			
			Note: The entry @id is used by default as the url-parameter.
		-->
			<xsl:param name="path" select="false()" />
			
			<article itemscope="itemscope" itemtype="http://schema.org/{$type}">
					
				<!-- Some Meta Stuff -->
				<xsl:if test="creation-date">
					<meta itemprop="creationDate" content="{creation-date}" />
				</xsl:if>
				
				<xsl:if test="body">
					<meta itemprop="wordCount" content="{body/@word-count}" />
				</xsl:if>
				
				<xsl:choose>
					<xsl:when test="$path">
						<h1>
							<a href="{$path}{@id}" itemprop="url">
								<span itemprop="headline">
									<xsl:value-of select="headline" />	
								</span>
							</a>	
						</h1>
						
						<!-- Image -->
						<xsl:if test="image">
							<a href="{$path}{@id}" itemprop="url">
								<img itemprop="thumbnail" src="{$workspace}{image/@path}/{image/filename}" alt="{name}" />
							</a>
						</xsl:if>	
					</xsl:when>
					<xsl:otherwise>
						<h1 itemprop="headline">
							<xsl:value-of select="headline" />	
						</h1>
						
						<!-- Image -->
						<xsl:if test="image">
							<img itemprop="image" src="{$workspace}{image/@path}/{image/filename}" alt="{name}" />
						</xsl:if>	
					</xsl:otherwise>
				</xsl:choose>
				
				<!-- Author -->
				<xsl:if test="author">
					<span itemprop="author">
						<xsl:value-of select="author/item" />
					</span>
				</xsl:if>
	
				<!-- Publish Date -->
				<xsl:if test="publish-date">
					<dl class="publish-date">
						<dt>Publish Date</dt>
						<dd itemprop="datePublished">
							<xsl:value-of select="publish-date" />
						</dd>
					</dl>
				</xsl:if>
	
				<!-- Display either short Description or Article body -->
				<xsl:choose>
					<xsl:when test="description !='' and $path">
						<div itemprop="description">
							<xsl:apply-templates select="description/*" mode="output" />
						</div>
					</xsl:when>
					<xsl:when test="body and $path">
						<div itemprop="description">
							<xsl:apply-templates select="substring(body/*, 1, 200)" mode="output" />
						</div>
					</xsl:when>
					<xsl:when test="body and not($path)">
						<div itemprop="articleBody">
							<xsl:apply-templates select="body/*" mode="output" />
						</div>
					</xsl:when>
				</xsl:choose>
	
			</article>

	</xsl:template>
	

<!--
	User Comments - http://schema.org/UserComments
-->	
	<xsl:template match="entry" mode="user-comments">
		<article itemscope="itemscope" itemtype="http://schema.org/UserComments">
			
			<!-- Some Meta Stuff -->
			<meta itemprop="creationDate" content="{related-post/item}" />

			<h3>
				<xsl:text>At: </xsl:text>
				<span itemprop="commentTime">
					<xsl:value-of select="date" />
				</span>
				<xsl:text> </xsl:text>
				<span itemprop="creator">
					<xsl:value-of select="commenter/item" />
				</span>
				<xsl:text> wrote: </xsl:text>
			</h3>
			
			<div itemprop="commentText">
				<xsl:apply-templates select="comment/*" mode="output" />
			</div>
			
		</article>
	</xsl:template>
	
	

<!--
	Job Posting - http://schema.org/JobPosting
-->	
	<xsl:template match="entry" mode="job-posting">
		
		<!-- 
			Pass in a path the full item , e.g. 'jobs/read' if displaying on the listing page
			
			Note: The entry @id is used by default as the url-parameter.
		-->
			<xsl:param name="path" select="false()" />
		
		
			<article itemscope="itemscope" itemtype="http://schema.org/JobPosting">
				<xsl:choose>
					<xsl:when test="$path">
						<h1>
							<a href="{$path}{@id}" itemprop="url">
								<span itemprop="title">
									<xsl:value-of select="title" />	
								</span>
							</a>	
						</h1>
						
						<!-- Image -->
						<xsl:if test="image">
							<a href="{$path}{@id}" itemprop="url">
								<img itemprop="thumbnail" src="{$workspace}{image/@path}/{image/filename}" alt="{name}" />
							</a>
						</xsl:if>	
					</xsl:when>
					<xsl:otherwise>
						<h1 itemprop="title">
							<xsl:value-of select="title" />	
						</h1>
						
						<!-- Image -->
						<xsl:if test="image">
							<img itemprop="image" src="{$workspace}{image/@path}/{image/filename}" alt="{name}" />
						</xsl:if>	
					</xsl:otherwise>
				</xsl:choose>
				
				<!-- Job Location -->
				<xsl:apply-templates select="." mode="place">
					<xsl:with-param name="itemprop" select="'jobLocation'" />
					<xsl:with-param name="display-mode" select="'job'" />
				</xsl:apply-templates>
				
				<!-- Date Posted -->
				<xsl:if test="date">
					<dl class="date">
						<dt>Date Posted</dt>
						<dd itemprop="datePosted">
							<xsl:value-of select="date" />
						</dd>
					</dl>
				</xsl:if>
				
				<!-- Employment Type -->
				<xsl:if test="employment-type">
					<dl class="employment-type">
						<dt>Employment Type</dt>
						<dd itemprop="employmentType">
							<xsl:value-of select="employment-type" />
						</dd>
					</dl>
				</xsl:if>
				
				<!-- Salary -->
				<xsl:if test="salary">
					<dl class="salary">
						<dt>Salary</dt>
						<dd itemprop="baseSalary">
							<xsl:value-of select="salary" />
						</dd>
					</dl>
				</xsl:if>
				
				<!-- Benefits -->
				<xsl:if test="benefits">
					<dl itemprop="benefits" class="benefits">
						<dt>Benefits</dt>
						<xsl:for-each select="benefits/item">
							<dd>
								<xsl:value-of select="." />
							</dd>
						</xsl:for-each>
					</dl>
				</xsl:if>
				
				<!-- Incentives -->
				<xsl:if test="incentives">
					<dl class="incentives">
						<dt>Incentives</dt>
						<dd itemprop="incentives">
							<xsl:value-of select="incentives" />
						</dd>
					</dl>
				</xsl:if>
				
				<!-- Skills -->
				<xsl:if test="skills">
					<dl itemprop="skills" class="skills">
						<dt>Skills</dt>
						<xsl:for-each select="skills/item">
							<dd>
								<xsl:value-of select="." />
							</dd>
						</xsl:for-each>
					</dl>
				</xsl:if>
				
				<!-- Description -->
				<xsl:if test="description">
					<div itemprop="description">
						<xsl:apply-templates select="description" mode="output" />
					</div>
				</xsl:if>
				
				
			</article>
	</xsl:template>


<!--
	Organisation - http://schema.org/Organisation
-->	
	<xsl:template match="entry" mode="organization">

		<!-- 
			Pass in a param here for more specific types of organisations. See: http://www.schema.org/Organization 
		-->
			<xsl:param name="type" select="'Organization'" />
			
		
		<!-- 
			Pass in an itemprop attribute if embedded in another utility.
		-->
			<xsl:param name="itemprop" select="false()" />
			
		
		<!-- 
			Pass in a path the full profile , e.g. 'organisations/profile' if displaying on the listing page
			
			Note: The entry @id is used by default as the url-parameter.
		-->
			<xsl:param name="path" select="false()" />
			
		
			<article itemscope="itemscope" itemtype="http://schema.org/{$type}">

				<!--  Class the generic Thing utility -->
				<xsl:apply-templates select="." mode="thing">
					<xsl:with-param name="path" select="$path" />
				</xsl:apply-templates>
				
				<!-- Description -->
				<xsl:if test="description">
					<div itemprop="description">
						<xsl:apply-templates select="description" mode="output" />
					</div>
				</xsl:if>
				
				<!-- Address -->
				<xsl:apply-templates select="." mode="postal-address" />
				
				<!-- Gender -->
				<xsl:if test="gender/item/@handle != ''">
					<dl class="gender">
						<dt>Gender</dt>
						<dd itemprop="gender">
							<xsl:value-of select="gender/item/@handle" />
						</dd>
					</dl>
				</xsl:if>
				
				<!-- Date of Birth -->
				<xsl:if test="date-of-birth != ''">
					<dl class="date-of-birth">
						<dt>Date of Birth</dt>
						<dd itemprop="birthDate">
							<xsl:value-of select="date-of-birth" />
						</dd>
					</dl>
				</xsl:if>
				
				<!-- Telephone -->
				<xsl:if test="telephone != ''">
					<dl class="telephone">
						<dt>Phone Number</dt>
						<dd itemprop="telephone">
							<xsl:value-of select="telephone" />
						</dd>
					</dl>
				</xsl:if>		
				
				<!-- Fax -->
				<xsl:if test="fax != ''">
					<dl class="fax">
						<dt>Fax</dt>
						<dd itemprop="faxNumber">
							<xsl:value-of select="fax" />
						</dd>
					</dl>
				</xsl:if>	
			
			</article>
	</xsl:template>
	
	
<!--
	Person - http://schema.org/Person 
-->	
	<xsl:template match="entry" mode="person">

		<!-- 
			Pass in a param here for more specific types of persons. See: http://www.schema.org/CreativeWork 
		-->
			<xsl:param name="type" select="'Person'" />
			
		<!-- 
			Pass in an itemprop attribute if embedded in another utility.
		-->
			<xsl:param name="itemprop" select="false()" />
			
			
		<!-- 
			Pass in a path the full profile , e.g. 'artists/profile' if displaying on the listing page
			
			Note: The entry @id is used by default as the url-parameter.
		-->
			<xsl:param name="path" select="false()" />
			
		
			<article itemscope="itemscope" itemtype="http://schema.org/{$type}">
			
				<xsl:if test="$itemprop">
					<xsl:attribute name="itemprop">
						<xsl:value-of select="$itemprop" />
					</xsl:attribute>
				</xsl:if>

				<!--  Class the generic Thing utility -->
				<xsl:apply-templates select="." mode="thing">
					<xsl:with-param name="path" select="$path" />
				</xsl:apply-templates>
				
				<!-- Description -->
				<xsl:if test="description">
					<div itemprop="description">
						<xsl:apply-templates select="description" mode="output" />
					</div>
				</xsl:if>
				
				<!-- Address -->
				<xsl:apply-templates select="." mode="postal-address" />
				
				<!-- Gender -->
				<xsl:if test="gender/item/@handle != ''">
					<dl class="gender">
						<dt>Gender</dt>
						<dd itemprop="gender">
							<xsl:value-of select="gender/item/@handle" />
						</dd>
					</dl>
				</xsl:if>
				
				<!-- Date of Birth -->
				<xsl:if test="date-of-birth != ''">
					<dl class="date-of-birth">
						<dt>Date of Birth</dt>
						<dd itemprop="birthDate">
							<xsl:value-of select="date-of-birth" />
						</dd>
					</dl>
				</xsl:if>
				
				<!-- Telephone -->
				<xsl:if test="telephone != ''">
					<dl class="telephone">
						<dt>Phone Number</dt>
						<dd itemprop="telephone">
							<xsl:value-of select="telephone" />
						</dd>
					</dl>
				</xsl:if>		
				
				<!-- Fax -->
				<xsl:if test="fax != ''">
					<dl class="fax">
						<dt>Fax</dt>
						<dd itemprop="faxNumber">
							<xsl:value-of select="fax" />
						</dd>
					</dl>
				</xsl:if>	
			
			</article>
	</xsl:template>


<!--
	Place - http://www.schema.org/Place
-->	
	<xsl:template match="entry" mode="place">
			
		<!-- 
			Pass in a param here for more specific types of places. See: http://www.schema.org/Place 
		-->
			<xsl:param name="type" select="'Place'" />
			
		<!-- 
			Pass in an itemprop attribute if embedded in another utility.
		-->
			<xsl:param name="itemprop" select="false()" />
			
		<!-- 
			Display Mode - Modify behaviour depending  on what is calling this utility. 
		-->
			<xsl:param name="display-mode" select="'full'" />	
			
		<!-- 
			Map Display - Control how the Google Map link is displayed. 
			
			Options: 
				* map (Map Image)
				* text ('Get Directions')
				* street (Street View Image) 
		-->
			<xsl:param name="map-display" select="'map'" />
			
			<article itemscope="itemscope" itemtype="http://schema.org/{$type}">
				
				<xsl:if test="$itemprop">
					<xsl:attribute name="itemprop">
						<xsl:value-of select="$itemprop" />
					</xsl:attribute>
				</xsl:if>

				<xsl:if test="$display-mode = 'full'">
					<h1 itemprop="name">
						<xsl:value-of select="name" />
					</h1>
					
					<!-- Description -->
					<xsl:if test="description">
						<span itemprop="description">
							<xsl:apply-templates select="description" mode="output" />
						</span>
					</xsl:if>
				</xsl:if>
						
				<!-- Address -->
				<xsl:apply-templates select="." mode="postal-address" />
				
				<!-- URL -->
				<xsl:if test="url != '' and $display-mode = 'full'">
					<dl class="url">
						<dt>Website</dt>
						<dd>
							<a itemprop="url" href="{url}">
								<xsl:value-of select="url" />
							</a>
						</dd>
					</dl>
				</xsl:if>
				
				<!-- Phone -->
				<xsl:if test="phone != ''">
					<dl class="phone">
						<dt>Phone</dt>
						<dd itemprop="telephone">
							<xsl:value-of select="phone" />
						</dd>
					</dl>
				</xsl:if>
				
				<!-- Fax -->
				<xsl:if test="fax != ''">
					<dl class="fax">
						<dt>Fax</dt>
						<dd itemprop="faxNumber">
							<xsl:value-of select="fax" />
						</dd>
					</dl>
				</xsl:if>
				
				<xsl:apply-templates select="." mode="geocoordinates" />
				
				<xsl:apply-templates select="." mode="map">
					<xsl:with-param name="map-display" select="$map-display" />
				</xsl:apply-templates>
	
			</article>
	
	</xsl:template>
	
	
<!--
	Event - http://www.schema.org/Event
-->
	<xsl:template match="entry" mode='event'>
	
	<!-- 
		Pass in a param here for more specific types of events. See: http://www.schema.org/Event
	-->
		<xsl:param name="type" select="'Event'" />
	
	<!-- 
		Pass in a path the full event page , e.g. 'events/read' if displaying on the listing page
		
		Note: The entry @id is used by default as the url-parameter.
	-->
		<xsl:param name="path" select="false()" />
		
	<!-- 
		Display - Control how the Google Map link is displayed.
		Note: This is passed to the Place utility 
		
		Options: 
			* map (Map Image)
			* text ('Get Directions')
			* street ('Street View Image') 
	-->
		<xsl:param name="map-display" select="'text'" />
		
		<article itemscope="itemscope" itemtype="http://schema.org/{$type}">
		
			<meta itemprop="duration" content="{date:difference(concat(start-date, 'T', start-date/@time, ':00'), concat(end-date, 'T', end-date/@time, ':00'))}" />
			<meta itemprop="startDate" content="{concat(start-date, 'T', start-date/@time, ':00')}" />
			<meta itemprop="endDate" content="{concat(end-date, 'T', end-date/@time, ':00')}" />
			
			
			<header>
			
				<!--  Class the generic Thing utility -->
				<xsl:apply-templates select="." mode="thing">
					<xsl:with-param name="path" select="$path" />
				</xsl:apply-templates>
		
				<!-- Date/Times -->
				<dl>	
					<dt>Start date:</dt>
					<dd>
						<time datetime="{concat(start-date, 'T', start-date/@time, ':00')}">
							<xsl:value-of select="start-date" />
						</time>
					</dd>
					
					<xsl:if test="end-date != ''">
						<dt>End date:</dt>
						<dd>
							<time datetime="{concat(end-date, 'T', end-date/@time, ':00')}">
								<xsl:value-of select="end-date" />
							</time>
						</dd>
					</xsl:if>
				</dl>
			</header>
			
			<!-- Description -->
			<xsl:if test="description">
				<div itemprop="description">
					<xsl:apply-templates select="description" mode="output" />
				</div>
			</xsl:if>
			
			<!-- Call the Place utility -->
			<xsl:apply-templates select="." mode="place">	
				<xsl:with-param name="display-mode" select="'event'" />
				<xsl:with-param name="map-display" select="$map-display" />
			</xsl:apply-templates>
			
			<!-- Price -->
			<xsl:if test="price !=''">
				<dl class="price">
					<dt>Price</dt>
					<dd itemprop="offer">
						<xsl:value-of select="price" />	
					</dd>
				</dl>
			</xsl:if>
			
		</article>
		
	</xsl:template>


<!-- 
	Thing -  http://www.schema.org/Thing
-->
	<xsl:template match="entry" mode="thing">
		<xsl:param name="path" selected="false" />
		<xsl:choose>
			<xsl:when test="$path">
				<h1>
					<a href="{$path}{@id}" itemprop="url">
						<span itemprop="name">
							<xsl:value-of select="name" />	
						</span>
					</a>	
				</h1>
				
				<!-- Image -->
				<xsl:if test="image">
					<a href="{$path}{@id}" itemprop="url">
						<img itemprop="image" src="{$workspace}{image/@path}/{image/filename}" alt="{name}" />
					</a>
				</xsl:if>	
			</xsl:when>
			<xsl:otherwise>
				<h1 itemprop="name">
					<xsl:value-of select="name" />	
				</h1>
				
				<!-- Image -->
				<xsl:if test="image">
					<img itemprop="image" src="{$workspace}{image/@path}/{image/filename}" alt="{name}" />
				</xsl:if>	
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
<!--
	Maps - http://www.schema.org/Place
-->		
	<xsl:template match="entry" mode="map">
			
		<xsl:param name="map-display" />
		
		<xsl:if test="map-location">
			<a itemprop="maps" href="http://maps.google.com/maps?q={map-location/map/@centre}+&amp;ie=UTF8" rel="external">
				<xsl:choose>
					<xsl:when test="$map-display = 'street'">
						<img itemprop="image" src="http://cbk0.google.com/cbk?output=thumbnail&amp;cb_client=maps_sv&amp;thumb=2&amp;thumbfov=60&amp;ll={map-location/@latitude},{map-location/@longitude}&amp;cbll={map-location/@latitude},{map-location/@longitude}&amp;thumbpegman=1&amp;w=100&amp;h=100" />
					</xsl:when>
					<xsl:when test="$map-display = 'map'">
						<img src="http://maps.google.com/maps/api/staticmap?center={map-location/map/@centre}&amp;markers=color:green|label:P|size:small|{map-location/map/@centre}&amp;zoom=15&amp;size=380x220&amp;sensor=false" alt="{name} Location" /> 
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>Get Directions</xsl:text>
					</xsl:otherwise>
				</xsl:choose> 	
			</a>
		</xsl:if>

	</xsl:template>		

<!--
	GeoCoordinates - http://www.schema.org/GeoCoordinates
-->		
	<xsl:template match="entry" mode="geocoordinates">
		<xsl:if test="map-location">
			<div itemprop="geo" itemscope="itemscope" itemtype="http://schema.org/GeoCoordinates">
			    <meta itemprop="latitude" content="{map-location/@latitude}" />
			    <meta itemprop="longitude" content="{map-location/@longitude}" />
			 </div>
		</xsl:if>
	</xsl:template>	
	
<!--
	Postal Address
-->
	<xsl:template match="entry" mode='postal-address'>
		
		<dl itemprop="address" itemscope="itemscope" itemtype="http://schema.org/PostalAddress">
		
			<!-- Post Box Number -->
			<xsl:if test="post-office-box != ''">
				<dt class="post-office-box">PO Box</dt>
				<dd itemprop="postOfficeBoxNumber">
					<xsl:value-of select="post-office-box" />
				</dd>
			</xsl:if>
	
			<!-- Street Address -->
			<xsl:if test="street-address != ''">
				<dt class="street-address">Street Address</dt>
				
				<dd itemprop="streetAddress" class="street-address">
					<xsl:value-of select="street-address" />
				</dd>
			</xsl:if>
			
			<!-- Suburb -->
			<xsl:if test="suburb != ''">
				<dt class="suburb">Suburb</dt>
	
				<dd itemprop="addressLocality" class="suburb">
					<xsl:value-of select="suburb" />
				</dd>
			</xsl:if>
			
			<!-- Region -->
			<xsl:if test="region != ''">
				<dt class="region">Region</dt>
				
				<dd itemprop="addressRegion">
					<xsl:value-of select="region" />
				</dd>
			</xsl:if>
			
			<!-- Postcode -->
			<xsl:if test="postcode != ''">
				<dt class="postcode">Postcode</dt>
			
				<dd itemprop="postalCode" class="postcode">
					<xsl:value-of select="postcode" />
				</dd>
			</xsl:if>

			<!-- Country -->
			<xsl:if test="country != ''">
				<dt class="country">Country</dt>
				
				<dd itemprop="addressCountry" class="country">
					<xsl:value-of select='country' />
				</dd>
			</xsl:if>
			
		</dl>

	</xsl:template>
	

</xsl:stylesheet>