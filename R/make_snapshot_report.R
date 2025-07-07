#' Make Waiting List Snapshot Report
#'
#' @param histogram_data data.frame.  A data.frame of histogram data in the NHSRwaitinglist data format.
#' @param org_categories charactor vector. A charactor vector of category column names present in the histogram data.
#' @param fill_category character. The name of a category column in the histogram data which will be used to define the histogram fill colours.
#' @param org_name character. The name of the organisation producing the report.
#' @param destination character. The path the final report should be rendered to.  Defaults to the current working directory.
#'
#' @returns character. The filepath of the final rendered report.
#' @export
#'
make_snapshot_report <- function(
    histogram_data_1,
    histogram_data_2,
    org_categories = NULL,
    fill_category = NULL,
    org_name = NULL,
    report_reference = NULL,
    report_owner = NULL,
    destination_directory = "."
){

  # Create a temp files to hold the incoming data in RDS files
  # this overcomes the problem where quarto converts params to lists
  temp_data_path_1 <- tempfile(fileext = ".rds")
  saveRDS(histogram_data_1, temp_data_path_1)
  temp_data_path_2 <- tempfile(fileext = ".rds")
  saveRDS(histogram_data_2, temp_data_path_2)

  # this is the source location for the quarto report format
  report_qmd_path <- system.file("reports", "waiting_list_snapshot_report.qmd", package = "NHSRwaitinglist")

  # to render reliably, we need to copy the qmd to a temporary location
  temp_file_name <- "temp_report.qmd"

  # this is the final filename for the output
  final_filename <- paste0(format(Sys.time(), "%Y%m%d_%H%M%S_"), "Waiting_List_Snapshot_Report.html")

  # temporarily copy the qmd file to avoid resource filepath problems
  file.copy(report_qmd_path, temp_file_name, overwrite = TRUE)

  # render the report
  quarto::quarto_render(
    input = temp_file_name,
    output_file = final_filename,
    execute_params = list(
      data_path_1 = temp_data_path_1,
      data_path_2 = temp_data_path_2,
      org_name = org_name,
      report_reference = report_reference,
      report_owner = report_owner
    )
  )

  # delete the temporary files
  unlink(temp_file_name)
  unlink(temp_data_path_1)
  unlink(temp_data_path_2)

  # move the report to the output directory if required
  if(destination_directory != "."){
    result_path <- file.path(getwd(), destination_directory, final_filename)
    file.copy(final_filename, result_path)
    file.remove(final_filename)
  } else {
    result_path <- file.path(getwd(), final_filename)
  }

  # open the report in the web browser
  browseURL(result_path)

  return(result_path)

}