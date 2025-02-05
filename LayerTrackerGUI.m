
clear; clc; 

components.file_name = '20181219_035408.mat';

load(components.file_name)

components.data = wiener2_modified(:,1000:1800);


%% Build GUI 

components.fig = uifigure("Position",[50 100 1350 690],'Name','Layer Tracker GUI');

g = uigridlayout(components.fig);
g.RowHeight = {'1x','0.75x','1x','0.75x','5x','1x','1x','1x','1x','1x'};
g.ColumnWidth = {'10x','1x','1x'};

components.ax = uiaxes(g);
components.ax.Layout.Row = [1 10];
components.ax.Layout.Column = 1;
grid(components.ax,'on')
components.ax.Color = 'w';
components.ax.Title.String = 'Manually Track The Layers';
imagesc(components.ax,components.data,'HitTest','off'); 
hold(components.ax,'on')
colormap(components.ax,1-gray)
components.ax.XLim = [0 size(components.data,2)];
components.ax.YLim = [0 size(components.data,1)];

components.xlimit_label = uilabel(g,"Text","Insert X Limits");
components.xlimit_label.Layout.Row = 3;
components.xlimit_label.Layout.Column = [2 3];
components.xlimit_label.HorizontalAlignment = 'center';

components.ylimit_label = uilabel(g,"Text","Insert Y Limits");
components.ylimit_label.Layout.Row = 1;
components.ylimit_label.Layout.Column = [2 3];
components.ylimit_label.HorizontalAlignment = 'center';

components.x_lower = uieditfield(g,"numeric","Value",0);
components.x_lower.Layout.Row = 4;
components.x_lower.Layout.Column = 2;

components.x_higher = uieditfield(g,"numeric","Value",size(components.data,2));
components.x_higher.Layout.Row = 4;
components.x_higher.Layout.Column = 3;

components.y_lower = uieditfield(g,"numeric","Value",0);
components.y_lower.Layout.Row = 2;
components.y_lower.Layout.Column = 2;

components.y_higher = uieditfield(g,"numeric","Value",size(components.data,1));
components.y_higher.Layout.Row = 2;
components.y_higher.Layout.Column = 3;

components.new_layer_button = uibutton(g);
components.new_layer_button.Layout.Row = 6;
components.new_layer_button.Layout.Column = [2 3];
components.new_layer_button.Text = "New Layer";

components.erase_last_point = uibutton(g);
components.erase_last_point.Layout.Row = 7;
components.erase_last_point.Layout.Column = [2 3];
components.erase_last_point.Text = "Erase Last Point";

components.edit_track_button = uibutton(g);
components.edit_track_button.Layout.Row = 8;
components.edit_track_button.Layout.Column = [2 3];
components.edit_track_button.Text = "Edit Previous Track";

components.save_results_button = uibutton(g);
components.save_results_button.Layout.Row = 9;
components.save_results_button.Layout.Column = [2 3];
components.save_results_button.Text = "Save Results";

components.load_save_button = uibutton(g);
components.load_save_button.Layout.Row = 10;
components.load_save_button.Layout.Column = [2 3];
components.load_save_button.Text = "Load Previous Save";

components.num_cell = 1; 

g2 = uigridlayout(g);
g2.Layout.Row = 5;
g2.Layout.Column = [2 3];
g2.RowHeight = {'1x','1x','1x'};
g2.ColumnWidth = {'1x','1x','1x'};

components.zoom_in_button = uibutton(g2);
components.zoom_in_button.Layout.Row = 1;
components.zoom_in_button.Layout.Column = 1;
components.zoom_in_button.Text = 'Zoom In';

components.zoom_out_button = uibutton(g2);
components.zoom_out_button.Layout.Row = 3;
components.zoom_out_button.Layout.Column = 1;
components.zoom_out_button.Text = 'Zoom Out';

components.left_action_button = uibutton(g2);
components.left_action_button.Layout.Row = 2;
components.left_action_button.Layout.Column = 1;
components.left_action_button.Text = 'Left';

