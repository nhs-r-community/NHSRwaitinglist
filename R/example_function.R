
#' @title Example function for getting started
#'
#' @description  This is an example function to help people getting involved.  The function below takes two inputs, converts
#' them to characters and then concatenates them as a string for output.  I've explicitly used the 'return' function at the end
#' , which is good practice, but the function will return the last row if not.  Once you've written your function, if working in RStudio
#' , go to the 'Code' menu and select 'Insert Roxygen Skeleton', which will insert the metadata tags like this.  Fill them in, and they
#' will be used to build the help files etc.
#'
#' @param input1 Something you want to put into the function, this could be a number, character etc.
#' @param input2 Something you want to put into the function, this could be a number, character etc.
#'
#' @return a character string of both inputs
#' @export
#'
#' @examples
#' example_function("something", 1234)
#'
example_function <- function(input1, input2){

  input1 <- as.character(input1)
  input2 <- as.character(input2)

  output <- paste(input1,",", input2)

  return(output)

}
