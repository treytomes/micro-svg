import "qa"
import "stringUtil"

XmlParser = {}

// "static" functions

XmlParser.isAlpha = function(ch)
	return ("A" <= ch and ch <= "Z") or ("a" <= ch and ch <= "z")
end function

XmlParser.isDigit = function(ch)
	return "0" <= ch and ch <= "9"
end function

XmlParser.isAlphaNumeric = function(ch)
	return self.isAlpha(ch) or self.isDigit(ch)
end function

XmlParser.isWhiteSpace = function(ch)
	return ch == " " or ch == "\t" or ch == "\r" or ch == "\n"
end function

///////

XmlParser.make = function(text)
	self = new XmlParser
	self.text = text
	self.reset
	return self
end function

XmlParser.reset = function
	self.index = 0
end function

XmlParser.peek = function(delta = 0)
	if self.index + delta > len(self.text) then return null
	return self.text[self.index + delta]
end function

XmlParser.read = function
	ch = self.peek
	qa.assert ch != null, "EOF"
	self.index += 1
	return ch
end function

XmlParser.readAlpha = function
	ch = self.peek
	if self.isAlpha(ch) then
		self.read
		return ch
	end if
	return null
end function

XmlParser.readDigit = function
	ch = self.peek
	if self.isDigit(ch) then
		self.read
		return ch
	end if
	return null
end function

XmlParser.readAlphaNumeric = function(ch)
	ch = self.peek
	if self.isAlphaNumeric(ch) or ch == "-" then
		self.read
		return ch
	end if
	return null
end function

XmlParser.match = function(ch)
	nextCh = self.read
	qa.assert nextCh == ch, "Expected '{0}', found '{1}' (index={2}).".fill([ ch, nextCh, self.index ])
end function

XmlParser.skipWhiteSpace = function
	while true
		ch = self.peek
		if self.isWhiteSpace(ch) then
			self.read
		else
			break
		end if
	end while
end function

XmlParser.parseIdentifier = function
	self.skipWhiteSpace
	name = ""
	ch = self.readAlpha
	if ch == null then return null
	name += ch

	foundColon = false
	while true
		if self.peek == ":" then
			if not foundColon then
				self.read
				foundColon = true
				name += ":"
			else
				qa.assert false, "Identifier already has a color."
			end if
		end if

		ch = self.readAlphaNumeric
		if ch == null then break
		name += ch
	end while

	return name
end function

XmlParser.parseTagName = function
	return self.parseIdentifier
end function

XmlParser.parseAttributeName = function
	return self.parseIdentifier
end function

XmlParser.parseString = function
	self.skipWhiteSpace
	self.match """"

	text = ""
	while true
		ch = self.read
		if ch == """" then break
		text += ch
	end while

	return text
end function

XmlParser.parseAttribute = function
	attrName = self.parseAttributeName
	if attrName == null then return

	self.skipWhiteSpace
	self.match "="

	attrValue = self.parseString
	return {
		attrName: attrValue,
	}
end function

XmlParser.parseAttributes = function
	attrs = {}
	while true
		nextAttr = self.parseAttribute
		if nextAttr == null then break
		attrs += nextAttr
	end while
	return attrs
end function

XmlParser.parseOpeningTag = function
	self.skipWhiteSpace
	if self.peek != "<" then return null
	if self.peek(1) == "/" then return null
	self.match "<"

	tagName = self.parseTagName
	// print "tagName="+tagName
	qa.assert tagName != null and len(tagName) > 0, "Tag name should not be empty."

	attributes = self.parseAttributes

	self.skipWhiteSpace

	isClosed = false
	if self.peek == "/" then
		self.read
		isClosed = true
	end if
	self.match ">"

	return {
		"name": tagName,
		"attributes": attributes,
		"isClosed": isClosed,
	}
end function

XmlParser.parseContents = function
	// print "BEGIN parseContents"
	// An element can contain a list of other elements.
	contents = []
	while true
		elem = self.parseElement
		if elem == null then break
		contents.push elem
	end while
	// print "END parseContents"
	return contents
end function

XmlParser.parseClosingTag = function(tagName)
	// print "BEGIN parseClosingTag"
	self.skipWhiteSpace
	self.match "<"
	self.match "/"

	closingTagName = self.parseTagName
	qa.assert tagName == closingTagName, "Tag name mismatch, {0} != {1}".fill([tagName, closingTagName])

	self.skipWhiteSpace
	self.match ">"
	// print "END parseClosingTag"
end function

XmlParser.skipComment = function
	self.skipWhiteSpace()
	if self.peek == "<" and self.peek(1) == "!" and self.peek(2) == "-" and self.peek(3) == "-" then
		self.read
		self.read
		self.read
		self.read

		// Read to the end of the comment block.
		while true
			if self.peek == "-" and self.peek(1) == "-" and self.peek(2) == ">" then
				self.read
				self.read
				self.read
				break
			end if
			self.read
		end while
		// print "Skipped comment. " + self.text[self.index:]
		return true
	end if
	return false
end function

XmlParser.skipComments = function
	while self.skipComment
	end while
end function

XmlParser.parseElement = function
	self.skipComments

	// print "BEGIN parseElement"
	elem = self.parseOpeningTag
	if elem == null then return null
	isClosed = elem.isClosed
	elem.remove "isClosed"

	if not isClosed then
		elem.contents = self.parseContents
		self.parseClosingTag elem.name
	end if
	// print "END parseElement"
	return elem
end function

XmlParser.parse = function
	// Parse and return the root element.
	return self.parseElement
end function

parseXml = function(text)
	parser = XmlParser.make(text)
	return parser.parse
end function

runUnitTests = function
	text = "<circle cx=""50"" cy=""40"" r=""30"" />"
	elem = parseXml(text)
	qa.assert elem != null, "Oops: {0}".fill([text])
	qa.assert elem.name == "circle"
	qa.assert elem.attributes.cx == "50", "cx expected {0}, found {1}".fill([50, elem.attributes.cx])
	qa.assert elem.attributes.cy == "40", "cy expected {0}, found {1}".fill([40, elem.attributes.cy])
	qa.assert elem.attributes.r == "30", "r expected {0}, found {1}".fill([30, elem.attributes.r])

	text = "<svg viewBox=""0 0 100 100"" xmlns=""http://www.w3.org/2000/svg""><circle cx=""50"" cy=""50"" r=""50"" /></svg>"
	elem = parseXml(text)
	qa.assert elem != null, "Oops: {0}".fill([text])
	qa.assert elem.name == "svg"
	qa.assert elem.contents[0].name == "circle"
end function

if locals == globals then
	runUnitTests
end if