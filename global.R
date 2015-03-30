require(data.table)

axis.vars = c('Number of orphans'   = 'orphans',
              'Neighbor distance'   = 'distance',
              'Total protein count' = 'total',
              'Orphan proportion'   = 'proportion',
              'Average length'      = 'ave.length',
              'Length ratio'        = 'length.rat',
              'Length stdev'        = 'sd.length')

orphan.data <- data.table(read.table('data/orphan-summary.tab'))
orphan.data$orphans <- as.numeric(orphan.data$orphans)
orphan.data$threshold <- as.character(orphan.data$threshold)
orphan.data$id <- as.character(orphan.data$id)
orphan.data$family <- as.factor(orphan.data$family)
orphan.data$key <- 1:nrow(orphan.data)

id.vars <- unique(orphan.data$id)
names(id.vars) <- id.vars

threshold.vars <- unique(orphan.data$threshold)
names(threshold.vars) <- threshold.vars

ages <- data.table(read.table('data/ages.tab'))
ages$key <- 1:nrow(ages)
ages$family <- as.factor(ages$family)
