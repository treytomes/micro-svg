renderCircle = function(pd, cx, cy, r, clr, strokeWidth=1, strokeDashArray=null, pathLength=null)
    if strokeDashArray != null and pathLength == null then
        pathLength = 2 * pi * r  // Default to circumference.
	end if

	if strokeWidth > 1 then r += floor(strokeWidth / 2)

    // Draw concentric circles for strokeWidth.
    for offset in range(0, strokeWidth, 0.5)
        adjustedR = r - offset
        if adjustedR <= 0 then continue

        // Generate points around the circle.
        angleStep = 1 / adjustedR  // Smaller step for larger circles.
        angle = 0
        while angle <= 2 * pi
            // Check if this angle falls in a dash.
            inDash = true
            if strokeDashArray != null then
                // Calculate the distance along the perimeter (scaled to pathLength).
                distance = (angle / (2 * pi)) * pathLength
                // Determine if this distance falls in a dash or gap.
                patternLength = sum(strokeDashArray)
                modDistance = distance % patternLength
                cumulative = 0
                inDash = false
                i = 0
                while i < len(strokeDashArray)
                    cumulative += strokeDashArray[i]
                    if modDistance < cumulative then
                        inDash = (i % 2 == 0)  // Even indices = dashes.
                        break
                    end if
                    i += 1
                end while
            end if

            if inDash then
                x = adjustedR * cos(angle)
                y = adjustedR * sin(angle)
                pd.setPixel cx + x, cy + y, clr
            end if

            angle += angleStep
        end while
    end for
end function

renderFilledCircle = function(pd, cx, cy, r, clr)
    // Generate points around the circle.
    angleStep = 1 / r  // Smaller step for larger circles.
    angle = 0
    while angle <= pi  // Only need to go halfway (symmetry).
        x = r * cos(angle)
        y = r * sin(angle)

        // Draw a vertical line from (cx - x, cy + y) to (cx - x, cy - y).
        pd.line(cx - x, cy + y, cx - x, cy - y, clr, 1)
        // Draw a vertical line from (cx + x, cy + y) to (cx + x, cy - y).
        pd.line(cx + x, cy + y, cx + x, cy - y, clr, 1)

        angle += angleStep
    end while
end function
