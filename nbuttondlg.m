function userchoice = nbuttondlg(question, buttonlabels, varargin)
    %NBUTTONDLG Generic n-button question dialog box.
    % NBUTTONDLG(Question, ButtonLabels) creates a modal dialog box that sizes to accomodate a
    % generic number of buttons. The number of buttons is determined by the number of elements in
    % ButtonLabels, provided as an array of string-likes understood by STRING.
    %
    % NBUTTONDLG returns the label of the selected button as the same type it was provided. If the
    % dialog window is closed without a valid selection the return value will be empty.
    %
    % NBUTTONDLG should theoretically support an infinite number of buttons. The default parameters
    % are optimized for 4 buttons.
    %
    % NBUTTONDLG uses UIWAIT to suspend execution until the user responds.
    %
    %  Example:
    %
    %     user_choice = nbuttondlg('What is your favorite color?', ...
    %                             {'Red', 'Green', 'Blue', 'Yellow'} ...
    %                   );
    %     if ~isempty(user_choice)
    %        fprintf('Your favorite color is %s!\n', user_choice);
    %     else
    %        fprintf('You have no favorite color :(\n')
    %     end
    %
    % The Question and ButtonLabels inputs can be followed by parameter/value pairs to specify
    % additional properties of the dialog box. For example, NBUTTONDLG(Question, ButtonLabels,
    % 'DialogTitle', 'This is a Title!') will create a dialog box with the specified Question and
    % ButtonLabels and replace the default figure title with 'This is a Title!'
    %
    % Available Parameter/Value pairs:
    %
    %      BorderSize          Spacing between dialog box edges and button
    %                          edges.
    %                          Value is in pixels.
    %                          Default: 20 pixels
    %
    %      ButtonWidth         Width of all buttons
    %                          Value is in pixels.
    %                          Default: 80 pixels
    %
    %      ButtonHeight        Height of all buttons
    %                          Value is in pixels.
    %                          Default: 40 pixels
    %
    %      ButtonSpacing       Spacing between all buttons
    %                          Value is in pixels.
    %                          Default: 20 pixels
    %
    %      PromptTextHeight    Height of the Question text box
    %                          Value is in pixels.
    %                          Default: 20 pixels
    %
    %      DialogTitle         Dialog box figure title
    %                          Value is an nx1 character array.
    %                          Default: 'Please Select an Option:'
    %
    %      DefaultButton       Default highlighted button
    %                          Value is an integer, an nx1 character array, or a string.
    %                          An attempt will be made to match a string-like label to a value in
    %                          ButtonLabels. If no match is found or the integer value is greater
    %                          than the number of buttons, the default value will be used.
    %                          Default: 1
    %
    %      CancelButton        Include a cancel button.
    %                          Value is true/false
    %                          If true, a 'Cancel' button label is added to ButtonLabels. If
    %                          'Cancel' is selected, NBUTTONDLG behaves as if it were closed without
    %                          selection.
    %                          Default: false
    %
    % See also QUESTDLG, DIALOG, ERRORDLG, HELPDLG, INPUTDLG, LISTDLG, WARNDLG, UIWAIT, STRING
    p = generateparser;
    parse(p, varargin{:});

    buttonlabels = string(buttonlabels);
    if p.Results.CancelButton
        buttonlabels = buttonlabels + "Cancel";
    end
    nbuttons = length(buttonlabels);

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
            'Callback', {@dlgbuttonfcn}...
        );
    end

        function dlgbuttonfcn(source, ~)
            % On button press, find which button the user pressed and exit function
            userchoice = buttonlabels{find(strcmp(source.String, buttonlabels), 1)};
            close(dlg.mainfig)
        end

    % Set default button highlighting
    if ischar(p.Results.DefaultButton)
        % Case insensitive search of the button labels for the specified button string. If found,
        % use that as the default button. Otherwise default to the first button.
        if sum(strcmpi(p.Results.DefaultButton, buttonlabels)) ~= 0
            DefaultButton = find(strcmpi(p.Results.DefaultButton, buttonlabels), 1);
        else
            DefaultButton = 1;
        end
    elseif isnumeric(p.Results.DefaultButton)
        % Round to the nearest integer, use that as the default button. If it's greater than the
        % number of buttons, default to the first button. If an array of numbers is presented, pick
        % the first one.
        DefaultButton = round(p.Results.DefaultButton);
        if DefaultButton > nbuttons
            DefaultButton = 1;
        end
    else
        % Default to first button
        DefaultButton = 1;
    end
    setdefaultbutton(dlg.button(DefaultButton));  % Add drop shadow

    waitfor(dlg.mainfig);

    if ~exist('userchoice', 'var')
        % Dialog was closed w/o making a selection, mimic questdlg behavior and return an empty
        % string
        userchoice = "";
    end

    if p.Results.CancelButton && strcmp('Cancel', userchoice)
        % Cancel button selected, return an empty string
        userchoice = "";
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

    isstrlike = @(s) ischar(s) || isStringScalar(s);
    addOptional(p, 'DialogTitle', defaultdialogtitle, isstrlike);
    addOptional(p, 'DefaultButton', defaultbutton); % Can be string or integer, behavior handled in main function
    addOptional(p, 'CancelButton', includecancelbutton, @islogical);
end

function setdefaultbutton(btnHandle)
    % Helper function ripped from questboxdlg, adds a drop shadow to the default button

    % First get the position of the button.
    buttonunits = btnHandle.Units;

    if strcmp(buttonunits, 'Pixels')
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

    % Create the default button look with a uipanel. Use black border color even on Mac or
    % Windows-XP (XP scheme) since this is in natve figures which uses the Win2K style buttons on
    % Windows and Motif buttons on the Mac.
    h1 = uipanel( ...
        get(btnHandle, 'Parent'), ...
        'HighlightColor', [0 0 0.8], ...
        'BorderType', 'etchedout', ...
        'Units', 'pixels', ...
        'Position', [leftOffset bottomOffset widthOffset heightOffset] ...
    );

    % Make sure it is stacked on the bottom.
    uistack(h1, 'bottom');
end
