// credit to gleeson! modifications by shdwcat

function yui_draw_rect_outline(x, y, w, h, thickness, color, alpha) {
	var x2 = x + w;
	var y2 = y + h;
	var t = thickness;
	draw_set_color(color);
	draw_set_alpha(alpha);
	draw_primitive_begin(pr_trianglestrip);
	    draw_vertex(x, y);
	    draw_vertex(x+t, y+t);
	    draw_vertex(x2, y);
	    draw_vertex(x2-t, y+t);
	    draw_vertex(x2, y2);
	    draw_vertex(x2-t, y2-t);
	    draw_vertex(x, y2);
	    draw_vertex(x+t, y2-t);
	    draw_vertex(x, y);
	    draw_vertex(x+t, y+t);
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