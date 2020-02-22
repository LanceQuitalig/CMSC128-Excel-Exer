FixData <- function(dataFrame) {
    x = length(dataFrame[1, ])
    y = length(dataFrame[, 1])

    resultDF = 0
    tempDF = c(" ", " ")

    for (row in 1 : y) {
        tempDF = c(" ", " ")
        for (col in 1 : x) tempDF[col] = as.character(dataFrame[[col]][row])
        if (row == 1) resultDF = tempDF
        else resultDF = rbind(resultDF, tempDF)
    }
    rownames(resultDF) = c()
    return(resultDF)
}