package lycan.util.algorithm;

using lycan.core.IntExtensions;

class Bresenham
{
	/**
	 * Bresenham's line algorithm, returns the points on the line x1,y1 to x2,y2
	 * @param	x1	x-coordinate of the first point.
	 * @param	y1	y-coordinate of the first point.
	 * @param	x2	x-coordinate of the second point.
	 * @param	y2	y-coordinate of the second point.
	 * @return	The points on the line x1,y1 to x2,y2
	 */
	public static function bresenham(x1:Int, y1:Int, x2:Int, y2:Int):Array<{x:Int, y:Int}> {
		var points = [];
		
		var dx:Int = x2 - x1;
		var ix:Int = ((dx > 0) ? 1 : 0) - ((dx < 0) ? 1 : 0);
		dx = IntExtensions.abs(dx) << 1;
		
		var dy:Int = y2 - y1;
		var iy:Int = ((dy > 0) ? 1 : 0) - ((dy < 0) ? 1 : 0);
		dy = IntExtensions.abs(dy) << 1;
		
		var points:Array<{ x:Int, y:Int }> = [];
		points.push({ x: x1, y: y1 });
		
		if (dx >= dy) {
			var error:Int = (dy - (dx >> 1));
			while (x1 != x2) {
				if (error >= 0 && ((error != 0) || (ix > 0))) {
					error -= dx;
					y1 += iy;
				}
				
				error += dy;
				x1 += ix;
				points.push({ x: x1, y: y1 });
			}
		} else {
			var error:Int = (dx - (dy >> 1));
			while (y1 != y2) {
				if (error >= 0 && ((error != 0) || (iy > 0))) {
					error -= dy;
					x1 += ix;
				}
				
				error += dx;
				y1 += iy;
				points.push({ x: x1, y: y1 });
			}
		}
		
		return points;
	}
}