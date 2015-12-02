[![MATLAB FEX](https://img.shields.io/badge/MATLAB%20FEX-nbuttondlg-brightgreen.svg)](http://www.mathworks.com/matlabcentral/fileexchange/53394-nbuttondlg--a-generic-implementation-of-questboxdlg) ![Minimum Version](https://img.shields.io/badge/Requires-R2009b%20%28v7.9%29-orange.svg)

# nbuttondlg

NBUTTONDLG(Question, ButtonLabels) creates a modal dialog box that sizes to accomodate a generic number of buttons. The number of buttons is determined by the number of elements in buttonlabels, a 1xn cell array of strings. The name of the button that is pressed is returned as a string in userchoice. If the dialog window is closed without a valid selection the return value is empty.

NBUTTONDLG will theoretically support an infinite number of buttons. The default paramaters are optimized for 4 buttons.

NBUTTONDLG uses UIWAIT to suspend execution until the user responds.

## Installation

No installation necessary. Clone the repository or download the files and execute directly in MATLAB.

## Usage

Example:

```matlab
UserChoice = nbuttondlg('What is your favorite color?', ...
                        {'Red', 'Green', 'Blue', 'Yellow'} ...
                        );
if ~isempty(UserChoice)
    fprintf('Your favorite color is %s!\n', UserChoice);
else
    fprintf('You have no favorite color :(\n')
end
````

![nbuttondlg](https://github.com/sco1/sco1.github.io/blob/master/nbuttondlg/nbuttondlg.PNG)

## Parameter/Value Pairs

The Question and ButtonLabel inputs can be followed by parameter/value pairs to specify additional properties of the dialog box. For example, `NBUTTONDLG(Question, ButtonLabels, 'DialogTitle', 'This is a Title!')` will create a dialog box with the specified Question and ButtonLabels and replace the default figure title with 'This is a Title!'

Property Name    | Data Type       | Description | Default
:---:            | :---:           | ---         | :---:
BorderSize       | Integer         | Spacing, in pixels, between dialog box edges and button edges | 20
ButtonWidth      | Integer         | Width, in pixels, of all buttons | 80
ButtonHeight     | Integer         | Height, in pixels, of all buttons | 40
ButtonSpacing    | Integer         | Spacing, in pixels, between all buttons | 20
PromptTextHeight | Integer         | Height, in pixels, of the question text box | 20
DialogTitle      | String          | Dialog box figure title | 'Please Select an Option'
DefaultButton    | Integer, String | Default highlighted button. Value is an integer or an nx1 character array. If a character array is used, an attempt will be made to match the character array to a value in ButtonLabel. If no match is found or the integer value is greater than the number of buttons, the default value will be used. | 1
CancelButton     | Boolean         | Include a cancel button. If true, a 'Cancel' button label is added to Buttonlabel. If Cancel is selected, NBUTTONDLG returns an empty string. | false
