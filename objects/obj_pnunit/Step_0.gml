
// These arrays are the losses on any one frame.
// Instead of resetting in a bunch of places, we reset here.
array_resize(lost, 0)
array_resize(lost_num, 0)

highlight=0;
var diff=0;
var pos=880;
var siz=min(400,(men*0.5)+(veh*2.5)+(dreads*2));
if (instance_exists(obj_centerline)){
    diff=x-obj_centerline.x;
}
if (siz>0){
    if ((pos+(diff*2))>817) and ((pos+(diff*2))<1575){
        if (mouse_x>=pos+(diff*2)) and (mouse_y>=450-(siz/2)) 
        and (mouse_x<pos+(diff*2)+10) and (mouse_y<450+(siz/2)) then highlight=men+medi+veh;
    }
}

if (highlight2!=highlight){
    highlight2=highlight;highlight3="";
    var i,stop;i=0;stop=0;
    repeat(70){i+=1;
        if (stop=0){
            if (dudes_num[i]>0) and (dudes_num[i+1]>0) then highlight3+=string(dudes_num[i])+"x "+string(dudes[i])+", ";
            if (dudes_num[i]>0) and (dudes_num[i+1]<=0){highlight3+=string(dudes_num[i])+"x "+string(dudes[i])+".  ";stop=1;}
        }
    }
}


