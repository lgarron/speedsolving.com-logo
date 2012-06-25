//+ua -kc -GW +kff180 +ef198 






 #declare picx=90 ;
 #declare picz=11 ;


#declare unitcube= superellipsoid { <0.2, 0.2> pigment{color 0} finish {specular 0.7 roughness 0.002} scale <1.5, 1, 1>} 
#declare ttt = function { pigment{ image_map{png "banner_grid_colors.png" } rotate x*90 scale <picx,1,picz>}}

#declare i=0;
#while (i < picx)
	#declare j=0;
	#while (j < picz)
		object{unitcube translate <2*i*1.5-60, 0, 2*j> pigment{color ttt(i, 0, j)}}
		#declare j=j+1;	
	#end
	#declare i=i+1;	
#end

light_source{<-100, 200, -50> rgb 2}
light_source{<-100, 20, -500> rgb 1}

camera{
	location y*50+x*100-z*15
	look_at x*100
	right x*image_width/image_height
}


