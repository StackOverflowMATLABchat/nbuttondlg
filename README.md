[![MATLAB FEX](https://img.shields.io/badge/MATLAB%20FEX-nbuttondlg-brightgreen.svg)](http://www.mathworks.com/matlabcentral/fileexchange/53394-nbuttondlg--a-generic-implementation-of-questboxdlg) ![Minimum Version](https://img.shields.io/badge/Requires-R2016b%20%28v9.1%29-orange.svg)

# nbuttondlg

`NBUTTONDLG(Question, ButtonLabels)` creates a modal dialog box that sizes to accomodate a generic number of buttons. The number of buttons is determined by the number of elements in `ButtonLabels`, provided as an array of string-likes understood by `string`. The name of the button that is pressed is returned as a `string`. If the dialog window is closed without a valid selection the return value is empty.

`NBUTTONDLG` should theoretically support an infinite number of buttons. The default parameters are optimized for `4` buttons.

`NBUTTONDLG` uses `UIWAIT` to suspend execution until the user responds.

## Installation

No installation necessary. Clone the repository or download the files and execute directly in MATLAB.

## Usage

Example:

```matlab
user_choice = nbuttondlg('What is your favorite color?', ...
                        {'Red', 'Green', 'Blue', 'Yellow'} ...
             );
if ~isempty(user_choice)
    fprintf('Your favorite color is %s!\n', user_choice);
else
    fprintf('You have no favorite color :(\n')
end
````

![nbuttondlg](https://github.com/sco1/sco1.github.io/blob/master/nbuttondlg/nbuttondlg.PNG)

## Parameter/Value Pairs

The `Question` and `ButtonLabel` inputs can be followed by parameter/value pairs to specify additional properties of the dialog box. For example, `NBUTTONDLG(Question, ButtonLabels, 'DialogTitle', 'This is a Title!')` will create a dialog box with the specified Question and ButtonLabels and replace the default figure title with `'This is a Title!`'

Property Name      | Data Type              | Description                                                   | Default
:---:              | :---:                  | ---                                                           | :---:
`BorderSize`       | Integer                | Spacing, in pixels, between dialog box edges and button edges | `20`
`ButtonWidth`      | Integer                | Width, in pixels, of all buttons                              | `80`
`ButtonHeight`     | Integer                | Height, in pixels, of all buttons                             | `40`
`ButtonSpacing`    | Integer                | Spacing, in pixels, between all buttons                       | `20`
`PromptTextHeight` | Integer                | Height, in pixels, of the question text box                   | `20`
`DialogTitle`      | String-like            | Dialog box figure title                                       | `'Please Select an Option'`
`DefaultButton`    | Integer or String-like | Default highlighted button.<sup>1</sup>                       | `1`
`CancelButton`     | Boolean                | Include a cancel button.<sup>2</sup>                          | `false`

1. An attempt will be made to match a string-like input to a value in `ButtonLabels`. If no match is found, or the integer value is greater than the number of buttons, the default value will be used.
2. If `true`, a 'Cancel' button label is added to `ButtonLabels`. If Cancel is selected, `NBUTTONDLG` behaves as if it were closed without selection.
