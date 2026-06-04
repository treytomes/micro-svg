// Render a circle outline.
renderCircle = function(pd, cx, cy, r, clr)
	// Helper method to render the eight symmetrical points of a circle.  
	renderCirclePoints = function(pd, cx, cy, x, y, clr)
		pd.setPixel cx + x, cy + y, clr
		pd.setPixel cx + x, cy - y, clr
		pd.setPixel cx - x, cy + y, clr
		pd.setPixel cx - x, cy - y, clr
		pd.setPixel cx + y, cy + x, clr
		pd.setPixel cx + y, cy - x, clr
		pd.setPixel cx - y, cy + x, clr
		pd.setPixel cx - y, cy - x, clr
	end function

	x = 0
	y = r
	d = 3 - r * 2

	while y >= x
		renderCirclePoints pd, cx, cy, x, y, clr
		x += 1

		// Check for decision parameter and correspondingly update d, x, y.  
		if d > 0 then
			y -= 1
			d += (x - y) * 4 + 10
		else
			d += x * 4 + 6
		end if
	end while
end function

renderFilledCircle = function(pd, cx, cy, r, clr)
	minX = cx - r
	maxX = cx + r
	minY = cy - r
	maxY = cy + r

	radiusSquared = r * r

	y = minY
	while y <= maxY
		if y >= 0 and y < pd.height then
			dy = y - cy
			dy2 = dy * dy
			rowOffset = y * pd.width

			x = minX
			while x <= maxX
				if x >= 0 and x < pd.width then
					dx = x - cx
					if dx * dx + dy2 <= radiusSquared then pd.setPixel x, y, clr
				end if
				x += 1
			end while
		end if
		y += 1
	end while
end function