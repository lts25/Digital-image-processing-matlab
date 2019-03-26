function [varargout]=Project_Final_Spring_2018(varargin)
%Levi Stalsworth
%This is a program to apply various filters to a selected image
%all filters can be selected through the button menus
%filters are previewed before being manually applied
%Spatial                        Frequency            morphological
%low-passs                      low-pass             structuring element
%high-pass                      high-pass            erosion
%highboost                      highboost            dilation
%brightness                     band-pass            opening
%contras                        band-stop            closing
%histogram equalization         homomorphic          boundary
%adaptive histogram equalization                     morphological smoothing          
%                                                    morphological gradient
%                                                    color mask
%                                                    object recognition          
%additional information on the selected filter may be needed to apply it
%the only known issue(other than not checking input is correct)
%is that the nxn structuring element identifies nxn squares, and nxm or 
%mx6n rectangles and vice versa with the other respective structuring 
%elements. The only thing I could find on how to fix this problem was in 
%the last slide in the last lecture, which had no suggestion on how to deal
%with the problem in matlab, so I had to leave it as is.

function_name='Project_Final_Spring_2018';

global figure_handle
global buttons
global figure_preview_handle
global previews
global figure_spatial_handle
global spatials
global figure_freq_handle
global freqs
global figure_morph_handle
global morphs
global figure_image1_handle
global image_1_data
global figure_image2_handle
global image_2_data
global waitbutt
global figure_waitbutt_handle
global SE


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
    'Name','Mighty Morphin filters',...
    'CallbackCommand','morph');
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


% buttons for mighty morphin filters -------------------------------------
morphs=[]; 
one_button=struct(...
    'Name','Select A Structuring Element (preset to a 3x3 square)',...
    'CallbackCommand','strel');
morphs=[morphs;one_button];

one_button=struct(...
    'Name','Color Mask',...
    'CallbackCommand','colour');
morphs=[morphs;one_button];

one_button=struct(...
    'Name','Erosion',...
    'CallbackCommand','erosion');
morphs=[morphs;one_button];

one_button=struct(...
    'Name','Dilation (OW MY EYE!)',...
    'CallbackCommand','dilation');
morphs=[morphs;one_button];

one_button=struct(...
    'Name','Opening',...
    'CallbackCommand','opening');
morphs=[morphs;one_button];

one_button=struct(...
    'Name','Closing',...
    'CallbackCommand','closing');
morphs=[morphs;one_button];

one_button=struct(...
    'Name','Boundrary',...
    'CallbackCommand','boundary');
morphs=[morphs;one_button];

one_button=struct(...
    'Name','Mighty Morphing (Morphological smoothing)',...
    'CallbackCommand','mighty morphing');
morphs=[morphs;one_button];

one_button=struct(...
    'Name','Gradually Morphing (Morphological gradient)',...
    'CallbackCommand','gradually morphing');
morphs=[morphs;one_button];

one_button=struct(...
    'Name','Object Recognition',...
    'CallbackCommand','object');
morphs=[morphs;one_button];

one_button=struct(...
    'Name','Cancel',...
    'CallbackCommand','cancel4');
morphs=[morphs;one_button];

NumberOfMorphs=size(morphs,1);


if nargin<1,
    action='initialize';
else
    action=varargin{1};
end;

