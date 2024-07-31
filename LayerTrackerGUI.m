
clear; clc; close all

load("20181231_044516.mat")

components.data = wiener2_modified;


%% Build GUI 

components.fig = uifigure("Position",[50 100 1350 690],'Name','Layer Tracker GUI');

g = uigridlayout(components.fig);
g.RowHeight = {'1x','0.75x','1x','0.75x','5x','1x','1x','1x','1x'};
g.ColumnWidth = {'10x','1x','1x'};

components.ax = uiaxes(g);
components.ax.Layout.Row = [1 9];
components.ax.Layout.Column = 1;
grid(components.ax,'on')
components.ax.Color = 'w';
components.ax.Title.String = 'Manually Track The Layers';
imagesc(components.ax,components.data,'HitTest','off'); hold(components.ax,'on')
colormap(components.ax,1-gray)
components.ax.XLim = [0 size(components.data,2)];
components.ax.YLim = [0 size(components.data,1)];

components.xlimit_label = uilabel(g,"Text","Insert X Limits");
components.xlimit_label.Layout.Row = 1;
components.xlimit_label.Layout.Column = [2 3];
components.xlimit_label.HorizontalAlignment = 'center';

components.ylimit_label = uilabel(g,"Text","Insert Y Limits");
components.ylimit_label.Layout.Row = 3;
components.ylimit_label.Layout.Column = [2 3];
components.ylimit_label.HorizontalAlignment = 'center';

components.x_lower = uieditfield(g,"numeric","Value",0);
components.x_lower.Layout.Row = 2;
components.x_lower.Layout.Column = 2;

components.x_higher = uieditfield(g,"numeric","Value",size(components.data,2));
components.x_higher.Layout.Row = 2;
components.x_higher.Layout.Column = 3;

components.y_lower = uieditfield(g,"numeric","Value",0);
components.y_lower.Layout.Row = 4;
components.y_lower.Layout.Column = 2;

components.y_higher = uieditfield(g,"numeric","Value",size(components.data,1));
components.y_higher.Layout.Row = 4;
components.y_higher.Layout.Column = 3;

components.new_layer_button = uibutton(g);
components.new_layer_button.Layout.Row = 6;
components.new_layer_button.Layout.Column = [2 3];
components.new_layer_button.Text = "New Layer";

components.erase_last_point = uibutton(g);
components.erase_last_point.Layout.Row = 7;
components.erase_last_point.Layout.Column = [2 3];
components.erase_last_point.Text = "Erase Last Point";

components.save_results_button = uibutton(g);
components.save_results_button.Layout.Row = 8;
components.save_results_button.Layout.Column = [2 3];
components.save_results_button.Text = "Save Results";

components.load_save_button = uibutton(g);
components.load_save_button.Layout.Row = 9;
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


%% Connections 

components.x_lower.ValueChangedFcn = @(src,event)change_limits(components);
components.x_higher.ValueChangedFcn = @(src,event)change_limits(components);
components.y_lower.ValueChangedFcn = @(src,event)change_limits(components);
components.y_higher.ValueChangedFcn = @(src,event)change_limits(components);

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

%% Initialize 

innit_handles.previous_tracks = cell(1);
innit_handles.previous_tracks{1} = [];
innit_handles.replot_flag = 0;
innit_handles.run_flag = 1;
innit_handles.current_track = [];
innit_handles.XLim = [0 size(components.data,2)];
innit_handles.YLim = [0 size(components.data,1)];
innit_handles.Home_X = [0 size(components.data,2)];
innit_handles.Home_Y = [0 size(components.data,1)];


guidata(components.fig, innit_handles);

run(components); 

%% Functions

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

function move_down(hObject, eventdata,components)
handles = guidata(hObject);

scale_factor = 0.1;

current_y_lim = handles.YLim;

dist_y = current_y_lim(2) - current_y_lim(1);

new_y_lim = [current_y_lim(1) + scale_factor * dist_y, current_y_lim(2) + scale_factor * dist_y];

components.y_lower.Value = new_y_lim(1);
components.y_higher.Value = new_y_lim(2);

handles.YLim = new_y_lim;

guidata(hObject,handles)

run(components)

end

function move_up(hObject, eventdata,components)
handles = guidata(hObject);

scale_factor = 0.1;

current_y_lim = handles.YLim;

dist_y = current_y_lim(2) - current_y_lim(1);

new_y_lim = [current_y_lim(1) - scale_factor * dist_y, current_y_lim(2) - scale_factor * dist_y];

components.y_lower.Value = new_y_lim(1);
components.y_higher.Value = new_y_lim(2);

handles.YLim = new_y_lim;

guidata(hObject,handles)

run(components)

end

function move_right(hObject, eventdata,components)
handles = guidata(hObject);

scale_factor = 0.1;

current_x_lim = handles.XLim;

dist_x = current_x_lim(2) - current_x_lim(1);

new_x_lim = [current_x_lim(1) + scale_factor * dist_x, current_x_lim(2) + scale_factor * dist_x];