components.right_action_button = uibutton(g2);
components.right_action_button.Layout.Row = 2;
components.right_action_button.Layout.Column = 3;
components.right_action_button.Text = 'Right';

components.up_action_button = uibutton(g2);
components.up_action_button.Layout.Row = 1;
components.up_action_button.Layout.Column = 2;
components.up_action_button.Text = 'Up';

components.down_action_button = uibutton(g2);
components.down_action_button.Layout.Row = 3;
components.down_action_button.Layout.Column = 2;
components.down_action_button.Text = 'Down';

components.home_button = uibutton(g2);
components.home_button.Layout.Row = 2;
components.home_button.Layout.Column = 2;
components.home_button.Text = 'Home';

components.add_delete_option = uibutton(g2);
components.add_delete_option.Layout.Row = 1;
components.add_delete_option.Layout.Column = 3;
components.add_delete_option.Text = 'Adding';
set(components.add_delete_option,'FontColor','w')
set(components.add_delete_option,'BackgroundColor','b')


%% Connecting Everything

components.x_lower.ValueChangedFcn = @(src,event)change_limits(src,event,components);
components.x_higher.ValueChangedFcn = @(src,event)change_limits(src,event,components);
components.y_lower.ValueChangedFcn = @(src,event)change_limits(src,event,components);
components.y_higher.ValueChangedFcn = @(src,event)change_limits(src,event,components);

components.ax.ButtonDownFcn = @(src,event)plot_ButtonDownFcn(src,event,components);
components.erase_last_point.ButtonPushedFcn = @(src,event)delete_last_point(src,event,components);

components.new_layer_button.ButtonPushedFcn = @(src,event)new_layer(src,event,components);

components.save_results_button.ButtonPushedFcn = @(src,event)save_results(src,event,components);

components.load_save_button.ButtonPushedFcn = @(src,event)load_save(src,event,components);

components.zoom_in_button.ButtonPushedFcn = @(src,event)zoom_in(src,event,components);

components.zoom_out_button.ButtonPushedFcn = @(src,event)zoom_out(src,event,components);

components.left_action_button.ButtonPushedFcn = @(src,event)move_left(src,event,components);

components.right_action_button.ButtonPushedFcn = @(src,event)move_right(src,event,components);

components.up_action_button.ButtonPushedFcn = @(src,event)move_up(src,event,components);

components.down_action_button.ButtonPushedFcn = @(src,event)move_down(src,event,components);

components.home_button.ButtonPushedFcn = @(src,event)go_home(src,event,components);

components.edit_track_button.ButtonPushedFcn = @(src,event)edit_track(src,event,components);

components.add_delete_option.ButtonPushedFcn = @(src,event)add_delete_option(src,event,components);


%% Initialize handles / data that is changing from user selection

innit_handles.previous_tracks = cell(1);
innit_handles.previous_tracks{1} = [];
innit_handles.replot_flag = 0;
innit_handles.run_flag = 1;
innit_handles.current_track = [];
innit_handles.XLim = [0 size(components.data,2)];
innit_handles.YLim = [0 size(components.data,1)];
innit_handles.Home_X = [0 size(components.data,2)];
innit_handles.Home_Y = [0 size(components.data,1)];
innit_handles.edit_track_flag = 0;
innit_handles.deleting_flag = 0;

% This guidata command is used when handling data between functions within
% the GUI. IE this structure is stored in the figure components.fig, and
% this is useful when handling data that is constantly changing. However,
% whenever the data is not changing, I share it using the components
% structure for easy access (basically all the data and GUI buttons are
% in the components structure)
guidata(components.fig, innit_handles);

%% Functions 

function add_delete_option(hObject, eventdata,components)
handles = guidata(hObject);

if handles.deleting_flag == 0
    handles.deleting_flag = 1;
    set(components.add_delete_option,'Text','Deleting')
    set(components.add_delete_option,'BackgroundColor','r')
else 
    handles.deleting_flag = 0;
    set(components.add_delete_option,'Text','Adding')
    set(components.add_delete_option,'BackgroundColor','b')
end

guidata(hObject,handles)

run(components)

end

