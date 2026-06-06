import "events"
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

lerp = function(sourceValue, targetValue, lerpWeight)
	if lerpWeight < 0 then
		lerpWeight = 0
	else if lerpWeight > 1 then
		lerpWeight = 1
	end if

	// Assume the value is a number.
	return sourceValue + (targetValue - sourceValue) * lerpWeight
end function

Axis = {
	"horizontal": 0,
	"vertical": 1,
	"diagonal": 2,
	"circle": 3,
}

PercentValue = {}

PercentValue.lerp = function(sourceValue, targetValue, lerpWeight)
	v = lerp(sourceValue.value, targetValue.value, lerpWeight)
	return PercentValue.make(v)
end function

PercentValue.make = function(value)
	self = new self
	self.value = value
	return self
end function

PercentValue.resolve = function(svgRoot, axis)
	if axis == Axis.horizontal then return self.value * svgRoot.viewBox.width
	if axis == Axis.vertical then return self.value * svgRoot.viewBox.height
	if axis == Axis.circle then return self.value * mathUtil.min(svgRoot.viewBox.width, svgRoot.viewBox.height)
	// pprint [ self.value, svgRoot.viewBox.getNormalizedDiagonal, self.value * svgRoot.viewBox.getNormalizedDiagonal ]
	return self.value * svgRoot.viewBox.getNormalizedDiagonal
end function

parseValue = function(valueText)
	if valueText == null or valueText == "none" or len(valueText) == 0 then return 0

	// A percentage will be parsed simply as a value between 0 and 1.
	// This may come back to bite me later.
	if valueText.endsWith("%") then return PercentValue.make(val(valueText[:-1]) / 100)

	// If it looks like a color, parse the color, otherwise parse the number.
	if "0" <= valueText[0] and valueText[0] <= "9" then  return val(valueText)
	
	return svgColor.parseSvgColor(valueText)
end function

parseArray = function(strokeDashArray)
	if strokeDashArray == null or strokeDashArray == "none" then return null

	strokeDashArray = splitEntries(strokeDashArray, [" ", ",", ";"])
	
	n = 0
	while n < len(strokeDashArray)
		strokeDashArray[n] = parseValue(strokeDashArray[n])
		n += 1
	end while
	return strokeDashArray
end function

parseColor = function(colorText)
	if colorText == null or colorText == "none" or len(colorText) == 0 then return color.clear
	return svgColor.parseSvgColor(colorText)
end function

parseTime = function(timeText)
	if timeText == null then return 0

	timeText = timeText.trim()
	if timeText.endsWith("s") then return val(timeText[:-1])
	if timeText.endsWith("ms") then return val(timeText[:-2]) / 1000
	return val(timeText)
end function

resolve = function(value, svgRoot, axis)
	if value isa PercentValue then return value.resolve(svgRoot, axis)
	if value isa list then
		arr = []
		for item in value
			arr.push resolve(item, svgRoot, axis)
		end for
		return arr
	end if
	return value
end function

SvgAnimate = {}

SvgAnimate.make = function(animateElem)
	self = new self

	self.attributeName = animateElem.attributes.attributeName
	// Camel-case the attribute name.
	pieces = self.attributeName.split("-")
	self.attributeName = pieces.pull
	while pieces
		self.attributeName += pieces.pull.capitalized
	end while

	self.values = parseArray(animateElem.attributes.values)
	self.dur = parseTime(animateElem.attributes.dur)
	self.begin = -1 * parseTime(animateElem.attributes.get("begin"))
	self.repeatCount = animateElem.attributes.repeatCount

	self.valuesIndex = 0
	self.iterTime = 0
	self.originalValue = null
	return self
end function