components.x_lower.Value = new_x_lim(1);
components.x_higher.Value = new_x_lim(2);

handles.XLim = new_x_lim;

guidata(hObject,handles)

run(components)

end

function move_left(hObject, eventdata,components)
handles = guidata(hObject);

scale_factor = 0.1;

current_x_lim = handles.XLim;

dist_x = current_x_lim(2) - current_x_lim(1);

new_x_lim = [current_x_lim(1) - scale_factor * dist_x, current_x_lim(2) - scale_factor * dist_x];

components.x_lower.Value = new_x_lim(1);
components.x_higher.Value = new_x_lim(2);

handles.XLim = new_x_lim;

guidata(hObject,handles)

run(components)

end

function zoom_in(hObject, eventdata,components)
handles = guidata(hObject);

scale_factor = 0.1;

current_x_lim = handles.XLim;
current_y_lim = handles.YLim;

dist_x = current_x_lim(2) - current_x_lim(1);
dist_y = current_y_lim(2) - current_y_lim(1);

new_x_lim = [current_x_lim(1) + scale_factor * dist_x, current_x_lim(2) - scale_factor * dist_x];
new_y_lim = [current_y_lim(1) + scale_factor * dist_y, current_y_lim(2) - scale_factor * dist_y];

components.x_lower.Value = new_x_lim(1);
components.x_higher.Value = new_x_lim(2);
components.y_lower.Value = new_y_lim(1);
components.y_higher.Value = new_y_lim(2);

handles.XLim = new_x_lim;
handles.YLim = new_y_lim;

guidata(hObject,handles)



run(components)

end

function zoom_out(hObject, eventdata,components)
handles = guidata(hObject);

scale_factor = 0.1;

current_x_lim = handles.XLim;
current_y_lim = handles.YLim;

dist_x = current_x_lim(2) - current_x_lim(1);
dist_y = current_y_lim(2) - current_y_lim(1);

new_x_lim = [current_x_lim(1) - scale_factor * dist_x, current_x_lim(2) + scale_factor * dist_x];
new_y_lim = [current_y_lim(1) - scale_factor * dist_y, current_y_lim(2) + scale_factor * dist_y];

components.x_lower.Value = new_x_lim(1);
components.x_higher.Value = new_x_lim(2);
components.y_lower.Value = new_y_lim(1);
components.y_higher.Value = new_y_lim(2);

handles.XLim = new_x_lim;
handles.YLim = new_y_lim;

guidata(hObject,handles)



run(components)

end

function load_save(hObject, eventdata,components)
handles = guidata(hObject);

fileName = uigetfile('*.mat','Find your previous truth data set');

if isempty(handles.previous_tracks{1})
    handles.previous_tracks = load(fileName).s;
else
    previous_length = length(handles.previous_tracks);
    prev_cell = load(fileName).s;
    for k = 1:length(prev_cell)
        handles.previous_tracks{k + previous_length} = prev_cell{k};
    end
end

handles.replot_flag = 1;

guidata(hObject,handles)

run(components)

end

function save_results(hObject, eventdata,components)
handles = guidata(hObject);

if ~isempty(handles.current_track)
    [x,idx] = sort(handles.current_track(1,:));
    y = handles.current_track(2,idx);
    handles.previous_tracks{length(handles.previous_tracks)+1} = [x; y];
    handles.current_track = [];
    handles.replot_flag = 1;
end

s = handles.previous_tracks;

structfilename = 'truth-' + string(datetime('now','Format','MM-dd-yy-HH-mm-ss')) + '.mat';

save(structfilename,'s');

guidata(hObject,handles)

run(components)

end

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

function [components] = change_limits(components)

handles = guidata(hObject);

handles.XLim = [components.x_lower.Value components.x_higher.Value];
handles.YLim = [components.y_lower.Value components.y_higher.Value];

run(components)

end

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

        if ~isempty(handles.previous_tracks)
            for kk = 1:length(handles.previous_tracks)
                current_track = handles.previous_tracks{kk};
                plot(components.ax,current_track(1,:),current_track(2,:),'r')
            end
        end

    end

    if ~isempty(handles) && ~isempty(handles.current_track)
        for k = 1:length(guidata(components.fig).current_track)
            scatter(components.ax,guidata(components.fig).current_track(1,:),guidata(components.fig).current_track(2,:),'b*')
        end
    end

    guidata(components.fig, handles);

    drawnow

end
end

function plot_ButtonDownFcn(hObject, eventdata,components)
% Get the click coordinates from the click event data
x = eventdata.IntersectionPoint(1);
y = eventdata.IntersectionPoint(2);

% disp(x)
% disp(y)

handles = guidata(hObject);
if isempty(handles)
    handles.current_track = [];
end
current_point = [x, y]';
handles.current_track = [handles.current_track current_point];
handles.replot_flag = 0;
guidata(hObject, handles);   % Write the modified struct back to the figure

run(components)

end

