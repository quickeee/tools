
qmad.rcorner=new Object();qmad.br_ie7=navigator.userAgent.indexOf("MSIE 7")+1;if(qmad.bvis.indexOf("qm_rcorner(b.cdiv);")==-1)qmad.bvis+="qm_rcorner(b.cdiv);";;function qm_rcorner(a,hide,force){var z;if(!hide&&((z=window.qmv)&&(z=z.addons)&&(z=z.round_corners)&&!z["on"+qm_index(a)]))return;var q=qmad.rcorner;if((!hide&&!a.hasrcorner)||force){var ss;if(!a.settingsid){var v=a;while((v=v.parentNode)){if(v.className.indexOf("qmmc")+1){a.settingsid=v.id;break;}}}ss=qmad[a.settingsid];if(!ss)return;if(!ss.rcorner_size)return;q.size=ss.rcorner_size;q.background=ss.rcorner_bg_color;if(!q.background)q.background="transparent";q.border=ss.rcorner_border_color;if(!q.border)q.border="#ff0000";q.angle=ss.rcorner_angle_corners;q.corners=ss.rcorner_apply_corners;if(!q.corners||q.corners.length<4)q.corners=new Array(true,1,1,1);q.tinset=0;if(ss.rcorner_top_line_auto_inset&&qm_a(a[qp]))q.tinset=a.idiv.offsetWidth;q.opacity=ss.rcorner_opacity;if(q.opacity&&q.opacity!=1){var addf="";if(window.showHelp)addf="filter:alpha(opacity="+(q.opacity*100)+");";q.opacity="opacity:"+q.opacity+";"+addf;}else q.opacity="";var f=document.createElement("SPAN");x2("qmrcorner",f,1);var fs=f.style;fs.position="absolute";fs.display="block";fs.top="0px";fs.left="0px";var size=q.size;q.mid=parseInt(size/2);q.ps=new Array(size+1);var t2=0;q.osize=q.size;if(!q.angle){for(var i=0;i<=size;i++){if(i==q.mid)t2=0;q.ps[i]=t2;t2+=Math.abs(q.mid-i)+1;}q.osize=1;}var fi="";for(var i=0;i<size;i++)fi+=qm_rcorner_get_span(size,i,1,q.tinset);fi+='<span qmrcmid=1 style="background-color:'+q.background+';border-color:'+q.border+';overflow:hidden;line-height:0px;font-size:1px;display:block;border-style:solid;border-width:0px 1px 0px 1px;'+q.opacity+'"></span>';for(var i=size-1;i>=0;i--)fi+=qm_rcorner_get_span(size,i);f.innerHTML=fi;f.noselect=1;a.insertBefore(f,a.firstChild);a.hasrcorner=f;}var b=a.hasrcorner;if(b){if(!a.offsetWidth)a.style.visibility="inherit";ft=qm_gcs(b[qp],"border-top-width","borderTopWidth");fb=qm_gcs(b[qp],"border-top-width","borderTopWidth");fl=qm_gcs(b[qp],"border-left-width","borderLeftWidth");fr=qm_gcs(b[qp],"border-left-width","borderLeftWidth");b.style.width=(a.offsetWidth-fl)+"px";b.style.height=(a.offsetHeight-fr)+"px";if(qmad.br_ie7){var sp=b.getElementsByTagName("SPAN");for(var i=0;i<sp.length;i++)sp[i].style.visibility="inherit";}b.style.visibility="inherit";var s=b.childNodes;for(var i=0;i<s.length;i++){if(s[i].getAttribute("qmrcmid"))s[i].style.height=Math.abs((a.offsetHeight-(q.osize*2)-ft-fb))+"px";}}};function qm_rcorner_get_span(size,i,top,tinset){var q=qmad.rcorner;var mlmr;if(i==0){var mo=q.ps[size]+q.mid;if(q.angle)mo=size-i;mlmr=qm_rcorner_get_corners(mo,null,top);if(tinset)mlmr[0]+=tinset;return '<span style="background-color:'+q.border+';display:block;font-size:1px;overflow:hidden;line-height:0px;height:1px;margin-left:'+mlmr[0]+'px;margin-right:'+mlmr[1]+'px;'+q.opacity+'"></span>';}else {var md=size-(i);var ih=1;var bs=1;if(!q.angle){if(i>=q.mid)ih=Math.abs(q.mid-i)+1;else {bs=Math.abs(q.mid-i)+1;md=q.ps[size-i]+q.mid;}if(top)q.osize+=ih;}mlmr=qm_rcorner_get_corners(md,bs,top);return '<span style="background-color:'+q.background+';border-color:'+q.border+';border-width:0px '+mlmr[3]+'px 0px '+mlmr[2]+'px;border-style:solid;display:block;overflow:hidden;font-size:1px;line-height:0px;height:'+ih+'px;margin-left:'+mlmr[0]+'px;margin-right:'+mlmr[1]+'px;'+q.opacity+'"></span>';}};function qm_rcorner_get_corners(mval,bval,top){var q=qmad.rcorner;var ml=mval;var mr=mval;var bl=bval;var br=bval;if(top){if(!q.corners[0]){ml=0;bl=1;}if(!q.corners[1]){mr=0;br=1;}}else {if(!q.corners[2]){mr=0;br=1;}if(!q.corners[3]){ml=0;bl=1;}}return new Array(ml,mr,bl,br);}