SvgAnimate.update = function(deltaTime, target)
	if self.repeatCount != "indefinite" and self.repeatCount <= 0 then return
	if self.begin < 0 then
		self.begin += deltaTime
		return
	end if

	currentValue = self.values[self.valuesIndex]
	nextValuesIndex = (self.valuesIndex + 1) % len(self.values)
	nextValue = self.values[nextValuesIndex]

	self.iterTime += deltaTime
	lerpWeight = self.iterTime / self.dur
	target[self.attributeName] = self.lerp(currentValue, nextValue, lerpWeight)
	
	if self.iterTime >= self.dur then
		self.iterTime = 0
		self.valuesIndex += 1
		if self.valuesIndex >= len(self.values) then
			self.valuesIndex = 0

			if self.repeatCount isa number then
				self.repeatCount -= 1
			end if
		end if
	end if
end function

SvgAnimate.lerp = function(sourceValue, targetValue, lerpWeight)
	// If it's a string, assume it's a color.
	if sourceValue isa string then
		sourceValue = svgColor.parseSvgColor(sourceValue)
		targetValue = svgColor.parseSvgColor(targetValue)
		return color.lerp(sourceValue, targetValue, lerpWeight)
	end if

	// Percent's just need their contents to be lerped.
	if sourceValue isa PercentValue then
		return PercentValue.lerp(lerpWeight, sourceValue.value, targetValue.value)
	end if

	// Assume the value is a number.
	return lerp(sourceValue, targetValue, lerpWeight)
end function

SvgBase = {}

SvgBase.make = function(elem)
	self = new self
	self.lastUpdateTime = time
	self.opacity = 1

	self.animations = []
	contents = elem.get("contents")
	if contents != null then
		for item in contents
			if item.name == "animate" then
				self.animations.push SvgAnimate.make(item)
			else
				qa.assert false, "Unknown element type: {0}".fill([ ])
			end if
		end for
		// pprint self.animations
	end if

	return self
end function

SvgBase.isAnimated = function
	return len(self.animations) > 0
end function

SvgBase.update = function
	currentTime = time
	deltaTime = currentTime - self.lastUpdateTime
	self.lastUpdateTime = currentTime

	for a in self.animations
		a.update deltaTime, self
	end for
end function

SvgRect = new SvgBase

SvgRect.make = function(rectElem)
    self = super.make(rectElem)

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
	x = resolve(self.x, svgRoot, Axis.horizontal)
	y = resolve(self.y, svgRoot, Axis.vertical)
	strokeWidth = resolve(self.strokeWidth, svgRoot, Axis.diagonal)
	width = resolve(self.width, svgRoot, Axis.horizontal)
	height = resolve(self.height, svgRoot, Axis.vertical)

	pd = svgRoot.display

    // Draw the filled rectangle.
    if self.fillColor != color.clear then
        pd.fillRect(x, y, width, height, self.fillColor)
    end if

    // Draw the stroke (outline).
    if strokeWidth > 0 and self.strokeColor != color.clear then
        pd.drawRect(x, y, width, height, self.strokeColor, strokeWidth)
    end if
end function

SvgLine = new SvgBase

SvgLine.make = function(lineElem)
	self = super.make(lineElem)

	self.x1 = parseValue(lineElem.attributes.x1)
	self.y1 = parseValue(lineElem.attributes.y1)
	self.x2 = parseValue(lineElem.attributes.x2)
	self.y2 = parseValue(lineElem.attributes.y2)
	
	self.pathLength = parseValue(lineElem.attributes.get("pathLength"))
	self.strokeDashArray = parseArray(lineElem.attributes.get("stroke-dasharray"))
	self.strokeWidth = parseValue(lineElem.attributes.get("stroke-width"))
	self.strokeColor = parseColor(lineElem.attributes.get("stroke"))
	return self
end function

