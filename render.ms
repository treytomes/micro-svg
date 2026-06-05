import "mathUtil"
import "qa"

import "customGfx"
import "svgColor"
import "xml"

removeEmptyEntries = function(arr)
	newArr = []
	for itm in arr
		ln = len(itm)
		if ln == null or ln == 0 then continue
		newArr.push itm
	end for
	return newArr
end function

splitEntries = function(text, splitArr)
	entries = text.split(splitArr[0])
	splitArr = splitArr[1:]

	while len(splitArr) > 0
		newEntries = []
		for item in entries
			newEntries += item.split(splitArr[0])
		end for
		splitArr = splitArr[1:]
		entries = newEntries
	end while

	return removeEmptyEntries(entries)
end function

Axis = {
	"horizontal": 0,
	"vertical": 1,
	"diagonal": 2,
}

PercentValue = {}

PercentValue.make = function(value)
	self = new self
	self.value = value
	return self
end function

PercentValue.resolve = function(svgRoot, axis)
	if axis == Axis.horizontal then return self.value * svgRoot.viewBox.width
	if axis == Axis.vertical then return self.value * svgRoot.viewBox.height
	return self.value * svgRoot.viewBox.normalizedDiagonal
end function

parseValue = function(valueText)
	if valueText == null or valueText == "none" or len(valueText) == 0 then return 0

	// A percentage will be parsed simply as a value between 0 and 1.
	// This may come back to bite me later.
	if valueText.endsWith("%") then return PercentValue.make(val(valueText[:-1]) / 100)

	return val(valueText)
end function

parseStrokeDashArray = function(strokeDashArray)
	if strokeDashArray == null or strokeDashArray == "none" then return null

	strokeDashArray = splitEntries(strokeDashArray, [" ", ","])
	
	n = 0
	while n < len(strokeDashArray)
		strokeDashArray[n] = parseValue(strokeDashArray[n])
		n += 1
	end while
	return strokeDashArray
end function

parseColor = function(colorText)
	if colorText == null or colorText == "none" or len(colorText) == 0 then return color.black
	return svgColor.parseSvgColor(colorText)
end function

SvgRect = {}

SvgRect.make = function(rectElem)
    self = new self

    // Parse attributes.
    self.x = parseValue(rectElem.attributes.get("x"))
    self.y = parseValue(rectElem.attributes.get("y"))
    self.width = parseValue(rectElem.attributes.get("width"))
    self.height = parseValue(rectElem.attributes.get("height"))
    self.fillColor = parseColor(rectElem.attributes.get("fill"))
    self.strokeWidth = parseValue(rectElem.attributes.get("stroke-width"))
    self.strokeColor = parseColor(rectElem.attributes.get("stroke"))

    return self
end function

SvgRect.render = function(svgRoot)
    pd = svgRoot.display

	// If width or height are percentages, expand them out.
	width = self.width
	if width isa PercentValue then width = width.resolve(svgRoot, Axis.horizontal)

	height = self.height
	if height isa PercentValue then height = height.resolve(svgRoot, Axis.vertical)

    // Draw the filled rectangle.
    if self.fillColor != color.clear then
        pd.fillRect(self.x, self.y, width, height, self.fillColor)
    end if

    // Draw the stroke (outline).
    if self.strokeWidth > 0 and self.strokeColor != color.clear then
        pd.drawRect(self.x, self.y, width, height, self.strokeColor, self.strokeWidth)
    end if
end function

SvgLine = {}

SvgLine.make = function(lineElem)
	self = new self

	self.x1 = parseValue(lineElem.attributes.x1)
	self.y1 = parseValue(lineElem.attributes.y1)
	self.x2 = parseValue(lineElem.attributes.x2)
	self.y2 = parseValue(lineElem.attributes.y2)
	
	self.pathLength = parseValue(lineElem.attributes.get("pathLength"))
	self.strokeDashArray = parseStrokeDashArray(lineElem.attributes.get("stroke-dasharray"))
	self.strokeWidth = parseValue(lineElem.attributes.get("stroke-width"))
	self.strokeColor = parseColor(lineElem.attributes.get("stroke"))
	return self
end function

