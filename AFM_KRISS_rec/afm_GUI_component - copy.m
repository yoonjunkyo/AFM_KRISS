pkg load control signal
graphics_toolkit qt

close all
clear all
clc

global response_opt = 1;
global analisys_opt = 1;
global h;

[a, b] = textread('fulldata.txt', "%f %s");
A=length(a)/3;
global xx;
global yy;
global dd;

x=a(1:3:end);
y=a(2:3:end);
d=a(3:3:end);
##grid on
xx=reshape(x,256,256);      
yy=reshape(y,256,256);
dd=reshape(d,256,256);
xx=xx';
yy=yy';
dd=dd';

function build_model
  global model;
  global h;
  
  plot_response ();
  plot_analisys();
  
endfunction

function plot_response
  subplot ("position", [0.68 0.55 0.3 0.35]);
  global model;
  global response_opt;
  global xx;
  global yy;
  global dd;

  switch response_opt
    case 1
      subplot ("position", [0.68 0.55 0.3 0.35]);
    case 2
      disp_img_2D(xx,yy,dd);
    case 3
      disp_img_3D(xx,yy,dd);
  endswitch

endfunction

function plot_analisys
  
  global model;
  global analisys_opt;
  global h;
  global xx;
  global yy;
  global dd;
  subplot ("position", [0.35 0.07 0.3 0.33]); #[0.3 0.43 0.3 0.53]    
  switch (analisys_opt)
  case 1
    subplot ("position", [0.68 0.07 0.3 0.33]); #[0.3 0.43 0.3 0.53]
  case 2
    imagesc(dd,'XData',[xx(1,1) xx(1,256)],'YData',[yy(1,1) yy(256,1)])
    hold on
    [Xc,Yc] = ginput(1)
    plot([0 60],[Yc Yc] ,'Color','r','LineWidth',1)
    
    X=xx(1,:)';
    Sfac = 256/26.0420;
    n = round(1+Yc*Sfac);
    D=dd(n,:)';

    subplot ("position", [0.68 0.07 0.3 0.33]); #[0.3 0.43 0.3 0.53]  
    plot(X,D,'g.')
    hold on;
    Y1=Flush(X,D,1);
    Y2=Flush(X,D,3);
    Y3=Flush(X,D,5);

    arr=[Y1,Y2,Y3]

    average=(Y1+Y2+Y3)/3

##´ÜÂ÷1 
    h.P_value = uicontrol (h.ctrl_panel, 'style', 'edit',
                        'units', 'normalized',
                        "string",num2str(Y1),
                        'position', [0.45 0.5 0.5 0.125],
                        'callback', @update_plots);    
    set (h.P_value, 'selected', true);              

##´ÜÂ÷2                 
    h.I_value = uicontrol (h.ctrl_panel, 'style', 'edit',
                        'units', 'normalized',
                         "string",num2str(Y2),
                        'position', [0.45 0.36 0.5 0.125],
                        'callback', @update_plots); 
    set (h.I_value, 'selected', true); 
                        
##´ÜÂ÷3                     
    h.D_value = uicontrol (h.ctrl_panel, 'style', 'edit',
                        'units', 'normalized',
                         "string",num2str(Y3),
                        'position', [0.45 0.22 0.5 0.125],
                        'callback', @update_plots);                     
    set (h.D_value, 'selected', true); 
##Æò±Õ
    h.C_value = uicontrol (h.ctrl_panel, 'style', 'edit',
                        'units', 'normalized',
                         "string",num2str(average),
                        'position', [0.45 0.08 0.5 0.125],
                        'callback', @update_plots);                     
    set (h.C_value, 'selected', true); 
     
endswitch
      
endfunction

function update_plots (obj, init = false)
  
  global model;
  global response_opt;
  global analisys_opt;
  
  ## gcbo holds the handle of the control
  h = guidata (obj);
  
  switch (gcbo)
    
    case {h.response_list} 
      response_opt = get (h.response_list, 'value');
      plot_response ();
            
    case {h.analisys_list} 
      analisys_opt = get (h.analisys_list, 'value');
      plot_analisys ();
    
  endswitch

