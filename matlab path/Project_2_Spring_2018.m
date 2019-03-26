function [varargout]=Project_2_Spring_2018(varargin)
%Levi Stalsworth
%This is a program to apply various filters to a selected image
%all filters can be selected through the button menus
%filters are previewed before being manually applied
%Spatial                        Frequency
%low-passs                      low-pass
%high-pass                      high-pass
%highboost                      highboost
%brightness                     band-pass
%contras                        band-stop
%histogram equalization         homomorphic  
%adaptive histogram equalization
%
%additional information on the selected filter may be needed to apply it


function_name='Project_2_Spring_2018';

global figure_handle
global buttons
global figure_preview_handle
global previews
global figure_spatial_handle
global spatials
global figure_freq_handle
global freqs
global figure_image1_handle
global image_1_data
global figure_image2_handle
global image_2_data
global waitbutt
global figure_waitbutt_handle


% buttons for waiting ----------------------------------------------------
waitbutt=[];

one_button=struct(...
    'Name','WAIT',...
    'CallbackCommand','wait');
waitbutt=[waitbutt;one_button];

NumberOfWaits=size(waitbutt,1);


% buttons for image select -----------------------------------------------
buttons=[];
one_button=struct(...
    'Name','Load Image',...
    'CallbackCommand','load');
buttons=[buttons;one_button];
one_button=struct(...
    'Name','Save Image',...
    'CallbackCommand','save');
buttons=[buttons;one_button];

one_button=struct(...
    'Name','Select Filter and Preview',...
    'CallbackCommand','change');
buttons=[buttons;one_button];

one_button=struct(...
    'Name','Apply Changes',...
    'CallbackCommand','apply');
buttons=[buttons;one_button];

one_button=struct(...
    'Name','Quit',...
    'CallbackCommand','quit');
buttons=[buttons;one_button];

NumberOfButtons=size(buttons,1);


% buttons for filters preview --------------------------------------------
previews = [];
one_button=struct(...
    'Name','Spatial Filters',...
    'CallbackCommand','spatials');
previews=[previews;one_button];

one_button=struct(...
    'Name','Freqeuncy Domain Filters',...
    'CallbackCommand','freq');
previews=[previews;one_button];

one_button=struct(...
    'Name','Cancel',...
    'CallbackCommand','cancel');
previews=[previews;one_button];

NumberOfPreviews=size(previews,1);


% buttons for spatial filters --------------------------------------------
spatials=[];
one_button=struct(...
    'Name','Be My Neighbor (low pass filter)',...
    'CallbackCommand','neighbor');
spatials=[spatials;one_button];

one_button=struct(...
    'Name','High-Pass Filter',...
    'CallbackCommand','edge');
spatials=[spatials;one_button];

one_button=struct(...
    'Name','Highboost',...
    'CallbackCommand','boost');
spatials=[spatials;one_button];

one_button=struct(...
    'Name','Brightness',...
    'CallbackCommand','bright');
spatials=[spatials;one_button];

one_button=struct(...
    'Name','Contrast',...
    'CallbackCommand','contra');
spatials=[spatials;one_button];

one_button=struct(...
    'Name','histeq',...
    'CallbackCommand','histeq');
spatials=[spatials;one_button];

one_button=struct(...
    'Name','adapthisteq',...
    'CallbackCommand','adapthisteq');
spatials=[spatials;one_button];

one_button=struct(...
    'Name','Cancel',...
    'CallbackCommand','cancel2');
spatials=[spatials;one_button];

NumberOfSpatials=size(spatials,1);


% buttons for frequency filters ------------------------------------------
freqs=[];
one_button=struct(...
    'Name','Low Pass',...
    'CallbackCommand','low pass');
freqs=[freqs;one_button];

one_button=struct(...
    'Name','High Pass',...
    'CallbackCommand','high pass');
freqs=[freqs;one_button];

one_button=struct(...
    'Name','High Boost',...
    'CallbackCommand','high boost');
freqs=[freqs;one_button];

one_button=struct(...
    'Name','Band Pass',...
    'CallbackCommand','band pass');
freqs=[freqs;one_button];

one_button=struct(...
    'Name','Band Stop',...
    'CallbackCommand','band stop');
freqs=[freqs;one_button];

one_button=struct(...
    'Name','Homomorphic',...
    'CallbackCommand','homo');
freqs=[freqs;one_button];

one_button=struct(...
    'Name','Cancel',...
    'CallbackCommand','cancel3');
freqs=[freqs;one_button];

NumberOfFreqs=size(freqs,1);


if nargin<1,
    action='initialize';
else
    action=varargin{1};
end;