% Changes button appearance and changes the edit_track_flag to 0 or 1 so
% the next click will find the closest value of that click (keeps clicked
% points all in one function by only changing the flag)
function edit_track(hObject, eventdata,components)
handles = guidata(hObject);

if handles.edit_track_flag == 0
    handles.edit_track_flag = 1;
    set(components.edit_track_button,'BackgroundColor','r')
    set(components.edit_track_button,'FontColor','w')
else 
    handles.edit_track_flag = 0;
    set(components.edit_track_button,'BackgroundColor','w')
    set(components.edit_track_button,'FontColor','k')
end

guidata(hObject,handles)

run(components)

end

% Functionality for zooming and panning
function go_home(hObject, eventdata,components)
handles = guidata(hObject);

handles.XLim = handles.Home_X;
handles.YLim = handles.Home_Y;

components.x_lower.Value = handles.Home_X(1);
components.x_higher.Value = handles.Home_X(2);
components.y_lower.Value = handles.Home_Y(1);
components.y_higher.Value = handles.Home_Y(2);

guidata(hObject,handles)

run(components)

end

% Functionality for zooming and panning
function move_down(hObject, eventdata,components)
handles = guidata(hObject);

scale_factor = 0.1;

current_y_lim = handles.YLim;

dist_y = current_y_lim(2) - current_y_lim(1);

new_y_lim = [round(current_y_lim(1) + scale_factor * dist_y), round(current_y_lim(2) + scale_factor * dist_y)];

components.y_lower.Value = new_y_lim(1);
components.y_higher.Value = new_y_lim(2);

handles.YLim = new_y_lim;

guidata(hObject,handles)

run(components)

end

% Functionality for zooming and panning
function move_up(hObject, eventdata,components)
handles = guidata(hObject);

scale_factor = 0.1;

current_y_lim = handles.YLim;

dist_y = current_y_lim(2) - current_y_lim(1);

new_y_lim = [round(current_y_lim(1) - scale_factor * dist_y), round(current_y_lim(2) - scale_factor * dist_y)];

components.y_lower.Value = new_y_lim(1);
components.y_higher.Value = new_y_lim(2);

handles.YLim = new_y_lim;

guidata(hObject,handles)

run(components)

end

% Functionality for zooming and panning
function move_right(hObject, eventdata,components)
handles = guidata(hObject);

scale_factor = 0.1;

current_x_lim = handles.XLim;

dist_x = current_x_lim(2) - current_x_lim(1);

new_x_lim = [round(current_x_lim(1) + scale_factor * dist_x), round(current_x_lim(2) + scale_factor * dist_x)];

components.x_lower.Value = new_x_lim(1);
components.x_higher.Value = new_x_lim(2);

handles.XLim = new_x_lim;

guidata(hObject,handles)

run(components)

end

% Functionality for zooming and panning
function move_left(hObject, eventdata,components)
handles = guidata(hObject);

scale_factor = 0.1;

current_x_lim = handles.XLim;

dist_x = current_x_lim(2) - current_x_lim(1);

new_x_lim = [round(current_x_lim(1) - scale_factor * dist_x), round(current_x_lim(2) - scale_factor * dist_x)];

components.x_lower.Value = new_x_lim(1);
components.x_higher.Value = new_x_lim(2);

handles.XLim = new_x_lim;

guidata(hObject,handles)

run(components)

end

% Functionality for zooming and panning
function zoom_in(hObject, eventdata,components)
handles = guidata(hObject);

scale_factor = 0.1;

current_x_lim = handles.XLim;
current_y_lim = handles.YLim;

dist_x = current_x_lim(2) - current_x_lim(1);
dist_y = current_y_lim(2) - current_y_lim(1);

new_x_lim = [round(current_x_lim(1) + scale_factor * dist_x), round(current_x_lim(2) - scale_factor * dist_x)];
new_y_lim = [round(current_y_lim(1) + scale_factor * dist_y), round(current_y_lim(2) - scale_factor * dist_y)];

components.x_lower.Value = new_x_lim(1);
components.x_higher.Value = new_x_lim(2);
components.y_lower.Value = new_y_lim(1);
components.y_higher.Value = new_y_lim(2);

