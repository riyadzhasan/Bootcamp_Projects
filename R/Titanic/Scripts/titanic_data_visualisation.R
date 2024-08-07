#installs and loads tidyverse (contains ggplot2) and plotly
install.packages("tidyverse")
install.packages("plotly")
library(tidyverse)
library(plotly)

#writes dataset onto dataframe
titanic_data <- read.csv("Cleaned_Titanic_Data.csv")

#Plot of survived
survived_bar <- ggplot(titanic_data, aes(x = as.factor(survived))) +
  geom_bar(aes(fill=sex)) + 
  scale_fill_brewer(palette = "Pastel1") +
  scale_x_discrete(labels = c('Died','Survived')) +
  labs(title="Count of Survived Passengers",
       subtitle="From Titanic Dataset",
       x="Survival Status",y="Total") +
  theme_bw()+
  theme(axis.title.x=element_blank(),
        #axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        axis.title.y=element_blank()
  )
plot(survived_bar)

#age histogram/density
age_hist <- ggplot(titanic_data, aes(x = age)) +
  geom_histogram(binwidth = 5, fill = "firebrick", color = "black") +
  #geom_density(fill="firebrick", color="black", alpha=0.8) +
  labs(title="Age Distribution of Passengers",
       subtitle="from Titanic Dataset",
       x="Age Distribution",
       y="Density"
  )
plot(age_hist)

#age vs survived boxplot/violin
box <- ggplot(titanic_data, aes(x = as.factor(survived), y = age)) +
  geom_boxplot() +
  geom_jitter(color="black", size=0.4, alpha=0.9) +
  scale_x_discrete(labels = c('Died','Survived')) +
  labs(title="Age Distribution by Survival Status",
       y="Age",
       x="Survived"
  )
plot(box)
violin <- ggplot(titanic_data, aes(x = as.factor(survived), y = age, fill=as.factor(pclass))) +
  geom_violin() +
  geom_jitter(color="black", size=0.4, alpha=0.9) +
  scale_fill_brewer(palette = "Pastel1") +
  scale_x_discrete(labels = c('Died','Survived')) +
  labs(title="Age Distribution by Survival Status",
       y="Age",
       x="Survived"
  )
plot(violin)

#bar of count of passngers from class, separated by gender
bar_class <- ggplot(titanic_data, aes(x = as.factor(pclass), fill=sex)) +
  geom_bar(width=0.5) +
  scale_fill_brewer(palette = "Pastel2") +
  geom_text(aes(label = after_stat(count)), stat = "count", colour = "black")+
  labs(title="Count of Passengers by Class",
       y="Total",
       x="Passenger Class"
  ) +
  coord_flip()
plot(bar_class)

#bar of count of passngers by embarked, separated by gender
bar_emb <- ggplot(titanic_data, aes(x = as.factor(embarked), fill=as.factor(embarked))) +
  geom_bar(width=0.5, show.legend = FALSE) +
  geom_text(aes(label = after_stat(count)), stat = "count", vjust=1.5, colour = "white")+
  labs(title="Count of Passengers by Embarkation Point",
       y="Count",
       x="Embarkation point"
  )
plot(bar_emb)

#scatter age vs fare
ggplot(titanic_data, aes(x = age, y = fare, color=sex)) +
  geom_point(size=1) +
  scale_color_brewer(palette="Accent")
  labs(title="Age vs. Fare by Sex",
     y="Fare",
     x="Age"
  )

#facet grid of age vs fare by pclass
ggplotly(
  ggplot(titanic_data, aes(x = age, y = fare, color=as.factor(survived))) +
  scale_color_brewer(palette = "Pastel1")+
  geom_point(size=1) +
  facet_wrap( ~ pclass) +
  labs(title="Age vs. Fare by Survival Status",
       subtitle="1st Class Survives more",
       y="Fare",
       x="Age"
  )+
  theme_bw()
)


# Stacked Bar Plot of Survival by Passenger Class
ggplotly(
  ggplot(titanic_data, aes(x = pclass, fill = as.factor(survived))) +
  geom_bar(position = "fill") +
  scale_fill_manual(values=c("#E69F00", "#56B4E9"))+
  labs(title="Survival Proportions by Passenger Class",
       x="Passenger Class",
       y="Proportion",
       fill = "Survived"
  )+
  theme_bw()
)

# clustered bar chart of count of passengers embarkation and whether they died or survived
ggplotly(
  ggplot(titanic_data, aes(x = embarked, fill = as.factor(survived)))+
    geom_bar(position="dodge") +
    labs(title="Survival Counts by Embarkation Point",
         x="Embarkation",
         y="Count",
         fill = "Survived",
    )+
    #scale_fill_brewer(labels=c("no","yes"))
    scale_fill_manual(values = c("0" = "red", "1" = "green"), labels = c("0" = "No", "1" = "Yes"))
)

#age vs fare by survival status with embarkation point faceted
ggplot(titanic_data, aes(x = age, y = fare, color = as.factor(survived))) +
  geom_point(size = 0.5) +
  scale_color_manual(values = c("0" = "red", "1" = "green"), labels = c("0" = "No", "1" = "Yes")) +
  facet_wrap(survived ~ embarked) +
  labs(title="Age vs. Fare by Survival Status and Embarked",
       x="Age",
       y="Fare",
       color = "Survived"
  )

#---
# Calculate counts and percentages for interactive plot
titanic_summary <- titanic_data %>%
  group_by(pclass, survived) %>%
  summarise(count = n()) %>%
  mutate(percentage = count / sum(count) * 100)

# Convert to data frame
titanic_summary <- as.data.frame(titanic_summary)

# Create the interactive stacked bar plot
plot <- plot_ly(titanic_summary, 
                x = ~pclass, 
                y = ~percentage, 
                type = 'bar', 
                color = ~as.factor(survived),
                text = ~paste('Survived:', survived, '<br>Percentage:', round(percentage, 2), '%'),
                hoverinfo = 'text',
                textposition = 'auto') %>%
  layout(barmode = 'stack',
         xaxis = list(title = 'Passenger Class'),
         yaxis = list(title = 'Percentage'),
         title = 'Survival Proportions by Passenger Class',
         legend = list(title = list(text = 'Survived')))
plot

## Filter the dataframe for passengers who embarked at Southampton
#southampton_data <- titanic_data %>%
#  filter(embarked == "s")