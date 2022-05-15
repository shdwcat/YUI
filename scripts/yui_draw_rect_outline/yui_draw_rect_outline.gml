// credit to gleeson! modifications by shdwcat

function yui_draw_rect_outline(x, y, w, h, t, color, alpha) {
	var x2 = x + w;
	var y2 = y + h;
	draw_set_color(color);
	draw_set_alpha(alpha);
	draw_primitive_begin(pr_trianglestrip);
		draw_vertex(x, y);			// top left outer
		draw_vertex(x+t, y+t);		// top left inner
		draw_vertex(x2, y);			// top right outer
		draw_vertex(x2-t, y+t);		// top right inner
		draw_vertex(x2, y2);		// bottom right outer
		draw_vertex(x2-t, y2-t);	// bottom right inner
		draw_vertex(x, y2);			// bottom left outer
		draw_vertex(x+t, y2-t);		// bottom left inner
		draw_vertex(x, y);
		draw_vertex(x+t, y+t);
	draw_primitive_end();
}

function yui_draw_rect_outline_clipped(x, y, w, h, cx1, cy1, cx2, cy2, t, color, alpha) {
	var x2 = x + w;
	var y2 = y + h;
	
	var clip_left = x < cx1;
	var clip_top = y < cy1;
	var clip_right = x2 > cx2;
	var clip_bottom = y2 > cy2;
	
	var dx = max(x, cx1);
	var dy = max(y, cy1);
	var dx2 = min(x2, cx2);
	var dy2 = min(y2, cy2);
	
	draw_set_color(color);
	draw_set_alpha(alpha);
	draw_primitive_begin(pr_trianglestrip);
		
		if !clip_top {
			draw_vertex(dx, dy);			// top left outer
			draw_vertex(dx+t, dy+t);		// top left inner
			
			draw_vertex(dx2, dy);			// top right outer
			draw_vertex(dx2-t, dy+t);		// top right inner
		}
		if !clip_right {
			draw_vertex(dx2, dy);		// top right outer
			draw_vertex(dx2-t, dy+t);	// top right inner
			
			draw_vertex(dx2, dy2);			// bottom right outer
			draw_vertex(dx2-t, dy2-t);		// bottom right inner
		}
		else {
			draw_primitive_end();
			draw_primitive_begin(pr_trianglestrip);
		}
		if !clip_bottom {
			draw_vertex(dx2, dy2);		// bottom right outer
			draw_vertex(dx2-t, dy2-t);	// bottom right inner
			
			draw_vertex(dx, dy2);				// bottom left outer
			draw_vertex(dx+t, dy2-t);			// bottom left inner
		}
		else {
			draw_primitive_end();
			draw_primitive_begin(pr_trianglestrip);
		}
		if !clip_left {
			draw_vertex(dx, dy2);		// bottom left outer
			draw_vertex(dx+t, dy2-t);	// bottom left inner
			
			draw_vertex(dx, dy);			// top left outer
			draw_vertex(dx+t, dy+t);		// top left inner
		}
		
	draw_primitive_end();
}

// credit to joh!

// @funct draw_rect_outline
/// @param vx
/// @param vy
/// @param vx2
/// @param vy2
/// @param h
/// @param a
/// @param vcol = c_white
function yui_draw_rect_outline_alt(vx, vy, vx2, vy2, h, vcol = c_white, a = 1) {
	
	if abs(h)>1
	{
		draw_primitive_begin(pr_trianglestrip)
	
		//top left
		draw_vertex_color(vx, vy, vcol, a)
		draw_vertex_color(vx-h, vy-h, vcol, a)
		//top right
		draw_vertex_color(vx2, vy, vcol, a)
		draw_vertex_color(vx2+h, vy-h, vcol, a)
		//bottom right
		draw_vertex_color(vx2, vy2, vcol, a)
		draw_vertex_color(vx2+h, vy2+h, vcol, a)
		//bottom left
		draw_vertex_color(vx, vy2, vcol, a)
		draw_vertex_color(vx-h, vy2+h, vcol, a)
		//close
		draw_vertex_color(vx, vy, vcol, a)
		draw_vertex_color(vx-h, vy-h, vcol, a)
	}
	else
	{
		draw_primitive_begin(pr_linestrip)

		//top left
		draw_vertex_color(vx, vy, vcol, a)
		//top right
		draw_vertex_color(vx2, vy, vcol, a)
		//bottom right
		draw_vertex_color(vx2, vy2, vcol, a)
		//bottom left
		draw_vertex_color(vx, vy2, vcol, a)
		//close
		draw_vertex_color(vx, vy, vcol, a)
	}
	draw_primitive_end();

}