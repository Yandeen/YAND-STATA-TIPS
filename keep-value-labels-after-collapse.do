// Keep only variables that will be in the database after collapse
keep grappe menage s16cq04 s00q01 s00q02 s16cq02 s16cq03 s16cq13a s16cq13b s16cq13c s16cq14a s16cq14b s16cq14c s16cq16a s16cq16b s16cq16c s16cq17 s16cq22a s16cq22b s16cq22c s16cq27


// define the path for saving temporary files
global path_for_tempfiles "C:\Users\USER\Documents\StataTemp"

// This is the list of variables for which we want to save the value labels.
label dir
local list_of_valuelables = r(names)

// save the label values
label save using $path_for_tempfiles/label_values.do, replace
// note the names of the label values for each variable that has a label value attached to it: need the variable name - value label correspodence
   local list_of_vars_w_valuelables
   foreach var of varlist * {
   local templocal : value label `var'
   if ("`templocal'" != "") {
      local varlabel_`var' : value label `var'
      di "`var': `varlabel_`var''"
      local list_of_vars_w_valuelables "`list_of_vars_w_valuelables' `var'"
   }
}
di "`list_of_vars_w_valuelables'"

// do the collapse here

collapse (first) s00q01 s00q02 s16cq02 s16cq03 (sum) s16cq13a (first) s16cq13b s16cq13c (sum) s16cq14a (first) s16cq14b s16cq14c (sum) s16cq16a (first) s16cq16b s16cq16c (sum) s16cq17 s16cq22a (first) s16cq22b s16cq22c (sum) s16cq27, by(grappe menage s16cq04)


// redefine the label values
do $path_for_tempfiles/label_values.do
// reattach the label values
foreach var of local list_of_vars_w_valuelables {
   cap label values `var' `varlabel_`var''
}