handles.XLim = new_x_lim;
handles.YLim = new_y_lim;

guidata(hObject,handles)



run(components)

end

% Functionality for zooming and panning
function zoom_out(hObject, eventdata,components)
handles = guidata(hObject);

scale_factor = 0.1;

current_x_lim = handles.XLim;
current_y_lim = handles.YLim;

dist_x = current_x_lim(2) - current_x_lim(1);
dist_y = current_y_lim(2) - current_y_lim(1);

new_x_lim = [round(current_x_lim(1) - scale_factor * dist_x), round(current_x_lim(2) + scale_factor * dist_x)];
new_y_lim = [round(current_y_lim(1) - scale_factor * dist_y), round(current_y_lim(2) + scale_factor * dist_y)];

components.x_lower.Value = new_x_lim(1);
components.x_higher.Value = new_x_lim(2);
components.y_lower.Value = new_y_lim(1);
components.y_higher.Value = new_y_lim(2);

handles.XLim = new_x_lim;
handles.YLim = new_y_lim;

guidata(hObject,handles)



run(components)

end

% Loading a previously saved file
function load_save(hObject, eventdata,components)
handles = guidata(hObject);

fileName = uigetfile('*.mat','Find your previous truth data set');

if isempty(handles.previous_tracks{1})
   handles.previous_tracks = load(fileName).t;
else
    previous_length = length(handles.previous_tracks);
    prev_cell = load(fileName).t;
    for k = 1:length(prev_cell)
        handles.previous_tracks{k + previous_length} = prev_cell{k};
    end
end

handles.replot_flag = 1;

guidata(hObject,handles)

run(components)

end

% Saves the results of the clicked layers into a structure for later
% analysis or for finishing at a later time
function save_results(hObject, eventdata,components)
handles = guidata(hObject);

if ~isempty(handles.current_track)
    [x,idx] = sort(handles.current_track(1,:));
    y = handles.current_track(2,idx);
    handles.previous_tracks{length(handles.previous_tracks)+1} = [x; y];
    handles.current_track = [];
    handles.replot_flag = 1;
end

t = handles.previous_tracks;

structfilename = ['Truth-',components.file_name];

save(structfilename,'t');

guidata(hObject,handles)

run(components)

end

% Takes selected points, sorts it, and then adds it to the previous tracks
function new_layer(hObject, eventdata,components)

handles = guidata(hObject);

if length(handles.previous_tracks) == 1 && isempty(handles.previous_tracks{1})
    [x,idx] = sort(handles.current_track(1,:));
    y = handles.current_track(2,idx);
    handles.previous_tracks{1} = [x; y];
    handles.current_track = [];
    handles.replot_flag = 1;
else
    [x,idx] = sort(handles.current_track(1,:));
    y = handles.current_track(2,idx);
    handles.previous_tracks{length(handles.previous_tracks)+1} = [x; y];
    handles.current_track = [];
    handles.replot_flag = 1;
end

guidata(hObject,handles)

run(components)

end

% Deletes last point that was selected for current track. When editing a
% layer that's already done, the points will already be sorted, so this is
% mainly useful when you're in the middle of selecting a ton of points. 
function delete_last_point(hObject, eventdata,components)
handles = guidata(hObject);
if ~isempty(handles) && length(handles.current_track) > 1
    handles.current_track = handles.current_track(:,1:end-1);
else 
    handles.current_track = [];
end

handles.replot_flag = 1;

guidata(hObject, handles);   % Write the modified struct back to the figure

run(components)

end

% Adds the ability to change the plot limits by simply adjusting the text.
% When running the run(components) function, it changes the limits already,
% so this is only needed when changing the text in the top right of the GUI
% and not for when zooming and whatnot with the buttons. 
function change_limits(hObject, eventdata,components)

handles = guidata(hObject);

handles.XLim = [components.x_lower.Value components.x_higher.Value];
handles.YLim = [components.y_lower.Value components.y_higher.Value];

guidata(components.fig, handles);

run(components)

end

