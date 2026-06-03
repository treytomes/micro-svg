//
// # SVG color grammar
//
// color    ::= "#" hexdigit hexdigit hexdigit (hexdigit hexdigit hexdigit)?
//              | "rgb(" wsp* integer comma integer comma integer wsp* ")"
//              | "rgb(" wsp* integer "%" comma integer "%" comma integer "%" wsp* ")"
//              | color-keyword
// hexdigit ::= [0-9A-Fa-f]
// comma    ::= wsp* "," wsp*
//
// # Examples
//
// `#A1B2C3`
// `rgb( 12, 34,  56)`
// `rgb(50%, 12%, 93% )`
//
// # Color keywords
// 
// aliceblue	rgb(240, 248, 255)
// antiquewhite	rgb(250, 235, 215)
// aqua	rgb( 0, 255, 255)
// aquamarine	rgb(127, 255, 212)
// azure	rgb(240, 255, 255)
// beige	rgb(245, 245, 220)
// bisque	rgb(255, 228, 196)
// black	rgb( 0, 0, 0)
// blanchedalmond	rgb(255, 235, 205)
// blue	rgb( 0, 0, 255)
// blueviolet	rgb(138, 43, 226)
// brown	rgb(165, 42, 42)
// burlywood	rgb(222, 184, 135)
// cadetblue	rgb( 95, 158, 160)
// chartreuse	rgb(127, 255, 0)
// chocolate	rgb(210, 105, 30)
// coral	rgb(255, 127, 80)
// cornflowerblue	rgb(100, 149, 237)
// cornsilk	rgb(255, 248, 220)
// crimson	rgb(220, 20, 60)
// cyan	rgb( 0, 255, 255)
// darkblue	rgb( 0, 0, 139)
// darkcyan	rgb( 0, 139, 139)
// darkgoldenrod	rgb(184, 134, 11)
// darkgray	rgb(169, 169, 169)
// darkgreen	rgb( 0, 100, 0)
// darkgrey	rgb(169, 169, 169)
// darkkhaki	rgb(189, 183, 107)
// darkmagenta	rgb(139, 0, 139)
// darkolivegreen	rgb( 85, 107, 47)
// darkorange	rgb(255, 140, 0)
// darkorchid	rgb(153, 50, 204)
// darkred	rgb(139, 0, 0)
// darksalmon	rgb(233, 150, 122)
// darkseagreen	rgb(143, 188, 143)
// darkslateblue	rgb( 72, 61, 139)
// darkslategray	rgb( 47, 79, 79)
// darkslategrey	rgb( 47, 79, 79)
// darkturquoise	rgb( 0, 206, 209)
// darkviolet	rgb(148, 0, 211)
// deeppink	rgb(255, 20, 147)
// deepskyblue	rgb( 0, 191, 255)
// dimgray	rgb(105, 105, 105)
// dimgrey	rgb(105, 105, 105)
// dodgerblue	rgb( 30, 144, 255)
// firebrick	rgb(178, 34, 34)
// floralwhite	rgb(255, 250, 240)
// forestgreen	rgb( 34, 139, 34)
// fuchsia	rgb(255, 0, 255)
// gainsboro	rgb(220, 220, 220)
// ghostwhite	rgb(248, 248, 255)
// gold	rgb(255, 215, 0)
// goldenrod	rgb(218, 165, 32)
// gray	rgb(128, 128, 128)
// grey	rgb(128, 128, 128)
// green	rgb( 0, 128, 0)
// greenyellow	rgb(173, 255, 47)
// honeydew	rgb(240, 255, 240)
// hotpink	rgb(255, 105, 180)
// indianred	rgb(205, 92, 92)
// indigo	rgb( 75, 0, 130)
// ivory	rgb(255, 255, 240)
// khaki	rgb(240, 230, 140)
// lavender	rgb(230, 230, 250)
// lavenderblush	rgb(255, 240, 245)
// lawngreen	rgb(124, 252, 0)
// lemonchiffon	rgb(255, 250, 205)
// lightblue	rgb(173, 216, 230)
// lightcoral	rgb(240, 128, 128)
// lightcyan	rgb(224, 255, 255)
// lightgoldenrodyellow	rgb(250, 250, 210)
// lightgray	rgb(211, 211, 211)
// lightgreen	rgb(144, 238, 144)
// lightgrey	rgb(211, 211, 211)
// lightpink	rgb(255, 182, 193)
// lightsalmon	rgb(255, 160, 122)
// lightseagreen	rgb( 32, 178, 170)
// lightskyblue	rgb(135, 206, 250)
// lightslategray	rgb(119, 136, 153)
// lightslategrey	rgb(119, 136, 153)
// lightsteelblue	rgb(176, 196, 222)
// lightyellow	rgb(255, 255, 224)
// lime	rgb( 0, 255, 0)
// limegreen	rgb( 50, 205, 50)
// linen	rgb(250, 240, 230)
// magenta	rgb(255, 0, 255)
// maroon	rgb(128, 0, 0)
// mediumaquamarine	rgb(102, 205, 170)
// mediumblue	rgb( 0, 0, 205)
// mediumorchid	rgb(186, 85, 211)
// mediumpurple	rgb(147, 112, 219)
// mediumseagreen	rgb( 60, 179, 113)
// mediumslateblue	rgb(123, 104, 238)
// mediumspringgreen	rgb( 0, 250, 154)
// mediumturquoise	rgb( 72, 209, 204)
// mediumvioletred	rgb(199, 21, 133)
// midnightblue	rgb( 25, 25, 112)
// mintcream	rgb(245, 255, 250)
// mistyrose	rgb(255, 228, 225)
// moccasin	rgb(255, 228, 181)
// navajowhite	rgb(255, 222, 173)
// navy	rgb( 0, 0, 128)
// oldlace	rgb(253, 245, 230)
// olive	rgb(128, 128, 0)
// olivedrab	rgb(107, 142, 35)
// orange	rgb(255, 165, 0)
// orangered	rgb(255, 69, 0)
// orchid	rgb(218, 112, 214)
// palegoldenrod	rgb(238, 232, 170)
// palegreen	rgb(152, 251, 152)
// paleturquoise	rgb(175, 238, 238)
// palevioletred	rgb(219, 112, 147)
// papayawhip	rgb(255, 239, 213)
// peachpuff	rgb(255, 218, 185)
// peru	rgb(205, 133, 63)
// pink	rgb(255, 192, 203)
// plum	rgb(221, 160, 221)
// powderblue	rgb(176, 224, 230)
// purple	rgb(128, 0, 128)
// red	rgb(255, 0, 0)
// rosybrown	rgb(188, 143, 143)
// royalblue	rgb( 65, 105, 225)
// saddlebrown	rgb(139, 69, 19)
// salmon	rgb(250, 128, 114)
// sandybrown	rgb(244, 164, 96)
// seagreen	rgb( 46, 139, 87)
// seashell	rgb(255, 245, 238)
// sienna	rgb(160, 82, 45)
// silver	rgb(192, 192, 192)
// skyblue	rgb(135, 206, 235)
// slateblue	rgb(106, 90, 205)
// slategray	rgb(112, 128, 144)
// slategrey	rgb(112, 128, 144)
// snow	rgb(255, 250, 250)
// springgreen	rgb( 0, 255, 127)
// steelblue	rgb( 70, 130, 180)
// tan	rgb(210, 180, 140)
// teal	rgb( 0, 128, 128)
// thistle	rgb(216, 191, 216)
// tomato	rgb(255, 99, 71)
// turquoise	rgb( 64, 224, 208)
// violet	rgb(238, 130, 238)
// wheat	rgb(245, 222, 179)
// white	rgb(255, 255, 255)
// whitesmoke	rgb(245, 245, 245)
// yellow	rgb(255, 255, 0)
// yellowgreen	rgb(154, 205, 50)
//

