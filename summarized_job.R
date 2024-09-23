# @author: Arkan De Lomas
# date: 23/09/2024
# convert a ncdf into an editable csv, and then return it back to a ncdf

library(ncdf4)

setwd('D:/work_for_Vince') # Delete this in final product

# First task to do is make the ncdf that vince sent a writeable version:
file.copy("v2.EU.SPIN_19450101_19451231_1Y_stomate_history.nc", "writable_copy.nc")

# from now on, work on writeable copy:
df <- nc_open("writable_copy.nc", write=TRUE)

# Read the target variable and its dimensions
var_name = "TOTAL_LITTER_SOIL_c"
vegt_data <- ncvar_get(df, var_name)


write.csv(vegt_data, 'vegt.csv', row.names = FALSE)

# -- at this point, the user edits the CSV file --

# then proceed to convert csv back to ncdf
edited_data <- read.csv('vegt.csv', header = TRUE)

# convert to a matrix
edited_matrix <- as.matrix(edited_data)
write.csv(edited_matrix, 'test.csv', row.names = FALSE)

edited_matrix <- apply(edited_matrix, 2, as.numeric) #  ensure all columns are numeric

dims <- dim(vegt_data)
reshaped_data <- array(as.numeric(edited_matrix), dim = dims)

ncvar_put(df, var_name, reshaped_data) #  edits the original ncdf file

vegt_data <- ncvar_get(df, var_name) # proves that the changes have been made
vegt_data
