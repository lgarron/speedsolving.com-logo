#declare flock=0.92; //For optional artistic effect


//Rubik's Cube animation system
//Lucas Garron; www.garron.us
//Begun November 20, 2005, finished November 23, 2005
//Refined for release November 26, 2006
//String parser added December 9, 2006
//created for POV-Ray 3.6

//Command line
//For animation, use -kc (~2-10 frames per turn is recommended)
//Without floor, use +ua
 
#declare include_floor=0;//Render using +ua if include_floor!=1

#declare focal_blur=0; //For optional artistic effect

#declare sine=1; //A  gentle sinusoidal rotation through the animation
#declare ang=20; //The angle of maximum rotation


#declare time1=0.0;         //Time to start twisting
#declare time2=0.98;      //Time to end twisting
#declare thick=0.05;      //Thickness of the tiles
#declare space=0.2;      //Space around the rim of of each tile


//***************Algorithm***************

//Automatically parse the algorithm as a string to generate the appropriate array
#declare alg="RLBFRLB'F'R'L'B'F'R'" //Same Sample alg; "." indicates a rest

#declare ind=0; 
#declare num=0; 
#declare arr=array[strlen(alg)]
#while (ind<strlen(alg)+1)
#declare iss=substr(alg,ind,1)
#if (strcmp(iss,"U")=0) #declare arr[num]=1; #declare num=num+1;  #end
#if (strcmp(iss,"R")=0) #declare arr[num]=2; #declare num=num+1;  #end
#if (strcmp(iss,"F")=0) #declare arr[num]=3; #declare num=num+1;  #end
#if (strcmp(iss,"L")=0) #declare arr[num]=4; #declare num=num+1;  #end
#if (strcmp(iss,"B")=0) #declare arr[num]=5; #declare num=num+1;  #end
#if (strcmp(iss,"D")=0) #declare arr[num]=6; #declare num=num+1;  #end
#if (strcmp(iss,".")=0) #declare arr[num]=0; #declare num=num+1;  #end
#if (strcmp(iss,"'")=0) #declare arr[num-1]=(arr[num-1]+6);
   #if(strcmp(substr(alg,ind-1,1),"2")=0) #declare arr[num-2]=(arr[num-2]+6); #end  #end
#if (strcmp(iss,"2")=0) #declare arr[num]=arr[num-1]; #declare num=num+1;  #end
#declare ind=ind+1;
#end


#declare moves=array[num]
#declare ind=0; 
#while (ind<(num))
#declare moves[ind]=arr[ind];
#declare ind=ind+1;
#end


//Defining an alg as an array (in the format used for rendering; slightly more efficient)
//array[number of moves][each quarter turn is one element, i.e. {2,1,8,7,8,3,2,2,7,8,7,2,1,8,9}]


//#declare moves=array[36]{2,1,8,7,8,3,2,2,7,8,7,2,1,8,9,2,2,7,2,2,10,1,2,7,4,1,1,8,1,2,1,1,2,1,2,2}//Sample alg


/*    Move codes:
00-nothing         Rest for a turn
01-flockwise 1     U
02-flockwise 2     R  
03-flockwise 3     F                                       
04-flockwise 4     L
05-flockwise 5     B
06-flockwise 6     D
07-counterflockwise 1     U'
08-counterflockwise 2     R'
09-counterflockwise 3     F'
10-counterflockwise 4     L'
11-counterflockwise 5     B'
12-counterflockwise 6     D'   
*/ 

                                              
//***************/Algorithm*************** 

global_settings { max_trace_level 100 } //For reflections


camera{
    location <4.9,6,-7>*2
    right <image_width/image_height,0,0>
    look_at <0,-1,0> 
#if (focal_blur=1) aperture 0.7 blur_samples 50 focal_point <2.8,2.8,-2.8> #end
}
//*****************************************************************************


//Natural light
light_source {<20,100,60>, rgb 0.5}
light_source {<-20,100,-20>, rgb 0.5}
light_source {<-10,100,15>, rgb 0.5}
light_source {<7,5,-8>*10, rgb 2.5}        //Main light