import "listUtil"
import "mapUtil"
import "qa"
import "stringUtil"

knownColors = {
	"aliceblue": color.rgb(240, 248, 255),
	"antiquewhite": color.rgb(250, 235, 215),
	"aqua": color.rgb( 0, 255, 255),
	"aquamarine": color.rgb(127, 255, 212),
	"azure": color.rgb(240, 255, 255),
	"beige": color.rgb(245, 245, 220),
	"bisque": color.rgb(255, 228, 196),
	"black": color.rgb( 0, 0, 0),
	"blanchedalmond": color.rgb(255, 235, 205),
	"blue": color.rgb( 0, 0, 255),
	"blueviolet": color.rgb(138, 43, 226),
	"brown": color.rgb(165, 42, 42),
	"burlywood": color.rgb(222, 184, 135),
	"cadetblue": color.rgb( 95, 158, 160),
	"chartreuse": color.rgb(127, 255, 0),
	"chocolate": color.rgb(210, 105, 30),
	"coral": color.rgb(255, 127, 80),
	"cornflowerblue": color.rgb(100, 149, 237),
	"cornsilk": color.rgb(255, 248, 220),
	"crimson": color.rgb(220, 20, 60),
	"cyan": color.rgb( 0, 255, 255),
	"darkblue": color.rgb( 0, 0, 139),
	"darkcyan": color.rgb( 0, 139, 139),
	"darkgoldenrod": color.rgb(184, 134, 11),
	"darkgray": color.rgb(169, 169, 169),
	"darkgreen": color.rgb( 0, 100, 0),
	"darkgrey": color.rgb(169, 169, 169),
	"darkkhaki": color.rgb(189, 183, 107),
	"darkmagenta": color.rgb(139, 0, 139),
	"darkolivegreen": color.rgb( 85, 107, 47),
	"darkorange": color.rgb(255, 140, 0),
	"darkorchid": color.rgb(153, 50, 204),
	"darkred": color.rgb(139, 0, 0),
	"darksalmon": color.rgb(233, 150, 122),
	"darkseagreen": color.rgb(143, 188, 143),
	"darkslateblue": color.rgb( 72, 61, 139),
	"darkslategray": color.rgb( 47, 79, 79),
	"darkslategrey": color.rgb( 47, 79, 79),
	"darkturquoise": color.rgb( 0, 206, 209),
	"darkviolet": color.rgb(148, 0, 211),
	"deeppink": color.rgb(255, 20, 147),
	"deepskyblue": color.rgb( 0, 191, 255),
	"dimgray": color.rgb(105, 105, 105),
	"dimgrey": color.rgb(105, 105, 105),
	"dodgerblue": color.rgb( 30, 144, 255),
	"firebrick": color.rgb(178, 34, 34),
	"floralwhite": color.rgb(255, 250, 240),
	"forestgreen": color.rgb( 34, 139, 34),
	"fuchsia": color.rgb(255, 0, 255),
	"gainsboro": color.rgb(220, 220, 220),
	"ghostwhite": color.rgb(248, 248, 255),
	"gold": color.rgb(255, 215, 0),
	"goldenrod": color.rgb(218, 165, 32),
	"gray": color.rgb(128, 128, 128),
	"grey": color.rgb(128, 128, 128),
	"green": color.rgb( 0, 128, 0),
	"greenyellow": color.rgb(173, 255, 47),
	"honeydew": color.rgb(240, 255, 240),
	"hotpink": color.rgb(255, 105, 180),
	"indianred": color.rgb(205, 92, 92),
	"indigo": color.rgb( 75, 0, 130),
	"ivory": color.rgb(255, 255, 240),
	"khaki": color.rgb(240, 230, 140),
	"lavender": color.rgb(230, 230, 250),
	"lavenderblush": color.rgb(255, 240, 245),
	"lawngreen": color.rgb(124, 252, 0),
	"lemonchiffon": color.rgb(255, 250, 205),
	"lightblue": color.rgb(173, 216, 230),
	"lightcoral": color.rgb(240, 128, 128),
	"lightcyan": color.rgb(224, 255, 255),
	"lightgoldenrodyellow": color.rgb(250, 250, 210),
	"lightgray": color.rgb(211, 211, 211),
	"lightgreen": color.rgb(144, 238, 144),
	"lightgrey": color.rgb(211, 211, 211),
	"lightpink": color.rgb(255, 182, 193),
	"lightsalmon": color.rgb(255, 160, 122),
	"lightseagreen": color.rgb( 32, 178, 170),
	"lightskyblue": color.rgb(135, 206, 250),
	"lightslategray": color.rgb(119, 136, 153),
	"lightslategrey": color.rgb(119, 136, 153),
	"lightsteelblue": color.rgb(176, 196, 222),
	"lightyellow": color.rgb(255, 255, 224),
	"lime": color.rgb( 0, 255, 0),
	"limegreen": color.rgb( 50, 205, 50),
	"linen": color.rgb(250, 240, 230),
	"magenta": color.rgb(255, 0, 255),
	"maroon": color.rgb(128, 0, 0),
	"mediumaquamarine": color.rgb(102, 205, 170),
	"mediumblue": color.rgb( 0, 0, 205),
	"mediumorchid": color.rgb(186, 85, 211),
	"mediumpurple": color.rgb(147, 112, 219),
	"mediumseagreen": color.rgb( 60, 179, 113),
	"mediumslateblue": color.rgb(123, 104, 238),
	"mediumspringgreen": color.rgb( 0, 250, 154),
	"mediumturquoise": color.rgb( 72, 209, 204),
	"mediumvioletred": color.rgb(199, 21, 133),
	"midnightblue": color.rgb( 25, 25, 112),
	"mintcream": color.rgb(245, 255, 250),
	"mistyrose": color.rgb(255, 228, 225),
	"moccasin": color.rgb(255, 228, 181),
	"navajowhite": color.rgb(255, 222, 173),
	"navy": color.rgb( 0, 0, 128),
	"oldlace": color.rgb(253, 245, 230),
	"olive": color.rgb(128, 128, 0),
	"olivedrab": color.rgb(107, 142, 35),
	"orange": color.rgb(255, 165, 0),
	"orangered": color.rgb(255, 69, 0),
	"orchid": color.rgb(218, 112, 214),
	"palegoldenrod": color.rgb(238, 232, 170),
	"palegreen": color.rgb(152, 251, 152),
	"paleturquoise": color.rgb(175, 238, 238),
	"palevioletred": color.rgb(219, 112, 147),
	"papayawhip": color.rgb(255, 239, 213),
	"peachpuff": color.rgb(255, 218, 185),
	"peru": color.rgb(205, 133, 63),
	"pink": color.rgb(255, 192, 203),
	"plum": color.rgb(221, 160, 221),
	"powderblue": color.rgb(176, 224, 230),
	"purple": color.rgb(128, 0, 128),
	"red": color.rgb(255, 0, 0),
	"rosybrown": color.rgb(188, 143, 143),
	"royalblue": color.rgb( 65, 105, 225),
	"saddlebrown": color.rgb(139, 69, 19),
	"salmon": color.rgb(250, 128, 114),
	"sandybrown": color.rgb(244, 164, 96),
	"seagreen": color.rgb( 46, 139, 87),
	"seashell": color.rgb(255, 245, 238),
	"sienna": color.rgb(160, 82, 45),
	"silver": color.rgb(192, 192, 192),
	"skyblue": color.rgb(135, 206, 235),
	"slateblue": color.rgb(106, 90, 205),
	"slategray": color.rgb(112, 128, 144),
	"slategrey": color.rgb(112, 128, 144),
	"snow": color.rgb(255, 250, 250),
	"springgreen": color.rgb( 0, 255, 127),
	"steelblue": color.rgb( 70, 130, 180),
	"tan": color.rgb(210, 180, 140),
	"teal": color.rgb( 0, 128, 128),
	"thistle": color.rgb(216, 191, 216),
	"tomato": color.rgb(255, 99, 71),
	"turquoise": color.rgb( 64, 224, 208),
	"violet": color.rgb(238, 130, 238),
	"wheat": color.rgb(245, 222, 179),
	"white": color.rgb(255, 255, 255),
	"whitesmoke": color.rgb(245, 245, 245),
	"yellow": color.rgb(255, 255, 0),
	"yellowgreen": color.rgb(154, 205, 50),
}

