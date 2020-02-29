FixData <- function(dataFrame) {
    x = length(dataFrame[1, ])
    y = length(dataFrame[, 1])

    resultDF = 0
    tempDF = c(" ", " ")

    print(dataFrame)

    for (row in 1 : y) {
        tempDF = c(" ", " ")
        for (col in 1 : x) tempDF[col] = as.character(dataFrame[[col]][row])
        if (row == 1) resultDF = tempDF
        else resultDF = rbind(resultDF, tempDF)
    }
    rownames(resultDF) = c()
    return(resultDF)
}

FindUser <- function(username, dataFrame) {
    y = length(dataFrame[, 1])
    rowIndex = c(FALSE, 0)

    for (row in 1 : y) {
        if (dataFrame[row, 1] == username) {
            rowIndex[1] = TRUE
            rowIndex[2] = row
            break
        }
    } 
    return(rowIndex)
}

CheckPass <- function(password, dataFrame, rowIndex) {
    if (dataFrame[rowIndex[2], 2] == password) return(TRUE)
    return(FALSE)
}

Signup <- function(username, password, dataFrame) {
    result = rbind(dataFrame, c(username, password))
    rownames(result) = c()
    colnames(result) = c("username", "password")
    return(result)
} 