//Floor
#if (include_floor=1)
plane {y,-5 pigment{rgb <0.8,0.7,0.3>} normal{quilted 0.05}  finish{reflection 1 metallic}}
#end



//Sticker/Tile colors
#declare color6= pigment{rgb <1,1,0>}           //U face                                                                          
#declare color3= pigment{rgb <0,0.6,0>}         //R face 
#declare color2= pigment{rgb <0.7,0,0>}         //F face 
#declare color5= pigment{rgb <0,0,0.7>}         //L face 
#declare color4= pigment{rgb <1,0.4,0>}         //B face 
#declare color1= pigment{rgb <1,1,1>}           //D face 

#declare sticker1= box{<-1+space,1,-1+space>,<1-space,1.+thick,1-space> pigment{color1}}
#declare sticker2= object{sticker1 pigment{color2} rotate z*-90}
#declare sticker3= object{sticker1 pigment{color3} rotate x*-90}                     
#declare sticker4= object{sticker1 pigment{color4} rotate z*90 }
#declare sticker5= object{sticker1 pigment{color5} rotate x*90 }
#declare sticker6= object{sticker1 pigment{color6} rotate x*180} 

#declare unitcube= superellipsoid { <0.1, 0.1> pigment{color 0} finish {specular 3 roughness 0.001}} //cubie shape
//#declare unitcube= box { -1,1 pigment{color 0} finish {specular 0.1 roughness 0.0003}} //alternate cubie shape
          

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
     #if (c2= 2) object{sticker1} #end
     #if (c1= 2) object{sticker2} #end
     #if (c3=-2) object{sticker3} #end
     #if (c1=-2) object{sticker4} #end
     #if (c3= 2) object{sticker5} #end
     #if (c2=-2) object{sticker6} #end
     translate <c1,c2,c3>}
    #declare  pos_index[9*(c1/2+1)+3*(c2/2+1)+(c3/2+1)]=
     9*(c1/2+1)+3*(c2/2+1)+(c3/2+1);
  #end
 #end
#end


#if ((time1<flock))

#declare pos_index_temp= array[27]{0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26}