hexDigits = "0123456789abcdef"

parseSvgColor = function(rawText)
	rawText = lower(rawText.trim())

	// Is it a known color?
	c = knownColors.get(rawText)
	if c != null then return c
	
	// Is it a raw hex color?
	if rawText.startsWith("#") then
		// Valid formats:
		// - #rgb
		// - #rgba
		// - #rrggbb
		// - #rrggbbaa
		//
		// So valid lengths are [3, 4, 6, 8] (+1 for the hash tag).
		textCase = len(rawText)
		qa.assert [4, 5, 7, 9].contains(textCase), "{0} does not represent a hexadecimal color.".fill([ rawText ])
		
		text = rawText[1:]
		for ch in text
			qa.assert hexDigits.contains(ch), "{0} does not represent a hexadecimal color.".fill([ rawText ])
		end for

		// I originally thought I would need to parse this string, but we actually *want* a hexadecimal color value.
		return rawText
	end if

	parseNumericArgument = function(text)
		text = text.trim()
		if text.endsWith("%") then
			text = text[:-1]
			v = val(text)
			qa.assert 0 <= v and v <= 100, "Value is out of range; expected a percentage."
		else
			v = val(text)
			qa.assert 0 <= v and v <= 255, "Value is out of range; expected a value for 0 to 255."
		end if
		return v
	end function

	// Is it an rgb or rgba?
	if rawText[:4] == "rgba" then
		text = rawText[4:]
		qa.assert text.startsWith("(") and text.endsWith(")"), "Expected parenthesis around the arguments."
		args = text[1:-1].split(",")
		qa.assert len(args) == 4, "Expected 4 color arguments: {0}".fill(rawText)

		args[0] = parseNumericArgument(args[0])
		args[1] = parseNumericArgument(args[1])
		args[2] = parseNumericArgument(args[2])
		args[3] = parseNumericArgument(args[3])
		return color.fromList(args)
	else
		text = rawText[3:]
		qa.assert text.startsWith("(") and text.endsWith(")"), "Expected parenthesis around the arguments."

		args = text[1:-1].split(",")
		qa.assert len(args) == 3, "Expected 3 color arguments: {0}".fill(rawText)

		args[0] = parseNumericArgument(args[0])
		args[1] = parseNumericArgument(args[1])
		args[2] = parseNumericArgument(args[2])
		return color.fromList(args)
	end if
end function

runUnitTests = function()
	qa.assert parseSvgColor("#123456") == "#123456"
	qa.assert parseSvgColor("rgb(1, 2, 3)") == "#010203FF"
	qa.assert parseSvgColor("rgba(1, 2, 3, 4)") == "#01020304"
	qa.assert parseSvgColor("rgb(3, 10, 100)") == "#030A64FF"
	qa.assert parseSvgColor("aliceblue") == knownColors["aliceblue"]
end function

if globals == locals then
	runUnitTests
end if