SvgLine.render = function(svgRoot)
    pd = svgRoot.display
    dx = self.x2 - self.x1
    dy = self.y2 - self.y1
    actualLength = sqrt(dx * dx + dy * dy)

    // Default pathLength to the line's actual length.
    if self.pathLength == 0 then self.pathLength = actualLength

    // If no dash pattern, draw the full line.
    if self.strokeDashArray == null or len(self.strokeDashArray) == 0 then
        pd.line(self.x1, self.y1, self.x2, self.y2, self.strokeColor, self.strokeWidth)
        return
    end if

    // Calculate the scaling factor.
    scalingFactor = actualLength / self.pathLength
    // Scale the dash pattern.
    scaledDashArray = []
    for dash in self.strokeDashArray
        scaledDashArray.push(dash * scalingFactor)
    end for

    // Calculate the direction vector (normalized).
    if actualLength > 0 then
        dirX = dx / actualLength
        dirY = dy / actualLength
    else
        dirX = 0
        dirY = 0
        return  // No line to draw.
    end if

    // Draw dashes along the line.
    distance = 0
    dashIndex = 0
    while distance < actualLength
        dashLength = scaledDashArray[dashIndex % len(scaledDashArray)]
        // Clamp to the remaining line length, with a minimum of 1 pixel.
        dashLength = mathUtil.max(mathUtil.min(dashLength, actualLength - distance), 1)

        if dashIndex % 2 == 0 then  // Even indices = dashes (visible).
            // Calculate dash start and end points (rounded to nearest pixel).
            dashStartX = floor(self.x1 + dirX * distance + 0.5)
            dashStartY = floor(self.y1 + dirY * distance + 0.5)
            dashEndX = floor(self.x1 + dirX * (distance + dashLength) + 0.5)
            dashEndY = floor(self.y1 + dirY * (distance + dashLength) + 0.5)
            pd.line(dashStartX, dashStartY, dashEndX, dashEndY, self.strokeColor, self.strokeWidth)
        end if

        distance += dashLength
        dashIndex += 1
    end while
end function

SvgCircle = {}

SvgCircle.make = function(circleElem)
	self = new self
	self.cx = parseValue(circleElem.attributes.cx)
	self.cy = parseValue(circleElem.attributes.cy)
	self.r = parseValue(circleElem.attributes.r)

	self.fillColor = parseColor(circleElem.attributes.get("fill"))
	self.pathLength = parseValue(circleElem.attributes.get("pathLength"))
	self.strokeDashArray = parseStrokeDashArray(circleElem.attributes.get("stroke-dasharray"))
	self.strokeWidth = parseValue(circleElem.attributes.get("stroke-width"))
	self.strokeColor = parseColor(circleElem.attributes.get("stroke"))
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

GfxViewBox.getNormalizedDiagonal = function
	return sqrt(self.width * self.width + self.height * self.height) / sqrt(2)
end function

SvgViewBox = new GfxViewBox

SvgViewBox.make = function(viewBoxText)
	self = new self
	pieces = viewBoxText.split(" ")
	pieces = removeEmptyEntries(pieces)
	qa.assert len(pieces) == 4, "Expected 4 items in the viewBox definition: `{0}`, found `{1}`".fill([ viewBoxText, pieces ])

	self.minX = parseValue(pieces[0])
	self.minY = parseValue(pieces[1])
	self.width = parseValue(pieces[2])
	self.height = parseValue(pieces[3])
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
		else if item.name == "line" then
			self.children.push SvgLine.make(item)
		else if item.name == "rect" then
            self.children.push SvgRect.make(item)
		else
			qa.assert false, "Unknown element type: {0}".fill([ ])
		end if
	end for

	self.display = new PixelDisplay
	self.display.clear self.backgroundColor, self.viewBox.width, self.viewBox.height

	return self
end function

Svg.getImage = function
	img = self.display.getImage(0, 0, self.viewBox.width, self.viewBox.height)
	img.flip true
	return img
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
// fileText = file.readLines("demo/doubleCircle.svg").join("")
fileText = file.readLines("demo/starryConstellation.svg").join("")
svgElem = xml.parseXml(fileText)
// pprint svgElem

root = Svg.make(svgElem)

gfx.clear
root.render gfx, 50, 50, 512, 512