#declare mc=0;
#while (mc<dimension_size(moves,1))
#declare mc=mc+1;
 #if (moves[mc-1]!=0)
  #switch (moves[mc-1])
  #case (1)
   #declare c4=-1;
   #while (c4<26)
    #declare c4=c4+1;
    #if  (mod(c4,9)>5)
     #declare cubes[pos_index[c4]]=object{cubes[pos_index[c4]] #if (((mc)/(dimension_size(moves,1))*(time2-time1)+time1)<flock) rotate y*90 #else #if (((mc-1)/(dimension_size(moves,1))*(time2-time1)+time1)<flock)  rotate y*90*(flock-((mc-1)/(dimension_size(moves,1))*(time2-time1)+time1))*(dimension_size(moves,1))/(time2-time1) #end #end}
     #declare pos_index_temp[c4]= pos_index[(floor(c4/9))+ 3 *(floor(mod(c4,9)/3))+ 9 *(2-mod(c4,3))];
    #end
   #end
  #break
  #case (2)
   #declare c4=17;
   #while (c4<26)
    #declare c4=c4+1;
     #declare cubes[pos_index[c4]]=object{cubes[pos_index[c4]] #if (((mc)/(dimension_size(moves,1))*(time2-time1)+time1)<flock) rotate x*90 #else #if (((mc-1)/(dimension_size(moves,1))*(time2-time1)+time1)<flock)  rotate x*90*(flock-((mc-1)/(dimension_size(moves,1))*(time2-time1)+time1))*(dimension_size(moves,1))/(time2-time1) #end #end}
     #declare pos_index_temp[c4]= pos_index[9 *(floor(c4/9))+ (2-floor(mod(c4,9)/3))+ 3 *(mod(c4,3))];
   #end
  #break
  #case (3)
   #declare c4=-1;
   #while (c4<26)
    #declare c4=c4+1;
    #if  (mod(c4,3)=0)
     #declare cubes[pos_index[c4]]=object{cubes[pos_index[c4]] #if (((mc)/(dimension_size(moves,1))*(time2-time1)+time1)<flock) rotate z*-90 #else #if (((mc-1)/(dimension_size(moves,1))*(time2-time1)+time1)<flock)  rotate z*-90*(flock-((mc-1)/(dimension_size(moves,1))*(time2-time1)+time1))*(dimension_size(moves,1))/(time2-time1) #end #end}
     #declare pos_index_temp[c4]= pos_index[3 *(floor(c4/9))+ 9 *(2-floor(mod(c4,9)/3))+ (mod(c4,3))];
    #end
   #end
  #break
  #case (4)
   #declare c4=-1;
   #while (c4<8)
    #declare c4=c4+1;
     #declare cubes[pos_index[c4]]=object{cubes[pos_index[c4]] #if (((mc)/(dimension_size(moves,1))*(time2-time1)+time1)<flock) rotate x*-90 #else #if (((mc-1)/(dimension_size(moves,1))*(time2-time1)+time1)<flock)  rotate x*-90*(flock-((mc-1)/(dimension_size(moves,1))*(time2-time1)+time1))*(dimension_size(moves,1))/(time2-time1) #end #end}
     #declare pos_index_temp[c4]= pos_index[9 *(floor(c4/9))+ (floor(mod(c4,9)/3))+ 3 *(2-mod(c4,3))];
   #end
  #break
  #case (5)
   #declare c4=-1;
   #while (c4<26)
    #declare c4=c4+1;
    #if  (mod(c4,3)=2)
     #declare cubes[pos_index[c4]]=object{cubes[pos_index[c4]] #if (((mc)/(dimension_size(moves,1))*(time2-time1)+time1)<flock) rotate z*90 #else #if (((mc-1)/(dimension_size(moves,1))*(time2-time1)+time1)<flock)  rotate z*90*(flock-((mc-1)/(dimension_size(moves,1))*(time2-time1)+time1))*(dimension_size(moves,1))/(time2-time1) #end #end}
     #declare pos_index_temp[c4]= pos_index[3 *(2-floor(c4/9))+ 9 *(floor(mod(c4,9)/3))+ (mod(c4,3))];
    #end
   #end
  #break
  #case (6)
   #declare c4=-1;
   #while (c4<26)
    #declare c4=c4+1;
    #if  (mod(c4,9)<3)
     #declare cubes[pos_index[c4]]=object{cubes[pos_index[c4]] #if (((mc)/(dimension_size(moves,1))*(time2-time1)+time1)<flock) rotate y*-90 #else #if (((mc-1)/(dimension_size(moves,1))*(time2-time1)+time1)<flock)  rotate y*-90*(flock-((mc-1)/(dimension_size(moves,1))*(time2-time1)+time1))*(dimension_size(moves,1))/(time2-time1) #end #end}
     #declare pos_index_temp[c4]= pos_index[(2-floor(c4/9))+ 3 *(floor(mod(c4,9)/3))+ 9 *(mod(c4,3))];
    #end                                                                                                              
   #end
  #break
  #case (7)
   #declare c4=-1;
   #while (c4<26)
    #declare c4=c4+1;
    #if  (mod(c4,9)>5)
     #declare cubes[pos_index[c4]]=object{cubes[pos_index[c4]] #if (((mc)/(dimension_size(moves,1))*(time2-time1)+time1)<flock) rotate y*-90 #else #if (((mc-1)/(dimension_size(moves,1))*(time2-time1)+time1)<flock)  rotate y*-90*(flock-((mc-1)/(dimension_size(moves,1))*(time2-time1)+time1))*(dimension_size(moves,1))/(time2-time1) #end #end}
     #declare pos_index_temp[c4]= pos_index[(2-floor(c4/9))+ 3 *(floor(mod(c4,9)/3))+ 9 *(mod(c4,3))];
    #end
   #end
  #break
  #case (8)
   #declare c4=17;
   #while (c4<26)
    #declare c4=c4+1;
     #declare cubes[pos_index[c4]]=object{cubes[pos_index[c4]] #if (((mc)/(dimension_size(moves,1))*(time2-time1)+time1)<flock) rotate x*-90 #else #if (((mc-1)/(dimension_size(moves,1))*(time2-time1)+time1)<flock)  rotate x*-90*(flock-((mc-1)/(dimension_size(moves,1))*(time2-time1)+time1))*(dimension_size(moves,1))/(time2-time1) #end #end}
     #declare pos_index_temp[c4]= pos_index[9 *(floor(c4/9))+ (floor(mod(c4,9)/3))+ 3 *(2-mod(c4,3))];
   #end                                                                                 
  #break
  #case (9)
   #declare c4=-1;
   #while (c4<26)
    #declare c4=c4+1;
    #if  (mod(c4,3)=0)
     #declare cubes[pos_index[c4]]=object{cubes[pos_index[c4]] #if (((mc)/(dimension_size(moves,1))*(time2-time1)+time1)<flock) rotate z*90 #else #if (((mc-1)/(dimension_size(moves,1))*(time2-time1)+time1)<flock)  rotate z*90*(flock-((mc-1)/(dimension_size(moves,1))*(time2-time1)+time1))*(dimension_size(moves,1))/(time2-time1) #end #end}
     #declare pos_index_temp[c4]= pos_index[3 *(2-floor(c4/9))+ 9 *(floor(mod(c4,9)/3))+ (mod(c4,3))];
    #end
   #end
  #break
  #case (10)
   #declare c4=-1;
   #while (c4<8)
    #declare c4=c4+1;
     #declare cubes[pos_index[c4]]=object{cubes[pos_index[c4]] #if (((mc)/(dimension_size(moves,1))*(time2-time1)+time1)<flock) rotate x*90 #else #if (((mc-1)/(dimension_size(moves,1))*(time2-time1)+time1)<flock)  rotate x*90*(flock-((mc-1)/(dimension_size(moves,1))*(time2-time1)+time1))*(dimension_size(moves,1))/(time2-time1) #end #end}
     #declare pos_index_temp[c4]= pos_index[9 *(floor(c4/9))+ (2-floor(mod(c4,9)/3))+ 3 *(mod(c4,3))];
   #end
  #break
  #case (11)
   #declare c4=-1;
   #while (c4<26)
    #declare c4=c4+1;
    #if  (mod(c4,3)=2)
     #declare cubes[pos_index[c4]]=object{cubes[pos_index[c4]] #if (((mc)/(dimension_size(moves,1))*(time2-time1)+time1)<flock) rotate z*-90 #else #if (((mc-1)/(dimension_size(moves,1))*(time2-time1)+time1)<flock)  rotate z*-90*(flock-((mc-1)/(dimension_size(moves,1))*(time2-time1)+time1))*(dimension_size(moves,1))/(time2-time1) #end #end}
     #declare pos_index_temp[c4]= pos_index[3 *(floor(c4/9))+ 9 *(2-floor(mod(c4,9)/3))+ (mod(c4,3))];
    #end
   #end
  #break
  #case (12)
   #declare c4=-1;
   #while (c4<26)
    #declare c4=c4+1;
    #if  (mod(c4,9)<3)
     #declare cubes[pos_index[c4]]=object{cubes[pos_index[c4]] #if (((mc)/(dimension_size(moves,1))*(time2-time1)+time1)<flock) rotate y*90 #else #if (((mc-1)/(dimension_size(moves,1))*(time2-time1)+time1)<flock)  rotate y*90*(flock-((mc-1)/(dimension_size(moves,1))*(time2-time1)+time1))*(dimension_size(moves,1))/(time2-time1) #end #end}
     #declare pos_index_temp[c4]= pos_index[(floor(c4/9))+ 3 *(floor(mod(c4,9)/3))+ 9 *(2-mod(c4,3))];
    #end                                                                                                              
   #end
  #break
  #else
  #end
 #end
 #declare c5=0;
 #while (c5<27)
  #declare pos_index[c5]=pos_index_temp[c5];
  #declare c5=c5+1;
 #end
#end

  

#end


#declare c5=0;
#while (c5<27)
 object{cubes[c5] #if ((time1<flock)&(flock<time2)&(sine=1)) rotate -y*ang*sin(2*pi*(flock-time1)/(time2-time1)) #end no_shadow
 rotate z*10
 } 
 #declare c5=c5+1;
#end