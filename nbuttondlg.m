function userchoice = nbuttondlg(question, buttonlabels, varargin)
%NBUTTONDLG Generic n-button question dialog box.
%  userchoice = NBUTTONDLG(question, buttonlabels, ...) creates a 
%  modal dialog box that sizes to accomodate a generic number of buttons.
%  The number of buttons is determined by the number of elements in
%  buttonlabels, a 1xn cell array of strings. The name of the button that 
%  is pressed is returned as a string in userchoice.
%
%  Theoretically this will to support an infinite number of buttons but the
%  utility is currently optimized for a maximum of 4-5 buttons.

% TODO: Add some error catching logic
% TODO: Document PV-pairs

p = generateparser;
parse(p, varargin{:});

if ~p.Results.CancelButton
    nbuttons = length(buttonlabels);
else
    nbuttons = length(buttonlabels) + 1;
    buttonlabels{end + 1} = 'Cancel';
end

stringspacer = floor(1.5*p.Results.BorderSize); % Spacing between prompt text and buttons, pixels
prompttxtxpos = p.Results.BorderSize; % Prompt text x position, pixels
prompttxtypos = p.Results.BorderSize + p.Results.ButtonHeight + stringspacer; % Prompt text y position, pixels

% Calculate size of entire dialog box
dialogwidth  = 2*p.Results.BorderSize + nbuttons*p.Results.ButtonWidth + (nbuttons - 1)*p.Results.ButtonSpacing;
dialogheight = 2*p.Results.BorderSize + p.Results.ButtonHeight + stringspacer + p.Results.PromptTextHeight;
prompttxtwidth  = dialogwidth - 2*p.Results.BorderSize; % Prompt text width, pixels

% Center window on screen
screz = get(0, 'ScreenSize');
boxposition = [screz(3) - dialogwidth, (screz(4) - dialogheight)]/2;

dlg.mainfig = figure( ...
    'Units', 'pixels', ...
    'Position', [boxposition(1) boxposition(2) dialogwidth dialogheight], ...
    'Menubar', 'none', ...
    'Name', p.Results.DialogTitle, ...
    'NumberTitle', 'off', ...
    'ToolBar', 'none', ...
    'Resize' , 'off' ...
    );

dlg.prompttxt = uicontrol( ...
    'Style', 'text', ...
    'Parent', dlg.mainfig, ...
    'Units', 'pixels', ...
    'Position', [prompttxtxpos prompttxtypos prompttxtwidth p.Results.PromptTextHeight], ...
    'String', question ...
    );

% Generate and space buttons
for ii = 1:nbuttons
    xpos = p.Results.BorderSize + (ii-1)*p.Results.ButtonSpacing + (ii-1)*p.Results.ButtonWidth;
    
    dlg.button(ii) = uicontrol( ...
        'Style', 'pushbutton', ...
        'Parent', dlg.mainfig, ...
        'Units', 'pixels', ...
        'Position', [xpos p.Results.BorderSize p.Results.ButtonWidth p.Results.ButtonHeight], ...
        'String', buttonlabels{ii}, ...
        'Callback', {@dlgbuttonfcn,  buttonlabels(1:nbuttons)}...
        );
end

    function dlgbuttonfcn(source, ~, buttonlist)
        % On button press, find which button the user pressed and exit
        % function
        userchoice = buttonlabels{find(strcmp(source.String, buttonlist), 1)};
        close(dlg.mainfig)
    end

% Set default button highlighting, not implemented
if ischar(p.Results.DefaultButton)
    % Case insensitive search of the button labels for the specified button
    % string. If found, use that as the default button. Otherwise default
    % to the first button.
    if sum(strcmpi(p.Results.DefaultButton, {dlg.button(:).String})) ~= 0
        DefaultButton = find(strcmpi(p.Results.DefaultButton, {dlg.button(:).String}), 1);
    else
        DefaultButton = 1;
    end
elseif isnumeric(p.Results.DefaultButton)
    % Round to the nearest integer, use that as the default button. If it's
    % greater than the number of buttons, default to the first button. If
    % an array of numbers is presented, pick the first one.
    DefaultButton = round(p.Results.DefaultButton);
    if DefaultButton > nbuttons
        DefaultButton = 1;
    end
else
    % Default to first button
    DefaultButton = 1;
end
setdefaultbutton(dlg.button(DefaultButton));

waitfor(dlg.mainfig);

if ~exist('userchoice', 'var')
    % Dialog was closed without making a selection
    % Mimic questdlg behavior and return an empty string
    userchoice = '';
end

if p.Results.CancelButton && strcmp('Cancel', userchoice)
    % Cancel button selected, return an empty string
    userchoice = '';
end
end

function p = generateparser
p = inputParser;

defaultbordersize      = 20; % Border size, pixels
defaultbuttonwidth     = 80; % Button width, pixels
defaultbuttonheight    = 40; % Button height, pixels
defaultbuttonspacing   = 20; % Spacing between buttons, pixels
defaultprompttxtheight = 20; % Prompt text height, pixels
defaultdialogtitle = 'Please Select an Option:'; % Dialog box title, string
defaultbutton = 1;  % Button selected by default, integer
includecancelbutton = false; % Include cancel button, logical

addOptional(p, 'BorderSize', defaultbordersize, @isnumeric);
addOptional(p, 'ButtonWidth', defaultbuttonwidth, @isnumeric);
addOptional(p, 'ButtonHeight', defaultbuttonheight, @isnumeric);
addOptional(p, 'ButtonSpacing', defaultbuttonspacing, @isnumeric);
addOptional(p, 'PromptTextHeight', defaultprompttxtheight, @isnumeric);
addOptional(p, 'DialogTitle', defaultdialogtitle, @ischar);
addOptional(p, 'DefaultButton', defaultbutton); % Can be string or integer, behavior handled in main function
addOptional(p, 'CancelButton', includecancelbutton, @islogical);
end

function setdefaultbutton(btnHandle) 
% Helper function ripped from guestboxdlg

% First get the position of the button.
if strcmp(btnHandle.Units, 'Pixels')
    btnPos = btnHandle.Position;
else
    oldunits = btnHandle.Units;
    btnHandle.Units = 'Pixels';
    btnPos = btnHandle.Position;
    btnHandle.Units = oldunits;
end

% Next calculate offsets.
leftOffset   = btnPos(1) - 1;
bottomOffset = btnPos(2) - 2;
widthOffset  = btnPos(3) + 3;
heightOffset = btnPos(4) + 3;

% Create the default button look with a uipanel.
% Use black border color even on Mac or Windows-XP (XP scheme) since
% this is in natve figures which uses the Win2K style buttons on Windows
% and Motif buttons on the Mac.
h1 = uipanel(get(btnHandle, 'Parent'), 'HighlightColor', [0 0 0.8], ...
    'BorderType', 'etchedout', 'units', 'pixels', ...
    'Position', [leftOffset bottomOffset widthOffset heightOffset]);

% Make sure it is stacked on the bottom.
uistack(h1, 'bottom');
end
