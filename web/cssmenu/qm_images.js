qmad.image=new Object();qmad.image.preload=new Array();if(qmad.bvis.indexOf("qm_image_switch(b,1);")==-1){qmad.bvis+="qm_image_switch(b,1);";qmad.bhide+="qm_image_switch(a.idiv,false,1);";if(window.attachEvent){window.attachEvent("onload",qm_image_preload);document.attachEvent("onmouseover",qm_image_off);}else  if(window.addEventListener){window.addEventListener("load",qm_image_preload,1);document.addEventListener("mouseover",qm_image_off,false);}document.write('<style type="text/css">.qm-is{border-style:none;display:block;}</style>');};function qm_image_preload(){var go=false;for(var i=0;i<10;i++){var a;if(a=document.getElementById("qm"+i)){var ai=a.getElementsByTagName("IMG");for(var j=0;j<ai.length;j++){if(ai[j].className.indexOf("qm-is")+1){go=true;var br=qm_image_base(ai[j]);if(ai[j].className.indexOf("qm-ih")+1)qm_image_preload2(br[0]+"_hover."+br[1]);if(ai[j].className.indexOf("qm-ia")+1)qm_image_preload2(br[0]+"_active."+br[1]);ai[j].setAttribute("qmvafter",1);if((z=window.qmv)&&(z=z.addons)&&(z=z.image))z["on"+i]=true;}}if(go){ai=a.getElementsByTagName("A");for(var j=0;j<ai.length;j++){if(window.attachEvent)ai[j].attachEvent("onmouseover",qmv_image_hover);else  if(window.addEventListener)ai[j].addEventListener("mouseover",qmv_image_hover,1);}}if(go)a.onmouseover=function(e){qm_kille(e)};}}};function qmv_image_hover(e){e=e||window.event;var targ=e.srcElement||e.target;while(targ&&targ.tagName!="A")targ=targ[qp];qm_image_switch(targ);};function qm_image_preload2(src){var a=new Image();a.src=src;qmad.image.preload.push(a);};function qm_image_base(a,full){var br=qm_image_split_ext_name(a.getAttribute("src",2));br[0]=br[0].replace("_hover","");br[0]=br[0].replace("_active","");if(full)return br[0]+"."+br[1];else return br;};function qm_image_off(){if(qmad.image.la&&qmad.image.la.className.indexOf("qmactive")==-1){qm_image_switch(qmad.image.la,false,1);qmad.image.la=null;}};function qm_image_switch(a,active,hide,force){if((z=window.qmv)&&(z=z.addons)&&(z=z.image)&&!z["on"+qm_index(a)])return;if(!active&&!hide&&qmad.image.la &&qmad.image.la!=a&&qmad.image.la.className.indexOf("qmactive")==-1)qm_image_switch(qmad.image.la,false,1);var img=a.getElementsByTagName("IMG");for(var i=0;i<img.length;i++){if(img[i].className&&img[i].className.indexOf("qm-is")+1){var br=qm_image_base(img[i]);if(!active&&!hide&&img[i].className.indexOf("qm-ih")+1&&(a.className.indexOf("qmactive")==-1||force)){qmad.image.la=a;img[i].src=br[0]+"_hover."+br[1];continue;}if(active&&img[i].className.indexOf("qm-ia")+1){img[i].src=br[0]+"_active."+br[1];continue;}if(hide)img[i].src=br[0]+"."+br[1];}}};function qm_image_split_ext_name(s){var ext=s.split(".");ext=ext[ext.length-1];var fn=s.substring(0,s.length-(ext.length+1));return new Array(fn,ext);}