% The main function that plots everything. Automatically changes axis
% limits (since they're part of the handles structure), and replots
% everything if the replot flag is true. The purpose of replotting is if
% you have to erase a previous point, so it gets rid of it in the handles
% structure, but it won't delete it from the plot without replotting over
% it. 
function run(components)
handles = guidata(components.fig);

components.ax.XLim = handles.XLim;
components.ax.YLim = handles.YLim;

if handles.run_flag 

    if ~isempty(handles) && handles.replot_flag
        hold(components.ax,'off')

        imagesc(components.ax,components.data,'HitTest','off');
        colormap(components.ax,1-gray)
        hold(components.ax,'on')

        handles.replot_flag = 0;

        if ~isempty(handles.previous_tracks{1})
            for kk = 1:length(handles.previous_tracks)
                current_track = handles.previous_tracks{kk};
                plot(components.ax,current_track(1,:),current_track(2,:),'r','HitTest','off')
            end
        end

        if ~isempty(handles.current_track)
            for k = 1:length(guidata(components.fig).current_track)
                scatter(components.ax,guidata(components.fig).current_track(1,:),guidata(components.fig).current_track(2,:),'b*','HitTest','off')
            end
        end

    end

    % if ~isempty(handles) && ~isempty(handles.current_track)
    %     for k = 1:length(guidata(components.fig).current_track)
    %         scatter(components.ax,guidata(components.fig).current_track(1,:),guidata(components.fig).current_track(2,:),'b*')
    %     end
    % end

    guidata(components.fig, handles);

    drawnow

end
end

% Main function for clicking purposes. Collects points you've clicked and
% adds it to the handles structure, or if the edit_track_flag is set to
% true then it'll find the previous_track that is closest so you can adjust
% it. 
function plot_ButtonDownFcn(hObject, eventdata,components)
% Get the click coordinates from the click event data
x = eventdata.IntersectionPoint(1);
y = eventdata.IntersectionPoint(2);

% disp(x)
% disp(y)

handles = guidata(hObject);
current_point = [x, y]';

if handles.edit_track_flag == 0 && handles.deleting_flag == 0
    handles.current_track = [handles.current_track current_point];
    handles.replot_flag = 0;
    guidata(hObject, handles);   % Write the modified struct back to the figure
    
    scatter(components.ax,current_point(1),current_point(2),'b*','HitTest','off')
    
    run(components)

elseif handles.edit_track_flag == 0 && handles.deleting_flag == 1
    for k = 1:length(handles.current_track)
        dist(k) = sqrt((handles.current_track(1,k)-x)^2+(handles.current_track(2,k)-y)^2);
    end
    [val,ind] = min(dist); 
    iter = 1;
    for k = 1:length(handles.current_track)
        if k ~= ind
            new_track(:,iter) = handles.current_track(:,k);
            iter = iter + 1;
        end
    end
    handles.current_track = new_track;
    handles.replot_flag = 1;
    guidata(hObject, handles);   % Write the modified struct back to the figure
    run(components)

else
    for k = 1:length(handles.previous_tracks)
        % fprintf('%1i out of %1i\n',k,length(handles.previous_tracks))
        track = handles.previous_tracks{k};
        min_dist(k) = min(sqrt((track(1,:)-x).^2+(track(2,:)-y).^2));
    end
    [val,ind] = min(min_dist);
    % ind reveals the track that contains the truest minimum distance to selected point

    scatter(components.ax,current_point(1),current_point(2),'m*','HitTest','off')

    iter = 1;
    for k = 1:length(handles.previous_tracks)
        if k ~= ind
            new_previous_tracks{iter} = handles.previous_tracks{k};
            iter = iter + 1;
        end
    end

    set(components.edit_track_button,'BackgroundColor','w')
    set(components.edit_track_button,'FontColor','k')
    handles.current_track = handles.previous_tracks{ind};
    handles.previous_tracks = new_previous_tracks;
    handles.replot_flag = 1;
    handles.edit_track_flag = 0;
    guidata(hObject, handles);   % Write the modified struct back to the figure
    run(components)
end
end

