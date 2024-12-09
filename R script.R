library(ggplot2)
library(dplyr)
library(readr)
library(tidyr)
library(plotly)
library(scales)
library(visdat)
library(RColorBrewer)
library(viridis)
library(htmlwidgets)

#Import dataset 1
data1 <- read.csv("C:/Desktop/R viz/Data1.csv")

#Import dataset 2
data2 <- read.csv("C:/Desktop/R viz/Data2.csv")

# Merge dataset 1 to dataset 2, and keep the desired columns
data <- merge(data2, data1[c("Channel_Name", "Country", "Population", "Unemployment_rate")], by = "Channel_Name", all.x = TRUE)
print(data)

#Save the merged data as a CSV file 
file_path <- "C:/Desktop/data.csv"
write.csv(data, file = file_path, row.names = FALSE)

#sort the dataset as per rank
data <-data %>% arrange(Rank)

#Delete the outlier (100th row)
data <- data[-100, ]

#convert character to numeric
data$Subscribers <- as.numeric(gsub(",", "", data$Subscribers))
data$video.views <- as.numeric(gsub(",", "", data$video.views))
data$video.count <- as.numeric(gsub(",", "", data$video.count))
data$start.year <- as.numeric(gsub(",", "", data$start.year))

summary(data)
str(data)
glimpse(data)

#Set scipen to 999 to prevent scientific notation in numeric values
options(scipen=999)
print(data)

#convert all nan, NaN and blank cells to NA
data <- data %>%
  mutate_all(~ifelse(. == "" | . == "NaN" |. == "nan" | is.nan(.), NA, .))

# Plot missing values
vis_plot <- vis_miss(data)
vis_plot + theme(axis.text.x = element_text(angle = 70, hjust = 0.03, size = 12), axis.text.y = element_text(size= 11) )



#Total video views and Video uploads by category
category_sum <- data %>%
  group_by(Category) %>%
  summarise(total_video_count = sum(video.count),
            total_views = sum(video.views))
print(category_sum)


# Plot Video views per category
plot_views_category<-ggplot(category_sum, aes(x = reorder(Category, -total_views), y = total_views)) +
  geom_bar(stat = "identity", fill = "lightblue") +
  #scale_fill_viridis_c(option = "magma") +
  labs(title = "Total Video Views by Category", x = "Category", y = "Total Video Views") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
    panel.grid = element_blank()) +
  scale_y_continuous(labels = scales::comma, breaks = seq(500000000000, 3000000000000, by = 500000000000))
print(plot_views_category)


# Plot Video count per Category
plot_count_category<- ggplot(category_sum, aes(x = reorder(Category, -total_video_count), y = total_video_count)) +
  geom_col(fill = "lightgreen") +
  #scale_fill_viridis_c(option = "plasma") +
  labs(title = "Total Video Count by Category", x = "Category", y = "Total Video Count") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        panel.grid = element_blank())+
  scale_y_continuous(labels = scales::comma, breaks = seq(500000, 3000000, by = 500000))
print(plot_count_category)



#STATIC PLOT

#Total videos in each categories
category_sum <- data %>%
  group_by(Category) %>%
  summarise(total_video_count = sum(video.count),
            total_views = sum(video.views))
print(category_sum)


static_plot<- ggplot(category_sum, aes(x = reorder(Category, -total_views), y = total_views, fill = total_video_count)) +
  geom_bar(stat = "identity") +
  scale_fill_viridis_c()+
  geom_text(aes(label = format(total_video_count, big.mark = ',')), vjust = -0.8, size = 3)+
  labs(title = "Total Video Views by Category", x = "Category", y = "Total Video views", fill = "Total videos uploaded") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 12), axis.text.y = element_text(size = 12)) +
  scale_y_continuous(breaks = c(0, 125000000000, 500000000000, 1000000000000, 1500000000000, 2000000000000, 2500000000000, 3000000000000, 3500000000000),
    labels = function(x) paste0(x / 1000000000, "B")) 
print(static_plot)


#Saving the static plot
ggsave(static_plot)
ggsave(filename = "C:/Desktop/R viz/visualisation_1.png", plot = static_plot, width = 15, height = 8 )




#INTERACTIVE PLOT
#PLOT 1
time_series <- data %>%
  arrange(start.year) %>%
  group_by(start.year) %>%
  summarize(Num_Channels = n())

time_series_plot <- ggplot(time_series, aes(x = start.year, y = Num_Channels)) +
  geom_line(color = viridis(1)) +
  geom_point(color = viridis(1), size =2) +
  labs(title = "YouTube channels created and subscribers gained from 2005-2021",
       y = "Number of Channels") +
  theme_minimal() +
  theme(
    panel.grid = element_blank(),
    axis.title.y = element_text(size = 14),
    axis.title.x = element_blank(),
    axis.line = element_line(colour = "black"))+
  scale_x_continuous(breaks = seq(min(time_series$start.year), max(time_series$start.year), by = 1)) +
  theme(axis.text.x = element_text(size = 15),
        axis.text.y = element_text(size = 15))


# Convert ggplot to plotly
time_series_plotly <- ggplotly(time_series_plot)
print(time_series_plotly)



#PLOT 2
interactive <- ggplot(data, aes(x = start.year, y = Subscribers, text = paste("Channel: ", Channel_Name, "<br>Country: ", Country, "<br>Video Views: ", format(video.views, big.mark = ",")))) +
  geom_point(aes(color = start.year), size = 2, alpha = 0.7) +
  scale_color_viridis_c(name = "YouTube Channel Start Year") +  # Using viridis color palette
  labs(x = "YouTube Channel Start Year",
       y = "Subscribers") +
  theme_minimal() +
  theme(
    axis.text.x = element_text(size = 12, angle = 0, vjust = 0.5, hjust = 1),
    axis.text.y = element_text(size = 12),  # Adjust y-axis label font size
    axis.title.y = element_text(size = 14),
    axis.title.x = element_text(size = 14)# Adjust y-axis title font size
  ) +
  scale_x_continuous(breaks = seq(min(data$start.year), max(data$start.year), by = 1)) +
  scale_y_continuous(labels = scales::comma_format(scale = 1e-6, suffix = "M"))  # Convert to million

# Convert ggplot to plotly
interactive_plotly <- ggplotly(interactive)
print(interactive_plotly)


#Merge both the plots using Subplot
interactive_subplot <- list(
  time_series_plotly %>% layout(xaxis = list(tickfont = list(size = 14)),
                                        yaxis = list(tickfont = list(size = 14))),
  interactive_plotly %>% layout(xaxis = list(tickfont = list(size = 14)),
                                yaxis = list(tickfont = list(size = 14)))
)

# Print the subplot
interactive_plot <- subplot(interactive_subplot, nrows = 2, shareY= TRUE, titleX=TRUE)
print(interactive_plot)

#Export HTML
htmlwidgets::saveWidget(interactive_plot, "C:/Desktop/R viz/visualization_2.html")