%initializes each handle -------------------------------------------------
if strcmp(action,'initialize'),
    
    %freq handle ---------------------------------------------------------
    bottom=400;
    left=400;
    height=400;
    width=400;
    figure_waitbutt_handle=figure( ...
        'Name','WAIT', ...
        'NumberTitle','off', ...
        'Units','pixels', ...
        'Position',[left bottom width height], ...
        'DockControls','off', ...
        'ToolBar','none', ...
        'MenuBar','none', ...
        'Color',[0 0 0], ...
        'Visible','off');
    uicontrol( ...
        'Style','frame', ...
         'Units','normalized', ...
         'Position',[0 0 1 1], ...
         'BackgroundColor',[0 0 0]);  

    button_wait_left=0.02;
    button_wait_width=0.96;
    button_wait_height=1.0/NumberOfWaits;
    
    for ButtonWaitNumber=1:NumberOfWaits
        waitPos=[button_wait_left (1 + (button_wait_height*0.025)-...
            (ButtonWaitNumber)*button_wait_height) button_wait_width ...
            (button_wait_height*0.95)];
        waitcallbackStr=strcat(function_name,...
            '(''',waitbutt(ButtonWaitNumber).CallbackCommand,''')');
    uicontrol( ...
        'Style','pushbutton', ...
        'Units','normalized', ...
        'Position',waitPos, ...
        'String',waitbutt(ButtonWaitNumber).Name, ...
        'Callback',waitcallbackStr );
     end  
     
    %freq handle ---------------------------------------------------------
    bottom=100;
    left=200;
    height=600;
    width=200;
    figure_freq_handle=figure( ...
        'Name','Control Panel Template', ...
        'NumberTitle','off', ...
        'Units','pixels', ...
        'Position',[left bottom width height], ...
        'DockControls','off', ...
        'ToolBar','none', ...
        'MenuBar','none', ...
        'Color',[0 0 0], ...
        'Visible','off');
    uicontrol( ...
        'Style','frame', ...
         'Units','normalized', ...
         'Position',[0 0 1 1], ...
         'BackgroundColor',[0 0 0]);  

    button_freq_left=0.02;
    button_freq_width=0.96;
    button_freq_height=1.0/NumberOfFreqs;
    
    for ButtonFreqNumber=1:NumberOfFreqs
        freqPos=[button_freq_left (1 + (button_freq_height*0.025)-...
            (ButtonFreqNumber)*button_freq_height) button_freq_width ...
            (button_freq_height*0.95)];
        freqcallbackStr=strcat(function_name,...
            '(''',freqs(ButtonFreqNumber).CallbackCommand,''')');
    uicontrol( ...
        'Style','pushbutton', ...
        'Units','normalized', ...
        'Position',freqPos, ...
        'String',freqs(ButtonFreqNumber).Name, ...
        'Callback',freqcallbackStr );
     end  

    %images handles ------------------------------------------------------
    figure_image1_handle=figure( ...
        'Name','image1', ...
        'NumberTitle','off', ...
        'DockControls','off', ...
        'ToolBar','none', ...
        'MenuBar','none', ...
        'Visible','off');
   
    figure_image2_handle=figure( ...
        'Name','image2', ...
        'NumberTitle','off', ...
        'DockControls','off', ...
        'ToolBar','none', ...
        'MenuBar','none', ...
        'Visible','off');
 
    %preview handle ------------------------------------------------------
    bottom=100;
    left=200;
    height=600;
    width=200;
    figure_preview_handle=figure( ...
        'Name','filters', ...
        'NumberTitle','off', ...
        'Units','pixels', ...
        'Position',[left bottom width height], ...
        'DockControls','off', ...
        'ToolBar','none', ...
        'MenuBar','none', ...
        'Color',[0 0 0], ...
        'Visible','off');
    uicontrol( ...
        'Style','frame', ...
         'Units','normalized', ...
         'Position',[0 0 1 1], ...
         'BackgroundColor',[1 0 0]); 

    button_preview_left=0.02;
    button_preview_width=0.96;
    button_preview_height=1.0/NumberOfPreviews;
    

    for ButtonPreviewNumber=1:NumberOfPreviews
        pvwPos=[button_preview_left (1 + (button_preview_height*0.025)-...
            (ButtonPreviewNumber)*button_preview_height)...
             button_preview_width (button_preview_height*0.95)];
        PrecallbackStr=strcat(function_name,...
            '(''',previews(ButtonPreviewNumber).CallbackCommand,''')');
    uicontrol( ...
        'Style','pushbutton', ...
        'Units','normalized', ...
        'Position',pvwPos, ...
        'String',previews(ButtonPreviewNumber).Name, ...
        'Callback',PrecallbackStr );
     end
        
    %spatial handle ------------------------------------------------------
    bottom=100;
    left=200;
    height=600;
    width=200;
    figure_spatial_handle=figure( ...
        'Name','filters', ...
        'NumberTitle','off', ...
        'Units','pixels', ...
        'Position',[left bottom width height], ...
        'DockControls','off', ...
        'ToolBar','none', ...
        'MenuBar','none', ...
        'Color',[0 0 0], ...
        'Visible','off');
    uicontrol( ...
        'Style','frame', ...
         'Units','normalized', ...
         'Position',[0 0 1 1], ...
         'BackgroundColor',[1 1 1]); 

    button_spatial_left=0.02;
    button_spatial_width=0.96;
    button_spatial_height=1.0/NumberOfSpatials;   

    for ButtonSpatialNumber=1:NumberOfSpatials
        spcPos=[button_spatial_left (1 + (button_spatial_height*0.025)-...
            (ButtonSpatialNumber)*button_spatial_height)...
             button_spatial_width (button_spatial_height*0.95)];
        SpccallbackStr=strcat(function_name,...
            '(''',spatials(ButtonSpatialNumber).CallbackCommand,''')');
    uicontrol( ...
        'Style','pushbutton', ...
        'Units','normalized', ...
        'Position',spcPos, ...
        'String',spatials(ButtonSpatialNumber).Name, ...
        'Callback',SpccallbackStr );
     end
    
    %options handle ------------------------------------------------------
    bottom=100;
    left=200;
    height=600;
    width=325;
    figure_handle=figure( ...
        'Name','Project#2-Levi Stalsworth', ...
        'NumberTitle','off', ...
        'Units','pixels', ...
        'Position',[left bottom width height], ...
        'DockControls','off', ...
        'ToolBar','none', ...
        'MenuBar','none', ...
        'Color',[0 0 0], ...
        'Visible','on');
    uicontrol( ...
        'Style','frame', ...
         'Units','normalized', ...
         'Position',[0 0 1 1], ...
         'BackgroundColor',[.7 0 .6]);  

    button_left=0.02;
    button_width=0.96;
    button_height=1.0/NumberOfButtons;
    
    for ButtonNumber=1:NumberOfButtons
        btnPos=[button_left (1 + (button_height*0.025)-...
            (ButtonNumber)*button_height) button_width (button_height*0.95)];
        callbackStr=strcat(function_name,...
            '(''',buttons(ButtonNumber).CallbackCommand,''')');
    uicontrol( ...
        'Style','pushbutton', ...
        'Units','normalized', ...
        'Position',btnPos, ...
        'String',buttons(ButtonNumber).Name, ...
        'Callback',callbackStr );
     end   
end;


if strcmp(action,'change'),
    set(figure_handle, 'Visible', 'off');
    set(figure_preview_handle, 'Visible', 'on');  
end;


if strcmp(action,'load'),
     image_1_name=uigetfile('*.*');
     if isequal(image_1_name,0)
        % do nothing
     else   
       set(groot,'CurrentFigure',figure_image1_handle);
       set(figure_image1_handle, 'Visible', 'off');
       [temp_image]=imread(image_1_name);
       image_1_data=temp_image;
       set(figure_image1_handle, 'Visible', 'on');
       imshow(image_1_data);
    end
end;


if strcmp(action,'apply'),
    set(groot,'CurrentFigure',figure_image1_handle);
    set(figure_image1_handle,'Visible', 'off');
    
    image_1_data=image_2_data;
    imshow(image_1_data);
    
    set(figure_image2_handle, 'Visible', 'off');
    set(figure_image1_handle,'Visible', 'on');
end;


if strcmp(action,'save'),
    answer = inputdlg('Write name of save file including file type');
    if isequal(answer, {})
        % do nothing
    else
    imwrite(image_1_data, answer{1});
    end
end;


if strcmp(action,'quit'),
    close all hidden;
    return;
end;


%preview option ---------------------------------------------------------
if strcmp(action,'spatials'),
    set(figure_preview_handle, 'Visible', 'off');
    set(figure_spatial_handle,'Visible', 'on');
end;


if strcmp(action,'freq'),
    set(figure_preview_handle, 'Visible', 'off');
    set(figure_freq_handle,'Visible', 'on');
end;


if strcmp(action,'cancel'),
    set(figure_preview_handle, 'Visible', 'off');
    set(figure_handle,'Visible', 'on');
end;


%spatial filters --------------------------------------------------------
if strcmp(action,'neighbor'),
    set(groot,'CurrentFigure',figure_image2_handle);    
    set(figure_image2_handle, 'Visible', 'off');
    set(figure_spatial_handle, 'Visible', 'off');
    
    k = menu('Choose a neighborhood','3x3', '5x5', '7x7', '9x9');

    set(figure_waitbutt_handle, 'Visible', 'on');
    [height width]=size(image_1_data);
    image_2_data=image_1_data;
    for row=1:height
        for col=1:width
            startrow=max(row-k,1);
            endrow=min(row+k,height);
            startcol=max(col-k,1);
            endcol=min(col+k,width);
            image_2_data(row,col)=...
                mean(mean(image_1_data(startrow:endrow,startcol:endcol)));
        end
    end

    set(figure_waitbutt_handle, 'Visible', 'off');
    set(figure_image2_handle,'Visible', 'on');
    imshow(image_2_data);
    set(figure_handle, 'Visible', 'on');
end;


if strcmp(action,'edge'),
    set(groot,'CurrentFigure',figure_image2_handle);    
    set(figure_image2_handle,'Visible', 'off');
    set(figure_spatial_handle, 'Visible', 'off');
    
    k = menu('Choose a neighborhood','3x3', '5x5', '7x7', '9x9');

    set(figure_waitbutt_handle, 'Visible', 'on');
    [height width]=size(image_1_data);
    image_2_data=image_1_data;
    for row=1:height
        for col=1:width
            startrow=max(row-k,1);
            endrow=min(row+k,height);
            startcol=max(col-k,1);
            endcol=min(col+k,width);
            image_2_data(row,col)=...
                mean(mean(image_1_data(startrow:endrow,startcol:endcol)));
        end
    end
    
    image_2_data = image_1_data - image_2_data;

    set(figure_image2_handle,'Visible', 'on');
    imshow(image_2_data);
    
    set(figure_waitbutt_handle, 'Visible', 'off');
    set(figure_handle, 'Visible', 'on');
end;


if strcmp(action,'boost'),
    set(figure_spatial_handle, 'Visible', 'off');
    set(groot,'CurrentFigure',figure_image2_handle);    
    set(figure_image2_handle,'Visible', 'off');
    
    k = menu('Choose a neighborhood','3x3', '5x5', '7x7', '9x9');
    b = inputdlg('Choose a boost');
    b = str2double(b{1});
    
    set(figure_waitbutt_handle, 'Visible', 'on');
    [height width]=size(image_1_data);
    lowpass=image_1_data;
    for row=1:height
        for col=1:width
            startrow=max(row-k,1);
            endrow=min(row+k,height);
            startcol=max(col-k,1);
            endcol=min(col+k,width);
            lowpass(row,col)=...
                mean(mean(image_1_data(startrow:endrow,startcol:endcol)));
        end
    end
    
    image_2_data = (b-1)*image_1_data + (image_1_data - lowpass);

    set(figure_image2_handle,'Visible', 'on');
    imshow(image_2_data);
    
    set(figure_waitbutt_handle, 'Visible', 'off');
    set(figure_handle, 'Visible', 'on');
end;


if strcmp(action,'bright'),
    set(groot,'CurrentFigure',figure_image2_handle);
    set(figure_image2_handle,'Visible', 'off');
    set(figure_spatial_handle, 'Visible', 'off');
	
	bright = inputdlg('Enter integer for brightness shift');
    bright = str2double(bright{1});
    
    set(figure_waitbutt_handle, 'Visible', 'on');
    
	image_2_data = image_1_data + bright;
	
	set(figure_image2_handle, 'Visible', 'on');
    imshow(image_2_data);
	
    set(figure_waitbutt_handle, 'Visible', 'off');
	set(figure_handle, 'Visible', 'on');    
end;


if strcmp(action,'contra'),
    set(groot,'CurrentFigure',figure_image2_handle);
    set(figure_image2_handle,'Visible', 'off');
    set(figure_spatial_handle, 'Visible', 'off');
	
	contra = inputdlg('Enter float for contras adjustment');
    contra = str2double(contra{1});
    
    set(figure_waitbutt_handle, 'Visible', 'on');
    
	image_2_data = image_1_data * contra;
	
    set(figure_waitbutt_handle, 'Visible', 'off');
	set(figure_image2_handle,'Visible', 'on');
    imshow(image_2_data);
    set(figure_handle, 'Visible', 'on');
end;


if strcmp(action,'histeq'),
    set(groot,'CurrentFigure',figure_image2_handle);
	set(figure_image2_handle, 'Visible', 'off');
    set(figure_spatial_handle, 'Visible', 'off');  
    set(figure_waitbutt_handle, 'Visible', 'on');

	image_2_data = histeq(image_1_data);

	set(figure_image2_handle,'Visible', 'on');
    imshow(image_2_data);
	
    set(figure_waitbutt_handle, 'Visible', 'off');
    set(figure_handle, 'Visible', 'on');
end;


if strcmp(action,'adapthisteq'),
    set(groot,'CurrentFigure',figure_image2_handle);
	set(figure_image2_handle, 'Visible', 'off');
    set(figure_spatial_handle, 'Visible', 'off');
    set(figure_waitbutt_handle, 'Visible', 'on');
    
 	if size(image_1_data, 3) == 3
	    working_image = rgb2ycbcr(image_1_data);
        Y=working_image(:,:,1);
        Y = adapthisteq(Y);
        working_image(:,:,1)=Y(:,:,1);
        image_2_data = working_image;
        image_2_data = ycbcr2rgb(image_2_data);
	elseif size(image_1_data, 3) == 1   
	    image_2_data = adapthisteq(image_1_data);
    end
    
	set(figure_image2_handle,'Visible', 'on');
    imshow(image_2_data);
	
    set(figure_waitbutt_handle, 'Visible', 'off');
    set(figure_handle, 'Visible', 'on');
end;


if strcmp(action,'cancel2'),
    set(figure_spatial_handle, 'Visible', 'off');
    set(figure_preview_handle,'Visible', 'on');
end;


%frequency filters -------------------------------------------------------
if strcmp(action,'low pass'),
    set(groot,'CurrentFigure',figure_image2_handle);
    set(figure_image2_handle,'Visible', 'off');
    was_color = false;
    
    type = menu('Choose a type','Ideal', 'Buttersworth', 'Gaussian');
    radius = inputdlg('Enter cutoff frequency');
    
    if isempty(radius)
        radius = 10;
    else
        radius = str2double(radius{1});
    end
    
    working_image = image_1_data;
    
    if size(working_image,3) == 3
        working_image = rgb2ycbcr(working_image);
        lecolor=working_image;
        working_image = working_image(:,:,1);
        was_color = true;
    elseif size(working_image,3) == 1
        was_color = false;
    end
    if type == 3
        order = inputdlg('Enter filter order');
        order = str2double(order{1});
    end
    
    set(figure_waitbutt_handle, 'Visible', 'on');
    
    working_image=im2double(working_image);
    working_spectrum=fft2_centered(working_image);      
    
    [height width]=size(working_image);
    filter=ones([height, width]);
    center_height=fix(height/2+.5);
    center_width=fix(width/2+.5);
    
    if type==1
        for x=1:height
            for y=1:width
                if D(x,y,center_height,center_width) <= radius
                    filter(x,y)=1;  
                else
                    filter(x,y)=0;
                end
            end
        end
    elseif type == 2
       for x=1:height
            for y=1:width
                filter(x,y)=exp(-1*(D(x,y,center_height,center_width).^2)/(2*(radius.^2)));
            end
       end
    elseif type == 3
        if isa(order, 'numeric')
            for x=1:height
                for y=1:width
                    filter(x,y)=1/((1+D(x,y,center_height,center_width)/radius).^(2*order));
                end
            end
        end
    end
       
    filtered_spectrum=working_spectrum.*filter;
    image_2_data=abs(ifft2(filtered_spectrum));
   
    if isa(image_1_data,'double')
        image_2_data=im2double(image_2_data);
    elseif isa(image_1_data,'uint8')
        image_2_data=im2uint8(image_2_data);
    end
  
    if was_color
        lecolor(:,:,1)=image_2_data;
        image_2_data = ycbcr2rgb(lecolor);
    end
    
    set(figure_waitbutt_handle, 'Visible', 'off');
    set(figure_image2_handle, 'Visible', 'on');
    imshow(image_2_data);
    set(figure_handle, 'Visible', 'on');
    set(figure_freq_handle, 'Visible', 'off');
end;


if strcmp(action,'high pass'),
    set(groot,'CurrentFigure',figure_image2_handle);
    set(figure_image2_handle,'Visible', 'off');
    was_color = false;
    
    type = menu('Choose a type','Ideal', 'Buttersworth', 'Gaussian');
    radius = inputdlg('Enter cutoff frequency');
    
    if isempty(radius)
        radius = 10;
    else
        radius = str2double(radius{1});
    end
    if type == 3
        order = inputdlg('Enter filter order');
        order = str2double(order{1});
    end
    
    set(figure_waitbutt_handle, 'Visible', 'on');
    
    working_image = image_1_data;
    
    if size(working_image,3) == 3
        working_image = rgb2ycbcr(working_image);
        lecolor=working_image;
        working_image = working_image(:,:,1);
        was_color = true;
    elseif size(working_image,3) == 1
        was_color = false;
    end
    
    working_image=im2double(working_image);
    working_spectrum=fft2_centered(working_image);      
    
    [height width]=size(working_image);
    filter=ones([height, width]);
    center_height=fix(height/2+.5);
    center_width=fix(width/2+.5);
    
    if type==1
        for x=1:height
            for y=1:width
                if D(x,y,center_height,center_width) <= radius
                    filter(x,y)=1;  
                else
                    filter(x,y)=0;
                end
            end
        end
    elseif type == 2
       for x=1:height
            for y=1:width
                filter(x,y)=exp(-1*(D(x,y,center_height,center_width).^2)/(2*(radius.^2)));
            end
       end
    elseif type == 3
        if isa(order, 'numeric')
            for x=1:height
                for y=1:width
                    filter(x,y)=1/((1+D(x,y,center_height,center_width)/radius).^(2*order));
                end
            end
        end
    end
    
    filter = 1-filter;
    filtered_spectrum=working_spectrum.*filter;
    image_2_data=abs(ifft2(filtered_spectrum));
    
    if isa(image_1_data,'double')
        image_2_data=im2double(image_2_data);
    elseif isa(image_1_data,'uint8')
        image_2_data=im2uint8(image_2_data);
    end
    
    if was_color
        lecolor(:,:,1)=image_2_data;
        image_2_data = ycbcr2rgb(lecolor);
    end
    
    set(figure_waitbutt_handle, 'Visible', 'off');
    set(figure_image2_handle, 'Visible', 'on');
    imshow(image_2_data);
    set(figure_handle, 'Visible', 'on');
    set(figure_freq_handle, 'Visible', 'off');
end;


if strcmp(action,'high boost'),
    set(groot,'CurrentFigure',figure_image2_handle);
    set(figure_image2_handle,'Visible', 'off');
    was_color = false;
    
    type = menu('Choose a type','Ideal', 'Buttersworth', 'Gaussian');
    radius = inputdlg('Enter cutoff frequency');
    boost = inputdlg('Endter highboost factor');
    
    if isempty(radius)
        radius = 10;
    else
        radius = str2double(radius{1});
    end
    if isempty(boost)
        boost = 10;
    else
        boost = str2double(boost{1});
    end
    if type == 3
        order = inputdlg('Enter filter order');
        order = str2double(order{1});
    end
    
    set(figure_waitbutt_handle, 'Visible', 'on');
    
    working_image = image_1_data;
    
    if size(working_image,3) == 3
        working_image = rgb2ycbcr(working_image);
        lecolor=working_image;
        working_image = working_image(:,:,1);
        was_color = true;
    elseif size(working_image,3) == 1
        was_color = false;
    end
    
    working_image=im2double(working_image);
    working_spectrum=fft2_centered(working_image);      
    
    [height width]=size(working_image);
    filter=ones([height, width]);
    center_height=fix(height/2+.5);
    center_width=fix(width/2+.5);
    
    if type==1
        for x=1:height
            for y=1:width
                if D(x,y,center_height,center_width) <= radius
                    filter(x,y)=1;  
                else
                    filter(x,y)=0;
                end
            end
        end
    elseif type == 2
       for x=1:height
            for y=1:width
                filter(x,y)=exp(-1*(D(x,y,center_height,center_width).^2)/(2*(radius.^2)));
            end
       end
    elseif type == 3
        if isa(order, 'numeric')
            for x=1:height
                for y=1:width
                    filter(x,y)=1/((1+D(x,y,center_height,center_width)/radius).^(2*order));
                end
            end
        end
    end
    
    filter = 1-filter;
    filtered_spectrum=working_spectrum.*filter;
    image_2_data=abs(ifft2(filtered_spectrum));
   
    if isa(image_1_data,'double')
        image_2_data=im2double(image_2_data);
    elseif isa(image_1_data,'uint8')
        image_2_data=im2uint8(image_2_data);
    end
  
    
    if was_color
        lecolor(:,:,1)=image_2_data;
        image_2_data = ycbcr2rgb(lecolor);
    end
    
    image_2_data = boost*image_1_data.*(1+image_2_data);
    set(figure_waitbutt_handle, 'Visible', 'off');
    set(figure_image2_handle, 'Visible', 'on');
    imshow(image_2_data);
    set(figure_handle, 'Visible', 'on');
    set(figure_freq_handle, 'Visible', 'off');
end;


if strcmp(action,'band pass'),
    set(groot,'CurrentFigure',figure_image2_handle);
    set(figure_image2_handle,'Visible', 'off');
    was_color = false;
    
    type = menu('Choose a type','Ideal', 'Buttersworth', 'Gaussian');
    lower = inputdlg('Enter lower cutoff frequency');    
    upper = inputdlg('Enter upper cutoff frequency');
    
    if isempty(lower)
        lower = 10;
    else
        lower = str2double(lower{1});
    end
    if isempty(upper)
        upper = 10;
    else
        upper = str2double(upper{1});
    end
    
    if type == 3
        order = inputdlg('Enter filter order');
        order = str2double(order{1});
    end
    
    set(figure_waitbutt_handle, 'Visible', 'on');
    
    inner_radius=min(lower,upper);
    outer_radius=max(lower,upper);
    
    working_image = image_1_data;
    
    if size(working_image,3) == 3
        working_image = rgb2ycbcr(working_image);
        lecolor=working_image;
        working_image = working_image(:,:,1);
        was_color = true;
    elseif size(working_image,3) == 1
        was_color = false;
    end
    
    working_image=im2double(working_image);
    working_spectrum=fft2_centered(working_image);      
    
    [height width]=size(working_image);
    filter=ones([height, width]);
    center_height=fix(height/2+.5);
    center_width=fix(width/2+.5);
    
    if type==1
        for x=1:height
            for y=1:width
                if D(x,y,center_height,center_width) >= inner_radius & D(x,y,center_height,center_width) <= outer_radius
                    filter(x,y)=1;  
                else
                    filter(x,y)=0;
                end
            end
        end
    elseif type == 2
        for x=1:height
            for y=1:width
                    filter(x,y)=(1-exp(-1*(D(x,y,center_height,center_width).^2)/(2*(inner_radius.^2))))*exp(-1*(D(x,y,center_height,center_width).^2)/(2*(outer_radius.^2)));
            end
        end
    elseif type == 3
        if isa(order, 'numeric')
        for x=1:height
            for y=1:width
                if D(x,y,center_height,center_width) > 0
                    filter(x,y)=(1/((1+inner_radius/D(x,y,center_height,center_width)).^(2*order))).*(1/((1+D(x,y,center_height,center_width)/outer_radius).^(2*order)));
                else
                    filter(x,y)=0;
                end
            end
        end
        end
    end
    
    filtered_spectrum=working_spectrum.*filter;
    image_2_data=abs(ifft2(filtered_spectrum));
   
    if isa(image_1_data,'double')
        image_2_data=im2double(image_2_data);
    elseif isa(image_1_data,'uint8')
        image_2_data=im2uint8(image_2_data);
    end
     
    if was_color
        lecolor(:,:,1)=image_2_data;
        image_2_data = ycbcr2rgb(lecolor);
    end
    
    set(figure_waitbutt_handle, 'Visible', 'off');
    set(figure_image2_handle, 'Visible', 'on');
    imshow(image_2_data);
    set(figure_handle, 'Visible', 'on');
    set(figure_freq_handle, 'Visible', 'off');
end;


if strcmp(action,'band stop'),
    set(groot,'CurrentFigure',figure_image2_handle);
    set(figure_image2_handle,'Visible', 'off');
    was_color = false;
    
    type = menu('Choose a type','Ideal', 'Buttersworth', 'Gaussian');
    lower = inputdlg('Enter lower cutoff frequency');    
    upper = inputdlg('Enter upper cutoff frequency');
    
    if isempty(lower)
        lower = 10;
    else
        lower = str2double(lower{1});
    end
    if isempty(upper)
        upper = 10;
    else
        upper = str2double(upper{1});
    end
    if type == 3
        order = inputdlg('Enter filter order');
        order = str2double(order{1});
    end
    
    set(figure_waitbutt_handle, 'Visible', 'on');
    
    inner_radius=min(lower,upper);
    outer_radius=max(lower,upper);
    
    working_image = image_1_data;
    
    if size(working_image,3) == 3
        working_image = rgb2ycbcr(working_image);
        lecolor=working_image;
        working_image = working_image(:,:,1);
        was_color = true;
    elseif size(working_image,3) == 1
        was_color = false;
    end
    
    working_image=im2double(working_image);
    working_spectrum=fft2_centered(working_image);      
    
    [height width]=size(working_image);
    filter=ones([height, width]);
    center_height=fix(height/2+.5);
    center_width=fix(width/2+.5);
    
    if type==1
        for x=1:height
            for y=1:width
                if D(x,y,center_height,center_width) >= inner_radius & D(x,y,center_height,center_width) <= outer_radius
                    filter(x,y)=1;  
                else
                    filter(x,y)=0;
                end
            end
        end
    elseif type == 2
        for x=1:height
            for y=1:width
                    filter(x,y)=(1-exp(-1*(D(x,y,center_height,center_width).^2)/(2*(inner_radius.^2))))*exp(-1*(D(x,y,center_height,center_width).^2)/(2*(outer_radius.^2)));
            end
        end
    elseif type == 3
        if isa(order, 'numeric')
        for x=1:height
            for y=1:width
                if D(x,y,center_height,center_width) > 0
                    filter(x,y)=(1/((1+inner_radius/D(x,y,center_height,center_width)).^(2*order))).*(1/((1+D(x,y,center_height,center_width)/outer_radius).^(2*order)));
                else
                    filter(x,y)=0;
                end
            end
        end
        end
    end
    
    filter = 1-filter;
    filtered_spectrum=working_spectrum.*filter;
    image_2_data=abs(ifft2(filtered_spectrum));
   
    if isa(image_1_data,'double')
        image_2_data=im2double(image_2_data);
    elseif isa(image_1_data,'uint8')
        image_2_data=im2uint8(image_2_data);
    end
  
    
    if was_color
        lecolor(:,:,1)=image_2_data;
        image_2_data = ycbcr2rgb(lecolor);
    end
    
    set(figure_waitbutt_handle, 'Visible', 'off');
    set(figure_image2_handle, 'Visible', 'on');
    imshow(image_2_data);
    set(figure_handle, 'Visible', 'on');
    set(figure_freq_handle, 'Visible', 'off');
end;


if strcmp(action,'homo'),
    set(groot,'CurrentFigure',figure_image2_handle);
    set(figure_image2_handle,'Visible', 'off');
    was_color = false;
    
    type = menu('Choose a type','Ideal', 'Buttersworth', 'Gaussian');
    radius = inputdlg('Enter cutoff frequency');
    gammal = inputdlg('Enter lower gamma limit');
    gammah = inputdlg('Enter upper gamma limit');
    
    if isempty(radius)
        radius = 10;
    else
        radius = str2double(radius{1});
    end
    if isempty(gammal)
        gammal = 10;
    else
        gammal = str2double(gammal{1});
    end
    if isempty(gammah)
        gammah = 50;
    else
        gammah = str2double(gammah{1});
    end   
    if type == 3
        order = inputdlg('Enter filter order');
        order = str2double(order{1});
    end
    
    set(figure_waitbutt_handle, 'Visible', 'on');
    
    working_image = image_1_data;
    
    if size(working_image,3) == 3
        working_image = rgb2ycbcr(working_image);
        lecolor=working_image;
        working_image = working_image(:,:,1);
        was_color = true;
    elseif size(working_image,3) == 1
        was_color = false;
    end
    
    working_image=im2double(working_image);
    working_spectrum=fft2_centered(working_image);      
    
    [height width]=size(working_image);
    filter=ones([height, width]);
    center_height=fix(height/2+.5);
    center_width=fix(width/2+.5);
    
    if type==1
        for x=1:height
            for y=1:width
                if D(x,y,center_height,center_width) <= radius
                    filter(x,y)=1;  
                else
                    filter(x,y)=0;
                end
            end
        end
    elseif type == 2
       for x=1:height
            for y=1:width
                filter(x,y)=exp(-1*(D(x,y,center_height,center_width).^2)/(2*(radius.^2)));
            end
       end
    elseif type == 3
        if isa(order, 'numeric')
            for x=1:height
                for y=1:width
                    filter(x,y)=1/((1+D(x,y,center_height,center_width)/radius).^(2*order));
                end
            end
        end
    end
    
    filter = 1-filter;
    filter=((gammah-gammal)*filter)+gammal;
    filtered_spectrum=working_spectrum.*filter;
    image_2_data=abs(ifft2(filtered_spectrum));
      
    if max(max(image_2_data))>1.0
        image_2_data=image_2_data/max(max(image_2_data));
    end
    
    if isa(image_1_data,'double')
        image_2_data=im2double(image_2_data);
    elseif isa(image_1_data,'uint8')
        image_2_data=im2uint8(image_2_data);
    end
    
    if was_color
        lecolor(:,:,1)=image_2_data;
        image_2_data = ycbcr2rgb(lecolor);
    end
    
    set(figure_waitbutt_handle, 'Visible', 'off');
    set(figure_image2_handle, 'Visible', 'on');
    imshow(image_2_data);
    set(figure_handle, 'Visible', 'on');
    set(figure_freq_handle, 'Visible', 'off');
end;


if strcmp(action,'cancel3'),
    set(figure_freq_handle, 'Visible', 'off');
    set(figure_preview_handle,'Visible', 'on');
end;


% if matlab takes to long, entertain yourself with button ----------------
if strcmp(action,'wait'),
    set(groot, 'CurrentFigure', figure_waitbutt_handle);
    randomNum = randi([100 600], 1, 4);
    
    i = randomNum(1);
    j = randomNum(2);
    k = randomNum(3);
    l = randomNum(4);
    set(figure_waitbutt_handle,'Position', [i j k l]);
end;

% functions used in frequency domain calculations ------------------------
function [spectrum]=fft2_centered(picture)
[height width]=size(picture);
picture2=zeros(height,width);
for x=1:height
   for y=1:width
      picture2(x,y)=picture(x,y)*((-1)^(x+y));
   end
end
spectrum=fft2(picture2);

function [distance] = D(x1,y1,x2,y2)
distance=sqrt((x1-x2).^2 + (y1-y2).^2);
return


