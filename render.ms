import "qa"
import "xml"

import "svgColor"
import "customGfx"

removeEmptyEntries = function(arr)
	newArr = []
	for itm in arr
		ln = len(itm)
		if ln == null or ln == 0 then continue
		newArr.push itm
	end for
	return newArr
end function

SvgCircle = {}

SvgCircle.make = function(circleElem)
	self = new self
	self.cx = val(circleElem.attributes.cx)
	self.cy = val(circleElem.attributes.cy)
	self.r = val(circleElem.attributes.r)

	self.pathLength = circleElem.attributes.get("pathLength")
	if self.pathLength == null or self.pathLength == "none" then
		self.pathLength = null
	else
		self.pathLength = val(self.pathLength)
	end if

	self.strokeDashArray = circleElem.attributes.get("stroke-dasharray")
	if self.strokeDashArray == null or self.strokeDashArray == "none" then
		self.strokeDashArray = null
	else
		self.strokeDashArray = removeEmptyEntries(self.strokeDashArray.split(" "))
		n = 0
		while n < len(self.strokeDashArray)
			self.strokeDashArray[n] = val(self.strokeDashArray[n])
			n += 1
		end while
	end if

	self.strokeWidth = circleElem.attributes.get("stroke-width")
	if self.strokeWidth == null or self.strokeWidth == "none" then
		self.strokeWidth = 0
	else
		self.strokeWidth = val(self.strokeWidth)
	end if

	self.fillColor = circleElem.attributes.get("fill")
	if self.fillColor == null or self.fillColor == "none" then
		self.fillColor = color.black
	else
		self.fillColor = svgColor.parseSvgColor(self.fillColor)
	end if
	
	self.strokeColor = circleElem.attributes.get("stroke")
	if self.strokeColor == null or self.strokeColor == "none" then
		self.strokeColor = color.black
	else
		self.strokeColor = svgColor.parseSvgColor(self.strokeColor)
	end if
	return self
end function

SvgCircle.render = function(svgRoot)
	offsetX = svgRoot.viewBox.minX
	offsetY = svgRoot.viewBox.minY
	
	left = self.cx - self.r
	bottom = self.cy - self.r
	width = self.r * 2
	height = self.r * 2

	customGfx.renderFilledCircle svgRoot.display, self.cx, self.cy, self.r, self.fillColor
	customGfx.renderCircle svgRoot.display, self.cx, self.cy, self.r, self.strokeColor, self.strokeWidth, self.strokeDashArray, self.pathLength
end function

GfxViewBox = {}

GfxViewBox.make = function
	self = new self
	self.minX = 0
	self.minY = 0
	self.width = gfx.width
	self.height = gfx.height
	return self
end function

SvgViewBox = new GfxViewBox

SvgViewBox.make = function(viewBoxText)
	self = new self
	pieces = viewBoxText.split(" ")
	pieces = removeEmptyEntries(pieces)
	qa.assert len(pieces) == 4, "Expected 4 items in the viewBox definition: `{0}`, found `{1}`".fill([ viewBoxText, pieces ])

	self.minX = val(pieces[0])
	self.minY = val(pieces[1])
	self.width = val(pieces[2])
	self.height = val(pieces[3])
	return self
end function

Svg = {}

Svg.make = function(svgElem)
	self = new self
	self.backgroundColor = color.white
	
	// Not an SVG property (that I know of), but gets applied by the Mini Micro at render time.
	self.tint = color.white

	viewBox = svgElem.attributes.get("viewBox")
	if viewBox != null then
		self.viewBox = SvgViewBox.make(viewBox)
	else
		self.viewBox = GfxViewBox.make
	end if

	self.children = []
	contents = svgElem.contents
	for item in contents
		if item.name == "circle" then
			self.children.push SvgCircle.make(item)
		else
			qa.assert false, "Unknown element type: {0}".fill([ ])
		end if
	end for

	self.display = new PixelDisplay
	self.display.clear self.backgroundColor, self.viewBox.width, self.viewBox.height

	return self
end function

Svg.getImage = function
	return self.display.getImage(0, 0, self.viewBox.width, self.viewBox.height)
end function

Svg.render = function(pd, x = 0, y = 0, width = -1, height = -1)
	self.display.clear self.backgroundColor, self.viewBox.width, self.viewBox.height

	for item in self.children
		item.render self
	end for

	img = root.getImage
	if width == -1 then width = pd.width
	if height == -1 then height = pd.height
	pd.drawImage img, x, y, width, height, 0, 0, img.width, img.height, self.tint
end function

// fileText = file.readLines("demo/circle.svg").join("")
fileText = file.readLines("demo/doubleCircle.svg").join("")
svgElem = xml.parseXml(fileText)
// pprint svgElem

root = Svg.make(svgElem)

gfx.clear
root.render gfx, 50, 50, 512, 512