endfunction
function file_open()
  [file,path] = uigetfile('*.txt');
if isequal(file,0)
   disp('User selected Cancel');
else
   disp(['User selected ', fullfile(path,file)]);
end

##file_open UI func¾È¿¡ ¼û°ÜµÒ
##h.fileopen = uicontrol (h.fig, 'style', 'radiobutton',
##                    'units', 'normalized', # m
##                    'string', 'File Open',
##                    'horizontalalignment', 'left',
##                    'position', [0.08 0.6 0.08 0.6],
##                    'callback', @file_open);

endfunction




## Creatge Dialog
h.fig = figure ('position', [300 45 1200 700], 'menubar', 'none');

h.response_list = uicontrol ("style", "popupmenu",
                                "units", "normalized",
                                "callback", @update_plots,
                                "position", [0.83 0.92 0.1 0.05],
                                "string", {'select','2D','3D'});

h.response_label = uicontrol ("style", "text",
                           "units", "normalized",
                           "string", "Image mode:",
                           "horizontalalignment", "left",
                           "position", [0.73 0.92 0.08 0.05]);

set (h.response_list, 'value', response_opt);


h.analisys_list = uicontrol ("style", "popupmenu",
                                "units", "normalized",
                                "callback", @update_plots,
                                "position", [0.83 0.445 0.1 0.05],
                                "string", { '  ', 
                                            'Line select'});

h.analisys_label = uicontrol ("style", "text",
                           "units", "normalized",
                           "string", "Line select:",
                           "horizontalalignment", "left",
                           "position", [0.73 0.445 0.095 0.05]);

set (h.analisys_list, 'value', analisys_opt);


h.ctrl_panel = uibuttongroup (h.fig, 'title', 'Controller configuration',
                    'units', 'normalized',
                    'position', [0.34 0.43 0.3 0.53]);
                    
h.Custom_opt = uicontrol (h.ctrl_panel, 'style', 'radiobutton',
                    'string', 'Custom Controller',
                    'units', 'normalized',
                    'position', [0.3 0.85 0.4 0.125],
                    'callback', @update_plots); 

set (h.Custom_opt, 'value', true);

h.ctrl_num_label = uicontrol (h.ctrl_panel, 'style', 'text',
                    'units', 'normalized',
                    'string', 'threshold:',
                    'horizontalalignment', 'left',
                    'position', [0.06 0.72 0.65 0.125]);

h.ctrl_num = uicontrol (h.ctrl_panel, 'style', 'edit',
                    'units', 'normalized',
                    'string', num2str(-30),
                    'position', [0.45 0.72 0.5 0.125],
                    'callback', @update_plots);

set (h.ctrl_panel, 'selected', true);

h.P_enabled = uicontrol (h.ctrl_panel, 'style', 'text',
                    'string', '´ÜÂ÷ 1 : ',
                    'units', 'normalized',
                    'position', [0.05 0.5 0.3 0.125],
                    'callback', @update_plots);
set (h.P_enabled, 'selected', true);
                                   
h.I_enabled = uicontrol (h.ctrl_panel, 'style', 'text',
                    'string', '´ÜÂ÷ 2 : ',
                    'units', 'normalized',
                    'position', [0.05 0.36 0.3 0.125],
                    'callback', @update_plots);
set (h.I_enabled, 'value', false);
                    
h.D_enabled = uicontrol (h.ctrl_panel, 'style', 'text',
                    'string', '´ÜÂ÷ 3 : ',
                    'units', 'normalized',
                    'position', [0.05 0.22 0.3 0.125],
                    'callback', @update_plots);
set (h.P_enabled, 'value', false);
                    
h.C_enabled = uicontrol (h.ctrl_panel, 'style', 'text',
                    'string', 'Æò±Õ : ',
                    'units', 'normalized',
                    'position', [0.05 0.08 0.3 0.125],
                    'callback', @update_plots);
set (h.C_enabled, 'value', false);


build_model ();

model.closed_loop = true;
model.ctrl_type = 'Custom';

set (gcf, "color", get(0, "defaultuicontrolbackgroundcolor"));
guidata (gcf, h);
update_plots (gcf, true);

