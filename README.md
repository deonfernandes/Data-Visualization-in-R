# YouTube Data Visualization Project

This project involves analyzing and visualizing YouTube data to uncover insights about channel growth, content trends, and viewership patterns. The project combines static and interactive plots to deliver actionable insights for content creators, marketers, and analysts.

## Overview

The project utilizes two datasets that provide information about the top 1000 YouTube channels. Key aspects include:
- **Static Visualizations**: Analysis of video views and uploads by category.
- **Interactive Visualizations**: Trends in channel creation and subscriber growth over time.
- **Data Processing**: Cleaning and merging datasets to enhance analysis accuracy.

## Features

1. **Static Visualization**:
   - Bar plot showcasing total video views per category.
   - Bar plot highlighting the total video uploads for each category.
   - Insights into category popularity and content efficiency.

2. **Interactive Visualization**:
   - Time series plot of YouTube channels created annually from 2005–2021.
   - Scatter plot showing subscriber count trends by channel start year, with tooltips providing additional channel details.
   - Subplot combining time series and scatter plot for comparative analysis.

3. **Data Processing**:
   - Handling missing values and outliers.
   - Converting character columns to numeric for accurate calculations.
   - Saving processed data as a CSV for reproducibility.

## Datasets

1. **Most Subscribed YouTube Channels**  
   [Dataset Link](https://www.kaggle.com/datasets/surajjha101/top-youtube-channels-data)

2. **Global YouTube Statistics 2023**  
   [Dataset Link](https://www.kaggle.com/datasets/nelgiriyewithana/global-youtube-statistics-2023)

## Tools and Technologies

- **Programming Language**: R
- **Libraries**:
  - `ggplot2` for static plots.
  - `dplyr` and `tidyr` for data manipulation.
  - `plotly` for interactive visualizations.
  - `RColorBrewer` and `viridis` for color palettes.
  - `visdat` for missing data visualization.
  - `htmlwidgets` for exporting interactive plots.
- **Data Sources**: Open-source datasets from Kaggle.


Results
Static Plots: Bar charts provide insights into the most viewed and uploaded content categories.
Interactive Plots: Allow dynamic exploration of channel growth trends and subscriber counts.

Exported Outputs:
PNG file for static plots.
HTML file for interactive visualizations.

Insights
Music, Entertainment, and Comedy are the most popular content categories.
Despite fewer uploads, the Music category garners the highest number of views.
Channel creation peaked in 2014, with a steady decline afterward.