SvgLine.render = function(svgRoot)
    pd = svgRoot.display

	x1 = resolve(self.x1, svgRoot, Axis.horizontal)
	x2 = resolve(self.x2, svgRoot, Axis.horizontal)
	y1 = resolve(self.y1, svgRoot, Axis.vertical)
	y2 = resolve(self.y2, svgRoot, Axis.vertical)
	strokeWidth = resolve(self.strokeWidth, svgRoot, Axis.diagonal)

    dx = x2 - x1
    dy = y2 - y1
    actualLength = sqrt(dx * dx + dy * dy)

	strokeDashArray = resolve(self.strokeDashArray, svgRoot, Axis.diagonal)

    // Default pathLength to the line's actual length.
    if self.pathLength == 0 then self.pathLength = actualLength

    // If no dash pattern, draw the full line.
    if strokeDashArray == null or len(strokeDashArray) == 0 then
		// pprint ["strokeWidth", strokeWidth, strokeWidth isa PercentValue]
        pd.line x1, y1, x2, y2, self.strokeColor, strokeWidth
        return
    end if

    // Calculate the scaling factor.
    scalingFactor = actualLength / self.pathLength
    // Scale the dash pattern.
    scaledDashArray = []
    for dash in strokeDashArray
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
            dashStartX = floor(x1 + dirX * distance + 0.5)
            dashStartY = floor(y1 + dirY * distance + 0.5)
            dashEndX = floor(x1 + dirX * (distance + dashLength) + 0.5)
            dashEndY = floor(y1 + dirY * (distance + dashLength) + 0.5)
            pd.line(dashStartX, dashStartY, dashEndX, dashEndY, self.strokeColor, strokeWidth)
        end if

        distance += dashLength
        dashIndex += 1
    end while
end function

SvgCircle = new SvgBase

SvgCircle.make = function(circleElem)
	self = super.make(circleElem)
	self.cx = parseValue(circleElem.attributes.cx)
	self.cy = parseValue(circleElem.attributes.cy)
	self.r = parseValue(circleElem.attributes.r)

	self.fillColor = parseColor(circleElem.attributes.get("fill"))
	self.pathLength = parseValue(circleElem.attributes.get("pathLength"))
	self.strokeDashArray = parseArray(circleElem.attributes.get("stroke-dasharray"))
	self.strokeWidth = parseValue(circleElem.attributes.get("stroke-width"))
	self.strokeColor = parseColor(circleElem.attributes.get("stroke"))
	return self
end function

SvgCircle.render = function(svgRoot)
	offsetX = svgRoot.viewBox.minX
	offsetY = svgRoot.viewBox.minY

	cx = resolve(self.cx, svgRoot, Axis.horizontal)
	cy = resolve(self.cy, svgRoot, Axis.vertical)
	r = resolve(self.r, svgRoot, Axis.circle)
	strokeWidth = resolve(self.strokeWidth, svgRoot, Axis.diagonal)
	strokeDashArray = resolve(self.strokeDashArray, svgRoot, Axis.diagonal)

	fillColor = color.lerp(color.clear, self.fillColor, self.opacity)
	strokeColor = color.lerp(color.clear, self.strokeColor, self.opacity)

	customGfx.renderFilledCircle svgRoot.display, cx, cy, r, fillColor
	customGfx.renderCircle svgRoot.display, cx, cy, r, strokeColor, strokeWidth, strokeDashArray, self.pathLength
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
	return sqrt(self.width * self.width + self.height * self.height) /// sqrt(2)
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

Svg.isAnimated = function
	for child in self.children
		if child.isAnimated then return true
	end for
	return false
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

Svg.update = function
	for item in self.children
		item.update
	end for
end function

// fileText = file.readLines("demo/circle.svg").join("")
// fileText = file.readLines("demo/doubleCircle.svg").join("")
// fileText = file.readLines("demo/starryConstellation.svg").join("")
// fileText = file.readLines("demo/percentDemo0.svg").join("")
// fileText = file.readLines("demo/percentDemo1.svg").join("")
fileText = file.readLines("demo/constellation2.svg").join("")
svgElem = xml.parseXml(fileText)
// pprint svgElem

root = Svg.make(svgElem)

gfx.clear
root.render gfx, 50, 50, 512, 512

if root.isAnimated then
	while true
		root.render gfx, 50, 50, 512, 512
		root.update
	end while
end if