%initializes each handle -------------------------------------------------
if strcmp(action,'initialize'),
    
    %wait handle ---------------------------------------------------------
    bottom=400;
    left=400;
    height=400;
    width=400;
    figure_waitbutt_handle=figure( ...
        'Name','It''s Morphin Time', ...
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
     
    %morph handle --------------------------------------------------------
    bottom=100;
    left=200;
    height=600;
    width=300;
    figure_morph_handle=figure( ...
        'Name','It''s Morphin Time', ...
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
         'BackgroundColor',[1 .5 .5]);  

    button_morph_left=0.02;
    button_morph_width=0.96;
    button_morph_height=1.0/NumberOfMorphs;
    
    for ButtonMorphNumber=1:NumberOfMorphs
        morphPos=[button_morph_left (1 + (button_morph_height*0.025)-...
            (ButtonMorphNumber)*button_morph_height) button_morph_width ...
            (button_morph_height*0.95)];
        morphcallbackStr=strcat(function_name,...
            '(''',morphs(ButtonMorphNumber).CallbackCommand,''')');
    uicontrol( ...
        'Style','pushbutton', ...
        'Units','normalized', ...
        'Position',morphPos, ...
        'String',morphs(ButtonMorphNumber).Name, ...
        'Callback',morphcallbackStr );
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

if strcmp(action,'morph'),
    set(figure_preview_handle, 'Visible', 'off');
    SE = strel('square',3);
    set(figure_morph_handle,'Visible', 'on');
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

    set(figure_image2_handle,'Visible', 'on');
    imshow(image_2_data);
    set(figure_handle, 'Visible', 'on');
    set(figure_waitbutt_handle, 'Visible', 'off');
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

    set(figure_handle, 'Visible', 'on');
    set(figure_waitbutt_handle, 'Visible', 'off');
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
    
    set(figure_handle, 'Visible', 'on');
    set(figure_waitbutt_handle, 'Visible', 'off');
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

	set(figure_handle, 'Visible', 'on');  
    set(figure_waitbutt_handle, 'Visible', 'off');
end;


if strcmp(action,'contra'),
    set(groot,'CurrentFigure',figure_image2_handle);
    set(figure_image2_handle,'Visible', 'off');
    set(figure_spatial_handle, 'Visible', 'off');
	
	contra = inputdlg('Enter float for contras adjustment');
    contra = str2double(contra{1});
    
    set(figure_waitbutt_handle, 'Visible', 'on');
    
	image_2_data = image_1_data * contra;
	
	set(figure_image2_handle,'Visible', 'on');
    imshow(image_2_data);
    set(figure_handle, 'Visible', 'on');
    set(figure_waitbutt_handle, 'Visible', 'off');
end;


if strcmp(action,'histeq'),
    set(groot,'CurrentFigure',figure_image2_handle);
	set(figure_image2_handle, 'Visible', 'off');
    set(figure_spatial_handle, 'Visible', 'off');  
    set(figure_waitbutt_handle, 'Visible', 'on');

	image_2_data = histeq(image_1_data);

	set(figure_image2_handle,'Visible', 'on');
    imshow(image_2_data);
	
    set(figure_handle, 'Visible', 'on');
    set(figure_waitbutt_handle, 'Visible', 'off');
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

    set(figure_handle, 'Visible', 'on');
    set(figure_waitbutt_handle, 'Visible', 'off');
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

    set(figure_image2_handle, 'Visible', 'on');
    imshow(image_2_data);
    set(figure_handle, 'Visible', 'on');
    set(figure_freq_handle, 'Visible', 'off');
    set(figure_waitbutt_handle, 'Visible', 'off');
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
    
    set(figure_image2_handle, 'Visible', 'on');
    imshow(image_2_data);
    set(figure_handle, 'Visible', 'on');
    set(figure_freq_handle, 'Visible', 'off');
    set(figure_waitbutt_handle, 'Visible', 'off');
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
    set(figure_image2_handle, 'Visible', 'on');
    imshow(image_2_data);
    set(figure_handle, 'Visible', 'on');
    set(figure_freq_handle, 'Visible', 'off');
    set(figure_waitbutt_handle, 'Visible', 'off');
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
    
    set(figure_image2_handle, 'Visible', 'on');
    imshow(image_2_data);
    set(figure_handle, 'Visible', 'on');
    set(figure_freq_handle, 'Visible', 'off');
    set(figure_waitbutt_handle, 'Visible', 'off');
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
    
    set(figure_image2_handle, 'Visible', 'on');
    imshow(image_2_data);
    set(figure_handle, 'Visible', 'on');
    set(figure_freq_handle, 'Visible', 'off');
    set(figure_waitbutt_handle, 'Visible', 'off');
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
    
    set(figure_image2_handle, 'Visible', 'on');
    imshow(image_2_data);
    set(figure_handle, 'Visible', 'on');
    set(figure_freq_handle, 'Visible', 'off');
    set(figure_waitbutt_handle, 'Visible', 'off');
end;


if strcmp(action,'cancel3'),
    set(figure_freq_handle, 'Visible', 'off');
    set(figure_preview_handle,'Visible', 'on');
end;


%morphological filters ---------------------------------------------------
if strcmp(action,'strel'),
    set(figure_morph_handle, 'Visible', 'off');
    
    SE = toStrel();

    set(figure_morph_handle, 'Visible', 'on');
end;


if strcmp(action,'colour'),
    set(groot,'CurrentFigure',figure_image2_handle);
    set(figure_image2_handle,'Visible', 'off');
    set(figure_morph_handle, 'Visible', 'off');
       
    image_2_data = cooler(image_1_data);
 
    set(figure_image2_handle,'Visible', 'on');
    imshow(image_2_data);
    set(figure_handle,'Visible','on');
end;


if strcmp(action,'erosion'),
    set(groot,'CurrentFigure',figure_image2_handle);
    set(figure_image2_handle,'Visible', 'off');
    set(figure_morph_handle, 'Visible', 'off');
    
    set(figure_waitbutt_handle, 'Visible', 'on');
    
	image_2_data = imerode(image_1_data, SE);
	
	set(figure_image2_handle, 'Visible', 'on');
    imshow(image_2_data);

	set(figure_handle, 'Visible', 'on');  
    set(figure_waitbutt_handle, 'Visible', 'off');
end;


if strcmp(action,'dilation'),
    set(groot,'CurrentFigure',figure_image2_handle);
    set(figure_image2_handle,'Visible', 'off');
    set(figure_morph_handle, 'Visible', 'off');
    
    set(figure_waitbutt_handle, 'Visible', 'on');
    
	image_2_data = imdilate(image_1_data, SE);
	
	set(figure_image2_handle, 'Visible', 'on');
    imshow(image_2_data);

	set(figure_handle, 'Visible', 'on');  
    set(figure_waitbutt_handle, 'Visible', 'off');
end;


if strcmp(action,'opening'),
    set(groot,'CurrentFigure',figure_image2_handle);
    set(figure_image2_handle,'Visible', 'off');
    set(figure_morph_handle, 'Visible', 'off');
    
    set(figure_waitbutt_handle, 'Visible', 'on');
    
	image_2_data = imopen(image_1_data, SE);
	
	set(figure_image2_handle, 'Visible', 'on');
    imshow(image_2_data);

	set(figure_handle, 'Visible', 'on');  
    set(figure_waitbutt_handle, 'Visible', 'off');
end;


if strcmp(action,'closing'),
    set(groot,'CurrentFigure',figure_image2_handle);
    set(figure_image2_handle,'Visible', 'off');
    set(figure_morph_handle, 'Visible', 'off');
    
    set(figure_waitbutt_handle, 'Visible', 'on');
    
	image_2_data = imclose(image_1_data, SE);
	
	set(figure_image2_handle, 'Visible', 'on');
    imshow(image_2_data);

	set(figure_handle, 'Visible', 'on');  
    set(figure_waitbutt_handle, 'Visible', 'off');
end;


if strcmp(action,'boundary'),
    set(groot,'CurrentFigure',figure_image2_handle);
    set(figure_image2_handle,'Visible', 'off');
    set(figure_morph_handle, 'Visible', 'off');
    
    set(figure_waitbutt_handle, 'Visible', 'on');
    
    intermediate = imerode(image_1_data, SE);
	image_2_data = image_1_data-intermediate;
	
	set(figure_image2_handle, 'Visible', 'on');
    imshow(image_2_data);

	set(figure_handle, 'Visible', 'on');  
    set(figure_waitbutt_handle, 'Visible', 'off');
end;


if strcmp(action,'mighty morphing'),
    set(groot,'CurrentFigure',figure_image2_handle);
    set(figure_image2_handle,'Visible', 'off');
    set(figure_morph_handle, 'Visible', 'off');
    
    set(figure_waitbutt_handle, 'Visible', 'on');
    
	image_2_data = imclose(imopen(image_1_data, SE), SE);
	
	set(figure_image2_handle, 'Visible', 'on');
    imshow(image_2_data);

	set(figure_handle, 'Visible', 'on');  
    set(figure_waitbutt_handle, 'Visible', 'off');
end;


if strcmp(action,'gradually morphing'),
    set(groot,'CurrentFigure',figure_image2_handle);
    set(figure_image2_handle,'Visible', 'off');
    set(figure_morph_handle, 'Visible', 'off');
    
    set(figure_waitbutt_handle, 'Visible', 'on');
    
	image_2_data = imdilate(image_1_data, SE) - imerode(image_1_data, SE);
	
	set(figure_image2_handle, 'Visible', 'on');
    imshow(image_2_data);

	set(figure_handle, 'Visible', 'on');  
    set(figure_waitbutt_handle, 'Visible', 'off');
end;

if strcmp(action,'object'),
    set(groot,'CurrentFigure',figure_image2_handle);
    set(figure_image2_handle,'Visible', 'off');
    set(figure_morph_handle, 'Visible', 'off');
    doColor = 1;
    doColor = menu('Do you want to use a color mask?', 'Yes', 'No');
    
    working_image = image_1_data;
    [rows columns] = size(working_image);
    
    rowf = working_image(1,:);
    rowl = working_image(rows,:);
    colf = working_image(:,1);
    coll = working_image(:,columns);

    modes = [mode(rowf),mode(rowl),mode(colf),mode(coll)];
    back_color = mode(modes);
    
    if doColor == 1
        color_mask = cooler(working_image);
        working_image = color_mask;
    end
    
    [se sse] = toStrel();
    small_struct_mask = imerode(working_image,sse);
    small_struct_mask = imdilate(small_struct_mask,sse);
    
    big_struct_mask = imerode(small_struct_mask,se);
    big_struct_mask = imdilate(big_struct_mask,se);
    
    struct_mask = small_struct_mask - big_struct_mask;
    
    if doColor == 1
        if size(image_1_data,3)==3
            struct_mask = cat(3,struct_mask,struct_mask,struct_mask);
        end
    end
    
    if strcmp(class(image_1_data), 'uint8')
        struct_mask_final = uint8(struct_mask);
        struct_maskI = uint8(imcomplement(struct_mask));
    else
        struct_mask_final = struct_mask;
        struct_maskI = imcomplement(struct_mask);
    end
    
    if doColor == 1
        image_2_data = (struct_mask_final.*image_1_data) + (struct_maskI*back_color);
    else
        image_2_data = struct_mask;
    end
    
    set(figure_image2_handle,'Visible','on');
    imshow(image_2_data);
   

	set(figure_handle, 'Visible', 'on');  
    set(figure_waitbutt_handle, 'Visible', 'off');
end;


if strcmp(action,'cancel4'),
    set(figure_morph_handle, 'Visible', 'off');
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


%functions used in morphological options ---------------------------------
function [element] = cooler(image_1_data)
	% create image to work with.
	rgbImage = image_1_data;
	[rows columns numberOfColorBands] = size(image_1_data);
	% If it's monochrome (indexed), convert it to color.
	% Check to see if it's an 8-bit image needed later for scaling).
	if strcmpi(class(rgbImage), 'uint8')
		% Flag for 256 gray levels.
		eightBit = true;
	else
		eightBit = false;
    end    
    
	if numberOfColorBands == 1
        prompt = {'Enter min Grayscale intensity', 'Enter max grayscale intensity'};
        title = 'Grayscale';
        dims = [1 35];
        definput = {'0','100'};
        answer = inputdlg(prompt,title,dims,definput);
        keycolorMin = str2double(answer{1});
        keycolorMax = str2double(answer{2});
        
        keyplane=image_1_data;
        color_mask=double(keycolorMin < keyplane & keyplane < keycolorMax);
    elseif numberOfColorBands == 3
        leHow = menu('Select type', 'RGB', 'HSV');
        
        if leHow == 1
            % Extract out the color bands from the original image
            % into 3 separate 2D arrays, one for each color component.
            redBand = rgbImage(:, :, 1);
            greenBand = rgbImage(:, :, 2);
            blueBand = rgbImage(:, :, 3);
            
            % Now select thresholds for the 3 color bands.
            prompt = {'Enter min red', 'Enter max red'};
            title = 'Red';
            dims = [1 35];
            mayber = graythresh(redBand);
            mayber = num2str(mayber);
            definput = {'0', mayber};
            %definput = {mayber,'255'};
            answer = inputdlg(prompt,title,dims,definput);
            rd = str2double(answer{1});
            rh = str2double(answer{2});
            
            prompt = {'Enter min green', 'Enter max green'};
            title = 'Green';
            dims = [1 35];
            maybeg = graythresh(greenBand);
            maybeg = num2str(maybeg);
            definput = {maybeg, '255'};
            %definput = {'0',maybeg};
            answer = inputdlg(prompt,title,dims,definput);
            gd = str2double(answer{1});
            gh = str2double(answer{2});
            
            
            prompt = {'Enter min blue', 'Enter max blue'};
            title = 'Blue';
            dims = [1 35];
            maybeb = graythresh(blueBand);
            maybeb = num2str(maybeb);
            definput = {'0',maybeb};
            answer = inputdlg(prompt,title,dims,definput);
            bd = str2double(answer{1});
            bh = str2double(answer{2});           
            
            redMask = zeros(rows, columns);
            greenMask = zeros(rows, columns);
            blueMask = zeros(rows, columns);
            % Now apply each color band's particular thresholds to the color band
            redMask = double((redBand >= rd) & (redBand <= rh));
            greenMask = double((greenBand >= gd) & (greenBand <= gh));
            blueMask = double((blueBand >= bd) & (blueBand <= bh));
            
            color_mask = zeros(rows, columns);
            
            
            color_mask = double(redMask & greenMask & blueMask);
        elseif leHow == 2
            hsvVersion=rgb2hsv(image_1_data);
            
            prompt = {'Enter min Hue', 'Enter max Hue'};
            title = 'Hue';
            dims = [1 35];
            definput = {'0','255'};
            answer = inputdlg(prompt,title,dims,definput);
            hb = str2double(answer{1});
            hh = str2double(answer{2});
            keyplaneHue=image_1_data(:,:,1);
            
            prompt = {'Enter min Saturation', 'Enter max Saturation'};
            title = 'Saturation';
            dims = [1 35];
            definput = {'0','255'};
            answer = inputdlg(prompt,title,dims,definput);
            sb = str2double(answer{1});
            sh = str2double(answer{2});
            keyplaneSaturation=image_1_data(:,:,2);
            
            prompt = {'Enter min value', 'Enter max value'};
            title = 'Value';
            dims = [1 35];
            definput = {'0','255'};
            answer = inputdlg(prompt,title,dims,definput);
            vb = str2double(answer{1});
            vh = str2double(answer{2});
            keyplaneValue=image_1_data(:,:,3);
            
            hueMask = double((hb < keyplaneHue) & (keyplaneHue < hh));
            saturationMask = double((sb < keyplaneSaturation) & (keyplaneSaturation < sh));
            valueMask = double((vb < keyplaneValue) & (keyplaneValue < vh));
            
            color_mask = (hueMask & saturationMask & valueMask);
        end
    end
    element = color_mask;
return

function [element sElement] = toStrel()   
    shape = menu('Choose a shape','diamond', 'disk', 'line', 'octagon', 'rectangle', 'square');
    
    if shape == 1
        r = inputdlg('Enter radius');
        r = str2double(r{1});
        sr = r-1;
        SE = strel('diamond',r);
        sSE = strel('diamond',sr);
    end
    if shape == 2   
        r = inputdlg('Enter radius');
        r = str2double(r{1});
        n = inputdlg('enter number of line structuring elements used to approximate the disk shape, must be 0, 6, 4, or 8'); 
        n = str2double(n{1});
        sr = r-1;
        SE = strel('disk',r,n);
        sSE = strel('disk',sr,n);
    end
    if shape == 3
        len = inputdlg('Enter length');
        len = str2double(len{1});        
        deg = inputdlg('Enter angle (degrees)');
        deg = str2double(deg{1});
        slen = len-1;
        SE = strel('line',len,deg);
        sSE = strel('line',slen,deg);
    end
    if shape == 4
        r = inputdlg('Enter radius, must be a nonnegative multiple of 3');
        r = str2double(r{1});
        sr = r-3;
        SE = strel('octagon',r);
        sSE = strel('octagon',sr);
    end
    if shape == 5
        l = inputdlg('Enter length size');
        l = str2double(l{1});
        w = inputdlg('Enter width size');
        w = str2double(w{1});
        lw = [l w];
        slw = [(l-1) (w-1)];
        SE = strel('rectangle', lw);
        sSE = strel('rectangle', slw);
    end
    if shape == 6
        w = inputdlg('Enter side length');
        w = str2double(w{1});
        sw = w - 1;
        SE = strel('square',w);
        sSE = strel('square',sw);
    end
    element = SE;
    sElement = sSE;
return



