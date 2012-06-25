
#declare block=0;
#declare time1=0.05*0;
#declare time2=0.8+0.18;
#declare levels=7;
#declare number=mod(levels,2)/4 + levels/3 + pow(levels,2)/4 + pow(levels,3)/6;
#declare pause=5;
#declare total=pause*(levels-1)+number;
#declare speed=30;
#declare thick=0.002;
#declare bheight=3;
#declare space=0.1;


#declare cc4= pigment{rgb <1,1,1>}
#declare cc1= pigment{rgb <0,0,0.7>}                                                                                        
#declare cc3= pigment{rgb <0.8,0,0>}
#declare cc2= pigment{rgb <0,0.6,0>}
#declare cc6= pigment{rgb <0,0,0.7>*0}
#declare cc5= pigment{rgb <1,0.4,0>/2}
#declare sticker1= superellipsoid{<0.1,0.3> scale <1-space,thick,1-space> pigment{cc1} translate <0,1+thick/2,0> finish{reflection 0.02 ambient 0.7 }}
#declare sticker2= object{sticker1 pigment{cc2} rotate z*-90}
#declare sticker3= object{sticker1 pigment{cc3} rotate x*-90}                     
#declare sticker4= object{sticker1 pigment{cc5} rotate z*90 }
#declare sticker5= object{sticker1 pigment{cc5} rotate x*90 }
#declare sticker6= object{sticker1 pigment{cc6} rotate x*180}
#declare unitcube= superellipsoid{<0.05,0.05> pigment{rgb 0.1} finish{specular 0.5 roughness 0.1}}

#macro cubee(tt)

#declare cubes= array[27]
#declare pos_index= array[27]
#declare c1=-4;
#while (c1<2)
 #declare c1=c1+2;
 #declare c2=-4;
 #while (c2<2)
  #declare c2=c2+2;
  #declare c3=-4;
  #while (c3<2)
   #declare c3=c3+2;
    #declare cubes[9*(c1/2+1)+3*(c2/2+1)+(c3/2+1)]=
     union {
     object{unitcube}
     //#if (c2= 2) #if((c1=0)&(c3=-2)&tt=1) object{sticker1 pigment{cc4}} #else #if((c1=0)&(c3=0)&tt=2) object{sticker1 pigment{cc4}} #else object{sticker1} #end #end #end
     //#if (c1= 2) object{sticker2} #end
     //#if (c3=-2) object{sticker3} #end
     #if (c1=-2) object{sticker4} #end
     #if (c3= 2) object{sticker5} #end
     #if (c2=-2) object{sticker6} #end
     translate <c1,c2,c3>}
    #declare  pos_index[9*(c1/2+1)+3*(c2/2+1)+(c3/2+1)]=
     9*(c1/2+1)+3*(c2/2+1)+(c3/2+1);
  #end
 #end
#end     

#end



#declare cc6= pigment{rgb <1,1,1>*2}
#declare cc4= pigment{rgb <0,0,1>}                                                                                        
#declare cc3= pigment{rgb <0.8,0,0>*1}
#declare cc2= pigment{rgb <0,1,0>*2}
#declare cc1= pigment{rgb <1,1,0>*0.6*2}
#declare cc5= pigment{rgb <1,0.3,0>*1.8}

union{
cubee(2)
#declare c5=0;
#while (c5<27)
 object{cubes[c5] rotate 360*clock*<-1,-1,0>} 
 #declare c5=c5+1;
#end

#macro st3(tr, colo)
object{sticker3 pigment{colo} translate tr}
#end

st3(<-2, 2,-2>, cc3)
st3(< 0, 2,-2>, cc5)
st3(< 2, 2,-2>, cc5)
st3(<-2, 0,-2>, cc3)
st3(< 0, 0,-2>, cc5)
st3(< 2, 0,-2>, cc3)
st3(<-2,-2,-2>, cc5)
st3(< 0,-2,-2>, cc5)
st3(< 2,-2,-2>, cc3)


#macro st2(tr, colo)
object{sticker3 pigment{colo} translate tr rotate y*-90}
#end

st2(<-2, 2,-2>, cc4)
st2(< 0, 2,-2>, cc2)
st2(< 2, 2,-2>, cc2)
st2(<-2, 0,-2>, cc4)
st2(< 0, 0,-2>, cc2)
st2(< 2, 0,-2>, cc4)
st2(<-2,-2,-2>, cc2)
st2(< 0,-2,-2>, cc2)
st2(< 2,-2,-2>, cc4)


#macro st1(tr, colo)
object{sticker3 pigment{colo} translate tr rotate x*90}
#end

st1(<-2, 2,-2>, cc1)
st1(< 0, 2,-2>, cc6)
st1(< 2, 2,-2>, cc1)
st1(<-2, 0,-2>, cc6)
st1(< 0, 0,-2>, cc6)
st1(< 2, 0,-2>, cc6)
st1(<-2,-2,-2>, cc1)
st1(< 0,-2,-2>, cc6)
st1(< 2,-2,-2>, cc1)

translate z*1
finish{ambient 1}
}



//cylinder{-15*x, 15*x, 0.2 pigment{rgb 1}}

light_source{<5,10,-8> rgb 1}


background{rgb 1}          

camera {
  angle 40
  location  <2, 2, -2>*8.1
  look_at   <0.0, 0.0,  0.0>
}